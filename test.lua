--[[ Holon VM v5 Secure ]]
local _kteiv = {84149667,84345877,117900657,84150179,84280853,117901169,84215205,84215189}
local _gvcyf = {{117,7,110,0,116},{77,34,78,33,79,111,57,116,84,0,101,22,98,88,120,144,37,146,119,252,105,143,7,151,114,248,103},{225,90,244,18,145,34,193,66,220,63,189,10,233,106,217,61,133,15,236,109,202,47,129,30,246,87,219,56,185,44,207,77,193,34,163,5,230,103,227,0,129,63,220,93,196,234,196,234}}
local _xoaxk = 5
local function _wfpxo(_kteiv, _gvcyf, _qnxfa, ...)
    local _ubiuo, _ekeqa = 1, getfenv() or _G
    local _args = {...}; for i=1, #_args do _qnxfa[i-1] = _args[i] end
    local _hazrb = {}
    for i, v in ipairs(_gvcyf) do
        local t = {}
        local last_byte = _xoaxk -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _hazrb[i] = table.concat(t)
    end

    local _askqu = nil

    local _nwqsk = 1 -- Instruction Width
    local _ST = 9626
    local _IN, _axumu = 0, 0
    while _askqu == nil do
        if _ST == 9626 then
            if _ubiuo > #_kteiv then _askqu = {} else
                _IN = _kteiv[_ubiuo]
                _axumu = _IN % 256
                _ST = 8820
            end
        elseif _ST == 8820 then
            if _axumu == (9 * 2 - -60 + 92) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = _qnxfa[_vpbis[3]]
_ST = 1561
elseif _axumu == (-9 * 2 - -6 + 161) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
local n = _vpbis[3] - 1; local t = {}; for i=0, n-1 do t[i+1] = _qnxfa[_vpbis[2]+i] end; _askqu = t
_ST = 1561
elseif _axumu == (-98 * 2 - 101 + 511) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
if not _qnxfa[_vpbis[2]] then _ubiuo = _ubiuo + _vpbis[4] * _nwqsk end
_ST = 1561
elseif _axumu == (-80 * 2 - -9 + 177) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]][_hazrb[_vpbis[3]]] = _qnxfa[_vpbis[4]]
_ST = 1561
elseif _axumu == (-19 * 2 - -22 + 223) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = _qnxfa[_vpbis[3]] * _qnxfa[_vpbis[4]]
_ST = 1561
elseif _axumu == (14 * 2 - -73 + -70) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_ubiuo = _ubiuo + _vpbis[4] * _nwqsk
_ST = 1561
elseif _axumu == (-24 * 2 - -82 + 123) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = _qnxfa[_vpbis[3]] == _qnxfa[_vpbis[4]]
_ST = 1561
elseif _axumu == (57 * 2 - -16 + -11) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = -_qnxfa[_vpbis[3]]
_ST = 1561
elseif _axumu == (-95 * 2 - 20 + 271) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
                    local target_S = _qnxfa
                    for i=1, _vpbis[4] do target_S = target_S.parent end
                    _qnxfa[_vpbis[2]] = target_S[_vpbis[3]]
                
_ST = 1561
elseif _axumu == (-11 * 2 - 117 + 278) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };

_ST = 1561
elseif _axumu == (69 * 2 - 117 + 142) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = _ekeqa[_hazrb[_vpbis[3]]]
_ST = 1561
elseif _axumu == (-4 * 2 - -19 + 154) then
-- no-op
_ST = 1561
elseif _axumu == (-13 * 2 - 9 + 79) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = _qnxfa[_vpbis[3]] / _qnxfa[_vpbis[4]]
_ST = 1561
elseif _axumu == (-86 * 2 - -99 + 201) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
                    local target_S = _qnxfa
                    for i=1, _vpbis[3] do target_S = target_S.parent end
                    target_S[_vpbis[2]] = _qnxfa[_vpbis[4]]
                
_ST = 1561
elseif _axumu == (-88 * 2 - -3 + 357) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = _qnxfa[_vpbis[3]] <= _qnxfa[_vpbis[4]]
_ST = 1561
elseif _axumu == (-110 * 2 - 40 + 344) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = _qnxfa[_vpbis[3]][_hazrb[_vpbis[4]]]
_ST = 1561
elseif _axumu == (-53 * 2 - -82 + 92) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = {}
_ST = 1561
elseif _axumu == (-48 * 2 - -10 + 193) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = _qnxfa[_vpbis[3]][_qnxfa[_vpbis[4]]]
_ST = 1561
elseif _axumu == (-66 * 2 - -29 + 335) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = _qnxfa[_vpbis[3]] + _qnxfa[_vpbis[4]]
_ST = 1561
elseif _axumu == (70 * 2 - -55 + -34) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = _qnxfa[_vpbis[3]] - _qnxfa[_vpbis[4]]
_ST = 1561
elseif _axumu == (118 * 2 - -14 + -137) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
            local f = _qnxfa[_vpbis[2]]
            if f then
                local nargs = _vpbis[3] - 1
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _qnxfa[_vpbis[2] + i])
                end
                local results = { f(unpack(args)) }
                local nRes = _vpbis[4] - 1
                if nRes > 0 then
                    for i = 1, nRes do _qnxfa[_vpbis[2] + i - 1] = results[i] end
                end
            end
_ST = 1561
elseif _axumu == (-5 * 2 - 54 + 319) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = _qnxfa[_vpbis[3]] ~= _qnxfa[_vpbis[4]]
_ST = 1561
elseif _axumu == (115 * 2 - 109 + 55) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = not _qnxfa[_vpbis[3]]
_ST = 1561
elseif _axumu == (-119 * 2 - 39 + 393) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = _qnxfa[_vpbis[3]] < _qnxfa[_vpbis[4]]
_ST = 1561
elseif _axumu == (121 * 2 - 126 + 12) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };

_ST = 1561
elseif _axumu == (108 * 2 - -97 + -112) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]][_qnxfa[_vpbis[3]]] = _qnxfa[_vpbis[4]]
_ST = 1561
elseif _axumu == (103 * 2 - -21 + -189) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
local proto_src = _hazrb[_vpbis[3]]
                local p_func = loadstring(proto_src)
                if p_func then
                    local p = p_func()
                    _qnxfa[_vpbis[2]] = function(...)
                        local new_S = {}
                        new_S.parent = _qnxfa
                        return _wfpxo(p.B, p.C, new_S, ...)
                    end
                end
_ST = 1561
elseif _axumu == (-95 * 2 - -119 + 92) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_qnxfa[_vpbis[2]] = _hazrb[_vpbis[3]]
_ST = 1561
elseif _axumu == (13 * 2 - -7 + 186) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
_ekeqa[_hazrb[_vpbis[2]]] = _qnxfa[_vpbis[3]]
_ST = 1561
elseif _axumu == (38 * 2 - -115 + 8) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };

_ST = 1561
elseif _axumu == (-57 * 2 - 125 + 254) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };
if _qnxfa[_vpbis[2]] then _ubiuo = _ubiuo + _vpbis[4] * _nwqsk end
_ST = 1561
elseif _axumu == (-26 * 2 - -75 + 179) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _vpbis = { _axumu, bit32.bxor(_rA, _xoaxk), bit32.bxor(_rB, _xoaxk), bit32.bxor(_rC, _xoaxk) };

_ST = 1561
end
        elseif _ST == 1561 then
            _ubiuo = _ubiuo + _nwqsk
            _ST = 9626
        end
    end
    return unpack(_askqu or {})
end
return _wfpxo(_kteiv, _gvcyf, {}, ...)
