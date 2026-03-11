--[[ Holon VM v5 Secure ]]
local _iclwm = {1650680325,1650484082,1650680437,1650679813,1650549106,1650679925,1650614868}
local _nwvjo = {{18,96,9,103,19},{42,69,41,70,40,8,94,19,51,103,2,113,5,63,31,247,66,245,16,155,14,232,96,240,21,159,0},{134,61,147,117,246,69,166,37,187,88,218,109,142,13,190,90,226,104,139,10,173,72,230,121,145,48,188,95,222,75,168,42,166,69,196,98,129,0,132,103,230,88,187,58,163,141,163,141}}
local _jydbf = 98
local function _mrhlu(...)
    local _rcbjk, _mjxob, _hbrqq = 1, {}, getfenv() or _G
    local _ngkzz = {}
    for i, v in ipairs(_nwvjo) do
        local t = {}
        local last_byte = _jydbf -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _ngkzz[i] = table.concat(t)
    end

    local _ihonm = false

    local _hxlwp = 1 -- Instruction Width
    local _ST = 5204
    local _IN, _nuvlt = 0, 0
    while not _ihonm do
        if _ST == 5204 then
            if _rcbjk > #_iclwm then _ihonm = true else
                _IN = _iclwm[_rcbjk]
                _nuvlt = _IN % 256
                _ST = 2937
            end
        elseif _ST == 2937 then
            if _nuvlt == (-85 * 2 - -14 + 161) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bitrq = { _nuvlt, bit32.bxor(_rA, _jydbf), bit32.bxor(_rB, _jydbf), bit32.bxor(_rC, _jydbf) };
_mjxob[_bitrq[2]] = _hbrqq[_ngkzz[_bitrq[3]]]
_ST = 8568
elseif _nuvlt == (-23 * 2 - -36 + 127) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bitrq = { _nuvlt, bit32.bxor(_rA, _jydbf), bit32.bxor(_rB, _jydbf), bit32.bxor(_rC, _jydbf) };
            local f = _mjxob[_bitrq[2]]
            if f then
                local nargs = _bitrq[3]
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _mjxob[_bitrq[2] + i])
                end
                f(unpack(args))
            end
_ST = 8568
elseif _nuvlt == (-41 * 2 - 92 + 277) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bitrq = { _nuvlt, bit32.bxor(_rA, _jydbf), bit32.bxor(_rB, _jydbf), bit32.bxor(_rC, _jydbf) };
_mjxob[_bitrq[2]] = _mjxob[_bitrq[3]] == _mjxob[_bitrq[4]]
_ST = 8568
elseif _nuvlt == (88 * 2 - -116 + -178) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bitrq = { _nuvlt, bit32.bxor(_rA, _jydbf), bit32.bxor(_rB, _jydbf), bit32.bxor(_rC, _jydbf) };
_mjxob[_bitrq[2]] = _ngkzz[_bitrq[3]]
_ST = 8568
elseif _nuvlt == (-63 * 2 - -94 + 277) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bitrq = { _nuvlt, bit32.bxor(_rA, _jydbf), bit32.bxor(_rB, _jydbf), bit32.bxor(_rC, _jydbf) };
if not _mjxob[_bitrq[2]] then _rcbjk = _rcbjk + _bitrq[4] * _hxlwp end
_ST = 8568
elseif _nuvlt == (-103 * 2 - 45 + 273) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bitrq = { _nuvlt, bit32.bxor(_rA, _jydbf), bit32.bxor(_rB, _jydbf), bit32.bxor(_rC, _jydbf) };
_rcbjk = _rcbjk + _bitrq[4] * _hxlwp
_ST = 8568
elseif _nuvlt == (113 * 2 - -96 + -238) then
_ihonm = true
_ST = 8568
elseif _nuvlt == (58 * 2 - -100 + -187) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bitrq = { _nuvlt, bit32.bxor(_rA, _jydbf), bit32.bxor(_rB, _jydbf), bit32.bxor(_rC, _jydbf) };
_mjxob[_bitrq[2]][_ngkzz[_bitrq[3]]] = _mjxob[_bitrq[4]]
_ST = 8568
elseif _nuvlt == (64 * 2 - 74 + 56) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bitrq = { _nuvlt, bit32.bxor(_rA, _jydbf), bit32.bxor(_rB, _jydbf), bit32.bxor(_rC, _jydbf) };
_mjxob[_bitrq[2]] = _mjxob[_bitrq[3]] * _mjxob[_bitrq[4]]
_ST = 8568
elseif _nuvlt == (90 * 2 - -104 + -131) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bitrq = { _nuvlt, bit32.bxor(_rA, _jydbf), bit32.bxor(_rB, _jydbf), bit32.bxor(_rC, _jydbf) };
_mjxob[_bitrq[2]] = _mjxob[_bitrq[3]] + _mjxob[_bitrq[4]]
_ST = 8568
elseif _nuvlt == (45 * 2 - -81 + -82) then
-- no-op
_ST = 8568
elseif _nuvlt == (-21 * 2 - -98 + 59) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bitrq = { _nuvlt, bit32.bxor(_rA, _jydbf), bit32.bxor(_rB, _jydbf), bit32.bxor(_rC, _jydbf) };
_mjxob[_bitrq[2]] = _mjxob[_bitrq[3]] - _mjxob[_bitrq[4]]
_ST = 8568
elseif _nuvlt == (99 * 2 - 6 + -186) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bitrq = { _nuvlt, bit32.bxor(_rA, _jydbf), bit32.bxor(_rB, _jydbf), bit32.bxor(_rC, _jydbf) };
_mjxob[_bitrq[2]] = _mjxob[_bitrq[3]]
_ST = 8568
elseif _nuvlt == (42 * 2 - 86 + 195) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bitrq = { _nuvlt, bit32.bxor(_rA, _jydbf), bit32.bxor(_rB, _jydbf), bit32.bxor(_rC, _jydbf) };
_mjxob[_bitrq[2]] = _mjxob[_bitrq[3]] / _mjxob[_bitrq[4]]
_ST = 8568
elseif _nuvlt == (-113 * 2 - -39 + 375) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _bitrq = { _nuvlt, bit32.bxor(_rA, _jydbf), bit32.bxor(_rB, _jydbf), bit32.bxor(_rC, _jydbf) };
_mjxob[_bitrq[2]] = _mjxob[_bitrq[3]][_ngkzz[_bitrq[4]]]
_ST = 8568
end
        elseif _ST == 8568 then
            _rcbjk = _rcbjk + _hxlwp
            _ST = 5204
        end
    end
end
_mrhlu(...)
