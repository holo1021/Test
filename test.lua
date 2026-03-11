--[[ Holon VM v5 Secure ]]
local _qnsfr = {237,50,51,50,31,51,48,50,106,50,48,51,237,48,51,50,31,49,49,50,106,48,48,51,211,50,51,50}
local _nujxv = {{66,48,89,55,67},{122,21,121,22,120,88,14,67,99,55,82,33,85,111,79,167,18,165,64,203,94,184,48,160,69,207,80},{214,109,195,37,166,21,246,117,235,8,138,61,222,93,238,10,178,56,219,90,253,24,182,41,193,96,236,15,142,27,248,122,246,21,148,50,209,80,212,55,182,8,235,106,243,221,243,221}}
local _yxinf = {}
local _mlpbu = 50
local function _ovcrj(...)
    local _bvkbg, _igysp = {}, getfenv() or _G
    local _auqcn = {} -- Call Stack: {cl, pc, base, ret_reg}

    -- Helper to decode constants for a prototype, with caching
    local _tqchk = setmetatable({}, {__mode = "k"})
    local function _nvqiv(p)
        if _tqchk[p] then return _tqchk[p] end
        local dc = {}
        for i, v in ipairs(p.c) do
            local s = ""
            local last_byte = _mlpbu
            for j = 1, #v do
                local enc_byte = v[j]
                local dec_byte = bit32.bxor(enc_byte, last_byte)
                s = s .. string.char(dec_byte)
                last_byte = enc_byte
            end
            dc[i] = s
        end
        _tqchk[p] = dc
        return dc
    end

    -- Main closure setup
    local _CL = { p = { b = _qnsfr, c = _nujxv, p = _yxinf, np = 0 } }
    table.insert(_auqcn, { cl = _CL, pc = 1, base = 1, rr = 1 })

    -- VM命令ハンドラテーブル
    local _ndqjj = {
        [45] = function(_I, _bvkbg, _BASE) _bvkbg[_BASE + _I[2]] = _bvkbg[_BASE + _I[3]] end,
        [31] = function(_I, _bvkbg, _BASE, _DC) _bvkbg[_BASE + _I[2]] = _DC[_I[3]] end,
        [237] = function(_I, _bvkbg, _BASE, _DC, _igysp) _bvkbg[_BASE + _I[2]] = _igysp[_DC[_I[3]]] end,
        [212] = function(_I, _bvkbg, _BASE, _DC, _igysp) _igysp[_DC[_I[3]]] = _bvkbg[_BASE + _I[2]] end,
        [235] = function(_I, _bvkbg, _BASE, _DC, _igysp, _CL) _bvkbg[_BASE + _I[2]] = { p = _CL.p.p[_I[3]], uv = {} } end,
        [106] = function(_I, _bvkbg, _BASE, _DC, _igysp, _CL, _auqcn)
            local func_reg, n_args, n_ret = _I[2], _I[3] - 1, _I[4] - 1
            local func = _bvkbg[_BASE + func_reg]
            if func then
                if type(func) == "function" then
                    local args = {}
                    for i = 1, n_args do table.insert(args, _bvkbg[_BASE + func_reg + i]) end
                    local results = {pcall(func, unpack(args))}
                    for i = 1, n_ret do _bvkbg[_BASE + func_reg + i - 1] = results[i+1] end
                else
                    table.insert(_auqcn, { cl = func, pc = 1, base = _BASE + func_reg, rr = _BASE + func_reg })
                end
            end
        end,
        [211] = function(_I, _bvkbg, _BASE, _DC, _igysp, _CL, _auqcn, frame)
            local ret_start, n_ret = _I[2], _I[3] - 1
            if #_auqcn > 1 then -- 呼び出し元がある場合のみ戻り値を設定
                for i = 1, n_ret do _bvkbg[frame.rr + i - 1] = _bvkbg[_BASE + ret_start + i - 1] end
            end
            table.remove(_auqcn)
        end,
        [11] = function(_I, _bvkbg, _BASE, _DC, _igysp, _CL, _auqcn, frame, _P, _eobyt) frame.pc = _P + _I[4] * _eobyt end,
        [210] = function(_I, _bvkbg, _BASE, _DC, _igysp, _CL, _auqcn, frame, _P, _eobyt) if not _bvkbg[_BASE + _I[2]] then frame.pc = _P + _I[4] * _eobyt end end,
        [189] = function(_I, _bvkbg, _BASE) _bvkbg[_BASE + _I[2]] = _bvkbg[_BASE + _I[3]] == _bvkbg[_BASE + _I[4]] end,
        [176] = function(_I, _bvkbg, _BASE) _bvkbg[_BASE + _I[2]] = _bvkbg[_BASE + _I[3]] + _bvkbg[_BASE + _I[4]] end,
        [254] = function(_I, _bvkbg, _BASE) _bvkbg[_BASE + _I[2]] = _bvkbg[_BASE + _I[3]] - _bvkbg[_BASE + _I[4]] end,
        [253] = function(_I, _bvkbg, _BASE) _bvkbg[_BASE + _I[2]] = _bvkbg[_BASE + _I[3]] * _bvkbg[_BASE + _I[4]] end,
        [125] = function(_I, _bvkbg, _BASE) _bvkbg[_BASE + _I[2]] = _bvkbg[_BASE + _I[3]] / _bvkbg[_BASE + _I[4]] end,
        [14] = function() end -- 何もしない
    }

    local _eobyt = 4 -- Instruction Width

    while #_auqcn > 0 do
        local frame = _auqcn[#_auqcn]
        local _CL, _P, _BASE = frame.cl, frame.pc, frame.base
        if not _CL then table.remove(_auqcn); goto continue_loop end -- 安全策: 不正なコールスタックを削除
        local _BC = _CL.p.b
        local _DC = _nvqiv(_CL.p)

        if _P <= #_BC then
            local _O = _BC[_P]
            frame.pc = _P + _eobyt
            local handler = _ndqjj[_O]
            if handler then
                local _I = { _O, bit32.bxor(_BC[_P+1], _mlpbu), bit32.bxor(_BC[_P+2], _mlpbu), bit32.bxor(_BC[_P+3], _mlpbu) }
                handler(_I, _bvkbg, _BASE, _DC, _igysp, _CL, _auqcn, frame, _P, _eobyt)
            end
        else
            table.remove(_auqcn) -- バイトコードの終端に達したら暗黙的にリターン
        end

        ::continue_loop::
    end
end
_ovcrj(...)
