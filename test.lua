--[[ Holon VM v5 Secure ]]
local _rkcob = {35,60,61,60,119,61,62,60,232,60,62,61,35,62,61,60,119,63,63,60,232,62,62,61,167,60,61,60}
local _jpxri = {{76,62,87,57,77},{116,27,119,24,118,86,0,77,109,57,92,47,91,97,65,169,28,171,78,197,80,182,62,174,75,193,94},{216,99,205,43,168,27,248,123,229,6,132,51,208,83,224,4,188,54,213,84,243,22,184,39,207,110,226,1,128,21,246,116,248,27,154,60,223,94,218,57,184,6,229,100,253,211,253,211}}
local _nrgpg = {}
local _wdzuc = 60
local function _nwmod(...)
    local _ddxsj, _khgep = {}, getfenv() or _G
    local _cvttg = {} -- Call Stack: {cl, pc, base, ret_reg}

    -- Helper to decode constants for a prototype, with caching
    local _jvfte = setmetatable({}, {__mode = "k"})
    local function _hsfvx(p)
        if _jvfte[p] then return _jvfte[p] end
        local dc = {}
        for i, v in ipairs(p.c) do
            local s = ""
            local last_byte = _wdzuc
            for j = 1, #v do
                local enc_byte = v[j]
                local dec_byte = bit32.bxor(enc_byte, last_byte)
                s = s .. string.char(dec_byte)
                last_byte = enc_byte
            end
            dc[i] = s
        end
        _jvfte[p] = dc
        return dc
    end

    -- Main closure setup
    local _CL = { p = { b = _rkcob, c = _jpxri, p = _nrgpg, np = 0 } }
    table.insert(_cvttg, { cl = _CL, pc = 1, base = 1, rr = 1 })

    -- VM命令ハンドラテーブル
    local _ejuhs = {
        [209] = function(_I, _ddxsj, _BASE) _ddxsj[_BASE + _I[2]] = _ddxsj[_BASE + _I[3]] end,
        [119] = function(_I, _ddxsj, _BASE, _DC) _ddxsj[_BASE + _I[2]] = _DC[_I[3]] end,
        [35] = function(_I, _ddxsj, _BASE, _DC, _khgep) _ddxsj[_BASE + _I[2]] = _khgep[_DC[_I[3]]] end,
        [22] = function(_I, _ddxsj, _BASE, _DC, _khgep) _khgep[_DC[_I[3]]] = _ddxsj[_BASE + _I[2]] end,
        [69] = function(_I, _ddxsj, _BASE, _DC, _khgep, _CL) _ddxsj[_BASE + _I[2]] = { p = _CL.p.p[_I[3]], uv = {} } end,
        [232] = function(_I, _ddxsj, _BASE, _DC, _khgep, _CL, _cvttg)
            local func_reg, n_args, n_ret = _I[2], _I[3] - 1, _I[4] - 1
            local func = _ddxsj[_BASE + func_reg]

            if not func then
                error("VM Error: Attempt to call a nil value at register " .. func_reg)
            elseif type(func) == "function" then
                local args = {}
                for i = 1, n_args do table.insert(args, _ddxsj[_BASE + func_reg + i]) end
                local results = {pcall(func, unpack(args))}
                for i = 1, n_ret do _ddxsj[_BASE + func_reg + i - 1] = results[i+1] end
            elseif type(func) == "table" and func.p then -- Holon Closure
                table.insert(_cvttg, { cl = func, pc = 1, base = _BASE + func_reg, rr = _BASE + func_reg })
            else
                error("VM Error: Attempt to call a non-function/non-closure value (type: " .. type(func) .. ") at register " .. func_reg)
            end
        end,

        [167] = function(_I, _ddxsj, _BASE, _DC, _khgep, _CL, _cvttg, frame)
            local ret_start, n_ret = _I[2], _I[3] - 1
            if #_cvttg > 1 then -- 呼び出し元がある場合のみ戻り値を設定
                for i = 1, n_ret do _ddxsj[frame.rr + i - 1] = _ddxsj[_BASE + ret_start + i - 1] end
            end
            table.remove(_cvttg)
        end,
        [155] = function(_I, _ddxsj, _BASE, _DC, _khgep, _CL, _cvttg, frame, _P, _qmzdr) frame.pc = _P + _I[4] * _qmzdr end,
        [120] = function(_I, _ddxsj, _BASE, _DC, _khgep, _CL, _cvttg, frame, _P, _qmzdr) if not _ddxsj[_BASE + _I[2]] then frame.pc = _P + _I[4] * _qmzdr end end,
        [128] = function(_I, _ddxsj, _BASE) _ddxsj[_BASE + _I[2]] = _ddxsj[_BASE + _I[3]] == _ddxsj[_BASE + _I[4]] end,
        [173] = function(_I, _ddxsj, _BASE) _ddxsj[_BASE + _I[2]] = _ddxsj[_BASE + _I[3]] + _ddxsj[_BASE + _I[4]] end,
        [177] = function(_I, _ddxsj, _BASE) _ddxsj[_BASE + _I[2]] = _ddxsj[_BASE + _I[3]] - _ddxsj[_BASE + _I[4]] end,
        [182] = function(_I, _ddxsj, _BASE) _ddxsj[_BASE + _I[2]] = _ddxsj[_BASE + _I[3]] * _ddxsj[_BASE + _I[4]] end,
        [153] = function(_I, _ddxsj, _BASE) _ddxsj[_BASE + _I[2]] = _ddxsj[_BASE + _I[3]] / _ddxsj[_BASE + _I[4]] end,
        [250] = function() end -- 何もしない
    }

    local _qmzdr = 4 -- Instruction Width

    while #_cvttg > 0 do
        local frame = _cvttg[#_cvttg]
        local _CL, _P, _BASE = frame.cl, frame.pc, frame.base
        if not _CL then table.remove(_cvttg); goto continue_loop end -- 安全策: 不正なコールスタックを削除
        local _BC = _CL.p.b
        local _DC = _hsfvx(_CL.p)

        if _P <= #_BC then
            local _O = _BC[_P]
            frame.pc = _P + _qmzdr
            local handler = _ejuhs[_O]
            if handler then
                local _I = { _O, bit32.bxor(_BC[_P+1], _wdzuc), bit32.bxor(_BC[_P+2], _wdzuc), bit32.bxor(_BC[_P+3], _wdzuc) }
                handler(_I, _ddxsj, _BASE, _DC, _khgep, _CL, _cvttg, frame, _P, _qmzdr)
            end
        else
            table.remove(_cvttg) -- バイトコードの終端に達したら暗黙的にリターン
        end

        ::continue_loop::
    end
end
_nwmod(...)
