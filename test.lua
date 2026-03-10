--[[ Holon VM v5 Secure ]]
local _yirve = {54,175,173,174,32,172,175,174,35,174,174,174,155,175,175,174,35,174,174,174,54,175,173,174,32,172,172,174,35,174,174,174,155,175,175,174,35,174,174,174,118,174,174,174}
local _lqety = {{246,29,26,29,28,206,4,251,206,2,19,33,34,232,206,150,99,101,147,57,67,148,54,62,147,56,77},{146,105,92,148,49,97,145,49,76,145,48,101,145,49,97,146,102,56,145,47,85,147,92,77,150,79,58,145,47,67,145,48,58,145,47,84,145,47,50,145,47,108,145,47,71,220,220,220},{30,32,23,28,34}}
local _gijrf = 174
local function _xdnbd(...)
    local _uecff, _pxyvr, _gtvmj = 1, {}, getfenv() or _G
    local _dzqwj = {}
    for i, v in ipairs(_lqety) do
        local s = ""
        for j = 1, #v do s = s .. string.char((v[j] - _gijrf) % 256) end
        _dzqwj[i] = s
    end

    local _dmbhr = false
    local _rmzpd = {}
    _rmzpd[54] = function(_wltrf) _pxyvr[_wltrf[2]] = _gtvmj[_dzqwj[_wltrf[3]]] end
    _rmzpd[32]     = function(_wltrf) _pxyvr[_wltrf[2]] = _dzqwj[_wltrf[3]] end
    _rmzpd[155]      = function(_wltrf) local f = _pxyvr[_wltrf[2]]; if f then f(_pxyvr[_wltrf[2]+1]) end end
    _rmzpd[118]    = function() _dmbhr = true end
    
    -- NOOP & Math Ops
    _rmzpd[35]      = function(_wltrf) _pxyvr[_wltrf[2]] = _pxyvr[_wltrf[3]] end
    -- 算術演算命令 (R1 = R2 + R3)
    _rmzpd[233]       = function(_wltrf) _pxyvr[_wltrf[2]] = _pxyvr[_wltrf[3]] + _pxyvr[_wltrf[4]] end
    _rmzpd[27]       = function(_wltrf) _pxyvr[_wltrf[2]] = _pxyvr[_wltrf[3]] - _pxyvr[_wltrf[4]] end
    _rmzpd[107]       = function(_wltrf) _pxyvr[_wltrf[2]] = _pxyvr[_wltrf[3]] * _pxyvr[_wltrf[4]] end
    _rmzpd[101]       = function(_wltrf) _pxyvr[_wltrf[2]] = _pxyvr[_wltrf[3]] / _pxyvr[_wltrf[4]] end


    local _zkhhu = 4 -- Instruction Width
    while not _dmbhr and _uecff <= #_yirve do
        local _jvgwr = _yirve[_uecff]
        local handler = _rmzpd[_jvgwr]
        if handler then
            local _wltrf = {
                _jvgwr,
                bit32.bxor(_yirve[_uecff+1], _gijrf),
                bit32.bxor(_yirve[_uecff+2], _gijrf),
                bit32.bxor(_yirve[_uecff+3], _gijrf)
            }
            handler(_wltrf)
        end
        _uecff = _uecff + _zkhhu
    end
end
_xdnbd(...)
