--[[ Holon VM v5 Secure ]]
local _lfxmd = {2088598692,2088664357,2122218731,2088599204,2088730405,2122219243,2088533008}
local _vtwqy = {{12,126,23,121,13},{52,91,55,88,54,22,64,13,45,121,28,111,27,33,1,233,92,235,14,133,16,246,126,238,11,129,30},{152,35,141,107,232,91,184,59,165,70,196,115,144,19,160,68,252,118,149,20,179,86,248,103,143,46,162,65,192,85,182,52,184,91,218,124,159,30,154,121,248,70,165,36,189,147,189,147}}
local _xbnki = 124
local function _fwveu(_lfxmd, _vtwqy, _gptro, ...)
    local _xxshe, _gaupp = 1, getfenv() or _G
    local _args = {...}; for i=1, #_args do _gptro[i-1] = _args[i] end
    local _bkjwh = {}
    for i, v in ipairs(_vtwqy) do
        local t = {}
        local last_byte = _xbnki -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _bkjwh[i] = table.concat(t)
    end

    local _fasuj = nil

    local _kszse = 1 -- Instruction Width
    local _ST = 8375
    local _IN, _sqmni = 0, 0
    while _fasuj == nil do
        if _ST == 8375 then
            if _xxshe > #_lfxmd then _fasuj = {} else
                _IN = _lfxmd[_xxshe]
                _sqmni = _IN % 256
                _ST = 9046
            end
        elseif _ST == 9046 then
            if _sqmni == (-27 * 2 - 116 + 334) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = _gaupp[_bkjwh[_kgxas[3]]]
_ST = 6866
elseif _sqmni == (114 * 2 - -90 + -82) then
-- no-op
_ST = 6866
elseif _sqmni == (107 * 2 - -61 + -185) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]][_gptro[_kgxas[3]]] = _gptro[_kgxas[4]]
_ST = 6866
elseif _sqmni == (-15 * 2 - -4 + 66) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = _gptro[_kgxas[3]] * _gptro[_kgxas[4]]
_ST = 6866
elseif _sqmni == (50 * 2 - -56 + -140) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
local n = _kgxas[3] - 1; local t = {}; for i=0, n-1 do t[i+1] = _gptro[_kgxas[2]+i] end; _fasuj = t
_ST = 6866
elseif _sqmni == (104 * 2 - -92 + -175) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = _gptro[_kgxas[3]]
_ST = 6866
elseif _sqmni == (-62 * 2 - -33 + 106) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]][_bkjwh[_kgxas[3]]] = _gptro[_kgxas[4]]
_ST = 6866
elseif _sqmni == (22 * 2 - -115 + -105) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
if _gptro[_kgxas[2]] then _xxshe = _xxshe + _kgxas[4] * _kszse end
_ST = 6866
elseif _sqmni == (-27 * 2 - -122 + 167) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
            local f = _gptro[_kgxas[2]]
            if f then
                local nargs = _kgxas[3] - 1
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _gptro[_kgxas[2] + i])
                end
                local results = { f(unpack(args)) }
                local nRes = _kgxas[4] - 1
                if nRes > 0 then
                    for i = 1, nRes do _gptro[_kgxas[2] + i - 1] = results[i] end
                end
            end
_ST = 6866
elseif _sqmni == (36 * 2 - -36 + 90) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = _gptro[_kgxas[3]][_gptro[_kgxas[4]]]
_ST = 6866
elseif _sqmni == (82 * 2 - 55 + -12) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = {}
_ST = 6866
elseif _sqmni == (-125 * 2 - 5 + 358) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
local proto_src = _bkjwh[_kgxas[3]]
                local p_func = loadstring(proto_src)
                if p_func then
                    local p = p_func()
                    _gptro[_kgxas[2]] = function(...)
                        local new_S = {}
                        new_S.parent = _gptro
                        return _fwveu(p.B, p.C, new_S, ...)
                    end
                end
_ST = 6866
elseif _sqmni == (3 * 2 - 29 + 60) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = _bkjwh[_kgxas[3]]
_ST = 6866
elseif _sqmni == (-19 * 2 - -63 + 180) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = _gptro[_kgxas[3]] ~= _gptro[_kgxas[4]]
_ST = 6866
elseif _sqmni == (60 * 2 - -84 + 45) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = _gptro[_kgxas[3]] <= _gptro[_kgxas[4]]
_ST = 6866
elseif _sqmni == (73 * 2 - 67 + 143) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = _gptro[_kgxas[3]] < _gptro[_kgxas[4]]
_ST = 6866
elseif _sqmni == (-85 * 2 - 116 + 532) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = _gptro[_kgxas[3]] / _gptro[_kgxas[4]]
_ST = 6866
elseif _sqmni == (25 * 2 - -92 + 65) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = _gptro[_kgxas[3]] - _gptro[_kgxas[4]]
_ST = 6866
elseif _sqmni == (63 * 2 - -91 + -204) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = _gptro[_kgxas[3]] + _gptro[_kgxas[4]]
_ST = 6866
elseif _sqmni == (-125 * 2 - -87 + 206) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_xxshe = _xxshe + _kgxas[4] * _kszse
_ST = 6866
elseif _sqmni == (-111 * 2 - 78 + 506) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gaupp[_bkjwh[_kgxas[2]]] = _gptro[_kgxas[3]]
_ST = 6866
elseif _sqmni == (6 * 2 - -108 + 43) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
                    local target_S = _gptro
                    for i=1, _kgxas[4] do target_S = target_S.parent end
                    _gptro[_kgxas[2]] = target_S[_kgxas[3]]
                
_ST = 6866
elseif _sqmni == (94 * 2 - -1 + -184) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
if not _gptro[_kgxas[2]] then _xxshe = _xxshe + _kgxas[4] * _kszse end
_ST = 6866
elseif _sqmni == (-100 * 2 - -69 + 299) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = _gptro[_kgxas[3]][_bkjwh[_kgxas[4]]]
_ST = 6866
elseif _sqmni == (93 * 2 - -84 + -104) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
                    local target_S = _gptro
                    for i=1, _kgxas[3] do target_S = target_S.parent end
                    target_S[_kgxas[2]] = _gptro[_kgxas[4]]
                
_ST = 6866
elseif _sqmni == (41 * 2 - 38 + 17) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = -_gptro[_kgxas[3]]
_ST = 6866
elseif _sqmni == (-51 * 2 - -68 + 174) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = _gptro[_kgxas[3]] == _gptro[_kgxas[4]]
_ST = 6866
elseif _sqmni == (70 * 2 - 64 + -41) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _kgxas = { _sqmni, bit32.bxor(_rA, _xbnki), bit32.bxor(_rB, _xbnki), bit32.bxor(_rC, _xbnki) };
_gptro[_kgxas[2]] = not _gptro[_kgxas[3]]
_ST = 6866
end
        elseif _ST == 6866 then
            _xxshe = _xxshe + _kszse
            _ST = 8375
        end
    end
    return unpack(_fasuj or {})
end
return _fwveu(_lfxmd, _vtwqy, {}, ...)
