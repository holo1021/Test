local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- test.luaから持ってきたイベント定義
local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- 作者情報の定義
local AuthorName = "holon_calm"
local RobloxID = "najayou777"
local DetailIcon = "rbxassetid://7733964719"

-- リンク集を表示する共通関数（認証画面とメイン画面で使い回せます）
local function AddDetailContent(Tab)
    Tab:AddButton({
        Name = "EN version copy and launch",
        Callback = function()
            setclipboard("loadstring(game:HttpGet(\"https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/language/hub-en.lua\"))()")
            task.spawn(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/language/hub-en.lua"))()
            end)
        end
    })

    Tab:AddButton({
        Name = "TikTok",
        Callback = function()
            setclipboard("https://www.tiktok.com/@holon_calm")
            OrionLib:MakeNotification({Name = "リンク", Content = "TikTokのリンクをコピーしました", Time = 3})
        end
    })
    
    Tab:AddButton({
        Name = "Discord",
        Callback = function()
            setclipboard("https://discord.gg/EHBXqgZZYN")
            OrionLib:MakeNotification({Name = "リンク", Content = "Discordの招待リンクをコピーしました", Time = 3})
        end
    })
    
    Tab:AddButton({
        Name = "YouTube",
        Callback = function()
            setclipboard("https://www.youtube.com/@Holoncalm")
            OrionLib:MakeNotification({Name = "リンク", Content = "YouTubeのリンクをコピーしました", Time = 3})
        end
    })
    Tab:AddLabel("作者: " .. AuthorName)
    Tab:AddLabel("Roblox ID: " .. RobloxID)
end

-- BodyMover作成関数
local function createBodyMovers(part)
    -- 既存のMoverがあれば削除
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("BodyPosition") or child:IsA("BodyGyro") then
            child:Destroy()
        end
    end

    local bodyPosition = Instance.new("BodyPosition")
    local bodyGyro = Instance.new("BodyGyro")

    bodyPosition.P = 20000
    bodyPosition.D = 500
    bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyPosition.Parent = part

    bodyGyro.P = 3000
    bodyGyro.D = 100
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.Parent = part

    return bodyPosition, bodyGyro
end

local function getActiveTargetMain()
    if targetMainName == "" then return LocalPlayer end
    -- 名前から「今現在」のプレイヤーを探し直す
    return Players:FindFirstChild(targetMainName) or LocalPlayer
end

--------------------------------------------------------------------------------
-- [データ定義] ベクターパス / 形状データ
--------------------------------------------------------------------------------
local Paths = {
    -- アルファベット (A-Z, Space) の簡易ストロークデータ
    Alpha = {
        ["A"]={Vector2.new(0,0),Vector2.new(1,2),Vector2.new(2,0),Vector2.new(1.5,1),Vector2.new(0.5,1)},
        ["B"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(1.5,2),Vector2.new(1.5,1),Vector2.new(0,1),Vector2.new(1.5,1),Vector2.new(1.5,0),Vector2.new(0,0)},
        ["C"]={Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,0),Vector2.new(2,0)},
        ["D"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(1.5,1.5),Vector2.new(1.5,0.5),Vector2.new(0,0)},
        ["E"]={Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,1),Vector2.new(1.5,1),Vector2.new(0,1),Vector2.new(0,0),Vector2.new(2,0)},
        ["F"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,1),Vector2.new(1.5,1)},
        ["G"]={Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,0),Vector2.new(2,0),Vector2.new(2,1),Vector2.new(1,1)},
        ["H"]={Vector2.new(0,2),Vector2.new(0,0),Vector2.new(0,1),Vector2.new(2,1),Vector2.new(2,2),Vector2.new(2,0)},
        ["I"]={Vector2.new(0,2),Vector2.new(2,2),Vector2.new(1,2),Vector2.new(1,0),Vector2.new(0,0),Vector2.new(2,0)},
        ["J"]={Vector2.new(0,0.5),Vector2.new(1,0),Vector2.new(2,0.5),Vector2.new(2,2)},
        ["K"]={Vector2.new(0,2),Vector2.new(0,0),Vector2.new(0,1),Vector2.new(2,2),Vector2.new(0,1),Vector2.new(2,0)},
        ["L"]={Vector2.new(0,2),Vector2.new(0,0),Vector2.new(2,0)},
        ["M"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(1,1),Vector2.new(2,2),Vector2.new(2,0)},
        ["N"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,0),Vector2.new(2,2)},
        ["O"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,2),Vector2.new(2,0),Vector2.new(0,0)},
        ["P"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,2),Vector2.new(2,1),Vector2.new(0,1)},
        ["Q"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,2),Vector2.new(2,0),Vector2.new(0,0),Vector2.new(1,0.5),Vector2.new(2,-0.5)},
        ["R"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,2),Vector2.new(2,1),Vector2.new(0,1),Vector2.new(2,0)},
        ["S"]={Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,1),Vector2.new(2,1),Vector2.new(2,0),Vector2.new(0,0)},
        ["T"]={Vector2.new(0,2),Vector2.new(2,2),Vector2.new(1,2),Vector2.new(1,0)},
        ["U"]={Vector2.new(0,2),Vector2.new(0,0),Vector2.new(2,0),Vector2.new(2,2)},
        ["V"]={Vector2.new(0,2),Vector2.new(1,0),Vector2.new(2,2)},
        ["W"]={Vector2.new(0,2),Vector2.new(0.5,0),Vector2.new(1,1),Vector2.new(1.5,0),Vector2.new(2,2)},
        ["X"]={Vector2.new(0,2),Vector2.new(2,0),Vector2.new(1,1),Vector2.new(0,0),Vector2.new(2,2)},
        ["Y"]={Vector2.new(0,2),Vector2.new(1,1),Vector2.new(2,2),Vector2.new(1,1),Vector2.new(1,0)},
        ["Z"]={Vector2.new(0,2),Vector2.new(2,2),Vector2.new(0,0),Vector2.new(2,0)},
        [" "]={Vector2.new(0,0), Vector2.new(0,0)}
    },
    -- マカバ (Merkaba) 立体頂点
    Merkaba = { 
        Vector3.new(1,1,1),Vector3.new(-1,-1,1),Vector3.new(-1,1,-1),Vector3.new(1,-1,-1),
        Vector3.new(1,1,1),Vector3.new(-1,-1,-1),Vector3.new(1,1,-1),Vector3.new(1,-1,1),
        Vector3.new(-1,1,1),Vector3.new(-1,-1,-1) 
    },
    -- 五芒星
    Star = (function() local t={}; for i=0,5 do local a=math.rad(i*144+90); table.insert(t, Vector2.new(math.cos(a),math.sin(a))) end; return t end)(),
    -- 円
    Circle = (function() local t={}; for i=0,20 do local a=math.rad(i*18); table.insert(t, Vector2.new(math.cos(a),math.sin(a))) end; return t end)(),
    MagicCircle2 = (function()
        local t = {}
        -- 外側の大きな円
        for i = 0, 36 do
            local a = math.rad(i * 10)
            table.insert(t, Vector2.new(math.cos(a) * 2, math.sin(a) * 2))
        end
        -- 中間の円
        for i = 0, 24 do
            local a = math.rad(i * 15)
            table.insert(t, Vector2.new(math.cos(a) * 1.5, math.sin(a) * 1.5))
        end
        -- 内側の円
        for i = 0, 18 do
            local a = math.rad(i * 20)
            table.insert(t, Vector2.new(math.cos(a), math.sin(a)))
        end
        return t
    end)(),
    
    MagicCircle3 = (function()
        local t = {}
        -- 多重円構造
        for layer = 1, 5 do
            local radius = 2.5 - (layer * 0.4)
            local points = 12 + (layer * 4)
            for i = 0, points do
                local a = math.rad((360 / points) * i)
                table.insert(t, Vector2.new(math.cos(a) * radius, math.sin(a) * radius))
            end
        end
        return t
    end)(),
}

--------------------------------------------------------------------------------
-- [コンフィグ & 変数管理]
--------------------------------------------------------------------------------
local defaultConfig = {
    Wing = { Size = 30, Gap = 3.0, Speed = 6, Height = 0.5, Back = 0, Joints = 3, V_Angle = 0, Tilt = 0, Strength = 15, RootFixed = true, Curve = false, CurveAmount = 10 },
    Heart = { Size = 8, Speed = 2, Height = 5, Back = 2 },
    Star = { Size = 10, Speed = 2, Height = 5, Back = 0 },
    Vortex = { Size = 30, Speed = 10, Height = 20, Back = 0 },
    Sphere = { Size = 30, Speed = 30, Height = 5, Back = 0 },
    Rotate = { Size = 15, Speed = 6, Height = 7, Back = 0, Wave = false, WaveSpeed = 2, WaveAmp = 2 },
    Pet = { Size = 8, Speed = 2, Height = 4, Back = 12, Count = 2, Joints = 3, Gap = 13 },
    Text = { Size = 10, Speed = 5, Height = 6, Back = 2, Content = "HELLO", Mirror = false },
    MagicCircle = { Size = 12, Speed = 2, Height = -3, Back = 0 },
    MagicCircle2 = { Size = 15, Speed = 1, Height = -2, Back = 0, Layers = 3 },
    MagicCircle3 = { Size = 20, Speed = 0.5, Height = 5, Back = 0, Complexity = 5 },
    FloatStone = { Size = 10, Speed = 2, Height = 2, Back = 0, Chaos = false },
    Merkaba = { Size = 8, Speed = 2, Height = 7, Back = 0 },
    Cube = { Size = 5, Speed = 1, Height = 5, Back = 0 },
    Pyramid = { Size = 5, Speed = 1, Height = 5, Back = 0 },
    MirrorPlayer = { Size = 60, Speed = 10, Height = 0, Back = 0, Scale = 1, EdgeSpacing = 1 },
    Beam = { Size = 60, Speed = 50, Height = 0.5, Back = 0, Count = 8 },
    BackGuard = { Size = 10, Speed = 2, Height = 2, Back = 15 },
    Tornado = { Size = 20, Speed = 15, Height = 0, Back = 0, Radius = 5, TopRadius = 20 },
    Gyro = { Size = 20, Speed = 5, Height = 5, Back = 0, InnerSize = 12, CenterType = "Sphere" },
    Combined = {Mode1 = "Wing", Mode2 = "Merkaba", Mode3 = "なし", Mode1Count = 15, Mode2Count = 15, Mode3Count = 0},
    AnimSpeed = 1.0,
    Global = { MaxToys = 30, EffectRotation = Vector3.new(0,0,0), IndividualRotation = Vector3.new(0, -90, 0) },
}

