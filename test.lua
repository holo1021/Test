--[[ holon v5 Register VM Obfuscator]]
return(function(...)
    -- VM Setup
    local g = getfenv and getfenv() or _G
    local char = g.string.char
    local concat = g.table.concat
    local floor = g.math.floor
    
    -- Bytecode and constants are passed in from the compiler
    local bytecode_str = "9.0,65799.0,16908291.0,65546.0"
    local constants_tbl = {"print","Hello from the new Holon VM!",}
    local shuffled_ops_tbl = {"JMP","SUB","ADD","CALL","GETTABLE","MOVE","TEST","LOADK","DIV","GETGLOBAL","RETURN","NEWTABLE","MUL","JUNK","SETGLOBAL","SETTABLE",}
    local place_id_check = nil

    -- PlaceId Lock Check & Decryption
    if place_id_check ~= nil then
        -- 難読化された方法でPlaceIdを取得
        local current_place_id = g["ga".."me"]["Pla".."ce".."Id"]
        
        -- IDが一致しない場合はVMを破壊 (無限ループでクラッシュさせる)
        if current_place_id ~= place_id_check then
            while true do end
        end

        -- 定数テーブルを復号するためのXOR関数
        local bxor = function(a,b)
            local p,c=1,0
            while a>0 and b>0 do local ra,rb=a%2,b%2;if ra~=rb then c=c+p end;a,b,p=(a-ra)/2,(b-rb)/2,p*2 end
            if a<b then a=b end
            while a>0 do local ra=a%2;if ra>0 then c=c+p end;a,p=(a-ra)/2,p*2 end
            return c
        end

        -- 定数テーブル内の暗号化された文字列を復号
        local key = current_place_id
        for i = 1, #constants_tbl do
            local const = constants_tbl[i]
            if type(const) == "table" then -- 暗号化された文字列はテーブルとして渡される
                local decrypted_chars = {}
                local rolling_key = key
                for j = 1, #const do
                    local dec_byte = bxor(const[j], rolling_key % 256)
                    decrypted_chars[j] = char(dec_byte)
                    rolling_key = (rolling_key * 167 + 13) % 65536
                end
                constants_tbl[i] = concat(decrypted_chars)
            end
        end
    end

    -- Deserialize bytecode string into a table of numbers
    local code = {}
    for num in g.string.gmatch(bytecode_str, "([^,]+)") do
        code[#code + 1] = g.tonumber(num)
    end

    --[[
        Opcode Mapping Reconstruction
        The compiler provides a shuffled list of opcode names.
        The VM has a master list in a fixed order.
        By comparing the two, we can build a map from the obfuscated (shuffled)
        opcode value to the real, canonical opcode value. This thwarts static analysis.
    --]]
    local MASTER_OPCODES = {
        "MOVE", "LOADK", "GETGLOBAL", "SETGLOBAL", "ADD", "SUB", "MUL", "DIV",
        "CALL", "RETURN", "JMP", "TEST", "NEWTABLE", "GETTABLE", "SETTABLE", "JUNK"
    }
    
    -- op_map[obfuscated_op_value] = canonical_op_value
    local op_map = {}
    for shuffled_idx, op_name in ipairs(shuffled_ops_tbl) do
        for master_idx, master_name in ipairs(MASTER_OPCODES) do
            if op_name == master_name then
                op_map[shuffled_idx - 1] = master_idx -- Obfuscated op (shuffled_idx-1) maps to canonical op (master_idx)
                break
            end
        end
    end

    -- VM Execution
    local pc = 1          -- Program Counter
    local stack = {}      -- Registers / Stack frames
    local base = 1        -- Base of current stack frame

    -- Main interpreter loop
    while true do
        local instruction = code[pc]
        pc = pc + 1

        -- Instruction Decoding (simple version)
        local op = instruction % 256
        local a = floor(instruction / 256) % 256
        local b = floor(instruction / 65536) % 256
        local c = floor(instruction / 16777216) % 256
        local bx = floor(instruction / 65536)
        
        -- Map the obfuscated opcode to its real one
        local canonical_op = op_map[op]

        -- Register mapping
        a = base + a
        b = base + b
        c = base + c

        -- Opcode Dispatch
        if canonical_op == 1 then -- MOVE
            stack[a] = stack[b]
        elseif canonical_op == 2 then -- LOADK
            stack[a] = constants_tbl[bx + 1]
        elseif canonical_op == 3 then -- GETGLOBAL
            stack[a] = g[constants_tbl[bx + 1]]
        elseif canonical_op == 4 then -- SETGLOBAL
            g[constants_tbl[bx + 1]] = stack[a]
        elseif canonical_op == 5 then -- ADD
            stack[a] = stack[b] + stack[c]
        elseif canonical_op == 6 then -- SUB
            stack[a] = stack[b] - stack[c]
        elseif canonical_op == 7 then -- MUL
            stack[a] = stack[b] * stack[c]
        elseif canonical_op == 8 then -- DIV
            stack[a] = stack[b] / stack[c]
        elseif canonical_op == 9 then -- CALL
            local n_args = b - 1
            local n_results = c - 1
            local args = {}
            for i = 1, n_args do
                args[i] = stack[a + i]
            end
            
            local results = {stack[a](g.unpack(args))}
            
            if n_results ~= 0 then
                for i = 1, n_results do
                    stack[a + i - 1] = results[i]
                end
            else
                for i=1, #results do
                    stack[a + i - 1] = results[i]
                end
            end
        elseif canonical_op == 10 then -- RETURN
            return
        elseif canonical_op == 11 then -- JMP
            pc = pc + (bx - 131071) -- sBx is signed with a bias
        elseif canonical_op == 12 then -- TEST
            if not stack[a] then
                pc = pc + 1 -- Skip next instruction (which should be a JMP)
            end
        elseif canonical_op == 13 then -- NEWTABLE
            stack[a] = {}
        elseif canonical_op == 14 then -- GETTABLE
            stack[a] = stack[b][stack[c]]
        elseif canonical_op == 15 then -- SETTABLE
            stack[a][stack[b]] = stack[c]
        elseif canonical_op == 16 then -- JUNK
            -- This is a junk instruction, do nothing.
        else
            return
        end
    end
end)(...)
