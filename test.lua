--[[ Holon VM v5 Secure ]]
local _nmxwa = {33751688,33555434,642,33751176,33620458,130,33686092}
local _qkrve = {{114,0,105,7,115},{74,37,73,38,72,104,62,115,83,7,98,17,101,95,127,151,34,149,112,251,110,136,0,144,117,255,96},{230,93,243,21,150,37,198,69,219,56,186,13,238,109,222,58,130,8,235,106,205,40,134,25,241,80,220,63,190,43,200,74,198,37,164,2,225,96,228,7,134,56,219,90,195,237,195,237}}
local _sbogw = 2
local function _vylwj(_nmxwa, _qkrve, _afjkx, ...)
    local _buqam, _alqae = 1, getfenv() or _G
    local _args = {...}; for i=1, #_args do _afjkx[i-1] = _args[i] end
    local _njnjr = {}
    for i, v in ipairs(_qkrve) do
        local t = {}
        local last_byte = _sbogw -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _njnjr[i] = table.concat(t)
    end

    local _ciwjj = nil

    local _pghhl = 1 -- Instruction Width
    local _ST = 9579
    local _IN, _biqyd = 0, 0
    while _ciwjj == nil do
        if _ST == 9579 then
            if _buqam > #_nmxwa then _ciwjj = {} else
                _IN = _nmxwa[_buqam]
                _biqyd = _IN % 256
                _ST = 6588
            end
        elseif _ST == 6588 then
            if _biqyd == (-15 * 2 - 106 + 370) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = _njnjr[_sbhic[3]]
_ST = 9960
elseif _biqyd == (127 * 2 - 10 + -108) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = _alqae[_njnjr[_sbhic[3]]]
_ST = 9960
elseif _biqyd == (-76 * 2 - 79 + 339) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = not _afjkx[_sbhic[3]]
_ST = 9960
elseif _biqyd == (43 * 2 - 99 + 76) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = _afjkx[_sbhic[3]] - _afjkx[_sbhic[4]]
_ST = 9960
elseif _biqyd == (-68 * 2 - 93 + 480) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]][_afjkx[_sbhic[3]]] = _afjkx[_sbhic[4]]
_ST = 9960
elseif _biqyd == (-94 * 2 - 28 + 290) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = _afjkx[_sbhic[3]]
_ST = 9960
elseif _biqyd == (11 * 2 - -72 + -86) then
-- no-op
_ST = 9960
elseif _biqyd == (14 * 2 - 54 + 158) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
                    local target_S = _afjkx
                    for i=1, _sbhic[3] do target_S = target_S.parent end
                    target_S[_sbhic[2]] = _afjkx[_sbhic[4]]
                
_ST = 9960
elseif _biqyd == (31 * 2 - -63 + 111) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_alqae[_njnjr[_sbhic[2]]] = _afjkx[_sbhic[3]]
_ST = 9960
elseif _biqyd == (87 * 2 - -40 + 14) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = _afjkx[_sbhic[3]] * _afjkx[_sbhic[4]]
_ST = 9960
elseif _biqyd == (-13 * 2 - -10 + 70) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
if not _afjkx[_sbhic[2]] then _buqam = _buqam + _sbhic[4] * _pghhl end
_ST = 9960
elseif _biqyd == (-84 * 2 - 90 + 281) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = _afjkx[_sbhic[3]] + _afjkx[_sbhic[4]]
_ST = 9960
elseif _biqyd == (121 * 2 - 22 + -147) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = _afjkx[_sbhic[3]][_afjkx[_sbhic[4]]]
_ST = 9960
elseif _biqyd == (8 * 2 - 66 + 70) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = -_afjkx[_sbhic[3]]
_ST = 9960
elseif _biqyd == (-26 * 2 - 125 + 228) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
local proto_src = _njnjr[_sbhic[3]]
                local p_func = loadstring(proto_src)
                if p_func then
                    local p = p_func()
                    _afjkx[_sbhic[2]] = function(...)
                        local new_S = {}
                        new_S.parent = _afjkx
                        return _vylwj(p.B, p.C, new_S, ...)
                    end
                end
_ST = 9960
elseif _biqyd == (95 * 2 - 25 + -34) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_buqam = _buqam + _sbhic[4] * _pghhl
_ST = 9960
elseif _biqyd == (0 * 2 - 79 + 101) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = _afjkx[_sbhic[3]] ~= _afjkx[_sbhic[4]]
_ST = 9960
elseif _biqyd == (67 * 2 - 83 + 25) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
local n = _sbhic[3] - 1; local t = {}; for i=0, n-1 do t[i+1] = _afjkx[_sbhic[2]+i] end; _ciwjj = t
_ST = 9960
elseif _biqyd == (-126 * 2 - 20 + 475) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
if _afjkx[_sbhic[2]] then _buqam = _buqam + _sbhic[4] * _pghhl end
_ST = 9960
elseif _biqyd == (-114 * 2 - -39 + 319) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
            local f = _afjkx[_sbhic[2]]
            if f then
                local nargs = _sbhic[3] - 1
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _afjkx[_sbhic[2] + i])
                end
                local results = { f(unpack(args)) }
                local nRes = _sbhic[4] - 1
                if nRes > 0 then
                    for i = 1, nRes do _afjkx[_sbhic[2] + i - 1] = results[i] end
                end
            end
_ST = 9960
elseif _biqyd == (-19 * 2 - -82 + 78) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]][_njnjr[_sbhic[3]]] = _afjkx[_sbhic[4]]
_ST = 9960
elseif _biqyd == (6 * 2 - -72 + 69) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = _afjkx[_sbhic[3]] <= _afjkx[_sbhic[4]]
_ST = 9960
elseif _biqyd == (33 * 2 - 23 + -28) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = _afjkx[_sbhic[3]][_njnjr[_sbhic[4]]]
_ST = 9960
elseif _biqyd == (48 * 2 - -109 + 41) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = {}
_ST = 9960
elseif _biqyd == (23 * 2 - -91 + -133) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = _afjkx[_sbhic[3]] / _afjkx[_sbhic[4]]
_ST = 9960
elseif _biqyd == (64 * 2 - -110 + -51) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
                    local target_S = _afjkx
                    for i=1, _sbhic[4] do target_S = target_S.parent end
                    _afjkx[_sbhic[2]] = target_S[_sbhic[3]]
                
_ST = 9960
elseif _biqyd == (-77 * 2 - 104 + 498) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = _afjkx[_sbhic[3]] == _afjkx[_sbhic[4]]
_ST = 9960
elseif _biqyd == (93 * 2 - 26 + -45) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _sbhic = { _biqyd, bit32.bxor(_rA, _sbogw), bit32.bxor(_rB, _sbogw), bit32.bxor(_rC, _sbogw) };
_afjkx[_sbhic[2]] = _afjkx[_sbhic[3]] < _afjkx[_sbhic[4]]
_ST = 9960
end
        elseif _ST == 9960 then
            _buqam = _buqam + _pghhl
            _ST = 9579
        end
    end
    return unpack(_ciwjj or {})
end
return _vylwj(_nmxwa, _qkrve, {}, ...)
