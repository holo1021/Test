--[[ Holon VM v5 Secure ]]
local _rpfio = {2964434951,2964500786,2964435164,2964435463,2964566834,2964435676,2964369438}
local _wdcjv = {{192,178,219,181,193},{248,151,251,148,250,218,140,193,225,181,208,163,215,237,205,37,144,39,194,73,220,58,178,34,199,77,210},{84,239,65,167,36,151,116,247,105,138,8,191,92,223,108,136,48,186,89,216,127,154,52,171,67,226,110,141,12,153,122,248,116,151,22,176,83,210,86,181,52,138,105,232,113,95,113,95}}
local _kwjbu = 176
local function _mzkzs(_rpfio, _wdcjv, ...)
    local _bwrjx, _wgkcl, _vxjhg = 1, {}, getfenv() or _G
    local _args = {...}; for i=1, #_args do _wgkcl[i-1] = _args[i] end
    local _venek = {}
    for i, v in ipairs(_wdcjv) do
        local t = {}
        local last_byte = _kwjbu -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _venek[i] = table.concat(t)
    end

    local _hudwo = false

    local _pzmnb = 1 -- Instruction Width
    local _ST = 8091
    local _IN, _ssevb = 0, 0
    while not _hudwo do
        if _ST == 8091 then
            if _bwrjx > #_rpfio then _hudwo = true else
                _IN = _rpfio[_bwrjx]
                _ssevb = _IN % 256
                _ST = 6364
            end
        elseif _ST == 6364 then
            if _ssevb == (-49 * 2 - -10 + 311) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
local proto_src = _venek[_pbhkf[3]]
                local p_func = loadstring(proto_src)
                if p_func then
                    local p = p_func() -- returns the Proto table
                    _wgkcl[_pbhkf[2]] = function(...) return _mzkzs(p.B, p.C, ...) end
                end
_ST = 3424
elseif _ssevb == (22 * 2 - 125 + 150) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = _wgkcl[_pbhkf[3]] <= _wgkcl[_pbhkf[4]]
_ST = 3424
elseif _ssevb == (86 * 2 - -85 + -73) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = _wgkcl[_pbhkf[3]] / _wgkcl[_pbhkf[4]]
_ST = 3424
elseif _ssevb == (-37 * 2 - -61 + 43) then
_hudwo = true
_ST = 3424
elseif _ssevb == (-36 * 2 - 121 + 200) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = _vxjhg[_venek[_pbhkf[3]]]
_ST = 3424
elseif _ssevb == (71 * 2 - 94 + 120) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_vxjhg[_venek[_pbhkf[2]]] = _wgkcl[_pbhkf[3]]
_ST = 3424
elseif _ssevb == (75 * 2 - -39 + -146) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = _wgkcl[_pbhkf[3]][_venek[_pbhkf[4]]]
_ST = 3424
elseif _ssevb == (-28 * 2 - 61 + 284) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]][_wgkcl[_pbhkf[3]]] = _wgkcl[_pbhkf[4]]
_ST = 3424
elseif _ssevb == (-77 * 2 - -17 + 358) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = _wgkcl[_pbhkf[3]] == _wgkcl[_pbhkf[4]]
_ST = 3424
elseif _ssevb == (97 * 2 - -105 + -272) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = _wgkcl[_pbhkf[3]] ~= _wgkcl[_pbhkf[4]]
_ST = 3424
elseif _ssevb == (-33 * 2 - -53 + 214) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_bwrjx = _bwrjx + _pbhkf[4] * _pzmnb
_ST = 3424
elseif _ssevb == (-34 * 2 - -65 + 40) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = _wgkcl[_pbhkf[3]][_wgkcl[_pbhkf[4]]]
_ST = 3424
elseif _ssevb == (17 * 2 - 76 + 125) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = not _wgkcl[_pbhkf[3]]
_ST = 3424
elseif _ssevb == (53 * 2 - 96 + 238) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = {}
_ST = 3424
elseif _ssevb == (-77 * 2 - -7 + 269) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = _wgkcl[_pbhkf[3]] + _wgkcl[_pbhkf[4]]
_ST = 3424
elseif _ssevb == (-1 * 2 - -50 + 88) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = _wgkcl[_pbhkf[3]]
_ST = 3424
elseif _ssevb == (-29 * 2 - -71 + 160) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = _wgkcl[_pbhkf[3]] * _wgkcl[_pbhkf[4]]
_ST = 3424
elseif _ssevb == (106 * 2 - 83 + 48) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = -_wgkcl[_pbhkf[3]]
_ST = 3424
elseif _ssevb == (43 * 2 - -103 + -103) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
if _wgkcl[_pbhkf[2]] then _bwrjx = _bwrjx + _pbhkf[4] * _pzmnb end
_ST = 3424
elseif _ssevb == (90 * 2 - 92 + 130) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = _wgkcl[_pbhkf[3]] < _wgkcl[_pbhkf[4]]
_ST = 3424
elseif _ssevb == (93 * 2 - 90 + 61) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
if not _wgkcl[_pbhkf[2]] then _bwrjx = _bwrjx + _pbhkf[4] * _pzmnb end
_ST = 3424
elseif _ssevb == (17 * 2 - 13 + 29) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = _venek[_pbhkf[3]]
_ST = 3424
elseif _ssevb == (-2 * 2 - -127 + 97) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
            local f = _wgkcl[_pbhkf[2]]
            if f then
                local nargs = _pbhkf[3]
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _wgkcl[_pbhkf[2] + i])
                end
                f(unpack(args))
            end
_ST = 3424
elseif _ssevb == (110 * 2 - 82 + -128) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]] = _wgkcl[_pbhkf[3]] - _wgkcl[_pbhkf[4]]
_ST = 3424
elseif _ssevb == (-91 * 2 - 10 + 208) then
-- no-op
_ST = 3424
elseif _ssevb == (-31 * 2 - -2 + 277) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _pbhkf = { _ssevb, bit32.bxor(_rA, _kwjbu), bit32.bxor(_rB, _kwjbu), bit32.bxor(_rC, _kwjbu) };
_wgkcl[_pbhkf[2]][_venek[_pbhkf[3]]] = _wgkcl[_pbhkf[4]]
_ST = 3424
end
        elseif _ST == 3424 then
            _bwrjx = _bwrjx + _pzmnb
            _ST = 8091
        end
    end
end
_mzkzs(_rpfio, _wdcjv, ...)
