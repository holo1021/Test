--[[ Holon VM v5 Secure ]]
local _hpuzv = {1347506238,1347572055,1381126145,1347506750,1347638103,1381126657,1347440854}
local _wntrb = {{32,82,59,85,33},{24,119,27,116,26,58,108,33,1,85,48,67,55,13,45,197,112,199,34,169,60,218,82,194,39,173,50},{180,15,161,71,196,119,148,23,137,106,232,95,188,63,140,104,208,90,185,56,159,122,212,75,163,2,142,109,236,121,154,24,148,119,246,80,179,50,182,85,212,106,137,8,145,191,145,191}}
local _jgodl = 80
local function _beiqj(_hpuzv, _wntrb, ...)
    local _wtdoh, _efalc, _iflmx = 1, {}, getfenv() or _G
    local _args = {...}; for i=1, #_args do _efalc[i-1] = _args[i] end
    local _jmtcy = {}
    for i, v in ipairs(_wntrb) do
        local t = {}
        local last_byte = _jgodl -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _jmtcy[i] = table.concat(t)
    end

    local _frjno = nil

    local _pamnl = 1 -- Instruction Width
    local _ST = 1249
    local _IN, _sbkfl = 0, 0
    while _frjno == nil do
        if _ST == 1249 then
            if _wtdoh > #_hpuzv then _frjno = {} else
                _IN = _hpuzv[_wtdoh]
                _sbkfl = _IN % 256
                _ST = 5675
            end
        elseif _ST == 5675 then
            if _sbkfl == (-124 * 2 - 122 + 405) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
if _efalc[_cyplc[2]] then _wtdoh = _wtdoh + _cyplc[4] * _pamnl end
_ST = 1891
elseif _sbkfl == (3 * 2 - 46 + 245) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = _efalc[_cyplc[3]] ~= _efalc[_cyplc[4]]
_ST = 1891
elseif _sbkfl == (-113 * 2 - -13 + 392) then
-- no-op
_ST = 1891
elseif _sbkfl == (76 * 2 - -63 + 36) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]][_jmtcy[_cyplc[3]]] = _efalc[_cyplc[4]]
_ST = 1891
elseif _sbkfl == (81 * 2 - 4 + -8) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = _efalc[_cyplc[3]]
_ST = 1891
elseif _sbkfl == (-106 * 2 - 23 + 322) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = _jmtcy[_cyplc[3]]
_ST = 1891
elseif _sbkfl == (-81 * 2 - 95 + 299) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]][_efalc[_cyplc[3]]] = _efalc[_cyplc[4]]
_ST = 1891
elseif _sbkfl == (127 * 2 - -74 + -303) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = not _efalc[_cyplc[3]]
_ST = 1891
elseif _sbkfl == (86 * 2 - 0 + -17) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = _efalc[_cyplc[3]][_jmtcy[_cyplc[4]]]
_ST = 1891
elseif _sbkfl == (118 * 2 - 76 + 79) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
if not _efalc[_cyplc[2]] then _wtdoh = _wtdoh + _cyplc[4] * _pamnl end
_ST = 1891
elseif _sbkfl == (-102 * 2 - 15 + 281) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = _iflmx[_jmtcy[_cyplc[3]]]
_ST = 1891
elseif _sbkfl == (6 * 2 - 44 + 138) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = _efalc[_cyplc[3]] - _efalc[_cyplc[4]]
_ST = 1891
elseif _sbkfl == (-108 * 2 - 96 + 526) then
local n = _cyplc[3] - 1; local t = {}; for i=0, n-1 do t[i+1] = _efalc[_cyplc[2]+i] end; _frjno = t
_ST = 1891
elseif _sbkfl == (82 * 2 - 95 + 116) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = -_efalc[_cyplc[3]]
_ST = 1891
elseif _sbkfl == (5 * 2 - -99 + 133) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = _efalc[_cyplc[3]] + _efalc[_cyplc[4]]
_ST = 1891
elseif _sbkfl == (50 * 2 - 109 + 59) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = _efalc[_cyplc[3]] == _efalc[_cyplc[4]]
_ST = 1891
elseif _sbkfl == (-58 * 2 - 42 + 159) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
            local f = _efalc[_cyplc[2]]
            if f then
                local nargs = _cyplc[3] - 1
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _efalc[_cyplc[2] + i])
                end
                local results = { f(unpack(args)) }
                local nRes = _cyplc[4] - 1
                if nRes > 0 then
                    for i = 1, nRes do _efalc[_cyplc[2] + i - 1] = results[i] end
                end
            end
_ST = 1891
elseif _sbkfl == (-30 * 2 - 40 + 164) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = {}
_ST = 1891
elseif _sbkfl == (109 * 2 - -80 + -275) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = _efalc[_cyplc[3]][_efalc[_cyplc[4]]]
_ST = 1891
elseif _sbkfl == (72 * 2 - -54 + -34) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_wtdoh = _wtdoh + _cyplc[4] * _pamnl
_ST = 1891
elseif _sbkfl == (83 * 2 - 107 + -1) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = _efalc[_cyplc[3]] <= _efalc[_cyplc[4]]
_ST = 1891
elseif _sbkfl == (-76 * 2 - -35 + 257) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = _efalc[_cyplc[3]] * _efalc[_cyplc[4]]
_ST = 1891
elseif _sbkfl == (36 * 2 - 120 + 278) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
local proto_src = _jmtcy[_cyplc[3]]
                local p_func = loadstring(proto_src)
                if p_func then
                    local p = p_func() -- returns the Proto table
                    _efalc[_cyplc[2]] = function(...) return _beiqj(p.B, p.C, ...) end
                end
_ST = 1891
elseif _sbkfl == (-87 * 2 - -39 + 210) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_iflmx[_jmtcy[_cyplc[2]]] = _efalc[_cyplc[3]]
_ST = 1891
elseif _sbkfl == (23 * 2 - 53 + 23) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = _efalc[_cyplc[3]] / _efalc[_cyplc[4]]
_ST = 1891
elseif _sbkfl == (112 * 2 - -77 + -84) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cyplc = { _sbkfl, bit32.bxor(_rA, _jgodl), bit32.bxor(_rB, _jgodl), bit32.bxor(_rC, _jgodl) };
_efalc[_cyplc[2]] = _efalc[_cyplc[3]] < _efalc[_cyplc[4]]
_ST = 1891
end
        elseif _ST == 1891 then
            _wtdoh = _wtdoh + _pamnl
            _ST = 1249
        end
    end
end
return unpack(_frjno or {})
end
_beiqj(_hpuzv, _wntrb, ...)
