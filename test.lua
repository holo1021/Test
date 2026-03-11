--[[ Holon VM v5 Secure ]]
local _wfrut = {303239692,303043367,303239887,303239180,303108391,303239375,303174261}
local _ptacc = {{98,16,121,23,99},{90,53,89,54,88,120,46,99,67,23,114,1,117,79,111,135,50,133,96,235,126,152,16,128,101,239,112},{246,77,227,5,134,53,214,85,203,40,170,29,254,125,206,42,146,24,251,122,221,56,150,9,225,64,204,47,174,59,216,90,214,53,180,18,241,112,244,23,150,40,203,74,211,253,211,253}}
local _toznv = 18
local function _hpyrj(_wfrut, _ptacc, ...)
    local _jgcjj, _cuzvw, _eouhk = 1, {}, getfenv() or _G
    local _args = {...}; for i=1, #_args do _cuzvw[i-1] = _args[i] end
    local _vcgai = {}
    for i, v in ipairs(_ptacc) do
        local t = {}
        local last_byte = _toznv -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _vcgai[i] = table.concat(t)
    end

    local _xmnis = false

    local _fvidc = 1 -- Instruction Width
    local _ST = 9382
    local _IN, _ldrpc = 0, 0
    while not _xmnis do
        if _ST == 9382 then
            if _jgcjj > #_wfrut then _xmnis = true else
                _IN = _wfrut[_jgcjj]
                _ldrpc = _IN % 256
                _ST = 3226
            end
        elseif _ST == 3226 then
            if _ldrpc == (-29 * 2 - -104 + 51) then
-- no-op
_ST = 7971
elseif _ldrpc == (84 * 2 - -59 + -24) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _czget = { _ldrpc, bit32.bxor(_rA, _toznv), bit32.bxor(_rB, _toznv), bit32.bxor(_rC, _toznv) };
_cuzvw[_czget[2]] = _cuzvw[_czget[3]] + _cuzvw[_czget[4]]
_ST = 7971
elseif _ldrpc == (5 * 2 - 74 + 180) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _czget = { _ldrpc, bit32.bxor(_rA, _toznv), bit32.bxor(_rB, _toznv), bit32.bxor(_rC, _toznv) };
_cuzvw[_czget[2]][_vcgai[_czget[3]]] = _cuzvw[_czget[4]]
_ST = 7971
elseif _ldrpc == (40 * 2 - -124 + -173) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _czget = { _ldrpc, bit32.bxor(_rA, _toznv), bit32.bxor(_rB, _toznv), bit32.bxor(_rC, _toznv) };
local proto_src = _vcgai[_czget[3]]
                local p_func = loadstring(proto_src)
                if p_func then
                    local p = p_func() -- returns the Proto table
                    _cuzvw[_czget[2]] = function(...) return _hpyrj(p.B, p.C, ...) end
                end
_ST = 7971
elseif _ldrpc == (109 * 2 - 122 + -31) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _czget = { _ldrpc, bit32.bxor(_rA, _toznv), bit32.bxor(_rB, _toznv), bit32.bxor(_rC, _toznv) };
_cuzvw[_czget[2]] = _cuzvw[_czget[3]] * _cuzvw[_czget[4]]
_ST = 7971
elseif _ldrpc == (14 * 2 - -58 + -47) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _czget = { _ldrpc, bit32.bxor(_rA, _toznv), bit32.bxor(_rB, _toznv), bit32.bxor(_rC, _toznv) };
_cuzvw[_czget[2]] = _vcgai[_czget[3]]
_ST = 7971
elseif _ldrpc == (-96 * 2 - 5 + 415) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _czget = { _ldrpc, bit32.bxor(_rA, _toznv), bit32.bxor(_rB, _toznv), bit32.bxor(_rC, _toznv) };
_cuzvw[_czget[2]] = _cuzvw[_czget[3]] - _cuzvw[_czget[4]]
_ST = 7971
elseif _ldrpc == (67 * 2 - -81 + -203) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _czget = { _ldrpc, bit32.bxor(_rA, _toznv), bit32.bxor(_rB, _toznv), bit32.bxor(_rC, _toznv) };
_cuzvw[_czget[2]] = _eouhk[_vcgai[_czget[3]]]
_ST = 7971
elseif _ldrpc == (52 * 2 - -48 + 77) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _czget = { _ldrpc, bit32.bxor(_rA, _toznv), bit32.bxor(_rB, _toznv), bit32.bxor(_rC, _toznv) };
_cuzvw[_czget[2]] = _cuzvw[_czget[3]] == _cuzvw[_czget[4]]
_ST = 7971
elseif _ldrpc == (-95 * 2 - 70 + 446) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _czget = { _ldrpc, bit32.bxor(_rA, _toznv), bit32.bxor(_rB, _toznv), bit32.bxor(_rC, _toznv) };
_cuzvw[_czget[2]] = _cuzvw[_czget[3]] / _cuzvw[_czget[4]]
_ST = 7971
elseif _ldrpc == (63 * 2 - 114 + 224) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _czget = { _ldrpc, bit32.bxor(_rA, _toznv), bit32.bxor(_rB, _toznv), bit32.bxor(_rC, _toznv) };
_cuzvw[_czget[2]] = _cuzvw[_czget[3]][_vcgai[_czget[4]]]
_ST = 7971
elseif _ldrpc == (-65 * 2 - -65 + 158) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _czget = { _ldrpc, bit32.bxor(_rA, _toznv), bit32.bxor(_rB, _toznv), bit32.bxor(_rC, _toznv) };
_jgcjj = _jgcjj + _czget[4] * _fvidc
_ST = 7971
elseif _ldrpc == (-39 * 2 - 67 + 352) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _czget = { _ldrpc, bit32.bxor(_rA, _toznv), bit32.bxor(_rB, _toznv), bit32.bxor(_rC, _toznv) };
            local f = _cuzvw[_czget[2]]
            if f then
                local nargs = _czget[3]
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _cuzvw[_czget[2] + i])
                end
                f(unpack(args))
            end
_ST = 7971
elseif _ldrpc == (-76 * 2 - 116 + 385) then
_xmnis = true
_ST = 7971
elseif _ldrpc == (-24 * 2 - 103 + 217) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _czget = { _ldrpc, bit32.bxor(_rA, _toznv), bit32.bxor(_rB, _toznv), bit32.bxor(_rC, _toznv) };
_cuzvw[_czget[2]] = _cuzvw[_czget[3]]
_ST = 7971
elseif _ldrpc == (120 * 2 - 125 + -54) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _czget = { _ldrpc, bit32.bxor(_rA, _toznv), bit32.bxor(_rB, _toznv), bit32.bxor(_rC, _toznv) };
if not _cuzvw[_czget[2]] then _jgcjj = _jgcjj + _czget[4] * _fvidc end
_ST = 7971
end
        elseif _ST == 7971 then
            _jgcjj = _jgcjj + _fvidc
            _ST = 9382
        end
    end
end
_hpyrj(_wfrut, _ptacc, ...)
