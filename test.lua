--[[ Holon VM v5 Secure ]]
local _B = {{24,1,3},{41,2,1},{25,1,1,0},{24,1,3},{41,2,2},{25,1,1,0},{184,0,0},{248,0,0},}
local _C = {{255,38,35,38,37,215,13,4,215,11,28,42,43,241,215,159,108,110,156,66,76,157,63,71,156,65,86},{155,114,101,157,58,106,154,58,85,154,57,110,154,58,106,155,111,65,154,56,94,156,101,86,159,88,67,154,56,76,154,57,67,154,56,93,154,56,59,154,56,117,154,56,80,229,229,229},{39,41,32,37,43}}
local _K = 183
local function _V(...)
    local _P, _S, _E = 1, {}, getfenv() or _G
    local _DC = {}
    for i, v in ipairs(_C) do
        local s = ""
        for j = 1, #v do s = s .. string.char((v[j] - _K) % 256) end
        _DC[i] = s
    end

    local _R = false
    local _H = {}
    _H[24] = function(_I) _S[_I[2]] = _E[_DC[_I[3]]] end
    _H[41]     = function(_I) _S[_I[2]] = _DC[_I[3]] end
    _H[25]      = function(_I)
        local f = _S[_I[2]]
        if f then f(_S[_I[2]+1]) end
    end
    _H[248]    = function() _R = true end

    while not _R do
        local _I = _B[_P]
        if not _I then break end
        local _O = _I[1]
        local handler = _H[_O]
        if handler then
            handler(_I)
        end
        _P = _P + 1
    end
end
_V(...)
