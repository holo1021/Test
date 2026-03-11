--[[ Holon VM v5 Secure ]]
local _gqebz = {33,149,151,148,3,148,148,148,127,150,149,148,176,149,149,148,3,148,148,148,33,149,151,148,127,150,150,148,176,149,149,148,58,148,148,148,3,148,148,148}
local _nlqnp = {{220,179,223,176,222,254,168,229,197,145,244,135,243,201,233,1,180,3,230,109,248,30,150,6,227,105,246},{112,203,101,131,0,179,80,211,77,174,44,155,120,251,72,172,20,158,125,252,91,190,16,143,103,198,74,169,40,189,94,220,80,179,50,148,119,246,114,145,16,174,77,204,85,123,85,123},{228,150,255,145,229}}
local _yjcln = 148
local function _ieqbx(...)
    local _crdsd, _znigb, _wtmmw = 1, {}, getfenv() or _G
    local _icioj = {}
    for i, v in ipairs(_nlqnp) do
        local s = ""
        local last_byte = _yjcln -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            s = s .. string.char(dec_byte)
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _icioj[i] = s
    end

    local _zlzmk = false
    local _uwcrr = {}
    _uwcrr[33] = function(_nqodm) _znigb[_nqodm[2]] = _wtmmw[_icioj[_nqodm[3]]] end
    _uwcrr[127]     = function(_nqodm) _znigb[_nqodm[2]] = _icioj[_nqodm[3]] end
    _uwcrr[176]      = function(_nqodm) local f = _znigb[_nqodm[2]]; if f then f(_znigb[_nqodm[2]+1]) end end
    _uwcrr[58]    = function() _zlzmk = true end
    
    -- NOOP & Math Ops
    _uwcrr[3]      = function(_nqodm) _znigb[_nqodm[2]] = _znigb[_nqodm[3]] end
    -- 算術演算命令 (R1 = R2 + R3)
    _uwcrr[243]       = function(_nqodm) _znigb[_nqodm[2]] = _znigb[_nqodm[3]] + _znigb[_nqodm[4]] end
    _uwcrr[133]       = function(_nqodm) _znigb[_nqodm[2]] = _znigb[_nqodm[3]] - _znigb[_nqodm[4]] end
    _uwcrr[16]       = function(_nqodm) _znigb[_nqodm[2]] = _znigb[_nqodm[3]] * _znigb[_nqodm[4]] end
    _uwcrr[30]       = function(_nqodm) _znigb[_nqodm[2]] = _znigb[_nqodm[3]] / _znigb[_nqodm[4]] end


    local _kebuk = 4 -- Instruction Width
    while not _zlzmk and _crdsd <= #_gqebz do
        local _duxkr = _gqebz[_crdsd]
        local handler = _uwcrr[_duxkr]
        if handler then
            local _nqodm = {
                _duxkr,
                bit32.bxor(_gqebz[_crdsd+1], _yjcln),
                bit32.bxor(_gqebz[_crdsd+2], _yjcln),
                bit32.bxor(_gqebz[_crdsd+3], _yjcln)
            }
            handler(_nqodm)
        end
        _crdsd = _crdsd + _kebuk
    end
end
_ieqbx(...)
