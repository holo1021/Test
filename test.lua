--[[ Holon VM v5 Secure ]]
local _tbbeo = {2138996499,2138930835,2105376611,2138995987,2138864787,2105376099,2139062183}
local _vatwf = {{15,125,20,122,14},{55,88,52,91,53,21,67,14,46,122,31,108,24,34,2,234,95,232,13,134,19,245,125,237,8,130,29},{155,32,142,104,235,88,187,56,166,69,199,112,147,16,163,71,255,117,150,23,176,85,251,100,140,45,161,66,195,86,181,55,187,88,217,127,156,29,153,122,251,69,166,39,190,144,190,144}}
local _vvlro = 127
local function _dugvq(_tbbeo, _vatwf, _lmezb, ...)
    local _kmhlz, _zyqgj = 1, getfenv() or _G
    local _args = {...}; for i=1, #_args do _lmezb[i-1] = _args[i] end
    local _szcbq = {}
    for i, v in ipairs(_vatwf) do
        local t = {}
        local last_byte = _vvlro -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _szcbq[i] = table.concat(t)
    end

    local _dnzbs = nil

    local _xfxyj = 1 -- Instruction Width
    local _ST = 1113
    local _IN, _yammb = 0, 0
    while _dnzbs == nil do
        if _ST == 1113 then
            if _kmhlz > #_tbbeo then _dnzbs = {} else
                _IN = _tbbeo[_kmhlz]
                _yammb = _IN % 256
                _ST = 4003
            end
        elseif _ST == 4003 then
            if _yammb == (46 * 2 - -65 + 90) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]] = _lmezb[_uuaom[3]] ~= _lmezb[_uuaom[4]]
_ST = 4407
elseif _yammb == (-17 * 2 - -14 + 264) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]] = {}
_ST = 4407
elseif _yammb == (13 * 2 - 26 + 70) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };

_ST = 4407
elseif _yammb == (-37 * 2 - -13 + 316) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
local args = {}; for i=1, _uuaom[3]-1 do args[i] = _lmezb[_uuaom[2]+i] end; local res = {_lmezb[_uuaom[2]](unpack(args))}; for i=1, _uuaom[4] do _lmezb[_uuaom[2]+i-1] = res[i] end
_ST = 4407
elseif _yammb == (91 * 2 - -36 + -213) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
                    local target_S = _lmezb
                    for i=1, _uuaom[4] do target_S = target_S.parent end
                    _lmezb[_uuaom[2]] = target_S[_uuaom[3]]
                
_ST = 4407
elseif _yammb == (24 * 2 - 37 + 8) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]] = _zyqgj[_szcbq[_uuaom[3]]]
_ST = 4407
elseif _yammb == (-71 * 2 - 74 + 315) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
            local f = _lmezb[_uuaom[2]]
            if f then
                local nargs = _uuaom[3] - 1
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _lmezb[_uuaom[2] + i])
                end
                local results = { f(unpack(args)) }
                local nRes = _uuaom[4] - 1
                if nRes > 0 then
                    for i = 1, nRes do _lmezb[_uuaom[2] + i - 1] = results[i] end
                end
            end
_ST = 4407
elseif _yammb == (-89 * 2 - -115 + 260) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
local proto_src = _szcbq[_uuaom[3]]
                local p_func = loadstring(proto_src)
                if p_func then
                    local p = p_func()
                    _lmezb[_uuaom[2]] = function(...)
                        local new_S = {}
                        new_S.parent = _lmezb
                        return _dugvq(p.B, p.C, new_S, ...)
                    end
                end
_ST = 4407
elseif _yammb == (-51 * 2 - -32 + 263) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]] = _lmezb[_uuaom[3]] <= _lmezb[_uuaom[4]]
_ST = 4407
elseif _yammb == (98 * 2 - -11 + -60) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]] = _szcbq[_uuaom[3]]
_ST = 4407
elseif _yammb == (42 * 2 - -50 + -14) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_zyqgj[_szcbq[_uuaom[2]]] = _lmezb[_uuaom[3]]
_ST = 4407
elseif _yammb == (-11 * 2 - 81 + 344) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]] = not _lmezb[_uuaom[3]]
_ST = 4407
elseif _yammb == (85 * 2 - 41 + 93) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]] = _lmezb[_uuaom[3]][_lmezb[_uuaom[4]]]
_ST = 4407
elseif _yammb == (-97 * 2 - 91 + 503) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };

