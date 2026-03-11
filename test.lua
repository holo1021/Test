--[[ Holon VM v5 Secure ]]
local _isfpp = {2240054738,2240251023,2240054625,2240055250,2240185999,2240055137,2240120245}
local _aoiiz = {{245,135,238,128,244},{205,162,206,161,207,239,185,244,212,128,229,150,226,216,248,16,165,18,247,124,233,15,135,23,242,120,231},{97,218,116,146,17,162,65,194,92,191,61,138,105,234,89,189,5,143,108,237,74,175,1,158,118,215,91,184,57,172,79,205,65,162,35,133,102,231,99,128,1,191,92,221,68,106,68,106}}
local _blpiu = 133
local function _wwqdw(_isfpp, _aoiiz, ...)
    local _obfnu, _nulwm, _mqqfj = 1, {}, getfenv() or _G
    local _args = {...}; for i=1, #_args do _nulwm[i-1] = _args[i] end
    local _dpwsm = {}
    for i, v in ipairs(_aoiiz) do
        local t = {}
        local last_byte = _blpiu -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _dpwsm[i] = table.concat(t)
    end

    local _lafsw = false

    local _gldji = 1 -- Instruction Width
    local _ST = 5990
    local _IN, _rdldb = 0, 0
    while not _lafsw do
        if _ST == 5990 then
            if _obfnu > #_isfpp then _lafsw = true else
                _IN = _isfpp[_obfnu]
                _rdldb = _IN % 256
                _ST = 9936
            end
        elseif _ST == 9936 then
            if _rdldb == (-42 * 2 - -16 + 287) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
_nulwm[_lumon[2]] = _nulwm[_lumon[3]] / _nulwm[_lumon[4]]
_ST = 1410
elseif _rdldb == (121 * 2 - 88 + -137) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
local proto_src = _dpwsm[_lumon[3]]
                local p_func = loadstring(proto_src)
                if p_func then
                    local p = p_func() -- returns the Proto table
                    _nulwm[_lumon[2]] = function(...) return _wwqdw(p.B, p.C, ...) end
                end
_ST = 1410
elseif _rdldb == (24 * 2 - 103 + 198) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
_nulwm[_lumon[2]] = _dpwsm[_lumon[3]]
_ST = 1410
elseif _rdldb == (115 * 2 - 114 + 94) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
_nulwm[_lumon[2]] = _mqqfj[_dpwsm[_lumon[3]]]
_ST = 1410
elseif _rdldb == (-110 * 2 - 56 + 323) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
if not _nulwm[_lumon[2]] then _obfnu = _obfnu + _lumon[4] * _gldji end
_ST = 1410
elseif _rdldb == (-85 * 2 - 46 + 242) then
-- no-op
_ST = 1410
elseif _rdldb == (57 * 2 - -4 + -1) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
_nulwm[_lumon[2]] = _nulwm[_lumon[3]][_nulwm[_lumon[4]]]
_ST = 1410
elseif _rdldb == (96 * 2 - 123 + -32) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
_nulwm[_lumon[2]][_nulwm[_lumon[3]]] = _nulwm[_lumon[4]]
_ST = 1410
elseif _rdldb == (22 * 2 - 79 + 77) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
_mqqfj[_dpwsm[_lumon[2]]] = _nulwm[_lumon[3]]
_ST = 1410
elseif _rdldb == (19 * 2 - -51 + -33) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
_nulwm[_lumon[2]] = _nulwm[_lumon[3]] + _nulwm[_lumon[4]]
_ST = 1410
elseif _rdldb == (58 * 2 - 15 + 82) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
_nulwm[_lumon[2]] = _nulwm[_lumon[3]] * _nulwm[_lumon[4]]
_ST = 1410
elseif _rdldb == (20 * 2 - -107 + -143) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
_nulwm[_lumon[2]] = _nulwm[_lumon[3]]
_ST = 1410
elseif _rdldb == (96 * 2 - 10 + -181) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
_nulwm[_lumon[2]] = _nulwm[_lumon[3]] == _nulwm[_lumon[4]]
_ST = 1410
elseif _rdldb == (-36 * 2 - 117 + 377) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
_nulwm[_lumon[2]] = _nulwm[_lumon[3]] - _nulwm[_lumon[4]]
_ST = 1410
elseif _rdldb == (-95 * 2 - -15 + 308) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
_nulwm[_lumon[2]] = _nulwm[_lumon[3]][_dpwsm[_lumon[4]]]
_ST = 1410
elseif _rdldb == (-96 * 2 - -111 + 146) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
_obfnu = _obfnu + _lumon[4] * _gldji
_ST = 1410
elseif _rdldb == (-120 * 2 - 17 + 438) then
_lafsw = true
_ST = 1410
elseif _rdldb == (-83 * 2 - -109 + 213) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
_nulwm[_lumon[2]][_dpwsm[_lumon[3]]] = _nulwm[_lumon[4]]
_ST = 1410
elseif _rdldb == (-7 * 2 - 120 + 231) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
            local f = _nulwm[_lumon[2]]
            if f then
                local nargs = _lumon[3]
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _nulwm[_lumon[2] + i])
                end
                f(unpack(args))
            end
_ST = 1410
elseif _rdldb == (49 * 2 - 108 + 73) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _lumon = { _rdldb, bit32.bxor(_rA, _blpiu), bit32.bxor(_rB, _blpiu), bit32.bxor(_rC, _blpiu) };
_nulwm[_lumon[2]] = {}
_ST = 1410
end
        elseif _ST == 1410 then
            _obfnu = _obfnu + _gldji
            _ST = 5990
        end
    end
end
_wwqdw(_isfpp, _aoiiz, ...)
