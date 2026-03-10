--[[ Holon VM v5 Secure ]]
local _B = {{1,1,3},{73,0,0},{15,2,1},{73,0,0},{134,1,1,0},{73,0,0},{1,1,3},{15,2,2},{134,1,1,0},{73,0,0},{97,0,0},}
local _C = {{243,26,23,26,25,203,1,248,203,255,16,30,31,229,203,147,96,98,144,54,64,145,51,59,144,53,74},{143,102,89,145,46,94,142,46,73,142,45,98,142,46,94,143,99,53,142,44,82,144,89,74,147,76,55,142,44,64,142,45,55,142,44,81,142,44,47,142,44,105,142,44,68,217,217,217},{27,29,20,25,31}}
local _K = 171
local function _V(...)
    local _P, _S, _E = 1, {}, getfenv() or _G
    local _DC = {}
    for i, v in ipairs(_C) do
        local s = ""
        for j = 1, #v do s = s .. string.char((v[j] - _K) % 256) end
        _DC[i] = s
    end
    while true do
        local _I = _B[_P]
        if not _I then break end
        local _O = _I[1]
        if _O == 1 then
            _S[_I[2]] = _E[_DC[_I[3]]]
        elseif _O == 15 then
            _S[_I[2]] = _DC[_I[3]]
        elseif _O == 134 then
            local f = _S[_I[2]]
            if f then f(_S[_I[2]+1]) end
        elseif _O == 97 then
            return
        end
        _P = _P + 1
    end
end
_V(...)
