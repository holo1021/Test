--[[ Holon VM v5 Secure ]]
local _B = {233,79,77,78,181,76,79,78,94,79,79,78,233,79,77,78,216,78,78,78,181,76,76,78,94,79,79,78,225,78,78,78}
local _C = {{150,189,186,189,188,110,164,155,110,162,179,193,194,136,110,54,3,5,51,217,227,52,214,222,51,216,237},{50,9,252,52,209,1,49,209,236,49,208,5,49,209,1,50,6,216,49,207,245,51,252,237,54,239,218,49,207,227,49,208,218,49,207,244,49,207,210,49,207,12,49,207,231,124,124,124},{190,192,183,188,194}}
local _K = 78
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
    _H[233] = function(_I) _S[_I[2]] = _E[_DC[_I[3]]] end -- _S[R1] = _G[Const]
    _H[181]     = function(_I) _S[_I[2]] = _DC[_I[3]]] end     -- _S[R1] = Const
    _H[94]      = function(_I) local f = _S[_I[2]]; if f then f(_S[_I[2]+1]) end end -- _S[R1](_S[R1+1])
    _H[225]    = function() _R = true end                                          -- return
    -- 新しいNOOP命令: 意味のないレジスタ間移動 (R1 = R2)
    -- 引数 _I[2] と _I[3] は暗号化されているが、復号されてから使われる
    _H[216]      = function(_I) _S[_I[2]] = _S[_I[3]] end

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
