--[[ Holon VM v5 Secure ]]
local _zznls = {3233923315,3233988867,3233923270,3233923827,3234054915,3233923782,3233857562}
local _ktpfs = {{176,194,171,197,177},{136,231,139,228,138,170,252,177,145,197,160,211,167,157,189,85,224,87,178,57,172,74,194,82,183,61,162},{36,159,49,215,84,231,4,135,25,250,120,207,44,175,28,248,64,202,41,168,15,234,68,219,51,146,30,253,124,233,10,136,4,231,102,192,35,162,38,197,68,250,25,152,1,47,1,47}}
local _ydzeh = 192
local function _zprgv(_zznls, _ktpfs, ...)
    local _jwlqv, _vryrr, _okuzu = 1, {}, getfenv() or _G
    local _args = {...}; for i=1, #_args do _vryrr[i-1] = _args[i] end
    local _fbsis = {}
    for i, v in ipairs(_ktpfs) do
        local t = {}
        local last_byte = _ydzeh -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _fbsis[i] = table.concat(t)
    end

    local _ppyoz = false

    local _kpmlq = 1 -- Instruction Width
    local _ST = 4420
    local _IN, _iydvk = 0, 0
    while not _ppyoz do
        if _ST == 4420 then
            if _jwlqv > #_zznls then _ppyoz = true else
                _IN = _zznls[_jwlqv]
                _iydvk = _IN % 256
                _ST = 3824
            end
        elseif _ST == 3824 then
            if _iydvk == (22 * 2 - -35 + -44) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qgwde = { _iydvk, bit32.bxor(_rA, _ydzeh), bit32.bxor(_rB, _ydzeh), bit32.bxor(_rC, _ydzeh) };
_vryrr[_qgwde[2]] = _vryrr[_qgwde[3]]
_ST = 4571
elseif _iydvk == (-82 * 2 - -119 + 121) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qgwde = { _iydvk, bit32.bxor(_rA, _ydzeh), bit32.bxor(_rB, _ydzeh), bit32.bxor(_rC, _ydzeh) };
_jwlqv = _jwlqv + _qgwde[4] * _kpmlq
_ST = 4571
elseif _iydvk == (123 * 2 - -103 + -342) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qgwde = { _iydvk, bit32.bxor(_rA, _ydzeh), bit32.bxor(_rB, _ydzeh), bit32.bxor(_rC, _ydzeh) };
_vryrr[_qgwde[2]] = _vryrr[_qgwde[3]] + _vryrr[_qgwde[4]]
_ST = 4571
elseif _iydvk == (31 * 2 - 86 + 111) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qgwde = { _iydvk, bit32.bxor(_rA, _ydzeh), bit32.bxor(_rB, _ydzeh), bit32.bxor(_rC, _ydzeh) };
_vryrr[_qgwde[2]] = _vryrr[_qgwde[3]][_fbsis[_qgwde[4]]]
_ST = 4571
elseif _iydvk == (-10 * 2 - -106 + 81) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qgwde = { _iydvk, bit32.bxor(_rA, _ydzeh), bit32.bxor(_rB, _ydzeh), bit32.bxor(_rC, _ydzeh) };
_vryrr[_qgwde[2]] = _vryrr[_qgwde[3]] * _vryrr[_qgwde[4]]
_ST = 4571
elseif _iydvk == (-59 * 2 - 14 + 330) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qgwde = { _iydvk, bit32.bxor(_rA, _ydzeh), bit32.bxor(_rB, _ydzeh), bit32.bxor(_rC, _ydzeh) };
            local f = _vryrr[_qgwde[2]]
            if f then
                local nargs = _qgwde[3]
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _vryrr[_qgwde[2] + i])
                end
                f(unpack(args))
            end
_ST = 4571
elseif _iydvk == (-31 * 2 - -48 + 184) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qgwde = { _iydvk, bit32.bxor(_rA, _ydzeh), bit32.bxor(_rB, _ydzeh), bit32.bxor(_rC, _ydzeh) };
_vryrr[_qgwde[2]] = _vryrr[_qgwde[3]] == _vryrr[_qgwde[4]]
_ST = 4571
elseif _iydvk == (124 * 2 - -16 + -83) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qgwde = { _iydvk, bit32.bxor(_rA, _ydzeh), bit32.bxor(_rB, _ydzeh), bit32.bxor(_rC, _ydzeh) };
local proto_src = _fbsis[_qgwde[3]]
                local p_func = loadstring(proto_src)
                if p_func then
                    local p = p_func() -- returns the Proto table
                    _vryrr[_qgwde[2]] = function(...) return _zprgv(p.B, p.C, ...) end
                end
_ST = 4571
elseif _iydvk == (-53 * 2 - -120 + 147) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qgwde = { _iydvk, bit32.bxor(_rA, _ydzeh), bit32.bxor(_rB, _ydzeh), bit32.bxor(_rC, _ydzeh) };
if not _vryrr[_qgwde[2]] then _jwlqv = _jwlqv + _qgwde[4] * _kpmlq end
_ST = 4571
elseif _iydvk == (-77 * 2 - 61 + 349) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qgwde = { _iydvk, bit32.bxor(_rA, _ydzeh), bit32.bxor(_rB, _ydzeh), bit32.bxor(_rC, _ydzeh) };
_vryrr[_qgwde[2]][_fbsis[_qgwde[3]]] = _vryrr[_qgwde[4]]
_ST = 4571
elseif _iydvk == (23 * 2 - 101 + 298) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qgwde = { _iydvk, bit32.bxor(_rA, _ydzeh), bit32.bxor(_rB, _ydzeh), bit32.bxor(_rC, _ydzeh) };
_vryrr[_qgwde[2]] = _okuzu[_fbsis[_qgwde[3]]]
_ST = 4571
elseif _iydvk == (94 * 2 - 15 + 62) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qgwde = { _iydvk, bit32.bxor(_rA, _ydzeh), bit32.bxor(_rB, _ydzeh), bit32.bxor(_rC, _ydzeh) };
_vryrr[_qgwde[2]] = _vryrr[_qgwde[3]] - _vryrr[_qgwde[4]]
_ST = 4571
elseif _iydvk == (-47 * 2 - -82 + 38) then
_ppyoz = true
_ST = 4571
elseif _iydvk == (4 * 2 - 49 + 44) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qgwde = { _iydvk, bit32.bxor(_rA, _ydzeh), bit32.bxor(_rB, _ydzeh), bit32.bxor(_rC, _ydzeh) };
_vryrr[_qgwde[2]] = _fbsis[_qgwde[3]]
_ST = 4571
elseif _iydvk == (59 * 2 - -24 + -32) then
-- no-op
_ST = 4571
elseif _iydvk == (120 * 2 - 30 + 45) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qgwde = { _iydvk, bit32.bxor(_rA, _ydzeh), bit32.bxor(_rB, _ydzeh), bit32.bxor(_rC, _ydzeh) };
_vryrr[_qgwde[2]] = _vryrr[_qgwde[3]] / _vryrr[_qgwde[4]]
_ST = 4571
end
        elseif _ST == 4571 then
            _jwlqv = _jwlqv + _kpmlq
            _ST = 4420
        end
    end
end
_zprgv(_zznls, _ktpfs, ...)
