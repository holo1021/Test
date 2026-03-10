--[[ Holon VM v5 Secure ]]
local _jnykn = {3,98,96,99,86,99,99,99,130,97,98,99,206,98,98,99,3,98,96,99,86,99,99,99,130,97,97,99,86,99,99,99,206,98,98,99,162,99,99,99}
local _vjubc = {{43,68,40,71,41,9,95,18,50,102,3,112,4,62,30,246,67,244,17,154,15,233,97,241,20,158,1},{135,60,146,116,247,68,167,36,186,89,219,108,143,12,191,91,227,105,138,11,172,73,231,120,144,49,189,94,223,74,169,43,167,68,197,99,128,1,133,102,231,89,186,59,162,140,162,140},{19,97,8,102,18}}
local _vosiu = 99
local function _sveho(...)
    local _tjjdp, _lifen, _ilwgc = 1, {}, getfenv() or _G
    local _rpvwz = {}
    for i, v in ipairs(_vjubc) do
        local s = ""
        local last_byte = _vosiu -- 最初のキーはVMキー
        for j = 1, #v do
            local enc_byte = v[j]
            local dec_byte = bit32.bxor(enc_byte, last_byte)
            s = s .. string.char(dec_byte)
            last_byte = enc_byte -- 暗号化されたバイトが次の復号キーになる
        end
        _rpvwz[i] = s
    end

    local _kcves = false
    local _vnppm = {}
    _vnppm[3] = function(_rgkff) _lifen[_rgkff[2]] = _ilwgc[_rpvwz[_rgkff[3]]] end
    _vnppm[130]     = function(_rgkff) _lifen[_rgkff[2]] = _rpvwz[_rgkff[3]] end
    _vnppm[206]      = function(_rgkff) local f = _lifen[_rgkff[2]]; if f then f(_lifen[_rgkff[2]+1]) end end
    _vnppm[162]    = function() _kcves = true end
    
    -- NOOP & Math Ops
    _vnppm[86]      = function(_rgkff) _lifen[_rgkff[2]] = _lifen[_rgkff[3]] end
    -- 算術演算命令 (R1 = R2 + R3)
    _vnppm[110]       = function(_rgkff) _lifen[_rgkff[2]] = _lifen[_rgkff[3]] + _lifen[_rgkff[4]] end
    _vnppm[251]       = function(_rgkff) _lifen[_rgkff[2]] = _lifen[_rgkff[3]] - _lifen[_rgkff[4]] end
    _vnppm[13]       = function(_rgkff) _lifen[_rgkff[2]] = _lifen[_rgkff[3]] * _lifen[_rgkff[4]] end
    _vnppm[43]       = function(_rgkff) _lifen[_rgkff[2]] = _lifen[_rgkff[3]] / _lifen[_rgkff[4]] end

    local _iqrei = 4 -- Instruction Width
    
    -- 制御フロー平坦化 (Control Flow Flattening)
    local _hsjcd = 217 -- _hsjcd: State, 初期状態はFETCH
    local _iokov, _wcgrj -- _iokov: Temp Opcode, _wcgrj: Temp Instruction
    
    while _hsjcd ~= 101 do
        if _hsjcd == 217 then
            if not _kcves and _tjjdp <= #_jnykn then
                _iokov = _jnykn[_tjjdp] -- オペコードを一時保存
                _wcgrj = {      -- 命令全体を復号して一時保存
                    _iokov,
                    bit32.bxor(_jnykn[_tjjdp+1], _vosiu),
                    bit32.bxor(_jnykn[_tjjdp+2], _vosiu),
                    bit32.bxor(_jnykn[_tjjdp+3], _vosiu)
                }
                _hsjcd = 46 -- 次はDISPATCH状態へ
            else
                _hsjcd = 101 -- ループ終了
            end
        elseif _hsjcd == 46 then
            local handler = _vnppm[_iokov]
            if handler then
                handler(_wcgrj) -- 保存しておいた命令を実行
            end
            _tjjdp = _tjjdp + _iqrei
            _hsjcd = 217 -- 次はFETCH状態へ戻る
        else
            _hsjcd = 101 -- 不正な状態なら終了
        end
    end
end
_sveho(...)
