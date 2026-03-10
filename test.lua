--[[ Holon VM v5 Secure ]]
if not bit32 then
    bit32 = {}
    function bit32.bxor(a, b)
        local r, p = 0, 1
        while a > 0 or b > 0 do
            local ra, rb = a % 2, b % 2
            if ra ~= rb then r = r + p end
            a, b = (a - ra) / 2, (b - rb) / 2
            p = p * 2
        end
        return r
    end
end
local _bzyte = {1,197,199,196,206,198,197,196,232,197,197,196,90,196,196,196,1,197,199,196,206,198,198,196,90,196,196,196,232,197,197,196,31,196,196,196}
local _kktdp = {{140,227,143,224,142,174,248,181,149,193,164,215,163,153,185,81,228,83,182,61,168,78,198,86,179,57,166},{32,155,53,211,80,227,0,131,29,254,124,203,40,171,24,252,68,206,45,172,11,238,64,223,55,150,26,249,120,237,14,140,0,227,98,196,39,166,34,193,64,254,29,156,5,43,5,43},{180,198,175,193,181}}
local _EH = {[134] = {155,200,147,204,133,222,236,177,236,204,241,209,142,221,134,217,144,203,248,165,248,216,245,213,138,217,130,221,148,207,251,166,251},[1] = {155,200,147,204,133,222,236,177,236,204,241,209,142,203,144,207,139,200,147,204,133,222,237,176,237,176},[232] = {168,199,164,197,169,137,239,207,242,210,141,222,133,218,147,200,250,167,250,193,225,136,238,206,168,136,252,148,241,159,191,217,241,174,253,166,249,176,235,217,132,175,158,195,234,202,175,193,165},[125] = {155,200,147,204,133,222,236,177,236,204,241,209,142,221,134,217,144,203,248,165,248,216,242,210,141,222,133,218,147,200,252,161,252},[9] = {155,200,147,204,133,222,236,177,236,204,241,209,142,221,134,217,144,203,248,165,248,216,247,215,136,219,128,223,150,205,249,164,249},[206] = {155,200,147,204,133,222,236,177,236,204,241,209,142,202,137,210,141,196,159,172,241,172},[150] = {155,200,147,204,133,222,236,177,236,204,241,209,142,221,134,217,144,203,248,165,248,216,243,211,140,223,132,219,146,201,253,160,253},[31] = {155,201,231,145,240,156,188,129,161,213,167,210,183},[90] = {155,200,147,204,133,222,236,177,236,204,241,209,142,221,134,217,144,203,248,165,248}}
local _aeder = 196
local function _yzajt(...)
    local _fhwyv, _pcihy, _vbwtq = 1, {}, getfenv() or _G
    local _dytii = {}
    for i, v in ipairs(_kktdp) do
        local s = ""
        local last_byte = _aeder -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            s = s .. string.char(dec_byte)
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _dytii[i] = s
    end

    local _acosp = {val = false}
    local _pdsuv = {}
    local _LS = loadstring or load

    for op, enc_body in pairs(_EH) do
        local body_str = ""
        local last_byte = _aeder
        for j = 1, #enc_body do
            local enc_byte = enc_body[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            body_str = body_str .. string.char(dec_byte)
            last_byte = enc_byte
        end
        -- 引数として _pcihy, _dytii, _vbwtq, _acosp, _hrfhp を受け取るように変更
        local chunk, err = _LS("return function(_pcihy, _dytii, _vbwtq, _acosp, _hrfhp) " .. body_str .. " end")
        if chunk then
            local handler = chunk() -- Execute the chunk to get the actual handler function
            _pdsuv[op] = handler
        end
    end

    local _ymkvq = 4
    while not _acosp.val and _fhwyv <= #_bzyte do
        local _gpolv = _bzyte[_fhwyv]
        local handler = _pdsuv[_gpolv]
        if handler then
            local _hrfhp = {
                _gpolv,
                bit32.bxor(_bzyte[_fhwyv+1], _aeder),
                bit32.bxor(_bzyte[_fhwyv+2], _aeder),
                bit32.bxor(_bzyte[_fhwyv+3], _aeder)
            }
            -- 必要な変数をすべて引数として渡す
            handler(_pcihy, _dytii, _vbwtq, _acosp, _hrfhp)
        end
        _fhwyv = _fhwyv + _ymkvq
    end
end
_yzajt(...)
