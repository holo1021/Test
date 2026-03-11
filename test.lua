--[[ Holon VM v5 Secure ]]
local _zczcq = {858927917,858862242,858928121,858927405,858796194,858927609,858993470,858993601}
local _jlffn = {{67,49,88,54,66},{123,20,120,23,121,89,15,66,98,54,83,32,84,110,78,166,19,164,65,202,95,185,49,161,68,206,81},{215,108,194,36,167,20,247,116,234,9,139,60,223,92,239,11,179,57,218,91,252,25,183,40,192,97,237,14,143,26,249,123,247,20,149,51,208,81,213,54,183,9,234,107,242,220,242,220}}
local _zxymt = 51
local function _wvpla(...)
    local _salie, _xnald, _zvbuf = 1, {}, getfenv() or _G
    local _hlsmg = {}
    for i, v in ipairs(_jlffn) do
        local t = {}
        local last_byte = _zxymt -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _hlsmg[i] = table.concat(t)
    end

    local _jmiyu = false

    local _wdvhq = 1 -- Instruction Width
    while not _jmiyu and _salie <= #_zczcq do
        local _IN = _zczcq[_salie]
        local _rvgvq = _IN % 256
        
        if _rvgvq == (67 * 2 - -38 + 69) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ribiz = { _rvgvq, bit32.bxor(_rA, _zxymt), bit32.bxor(_rB, _zxymt), bit32.bxor(_rC, _zxymt) };
_xnald[_ribiz[2]] = _xnald[_ribiz[3]][_hlsmg[_ribiz[4]]]
elseif _rvgvq == (40 * 2 - -74 + 95) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ribiz = { _rvgvq, bit32.bxor(_rA, _zxymt), bit32.bxor(_rB, _zxymt), bit32.bxor(_rC, _zxymt) };
            local f = _xnald[_ribiz[2]]
            if f then
                local nargs = _ribiz[3]
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _xnald[_ribiz[2] + i])
                end
                f(unpack(args))
            end
elseif _rvgvq == (-57 * 2 - 16 + 174) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ribiz = { _rvgvq, bit32.bxor(_rA, _zxymt), bit32.bxor(_rB, _zxymt), bit32.bxor(_rC, _zxymt) };
_xnald[_ribiz[2]][_hlsmg[_ribiz[3]]] = _xnald[_ribiz[4]]
elseif _rvgvq == (91 * 2 - 72 + 52) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ribiz = { _rvgvq, bit32.bxor(_rA, _zxymt), bit32.bxor(_rB, _zxymt), bit32.bxor(_rC, _zxymt) };
_xnald[_ribiz[2]] = _hlsmg[_ribiz[3]]
elseif _rvgvq == (31 * 2 - 33 + 157) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ribiz = { _rvgvq, bit32.bxor(_rA, _zxymt), bit32.bxor(_rB, _zxymt), bit32.bxor(_rC, _zxymt) };
_salie = _salie + _ribiz[4] * _wdvhq
elseif _rvgvq == (-21 * 2 - -63 + 172) then
-- no-op
elseif _rvgvq == (19 * 2 - 19 + 110) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ribiz = { _rvgvq, bit32.bxor(_rA, _zxymt), bit32.bxor(_rB, _zxymt), bit32.bxor(_rC, _zxymt) };
_xnald[_ribiz[2]] = _xnald[_ribiz[3]] + _xnald[_ribiz[4]]
elseif _rvgvq == (38 * 2 - -11 + 2) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ribiz = { _rvgvq, bit32.bxor(_rA, _zxymt), bit32.bxor(_rB, _zxymt), bit32.bxor(_rC, _zxymt) };
_xnald[_ribiz[2]] = _xnald[_ribiz[3]] == _xnald[_ribiz[4]]
elseif _rvgvq == (121 * 2 - 82 + 42) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ribiz = { _rvgvq, bit32.bxor(_rA, _zxymt), bit32.bxor(_rB, _zxymt), bit32.bxor(_rC, _zxymt) };
_xnald[_ribiz[2]] = _xnald[_ribiz[3]] / _xnald[_ribiz[4]]
elseif _rvgvq == (-85 * 2 - -74 + 233) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ribiz = { _rvgvq, bit32.bxor(_rA, _zxymt), bit32.bxor(_rB, _zxymt), bit32.bxor(_rC, _zxymt) };
_xnald[_ribiz[2]] = _xnald[_ribiz[3]] * _xnald[_ribiz[4]]
elseif _rvgvq == (-86 * 2 - -31 + 333) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ribiz = { _rvgvq, bit32.bxor(_rA, _zxymt), bit32.bxor(_rB, _zxymt), bit32.bxor(_rC, _zxymt) };
_xnald[_ribiz[2]] = _xnald[_ribiz[3]] - _xnald[_ribiz[4]]
elseif _rvgvq == (38 * 2 - -86 + 34) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ribiz = { _rvgvq, bit32.bxor(_rA, _zxymt), bit32.bxor(_rB, _zxymt), bit32.bxor(_rC, _zxymt) };
_xnald[_ribiz[2]] = _xnald[_ribiz[3]]
elseif _rvgvq == (105 * 2 - 43 + -122) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ribiz = { _rvgvq, bit32.bxor(_rA, _zxymt), bit32.bxor(_rB, _zxymt), bit32.bxor(_rC, _zxymt) };
_xnald[_ribiz[2]] = _zvbuf[_hlsmg[_ribiz[3]]]
elseif _rvgvq == (-65 * 2 - -70 + 122) then
_jmiyu = true
elseif _rvgvq == (84 * 2 - -21 + 34) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ribiz = { _rvgvq, bit32.bxor(_rA, _zxymt), bit32.bxor(_rB, _zxymt), bit32.bxor(_rC, _zxymt) };
if not _xnald[_ribiz[2]] then _salie = _salie + _ribiz[4] * _wdvhq end
end
        
        _salie = _salie + _wdvhq
    end
end
_wvpla(...)
