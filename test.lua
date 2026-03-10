--[[ Holon VM v5 Secure ]]
local _B = {189,1,3,0,168,0,0,0,101,2,1,0,134,1,1,0,189,1,3,0,168,0,0,0,101,2,2,0,134,1,1,0,41,0,0,0}
local _C = {{107,146,143,146,145,67,121,112,67,119,136,150,151,93,67,11,216,218,8,174,184,9,171,179,8,173,194},{7,222,209,9,166,214,6,166,193,6,165,218,6,166,214,7,219,173,6,164,202,8,209,194,11,196,175,6,164,184,6,165,175,6,164,201,6,164,167,6,164,225,6,164,188,81,81,81},{147,149,140,145,151}}
local _K = 35
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
    _H[189] = function(_I) _S[_I[2]] = _E[_DC[_I[3]]] end
    _H[101]     = function(_I) _S[_I[2]] = _DC[_I[3]] end
    _H[134]      = function(_I)
        local f = _S[_I[2]]
        if f then f(_S[_I[2]+1]) end
    end
    _H[41]    = function() _R = true end

    local _IW = 4 -- Instruction Width
    while not _R and _P <= #_B do
        local _O = _B[_P]
        local handler = _H[_O]
        if handler then
            -- ハンドラの互換性のために一時的な命令テーブルを作成
            local _I = {_O, _B[_P+1], _B[_P+2], _B[_P+3]}
            handler(_I)
        end
        _P = _P + _IW
    end
end
_V(...)
