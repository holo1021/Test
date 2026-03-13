-- Holon VM Runtime
local function vm_run(bytecode, env, args_list, params, upvalues)
    local pc = 1        -- Program Counter
    local top = 0       -- Stack Top
    local stack = {}    -- Virtual Stack
    local locals = {}   -- Local Variables
    
    if params and args_list then
        for i, param in ipairs(params) do
            locals[param] = args_list[i]
        end
    end
    
    -- Opcode Mapping (Example)
    -- 1: LOAD_CONST, 2: GET_GLOBAL, 3: CALL, 4: STORE_LOCAL, 5: LOAD_LOCAL
    -- 6: GET_TABLE, 7: SET_TABLE, 8: SELF, 0: EXIT
    -- 9-12: Math, 13: JUMP, 14: JMP_FALSE, 15: CLOSURE, 16: RETURN
    -- 24: ITER_LOOP
    -- 25: INIT_LOCAL

    -- Polyfills for VM compatibility
    -- ipairs/pairs usually return 3 values. Our VM Call only captures 1 (simplification).
    -- So we wrap them to return a SINGLE stateful iterator closure.
    local _orig_ipairs = env.ipairs
    env.ipairs = function(t)
        local f, s, i = _orig_ipairs(t)
        return function()
            local i_new, v = f(s, i)
            i = i_new
            return i_new, v
        end
    end
    local _orig_pairs = env.pairs
    env.pairs = function(t)
        local f, s, k = _orig_pairs(t)
        return function()
            local k_new, v = f(s, k)
            k = k_new
            return k_new, v
        end
    end
    
    while true do
        local op_data = bytecode[pc]
        pc = pc + 1

        if not op_data then break end
        local op = op_data[1]
        local arg = op_data[2]

        if op == 0 then 
            break 
        elseif op == 1 then -- LOAD_CONST
            top = top + 1
            stack[top] = arg
        elseif op == 2 then -- GET_GLOBAL
            local val = env[arg] or (game and game[arg])
            -- Fallback: check upvalues if global is missing? No, standard Lua checks env last.
            -- But in this simple VM, we might have mixed up scopes.
            stack[top] = val
        elseif op == 3 then -- CALL
            local args_count = arg
            local func = stack[top - args_count]
            local args = {}
            for i = 1, args_count do
                args[i] = stack[top - args_count + i]
            end
            local res = func(unpack(args))
            top = top - args_count - 1
            if res then
                top = top + 1
                stack[top] = res
            else
                -- Push nil or keep balance? For simple statements, we assume stack balance
                top = top + 1
                stack[top] = nil
            end
        elseif op == 4 then -- STORE_LOCAL
            local val = stack[top]
            top = top - 1
            -- Check upvalues first to support writing to outer scope (Closure)
            if upvalues and upvalues[arg] ~= nil then
                upvalues[arg] = val
            else
                locals[arg] = val
            end
        elseif op == 5 then -- LOAD_LOCAL / GLOBAL FALLBACK
            local val = locals[arg]
            if val == nil and upvalues then val = upvalues[arg] end
            if val == nil then val = env[arg] end
            if val == nil and arg == "game" then val = game end
            top = top + 1
            stack[top] = val
        elseif op == 6 then -- GET_TABLE
            local obj = stack[top]
            local val = obj[arg]
            stack[top] = val
        elseif op == 7 then -- SET_TABLE
            local val = stack[top]
            local obj = stack[top-1]
            obj[arg] = val
            top = top - 2
        elseif op == 8 then -- SELF (Method prep)
            -- obj is at top.
            local obj = stack[top]
            local method = obj[arg]
            -- Stack: ... obj -> ... method obj
            stack[top] = method
            top = top + 1
            stack[top] = obj
        elseif op == 9 then -- ADD
            stack[top-1] = stack[top-1] + stack[top]; top=top-1
        elseif op == 10 then -- SUB
            stack[top-1] = stack[top-1] - stack[top]; top=top-1
        elseif op == 11 then -- MUL
            stack[top-1] = stack[top-1] * stack[top]; top=top-1
        elseif op == 12 then -- DIV
            stack[top-1] = stack[top-1] / stack[top]; top=top-1
        elseif op == 13 then -- JUMP
            pc = pc + arg
        elseif op == 14 then -- JUMP_IF_FALSE
            local val = stack[top]; top=top-1
            if not val then pc = pc + arg end
        elseif op == 15 then -- CLOSURE
            -- arg contains {params={...}, code={...}}
            local proto = arg
            local captured_locals = locals -- Capture current scope for the closure
            local function closure(...)
                return vm_run(proto.code, env, {...}, proto.params, captured_locals)
            end
            top = top + 1
            stack[top] = closure
        elseif op == 16 then -- RETURN
            return
        elseif op == 24 then -- ITER_LOOP
            -- stack[top] is iterator function. Call it.
            local iter = stack[top]
            local i, v = iter() -- Call the wrapped iterator
            if i then
                -- Continue loop: assign vars
                local var_names = arg.vars
                if var_names[1] then locals[var_names[1]] = i end
                if var_names[2] then locals[var_names[2]] = v end
                -- Don't increment PC, fall through to block
            else
                -- Loop finished: Pop iterator and Jump
                top = top - 1
                pc = pc + arg.skip
            end
        elseif op == 25 then -- INIT_LOCAL
            local val = stack[top]
            top = top - 1
            locals[arg] = val
        end
    end
