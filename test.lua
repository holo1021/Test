--[[ Holon VM v5 Secure ]]
local _adsrf = {206,124,125,124,39,125,126,124,136,124,126,125,206,126,125,124,39,127,127,124,136,126,126,125,35,124,125,124}
local _xkccq = {{12,126,23,121,13},{52,91,55,88,54,22,64,13,45,121,28,111,27,33,1,233,92,235,14,133,16,246,126,238,11,129,30},{152,35,141,107,232,91,184,59,165,70,196,115,144,19,160,68,252,118,149,20,179,86,248,103,143,46,162,65,192,85,182,52,184,91,218,124,159,30,154,121,248,70,165,36,189,147,189,147}}
local _yipkn = {}
local _zmgfn = 124
local function _czbvw(...)
    local _savos, _wwage = {}, getfenv() or _G
    local _bgcjm = {} -- Call Stack: {cl, pc, base, ret_reg}

    -- Helper to decode constants for a prototype, with caching
    local _hxgye = setmetatable({}, {__mode = "k"})
    local function _oinjz(p)
        if _hxgye[p] then return _hxgye[p] end
        local dc = {}
        for i, v in ipairs(p.c) do
            local s = ""
            local last_byte = _zmgfn
            for j = 1, #v do
                local enc_byte = v[j]
                local dec_byte = bit32.bxor(enc_byte, last_byte)
                s = s .. string.char(dec_byte)
                last_byte = enc_byte
            end
            dc[i] = s
        end
        _hxgye[p] = dc
        return dc
    end

    -- Main closure setup
    local _CL = { p = { b = _adsrf, c = _xkccq, p = _yipkn, np = 0 } }
    table.insert(_bgcjm, { cl = _CL, pc = 1, base = 1, rr = 1 })

    -- VM命令ハンドラテーブル
    local _aalor = {
        [239] = function(_I, _savos, _BASE) _savos[_BASE + _I[2]] = _savos[_BASE + _I[3]] end,
        [39] = function(_I, _savos, _BASE, _DC) _savos[_BASE + _I[2]] = _DC[_I[3]] end,
        [206] = function(_I, _savos, _BASE, _DC, _wwage) _savos[_BASE + _I[2]] = _wwage[_DC[_I[3]]] end,
        [184] = function(_I, _savos, _BASE, _DC, _wwage) _wwage[_DC[_I[3]]] = _savos[_BASE + _I[2]] end,
        [19] = function(_I, _savos, _BASE, _DC, _wwage, _CL) _savos[_BASE + _I[2]] = { p = _CL.p.p[_I[3]], uv = {} } end,
        [136] = function(_I, _savos, _BASE, _DC, _wwage, _CL, _bgcjm)
            local func_reg, n_args, n_ret = _I[2], _I[3] - 1, _I[4] - 1
            local func = _savos[_BASE + func_reg]
            if func then
                if type(func) == "function" then
                    local args = {}
                    for i = 1, n_args do args[i] = _savos[_BASE + func_reg + i] end
                    -- pcallを削除し、直接呼び出すことでエラーを隠蔽せず、unpackの範囲を明示してnil安全性を高めます
                    local results = {func(unpack(args, 1, n_args))}
                    for i = 1, n_ret do _savos[_BASE + func_reg + i - 1] = results[i+1] end
                else
                    table.insert(_bgcjm, { cl = func, pc = 1, base = _BASE + func_reg, rr = _BASE + func_reg })
                end
            end
        end,
        [35] = function(_I, _savos, _BASE, _DC, _wwage, _CL, _bgcjm, frame)
            local ret_start, n_ret = _I[2], _I[3] - 1
            if #_bgcjm > 1 then -- 呼び出し元がある場合のみ戻り値を設定
                for i = 1, n_ret do _savos[frame.rr + i - 1] = _savos[_BASE + ret_start + i - 1] end
            end
            table.remove(_bgcjm)
        end,
        [159] = function(_I, _savos, _BASE, _DC, _wwage, _CL, _bgcjm, frame, _P, _ipwgg) frame.pc = _P + _I[4] * _ipwgg end,
        [247] = function(_I, _savos, _BASE, _DC, _wwage, _CL, _bgcjm, frame, _P, _ipwgg) if not _savos[_BASE + _I[2]] then frame.pc = _P + _I[4] * _ipwgg end end,
        [98] = function(_I, _savos, _BASE) _savos[_BASE + _I[2]] = _savos[_BASE + _I[3]] == _savos[_BASE + _I[4]] end,
        [212] = function(_I, _savos, _BASE) _savos[_BASE + _I[2]] = _savos[_BASE + _I[3]] + _savos[_BASE + _I[4]] end,
        [153] = function(_I, _savos, _BASE) _savos[_BASE + _I[2]] = _savos[_BASE + _I[3]] - _savos[_BASE + _I[4]] end,
        [224] = function(_I, _savos, _BASE) _savos[_BASE + _I[2]] = _savos[_BASE + _I[3]] * _savos[_BASE + _I[4]] end,
        [203] = function(_I, _savos, _BASE) _savos[_BASE + _I[2]] = _savos[_BASE + _I[3]] / _savos[_BASE + _I[4]] end,
        [71] = function() end -- 何もしない
    }

    local _ipwgg = 4 -- Instruction Width

    while #_bgcjm > 0 do
        local frame = _bgcjm[#_bgcjm]
        local _CL, _P, _BASE = frame.cl, frame.pc, frame.base
        if not _CL then table.remove(_bgcjm); goto continue_loop end -- 安全策: 不正なコールスタックを削除
        local _BC = _CL.p.b
        local _DC = _oinjz(_CL.p)

        if _P <= #_BC then
            local _O = _BC[_P]
            frame.pc = _P + _ipwgg
            local handler = _aalor[_O]
            if handler then
                local _I = { _O, bit32.bxor(_BC[_P+1], _zmgfn), bit32.bxor(_BC[_P+2], _zmgfn), bit32.bxor(_BC[_P+3], _zmgfn) }
                handler(_I, _savos, _BASE, _DC, _wwage, _CL, _bgcjm, frame, _P, _ipwgg)
            end
        else
            table.remove(_bgcjm) -- バイトコードの終端に達したら暗黙的にリターン
        end

        ::continue_loop::
    end
end
_czbvw(...)
