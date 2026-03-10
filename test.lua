--[[ Holon VM v5 Secure ]]
local _kqmyi = {90,25,27,24,114,26,25,24,174,25,25,24,90,25,27,24,114,26,26,24,220,24,24,24,174,25,25,24,18,24,24,24}
local _mkoup = {{80,63,83,60,82,114,36,105,73,29,120,11,127,69,101,141,56,143,106,225,116,146,26,138,111,229,122},{252,71,233,15,140,63,220,95,193,34,160,23,244,119,196,32,152,18,241,112,215,50,156,3,235,74,198,37,164,49,210,80,220,63,190,24,251,122,254,29,156,34,193,64,217,247,217,247},{104,26,115,29,105}}
local _EH = {[18] = {71,21,59,77,44,64,96,93,125,9,123,14,107},[220] = {71,20,79,16,89,2,48,109,48,16,45,13,82,1,90,5,76,23,36,121,36},[90] = {71,20,79,16,89,2,48,109,48,16,45,13,82,23,76,19,87,20,79,16,89,2,49,108,49,108},[176] = {71,20,79,16,89,2,48,109,48,16,45,13,82,1,90,5,76,23,36,121,36,4,41,9,86,5,94,1,72,19,39,122,39},[224] = {71,20,79,16,89,2,48,109,48,16,45,13,82,1,90,5,76,23,36,121,36,4,46,14,81,2,89,6,79,20,32,125,32},[136] = {71,20,79,16,89,2,48,109,48,16,45,13,82,1,90,5,76,23,36,121,36,4,43,11,84,7,92,3,74,17,37,120,37},[96] = {71,20,79,16,89,2,48,109,48,16,45,13,82,1,90,5,76,23,36,121,36,4,47,15,80,3,88,7,78,21,33,124,33},[114] = {71,20,79,16,89,2,48,109,48,16,45,13,82,22,85,14,81,24,67,112,45,112},[174] = {116,27,120,25,117,85,51,19,46,14,81,2,89,6,79,20,38,123,38,29,61,84,50,18,116,84,32,72,45,67,99,5,45,114,33,122,37,108,55,5,88,115,66,31,54,22,115,29,121}}
local _jgmcu = 24
local function _qsnvj(...)
    local _ybivk, _vqqfr, _fpgsx = 1, {}, getfenv() or _G
    local _qtaju = {}
    for i, v in ipairs(_mkoup) do
        local s = ""
        local last_byte = _jgmcu -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            s = s .. string.char(dec_byte)
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _qtaju[i] = s
    end

    local _xfsmi = {val = false}
    local _fkcyu = {}
    local _LS = loadstring or load

    -- Create a custom environment for the handlers.
    -- This gives them access to the VM's state variables (_vqqfr, _qtaju, etc.) as "globals".
    local _ENV = { _vqqfr = _vqqfr, _qtaju = _qtaju, _fpgsx = _fpgsx, _xfsmi = _xfsmi }

    for op, enc_body in pairs(_EH) do
        local body_str = ""
        local last_byte = _jgmcu
        for j = 1, #enc_body do
            local enc_byte = enc_body[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            body_str = body_str .. string.char(dec_byte)
            last_byte = enc_byte
        end
        local chunk, err = _LS("return function(_erfdv) " .. body_str .. " end")
        if chunk then
            setfenv(chunk, _ENV) -- Set the chunk's environment to our custom one
            local handler = chunk() -- Execute the chunk to get the actual handler function
            _fkcyu[op] = handler
        end
    end

    local _umdul = 4
    while not _xfsmi.val and _ybivk <= #_kqmyi do
        local _aoitv = _kqmyi[_ybivk]
        local handler = _fkcyu[_aoitv]
        if handler then
            local _erfdv = {
                _aoitv,
                bit32.bxor(_kqmyi[_ybivk+1], _jgmcu),
                bit32.bxor(_kqmyi[_ybivk+2], _jgmcu),
                bit32.bxor(_kqmyi[_ybivk+3], _jgmcu)
            }
            handler(_erfdv)
        end
        _ybivk = _ybivk + _umdul
    end
end
_qsnvj(...)
