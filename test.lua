--[[ Holon VM v5 Secure ]]
local _bxcnd = {250,181,183,180,225,182,181,180,185,181,181,180,63,180,180,180,250,181,183,180,225,182,182,180,185,181,181,180,35,180,180,180}
local _tohgl = {{252,147,255,144,254,222,136,197,229,177,212,167,211,233,201,33,148,35,198,77,216,62,182,38,195,73,214},{80,235,69,163,32,147,112,243,109,142,12,187,88,219,104,140,52,190,93,220,123,158,48,175,71,230,106,137,8,157,126,252,112,147,18,180,87,214,82,177,48,142,109,236,117,91,117,91},{196,182,223,177,197}}
local _EH = {[225] = {235,184,227,188,245,174,156,193,156,188,129,161,254,186,249,162,253,180,239,220,129,220},[32] = {235,184,227,188,245,174,156,193,156,188,129,161,254,173,246,169,224,187,136,213,136,168,130,162,253,174,245,170,227,184,140,209,140},[185] = {216,183,212,181,217,249,159,191,130,162,253,174,245,170,227,184,138,215,138,177,145,248,158,190,216,248,140,228,129,239,207,169,129,222,141,214,137,192,155,169,244,223,238,179,154,186,223,177,213},[215] = {235,184,227,188,245,174,156,193,156,188,129,161,254,173,246,169,224,187,136,213,136,168,133,165,250,169,242,173,228,191,139,214,139},[63] = {235,184,227,188,245,174,156,193,156,188,129,161,254,173,246,169,224,187,136,213,136},[250] = {235,184,227,188,245,174,156,193,156,188,129,161,254,187,224,191,251,184,227,188,245,174,157,192,157,192},[202] = {235,184,227,188,245,174,156,193,156,188,129,161,254,173,246,169,224,187,136,213,136,168,131,163,252,175,244,171,226,185,141,208,141},[223] = {235,184,227,188,245,174,156,193,156,188,129,161,254,173,246,169,224,187,136,213,136,168,135,167,248,171,240,175,230,189,137,212,137},[35] = {235,185,153,164,132,240,130,247,146}}
local _hcmwv = 180
local function _ncjiw(...)
    local _nrfvz, _tmldu, _nyjtr = 1, {}, getfenv() or _G
    local _blfie = {}
    for i, v in ipairs(_tohgl) do
        local s = ""
        local last_byte = _hcmwv -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            s = s .. string.char(dec_byte)
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _blfie[i] = s
    end

    local _ahast = false
    local _mpnvl = {}
    local _LS = loadstring or load

    for op, enc_body in pairs(_EH) do
        local body_str = ""
        local last_byte = _hcmwv
        for j = 1, #enc_body do
            local enc_byte = enc_body[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            body_str = body_str .. string.char(dec_byte)
            last_byte = enc_byte
        end
        local chunk, err = _LS("return function(_gvpvt) " .. body_str .. " end")
        if chunk then
            local handler = chunk()
            setfenv(handler, getfenv(1))
            _mpnvl[op] = handler
        end
    end

    local _ycawl = 4
    while not _ahast and _nrfvz <= #_bxcnd do
        local _aicjy = _bxcnd[_nrfvz]
        local handler = _mpnvl[_aicjy]
        if handler then
            local _gvpvt = {
                _aicjy,
                bit32.bxor(_bxcnd[_nrfvz+1], _hcmwv),
                bit32.bxor(_bxcnd[_nrfvz+2], _hcmwv),
                bit32.bxor(_bxcnd[_nrfvz+3], _hcmwv)
            }
            handler(_gvpvt)
        end
        _nrfvz = _nrfvz + _ycawl
    end
end
_ncjiw(...)