_ST = 4407
elseif _yammb == (101 * 2 - 105 + -74) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]] = _lmezb[_uuaom[3]] * _lmezb[_uuaom[4]]
_ST = 4407
elseif _yammb == (-38 * 2 - 92 + 335) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
local n = _uuaom[3] - 1; local t = {}; for i=0, n-1 do t[i+1] = _lmezb[_uuaom[2]+i] end; _dnzbs = t
_ST = 4407
elseif _yammb == (-8 * 2 - 119 + 257) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]] = _lmezb[_uuaom[3]] == _lmezb[_uuaom[4]]
_ST = 4407
elseif _yammb == (-78 * 2 - 76 + 390) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
if not _lmezb[_uuaom[2]] then _kmhlz = _kmhlz + _uuaom[4] * _xfxyj end
_ST = 4407
elseif _yammb == (71 * 2 - 39 + 12) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
if _lmezb[_uuaom[2]] then _kmhlz = _kmhlz + _uuaom[4] * _xfxyj end
_ST = 4407
elseif _yammb == (-24 * 2 - -28 + 132) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]][_szcbq[_uuaom[3]]] = _lmezb[_uuaom[4]]
_ST = 4407
elseif _yammb == (-103 * 2 - -85 + 304) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]][_lmezb[_uuaom[3]]] = _lmezb[_uuaom[4]]
_ST = 4407
elseif _yammb == (-77 * 2 - -108 + 272) then
-- no-op
_ST = 4407
elseif _yammb == (112 * 2 - -1 + -149) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]] = _lmezb[_uuaom[3]]
_ST = 4407
elseif _yammb == (89 * 2 - 42 + -77) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]] = -_lmezb[_uuaom[3]]
_ST = 4407
elseif _yammb == (125 * 2 - 1 + -31) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
                    local target_S = _lmezb
                    for i=1, _uuaom[3] do target_S = target_S.parent end
                    target_S[_uuaom[2]] = _lmezb[_uuaom[4]]
                
_ST = 4407
elseif _yammb == (-119 * 2 - -88 + 176) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
if _lmezb[_uuaom[2]+1] ~= nil then _lmezb[_uuaom[2]] = _lmezb[_uuaom[2]+1]; _kmhlz = _kmhlz + _uuaom[4] * _xfxyj else _lmezb[_uuaom[2]] = nil end
_ST = 4407
elseif _yammb == (-40 * 2 - 34 + 338) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]] = _lmezb[_uuaom[3]] + _lmezb[_uuaom[4]]
_ST = 4407
elseif _yammb == (-30 * 2 - -64 + 50) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_kmhlz = _kmhlz + _uuaom[4] * _xfxyj
_ST = 4407
elseif _yammb == (-53 * 2 - 51 + 178) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]] = _lmezb[_uuaom[3]] < _lmezb[_uuaom[4]]
_ST = 4407
elseif _yammb == (84 * 2 - -60 + 14) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };

_ST = 4407
elseif _yammb == (3 * 2 - 108 + 262) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]] = _lmezb[_uuaom[3]][_szcbq[_uuaom[4]]]
_ST = 4407
elseif _yammb == (-29 * 2 - -108 + 12) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _uuaom = { _yammb, bit32.bxor(_rA, _vvlro), bit32.bxor(_rB, _vvlro), bit32.bxor(_rC, _vvlro) };
_lmezb[_uuaom[2]] = _lmezb[_uuaom[3]] - _lmezb[_uuaom[4]]
_ST = 4407
end
        elseif _ST == 4407 then
            _kmhlz = _kmhlz + _xfxyj
            _ST = 1113
        end
    end
    return unpack(_dnzbs or {})
end
return _dugvq(_tbbeo, _vatwf, {}, ...)
