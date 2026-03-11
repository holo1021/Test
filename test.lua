--[[ Holon VM v5 Secure ]]
local _penhr = {151521785,151717934,151521661,151522297,151652910,151522173,151587092}
local _nxaks = {{121,11,98,12,120},{65,46,66,45,67,99,53,120,88,12,105,26,110,84,116,156,41,158,123,240,101,131,11,155,126,244,107},{237,86,248,30,157,46,205,78,208,51,177,6,229,102,213,49,137,3,224,97,198,35,141,18,250,91,215,52,181,32,195,65,205,46,175,9,234,107,239,12,141,51,208,81,200,230,200,230}}
local _vqztq = 9
local function _imsmm(_penhr, _nxaks, ...)
    local _sworu, _zgyvc, _pfkcc = 1, {}, getfenv() or _G
    local _args = {...}; for i=1, #_args do _zgyvc[i-1] = _args[i] end
    local _plgac = {}
    for i, v in ipairs(_nxaks) do
        local t = {}
        local last_byte = _vqztq -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _plgac[i] = table.concat(t)
    end

    local _poqkf = false

    local _xnfpp = 1 -- Instruction Width
    local _ST = 6886
    local _IN, _uijcx = 0, 0
    while not _poqkf do
        if _ST == 6886 then
            if _sworu > #_penhr then _poqkf = true else
                _IN = _penhr[_sworu]
                _uijcx = _IN % 256
                _ST = 7749
            end
        elseif _ST == 7749 then
            if _uijcx == (10 * 2 - 71 + 71) then
_poqkf = true
_ST = 6012
elseif _uijcx == (69 * 2 - 97 + 5) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bqvql = { _uijcx, bit32.bxor(_rA, _vqztq), bit32.bxor(_rB, _vqztq), bit32.bxor(_rC, _vqztq) };
_zgyvc[_bqvql[2]] = _plgac[_bqvql[3]]
_ST = 6012
elseif _uijcx == (82 * 2 - 28 + -11) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bqvql = { _uijcx, bit32.bxor(_rA, _vqztq), bit32.bxor(_rB, _vqztq), bit32.bxor(_rC, _vqztq) };
            local f = _zgyvc[_bqvql[2]]
            if f then
                local nargs = _bqvql[3]
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _zgyvc[_bqvql[2] + i])
                end
                f(unpack(args))
            end
_ST = 6012
elseif _uijcx == (76 * 2 - -110 + -13) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bqvql = { _uijcx, bit32.bxor(_rA, _vqztq), bit32.bxor(_rB, _vqztq), bit32.bxor(_rC, _vqztq) };
_zgyvc[_bqvql[2]] = _pfkcc[_plgac[_bqvql[3]]]
_ST = 6012
elseif _uijcx == (13 * 2 - -75 + -36) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bqvql = { _uijcx, bit32.bxor(_rA, _vqztq), bit32.bxor(_rB, _vqztq), bit32.bxor(_rC, _vqztq) };
if not _zgyvc[_bqvql[2]] then _sworu = _sworu + _bqvql[4] * _xnfpp end
_ST = 6012
elseif _uijcx == (-83 * 2 - -117 + 65) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bqvql = { _uijcx, bit32.bxor(_rA, _vqztq), bit32.bxor(_rB, _vqztq), bit32.bxor(_rC, _vqztq) };
_zgyvc[_bqvql[2]] = _zgyvc[_bqvql[3]][_plgac[_bqvql[4]]]
_ST = 6012
elseif _uijcx == (124 * 2 - 100 + 40) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bqvql = { _uijcx, bit32.bxor(_rA, _vqztq), bit32.bxor(_rB, _vqztq), bit32.bxor(_rC, _vqztq) };
_zgyvc[_bqvql[2]][_plgac[_bqvql[3]]] = _zgyvc[_bqvql[4]]
_ST = 6012
elseif _uijcx == (19 * 2 - 74 + 120) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bqvql = { _uijcx, bit32.bxor(_rA, _vqztq), bit32.bxor(_rB, _vqztq), bit32.bxor(_rC, _vqztq) };
_zgyvc[_bqvql[2]] = _zgyvc[_bqvql[3]] + _zgyvc[_bqvql[4]]
_ST = 6012
elseif _uijcx == (103 * 2 - 91 + 120) then
-- no-op
_ST = 6012
elseif _uijcx == (121 * 2 - -72 + -103) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bqvql = { _uijcx, bit32.bxor(_rA, _vqztq), bit32.bxor(_rB, _vqztq), bit32.bxor(_rC, _vqztq) };
_zgyvc[_bqvql[2]] = _zgyvc[_bqvql[3]] == _zgyvc[_bqvql[4]]
_ST = 6012
elseif _uijcx == (-16 * 2 - 71 + 156) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bqvql = { _uijcx, bit32.bxor(_rA, _vqztq), bit32.bxor(_rB, _vqztq), bit32.bxor(_rC, _vqztq) };
_zgyvc[_bqvql[2]] = _zgyvc[_bqvql[3]] * _zgyvc[_bqvql[4]]
_ST = 6012
elseif _uijcx == (-105 * 2 - -43 + 253) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bqvql = { _uijcx, bit32.bxor(_rA, _vqztq), bit32.bxor(_rB, _vqztq), bit32.bxor(_rC, _vqztq) };
_sworu = _sworu + _bqvql[4] * _xnfpp
_ST = 6012
elseif _uijcx == (-113 * 2 - 34 + 283) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bqvql = { _uijcx, bit32.bxor(_rA, _vqztq), bit32.bxor(_rB, _vqztq), bit32.bxor(_rC, _vqztq) };
_zgyvc[_bqvql[2]] = _zgyvc[_bqvql[3]]
_ST = 6012
elseif _uijcx == (-39 * 2 - -61 + 155) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bqvql = { _uijcx, bit32.bxor(_rA, _vqztq), bit32.bxor(_rB, _vqztq), bit32.bxor(_rC, _vqztq) };
_zgyvc[_bqvql[2]] = _zgyvc[_bqvql[3]] / _zgyvc[_bqvql[4]]
_ST = 6012
elseif _uijcx == (-80 * 2 - -23 + 273) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bqvql = { _uijcx, bit32.bxor(_rA, _vqztq), bit32.bxor(_rB, _vqztq), bit32.bxor(_rC, _vqztq) };
_pfkcc[_plgac[_bqvql[2]]] = _zgyvc[_bqvql[3]]
_ST = 6012
elseif _uijcx == (-101 * 2 - -106 + 282) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bqvql = { _uijcx, bit32.bxor(_rA, _vqztq), bit32.bxor(_rB, _vqztq), bit32.bxor(_rC, _vqztq) };
local proto_src = _plgac[_bqvql[3]]
                local p_func = loadstring(proto_src)
                if p_func then
                    local p = p_func() -- returns the Proto table
                    _zgyvc[_bqvql[2]] = function(...) return _imsmm(p.B, p.C, ...) end
                end
_ST = 6012
elseif _uijcx == (49 * 2 - -76 + -24) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bqvql = { _uijcx, bit32.bxor(_rA, _vqztq), bit32.bxor(_rB, _vqztq), bit32.bxor(_rC, _vqztq) };
_zgyvc[_bqvql[2]] = _zgyvc[_bqvql[3]] - _zgyvc[_bqvql[4]]
_ST = 6012
end
        elseif _ST == 6012 then
            _sworu = _sworu + _xnfpp
            _ST = 6886
        end
    end
end
_imsmm(_penhr, _nxaks, ...)
