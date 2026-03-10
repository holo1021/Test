--[[ Holon VM v5 Secure ]]
local _ghuye = {91,138,138,138}
local _zasjx = {}
local _mzbqb = 138
local function _qowhc(...)
    local _zqqgt, _tzrel, _awehx = 1, {}, getfenv() or _G
    local _nbqfa = {}
    for i, v in ipairs(_zasjx) do
        local s = ""
        local last_byte = _mzbqb
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            s = s .. string.char(dec_byte)
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _nbqfa[i] = s
    end

    local _jwuky = false
    local _vsizg = {}
    _vsizg[165] = function(_qdoce) _tzrel[_qdoce[2]] = _awehx[_nbqfa[_qdoce[3]]] end
    _vsizg[193]     = function(_qdoce) local c = _nbqfa[_qdoce[3]]; _tzrel[_qdoce[2]] = tonumber(c) or c end
    _vsizg[61]      = function(_qdoce) local f = _tzrel[_qdoce[2]]; if f then f(_tzrel[_qdoce[2]+1]) end end
    _vsizg[91]    = function() _jwuky = true end
    
    -- 汎用命令と算術演算命令
    _vsizg[56]      = function(_qdoce) _tzrel[_qdoce[2]] = _tzrel[_qdoce[3]] end
    _vsizg[37]      = function() end -- ジャンク命令用
    _vsizg[227]       = function(_qdoce) _tzrel[_qdoce[2]] = _tzrel[_qdoce[3]] + _tzrel[_qdoce[4]] end
    _vsizg[31]       = function(_qdoce) _tzrel[_qdoce[2]] = _tzrel[_qdoce[3]] - _tzrel[_qdoce[4]] end
    _vsizg[135]       = function(_qdoce) _tzrel[_qdoce[2]] = _tzrel[_qdoce[3]] * _tzrel[_qdoce[4]] end
    _vsizg[174]       = function(_qdoce) _tzrel[_qdoce[2]] = _tzrel[_qdoce[3]] / _tzrel[_qdoce[4]] end


    local _fdcyh = 4 -- Instruction Width
    while not _jwuky and _zqqgt <= #_ghuye do
        local _suwud = _ghuye[_zqqgt]
        local handler = _vsizg[_suwud]
        if handler then
            local _qdoce = {
                _suwud,
                bit32.bxor(_ghuye[_zqqgt+1], _mzbqb),
                bit32.bxor(_ghuye[_zqqgt+2], _mzbqb),
                bit32.bxor(_ghuye[_zqqgt+3], _mzbqb)
            }
            handler(_qdoce)
        end
        _zqqgt = _zqqgt + _fdcyh
    end
end
_qowhc(...)
