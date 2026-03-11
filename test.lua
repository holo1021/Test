--[[ Holon VM v5 Secure ]]
local _cmbzf = {875902191,875967956,909521975,875902703,876034004,909522487,875836605}
local _qofbb = {{68,54,95,49,69},{124,19,127,16,126,94,8,69,101,49,84,39,83,105,73,161,20,163,70,205,88,190,54,166,67,201,86},{208,107,197,35,160,19,240,115,237,14,140,59,216,91,232,12,180,62,221,92,251,30,176,47,199,102,234,9,136,29,254,124,240,19,146,52,215,86,210,49,176,14,237,108,245,219,245,219}}
local _lcyii = 52
local function _uerke(_cmbzf, _qofbb, _arqzf, ...)
    local _rxaqx, _jctij = 1, getfenv() or _G
    local _args = {...}; for i=1, #_args do _arqzf[i-1] = _args[i] end
    local _esjgo = {}
    for i, v in ipairs(_qofbb) do
        local t = {}
        local last_byte = _lcyii -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _esjgo[i] = table.concat(t)
    end

    local _hwrjz = nil

    local _injoc = 1 -- Instruction Width
    local _ST = 2211
    local _IN, _ppyjj = 0, 0
    while _hwrjz == nil do
        if _ST == 2211 then
            if _rxaqx > #_cmbzf then _hwrjz = {} else
                _IN = _cmbzf[_rxaqx]
                _ppyjj = _IN % 256
                _ST = 7135
            end
        elseif _ST == 7135 then
            if _ppyjj == (-34 * 2 - 10 + 100) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = _arqzf[_ysnhp[3]][_esjgo[_ysnhp[4]]]
_ST = 7984
elseif _ppyjj == (14 * 2 - -6 + -33) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = -_arqzf[_ysnhp[3]]
_ST = 7984
elseif _ppyjj == (-64 * 2 - 17 + 203) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = not _arqzf[_ysnhp[3]]
_ST = 7984
elseif _ppyjj == (49 * 2 - -6 + 150) then
-- no-op
_ST = 7984
elseif _ppyjj == (-68 * 2 - 82 + 286) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_rxaqx = _rxaqx + _ysnhp[4] * _injoc
_ST = 7984
elseif _ppyjj == (-25 * 2 - -125 + 102) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = _arqzf[_ysnhp[3]]
_ST = 7984
elseif _ppyjj == (39 * 2 - 45 + 202) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
local proto_src = _esjgo[_ysnhp[3]]
                local p_func = loadstring(proto_src)
                if p_func then
                    local p = p_func()
                    _arqzf[_ysnhp[2]] = function(...)
                        local new_S = {}
                        new_S.parent = _arqzf
                        return _uerke(p.B, p.C, new_S, ...)
                    end
                end
_ST = 7984
elseif _ppyjj == (0 * 2 - -95 + 27) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
                    local target_S = _arqzf
                    for i=1, _ysnhp[3] do target_S = target_S.parent end
                    target_S[_ysnhp[2]] = _arqzf[_ysnhp[4]]
                
_ST = 7984
elseif _ppyjj == (127 * 2 - -21 + -256) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
local args = {}; for i=1, _ysnhp[3]-1 do args[i] = _arqzf[_ysnhp[2]+i] end; local res = {_arqzf[_ysnhp[2]](unpack(args))}; for i=1, _ysnhp[4] do _arqzf[_ysnhp[2]+i-1] = res[i] end
_ST = 7984
elseif _ppyjj == (124 * 2 - -63 + -157) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
if _arqzf[_ysnhp[2]+1] ~= nil then _arqzf[_ysnhp[2]] = _arqzf[_ysnhp[2]+1]; _rxaqx = _rxaqx + _ysnhp[4] * _injoc else _arqzf[_ysnhp[2]] = nil end
_ST = 7984
elseif _ppyjj == (118 * 2 - 69 + -141) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = _arqzf[_ysnhp[3]] ~= _arqzf[_ysnhp[4]]
_ST = 7984
elseif _ppyjj == (-121 * 2 - 53 + 502) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = _arqzf[_ysnhp[3]] * _arqzf[_ysnhp[4]]
_ST = 7984
elseif _ppyjj == (-22 * 2 - -48 + 143) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = _arqzf[_ysnhp[3]] <= _arqzf[_ysnhp[4]]
_ST = 7984
elseif _ppyjj == (106 * 2 - 110 + -17) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = _arqzf[_ysnhp[3]] + _arqzf[_ysnhp[4]]
_ST = 7984
elseif _ppyjj == (-52 * 2 - -77 + 78) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_jctij[_esjgo[_ysnhp[2]]] = _arqzf[_ysnhp[3]]
_ST = 7984
elseif _ppyjj == (-45 * 2 - 104 + 277) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]][_esjgo[_ysnhp[3]]] = _arqzf[_ysnhp[4]]
_ST = 7984
elseif _ppyjj == (-39 * 2 - 35 + 302) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
local n = _ysnhp[3] - 1; local t = {}; for i=0, n-1 do t[i+1] = _arqzf[_ysnhp[2]+i] end; _hwrjz = t
_ST = 7984
elseif _ppyjj == (-37 * 2 - -78 + 92) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = _arqzf[_ysnhp[3]] < _arqzf[_ysnhp[4]]
_ST = 7984
elseif _ppyjj == (-113 * 2 - -20 + 218) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };

_ST = 7984
elseif _ppyjj == (37 * 2 - 8 + 162) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = _arqzf[_ysnhp[3]] == _arqzf[_ysnhp[4]]
_ST = 7984
elseif _ppyjj == (-58 * 2 - -101 + 67) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
                    local target_S = _arqzf
                    for i=1, _ysnhp[4] do target_S = target_S.parent end
                    _arqzf[_ysnhp[2]] = target_S[_ysnhp[3]]
                
_ST = 7984
elseif _ppyjj == (-93 * 2 - -98 + 327) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = _jctij[_esjgo[_ysnhp[3]]]
_ST = 7984
elseif _ppyjj == (56 * 2 - -6 + 4) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };

_ST = 7984
elseif _ppyjj == (87 * 2 - 0 + 67) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
if _arqzf[_ysnhp[2]] then _rxaqx = _rxaqx + _ysnhp[4] * _injoc end
_ST = 7984
elseif _ppyjj == (-101 * 2 - -116 + 322) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]][_arqzf[_ysnhp[3]]] = _arqzf[_ysnhp[4]]
_ST = 7984
elseif _ppyjj == (-19 * 2 - 36 + 320) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = _arqzf[_ysnhp[3]] - _arqzf[_ysnhp[4]]
_ST = 7984
elseif _ppyjj == (-68 * 2 - -38 + 184) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = _arqzf[_ysnhp[3]][_arqzf[_ysnhp[4]]]
_ST = 7984
elseif _ppyjj == (-47 * 2 - -73 + 233) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = _esjgo[_ysnhp[3]]
_ST = 7984
elseif _ppyjj == (-87 * 2 - 97 + 279) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = tostring(_arqzf[_ysnhp[3]]) .. tostring(_arqzf[_ysnhp[4]])
_ST = 7984
elseif _ppyjj == (-2 * 2 - 88 + 147) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
            local f = _arqzf[_ysnhp[2]]
            if f then
                local nargs = _ysnhp[3] - 1
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _arqzf[_ysnhp[2] + i])
                end
                local results = { f(unpack(args)) }
                local nRes = _ysnhp[4] - 1
                if nRes > 0 then
                    for i = 1, nRes do _arqzf[_ysnhp[2] + i - 1] = results[i] end
                end
            end
_ST = 7984
elseif _ppyjj == (-15 * 2 - 84 + 352) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
_arqzf[_ysnhp[2]] = {}
_ST = 7984
elseif _ppyjj == (-18 * 2 - 10 + 162) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _ysnhp = { _ppyjj, bit32.bxor(_rA, _lcyii), bit32.bxor(_rB, _lcyii), bit32.bxor(_rC, _lcyii) };
if not _arqzf[_ysnhp[2]] then _rxaqx = _rxaqx + _ysnhp[4] * _injoc end
_ST = 7984
end
        elseif _ST == 7984 then
            _rxaqx = _rxaqx + _injoc
            _ST = 2211
        end
    end
    return unpack(_hwrjz or {})
end
return _uerke(_cmbzf, _qofbb, {}, ...)
