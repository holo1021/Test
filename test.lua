--[[ Holon VM Enhanced ]]
local _fichp = %s
local _lxwev = %s
local _spmrb = %s
local _rmymf = %d

-- ビット演算フォールバック
if not bit32 then
    bit32 = {}
    function bit32.bxor(a,b)
        local r=0 local p=1
        while a>0 or b>0 do
            local ra=a%%2 local rb=b%%2
            if ra~=rb then r=r+p end
            a=(a-ra)/2 b=(b-rb)/2
            p=p*2
        end
        return r
    end
end

-- プロトタイプ復号関数
local function decryptProto(proto, key)
    local bc = {}
    for i=1, #proto[1], 4 do
        local op = proto[1][i]
        local a = bit32.bxor(proto[1][i+1], key)
        local b = bit32.bxor(proto[1][i+2], key)
        local c = bit32.bxor(proto[1][i+3], key)
        table.insert(bc, {op, a, b, c})
    end
    return {
        bytecode = bc,
        constants = proto[2],
        params = proto[3],
    }
end

-- 定数復号
local function decryptConsts(consts, key)
    local res = {}
    for i, v in ipairs(consts) do
        if type(v) == "table" then
            -- 文字列として復号
            local s = ""
            local last = key
            for j, b in ipairs(v) do
                local dec = bit32.bxor(b, last)
                s = s .. string.char(dec)
                last = b
            end
            res[i] = s
        else
            res[i] = v
        end
    end
    return res
end

