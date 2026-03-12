local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- test.luaから持ってきたイベント定義
local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--------------------------------------------------------------------------------
-- [コンフィグ & 変数管理]
--------------------------------------------------------------------------------
local defaultConfig = {
    Wing = { Size = 30, Gap = 3.0, Speed = 6, Height = 0.5, Back = 0, Joints = 3, V_Angle = 0, Tilt = 0, Strength = 15, RootFixed = true, Curve = false, CurveAmount = 10 },
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
local isEnabled = false
local followPlayer = true
local lastBaseCF = nil
local targetMain = LocalPlayer
local activeToys = {}        -- {A0, A1, AP, AO, Part}
local originalCollisions = {} -- {Part: Boolean}
local updateConnection = nil

-- Wing mode only
local currentMode = "Wing"

--------------------------------------------------------------------------------
-- [計算ロジック] 翼(Wing)の座標計算
--------------------------------------------------------------------------------
local function getPositionForMode(i, count, time)
    local c = cfg.Wing
    
    local ratio = (i-1) / (count > 1 and count-1 or 1)
    
    -- 単体モード（合体なし）の翼計算
    local side = (i % 2 == 1) and -1 or 1
    local idx = math.ceil(i / 2)
    local totalSide = math.ceil(count / 2)

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
        local flap_ratio = math.sin(flapPhase)
        local soar_angle = math.rad(flap_ratio * curve_amount * distRatio)
        rotCF = rotCF * CFrame.Angles(0, 0, soar_angle * side)
    end
    
    return (rotCF * pos) + Vector3.new(0, c.Height, c.Back)
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

    if not targetMain or not targetMain.Character then return end
    local root = targetMain.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local fws = {}
    local myName = LocalPlayer.Name
    
    local maxCount = cfg.Global.MaxToys or 30

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
            local relativePos = getPositionForMode(i, #fws, tick())
            pp.CFrame = root.CFrame:ToWorldSpace(CFrame.new(relativePos))
        end
        
        pp.Anchored = false
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
        
        -- AttachmentとAlign
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

        local baseCF
        if followPlayer then
            baseCF = rootPart.CFrame
            lastBaseCF = baseCF
        else
            if not lastBaseCF then lastBaseCF = rootPart.CFrame end
            baseCF = lastBaseCF
        end

        local t = tick()
        
        -- エフェクト全体の回転
        local effectRot = cfg.Global.EffectRotation or Vector3.zero
        local effectRotationCF = CFrame.Angles(math.rad(effectRot.X), math.rad(effectRot.Y), math.rad(effectRot.Z))
        local rotatedBaseCF = baseCF * effectRotationCF

        -- おもちゃ個別の回転
        local indivRot = cfg.Global.IndividualRotation or Vector3.new(0, -90, 0)
        local individualRotation = CFrame.Angles(math.rad(indivRot.X), math.rad(indivRot.Y), math.rad(indivRot.Z))
        
        for i, fw in ipairs(activeToys) do
            if fw.Part.Position.Y <= -90 then
                fw.Part.Anchored = true
            else
                fw.Part.Anchored = false

                local relativePos = getPositionForMode(i, #activeToys, t)
                local worldPos = rotatedBaseCF:PointToWorldSpace(relativePos)
                fw.AP.Position = worldPos
                fw.AO.CFrame = rotatedBaseCF * individualRotation
            end
        end
    end)
end

--------------------------------------------------------------------------------
-- [UI 構築] orion lib
--------------------------------------------------------------------------------
local OrionUrl = "https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/source.txt"

local function StartHolonHUB()
    local OrionLib = loadstring(game:HttpGet(OrionUrl))()
    
    pcall(function()
        if game:GetService("CoreGui"):FindFirstChild("Orion") then 
            game:GetService("CoreGui").Orion:Destroy() 
        end
    end)

    local Window = OrionLib:MakeWindow({
        Name = "Holon HUB v1.4.3 [Wing Only]",
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

    -- UI要素管理
    local UIElements = {}

    -- --- メインタブ ---
    local MainTab = Window:MakeTab({ Name = "メイン", Icon = "rbxassetid://7733960981" })

    -- エフェクト制御セクション
    local MainSec = MainTab:AddSection({ Name = "エフェクト制御" })

    local targetMainName = ""

    UIElements.MainTargetDropdown = MainSec:AddDropdown({
        Name = "メイン対象",
        Default = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")",
        Options = getPList(),
        Callback = function(v)
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

    UIElements.EffectToggle = MainSec:AddToggle({
        Name = "エフェクト有効化",
        Default = false,
        Callback = function(v)
            if v then startEffect() else stopEffect() end
        end    
    })

    -- 制御対象ドロップダウン
    local itemDropdown
    UIElements.ItemDropdown = MainSec:AddDropdown({
        Name = "制御対象の選択",
        Default = "なし",
        Options = {"なし"},
        Callback = function(v) selectedItemName = v end
    })
    itemDropdown = UIElements.ItemDropdown

    -- おもちゃリスト更新
    local function refreshToyList()
        detectedItems = {}
        local myName = LocalPlayer.Name
        local allMyItems = {}
        local plotsFolder = Workspace:FindFirstChild("Plots")
        local plotItemsFolder = Workspace:FindFirstChild("PlotItems")

        if useOtherToys then
            for _, folder in ipairs(Workspace:GetChildren()) do
                if folder.Name:match("SpawnedInToys$") then
                    for _, item in ipairs(folder:GetChildren()) do table.insert(allMyItems, item) end
                end
            end
        else
            local spawnedToys = Workspace:FindFirstChild(myName .. "SpawnedInToys")
            if spawnedToys then
                for _, item in ipairs(spawnedToys:GetChildren()) do table.insert(allMyItems, item) end
            end
        end

        if plotsFolder and plotItemsFolder then
            for _, plot in ipairs(plotsFolder:GetChildren()) do
                local sign = plot:FindFirstChild("PlotSign")
                local ownerObj = sign and (sign:FindFirstChild("ThisPlotsOwners") or sign:FindFirstChild("Owner"))
                if ownerObj then
                    local val = ownerObj:FindFirstChild("Value") or ownerObj
                    local data = val:FindFirstChild("Data") or val
                    local isMine = (data:IsA("StringValue") and data.Value == myName)
                    if isMine or useOtherToys then
                        local targetFolder = plotItemsFolder:FindFirstChild(plot.Name)
                        if targetFolder then
                            for _, item in ipairs(targetFolder:GetChildren()) do table.insert(allMyItems, item) end
                        end
                        if isMine and not useOtherToys then break end
                    end
                end
            end
        end

        for _, item in ipairs(Workspace:GetChildren()) do
            local ownerValue = item:FindFirstChild("Owner") or item:FindFirstChild("PartOwner")
            if item:IsA("Model") and ownerValue and ownerValue:IsA("StringValue") then
                if (ownerValue.Value == myName or useOtherToys) and not table.find(allMyItems, item) then
                    table.insert(allMyItems, item)
                end
            end
        end

        for _, item in ipairs(allMyItems) do
            if item:IsA("Model") and item.PrimaryPart then
                local itemName = tostring(item.Name)
                if not table.find(detectedItems, itemName) then
                    table.insert(detectedItems, itemName)
                end
            end
        end

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

    task.spawn(refreshToyList)

    UIElements.FollowToggle = MainSec:AddToggle({
        Name = "プレイヤー追従",
        Default = true,
        Callback = function(v) followPlayer = v end
    })

    UIElements.MaxToysSlider = MainSec:AddSlider({
        Name = "使用するおもちゃの最大数",
        Min = 1, Max = 200, Default = cfg.Global.MaxToys or 100,
        Callback = function(v) cfg.Global.MaxToys = v end
    })

    UIElements.AnimSpeedSlider = MainSec:AddSlider({
        Name = "アニメ速度倍率",
        Min = 1, Max = 50, Default = 10,
        Callback = function(v) cfg.AnimSpeed = v / 10 end
    })

    -- 翼固有設定セクション
    local WingSec = MainTab:AddSection({ Name = "翼設定" })

    WingSec:AddToggle({ Name = "付け根を固定 (Root Fixed)", Default = cfg.Wing.RootFixed, Callback = function(v) cfg.Wing.RootFixed = v end })
    WingSec:AddSlider({ Name = "体との距離 (Gap)", Min = 0, Max = 50, Default = cfg.Wing.Gap, Callback = function(v) cfg.Wing.Gap = v end })
    WingSec:AddSlider({ Name = "関節数", Min = 0, Max = 10, Default = cfg.Wing.Joints, Callback = function(v) cfg.Wing.Joints = v end })
    WingSec:AddSlider({ Name = "V字角度 (前後方向)", Min = -180, Max = 180, Default = cfg.Wing.V_Angle, Callback = function(v) cfg.Wing.V_Angle = v end })
    WingSec:AddSlider({ Name = "上下傾斜", Min = -90, Max = 90, Default = cfg.Wing.Tilt, Callback = function(v) cfg.Wing.Tilt = v end })
    WingSec:AddSlider({ Name = "羽ばたき強度", Min = 0, Max = 50, Default = cfg.Wing.Strength, Callback = function(v) cfg.Wing.Strength = v end })
    WingSec:AddToggle({ Name = "カーブ (反り)", Default = cfg.Wing.Curve, Callback = function(v) cfg.Wing.Curve = v end })
    WingSec:AddSlider({ Name = "カーブ強度 (反り)", Min = -50, Max = 50, Default = cfg.Wing.CurveAmount, Callback = function(v) cfg.Wing.CurveAmount = v end })

    -- エフェクト全体の向き
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

    -- ワールドリセット
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

    OrionLib:MakeNotification({ Name = "Holon HUB", Content = "v1.4.3 [Wing Only] が読み込まれました！", Time = 5 })
    OrionLib:Init()
end

StartHolonHUB()
