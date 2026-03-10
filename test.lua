--[[ Holon VM v5 Secure ]]
local _B = {163,71,69,70,45,68,71,70,15,71,71,70,163,71,69,70,45,68,68,70,173,70,70,70,15,71,71,70,149,70,70,70,173,70,70,70}
local _C = {{142,181,178,181,180,102,156,147,102,154,171,185,186,128,102,46,251,253,43,209,219,44,206,214,43,208,229},{42,1,244,44,201,249,41,201,228,41,200,253,41,201,249,42,254,208,41,199,237,43,244,229,46,231,210,41,199,219,41,200,210,41,199,236,41,199,202,41,199,4,41,199,223,116,116,116},{182,184,175,180,186}}
local _K = 70
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
    _H[163] = function(_I) _S[_I[2]] = _E[_DC[_I[3]]] end -- _S[R1] = _G[Const]
    _H[45]     = function(_I) _S[_I[2]] = _DC[_I[3]] end     -- _S[R1] = Const
    _H[15]      = function(_I) local f = _S[_I[2]]; if f then f(_S[_I[2]+1]) end end -- _S[R1](_S[R1+1])
    _H[149]    = function() _R = true end                                          -- return
    -- 新しいNOOP命令: 意味のないレジスタ間移動 (R1 = R2)
    -- 引数 _I[2] と _I[3] は暗号化されているが、復号されてから使われる
    _H[173]      = function(_I) _S[_I[2]] = _S[_I[3]] end

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
