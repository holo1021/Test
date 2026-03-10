--[[ Holon VM v5 Secure ]]
local _B = {28,98,96,99,54,97,98,99,14,99,99,99,63,98,98,99,28,98,96,99,54,97,97,99,14,99,99,99,63,98,98,99,172,99,99,99}
local _C = {{171,210,207,210,209,131,185,176,131,183,200,214,215,157,131,75,24,26,72,238,248,73,235,243,72,237,2},{71,30,17,73,230,22,70,230,1,70,229,26,70,230,22,71,27,237,70,228,10,72,17,2,75,4,239,70,228,248,70,229,239,70,228,9,70,228,231,70,228,33,70,228,252,145,145,145},{211,213,204,209,215}}
local _K = 99
local function _V(...)
    local _P, _S, _E = 1, {}, getfenv() or _G
    local _DC = {}
    for i, v in ipairs(_C) do
        local s = ""
        for j = 1, #v do s = s .. string.char((v[j] - _K) % 256) end
        _DC[i] = s
    end

    local _R = false
    local _H = {}
    _H[28] = function(_I) _S[_I[2]] = _E[_DC[_I[3]]] end -- _S[R1] = _G[Const]
    _H[54]     = function(_I) _S[_I[2]] = _DC[_I[3]] end     -- _S[R1] = Const
    _H[63]      = function(_I) local f = _S[_I[2]]; if f then f(_S[_I[2]+1]) end end -- _S[R1](_S[R1+1])
    _H[172]    = function() _R = true end                                          -- return
    -- 新しいNOOP命令: 意味のないレジスタ間移動 (R1 = R2)
    -- 引数 _I[2] と _I[3] は暗号化されているが、復号されてから使われる
    _H[14]      = function(_I) _S[_I[2]] = _S[_I[3]] end
    -- 算術演算命令 (R1 = R2 + R3)
    _H[45]       = function(_I) _S[_I[2]] = _S[_I[3]] + _S[_I[4]] end
    _H[196]       = function(_I) _S[_I[2]] = _S[_I[3]] - _S[_I[4]] end
    _H[145]       = function(_I) _S[_I[2]] = _S[_I[3]] * _S[_I[4]] end
    _H[200]       = function(_I) _S[_I[2]] = _S[_I[3]] / _S[_I[4]] end


    local _IW = 4 -- Instruction Width
    while not _R and _P <= #_B do
        local _O = _B[_P]
        local handler = _H[_O]
        if handler then
            -- ハンドラの互換性のために一時的な命令テーブルを作成
            -- オペランドをキーで復号
            local _I = {
                _O,
                bit32.bxor(_B[_P+1], _K),
                bit32.bxor(_B[_P+2], _K),
                bit32.bxor(_B[_P+3], _K)
            }
            handler(_I)
        end
        _P = _P + _IW
    end
end
_V(...)
