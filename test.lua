--[[ Holon VM v5 Secure ]]
local _mnsbq = {3065493212,3065296886,3031742143,3065492700,3065427620,3065361910,3031741631,3065427617}
local _xywce = {{198,180,221,179,199},{254,145,253,146,252,220,138,199,231,179,214,165,209,235,203,35,150,33,196,79,218,60,180,36,193,75,212},{82,233,71,161,34,145,114,241,111,140,14,185,90,217,106,142,54,188,95,222,121,156,50,173,69,228,104,139,10,159,124,254,114,145,16,182,85,212,80,179,50,140,111,238,119,89,119,89}}
local _ufpce = 182
local function _pzcev(_mnsbq, _xywce, _ohxtb, ...)
    local _snejk, _jtwec = 1, getfenv() or _G
    local _args = {...}; for i=1, #_args do _ohxtb[i-1] = _args[i] end
    local _wtkzc = {}
    for i, v in ipairs(_xywce) do
        local t = {}
        local last_byte = _ufpce -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _wtkzc[i] = table.concat(t)
    end

    local _fmade = nil

    local _dydbi = 1 -- Instruction Width
    local _ST = 2356
    local _IN, _uybye = 0, 0
    while _fmade == nil do
        if _ST == 2356 then
            if _snejk > #_mnsbq then _fmade = {} else
                _IN = _mnsbq[_snejk]
                _uybye = _IN % 256
                _ST = 9907
            end
        elseif _ST == 9907 then
            if _uybye == (93 * 2 - -70 + -36) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = _jtwec[_wtkzc[_urnfe[3]]]
_ST = 1776
elseif _uybye == (-112 * 2 - 5 + 380) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_snejk = _snejk + _urnfe[4] * _dydbi
_ST = 1776
elseif _uybye == (-71 * 2 - 63 + 231) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };

_ST = 1776
elseif _uybye == (-120 * 2 - 51 + 388) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = _ohxtb[_urnfe[3]] < _ohxtb[_urnfe[4]]
_ST = 1776
elseif _uybye == (86 * 2 - -16 + 19) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]][_ohxtb[_urnfe[3]]] = _ohxtb[_urnfe[4]]
_ST = 1776
elseif _uybye == (52 * 2 - 113 + 14) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = _ohxtb[_urnfe[3]]
_ST = 1776
elseif _uybye == (40 * 2 - 89 + 150) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = not _ohxtb[_urnfe[3]]
_ST = 1776
elseif _uybye == (60 * 2 - -33 + -84) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
if _ohxtb[_urnfe[2]+1] ~= nil then _ohxtb[_urnfe[2]] = _ohxtb[_urnfe[2]+1]; _snejk = _snejk + _urnfe[4] * _dydbi else _ohxtb[_urnfe[2]] = nil end
_ST = 1776
elseif _uybye == (120 * 2 - 105 + -84) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = _ohxtb[_urnfe[3]] + _ohxtb[_urnfe[4]]
_ST = 1776
elseif _uybye == (-3 * 2 - -33 + 26) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = {}
_ST = 1776
elseif _uybye == (78 * 2 - -2 + 6) then
-- no-op
_ST = 1776
elseif _uybye == (13 * 2 - -10 + 199) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = _ohxtb[_urnfe[3]] ~= _ohxtb[_urnfe[4]]
_ST = 1776
elseif _uybye == (33 * 2 - 17 + 121) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = _ohxtb[_urnfe[3]] <= _ohxtb[_urnfe[4]]
_ST = 1776
elseif _uybye == (-31 * 2 - 86 + 372) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
if not _ohxtb[_urnfe[2]] then _snejk = _snejk + _urnfe[4] * _dydbi end
_ST = 1776
elseif _uybye == (-14 * 2 - -22 + 71) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
                    local target_S = _ohxtb
                    for i=1, _urnfe[4] do target_S = target_S.parent end
                    _ohxtb[_urnfe[2]] = target_S[_urnfe[3]]
                
