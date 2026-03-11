--[[ Holon VM v5 Secure ]]
local _ptuhr = {168495781,168299456,168495786,168495269,168364480,168495274,168430278}
local _ywbxw = {{122,8,97,15,123},{66,45,65,46,64,96,54,123,91,15,106,25,109,87,119,159,42,157,120,243,102,128,8,152,125,247,104},{238,85,251,29,158,45,206,77,211,48,178,5,230,101,214,50,138,0,227,98,197,32,142,17,249,88,212,55,182,35,192,66,206,45,172,10,233,104,236,15,142,48,211,82,203,229,203,229}}
local _nzfnb = 10
local function _rzcog(...)
    local _piqgo, _tsrko, _ombfg = 1, {}, getfenv() or _G
    local _nrcbg = {}
    for i, v in ipairs(_ywbxw) do
        local t = {}
        local last_byte = _nzfnb -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _nrcbg[i] = table.concat(t)
    end

    local _mhgqt = false

    local _ukwly = 1 -- Instruction Width
    while not _mhgqt and _piqgo <= #_ptuhr do
        local _IN = _ptuhr[_piqgo]
        local _mgfcb = _IN % 256
        
        if _mgfcb == (80 * 2 - 24 + -59) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cdxwm = { _mgfcb, bit32.bxor(_rA, _nzfnb), bit32.bxor(_rB, _nzfnb), bit32.bxor(_rC, _nzfnb) };
_tsrko[_cdxwm[2]] = _tsrko[_cdxwm[3]] * _tsrko[_cdxwm[4]]
elseif _mgfcb == (-37 * 2 - 121 + 255) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cdxwm = { _mgfcb, bit32.bxor(_rA, _nzfnb), bit32.bxor(_rB, _nzfnb), bit32.bxor(_rC, _nzfnb) };
_tsrko[_cdxwm[2]] = _tsrko[_cdxwm[3]] + _tsrko[_cdxwm[4]]
elseif _mgfcb == (-99 * 2 - -41 + 197) then
-- no-op
elseif _mgfcb == (-40 * 2 - 106 + 321) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cdxwm = { _mgfcb, bit32.bxor(_rA, _nzfnb), bit32.bxor(_rB, _nzfnb), bit32.bxor(_rC, _nzfnb) };
_tsrko[_cdxwm[2]] = _tsrko[_cdxwm[3]]
elseif _mgfcb == (25 * 2 - -84 + 85) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cdxwm = { _mgfcb, bit32.bxor(_rA, _nzfnb), bit32.bxor(_rB, _nzfnb), bit32.bxor(_rC, _nzfnb) };
_tsrko[_cdxwm[2]] = _tsrko[_cdxwm[3]] / _tsrko[_cdxwm[4]]
elseif _mgfcb == (29 * 2 - -117 + 56) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cdxwm = { _mgfcb, bit32.bxor(_rA, _nzfnb), bit32.bxor(_rB, _nzfnb), bit32.bxor(_rC, _nzfnb) };
if not _tsrko[_cdxwm[2]] then _piqgo = _piqgo + _cdxwm[4] * _ukwly end
elseif _mgfcb == (-34 * 2 - -108 + 152) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cdxwm = { _mgfcb, bit32.bxor(_rA, _nzfnb), bit32.bxor(_rB, _nzfnb), bit32.bxor(_rC, _nzfnb) };
_tsrko[_cdxwm[2]] = _nrcbg[_cdxwm[3]]
elseif _mgfcb == (63 * 2 - 61 + 105) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cdxwm = { _mgfcb, bit32.bxor(_rA, _nzfnb), bit32.bxor(_rB, _nzfnb), bit32.bxor(_rC, _nzfnb) };
            local f = _tsrko[_cdxwm[2]]
            if f then
                local nargs = _cdxwm[3]
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _tsrko[_cdxwm[2] + i])
                end
                f(unpack(args))
            end
elseif _mgfcb == (-39 * 2 - 45 + 288) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cdxwm = { _mgfcb, bit32.bxor(_rA, _nzfnb), bit32.bxor(_rB, _nzfnb), bit32.bxor(_rC, _nzfnb) };
_tsrko[_cdxwm[2]] = _ombfg[_nrcbg[_cdxwm[3]]]
elseif _mgfcb == (78 * 2 - -82 + -83) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cdxwm = { _mgfcb, bit32.bxor(_rA, _nzfnb), bit32.bxor(_rB, _nzfnb), bit32.bxor(_rC, _nzfnb) };
_piqgo = _piqgo + _cdxwm[4] * _ukwly
elseif _mgfcb == (97 * 2 - 8 + -75) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cdxwm = { _mgfcb, bit32.bxor(_rA, _nzfnb), bit32.bxor(_rB, _nzfnb), bit32.bxor(_rC, _nzfnb) };
_tsrko[_cdxwm[2]] = _tsrko[_cdxwm[3]] - _tsrko[_cdxwm[4]]
elseif _mgfcb == (-21 * 2 - -103 + 137) then
_mhgqt = true
elseif _mgfcb == (43 * 2 - -71 + 93) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _cdxwm = { _mgfcb, bit32.bxor(_rA, _nzfnb), bit32.bxor(_rB, _nzfnb), bit32.bxor(_rC, _nzfnb) };
_tsrko[_cdxwm[2]] = _tsrko[_cdxwm[3]] == _tsrko[_cdxwm[4]]
end
        
        _piqgo = _piqgo + _ukwly
    end
end
_rzcog(...)
