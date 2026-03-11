--[[ Holon VM v5 Secure ]]
local _kdspt = {116,28,29,28,236,29,30,28,91,28,29,28,116,30,29,28,236,31,31,28,91,30,29,28,160,28,28,28}
local _rimoe = {{108,30,119,25,109},{84,59,87,56,86,118,32,109,77,25,124,15,123,65,97,137,60,139,110,229,112,150,30,142,107,225,126},{248,67,237,11,136,59,216,91,197,38,164,19,240,115,192,36,156,22,245,116,211,54,152,7,239,78,194,33,160,53,214,84,216,59,186,28,255,126,250,25,152,38,197,68,221,243,221,243}}
local _sdprt = 28
local function _cgzxh(...)
    local _rdxfb, _dtslm, _hmhxj = 1, {}, getfenv() or _G
    local _bupuj = {}
    for i, v in ipairs(_rimoe) do
        local s = ""
        local last_byte = _sdprt -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            s = s .. string.char(dec_byte)
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _bupuj[i] = s
    end

    local _pfiwq = false

    local _lmjmt = 4 -- Instruction Width
    while not _pfiwq and _rdxfb <= #_kdspt do
        local _qlvsc = _kdspt[_rdxfb]
        
        if _qlvsc == (43 * 2 - -72 + -24) then
local _vnkfg = { _qlvsc, bit32.bxor(_kdspt[_rdxfb+1], _sdprt), bit32.bxor(_kdspt[_rdxfb+2], _sdprt), bit32.bxor(_kdspt[_rdxfb+3], _sdprt) };
_dtslm[_vnkfg[2]] = _dtslm[_vnkfg[3]] == _dtslm[_vnkfg[4]]
elseif _qlvsc == (39 * 2 - -31 + -20) then
-- no-op
elseif _qlvsc == (81 * 2 - -11 + -57) then
local _vnkfg = { _qlvsc, bit32.bxor(_kdspt[_rdxfb+1], _sdprt), bit32.bxor(_kdspt[_rdxfb+2], _sdprt), bit32.bxor(_kdspt[_rdxfb+3], _sdprt) };
_dtslm[_vnkfg[2]] = _hmhxj[_bupuj[_vnkfg[3]]]
elseif _qlvsc == (30 * 2 - 127 + 190) then
local _vnkfg = { _qlvsc, bit32.bxor(_kdspt[_rdxfb+1], _sdprt), bit32.bxor(_kdspt[_rdxfb+2], _sdprt), bit32.bxor(_kdspt[_rdxfb+3], _sdprt) };
_dtslm[_vnkfg[2]] = _dtslm[_vnkfg[3]] + _dtslm[_vnkfg[4]]
elseif _qlvsc == (-115 * 2 - -69 + 397) then
local _vnkfg = { _qlvsc, bit32.bxor(_kdspt[_rdxfb+1], _sdprt), bit32.bxor(_kdspt[_rdxfb+2], _sdprt), bit32.bxor(_kdspt[_rdxfb+3], _sdprt) };
_dtslm[_vnkfg[2]] = _bupuj[_vnkfg[3]]
elseif _qlvsc == (-75 * 2 - 8 + 249) then
local _vnkfg = { _qlvsc, bit32.bxor(_kdspt[_rdxfb+1], _sdprt), bit32.bxor(_kdspt[_rdxfb+2], _sdprt), bit32.bxor(_kdspt[_rdxfb+3], _sdprt) };
            local f = _dtslm[_vnkfg[2]]
            if f then
                local nargs = _vnkfg[3]
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _dtslm[_vnkfg[2] + i])
                end
                f(unpack(args))
            end
elseif _qlvsc == (-55 * 2 - -17 + 253) then
_pfiwq = true
elseif _qlvsc == (-122 * 2 - -86 + 197) then
local _vnkfg = { _qlvsc, bit32.bxor(_kdspt[_rdxfb+1], _sdprt), bit32.bxor(_kdspt[_rdxfb+2], _sdprt), bit32.bxor(_kdspt[_rdxfb+3], _sdprt) };
_dtslm[_vnkfg[2]] = _dtslm[_vnkfg[3]] / _dtslm[_vnkfg[4]]
elseif _qlvsc == (-96 * 2 - -5 + 429) then
local _vnkfg = { _qlvsc, bit32.bxor(_kdspt[_rdxfb+1], _sdprt), bit32.bxor(_kdspt[_rdxfb+2], _sdprt), bit32.bxor(_kdspt[_rdxfb+3], _sdprt) };
_dtslm[_vnkfg[2]] = _dtslm[_vnkfg[3]]
elseif _qlvsc == (-57 * 2 - 87 + 427) then
local _vnkfg = { _qlvsc, bit32.bxor(_kdspt[_rdxfb+1], _sdprt), bit32.bxor(_kdspt[_rdxfb+2], _sdprt), bit32.bxor(_kdspt[_rdxfb+3], _sdprt) };
if not _dtslm[_vnkfg[2]] then _rdxfb = _rdxfb + _vnkfg[4] * _lmjmt end
elseif _qlvsc == (-88 * 2 - -97 + 180) then
local _vnkfg = { _qlvsc, bit32.bxor(_kdspt[_rdxfb+1], _sdprt), bit32.bxor(_kdspt[_rdxfb+2], _sdprt), bit32.bxor(_kdspt[_rdxfb+3], _sdprt) };
_rdxfb = _rdxfb + _vnkfg[4] * _lmjmt
elseif _qlvsc == (-88 * 2 - 19 + 430) then
local _vnkfg = { _qlvsc, bit32.bxor(_kdspt[_rdxfb+1], _sdprt), bit32.bxor(_kdspt[_rdxfb+2], _sdprt), bit32.bxor(_kdspt[_rdxfb+3], _sdprt) };
_dtslm[_vnkfg[2]] = _dtslm[_vnkfg[3]] - _dtslm[_vnkfg[4]]
elseif _qlvsc == (114 * 2 - 36 + -175) then
local _vnkfg = { _qlvsc, bit32.bxor(_kdspt[_rdxfb+1], _sdprt), bit32.bxor(_kdspt[_rdxfb+2], _sdprt), bit32.bxor(_kdspt[_rdxfb+3], _sdprt) };
_dtslm[_vnkfg[2]] = _dtslm[_vnkfg[3]] * _dtslm[_vnkfg[4]]
end
        
        _rdxfb = _rdxfb + _lmjmt
    end
end
_cgzxh(...)
