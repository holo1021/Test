--[[ Holon VM v5 Secure ]]
local _sfddf = {3048519074,3048715335,3048519017,3048519586,3048650311,3048519529,3048584631}
local _qoecf = {{197,183,222,176,196},{253,146,254,145,255,223,137,196,228,176,213,166,210,232,200,32,149,34,199,76,217,63,183,39,194,72,215},{81,234,68,162,33,146,113,242,108,143,13,186,89,218,105,141,53,191,92,221,122,159,49,174,70,231,107,136,9,156,127,253,113,146,19,181,86,215,83,176,49,143,108,237,116,90,116,90}}
local _jgakx = 181
local function _ifbow(...)
    local _sfdtf, _sepoh, _occqv = 1, {}, getfenv() or _G
    local _ekrag = {}
    for i, v in ipairs(_qoecf) do
        local s = ""
        local last_byte = _jgakx -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            s = s .. string.char(dec_byte)
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _ekrag[i] = s
    end

    local _xkyqq = false

    local _jmshb = 1 -- Instruction Width
    while not _xkyqq and _sfdtf <= #_sfddf do
        local _IN = _sfddf[_sfdtf]
        local _qfbev = _IN % 256
        
        if _qfbev == (17 * 2 - -34 + 37) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _petuf = { _qfbev, bit32.bxor(_rA, _jgakx), bit32.bxor(_rB, _jgakx), bit32.bxor(_rC, _jgakx) };
            local f = _sepoh[_petuf[2]]
            if f then
                local nargs = _petuf[3]
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _sepoh[_petuf[2] + i])
                end
                f(unpack(args))
            end
elseif _qfbev == (-118 * 2 - 14 + 315) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _petuf = { _qfbev, bit32.bxor(_rA, _jgakx), bit32.bxor(_rB, _jgakx), bit32.bxor(_rC, _jgakx) };
_sfdtf = _sfdtf + _petuf[4] * _jmshb
elseif _qfbev == (47 * 2 - 111 + 49) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _petuf = { _qfbev, bit32.bxor(_rA, _jgakx), bit32.bxor(_rB, _jgakx), bit32.bxor(_rC, _jgakx) };
_sepoh[_petuf[2]] = _sepoh[_petuf[3]] - _sepoh[_petuf[4]]
elseif _qfbev == (29 * 2 - 23 + 167) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _petuf = { _qfbev, bit32.bxor(_rA, _jgakx), bit32.bxor(_rB, _jgakx), bit32.bxor(_rC, _jgakx) };
_sepoh[_petuf[2]] = _sepoh[_petuf[3]]
elseif _qfbev == (111 * 2 - -13 + -73) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _petuf = { _qfbev, bit32.bxor(_rA, _jgakx), bit32.bxor(_rB, _jgakx), bit32.bxor(_rC, _jgakx) };
_sepoh[_petuf[2]] = _occqv[_ekrag[_petuf[3]]]
elseif _qfbev == (82 * 2 - 74 + -43) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _petuf = { _qfbev, bit32.bxor(_rA, _jgakx), bit32.bxor(_rB, _jgakx), bit32.bxor(_rC, _jgakx) };
_sepoh[_petuf[2]] = _sepoh[_petuf[3]] + _sepoh[_petuf[4]]
elseif _qfbev == (38 * 2 - -73 + 34) then
_xkyqq = true
elseif _qfbev == (107 * 2 - -51 + -74) then
-- no-op
elseif _qfbev == (-62 * 2 - -87 + 289) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _petuf = { _qfbev, bit32.bxor(_rA, _jgakx), bit32.bxor(_rB, _jgakx), bit32.bxor(_rC, _jgakx) };
_sepoh[_petuf[2]] = _sepoh[_petuf[3]] / _sepoh[_petuf[4]]
elseif _qfbev == (47 * 2 - -51 + 58) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _petuf = { _qfbev, bit32.bxor(_rA, _jgakx), bit32.bxor(_rB, _jgakx), bit32.bxor(_rC, _jgakx) };
if not _sepoh[_petuf[2]] then _sfdtf = _sfdtf + _petuf[4] * _jmshb end
elseif _qfbev == (-92 * 2 - -53 + 174) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _petuf = { _qfbev, bit32.bxor(_rA, _jgakx), bit32.bxor(_rB, _jgakx), bit32.bxor(_rC, _jgakx) };
_sepoh[_petuf[2]] = _sepoh[_petuf[3]] == _sepoh[_petuf[4]]
elseif _qfbev == (-96 * 2 - 122 + 511) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _petuf = { _qfbev, bit32.bxor(_rA, _jgakx), bit32.bxor(_rB, _jgakx), bit32.bxor(_rC, _jgakx) };
_sepoh[_petuf[2]] = _sepoh[_petuf[3]] * _sepoh[_petuf[4]]
elseif _qfbev == (61 * 2 - -33 + -84) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _petuf = { _qfbev, bit32.bxor(_rA, _jgakx), bit32.bxor(_rB, _jgakx), bit32.bxor(_rC, _jgakx) };
_sepoh[_petuf[2]] = _ekrag[_petuf[3]]
end
        
        _sfdtf = _sfdtf + _jmshb
    end
end
_ifbow(...)
