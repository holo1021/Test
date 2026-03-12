-- Holon HUB - Wing Only (OrionUI版) - 家のおもちゃのみ対象
-- 必要なサービスの取得
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- OrionLibの読み込み
local OrionUrl = "https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/source.txt"
local OrionLib = loadstring(game:HttpGet(OrionUrl))()

-- 既存のUIを削除
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("Orion") then
        game:GetService("CoreGui").Orion:Destroy()
    end
end)

-- ネットワーク所有権設定用イベント（あれば）
local SetNetworkOwner
pcall(function()
    local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
    SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")
end)

-- ===== 設定 =====
local WingConfig = {
    Size = 30,          -- 翼の大きさ
    Gap = 3.0,          -- 胴体からの距離
    Speed = 6,          -- 羽ばたく速さ
    Height = 0.5,       -- 高さオフセット
    Back = 0,           -- 前後オフセット
    Joints = 3,         -- 関節数（羽ばたきの位相ズレ）
    V_Angle = 0,        -- V字角度（前後方向）
    Tilt = 0,           -- 上下傾斜
    Strength = 15,      -- 羽ばたき強度
    RootFixed = true,   -- 根元を固定するか
    Curve = false,      -- 反りを有効にするか
    CurveAmount = 10,   -- 反りの強さ
}
local MaxToys = 30          -- 使用するおもちゃの最大数
local FollowPlayer = true   -- プレイヤーに追従するか

-- 内部変数
local isEnabled = false
local activeToys = {}       -- {A0, AP, AO, Part, Model}
local originalCollisions = {}
local updateConnection = nil
local lastBaseCF = nil

-- ===== 翼の位置計算（Wing専用） =====
local function getWingPosition(i, count, time)
    local c = WingConfig
    local side = (i % 2 == 1) and -1 or 1          -- 左(-1) / 右(1)
    local idx = math.ceil(i / 2)                   -- 翼の段数
    local totalSide = math.ceil(count / 2)          -- 片翼あたりの総段数

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

    if c.Curve then
        local curve_amount = c.CurveAmount or 10
        local flap_ratio = math.sin(flapPhase)
        local soar_angle = math.rad(flap_ratio * curve_amount * distRatio)
        rotCF = rotCF * CFrame.Angles(0, 0, soar_angle * side)
    end

    return (rotCF * pos) + Vector3.new(0, c.Height, c.Back)
end

-- ===== 自分の家（プロット）にあるおもちゃのみを取得 =====
local function getPlayerToys(maxCount)
    local toys = {}
    local myName = LocalPlayer.Name
    local plots = Workspace:FindFirstChild("Plots")
    local plotItems = Workspace:FindFirstChild("PlotItems")

    if plots and plotItems then
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local ownerObj = sign and (sign:FindFirstChild("ThisPlotsOwners") or sign:FindFirstChild("Owner"))
            if ownerObj then
                local val = ownerObj:FindFirstChild("Value") or ownerObj
                local data = val:FindFirstChild("Data") or val
                if data:IsA("StringValue") and data.Value == myName then
                    local targetFolder = plotItems:FindFirstChild(plot.Name)
                    if targetFolder then
                        for _, item in ipairs(targetFolder:GetChildren()) do
                            if item:IsA("Model") and item.PrimaryPart then
                                table.insert(toys, item)
                                if #toys >= maxCount then break end
                            end
                        end
                    end
                    break -- 自分のプロットは1つなので、見つけたら終了
                end
            end
        end
    end

    return toys
end

