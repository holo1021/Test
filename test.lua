--[[ Holon VM v5 Secure ]]
local _eglwr = {158,74,75,74,217,75,72,74,91,74,75,74,158,72,75,74,217,73,73,74,91,72,75,74,134,74,74,74}
local _shbaa = {{58,72,33,79,59},{2,109,1,110,0,32,118,59,27,79,42,89,45,23,55,223,106,221,56,179,38,192,72,216,61,183,40},{174,21,187,93,222,109,142,13,147,112,242,69,166,37,150,114,202,64,163,34,133,96,206,81,185,24,148,119,246,99,128,2,142,109,236,74,169,40,172,79,206,112,147,18,139,165,139,165}}
local _hhxvg = 74
local function _zfsxk(...)
    local _atpvd, _dqddr, _fedzi = 1, {}, getfenv() or _G
    local _azwsw = {}
    for i, v in ipairs(_shbaa) do
        local s = ""
        local last_byte = _hhxvg -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            s = s .. string.char(dec_byte)
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _azwsw[i] = s
    end

    local _gfhma = false
    local _wulxr = {}
    _wulxr[158] = function(_kwage) _dqddr[_kwage[2]] = _fedzi[_azwsw[_kwage[3]]] end
    _wulxr[217]     = function(_kwage) _dqddr[_kwage[2]] = _azwsw[_kwage[3]] end
    _wulxr[91]      = function(_kwage) local f = _dqddr[_kwage[2]]; if f then f(_dqddr[_kwage[2]+1]) end end
    _wulxr[134]    = function() _gfhma = true end
    
    -- NOOP & Math Ops
    _wulxr[254]      = function(_kwage) _dqddr[_kwage[2]] = _dqddr[_kwage[3]] end
    -- 算術演算命令 (R1 = R2 + R3)
    _wulxr[194]       = function(_kwage) _dqddr[_kwage[2]] = _dqddr[_kwage[3]] + _dqddr[_kwage[4]] end
    _wulxr[107]       = function(_kwage) _dqddr[_kwage[2]] = _dqddr[_kwage[3]] - _dqddr[_kwage[4]] end
    _wulxr[227]       = function(_kwage) _dqddr[_kwage[2]] = _dqddr[_kwage[3]] * _dqddr[_kwage[4]] end
    _wulxr[207]       = function(_kwage) _dqddr[_kwage[2]] = _dqddr[_kwage[3]] / _dqddr[_kwage[4]] end


    local _mxskd = 4 -- Instruction Width
    while not _gfhma and _atpvd <= #_eglwr do
        local _rzzzu = _eglwr[_atpvd]
        local handler = _wulxr[_rzzzu]
        if handler then
            local _kwage = {
                _rzzzu,
                bit32.bxor(_eglwr[_atpvd+1], _hhxvg),
                bit32.bxor(_eglwr[_atpvd+2], _hhxvg),
                bit32.bxor(_eglwr[_atpvd+3], _hhxvg)
            }
            handler(_kwage)
        end
        _atpvd = _atpvd + _mxskd
    end
end
_zfsxk(...)
