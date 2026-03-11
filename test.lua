--[[ Holon VM v5 Secure ]]
local _pbbhy = {1162102269,1162298600,1162167627,1195853211,1162102781,1162233576,1195853723,1162167608}
local _quazq = {{53,71,46,64,52},{13,98,14,97,15,47,121,52,20,64,37,86,34,24,56,208,101,210,55,188,41,207,71,215,50,184,39},{161,26,180,82,209,98,129,2,156,127,253,74,169,42,153,125,197,79,172,45,138,111,193,94,182,23,155,120,249,108,143,13,129,98,227,69,166,39,163,64,193,127,156,29,132,170,132,170}}
local _kffed = 69
local function _cpuix(_pbbhy, _quazq, _oudxk, ...)
    local _fmsxm, _gbxuh = 1, getfenv() or _G
    local _args = {...}; for i=1, #_args do _oudxk[i-1] = _args[i] end
    local _rlhjx = {}
    for i, v in ipairs(_quazq) do
        local t = {}
        local last_byte = _kffed -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            table.insert(t, string.char(dec_byte))
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _rlhjx[i] = table.concat(t)
    end

    local _vvtxy = nil

    local _hxtua = 1 -- Instruction Width
    local _ST = 2656
    local _IN, _miypt = 0, 0
    while _vvtxy == nil do
        if _ST == 2656 then
            if _fmsxm > #_pbbhy then _vvtxy = {} else
                _IN = _pbbhy[_fmsxm]
                _miypt = _IN % 256
                _ST = 1315
            end
        elseif _ST == 1315 then
            if _miypt == (-45 * 2 - 2 + 329) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = _oudxk[_qjofw[3]] == _oudxk[_qjofw[4]]
_ST = 2883
elseif _miypt == (62 * 2 - -86 + -108) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = _oudxk[_qjofw[3]] ~= _oudxk[_qjofw[4]]
_ST = 2883
elseif _miypt == (109 * 2 - -1 + -153) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = -_oudxk[_qjofw[3]]
_ST = 2883
elseif _miypt == (101 * 2 - 107 + -39) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
local n = _qjofw[3] - 1; local t = {}; for i=0, n-1 do t[i+1] = _oudxk[_qjofw[2]+i] end; _vvtxy = t
_ST = 2883
elseif _miypt == (39 * 2 - -103 + -16) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = {}
_ST = 2883
elseif _miypt == (97 * 2 - 66 + 125) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = _gbxuh[_rlhjx[_qjofw[3]]]
_ST = 2883
elseif _miypt == (-93 * 2 - 21 + 278) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
if _oudxk[_qjofw[2]] then _fmsxm = _fmsxm + _qjofw[4] * _hxtua end
_ST = 2883
elseif _miypt == (118 * 2 - 62 + 58) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = _rlhjx[_qjofw[3]]
_ST = 2883
elseif _miypt == (102 * 2 - 51 + 73) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]][_oudxk[_qjofw[3]]] = _oudxk[_qjofw[4]]
_ST = 2883
elseif _miypt == (-81 * 2 - 106 + 423) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
            local f = _oudxk[_qjofw[2]]
            if f then
                local nargs = _qjofw[3] - 1
                local args = {}
                for i = 1, nargs do
                    table.insert(args, _oudxk[_qjofw[2] + i])
                end
                local results = { f(unpack(args)) }
                local nRes = _qjofw[4] - 1
                if nRes > 0 then
                    for i = 1, nRes do _oudxk[_qjofw[2] + i - 1] = results[i] end
                end
            end
_ST = 2883
elseif _miypt == (113 * 2 - -79 + -145) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = _oudxk[_qjofw[3]] + _oudxk[_qjofw[4]]
_ST = 2883
elseif _miypt == (6 * 2 - 3 + 169) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = _oudxk[_qjofw[3]]
_ST = 2883
elseif _miypt == (-48 * 2 - 15 + 251) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
if not _oudxk[_qjofw[2]] then _fmsxm = _fmsxm + _qjofw[4] * _hxtua end
_ST = 2883
elseif _miypt == (124 * 2 - 71 + -163) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };

_ST = 2883
elseif _miypt == (35 * 2 - -19 + -3) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = _oudxk[_qjofw[3]] - _oudxk[_qjofw[4]]
_ST = 2883
elseif _miypt == (-21 * 2 - 45 + 270) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = _oudxk[_qjofw[3]] / _oudxk[_qjofw[4]]
_ST = 2883
elseif _miypt == (-9 * 2 - -22 + 251) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = _oudxk[_qjofw[3]] * _oudxk[_qjofw[4]]
_ST = 2883
elseif _miypt == (-104 * 2 - 96 + 544) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
                    local target_S = _oudxk
                    for i=1, _qjofw[4] do target_S = target_S.parent end
                    _oudxk[_qjofw[2]] = target_S[_qjofw[3]]
                
_ST = 2883
elseif _miypt == (93 * 2 - 107 + -41) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = _oudxk[_qjofw[3]][_oudxk[_qjofw[4]]]
_ST = 2883
elseif _miypt == (-59 * 2 - -53 + 140) then
-- no-op
_ST = 2883
elseif _miypt == (7 * 2 - 107 + 257) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = _oudxk[_qjofw[3]][_rlhjx[_qjofw[4]]]
_ST = 2883
elseif _miypt == (51 * 2 - -10 + -45) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = _oudxk[_qjofw[3]] < _oudxk[_qjofw[4]]
_ST = 2883
elseif _miypt == (-45 * 2 - 78 + 182) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
                    local target_S = _oudxk
                    for i=1, _qjofw[3] do target_S = target_S.parent end
                    target_S[_qjofw[2]] = _oudxk[_qjofw[4]]
                
_ST = 2883
elseif _miypt == (-122 * 2 - -61 + 402) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };

_ST = 2883
elseif _miypt == (-64 * 2 - -66 + 134) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]][_rlhjx[_qjofw[3]]] = _oudxk[_qjofw[4]]
_ST = 2883
elseif _miypt == (-41 * 2 - -123 + 16) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
local proto_src = _rlhjx[_qjofw[3]]
                local p_func = loadstring(proto_src)
                if p_func then
                    local p = p_func()
                    _oudxk[_qjofw[2]] = function(...)
                        local new_S = {}
                        new_S.parent = _oudxk
                        return _cpuix(p.B, p.C, new_S, ...)
                    end
                end
_ST = 2883
elseif _miypt == (-18 * 2 - -37 + 92) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_gbxuh[_rlhjx[_qjofw[2]]] = _oudxk[_qjofw[3]]
_ST = 2883
elseif _miypt == (-73 * 2 - -29 + 244) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = _oudxk[_qjofw[3]] <= _oudxk[_qjofw[4]]
_ST = 2883
elseif _miypt == (-68 * 2 - 25 + 257) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_fmsxm = _fmsxm + _qjofw[4] * _hxtua
_ST = 2883
elseif _miypt == (50 * 2 - 33 + 134) then
local _rA = math.floor(_IN / 256) % 256; local _rB = math.floor(_IN / 65536) % 256; local _rC = math.floor(_IN / 16777216) % 256; local _qjofw = { _miypt, bit32.bxor(_rA, _kffed), bit32.bxor(_rB, _kffed), bit32.bxor(_rC, _kffed) };
_oudxk[_qjofw[2]] = not _oudxk[_qjofw[3]]
_ST = 2883
end
        elseif _ST == 2883 then
            _fmsxm = _fmsxm + _hxtua
            _ST = 2656
        end
    end
    return unpack(_vvtxy or {})
end
return _cpuix(_pbbhy, _quazq, {}, ...)