_ST = 1776
elseif _uybye == (-118 * 2 - 13 + 495) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = _wtkzc[_urnfe[3]]
_ST = 1776
elseif _uybye == (-114 * 2 - -61 + 370) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = _ohxtb[_urnfe[3]] / _ohxtb[_urnfe[4]]
_ST = 1776
elseif _uybye == (29 * 2 - 23 + -28) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = _ohxtb[_urnfe[3]] - _ohxtb[_urnfe[4]]
_ST = 1776
elseif _uybye == (118 * 2 - 45 + -4) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = _ohxtb[_urnfe[3]][_ohxtb[_urnfe[4]]]
_ST = 1776
elseif _uybye == (-62 * 2 - -22 + 250) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = -_ohxtb[_urnfe[3]]
_ST = 1776
elseif _uybye == (-75 * 2 - 44 + 355) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
local n = _urnfe[3] - 1; local t = {}; for i=0, n-1 do t[i+1] = _ohxtb[_urnfe[2]+i] end; _fmade = t
_ST = 1776
elseif _uybye == (113 * 2 - 21 + -39) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = _ohxtb[_urnfe[3]][_wtkzc[_urnfe[4]]]
_ST = 1776
elseif _uybye == (-14 * 2 - 90 + 309) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
            local f = _ohxtb[_urnfe[2]]
            if f then
                local nargs = _urnfe[3] - 1
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _ohxtb[_urnfe[2] + i])
                end
                local results = { f(unpack(args)) }
                local nRes = _urnfe[4] - 1
                if nRes > 0 then
                    for i = 1, nRes do _ohxtb[_urnfe[2] + i - 1] = results[i] end
                end
            end
_ST = 1776
elseif _uybye == (-78 * 2 - 44 + 259) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]][_wtkzc[_urnfe[3]]] = _ohxtb[_urnfe[4]]
_ST = 1776
elseif _uybye == (65 * 2 - 115 + 5) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = _ohxtb[_urnfe[3]] == _ohxtb[_urnfe[4]]
_ST = 1776
elseif _uybye == (-109 * 2 - -59 + 342) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
if _ohxtb[_urnfe[2]] then _snejk = _snejk + _urnfe[4] * _dydbi end
_ST = 1776
elseif _uybye == (52 * 2 - 32 + 47) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };

_ST = 1776
elseif _uybye == (10 * 2 - -118 + 61) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
local args = {}; for i=1, _urnfe[3]-1 do args[i] = _ohxtb[_urnfe[2]+i] end; local res = {_ohxtb[_urnfe[2]](unpack(args))}; for i=1, _urnfe[4] do _ohxtb[_urnfe[2]+i-1] = res[i] end
_ST = 1776
elseif _uybye == (21 * 2 - 95 + 93) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_ohxtb[_urnfe[2]] = _ohxtb[_urnfe[3]] * _ohxtb[_urnfe[4]]
_ST = 1776
elseif _uybye == (-125 * 2 - 17 + 381) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
_jtwec[_wtkzc[_urnfe[2]]] = _ohxtb[_urnfe[3]]
_ST = 1776
elseif _uybye == (-19 * 2 - -106 + 51) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
                    local target_S = _ohxtb
                    for i=1, _urnfe[3] do target_S = target_S.parent end
                    target_S[_urnfe[2]] = _ohxtb[_urnfe[4]]
                
_ST = 1776
elseif _uybye == (-63 * 2 - -87 + 232) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _urnfe = { _uybye, bit32.bxor(_rA, _ufpce), bit32.bxor(_rB, _ufpce), bit32.bxor(_rC, _ufpce) };
local proto_src = _wtkzc[_urnfe[3]]
                local p_func = loadstring(proto_src)
                if p_func then
                    local p = p_func()
                    _ohxtb[_urnfe[2]] = function(...)
                        local new_S = {}
                        new_S.parent = _ohxtb
                        return _pzcev(p.B, p.C, new_S, ...)
                    end
                end
_ST = 1776
end
        elseif _ST == 1776 then
            _snejk = _snejk + _dydbi
            _ST = 2356
        end
    end
    return unpack(_fmade or {})
end
return _pzcev(_mnsbq, _xywce, {}, ...)
