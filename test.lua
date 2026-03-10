--[[ Holon VM v5 Secure ]]
local _bkknh = {204,61,63,60,238,62,61,60,219,61,61,60,204,61,63,60,238,62,62,60,219,61,61,60,234,60,60,60,243,60,60,60}
local _qexud = {{116,27,119,24,118,86,0,77,109,57,92,47,91,97,65,169,28,171,78,197,80,182,62,174,75,193,94},{216,99,205,43,168,27,248,123,229,6,132,51,208,83,224,4,188,54,213,84,243,22,184,39,207,110,226,1,128,21,246,116,248,27,154,60,223,94,218,57,184,6,229,100,253,211,253,211},{76,62,87,57,77}}
local _gqsot = 60
local function _zrbzg(...)
    local _xwtbr, _lrbnm, _gingo = 1, {}, getfenv() or _G
    local _qyqyg = {}
    for i, v in ipairs(_qexud) do
        local s = ""
        local last_byte = _gqsot -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            s = s .. string.char(dec_byte)
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _qyqyg[i] = s
    end

    local _xmokc = false
    local _bdjua = {}
    _bdjua[204] = function(_uiuzk) _lrbnm[_uiuzk[2]] = _gingo[_qyqyg[_uiuzk[3]]] end
    _bdjua[238]     = function(_uiuzk) _lrbnm[_uiuzk[2]] = _qyqyg[_uiuzk[3]] end
    _bdjua[219]      = function(_uiuzk) local f = _lrbnm[_uiuzk[2]]; if f then f(_lrbnm[_uiuzk[2]+1]) end end
    _bdjua[243]    = function() _xmokc = true end
    
    -- NOOP & Math Ops
    _bdjua[234]      = function(_uiuzk) _lrbnm[_uiuzk[2]] = _lrbnm[_uiuzk[3]] end
    -- 算術演算命令 (R1 = R2 + R3)
    _bdjua[106]       = function(_uiuzk) _lrbnm[_uiuzk[2]] = _lrbnm[_uiuzk[3]] + _lrbnm[_uiuzk[4]] end
    _bdjua[183]       = function(_uiuzk) _lrbnm[_uiuzk[2]] = _lrbnm[_uiuzk[3]] - _lrbnm[_uiuzk[4]] end
    _bdjua[198]       = function(_uiuzk) _lrbnm[_uiuzk[2]] = _lrbnm[_uiuzk[3]] * _lrbnm[_uiuzk[4]] end
    _bdjua[20]       = function(_uiuzk) _lrbnm[_uiuzk[2]] = _lrbnm[_uiuzk[3]] / _lrbnm[_uiuzk[4]] end


    local _oiqpj = 4 -- Instruction Width
    while not _xmokc and _xwtbr <= #_bkknh do
        local _podpa = _bkknh[_xwtbr]
        local handler = _bdjua[_podpa]
        if handler then
            local _uiuzk = {
                _podpa,
                bit32.bxor(_bkknh[_xwtbr+1], _gqsot),
                bit32.bxor(_bkknh[_xwtbr+2], _gqsot),
                bit32.bxor(_bkknh[_xwtbr+3], _gqsot)
            }
            handler(_uiuzk)
        end
        _xwtbr = _xwtbr + _oiqpj
    end
end
_zrbzg(...)
