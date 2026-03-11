--[[ Holon VM v5 Secure ]]
local _swqhb = {143,92,93,92,138,93,94,92,171,92,93,92,143,94,93,92,138,95,95,92,171,94,93,92,191,92,92,92}
local _ixjqh = {{44,94,55,89,45},{20,123,23,120,22,54,96,45,13,89,60,79,59,1,33,201,124,203,46,165,48,214,94,206,43,161,62},{184,3,173,75,200,123,152,27,133,102,228,83,176,51,128,100,220,86,181,52,147,118,216,71,175,14,130,97,224,117,150,20,152,123,250,92,191,62,186,89,216,102,133,4,157,179,157,179}}
local _mvslf = 92
local function _pegqi(...)
    local _yodxt, _sncxo, _pcivz = 1, {}, getfenv() or _G
    local _ettgn = {}
    for i, v in ipairs(_ixjqh) do
        local s = ""
        local last_byte = _mvslf -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            s = s .. string.char(dec_byte)
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _ettgn[i] = s
    end

    local _xhyiv = false
    local _akeuj = {}
    _akeuj[152]      = function(_ltuvp) _sncxo[_ltuvp[2]] = _sncxo[_ltuvp[3]] end
    _akeuj[143] = function(_ltuvp) _sncxo[_ltuvp[2]] = _pcivz[_ettgn[_ltuvp[3]]] end
    _akeuj[138]     = function(_ltuvp) _sncxo[_ltuvp[2]] = _ettgn[_ltuvp[3]] end
    _akeuj[171]      = function(_ltuvp)
        local f = _sncxo[_ltuvp[2]]
        if not f then return end
        local nargs = _ltuvp[3]
        local args = {}
        for i = 1, nargs do
            table.insert(args, _sncxo[_ltuvp[2] + i])
        end
        f(unpack(args))
    end
    _akeuj[191]    = function() _xhyiv = true end
    
    -- Control Flow, NOOP & Math Ops
    _akeuj[99]       = function(_ltuvp) _yodxt = _yodxt + _ltuvp[4] * _aubav end
    _akeuj[98]      = function(_ltuvp) if not _sncxo[_ltuvp[2]] then _yodxt = _yodxt + _ltuvp[4] * _aubav end end
    _akeuj[51]        = function(_ltuvp) _sncxo[_ltuvp[2]] = _sncxo[_ltuvp[3]] == _sncxo[_ltuvp[4]] end
    _akeuj[247]      = function() end -- 何もしない
    _akeuj[254]       = function(_ltuvp) _sncxo[_ltuvp[2]] = _sncxo[_ltuvp[3]] + _sncxo[_ltuvp[4]] end
    _akeuj[173]       = function(_ltuvp) _sncxo[_ltuvp[2]] = _sncxo[_ltuvp[3]] - _sncxo[_ltuvp[4]] end
    _akeuj[63]       = function(_ltuvp) _sncxo[_ltuvp[2]] = _sncxo[_ltuvp[3]] * _sncxo[_ltuvp[4]] end
    _akeuj[224]       = function(_ltuvp) _sncxo[_ltuvp[2]] = _sncxo[_ltuvp[3]] / _sncxo[_ltuvp[4]] end


    local _aubav = 4 -- Instruction Width
    while not _xhyiv and _yodxt <= #_swqhb do
        local _agsdg = _swqhb[_yodxt]
        local handler = _akeuj[_agsdg]
        if handler then
            local _ltuvp = {
                _agsdg,
                bit32.bxor(_swqhb[_yodxt+1], _mvslf),
                bit32.bxor(_swqhb[_yodxt+2], _mvslf),
                bit32.bxor(_swqhb[_yodxt+3], _mvslf)
            }
            handler(_ltuvp)
        end
        _yodxt = _yodxt + _aubav
    end
end
_pegqi(...)
