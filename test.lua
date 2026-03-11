--[[ Holon VM v5 Secure ]]
local _iepdt = {63,84,85,84,83,85,86,84,204,84,86,85,63,86,85,84,83,87,87,84,204,86,86,85,243,84,85,84}
local _vsjjy = {{36,86,63,81,37},{28,115,31,112,30,62,104,37,5,81,52,71,51,9,41,193,116,195,38,173,56,222,86,198,35,169,54},{176,11,165,67,192,115,144,19,141,110,236,91,184,59,136,108,212,94,189,60,155,126,208,79,167,6,138,105,232,125,158,28,144,115,242,84,183,54,178,81,208,110,141,12,149,187,149,187}}
local _vcbxx = {}
local _urekd = 84
local function _ublpc(...)
    local _ixnjy, _xasqo = {}, getfenv() or _G
    local _lvjel = {} -- Call Stack: {cl, pc, base, ret_reg}

    -- Helper to decode constants for a prototype, with caching
    local _ydopc = setmetatable({}, {__mode = "k"})
    local function _ayoyn(p)
        if _ydopc[p] then return _ydopc[p] end
        local dc = {}
        for i, v in ipairs(p.c) do
            local s = ""
            local last_byte = _urekd
            for j = 1, #v do
                local enc_byte = v[j]
                local dec_byte = bit32.bxor(enc_byte, last_byte)
                s = s .. string.char(dec_byte)
                last_byte = enc_byte
            end
            dc[i] = s
        end
        _ydopc[p] = dc
        return dc
    end

    -- Main closure setup
    local _CL = { p = { b = _iepdt, c = _vsjjy, p = _vcbxx, np = 0 } }
    table.insert(_lvjel, { cl = _CL, pc = 1, base = 1, rr = 1 })

    -- VM命令ハンドラテーブル
    local _iqnvm = {
        [88] = function(_I, _ixnjy, _BASE) _ixnjy[_BASE + _I[2]] = _ixnjy[_BASE + _I[3]] end,
        [83] = function(_I, _ixnjy, _BASE, _DC) _ixnjy[_BASE + _I[2]] = _DC[_I[3]] end,
        [63] = function(_I, _ixnjy, _BASE, _DC, _xasqo) _ixnjy[_BASE + _I[2]] = _xasqo[_DC[_I[3]]] end,
        [159] = function(_I, _ixnjy, _BASE, _DC, _xasqo) _xasqo[_DC[_I[3]]] = _ixnjy[_BASE + _I[2]] end,
        [94] = function(_I, _ixnjy, _BASE, _DC, _xasqo, _CL) _ixnjy[_BASE + _I[2]] = { p = _CL.p.p[_I[3]], uv = {} } end,
        [204] = function(_I, _ixnjy, _BASE, _DC, _xasqo, _CL, _lvjel)
            local func_reg, n_args, n_ret = _I[2], _I[3] - 1, _I[4] - 1
            local func = _ixnjy[_BASE + func_reg]

            if not func then
                error("VM Error: Attempt to call a nil value at register " .. func_reg)
            elseif type(func) == "function" then
                local args = {}
                for i = 1, n_args do table.insert(args, _ixnjy[_BASE + func_reg + i]) end
                local results = {pcall(func, unpack(args))}
                for i = 1, n_ret do _ixnjy[_BASE + func_reg + i - 1] = results[i+1] end
            elseif type(func) == "table" and func.p then -- Holon Closure
                table.insert(_lvjel, { cl = func, pc = 1, base = _BASE + func_reg, rr = _BASE + func_reg })
            else
                error("VM Error: Attempt to call a non-function/non-closure value (type: " .. type(func) .. ") at register " .. func_reg)
            end
        end,

        [243] = function(_I, _ixnjy, _BASE, _DC, _xasqo, _CL, _lvjel, frame)
            local ret_start, n_ret = _I[2], _I[3] - 1
            if #_lvjel > 1 then -- 呼び出し元がある場合のみ戻り値を設定
                for i = 1, n_ret do _ixnjy[frame.rr + i - 1] = _ixnjy[_BASE + ret_start + i - 1] end
            end
            table.remove(_lvjel)
        end,
        [149] = function(_I, _ixnjy, _BASE, _DC, _xasqo, _CL, _lvjel, frame, _P, _mbrvt) frame.pc = _P + _I[4] * _mbrvt end,
        [42] = function(_I, _ixnjy, _BASE, _DC, _xasqo, _CL, _lvjel, frame, _P, _mbrvt) if not _ixnjy[_BASE + _I[2]] then frame.pc = _P + _I[4] * _mbrvt end end,
        [168] = function(_I, _ixnjy, _BASE) _ixnjy[_BASE + _I[2]] = _ixnjy[_BASE + _I[3]] == _ixnjy[_BASE + _I[4]] end,
        [136] = function(_I, _ixnjy, _BASE) _ixnjy[_BASE + _I[2]] = _ixnjy[_BASE + _I[3]] + _ixnjy[_BASE + _I[4]] end,
        [58] = function(_I, _ixnjy, _BASE) _ixnjy[_BASE + _I[2]] = _ixnjy[_BASE + _I[3]] - _ixnjy[_BASE + _I[4]] end,
        [64] = function(_I, _ixnjy, _BASE) _ixnjy[_BASE + _I[2]] = _ixnjy[_BASE + _I[3]] * _ixnjy[_BASE + _I[4]] end,
        [95] = function(_I, _ixnjy, _BASE) _ixnjy[_BASE + _I[2]] = _ixnjy[_BASE + _I[3]] / _ixnjy[_BASE + _I[4]] end,
        [161] = function() end -- 何もしない
    }

    local _mbrvt = 4 -- Instruction Width

    while #_lvjel > 0 do
        local frame = _lvjel[#_lvjel]
        local _CL, _P, _BASE = frame.cl, frame.pc, frame.base
        if not _CL then table.remove(_lvjel); goto continue_loop end -- 安全策: 不正なコールスタックを削除
        local _BC = _CL.p.b
        local _DC = _ayoyn(_CL.p)

        if _P <= #_BC then
            local _O = _BC[_P]
            frame.pc = _P + _mbrvt
            local handler = _iqnvm[_O]
            if handler then
                local _I = { _O, bit32.bxor(_BC[_P+1], _urekd), bit32.bxor(_BC[_P+2], _urekd), bit32.bxor(_BC[_P+3], _urekd) }
                handler(_I, _ixnjy, _BASE, _DC, _xasqo, _CL, _lvjel, frame, _P, _mbrvt)
            end
        else
            table.remove(_lvjel) -- バイトコードの終端に達したら暗黙的にリターン
        end

        ::continue_loop::
    end
end
_ublpc(...)
