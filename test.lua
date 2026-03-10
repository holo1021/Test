--[[ Holon VM v5 Secure ]]
local _thryq = {192,196,198,197,252,199,196,197,47,196,196,197,192,196,198,197,252,199,199,197,47,196,196,197,5,197,197,197}
local _hiekr = {{141,226,142,225,143,175,249,180,148,192,165,214,162,152,184,80,229,82,183,60,169,79,199,87,178,56,167},{33,154,52,210,81,226,1,130,28,255,125,202,41,170,25,253,69,207,44,173,10,239,65,222,54,151,27,248,121,236,15,141,1,226,99,197,38,167,35,192,65,255,28,157,4,42,4,42},{181,199,174,192,180}}
local _rsnsk = 197
local function _yzjfm(...)
    local _ofboz, _fudyj, _wrcnd = 1, {}, getfenv() or _G
    local _edyek = {}
    for i, v in ipairs(_hiekr) do
        local s = ""
        local last_byte = _rsnsk -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            s = s .. string.char(dec_byte)
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _edyek[i] = s
    end

    local _rdmlj = false
    local _kjmtu = {}
    _kjmtu[192] = function(_ewodr) _fudyj[_ewodr[2]] = _wrcnd[_edyek[_ewodr[3]]] end
    _kjmtu[252]     = function(_ewodr) _fudyj[_ewodr[2]] = _edyek[_ewodr[3]] end
    _kjmtu[47]      = function(_ewodr) local f = _fudyj[_ewodr[2]]; if f then f(_fudyj[_ewodr[2]+1]) end end
    _kjmtu[5]    = function() _rdmlj = true end
    
    -- NOOP & Math Ops
    _kjmtu[37]      = function(_ewodr) _fudyj[_ewodr[2]] = _fudyj[_ewodr[3]] end
    -- 算術演算命令 (R1 = R2 + R3)
    _kjmtu[168]       = function(_ewodr) _fudyj[_ewodr[2]] = _fudyj[_ewodr[3]] + _fudyj[_ewodr[4]] end
    _kjmtu[214]       = function(_ewodr) _fudyj[_ewodr[2]] = _fudyj[_ewodr[3]] - _fudyj[_ewodr[4]] end
    _kjmtu[174]       = function(_ewodr) _fudyj[_ewodr[2]] = _fudyj[_ewodr[3]] * _fudyj[_ewodr[4]] end
    _kjmtu[43]       = function(_ewodr) _fudyj[_ewodr[2]] = _fudyj[_ewodr[3]] / _fudyj[_ewodr[4]] end


    local _idosb = 4 -- Instruction Width
    while not _rdmlj and _ofboz <= #_thryq do
        local _ostzm = _thryq[_ofboz]
        local handler = _kjmtu[_ostzm]
        if handler then
            local _ewodr = {
                _ostzm,
                bit32.bxor(_thryq[_ofboz+1], _rsnsk),
                bit32.bxor(_thryq[_ofboz+2], _rsnsk),
                bit32.bxor(_thryq[_ofboz+3], _rsnsk)
            }
            handler(_ewodr)
        end
        _ofboz = _ofboz + _idosb
    end
end
_yzjfm(...)