-- Deep Copy Helper
local function deepCopy(target)
    local copy = {}
    for k, v in pairs(target) do copy[k] = (type(v) == "table") and deepCopy(v) or v end
    return copy
end

local selectedItemName = "全てのおもちゃ" 
local detectedItems = {}

local cfg = deepCopy(defaultConfig)
local useOtherToys = false
local isEnabled, currentMode, combinedActive = false, "Wing", false
local followPlayer = true
local lastBaseCF = nil
local targetMain, targetSub = LocalPlayer, LocalPlayer    
local activeToys = {}        -- {A0, A1, AP, AO, Part}
local originalCollisions = {} -- {Part: Boolean}
local updateConnection = nil

-- ジャイロ用物理変数
local gyroInnerAngularVelocity = 0
local gyroInnerAngle = 0
local lastUpdateTick = 0

--------------------------------------------------------------------------------
-- [計算ロジック] 各モードの座標計算
--------------------------------------------------------------------------------
local function getPositionForMode(mode, i, count, time)
    local c = cfg[mode] or cfg.Wing
    
    -- iは1からcountまで。比率を計算
    local ratio = (i-1) / (count > 1 and count-1 or 1)
    
    if mode == "Wing" then
    local side, idx, totalSide

    if combinedActive then
        -- 【合体モード】
        -- i は全体の通し番号(1,2,3,4...)なので、そのまま奇数/偶数で分ける
        side = (i % 2 == 1) and -1 or 1 -- 1->左(-1), 2->右(1)
        idx = math.ceil(i / 2)          -- 1,2番目は1段目、3,4番目は2段目...
        totalSide = math.ceil(count / 2)
    else
        -- 【単体モード】
        -- 自分のパーツ内での順番通りに並べる
        side = (i % 2 == 1) and -1 or 1
        idx = math.ceil(i / 2)
        totalSide = math.ceil(count / 2)
    end

    -- 以降の計算は共通
    local distRatio = idx / math.max(1, totalSide)
    
    local flapPhase = time * c.Speed
    if c.Joints > 0 then
        flapPhase = flapPhase - (idx * (0.5 / math.max(1, c.Joints)))
    end

    local flap = math.sin(flapPhase) * c.Strength
    if c.RootFixed then
        flap = flap * distRatio
    end
    
    local horizontalOffset = c.Gap + (c.Size * distRatio)
    local pos = Vector3.new(horizontalOffset * side, flap, 0)
    
    local rotCF = CFrame.Angles(
        math.rad(c.Tilt), 
        math.rad(c.V_Angle * side), 
        0
    )

    -- カーブ（反り）の計算：羽ばたきに連動させる
    if c.Curve then
        local curve_amount = c.CurveAmount or 10
        -- 羽ばたきの現在の位相（-1から1）を取得
        local flap_ratio = math.sin(flapPhase)
        -- 羽ばたきの上下両方で、先端にいくほど強く反る角度を計算
        local soar_angle = math.rad(flap_ratio * curve_amount * distRatio)
        -- 翼の根元を軸に回転させることで「反り」を表現
        rotCF = rotCF * CFrame.Angles(0, 0, soar_angle * side)
    end
    
    return (rotCF * pos) + Vector3.new(0, c.Height, c.Back)
        
    elseif mode == "Heart" then
        local t = (ratio * math.pi * 2) + time * c.Speed
        local x = 16 * math.sin(t)^3
        local y = 13 * math.cos(t) - 5 * math.cos(2*t) - 2 * math.cos(3*t) - math.cos(4*t)
        return Vector3.new(x * c.Size * 0.1, y * c.Size * 0.1 + c.Height, c.Back)

    elseif mode == "Star" then
        -- 綺麗な五芒星を描くためのロジック（直線補間）
        local totalPoints = 10 -- 5つの頂点 + 5つの谷
        -- アニメーション進行度
        local cycle = (time * c.Speed * 0.2 + ratio) % 1
        local currentStep = cycle * totalPoints
        
        local idx1 = math.floor(currentStep)
        local idx2 = (idx1 + 1) % totalPoints
        local alpha = currentStep % 1 -- 2点間のどこにいるか

        -- 星の頂点座標を計算するローカル関数
        local function getStarPoint(i)
            -- 36度ずつ回転、+90度で頂点を真上に
            local theta = math.rad(i * 36 + 90) 
            -- 偶数は外側(Size)、奇数は内側(Size * 0.382 -> 黄金比に近い鋭さ)
            local r = (i % 2 == 0) and c.Size or (c.Size * 0.382)
            -- Xを反転させると時計回り/反時計回りが調整可能（ここではそのまま）
            return Vector2.new(-math.cos(theta) * r, math.sin(theta) * r)
        end

        local p1 = getStarPoint(idx1)
        local p2 = getStarPoint(idx2)
        
        -- 丸みを消すため、計算した2点間を直線で結ぶ(Lerp)
        local p = p1:Lerp(p2, alpha)

        -- Heartモードと同じ向き（垂直）にする
        -- X=横幅, Y=高さ(縦幅), Z=奥行き(固定)
        return Vector3.new(p.X, p.Y + c.Height, c.Back)
        
    elseif mode == "Vortex" then
        -- 平らな渦
        local spiral = (i / count) * math.pi * 4 + time * c.Speed
        local dist = (i / count) * c.Size
        
        local x = math.cos(spiral) * dist
        local z = math.sin(spiral) * dist
        
        return Vector3.new(x, c.Height, z + c.Back)
        
    elseif mode == "Sphere" then
        -- 球体配置
        local phi = math.acos(-1 + (2 * i) / count)
        local theta = math.sqrt(count * math.pi) * phi + time * c.Speed
        
        local x = c.Size * math.cos(theta) * math.sin(phi)
        local y = c.Size * math.sin(theta) * math.sin(phi)
        local z = c.Size * math.cos(phi)
        
        return Vector3.new(x, y + c.Height, z + c.Back)

    elseif mode == "Rotate" or mode == "MagicCircle" then
    -- 回転・八卦：星形または円
    local shape = (mode == "MagicCircle" and (i % 2 == 0)) and Paths.Star or Paths.Circle
    local speed = c.Speed
    local totalPoints = #shape
    
    -- ★完全に書き直し
    local cycle = (time * speed * 0.1 + ratio) % 1
    local currentStep = cycle * totalPoints
    
    local idx1 = math.floor(currentStep) % totalPoints + 1
    local idx2 = (math.floor(currentStep) + 1) % totalPoints + 1
    local alpha = currentStep % 1
    
    -- 安全なLerp
    local p1 = shape[idx1]
    local p2 = shape[idx2]
    if not p1 or not p2 then return Vector3.zero end
    
    local p = p1:Lerp(p2, alpha)
    
    -- Y軸回転を追加
    local rotAngle = time * speed * 0.3
    local rotX = p.X * math.cos(rotAngle) - p.Y * math.sin(rotAngle)
    local rotY = p.X * math.sin(rotAngle) + p.Y * math.cos(rotAngle)
    
    local waveY = 0
    if c.Wave then
        waveY = math.sin(time * (c.WaveSpeed or 2) + i * 0.5) * (c.WaveAmp or 2)
    end
    
    return Vector3.new(rotX * c.Size, c.Height + waveY, rotY * c.Size + c.Back)

elseif mode == "MagicCircle2" then
    -- 画像1のような放射状の魔法陣
    local totalPoints = #Paths.MagicCircle2
    local cycle = (time * c.Speed * 0.05 + ratio) % 1
    local currentStep = cycle * totalPoints
    
    local idx1 = math.floor(currentStep) % totalPoints + 1
    local idx2 = (math.floor(currentStep) + 1) % totalPoints + 1
    local alpha = currentStep % 1
    
    local p1 = Paths.MagicCircle2[idx1]
    local p2 = Paths.MagicCircle2[idx2]
    if not p1 or not p2 then return Vector3.zero end
    
    local p = p1:Lerp(p2, alpha)
    
    -- Y軸回転
    local rotAngle = time * c.Speed * 0.2
    local rotX = p.X * math.cos(rotAngle) - p.Y * math.sin(rotAngle)
    local rotZ = p.X * math.sin(rotAngle) + p.Y * math.cos(rotAngle)
    
    -- 上下の波動
    local wave = math.sin(time * c.Speed + i * 0.5) * 0.5
    
    return Vector3.new(rotX * c.Size, c.Height + wave, rotZ * c.Size + c.Back)

