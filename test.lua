--[[ Holon VM v5 Secure ]]
local _jrvod = {196,128,130,129,44,131,128,129,81,128,128,129,196,128,130,129,44,131,131,129,81,128,128,129,87,129,129,129}
local _puaew = {{201,166,202,165,203,235,189,240,208,132,225,146,230,220,252,20,161,22,243,120,237,11,131,19,246,124,227},{101,222,112,150,21,166,69,198,88,187,57,142,109,238,93,185,1,139,104,233,78,171,5,154,114,211,95,188,61,168,75,201,69,166,39,129,98,227,103,132,5,187,88,217,64,110,64,110},{241,131,234,132,240}}
local _jvihf = 129
local function _zncud(...)
    local _qhjrz, _llsdc, _qmhyu = 1, {}, getfenv() or _G
    local _iygss = {}
    for i, v in ipairs(_puaew) do
        local s = ""
        local last_byte = _jvihf -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            s = s .. string.char(dec_byte)
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _iygss[i] = s
    end

    local _xxuzr = false
    local _tiasu = {}
    _tiasu[196] = function(_kjwkq) _llsdc[_kjwkq[2]] = _qmhyu[_iygss[_kjwkq[3]]] end
    _tiasu[44]     = function(_kjwkq) _llsdc[_kjwkq[2]] = _iygss[_kjwkq[3]] end
    _tiasu[81]      = function(_kjwkq) local f = _llsdc[_kjwkq[2]]; if f then f(_llsdc[_kjwkq[2]+1]) end end
    _tiasu[87]    = function() _xxuzr = true end
    
    -- NOOP & Math Ops
    _tiasu[153]      = function(_kjwkq) _llsdc[_kjwkq[2]] = _llsdc[_kjwkq[3]] end
    -- 算術演算命令 (R1 = R2 + R3)
    _tiasu[74]       = function(_kjwkq) _llsdc[_kjwkq[2]] = _llsdc[_kjwkq[3]] + _llsdc[_kjwkq[4]] end
    _tiasu[72]       = function(_kjwkq) _llsdc[_kjwkq[2]] = _llsdc[_kjwkq[3]] - _llsdc[_kjwkq[4]] end
    _tiasu[232]       = function(_kjwkq) _llsdc[_kjwkq[2]] = _llsdc[_kjwkq[3]] * _llsdc[_kjwkq[4]] end
    _tiasu[193]       = function(_kjwkq) _llsdc[_kjwkq[2]] = _llsdc[_kjwkq[3]] / _llsdc[_kjwkq[4]] end


    local _txuks = 4 -- Instruction Width
    while not _xxuzr and _qhjrz <= #_jrvod do
        local _sbxok = _jrvod[_qhjrz]
        local handler = _tiasu[_sbxok]
        if handler then
            local _kjwkq = {
                _sbxok,
                bit32.bxor(_jrvod[_qhjrz+1], _jvihf),
                bit32.bxor(_jrvod[_qhjrz+2], _jvihf),
                bit32.bxor(_jrvod[_qhjrz+3], _jvihf)
            }
            handler(_kjwkq)
        end
        _qhjrz = _qhjrz + _txuks
    end
end
_zncud(...)
