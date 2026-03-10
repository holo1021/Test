--[[ Holon VM v2.0 ]]
local _B = {{2,1,3,},{1,2,1,},{3,1,1,0,},{2,1,3,},{1,2,2,},{3,1,1,0,},{4,0,0,},} -- Bytecode
local _C = {"Holon VM Test: 起動成功","仮想マシン上で実行されています...","print",} -- Constants
local function _V(...)
    local _P = 1 -- PC
    local _S = {} -- Stack
    local _E = getfenv() or _G
    while true do
        local _I = _B[_P]
        if not _I then break end
        local _O = _I[1]
        if _O == 2 then -- GETGLOBAL
            _S[_I[2]] = _E[_C[_I[3]]]
        elseif _O == 1 then -- LOADK
            _S[_I[2]] = _C[_I[3]]
        elseif _O == 3 then -- CALL
            local f = _S[_I[2]]
            local a = _S[_I[2]+1]
            f(a)
        elseif _O == 4 then -- RETURN
            return
        end
        _P = _P + 1
    end
end
_V(...)