elseif mode == "MagicCircle3" then
    -- 画像2のような垂直ビーム風の魔法陣
    local totalPoints = #Paths.MagicCircle3
    local cycle = (time * c.Speed * 0.03 + ratio) % 1
    local currentStep = cycle * totalPoints
    
    local idx1 = math.floor(currentStep) % totalPoints + 1
    local idx2 = (math.floor(currentStep) + 1) % totalPoints + 1
    local alpha = currentStep % 1
    
    local p1 = Paths.MagicCircle3[idx1]
    local p2 = Paths.MagicCircle3[idx2]
    if not p1 or not p2 then return Vector3.zero end
    
    local p = p1:Lerp(p2, alpha)
    
    -- ゆっくり回転
    local rotAngle = time * c.Speed * 0.1
    local rotX = p.X * math.cos(rotAngle) - p.Y * math.sin(rotAngle)
    local rotZ = p.X * math.sin(rotAngle) + p.Y * math.cos(rotAngle)
    
    return Vector3.new(rotX * c.Size, c.Height, rotZ * c.Size + c.Back)

    elseif mode == "Pet" then
        -- 設定から各種パラメータを取得
        local petCountSetting = cfg.Pet.Count or 2
        local totalFws = count -- 使用可能な全花火数
        
        -- 1体あたりの花火数を計算
        local fwsPerPet = math.floor(totalFws / petCountSetting)
        if fwsPerPet < 1 then fwsPerPet = 1 end

        -- 現在の花火(i)が、何体目のペットの、何番目のパーツか
        local petIndex = math.ceil(i / fwsPerPet)
        local partIndexInPet = (i - 1) % fwsPerPet 
        
        -- 指定したペット数を超える余り花火は非表示
        if petIndex > petCountSetting then
            return Vector3.new(0, -1000, 0)
        end

        -- パーツの役割分担 (0:体, 1:左羽, 2:右羽)
        local role = 0 
        local sideIndex = 0
        if partIndexInPet == 0 then
            role = 0 -- 最初の1個は体
        elseif partIndexInPet <= math.ceil((fwsPerPet - 1) / 2) then
            role = 1 -- 左羽
            sideIndex = partIndexInPet
        else
            role = 2 -- 右羽
            sideIndex = partIndexInPet - math.ceil((fwsPerPet - 1) / 2)
        end

        -- ペット自体の配置（Gapを使用して間隔を調整）
        local petSide = (petIndex % 2 == 0) and 1 or -1
        local horizontalOffset = (c.Gap or 5) + (math.floor((petIndex - 1) / 2) * 8)
        
        -- 共通の浮遊ムーブ
        local hover = math.sin(time * c.Speed) * 1.2
        local bob = math.cos(time * c.Speed * 0.5) * 1
        
        local basePos = Vector3.new(
            petSide * horizontalOffset,
            c.Height + hover,
            c.Back + bob
        )

        if role == 0 then
            return basePos
        else
            -- 羽の計算
            local wingSide = (role == 1) and -1 or 1
            
            -- ★ここを修正：c.Size を羽の広がり（幅）に直接反映
            -- sideIndex（羽の中のパーツ番号）に比例して、c.Sizeの分だけ外に広がります
            local wingSpread = (sideIndex * (c.Size * 0.1)) 
            
            local flapPhase = time * c.Speed * 3 - (sideIndex * 0.3)
            local flap = math.sin(flapPhase) * 2
            
            local jointFactor = (c.Joints or 3) * 0.2
            
            return basePos + Vector3.new(
                wingSide * (1 + jointFactor + wingSpread), -- c.Sizeがここにかかる
                flap * (1 + jointFactor),
                -0.5 + (sideIndex * 0.1)
            )
        end

    elseif mode == "FloatStone" then
        -- アニメーションの「カオス展開」の動きを計算に導入
        local rTime = time * cfg[mode].Speed
        local spread = cfg[mode].Size
        
        -- 複数の正弦波を組み合わせて不規則な軌道を生成
        local x = math.cos(rTime + i * 1.5) * spread
        local y = math.sin(rTime * 0.7 + i) * (spread * 0.5) + cfg[mode].Height
        local z = math.sin(rTime * 1.2 + i * 2.2) * spread + cfg[mode].Back
        
        return Vector3.new(x, y, z)

