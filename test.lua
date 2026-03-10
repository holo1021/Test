--[[ Holon VM v2.0 ]]
local _B = {{2,1,3},{1,2,1},{3,1,1,0},{2,1,3},{1,2,2},{3,1,1,0},{4,0,0},}
local _C = {{226,9,6,9,8,186,240,231,186,238,255,13,14,212,186,130,79,81,127,37,47,128,34,42,127,36,57},{126,85,72,128,29,77,125,29,56,125,28,81,125,29,77,126,82,36,125,27,65,127,72,57,130,59,38,125,27,47,125,28,38,125,27,64,125,27,30,125,27,88,125,27,51,200,200,200},{10,12,3,8,14}}
local _K = 154 -- 復号キー

local function _V(...)
    local _P = 1
    local _S = {}
    local _E = getfenv() or _G
    
    -- 定数テーブルをその場で復号する
    local _DC = {}
    for i, v in ipairs(_C) do
        local s = ""
        for j = 1, #v do 
            s = s .. string.char((v[j] - _K) % 256) 
        end
        _DC[i] = s
    end

    while true do
        local _I = _B[_P]
        if not _I then break end
        local _O = _I[1]
        
        if _O == 2 then -- GETGLOBAL
            _S[_I[2]] = _E[_DC[_I[3]]] -- 復号済みテーブルを使用
        elseif _O == 1 then -- LOADK
            _S[_I[2]] = _DC[_I[3]]
        elseif _O == 3 then -- CALL (★ここも復活)
            local f = _S[_I[2]]
            local a = _S[_I[2]+1]
            if f then f(a) end
        elseif _O == 4 then -- RETURN
            return
        end
        _P = _P + 1
    end
end
_V(...)
