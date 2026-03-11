--[[ Holon VM v5 Secure ]]
local _kzexm = {1330532204,1330466428,1296912274,1330531692,1330597804,1330400380,1296911762,1330597808}
local _yvmoo = {{63,77,36,74,62},{7,104,4,107,5,37,115,62,30,74,47,92,40,18,50,218,111,216,61,182,35,197,77,221,56,178,45},{171,16,190,88,219,104,139,8,150,117,247,64,163,32,147,119,207,69,166,39,128,101,203,84,188,29,145,114,243,102,133,7,139,104,233,79,172,45,169,74,203,117,150,23,142,160,142,160}}
local _juxdm = 79
local function _lhnrf(_kzexm, _yvmoo, ...)
    local _cyibs, _bkvrs, _bwnde = 1, {}, getfenv() or _G
    local _args = {...}; for i=1, #_args do _bkvrs[i-1] = _args[i] end
    local _bgsmk = {}
    for i, v in ipairs(_yvmoo) do
        local t = {}
        local last_byte = _juxdm -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _bgsmk[i] = table.concat(t)
    end

    local _ylutu = nil

    local _ldeaf = 1 -- Instruction Width
    local _ST = 4103
    local _IN, _oaihq = 0, 0
    while _ylutu == nil do
        if _ST == 4103 then
            if _cyibs > #_kzexm then _ylutu = {} else
                _IN = _kzexm[_cyibs]
                _oaihq = _IN % 256
                _ST = 7912
            end
        elseif _ST == 7912 then
            if _oaihq == (15 * 2 - 55 + 197) then
-- no-op
_ST = 5287
elseif _oaihq == (-98 * 2 - -73 + 147) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = _bkvrs[_gdsmj[3]] - _bkvrs[_gdsmj[4]]
_ST = 5287
elseif _oaihq == (116 * 2 - 27 + -97) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = _bwnde[_bgsmk[_gdsmj[3]]]
_ST = 5287
elseif _oaihq == (86 * 2 - 96 + 48) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = _bgsmk[_gdsmj[3]]
_ST = 5287
elseif _oaihq == (-14 * 2 - -32 + 172) then
local n = _gdsmj[3] - 1; local t = {}; for i=0, n-1 do t[i+1] = _bkvrs[_gdsmj[2]+i] end; _ylutu = t
_ST = 5287
elseif _oaihq == (-93 * 2 - 29 + 384) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = _bkvrs[_gdsmj[3]] ~= _bkvrs[_gdsmj[4]]
_ST = 5287
elseif _oaihq == (102 * 2 - -48 + -187) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = _bkvrs[_gdsmj[3]] <= _bkvrs[_gdsmj[4]]
_ST = 5287
elseif _oaihq == (24 * 2 - 19 + 120) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
local proto_src = _bgsmk[_gdsmj[3]]
                local p_func = loadstring(proto_src)
                if p_func then
                    local p = p_func() -- returns the Proto table
                    _bkvrs[_gdsmj[2]] = function(...) return _lhnrf(p.B, p.C, ...) end
                end
_ST = 5287
elseif _oaihq == (55 * 2 - -73 + -28) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = _bkvrs[_gdsmj[3]]
_ST = 5287
elseif _oaihq == (-5 * 2 - 107 + 168) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
if _bkvrs[_gdsmj[2]] then _cyibs = _cyibs + _gdsmj[4] * _ldeaf end
_ST = 5287
elseif _oaihq == (113 * 2 - 113 + 49) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = not _bkvrs[_gdsmj[3]]
_ST = 5287
elseif _oaihq == (86 * 2 - -35 + -60) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = _bkvrs[_gdsmj[3]] + _bkvrs[_gdsmj[4]]
_ST = 5287
elseif _oaihq == (50 * 2 - 9 + 55) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
            local f = _bkvrs[_gdsmj[2]]
            if f then
                local nargs = _gdsmj[3] - 1
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _bkvrs[_gdsmj[2] + i])
                end
                local results = { f(unpack(args)) }
                local nRes = _gdsmj[4] - 1
                if nRes > 0 then
                    for i = 1, nRes do _bkvrs[_gdsmj[2] + i - 1] = results[i] end
                end
            end
_ST = 5287
elseif _oaihq == (-50 * 2 - -96 + 172) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = _bkvrs[_gdsmj[3]] == _bkvrs[_gdsmj[4]]
_ST = 5287
elseif _oaihq == (96 * 2 - -102 + -275) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = _bkvrs[_gdsmj[3]] * _bkvrs[_gdsmj[4]]
_ST = 5287
elseif _oaihq == (14 * 2 - 102 + 270) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = _bkvrs[_gdsmj[3]] / _bkvrs[_gdsmj[4]]
_ST = 5287
elseif _oaihq == (20 * 2 - 43 + 99) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = _bkvrs[_gdsmj[3]][_bgsmk[_gdsmj[4]]]
_ST = 5287
elseif _oaihq == (54 * 2 - -65 + -83) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_cyibs = _cyibs + _gdsmj[4] * _ldeaf
_ST = 5287
elseif _oaihq == (-118 * 2 - -37 + 293) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
if not _bkvrs[_gdsmj[2]] then _cyibs = _cyibs + _gdsmj[4] * _ldeaf end
_ST = 5287
elseif _oaihq == (-1 * 2 - -125 + 94) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]][_bgsmk[_gdsmj[3]]] = _bkvrs[_gdsmj[4]]
_ST = 5287
elseif _oaihq == (-79 * 2 - 83 + 259) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = -_bkvrs[_gdsmj[3]]
_ST = 5287
elseif _oaihq == (-82 * 2 - 126 + 346) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bwnde[_bgsmk[_gdsmj[2]]] = _bkvrs[_gdsmj[3]]
_ST = 5287
elseif _oaihq == (40 * 2 - -88 + 27) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = _bkvrs[_gdsmj[3]] < _bkvrs[_gdsmj[4]]
_ST = 5287
elseif _oaihq == (104 * 2 - -123 + -245) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = _bkvrs[_gdsmj[3]][_bkvrs[_gdsmj[4]]]
_ST = 5287
elseif _oaihq == (27 * 2 - -15 + -48) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]] = {}
_ST = 5287
elseif _oaihq == (-32 * 2 - -83 + 144) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _gdsmj = { _oaihq, bit32.bxor(_rA, _juxdm), bit32.bxor(_rB, _juxdm), bit32.bxor(_rC, _juxdm) };
_bkvrs[_gdsmj[2]][_bkvrs[_gdsmj[3]]] = _bkvrs[_gdsmj[4]]
_ST = 5287
end
        elseif _ST == 5287 then
            _cyibs = _cyibs + _ldeaf
            _ST = 4103
        end
    end
    return unpack(_ylutu or {})
end
return _lhnrf(_kzexm, _yvmoo, ...)