-- ===== エフェクト開始 =====
local function startEffect()
    if isEnabled then stopEffect() end

    local toys = getPlayerToys(MaxToys)
    if #toys == 0 then
        OrionLib:MakeNotification({Name="エラー", Content="家におもちゃが見つかりません", Time=3})
        return
    end
    print("[Wing] 使用おもちゃ数:", #toys)

    for i, model in ipairs(toys) do
        local pp = model.PrimaryPart
        pp.AssemblyLinearVelocity = Vector3.zero
        pp.AssemblyAngularVelocity = Vector3.zero

        pcall(function() pp:SetNetworkOwner(LocalPlayer) end)
        if SetNetworkOwner then
            pcall(function() SetNetworkOwner:FireServer(pp, pp.CFrame) end)
        end

        -- 初期位置を設定（hub.lua と同じ処理）
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local relPos = getWingPosition(i, #toys, tick())
            pp.CFrame = root.CFrame:ToWorldSpace(CFrame.new(relPos))
        end

        -- 当たり判定無効化
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                if originalCollisions[part] == nil then
                    originalCollisions[part] = part.CanCollide
                end
                part.CanCollide = false
                part.CanTouch = false
                part.CanQuery = false
            end
        end

        -- AlignPosition / AlignOrientation 作成
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

        table.insert(activeToys, {A0=a0, AP=ap, AO=ao, Part=pp, Model=model})
    end

    isEnabled = true
    lastBaseCF = nil

    updateConnection = RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- ★ 所有権維持：毎フレーム実行（hub.lua よりも高頻度）
    for _, toy in ipairs(activeToys) do
        local part = toy.Part
        pcall(function() part:SetNetworkOwner(LocalPlayer) end)
        -- ★ サーバーへも毎フレーム通知（負荷注意）
        if SetNetworkOwner then
            pcall(function() SetNetworkOwner:FireServer(part, part.CFrame) end)
        end
    end

    local baseCF
    if FollowPlayer then
        baseCF = root.CFrame
        lastBaseCF = baseCF
    else
        if not lastBaseCF then lastBaseCF = root.CFrame end
        baseCF = lastBaseCF
    end

    local t = tick()

    for i, toy in ipairs(activeToys) do
        local part = toy.Part
        part.Anchored = false  -- 奈落判定は完全に削除

        local relPos = getWingPosition(i, #activeToys, t)
        local worldPos = baseCF:PointToWorldSpace(relPos)
        toy.AP.Position = worldPos

        -- hub.lua 準拠の向き
        local individualRot = CFrame.Angles(0, math.rad(-90), 0)
        toy.AO.CFrame = baseCF * individualRot
    end
end)
end

-- ===== エフェクト停止 =====
local function stopEffect()
    isEnabled = false
    if updateConnection then
        updateConnection:Disconnect()
        updateConnection = nil
    end

    for _, toy in ipairs(activeToys) do
        pcall(function()
            toy.A0:Destroy()
            toy.AP:Destroy()
            toy.AO:Destroy()
        end)
    end
    activeToys = {}

    for part, coll in pairs(originalCollisions) do
        if part and part.Parent then
            pcall(function() part.CanCollide = coll end)
        end
    end
    originalCollisions = {}
end

-- ===== UI構築 =====
local Window = OrionLib:MakeWindow({
    Name = "Holon HUB - Wing Only (家のおもちゃ限定)",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "HolonWing",
    IntroEnabled = true,
    IntroText = "Wing Mode Loaded"
})

-- メインタブ
local MainTab = Window:MakeTab({
    Name = "メイン",
    Icon = "rbxassetid://7733960981"
})

local MainSec = MainTab:AddSection({ Name = "制御" })

MainSec:AddToggle({
    Name = "エフェクト有効",
    Default = false,
    Callback = function(v)
        if v then startEffect() else stopEffect() end
    end
})

MainSec:AddToggle({
    Name = "プレイヤー追従",
    Default = FollowPlayer,
    Callback = function(v) FollowPlayer = v end
})

MainSec:AddSlider({
    Name = "使用おもちゃ数",
    Min = 1, Max = 100, Default = MaxToys,
    Callback = function(v) MaxToys = v end
})

-- 設定タブ
local ConfigTab = Window:MakeTab({
    Name = "設定",
    Icon = "rbxassetid://10734950309"
})

local WingSec = ConfigTab:AddSection({ Name = "羽パラメータ" })

WingSec:AddSlider({ Name = "サイズ", Min = 1, Max = 150, Default = WingConfig.Size, Callback = function(v) WingConfig.Size = v end })
WingSec:AddSlider({ Name = "速度", Min = 0, Max = 50, Default = WingConfig.Speed, Callback = function(v) WingConfig.Speed = v end })
WingSec:AddSlider({ Name = "高さ", Min = -50, Max = 50, Default = WingConfig.Height, Callback = function(v) WingConfig.Height = v end })
WingSec:AddSlider({ Name = "奥行き", Min = -50, Max = 50, Default = WingConfig.Back, Callback = function(v) WingConfig.Back = v end })
WingSec:AddSlider({ Name = "羽ばたき強度", Min = 0, Max = 50, Default = WingConfig.Strength, Callback = function(v) WingConfig.Strength = v end })
WingSec:AddSlider({ Name = "体との距離", Min = 0, Max = 50, Default = WingConfig.Gap, Callback = function(v) WingConfig.Gap = v end })
WingSec:AddSlider({ Name = "関節数", Min = 0, Max = 10, Default = WingConfig.Joints, Callback = function(v) WingConfig.Joints = v end })
WingSec:AddSlider({ Name = "V字角度", Min = -180, Max = 180, Default = WingConfig.V_Angle, Callback = function(v) WingConfig.V_Angle = v end })
WingSec:AddSlider({ Name = "上下傾斜", Min = -90, Max = 90, Default = WingConfig.Tilt, Callback = function(v) WingConfig.Tilt = v end })

WingSec:AddToggle({ Name = "付け根固定", Default = WingConfig.RootFixed, Callback = function(v) WingConfig.RootFixed = v end })
WingSec:AddToggle({ Name = "反り有効", Default = WingConfig.Curve, Callback = function(v) WingConfig.Curve = v end })
WingSec:AddSlider({ Name = "反り強度", Min = -50, Max = 50, Default = WingConfig.CurveAmount, Callback = function(v) WingConfig.CurveAmount = v end })

-- 詳細タブ（左右の向き調整用）は不要なので削除しても良いが、残しておく
local DetailTab = Window:MakeTab({
    Name = "詳細",
    Icon = "rbxassetid://7733771472"
})

local RotSec = DetailTab:AddSection({ Name = "向き調整" })

local currentExtraRot = 0
RotSec:AddSlider({
    Name = "追加Y軸回転（現在未使用）",
    Min = -180, Max = 180, Default = 0,
    Callback = function(v)
        currentExtraRot = v
        -- 現在のコードでは使用していない
    end
})

-- 起動メッセージ
OrionLib:MakeNotification({
    Name = "Holon HUB",
    Content = "Wing Only 版（家のおもちゃ限定）が読み込まれました",
    Time = 3
})

OrionLib:Init()
