--[[ Holon VM v5 Secure ]]
local _zbdmz = {184,14,15,14,155,15,12,14,83,14,15,14,184,12,15,14,155,13,13,14,83,12,15,14,229,14,14,14}
local _wwawe = {{126,12,101,11,127},{70,41,69,42,68,100,50,127,95,11,110,29,105,83,115,155,46,153,124,247,98,132,12,156,121,243,108},{234,81,255,25,154,41,202,73,215,52,182,1,226,97,210,54,142,4,231,102,193,36,138,21,253,92,208,51,178,39,196,70,202,41,168,14,237,108,232,11,138,52,215,86,207,225,207,225}}
local _pfikd = 14
local function _gzvjc(...)
    local _xwjbr, _fpifu, _zpdrd = 1, {}, getfenv() or _G
    local _khrty = {}
    for i, v in ipairs(_wwawe) do
        local s = ""
        local last_byte = _pfikd -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            s = s .. string.char(dec_byte)
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _khrty[i] = s
    end

    local _eydlf = false
    local _msfue = {}
    _msfue[207]      = function(_ropvy) _fpifu[_ropvy[2]] = _fpifu[_ropvy[3]] end
    _msfue[184] = function(_ropvy) _fpifu[_ropvy[2]] = _zpdrd[_khrty[_ropvy[3]]] end
    _msfue[155]     = function(_ropvy) _fpifu[_ropvy[2]] = _khrty[_ropvy[3]] end
    _msfue[83]      = function(_ropvy)
        local f = _fpifu[_ropvy[2]]
        if not f then return end
        local nargs = _ropvy[3]
        local args = {}
        for i = 1, nargs do
            table.insert(args, _fpifu[_ropvy[2] + i])
        end
        f(unpack(args))
    end
    _msfue[229]    = function() _eydlf = true end
    
    -- Control Flow, NOOP & Math Ops
    _msfue[54]       = function(_ropvy) _xwjbr = _xwjbr + _ropvy[4] * _vgzoz end
    _msfue[242]      = function(_ropvy) if not _fpifu[_ropvy[2]] then _xwjbr = _xwjbr + _ropvy[4] * _vgzoz end end
    _msfue[214]        = function(_ropvy) _fpifu[_ropvy[2]] = _fpifu[_ropvy[3]] == _fpifu[_ropvy[4]] end
    _msfue[221]      = function() end -- 何もしない
    _msfue[165]       = function(_ropvy) _fpifu[_ropvy[2]] = _fpifu[_ropvy[3]] + _fpifu[_ropvy[4]] end
    _msfue[220]       = function(_ropvy) _fpifu[_ropvy[2]] = _fpifu[_ropvy[3]] - _fpifu[_ropvy[4]] end
    _msfue[190]       = function(_ropvy) _fpifu[_ropvy[2]] = _fpifu[_ropvy[3]] * _fpifu[_ropvy[4]] end
    _msfue[21]       = function(_ropvy) _fpifu[_ropvy[2]] = _fpifu[_ropvy[3]] / _fpifu[_ropvy[4]] end


    local _vgzoz = 4 -- Instruction Width
    while not _eydlf and _xwjbr <= #_zbdmz do
        local _uqocy = _zbdmz[_xwjbr]
        local handler = _msfue[_uqocy]
        if handler then
            local _ropvy = {
                _uqocy,
                bit32.bxor(_zbdmz[_xwjbr+1], _pfikd),
                bit32.bxor(_zbdmz[_xwjbr+2], _pfikd),
                bit32.bxor(_zbdmz[_xwjbr+3], _pfikd)
            }
            handler(_ropvy)
        end
        _xwjbr = _xwjbr + _vgzoz
    end
end
_gzvjc(...)
