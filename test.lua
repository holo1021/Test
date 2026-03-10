--[[ Holon True VM ]]
local bytecode = {{1,1,1},{2,2,2},{3,1,1,0},{4,0,0},}
local constants = {"print","Hello from VM!",}

local function run()
    local pc = 1
    local stack = {}
    local env = getfenv() or _G

    while true do
        local inst = bytecode[pc]
        local op = inst[1]

        if op == 1 then -- GETGLOBAL
            stack[inst[2]] = env[constants[inst[3]]]
        elseif op == 2 then -- LOADK
            stack[inst[2]] = constants[inst[3]]
        elseif op == 3 then -- CALL
            local func = stack[inst[2]]
            local arg = stack[inst[2]+1]
            func(arg)
        elseif op == 4 then -- RETURN
            return
        end
        pc = pc + 1
    end
end
run()
