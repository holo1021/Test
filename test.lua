--[[ Holon VM v5 Secure ]]
local _vuxxx = {149,128,129,128,139,129,130,128,116,128,130,129,149,130,129,128,139,131,131,128,116,130,130,129,7,128,129,128}
local _ryzdh = {{240,130,235,133,241},{200,167,203,164,202,234,188,241,209,133,224,147,231,221,253,21,160,23,242,121,236,10,130,18,247,125,226},{100,223,113,151,20,167,68,199,89,186,56,143,108,239,92,184,0,138,105,232,79,170,4,155,115,210,94,189,60,169,74,200,68,167,38,128,99,226,102,133,4,186,89,216,65,111,65,111}}
local _PROTOS = {}
local _cvbsv = 128
local function _dubjr(...)
    local _yepzo, _oeape = {}, getfenv() or _G
    local _CS = {} -- Call Stack: {cl, pc, base, ret_reg}

    -- Helper to decode constants for a prototype, with caching
    local _DCCache = setmetatable({}, {__mode = "k"})
    local function get_dc(p)
        if _DCCache[p] then return _DCCache[p] end
        local dc = {}
        for i, v in ipairs(p.c) do
            local s = ""
            local last_byte = _cvbsv
            for j = 1, #v do
                local enc_byte = v[j]
                local dec_byte = bit32.bxor(enc_byte, last_byte)
                s = s .. string.char(dec_byte)
                last_byte = enc_byte
            end
            dc[i] = s
        end
        _DCCache[p] = dc
        return dc
    end

    -- Main closure setup
    local _CL = { p = { b = _vuxxx, c = _ryzdh, p = _PROTOS, np = 0 } }
    table.insert(_CS, { cl = _CL, pc = 1, base = 1, rr = 1 })

    local _drwob = {}
    local _anofx = 4 -- Instruction Width

    while #_CS > 0 do
        local frame = _CS[#_CS]
        local _CL, _vsydu, _BASE = frame.cl, frame.pc, frame.base
        local _BC = _CL.p.b
        local _iqxll = get_dc(_CL.p)

        if _vsydu > #_BC then
            -- Implicit return from function
            table.remove(_CS)
            goto continue_loop
        end

        local _nanby = _BC[_vsydu]
        frame.pc = _vsydu + _anofx

        local _iifes = { _nanby, bit32.bxor(_BC[_vsydu+1], _cvbsv), bit32.bxor(_BC[_vsydu+2], _cvbsv), bit32.bxor(_BC[_vsydu+3], _cvbsv) }

        if _nanby == 247 then _yepzo[_BASE + _iifes[2]] = _yepzo[_BASE + _iifes[3]]
        elseif _nanby == 139 then _yepzo[_BASE + _iifes[2]] = _iqxll[_iifes[3]]
        elseif _nanby == 149 then _yepzo[_BASE + _iifes[2]] = _oeape[_iqxll[_iifes[3]]]
        elseif _nanby == 5 then _oeape[_iqxll[_iifes[3]]] = _yepzo[_BASE + _iifes[2]]
        elseif _nanby == 207 then _yepzo[_BASE + _iifes[2]] = { p = _CL.p.p[_iifes[3]], uv = {} }
        elseif _nanby == 116 then
            local func_reg, n_args, n_ret = _iifes[2], _iifes[3] - 1, _iifes[4] - 1
            local func = _yepzo[_BASE + func_reg]
            if type(func) == "function" then
                local args = {}
                for i = 1, n_args do table.insert(args, _yepzo[_BASE + func_reg + i]) end
                local results = {pcall(func, unpack(args))}
                for i = 1, n_ret do _yepzo[_BASE + func_reg + i - 1] = results[i+1] end
            else
                table.insert(_CS, { cl = func, pc = 1, base = _BASE + func_reg, rr = _BASE + func_reg })
            end
        elseif _nanby == 7 then
            local ret_start, n_ret = _iifes[2], _iifes[3] - 1
            local caller_frame = _CS[#_CS-1]
            if caller_frame then
                for i = 1, n_ret do _yepzo[frame.rr + i - 1] = _yepzo[_BASE + ret_start + i - 1] end
            end
            table.remove(_CS)
        elseif _nanby == 255 then frame.pc = _vsydu + _iifes[4] * _anofx
        elseif _nanby == 29 then if not _yepzo[_BASE + _iifes[2]] then frame.pc = _vsydu + _iifes[4] * _anofx end
        elseif _nanby == 60 then _yepzo[_BASE + _iifes[2]] = _yepzo[_BASE + _iifes[3]] == _yepzo[_BASE + _iifes[4]]
        elseif _nanby == 64 then _yepzo[_BASE + _iifes[2]] = _yepzo[_BASE + _iifes[3]] + _yepzo[_BASE + _iifes[4]]
        elseif _nanby == 78 then _yepzo[_BASE + _iifes[2]] = _yepzo[_BASE + _iifes[3]] - _yepzo[_BASE + _iifes[4]]
        elseif _nanby == 173 then _yepzo[_BASE + _iifes[2]] = _yepzo[_BASE + _iifes[3]] * _yepzo[_BASE + _iifes[4]]
        elseif _nanby == 164 then _yepzo[_BASE + _iifes[2]] = _yepzo[_BASE + _iifes[3]] / _yepzo[_BASE + _iifes[4]]
        end

        ::continue_loop::
    end
end
_dubjr(...)
