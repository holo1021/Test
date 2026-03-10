--[[ Holon VM v5 Secure ]]
local _B = {166,140,142,141,251,143,140,141,124,140,140,141,166,140,142,141,251,143,143,141,124,140,140,141,47,141,141,141}
local _C = {{213,252,249,252,251,173,227,218,173,225,242,0,1,199,173,117,66,68,114,24,34,115,21,29,114,23,44},{113,72,59,115,16,64,112,16,43,112,15,68,112,16,64,113,69,23,112,14,52,114,59,44,117,46,25,112,14,34,112,15,25,112,14,51,112,14,17,112,14,75,112,14,38,187,187,187},{253,255,246,251,1}}
local _K = 141
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
    _H[166] = function(_I) _S[_I[2]] = _E[_DC[_I[3]]] end
    _H[251]     = function(_I) _S[_I[2]] = _DC[_I[3]] end
    _H[124]      = function(_I)
        local f = _S[_I[2]]
        if f then f(_S[_I[2]+1]) end
    end
    _H[47]    = function() _R = true end

    local _IW = 4 -- Instruction Width
    while not _R and _P <= #_B do
        local _O = _B[_P]
        local handler = _H[_O]
        if handler then
            -- ハンドラの互換性のために一時的な命令テーブルを作成
            -- オペランドをキーで復号
            local _I = {
                _O,
                bit32.bxor(_B[_P+1], _K),
                bit32.bxor(_B[_P+2], _K),
                bit32.bxor(_B[_P+3], _K)
            }
            handler(_I)
        end
        _P = _P + _IW
    end
end
_V(...)