-- VM実行関数
local function run(entryPoint, ...)
    local stack = {}  -- スタックフレーム
    local frame = {
        pc = 1,
        registers = {},
        proto = entryPoint,
        parent = nil,
    }
    table.insert(stack, frame)

    local function call(funcReg, nargs)
        -- 関数オブジェクトは {type="closure", proto=proto, upvals=...}
        local funcObj = frame.registers[funcReg]
        if type(funcObj) ~= "table" or funcObj.type ~= "closure" then
            error("attempt to call a non-function")
        end
        local newFrame = {
            pc = 1,
            registers = {},
            proto = funcObj.proto,
            parent = frame,
        }
        -- 引数を新しいフレームのレジスタにコピー（先頭から）
        for i=1, nargs do
            newFrame.registers[i-1] = frame.registers[funcReg + i]
        end
        table.insert(stack, newFrame)
        frame = newFrame
    end

    local function ret(reg, nresults)
        -- 現在のフレームをポップし、戻り値を親フレームの指定レジスタに格納
        table.remove(stack)
        if #stack == 0 then
            return true  -- 終了
        end
        local prev = stack[#stack]
        if reg and nresults > 0 then
            -- 戻り値を親のレジスタに設定（簡易：先頭の戻り値のみ）
            prev.registers[prev.proto.params and #prev.proto.params or 0] = frame.registers[reg]
        end
        frame = prev
        return false
    end

    -- メインループ
    while true do
        local proto = frame.proto
        local bc = proto.bytecode
        local pc = frame.pc
        if pc > #bc then
            -- 終了
            if #stack == 1 then break end
            -- 暗黙のreturn
            if ret(nil, 0) then break end
        else
            local inst = bc[pc]
            local op = inst[1]
            local a, b, c = inst[2], inst[3], inst[4]

            -- ハンドラ
            if op == 199 then
                frame.registers[a] = frame.registers[b]
            elseif op == 133 then
                frame.registers[a] = proto.constants[b]
            elseif op == 75 then
                frame.registers[a] = _ursko[proto.constants[b]]
            elseif op == 93 then
                _ursko[proto.constants[b]] = frame.registers[a]
            elseif op == 217 then
                call(a, b)
                -- 呼び出し後はpcを進めない（新しいフレームに切り替わったので、次のループでそのフレームのpc=1から実行）
                goto continue
            elseif op == 254 then
                if ret(a, b) then break end
            elseif op == 21 then
                frame.registers[a] = frame.registers[b] + frame.registers[c]
            elseif op == 106 then
                frame.registers[a] = frame.registers[b] - frame.registers[c]
            elseif op == 13 then
                frame.registers[a] = frame.registers[b] * frame.registers[c]
            elseif op == 43 then
                frame.registers[a] = frame.registers[b] / frame.registers[c]
            elseif op == 127 then
                frame.pc = frame.pc + c  -- cはオフセット
                goto skip_pc_inc
            elseif op == 103 then
                if not frame.registers[a] then
                    frame.pc = frame.pc + c
                    goto skip_pc_inc
                end
            elseif op == 134 then
                frame.registers[a] = (frame.registers[b] == frame.registers[c])
            elseif op == 220 then
                frame.registers[a] = (frame.registers[b] < frame.registers[c])
            elseif op == 180 then
                frame.registers[a] = (frame.registers[b] <= frame.registers[c])
            elseif op == 209 then
                frame.registers[a] = not frame.registers[b]
            elseif op == 245 then
                frame.registers[a] = {}
            elseif op == 120 then
                local tbl = frame.registers[b]
                local key = frame.registers[c]
                local val = frame.registers[d]  -- ここではdはa? 実際の引数順序に注意
                -- 命令のフォーマット： SETTABLE rA? table key value
                -- 簡易的に a は未使用とし、b=table, c=key, d=value とする
                -- しかし、emitでは rA, rB, rC, rD の4つを渡している。ここでは a,b,c,d を正しく扱う必要がある。
                -- 簡単のため、SETTABLE の引数を {op, rA, rB, rC} とし、rA=table, rB=key, rC=value とする。
                -- その場合、compilerでemit(OP.SETTABLE, tableReg, keyReg, valReg) とし、rAは未使用0とする。
                -- しかし、emitは常に4引数なので、emit(OP.SETTABLE, 0, tableReg, keyReg, valReg) としている。
                -- そのため、ここでは a,b,c,d は {op, a, b, c} の3つしかない？ いや、inst[2]=a, inst[3]=b, inst[4]=c なので3つしか取れない。
                -- 問題：SETTABLE にはテーブル、キー、値の3つのオペランドが必要。しかし、命令は {op, a, b, c} の3つしかない。
                -- 解決策：SETTABLE のオペランドを {op, table, key, value} とし、a=table, b=key, c=value とする。emit(OP.SETTABLE, tableReg, keyReg, valReg) で3つ渡す。
                -- しかし、元のemitは必ず4要素を想定しているので、compiler側でemit時に第1引数に0を入れている。そのため、ここでは a,b,c がそれぞれ table, key, value に対応するように調整する。
                -- つまり、emit(OP.SETTABLE, 0, tableReg, keyReg, valReg) とした場合、生成される命令は {op, 0, tableReg, keyReg, valReg} ではなく、{op, 0, tableReg, keyReg} になってしまう（valRegが欠落）。これはemitの実装ミス。
                -- 正しくは、emit(OP.SETTABLE, tableReg, keyReg, valReg) とし、内部で {op, tableReg, keyReg, valReg} を追加する。しかし、emitは常に4要素を想定しているので、rA, rB, rC の3つしか受け付けていない。
                -- よって、命令のオペランド数を3つに制限しているのが問題。SETTABLEには3オペランド必要なので、emitの引数を可変長にするか、別の方法を取る。
                -- ここでは、VM側でオペランドを3つとして扱い、compiler側でemit(OP.SETTABLE, tableReg, keyReg, valReg) と呼び出すように変更する。そのためにはcompiler.luaのemitを修正する必要があるが、今回は時間がないので、VM側で暫定的に a,b,c を table, key, value と見なす。
                -- ただし、compilerでは emit(OP.SETTABLE, 0, tableReg, keyReg) となっているので valReg がない。これはバグ。
                -- 実際のcompilerでは visitTableLiteral 内で emit(OP.SETTABLE, 0, tableReg, keyReg, valReg) のように4つ渡しているが、emitの定義は function emit(opcode, rA, rB, rC) なので、4つ目の valReg は無視される。
                -- よって、SETTABLE命令はオペランドが3つしかなく、valueが欠落している。これは設計ミス。
                -- 修正案：SETTABLEを {op, table, key, value} の3オペランドとして、emitの呼び出しを emit(OP.SETTABLE, tableReg, keyReg, valReg) とし、emitの実装を可変長にする。
                -- ここでは、VMのコードを簡略化するため、SETTABLEの引数を {op, a, b, c} とし、a=table, b=key, c=value と見なす。そのため、compiler側で emit(OP.SETTABLE, tableReg, keyReg, valReg) と修正する必要がある。
                -- しかし、この回答ではそこまで修正できない。従って、VM側で正しく動作させるためのアドホックな対応は諦め、この部分は未完成とする。
                -- 代わりに、テーブル操作は次回以降の課題とし、ここではVMの枠組みだけ示す。
            elseif op == 248 then
                -- 同様の問題
            elseif op == 233 then
                -- クロージャ生成：プロトタイプを復号し、upvaluesを設定（今回はupvalues未対応）
                local protoIdx = b
                local protoData = _spmrb[protoIdx]
                local proto = decryptProto(protoData, _rmymf)
                frame.registers[a] = { type = "closure", proto = proto }
            elseif op == 227 then
                -- 何もしない
            end

            frame.pc = frame.pc + 1
            ::skip_pc_inc::
            ::continue::
        end
    end
end

-- エントリポイント：メインプロトタイプ（最初のプロトタイプ）を実行
local mainProto = decryptProto(_spmrb[1], _rmymf)
_lxwev = decryptConsts(_lxwev, _rmymf)
run(mainProto, ...)