end

local bytecode = {{5, "game"},{8, "GetService"},{1, "Players"},{3, 2},{25, "Players"},{5, "game"},{8, "GetService"},{1, "ReplicatedStorage"},{3, 2},{25, "ReplicatedStorage"},{5, "game"},{8, "GetService"},{1, "RunService"},{3, 2},{25, "RunService"},{5, "Players"},{6, "LocalPlayer"},{25, "player"},{5, "ReplicatedStorage"},{8, "WaitForChild"},{1, "GrabEvents"},{3, 2},{8, "WaitForChild"},{1, "CreateGrabLine"},{3, 2},{25, "grabEvent"},{5, "Instance"},{6, "new"},{1, "ScreenGui"},{3, 1},{25, "screenGui"},{5, "screenGui"},{1, "MapWideSpamUI"},{7, "Name"},{5, "screenGui"},{1, false},{7, "ResetOnSpawn"},{5, "screenGui"},{5, "player"},{8, "WaitForChild"},{1, "PlayerGui"},{3, 2},{7, "Parent"},{5, "Instance"},{6, "new"},{1, "TextButton"},{3, 1},{25, "toggleBtn"},{5, "toggleBtn"},{5, "UDim2"},{6, "new"},{1, 0},{1, 250},{1, 0},{1, 60},{3, 4},{7, "Size"},{5, "toggleBtn"},{5, "UDim2"},{6, "new"},{1, 0.5},{1, 125},{18, 0},{1, 0.85},{1, 0},{3, 4},{7, "Position"},{5, "toggleBtn"},{5, "Color3"},{6, "fromRGB"},{1, 20},{1, 20},{1, 20},{3, 3},{7, "BackgroundColor3"},{5, "toggleBtn"},{5, "Color3"},{6, "new"},{1, 1},{1, 1},{1, 1},{3, 3},{7, "TextColor3"},{5, "toggleBtn"},{5, "Enum"},{6, "Font"},{6, "SourceSansBold"},{7, "Font"},{5, "toggleBtn"},{1, 24},{7, "TextSize"},{5, "toggleBtn"},{1, "MAP ALL SPAM: OFF"},{7, "Text"},{5, "toggleBtn"},{5, "screenGui"},{7, "Parent"},{5, "Instance"},{6, "new"},{1, "UICorner"},{3, 1},{25, "corner"},{5, "corner"},{5, "UDim"},{6, "new"},{1, 0},{1, 15},{3, 2},{7, "CornerRadius"},{5, "corner"},{5, "toggleBtn"},{7, "Parent"},{1, false},{25, "active"},{5, "CFrame"},{6, "new"},{1, 0.939641953},{18, 0},{1, 0.372039795},{1, 0.499999046},{18, 0},{1, 0.106275439},{18, 0},{1, 0},{1, 0.994336784},{18, 0},{1, 1.18534182e-07},{18, 0},{1, 1},{1, 1.26690196e-08},{1, 0.994336784},{1, 5.96046448e-08},{1, 0.106275439},{18, 0},{3, 12},{25, "targetCFrame"},{1, 2000},{25, "targetFrequency"},{5, "RunService"},{6, "Heartbeat"},{8, "Connect"},{15, {params={"dt",}, code={{5, "active"},{17, 0},{14, 1},{16, 0},{5, "math"},{6, "ceil"},{5, "targetFrequency"},{5, "dt"},{11, 0},{3, 1},{25, "batchSize"},{5, "Players"},{8, "GetPlayers"},{3, 1},{25, "allPlayers"},{1, 1},{25, "i"},{5, "i"},{5, "batchSize"},{21, 0},{14, 37},{5, "ipairs"},{5, "allPlayers"},{3, 1},{24, {vars={"_","target"}, skip=28}},{5, "target"},{6, "Character"},{25, "char"},{5, "char"},{14, 22},{5, "char"},{8, "FindFirstChild"},{1, "Torso"},{3, 2},{5, "char"},{8, "FindFirstChild"},{1, "UpperTorso"},{3, 2},{23, 0},{5, "char"},{8, "FindFirstChild"},{1, "HumanoidRootPart"},{3, 2},{23, 0},{25, "targetPart"},{5, "targetPart"},{14, 5},{5, "grabEvent"},{8, "FireServer"},{5, "targetPart"},{5, "targetCFrame"},{3, 3},{13, -28},{5, "i"},{1, 1},{9, 0},{4, "i"},{13, -40},{0, 0},{5, "toggleBtn"},{6, "MouseButton1Click"},{8, "Connect"},{15, {params={}, code={{5, "active"},{17, 0},{4, "active"},{5, "active"},{14, 11},{5, "toggleBtn"},{1, "MAP ALL SPAM: ON"},{7, "Text"},{5, "toggleBtn"},{5, "Color3"},{6, "fromRGB"},{1, 150},{1, 0},{1, 0},{3, 3},{7, "BackgroundColor3"},{0, 0},}}},{3, 2},}}},{3, 2},{0, 0},}
vm_run(bytecode, getfenv(), {}, {})