-- [Textモードの計算ロジック抜粋] 

    elseif mode == "Text" then
        local str = cfg.Text.Content
        local chars = {}
        for char in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
            table.insert(chars, char)
        end
        local numChars = #chars
        if numChars == 0 then return Vector3.zero end
    
        local fwsPerChar = math.max(1, math.floor(count / numChars))
        local charIndex = math.clamp(math.ceil(i / fwsPerChar), 1, numChars)
    
        local charStr = chars[charIndex]
        local path = Paths.Alpha[charStr:upper()] or Paths.Alpha[" "]
        
        -- アニメーション計算
        local totalPoints = #path
        local speed = math.max(1, math.floor(c.Speed)) * 0.5
        local cycle = (time * speed + (i % fwsPerChar) * 0.1) % 2 
        local tP = (cycle < 1) and (cycle * (totalPoints - 1)) or ((2 - cycle) * (totalPoints - 1))
        local idx1 = math.floor(tP) + 1
        local idx2 = math.min(idx1 + 1, totalPoints)
        local p = path[idx1]:Lerp(path[idx2] or path[idx1], tP % 1)
        
        -- ★ 文字間隔の自動調節
        -- サイズ(c.Size)が大きくなれば間隔(spacing)も広がるように設定
        local charSizeScale = c.Size * 0.4
        local spacing = c.Size * 1.2 -- 1.2倍の間隔で自動調整
        local totalWidth = (numChars - 1) * spacing
        
        -- 配置計算 (反転なし、常に正面)
        local xPos = p.X * charSizeScale * -1 -- 文字の形が正しく見える向き
        local yPos = p.Y * charSizeScale
        local xOffset = ((charIndex - 1) * spacing - (totalWidth / 2)) * -1
        
        return Vector3.new(xOffset + xPos, yPos + c.Height, -c.Back)

    elseif mode == "Merkaba" then
        -- マカバ：3D回転
        local totalP = #Paths.Merkaba
        local tP = (time * c.Speed + ratio * totalP) % totalP
        local p1 = Paths.Merkaba[math.floor(tP) + 1]
        local p2 = Paths.Merkaba[(math.floor(tP) % totalP) + 1]
        
        local p = p1:Lerp(p2, tP % 1) * c.Size
        
        -- 複雑な3軸回転
        local rot = CFrame.Angles(time, time * 1.5, 0)
        return (rot * p) + Vector3.new(0, c.Height + math.sin(time * 2), c.Back)

    elseif mode == "Cube" then
        -- 立方体の頂点定義
        local size = c.Size
        local v = {
            Vector3.new(size, size, size),      -- 1: 右上前
            Vector3.new(-size, size, size),     -- 2: 左上前
            Vector3.new(size, -size, size),     -- 3: 右下前
            Vector3.new(-size, -size, size),    -- 4: 左下前
            Vector3.new(size, size, -size),     -- 5: 右上後
            Vector3.new(-size, size, -size),    -- 6: 左上後
            Vector3.new(size, -size, -size),    -- 7: 右下後
            Vector3.new(-size, -size, -size)    -- 8: 左下後
        }

        -- ■ 変更点: 「辺」ではなく「面（4頂点のループ）」を定義
        local faces = {
            {v[1], v[2], v[4], v[3]}, -- 前面ループ
            {v[5], v[6], v[8], v[7]}, -- 背面ループ
            {v[1], v[5], v[6], v[2]}, -- 上面ループ
            {v[3], v[7], v[8], v[4]}, -- 底面ループ
            {v[1], v[5], v[7], v[3]}, -- 右面ループ
            {v[2], v[6], v[8], v[4]}  -- 左面ループ
        }

        local numFaces = #faces
        
        -- 1. おもちゃを6つの面に順番に割り振る
        local faceIdx = ((i - 1) % numFaces) + 1
        local currentFace = faces[faceIdx]

        -- 2. 進行具合の計算 (周回ループ)
        local speed = c.Speed * 0.5 
        -- おもちゃごとに位置をずらす (i * 0.25) ことで重なりを防ぐ
        local totalProgress = (time * speed) + (i * 0.25)
        
        -- 3. 現在どの辺(0~3)にいるか、その辺のどこ(0.0~1.0)にいるか
        local edgeIndex = math.floor(totalProgress) % 4 + 1
        local nextEdgeIndex = (edgeIndex % 4) + 1 -- 次の頂点
        local alpha = totalProgress % 1 -- 辺の上の進捗 (0.0 -> 1.0)

        -- 4. 座標を計算
        local p1 = currentFace[edgeIndex]
        local p2 = currentFace[nextEdgeIndex]
        
        local pos = p1:Lerp(p2, alpha)
        
        return pos + Vector3.new(0, c.Height, c.Back)

    elseif mode == "Pyramid" then
        local s = c.Size
        -- ピラミッドの頂点定義
        local top = Vector3.new(0, s, 0)
        local fl = Vector3.new(-s, -s, s)  -- 前左
        local fr = Vector3.new(s, -s, s)   -- 前右
        local br = Vector3.new(s, -s, -s)  -- 後右
        local bl = Vector3.new(-s, -s, -s) -- 後左
        
        -- 面（頂点のループ）を定義
        local faces = {
            {top, fl, fr}, -- 前面
            {top, fr, br}, -- 右面
            {top, br, bl}, -- 後面
            {top, bl, fl}, -- 左面
            {fl, fr, br, bl} -- 底面
        }
        
        local numFaces = #faces
        local faceIdx = ((i - 1) % numFaces) + 1
        local currentFace = faces[faceIdx]
        local numVerts = #currentFace
        
        local speed = c.Speed * 0.5
        local totalProgress = (time * speed) + (i * 0.25)
        
        local edgeIndex = math.floor(totalProgress) % numVerts + 1
        local nextEdgeIndex = (edgeIndex % numVerts) + 1
        local alpha = totalProgress % 1
        
        local p1 = currentFace[edgeIndex]
        local p2 = currentFace[nextEdgeIndex]
        
        return p1:Lerp(p2, alpha) + Vector3.new(0, c.Height, c.Back)

    elseif mode == "MirrorPlayer" then
        local char = targetMain.Character
        if not char then return Vector3.new(0,0,0) end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return Vector3.new(0,0,0) end

        -- 1. R6パーツ定義（サイズと名前をセット）
        local bodyParts = {
            { name = "Head",      size = Vector3.new(1.2, 1.2, 1.2) },
            { name = "Torso",     size = Vector3.new(2, 2, 1) },
            { name = "Left Arm",  size = Vector3.new(1, 2, 1) },
            { name = "Right Arm", size = Vector3.new(1, 2, 1) },
            { name = "Left Leg",  size = Vector3.new(1, 2, 1) },
            { name = "Right Leg", size = Vector3.new(1, 2, 1) }
        }

        local toysPerPart = math.max(1, math.floor(count / #bodyParts))
        local partIdx = math.min(math.ceil(i / toysPerPart), #bodyParts)
        local localIdx = ((i - 1) % toysPerPart) + 1
        local data = bodyParts[partIdx]
        
        -- 対象の部位を特定
        local targetPart = char:FindFirstChild(data.name) or root

        -- 2. サイズと形状の計算（ここはおもちゃの形を作る）
        local s = data.size * c.Size * 0.5
        local t = (time * c.Speed) % 4
        local step = t % 1
        local edge = math.floor(t)
        local faceIdx = (localIdx - 1) % 6
        local p = Vector3.new(0,0,0)

        if faceIdx == 0 then p = (edge==0 and Vector3.new(-s.X+s.X*2*step,-s.Y,s.Z) or edge==1 and Vector3.new(s.X,-s.Y+s.Y*2*step,s.Z) or edge==2 and Vector3.new(s.X-s.X*2*step,s.Y,s.Z) or Vector3.new(-s.X,s.Y-s.Y*2*step,s.Z))
        elseif faceIdx == 1 then p = (edge==0 and Vector3.new(-s.X+s.X*2*step,-s.Y,-s.Z) or edge==1 and Vector3.new(s.X,-s.Y+s.Y*2*step,-s.Z) or edge==2 and Vector3.new(s.X-s.X*2*step,s.Y,-s.Z) or Vector3.new(-s.X,s.Y-s.Y*2*step,-s.Z))
        elseif faceIdx == 2 then p = (edge==0 and Vector3.new(s.X,-s.Y,-s.Z+s.Z*2*step) or edge==1 and Vector3.new(s.X,-s.Y+s.Y*2*step,s.Z) or edge==2 and Vector3.new(s.X,s.Y,s.Z-s.Z*2*step) or Vector3.new(s.X,s.Y-s.Y*2*step,-s.Z))
        elseif faceIdx == 3 then p = (edge==0 and Vector3.new(-s.X,-s.Y,-s.Z+s.Z*2*step) or edge==1 and Vector3.new(-s.X,-s.Y+s.Y*2*step,s.Z) or edge==2 and Vector3.new(-s.X,s.Y,s.Z-s.Z*2*step) or Vector3.new(-s.X,s.Y-s.Y*2*step,-s.Z))
        elseif faceIdx == 4 then p = (edge==0 and Vector3.new(-s.X+s.X*2*step,s.Y,-s.Z) or edge==1 and Vector3.new(s.X,s.Y,-s.Z+s.Z*2*step) or edge==2 and Vector3.new(s.X-s.X*2*step,s.Y,s.Z) or Vector3.new(-s.X,s.Y,s.Z-s.Z*2*step))
        else p = (edge==0 and Vector3.new(-s.X+s.X*2*step,-s.Y,-s.Z) or edge==1 and Vector3.new(s.X,-s.Y,-s.Z+s.Z*2*step) or edge==2 and Vector3.new(s.X-s.X*2*step,-s.Y,s.Z) or Vector3.new(-s.X,-s.Y,s.Z-s.Z*2*step)) end

        -- 3. 【これが「位置」を直す魔法の式】
        -- 自分の各部位が「RootPartから見てどこにいるか」というオフセットを計算
        -- PointToObjectSpace を使うことで、エモート等でズレた位置も自動計算されます
        local partRelativePos = root.CFrame:PointToObjectSpace(targetPart.Position)
        
        -- 背後距離(Back)と高さ(Height)のオフセット
        local extraOffset = Vector3.new(0, c.Height, -c.Back)
        
        -- 回転情報を適用（部位が傾けばおもちゃの枠も傾く）
        local rotatedBoxPoint = (root.CFrame:Inverse() * targetPart.CFrame).Rotation * p

        -- 全部を足して返す
        -- [部位の相対位置] + [一筆書きの頂点] + [ユーザー設定のズレ]
        return partRelativePos + rotatedBoxPoint + extraOffset

    elseif mode == "Beam" then
        -- Y方向の光の柱
        local ang = (i % c.Count) * (math.pi * 2 / c.Count)
        local radius = c.Size * 0.3
        
        -- 円周配置
        local x = math.cos(ang) * radius
        local z = math.sin(ang) * radius
        
        -- Y軸高速往復
        local yOsc = math.sin(time * c.Speed + (i / count) * math.pi * 2)
        local y = yOsc * c.Size
        
        return Vector3.new(x, y + c.Height, z + c.Back)

    elseif mode == "BackGuard" then
        local spread = c.Size
    
         -- 各石のランダム位置(固定シードで再現性確保)
        local seed = i * 123.456
        local randomX = (math.sin(seed) * 2 - 1) * spread  -- 左右にバラバラ
        local randomY = (math.cos(seed * 1.3) * 2 - 1) * (spread * 0.3) + c.Height  -- 上下にバラバラ
    
        -- 後ろ側に配置
        local backDistance = c.Back + math.abs(math.sin(seed * 0.7)) * spread * 0.5
    
        -- 微妙な浮遊動作
        local hover = math.sin(time * c.Speed + i * 0.5) * 0.5
    
        return Vector3.new(randomX, randomY + hover, -backDistance)

    elseif mode == "Tornado" then
        local r1 = c.Radius or 5
        local r2 = c.TopRadius or 20
        local h = c.Size -- Sizeを高さとして使用
        local ratio = (i - 1) / (count > 1 and count - 1 or 1)
        local currentR = r1 + (r2 - r1) * ratio
        local currentH = h * ratio

        if c.Pyramid then
            -- 四角形の経路
            local totalProgress = (time * c.Speed * 0.2) + (ratio * 4)
            local side = math.floor(totalProgress) % 4
            local progressOnSide = totalProgress % 1
            
            local x, z
            if side == 0 then -- 上
                x = -currentR + (currentR * 2 * progressOnSide)
                z = currentR
            elseif side == 1 then -- 右
                x = currentR
                z = currentR - (currentR * 2 * progressOnSide)
            elseif side == 2 then -- 下
                x = currentR - (currentR * 2 * progressOnSide)
                z = -currentR
            else -- 左
                x = -currentR
                z = -currentR + (currentR * 2 * progressOnSide)
            end
            return Vector3.new(x, currentH + c.Height, z + c.Back)
        else
            local theta = time * c.Speed + ratio * math.pi * 4
            return Vector3.new(math.cos(theta) * currentR, currentH + c.Height, math.sin(theta) * currentR + c.Back)
        end

    elseif mode == "Gyro" then
        local outerLimit = math.ceil(count * 0.5)
        local innerLimit = math.ceil(count * 0.8)
        local finalPos
        
        if i <= outerLimit then
            -- 外側の縦向き円 (XY平面)
            local idx = i
            local total = outerLimit
            local r = c.Size
            local angle = (idx / total) * math.pi * 2 + time * c.Speed -- 外側も回転させる
            
            local x = math.cos(angle) * r
            local y = math.sin(angle) * r
            finalPos = Vector3.new(x, y, 0)
            
        else
            -- 内側（内側の円 + 中心）
            if i <= innerLimit then
                -- 内側の円 (斜めに回転)
                local idx = i - outerLimit
                local total = innerLimit - outerLimit
                local r = c.Size
                local angle = (idx / total) * math.pi * 2 + time * c.Speed
                
                -- YZ平面の円をベースにする
                local y = math.cos(angle) * r
                local z = math.sin(angle) * r
                
                -- Z軸周りに45度回転させて斜めにする
                local tilt = math.rad(45)
                local tx = -y * math.sin(tilt) -- x(0) * cos - y * sin
                local ty = y * math.cos(tilt)  -- x(0) * sin + y * cos
                
                finalPos = Vector3.new(tx, ty, z)
            else
                -- 中心オブジェクト (選択可能)
                local idx = i - innerLimit
                local total = count - innerLimit
                local r = (c.InnerSize or (c.Size * 0.6)) * 0.4
                local cType = c.CenterType or "Sphere"
                
                if cType == "Sphere" then
                    local phi = math.acos(-1 + (2 * idx) / total)
                    local theta = math.sqrt(total * math.pi) * phi + time * c.Speed * 2
                    local x = r * math.cos(theta) * math.sin(phi)
                    local y = r * math.sin(theta) * math.sin(phi)
                    local z = r * math.cos(phi)
                    finalPos = Vector3.new(x, y, z)
                elseif cType == "Cube" then
                    local t = time * c.Speed
                    local x = math.clamp(math.sin(t + idx) * r * 1.5, -r, r)
                    local y = math.clamp(math.cos(t * 1.1 + idx) * r * 1.5, -r, r)
                    local z = math.clamp(math.sin(t * 1.3 + idx) * r * 1.5, -r, r)
                    finalPos = Vector3.new(x, y, z)
                elseif cType == "Vertical" then
                    local angle = (idx / total) * math.pi * 2 + time * c.Speed * 4
                    local x = math.cos(angle) * r
                    local y = math.sin(angle) * r
                    finalPos = Vector3.new(x, y, 0)
                else -- Random
                    local seed = idx * 13.37
                    local x = math.sin(time * 2 + seed) * r
                    local y = math.cos(time * 2.5 + seed) * r
                    local z = math.sin(time * 1.5 + seed) * r
                    finalPos = Vector3.new(x, y, z)
                end
            end

            -- 内側のみエフェクト全体（構造）を回転させる
            local rotAngle = gyroInnerAngle -- 物理ベースの角度を使用
            local rx = finalPos.X * math.cos(rotAngle) - finalPos.Z * math.sin(rotAngle)
            local rz = finalPos.X * math.sin(rotAngle) + finalPos.Z * math.cos(rotAngle)
            finalPos = Vector3.new(rx, finalPos.Y, rz)
        end
        
        if not finalPos then return Vector3.zero end

        -- エフェクト全体は回転させず、オフセットのみ適用
        return Vector3.new(finalPos.X, finalPos.Y + c.Height, finalPos.Z + c.Back)
    end
    
    return Vector3.zero
end

--------------------------------------------------------------------------------
-- [メイン機能] エフェクト制御 (Start / Stop / Update)
--------------------------------------------------------------------------------
local function stopEffect()
    isEnabled = false
    if updateConnection then 
        updateConnection:Disconnect()
        updateConnection = nil 
    end
    
    -- ジャイロの状態をリセット
    gyroInnerAngularVelocity = 0
    gyroInnerAngle = 0
    
    -- アタッチメント削除 & 固定化
    for _, v in ipairs(activeToys) do
        pcall(function() 
            v.Part.Anchored = false 
            v.A0:Destroy()
            v.A1:Destroy()
            v.AP:Destroy()
            v.AO:Destroy() 
        end)
    end
    activeToys = {}
    
    -- 当たり判定復元
    for part, val in pairs(originalCollisions) do
        if part and part.Parent then 
            part.CanCollide = val 
        end
    end
    originalCollisions = {}
end

local function startEffect()
    stopEffect()
    activeToys = {}
    lastUpdateTick = tick() -- 物理計算用の時間リセット

    if not targetMain or not targetMain.Character then return end
    local root = targetMain.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local fws = {}
    local myName = LocalPlayer.Name
    
    local maxCount
    if combinedActive then
        local c1 = (cfg.Combined.Mode1 ~= "なし") and (cfg.Combined.Mode1Count or 15) or 0
        local c2 = (cfg.Combined.Mode2 ~= "なし") and (cfg.Combined.Mode2Count or 15) or 0
        local c3 = (cfg.Combined.Mode3 ~= "なし") and (cfg.Combined.Mode3Count or 0) or 0
        maxCount = c1 + c2 + c3
    else
        maxCount = cfg.Global.MaxToys or 30 
    end

    local allMyItems = {}
    local plotsFolder = Workspace:FindFirstChild("Plots")
    local plotItemsFolder = Workspace:FindFirstChild("PlotItems")

    -- 0. Get items from SpawnedInToys (Cosmic style)
    if useOtherToys then
        for _, folder in ipairs(Workspace:GetChildren()) do
            if folder.Name:match("SpawnedInToys$") then
                for _, item in ipairs(folder:GetChildren()) do
                    table.insert(allMyItems, item)
                end
            end
        end
    else
        local spawnedToys = Workspace:FindFirstChild(myName .. "SpawnedInToys")
        if spawnedToys then
            for _, item in ipairs(spawnedToys:GetChildren()) do
                table.insert(allMyItems, item)
            end
        end
    end

    -- 1. Get items from my plot
    if plotsFolder and plotItemsFolder then
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local ownerObj = sign and (sign:FindFirstChild("ThisPlotsOwners") or sign:FindFirstChild("Owner"))
            if ownerObj then
                local val = ownerObj:FindFirstChild("Value") or ownerObj
                local data = val:FindFirstChild("Data") or val
                local isMine = (data:IsA("StringValue") and data.Value == myName)
                
                if isMine or useOtherToys then
                    local myPlotName = plot.Name
                    local targetFolder = plotItemsFolder:FindFirstChild(myPlotName)
                    if targetFolder then
                        for _, item in ipairs(targetFolder:GetChildren()) do
                            table.insert(allMyItems, item)
                        end
                    end
                    if isMine and not useOtherToys then break end
                end
            end
        end
    end

    -- 2. Get items directly from Workspace that I own
    for _, item in ipairs(Workspace:GetChildren()) do
        local ownerValue = item:FindFirstChild("Owner") or item:FindFirstChild("PartOwner")
        if item:IsA("Model") and ownerValue and ownerValue:IsA("StringValue") then
            if (ownerValue.Value == myName or useOtherToys) and not table.find(allMyItems, item) then
                 table.insert(allMyItems, item)
            end
        end
    end

    -- 3. Filter items based on selection and add to fws
    for _, item in ipairs(allMyItems) do
        if #fws >= maxCount then break end
        if item:IsA("Model") and item.PrimaryPart and (selectedItemName == "全てのおもちゃ" or item.Name == selectedItemName) then
            table.insert(fws, item)
        end
    end

    -- 4. Ensure network ownership for all found items
    for _, item in ipairs(fws) do
        for _, part in ipairs(item:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part:SetNetworkOwner(LocalPlayer) end)
            end
        end
    end

    if #fws == 0 then
        warn("おもちゃが見つかりませんでした。")
        return
    end

        print("おもちゃを " .. #fws .. " 個捕捉しました。 (目標数: " .. maxCount .. ")")

   -- ネットワークオーナーシップを強制的に取得
    for i, model in ipairs(fws) do
        local pp = model.PrimaryPart
        
        -- 全パーツの勢いを殺す
        for _, d in ipairs(model:GetDescendants()) do 
            if d:IsA("BasePart") then
                d.AssemblyLinearVelocity = Vector3.zero
                d.AssemblyAngularVelocity = Vector3.zero
                pcall(function() d:SetNetworkOwner(LocalPlayer) end)
            end
        end
        
        -- スタート時の爆発を防ぐため、計算上の初期位置に直接配置する
        if root then
            local m, relIdx, relTotal
            if combinedActive then
                local c1 = (cfg.Combined.Mode1 ~= "なし") and (cfg.Combined.Mode1Count or 15) or 0
                local c2 = (cfg.Combined.Mode2 ~= "なし") and (cfg.Combined.Mode2Count or 15) or 0
                
                if i <= c1 then
                    m = cfg.Combined.Mode1
                    relIdx = i
                    relTotal = c1
                elseif i <= c1 + c2 then
                    m = cfg.Combined.Mode2
                    relIdx = i - c1
                    relTotal = c2
                else
                    m = cfg.Combined.Mode3
                    relIdx = i - c1 - c2
                    relTotal = cfg.Combined.Mode3Count or 0
                end
            else
                m = currentMode
                relIdx = i
                relTotal = #fws
            end
            if m and m ~= "なし" then
                local relativePos = getPositionForMode(m, relIdx, relTotal, tick())
                pp.CFrame = root.CFrame:ToWorldSpace(CFrame.new(relativePos))
            end
        end
        
        pp.Anchored = false -- 配置が終わってから物理を有効化
        pcall(function() pp:SetNetworkOwner(LocalPlayer) end)

        -- 当たり判定無効化
        for _, d in ipairs(model:GetDescendants()) do 
            if d:IsA("BasePart") then 
                if originalCollisions[d] == nil then originalCollisions[d] = d.CanCollide end
                d.CanCollide = false
                d.CanTouch = false
                d.CanQuery = false
            end 
        end
        
        -- (AttachmentやAlignPositionの設定はそのまま...)
        local a0 = Instance.new("Attachment", pp)
        local ap = Instance.new("AlignPosition", pp)
        ap.Attachment0 = a0
        ap.Mode = Enum.PositionAlignmentMode.OneAttachment
        ap.MaxForce = 1e9
        ap.Responsiveness = 200
        
        local ao = Instance.new("AlignOrientation", pp)
        ao.Attachment0 = a0
        ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
        ao.MaxTorque = 1e9
        ao.Responsiveness = 200
        
        table.insert(activeToys, {A0=a0, AP=ap, AO=ao, Part=pp})
    end
    
    isEnabled = true

    updateConnection = RunService.RenderStepped:Connect(function()
    local char = targetMain.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- ジャイロの物理演算
    local now = tick()
    local deltaTime = now - lastUpdateTick
    lastUpdateTick = now

    local playerVelocity = rootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)
    local playerSpeed = playerVelocity.Magnitude
    local targetAngularVelocity = playerSpeed * 0.1 -- 速度に応じて目標回転速度を設定
    local damping = 0.97 -- 慣性の強さ (1に近いほど強い)
    gyroInnerAngularVelocity = gyroInnerAngularVelocity * damping + targetAngularVelocity * (1 - damping)
    gyroInnerAngle = gyroInnerAngle + gyroInnerAngularVelocity * deltaTime

    local baseCF
    if followPlayer then
        -- 追従ON：常にプレイヤーの最新座標を基準にする
        baseCF = rootPart.CFrame
        lastBaseCF = baseCF
    else
        -- 追従OFF：lastBaseCF があればそれを「絶対」に使う
        if not lastBaseCF then
            lastBaseCF = rootPart.CFrame
        end
        baseCF = lastBaseCF
    end

    local t = tick()
    
    -- エフェクト全体の回転を計算
    local effectRot = cfg.Global.EffectRotation or Vector3.zero
    local effectRotationCF = CFrame.Angles(math.rad(effectRot.X), math.rad(effectRot.Y), math.rad(effectRot.Z))
    local rotatedBaseCF = baseCF * effectRotationCF

    -- おもちゃ個別の回転を計算
    local indivRot = cfg.Global.IndividualRotation or Vector3.new(0, -90, 0)
    local individualRotation = CFrame.Angles(math.rad(indivRot.X), math.rad(indivRot.Y), math.rad(indivRot.Z))
    
    for i, fw in ipairs(activeToys) do
        -- 奈落判定
        if fw.Part.Position.Y <= -90 then
            -- 奈落に落ちている場合は固定して何もしない
            fw.Part.Anchored = true
        else
            -- 奈落に落ちていない場合のみ、通常処理を行う (continueの代わり)
            fw.Part.Anchored = false

            local m, relIdx, relTotal
            if combinedActive then
                local c1 = (cfg.Combined.Mode1 ~= "なし") and (cfg.Combined.Mode1Count or 15) or 0
                local c2 = (cfg.Combined.Mode2 ~= "なし") and (cfg.Combined.Mode2Count or 15) or 0

                if i <= c1 then
                    m = cfg.Combined.Mode1
                    relIdx = i
                    relTotal = c1
                elseif i <= c1 + c2 then
                    m = cfg.Combined.Mode2
                    relIdx = i - c1
                    relTotal = c2
                else
                    m = cfg.Combined.Mode3
                    relIdx = i - c1 - c2
                    relTotal = cfg.Combined.Mode3Count or 0
                end
            else
                m = currentMode
                relIdx = i
                relTotal = #activeToys
            end

            if m and m ~= "なし" then
                local relativePos = getPositionForMode(m, relIdx, relTotal, t)
                local worldPos = rotatedBaseCF:PointToWorldSpace(relativePos)
                fw.AP.Position = worldPos
                if m == "BackGuard" then
                    fw.AO.CFrame = CFrame.lookAt(worldPos, rotatedBaseCF.Position) * individualRotation
                elseif m == "Rotate" or m == "MagicCircle" or m == "FloatStone" or m == "Merkaba" or m == "Cube" or m == "Tornado" or m == "Pyramid" or m == "Gyro" then
                    -- CFrame.lookAtが同じ座標でエラーを起こしフリーズするのを防ぐ
                    local nextPos = rotatedBaseCF:PointToWorldSpace(getPositionForMode(m, relIdx, relTotal, t + 0.05))
                    if (worldPos - nextPos).Magnitude < 0.001 then
                        -- 座標が同じ場合はデフォルトの向きを使い、エラーを回避
                        fw.AO.CFrame = rotatedBaseCF * individualRotation
                    else
                        fw.AO.CFrame = CFrame.lookAt(worldPos, nextPos) * individualRotation
                    end
                else
                    fw.AO.CFrame = rotatedBaseCF * individualRotation
                end
            else
                fw.AP.Position = Vector3.new(0, -10000, 0)
            end
        end -- if 奈落判定の閉じ
    end -- for ループの閉じ
end)
end

--------------------------------------------------------------------------------
-- [UI 構築] orion lib
--------------------------------------------------------------------------------
local KeyFileName = "HolonHub_Key.txt"
local CorrectKey = "holox"
local OrionUrl = "https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/source.txt"

-- [[ 1. メイン画面の関数 ]]
local function StartHolonHUB()
    -- スマホ対策：OrionLibを関数内で読み込み直す
    local OrionLib = loadstring(game:HttpGet(OrionUrl))()
    
    -- 既存のUIを強制削除（二重表示防止）
    pcall(function()
        if game:GetService("CoreGui"):FindFirstChild("Orion") then 
            game:GetService("CoreGui").Orion:Destroy() 
        end
    end)

    local Window = OrionLib:MakeWindow({
        Name = "Holon HUB v1.4.3 [Effect Only]",
        HidePremium = false,
        SaveConfig = false,
        ConfigFolder = "HolonHUB",
        IntroEnabled = true,
        IntroText = "Holon HUB Load!"
    })

-- プレイヤーリスト取得関数
local function getPList()
    local plist = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(plist, p.DisplayName .. " (@" .. p.Name .. ")")
    end
    return plist
end

-- UI要素を管理するテーブル
local UIElements = {}

-- 翻訳テーブル
local modeNames = {
    ["Wing"] = "翼 (Wing)", ["Heart"] = "ハート (Heart)", ["Star"] = "星 (Star)", ["Vortex"] = "渦 (Vortex)",
    ["Sphere"] = "球体 (Sphere)", ["Rotate"] = "回転 (Rotate)", ["Pet"] = "ペット (Pet)", ["Text"] = "文字 (Text)",
    ["MagicCircle"] = "魔法陣 (MagicCircle)", ["MagicCircle2"] = "魔法陣2 (MagicCircle2)", ["MagicCircle3"] = "魔法陣3 (MagicCircle3)",
    ["FloatStone"] = "浮遊石 (FloatStone)", ["Merkaba"] = "マカバ (Merkaba)", ["Cube"] = "立方体 (Cube)",
    ["Pyramid"] = "ピラミッド (Pyramid)", ["MirrorPlayer"] = "分身 (MirrorPlayer)", ["Beam"] = "ビーム (Beam)",
    ["BackGuard"] = "背後ガード (BackGuard)", ["Tornado"] = "竜巻 (Tornado)", ["Gyro"] = "ジャイロ (Gyro)", ["なし"] = "なし"
}
local modeKeys = {}
for k, v in pairs(modeNames) do modeKeys[v] = k end
local function getModeList()
    local list = {}
    local order = {"Wing","Heart","Star","Vortex","Sphere","Rotate","Pet","Text","MagicCircle","MagicCircle2","MagicCircle3","FloatStone","Merkaba","Cube","Pyramid","MirrorPlayer","Beam","BackGuard","Tornado","Gyro"}
    for _, k in ipairs(order) do table.insert(list, modeNames[k]) end
    return list
end

-- --- TAB: MAIN ---
local MainTab = Window:MakeTab({
	Name = "メイン",
	Icon = "rbxassetid://7733960981"
})

local MainSec = MainTab:AddSection({
	Name = "エフェクト制御"
})

-- メイン対象ドロップダウン（変数として定義）
local targetMainName = "" -- 名前を保存する変数を新しく用意

UIElements.MainTargetDropdown = MainSec:AddDropdown({
    Name = "メイン対象",
    Default = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")",
    Options = getPList(),
    Callback = function(v)
        -- @以降を正確に切り出す
        local name = v:match("@([^)]+)")
        targetMainName = name or LocalPlayer.Name
        targetMain = Players:FindFirstChild(targetMainName) or LocalPlayer
    end    
})

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    UIElements.MainTargetDropdown:Refresh(getPList(), true)
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    UIElements.MainTargetDropdown:Refresh(getPList(), true)
end)

-- エフェクト有効化トグル
UIElements.EffectToggle = MainSec:AddToggle({
	Name = "エフェクト有効化",
	Default = false,
	Callback = function(v)
		if v then startEffect() else stopEffect() end
	end    
})

-- モード選択ドロップダウン
UIElements.ModeDropdown = MainSec:AddDropdown({
	Name = "モード選択",
	Default = modeNames["Wing"],
	Options = getModeList(),
	Callback = function(v)
		currentMode = modeKeys[v]
		combinedActive = false
	end    
})

-- 制御対象ドロップダウン
local itemDropdown

UIElements.ItemDropdown = MainSec:AddDropdown({
    Name = "制御対象の選択",
    Default = "なし",
    Options = {"なし"},
    Callback = function(v)
        selectedItemName = v
    end    
})
itemDropdown = UIElements.ItemDropdown

-- おもちゃリストをスキャンしてドロップダウンを更新する共通関数
local function refreshToyList()
    detectedItems = {}
    local myName = LocalPlayer.Name
    local allMyItems = {}
    local plotsFolder = Workspace:FindFirstChild("Plots")
    local plotItemsFolder = Workspace:FindFirstChild("PlotItems")

    -- 0. Get items from SpawnedInToys
    if useOtherToys then
        for _, folder in ipairs(Workspace:GetChildren()) do
            if folder.Name:match("SpawnedInToys$") then
                for _, item in ipairs(folder:GetChildren()) do
                    table.insert(allMyItems, item)
                end
            end
        end
    else
        local spawnedToys = Workspace:FindFirstChild(myName .. "SpawnedInToys")
        if spawnedToys then
            for _, item in ipairs(spawnedToys:GetChildren()) do
                table.insert(allMyItems, item)
            end
        end
    end

    -- 1. Get items from my plot
    if plotsFolder and plotItemsFolder then
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local ownerObj = sign and (sign:FindFirstChild("ThisPlotsOwners") or sign:FindFirstChild("Owner"))
            if ownerObj then
                local val = ownerObj:FindFirstChild("Value") or ownerObj
                local data = val:FindFirstChild("Data") or val
                local isMine = (data:IsA("StringValue") and data.Value == myName)
                
                if isMine or useOtherToys then
                    local myPlotName = plot.Name
                    local targetFolder = plotItemsFolder:FindFirstChild(myPlotName)
                    if targetFolder then
                        for _, item in ipairs(targetFolder:GetChildren()) do
                            table.insert(allMyItems, item)
                        end
                        -- ★このフォルダの増減を監視開始 (初回のみ)
                        if isMine and not _G.ToyWatcher then
                            _G.ToyWatcher = true
                            targetFolder.ChildAdded:Connect(function() task.wait(0.1) refreshToyList() end)
                            targetFolder.ChildRemoved:Connect(function() task.wait(0.1) refreshToyList() end)
                        end
                    end
                    if isMine and not useOtherToys then break end
                end
            end
        end
    end

    -- 2. Get items directly from Workspace that I own
    for _, item in ipairs(Workspace:GetChildren()) do
        local ownerValue = item:FindFirstChild("Owner") or item:FindFirstChild("PartOwner")
        if item:IsA("Model") and ownerValue and ownerValue:IsA("StringValue") then
            if (ownerValue.Value == myName or useOtherToys) and not table.find(allMyItems, item) then
                 table.insert(allMyItems, item)
            end
        end
    end

    -- 3. Process all found items to create the name list
    for _, item in ipairs(allMyItems) do
        if item:IsA("Model") and item.PrimaryPart then
            local itemName = tostring(item.Name)
            if not table.find(detectedItems, itemName) then
                table.insert(detectedItems, itemName)
            end
        end
    end
    
    -- 4. Update dropdown
    local newValues = {"全てのおもちゃ"}
    for _, name in ipairs(detectedItems) do table.insert(newValues, name) end
    itemDropdown:Refresh(newValues, true)
end

MainSec:AddButton({
    Name = "おもちゃリスト更新",
    Callback = function()
        refreshToyList()
        OrionLib:MakeNotification({ Name = "更新", Content = "おもちゃリストを再スキャンしました", Time = 3 })
    end
})

UIElements.OtherToysToggle = MainSec:AddToggle({
    Name = "他人のおもちゃも使用",
    Default = false,
    Callback = function(v)
        useOtherToys = v
        refreshToyList()
    end
})

-- 起動時に一度実行
task.spawn(refreshToyList)

-- 合体モードトグル
UIElements.CombinedToggle = MainSec:AddToggle({
	Name = "合体モード使用",
	Default = false,
	Callback = function(v)
		combinedActive = v
	end    
})

-- 追従切り替え
UIElements.FollowToggle = MainSec:AddToggle({
    Name = "プレイヤー追従",
    Default = true,
    Callback = function(v)
        followPlayer = v
    end
})

-- 最大おもちゃ数
UIElements.MaxToysSlider = MainSec:AddSlider({
    Name = "使用するおもちゃの最大数",
    Min = 1, Max = 200, Default = cfg.Global.MaxToys or 100,
    Callback = function(v) cfg.Global.MaxToys = v end
})

-- アニメ速度倍率 (小数のため10倍で処理)
UIElements.AnimSpeedSlider = MainSec:AddSlider({
    Name = "アニメ速度倍率",
    Min = 1, Max = 50, Default = 10,
    Callback = function(v) cfg.AnimSpeed = v/10 end
})

-- --- アニメーションセクション ---
local AnimSec = MainTab:AddSection({
	Name = "アニメーション"
})

local seqRunning = false
AnimSec:AddToggle({
	Name = "変形シーケンス",
    Default = false,
	Callback = function(v)
        seqRunning = v
        if v then
            task.spawn(function()
                local s = 1 / cfg.AnimSpeed
                currentMode = "MagicCircle"
                cfg.MagicCircle.Height = -10
                startEffect()
                for i = -10, 5, 0.5 do 
                    if not seqRunning then break end
                    cfg.MagicCircle.Height = i
                    task.wait(0.2 * s) 
                end
                if not seqRunning then return end
                currentMode = "Merkaba"
                task.wait(6 * s)
                if not seqRunning then return end
                currentMode = "FloatStone"
                cfg.FloatStone.Chaos = true
                cfg.FloatStone.Size = 2
                for i = 2, 15, 0.5 do
                    if not seqRunning then break end
                    cfg.FloatStone.Size = i
                    task.wait(0.05 * s)
                end
            end)
        end
	end
})

local surgeRunning = false
AnimSec:AddToggle({
	Name = "Surge",
    Default = false,
	Callback = function(v)
        surgeRunning = v
        if v then
            task.spawn(function()
                local s = 1 / cfg.AnimSpeed
                currentMode = "MagicCircle"
                cfg.MagicCircle.Height = -3
                cfg.MagicCircle.Size = 5
                cfg.MagicCircle.Speed = 10
                startEffect()
                for i = 5, 30, 2 do
                    if not surgeRunning then break end
                    cfg.MagicCircle.Size = i
                    task.wait(0.09 * s)
                end
                if not surgeRunning then return end
                currentMode = "Sphere"
                cfg.Sphere.Size = 30
                task.wait(1 * s)
                if not surgeRunning then return end
                for i = 30, 3, 2 do
                    if not surgeRunning then break end
                    cfg.Sphere.Size = i
                    cfg.Sphere.Speed = (cfg.Sphere.Speed or 1) + 0.5
                    task.wait(0.05 * s)
                end
                if not surgeRunning then return end
                task.wait(0.9 * s)
                if not surgeRunning then return end
                cfg.Sphere.Speed = 20
                for i = 3, 25, 3 do
                    if not surgeRunning then break end
                    cfg.Sphere.Size = i
                    task.wait(0.04 * s)
                end
                if not surgeRunning then return end
                task.wait(1.5 * s)
                if not surgeRunning then return end
                currentMode = "BackGuard"
                cfg.BackGuard.Back = 15
                cfg.BackGuard.Height = 5
                cfg.BackGuard.Size = 20
                cfg.BackGuard.Speed = 1
            end)
        end
	end
})

-- --- TAB: MODE SETTINGS ---
local ModeSetTab = Window:MakeTab({
    Name = "モード設定",
    Icon = "rbxassetid://8997386997"
})

local CombineSec = ModeSetTab:AddSection({
    Name = "合体設定"
})

local function getModeListWithNone()
    local list = {"なし"}
    local order = {"Wing","Heart","Star","Vortex","Sphere","Rotate","Pet","Text","MagicCircle","MagicCircle2","MagicCircle3","FloatStone","Merkaba","Cube","Pyramid","MirrorPlayer","Beam","BackGuard","Tornado","Gyro"}
    for _, k in ipairs(order) do table.insert(list, modeNames[k]) end
    return list
end

UIElements.CombineMode1 = CombineSec:AddDropdown({
    Name = "合体: モード1",
    Default = modeNames["Wing"],
    Options = getModeListWithNone(),
    Callback = function(v) cfg.Combined.Mode1 = modeKeys[v] end
})

UIElements.CombineMode1Count = CombineSec:AddSlider({
    Name = "モード1の使用数",
    Min = 1,
    Max = 200,
    Default = 20,
    Increment = 1,
    ValueName = "個",
    Callback = function(v) cfg.Combined.Mode1Count = v end    
})

UIElements.CombineMode2 = CombineSec:AddDropdown({
    Name = "合体: モード2",
    Default = modeNames["Rotate"],
    Options = getModeListWithNone(),
    Callback = function(v) cfg.Combined.Mode2 = modeKeys[v] end
})

UIElements.CombineMode2Count = CombineSec:AddSlider({
    Name = "モード2の使用数",
    Min = 1,
    Max = 200,
    Default = 10,
    Increment = 1,
    ValueName = "個",
    Callback = function(v) cfg.Combined.Mode2Count = v end    
})

UIElements.CombineMode3 = CombineSec:AddDropdown({
    Name = "合体: モード3",
    Default = "なし",
    Options = getModeListWithNone(),
    Callback = function(v) cfg.Combined.Mode3 = modeKeys[v] end
})

UIElements.CombineMode3Count = CombineSec:AddSlider({
    Name = "モード3の使用数",
    Min = 0,
    Max = 200,
    Default = 0,
    Increment = 1,
    ValueName = "個",
    Callback = function(v) cfg.Combined.Mode3Count = v end
})

-- --- 共通設定エディタ (ドロップダウンで切り替え) ---
local EditSec = ModeSetTab:AddSection({
    Name = "共通設定エディタ"
})

local modes = {"Wing","Heart","Star","Vortex","Sphere","Rotate","Pet","Text","MagicCircle","MagicCircle2","MagicCircle3","FloatStone","Merkaba","Cube","Pyramid","MirrorPlayer","Beam","BackGuard","Tornado","Gyro"}

local currentEditMode = "Wing"
local sl_Speed, sl_Size, sl_Height, sl_Back

EditSec:AddDropdown({
    Name = "編集対象モード",
    Default = modeNames["Wing"],
    Options = getModeList(),
    Callback = function(v)
        currentEditMode = modeKeys[v]
        -- スライダーの値を更新
        if sl_Speed then sl_Speed:Set(cfg[currentEditMode].Speed or 10) end
        if sl_Size then sl_Size:Set(cfg[currentEditMode].Size or 10) end
        if sl_Height then sl_Height:Set(cfg[currentEditMode].Height or 0) end
        if sl_Back then sl_Back:Set(cfg[currentEditMode].Back or 0) end
    end
})

sl_Speed = EditSec:AddSlider({
    Name = "速度", Min = 0, Max = 100, Default = cfg.Wing.Speed or 10,
    Callback = function(v) cfg[currentEditMode].Speed = v end
})
sl_Size = EditSec:AddSlider({
    Name = "サイズ/幅", Min = 1, Max = 150, Default = cfg.Wing.Size or 10,
    Callback = function(v) cfg[currentEditMode].Size = v end
})
sl_Height = EditSec:AddSlider({
    Name = "高さ", Min = -50, Max = 50, Default = cfg.Wing.Height or 0,
    Callback = function(v) cfg[currentEditMode].Height = v end
})
sl_Back = EditSec:AddSlider({
    Name = "奥行き", Min = -50, Max = 50, Default = cfg.Wing.Back or 0,
    Callback = function(v) cfg[currentEditMode].Back = v end
})

-- --- 詳細設定タブ (固有設定のみ) ---
local AdvTab = Window:MakeTab({
    Name = "詳細設定",
    Icon = "rbxassetid://7733771472"
})

for _, m in ipairs(modes) do
    -- 固有設定があるモードのみセクションを作成
    if m == "Wing" or m == "Pet" or m == "Text" or m == "MagicCircle2" or m == "MagicCircle3" or m == "Beam" or m == "FloatStone" or m == "Tornado" or m == "Rotate" then
        local s = AdvTab:AddSection({ Name = modeNames[m] or m })
        
        if m == "Wing" then
            s:AddToggle({ Name = "付け根を固定 (Root Fixed)", Default = cfg.Wing.RootFixed, Callback = function(v) cfg.Wing.RootFixed = v end })
            s:AddSlider({ Name = "体との距離 (Gap)", Min = 0, Max = 50, Default = cfg.Wing.Gap or 10, Callback = function(v) cfg.Wing.Gap = v end })
            s:AddSlider({ Name = "関節数", Min = 0, Max = 10, Default = 3, Callback = function(v) cfg.Wing.Joints = v end })
            s:AddSlider({ Name = "V字角度 (前後方向)", Min = -180, Max = 180, Default = 0, Callback = function(v) cfg.Wing.V_Angle = v end })
            s:AddSlider({ Name = "上下傾斜", Min = -90, Max = 90, Default = 0, Callback = function(v) cfg.Wing.Tilt = v end })
            s:AddSlider({ Name = "羽ばたき強度", Min = 0, Max = 50, Default = 15, Callback = function(v) cfg.Wing.Strength = v end })
            s:AddToggle({ Name = "カーブ (反り)", Default = cfg.Wing.Curve or false, Callback = function(v) cfg.Wing.Curve = v end })
            s:AddSlider({ Name = "カーブ強度 (反り)", Min = -50, Max = 50, Default = cfg.Wing.CurveAmount or 10, Callback = function(v) cfg.Wing.CurveAmount = v end })
        
        elseif m == "Pet" then
            s:AddSlider({ Name = "個体数", Min = 1, Max = 10, Default = 2, Callback = function(v) cfg.Pet.Count = v end })
            s:AddSlider({ Name = "関節数(うねり)", Min = 0, Max = 10, Default = 3, Callback = function(v) cfg.Pet.Joints = v end })
            s:AddSlider({ Name = "横の広がり(Gap)", Min = 1, Max = 20, Default = 13, Callback = function(v) cfg.Pet.Gap = v end })
        
        elseif m == "Text" then
            s:AddTextbox({ Name = "表示テキスト", Default = "HELLO", TextDisappear = false, Callback = function(v) cfg.Text.Content = v end })
        
        elseif m == "MagicCircle2" then
            s:AddSlider({ Name = "レイヤー数", Min = 1, Max = 5, Default = 3, Callback = function(v) cfg.MagicCircle2.Layers = v end })
        
        elseif m == "MagicCircle3" then
            s:AddSlider({ Name = "複雑度", Min = 1, Max = 10, Default = 5, Callback = function(v) cfg.MagicCircle3.Complexity = v end })
        
        elseif m == "Beam" then
            s:AddSlider({ Name = "ビーム本数", Min = 1, Max = 20, Default = 8, Callback = function(v) cfg.Beam.Count = v end })
        
        elseif m == "FloatStone" then
            s:AddToggle({ Name = "カオス移動", Default = false, Callback = function(v) cfg.FloatStone.Chaos = v end })

        elseif m == "Tornado" then
            s:AddSlider({ Name = "下部幅", Min = 0, Max = 50, Default = cfg.Tornado.Radius, Callback = function(v) cfg.Tornado.Radius = v end })
            s:AddSlider({ Name = "上部幅", Min = 0, Max = 50, Default = cfg.Tornado.TopRadius, Callback = function(v) cfg.Tornado.TopRadius = v end })
            s:AddToggle({ Name = "ピラミッド形状", Default = false, Callback = function(v) cfg.Tornado.Pyramid = v end })

        elseif m == "Rotate" then
            s:AddToggle({ Name = "ウェーブ (くねくね)", Default = cfg.Rotate.Wave or false, Callback = function(v) cfg.Rotate.Wave = v end })
            s:AddSlider({ Name = "ウェーブ速度", Min = 1, Max = 20, Default = cfg.Rotate.WaveSpeed or 2, Callback = function(v) cfg.Rotate.WaveSpeed = v end })
            s:AddSlider({ Name = "ウェーブ振幅", Min = 1, Max = 20, Default = cfg.Rotate.WaveAmp or 2, Callback = function(v) cfg.Rotate.WaveAmp = v end })
        end
    end
end

-- エフェクト全体の向きセクション
local EffectRotSec = MainTab:AddSection({ Name = "エフェクト全体の向き" })
UIElements.EffectRotationX = EffectRotSec:AddSlider({
    Name = "X軸 (Pitch)", Min = -180, Max = 180, Default = 0,
    Callback = function(v) cfg.Global.EffectRotation = Vector3.new(v, cfg.Global.EffectRotation.Y, cfg.Global.EffectRotation.Z) end
})
UIElements.EffectRotationY = EffectRotSec:AddSlider({
    Name = "Y軸 (Yaw)", Min = -180, Max = 180, Default = 0,
    Callback = function(v) cfg.Global.EffectRotation = Vector3.new(cfg.Global.EffectRotation.X, v, cfg.Global.EffectRotation.Z) end
})
UIElements.EffectRotationZ = EffectRotSec:AddSlider({
    Name = "Z軸 (Roll)", Min = -180, Max = 180, Default = 0,
    Callback = function(v) cfg.Global.EffectRotation = Vector3.new(cfg.Global.EffectRotation.X, cfg.Global.EffectRotation.Y, v) end
})

local IndivRotSec = MainTab:AddSection({ Name = "おもちゃ自体の向き" })
UIElements.IndividualRotationX = IndivRotSec:AddSlider({
    Name = "X軸 (Pitch)", Min = -180, Max = 180, Default = 0,
    Callback = function(v) cfg.Global.IndividualRotation = Vector3.new(v, cfg.Global.IndividualRotation.Y, cfg.Global.IndividualRotation.Z) end
})
UIElements.IndividualRotationY = IndivRotSec:AddSlider({
    Name = "Y軸 (Yaw)", Min = -180, Max = 180, Default = -90,
    Callback = function(v) cfg.Global.IndividualRotation = Vector3.new(cfg.Global.IndividualRotation.X, v, cfg.Global.IndividualRotation.Z) end
})
UIElements.IndividualRotationZ = IndivRotSec:AddSlider({
    Name = "Z軸 (Roll)", Min = -180, Max = 180, Default = 0,
    Callback = function(v) cfg.Global.IndividualRotation = Vector3.new(cfg.Global.IndividualRotation.X, cfg.Global.IndividualRotation.Y, v) end
})

-- ワールドリセットボタン
MainSec:AddButton({
    Name = "エフェクトをワールド0,0,0にリセット",
    Callback = function()
        if not isEnabled then return end
        followPlayer = false 
        lastBaseCF = CFrame.new(0, 0, 0) 

        for i, fw in ipairs(activeToys) do
            task.spawn(function()
                fw.AP.Enabled = false 
                fw.Part.Anchored = true
                fw.Part.CFrame = CFrame.new(0, 0, 0)
                fw.AP.Position = Vector3.new(0, 0, 0) 
                fw.Part.AssemblyLinearVelocity = Vector3.zero
                
                task.wait(0.1)
                
                fw.AP.Enabled = true 
                fw.Part.Anchored = false
            end)
        end
    end
})

-- --- TAB: DETAIL ---
local DetailTab = Window:MakeTab({Name = "詳細", Icon = DetailIcon})
AddDetailContent(DetailTab)

-- 通知（起動時）
OrionLib:MakeNotification({
	Name = "Holon HUB",
	Content = "v1.4.3 [Effect Only] が読み込まれました！",
	Time = 5
})

    OrionLib:Init()
end

-- 認証システム（変更なし）
if isfile(KeyFileName) and readfile(KeyFileName) == CorrectKey then
    -- 認証済みなら即メインへ
    StartHolonHUB()
else
    -- 未認証なら認証UIを作る
    local OrionLib = loadstring(game:HttpGet(OrionUrl))()
    
    local AuthWindow = OrionLib:MakeWindow({
        Name = "Holon HUB | Key System",
        HidePremium = true,
        IntroEnabled = false
    })

    local AuthTab = AuthWindow:MakeTab({Name = "認証", Icon = "rbxassetid://7733919526"})
    local KeyInput = ""

    AuthTab:AddTextbox({
        Name = "キーを入力",
        Default = "",
        TextDisappear = false,
        Callback = function(Value) 
            KeyInput = Value 
        end     
    })

    AuthTab:AddButton({
        Name = "認証する",
        Callback = function()
            if KeyInput == CorrectKey then
                writefile(KeyFileName, CorrectKey)
                OrionLib:MakeNotification({Name = "成功", Content = "起動します!", Time = 2})
                task.wait(1)
                pcall(function() game.CoreGui.Orion:Destroy() end)
                task.wait(0.5)
                StartHolonHUB()
            else
                OrionLib:MakeNotification({Name = "失敗", Content = "キーが違います", Time = 5})
            end
        end
    })

    AuthTab:AddButton({
        Name = "キーを入手 (Discord)",
        Callback = function() setclipboard("https://discord.gg/EHBXqgZZYN") end
    })

    -- 詳細タブ
    local AuthDetailTab = AuthWindow:MakeTab({Name = "詳細", Icon = DetailIcon})
    AddDetailContent(AuthDetailTab)
    
    OrionLib:Init()
end
