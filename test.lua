local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")

local LocalPlayer = Players.LocalPlayer

local defaultConfig = {
    Wing = { Size = 30, Gap = 3.0, Speed = 6, Height = 0.5, Back = 0, Joints = 3, Strength = 15, Curve = false, CurveAmount = 10 },
}

local function deepCopy(target)
    local copy = {}
    for k, v in pairs(target) do copy[k] = (type(v) == "table") and deepCopy(v) or v end
    return copy
end

local selectedItemName = "全てのおもちゃ" 
local detectedItems = {}

local cfg = deepCopy(defaultConfig)
local isEnabled = false
local activeToys = {}
local originalCollisions = {}
local updateConnection = nil

local targetMain = LocalPlayer

local function getPositionForMode(i, count, time)
    local c = cfg.Wing
    local ratio = (i-1) / (count > 1 and count-1 or 1)
    local side = (i % 2 == 1) and -1 or 1
    local idx = math.ceil(i / 2)
    local totalSide = math.ceil(count / 2)

    local distRatio = idx / math.max(1, totalSide)
    
    local flapPhase = time * c.Speed
    if c.Joints > 0 then
        flapPhase = flapPhase - (idx * (0.5 / math.max(1, c.Joints)))
    end

    local flap = math.sin(flapPhase) * c.Strength
    flap = flap * distRatio
    
    local horizontalOffset = c.Gap + (c.Size * distRatio)
    local pos = Vector3.new(horizontalOffset * side, flap, 0)
    
    local rotCF = CFrame.Angles(0, 0, 0)

    if c.Curve then
        local curve_amount = c.CurveAmount or 10
        local flap_ratio = math.sin(flapPhase)
        local soar_angle = math.rad(flap_ratio * curve_amount * distRatio)
        rotCF = rotCF * CFrame.Angles(0, 0, soar_angle * side)
    end
    
    return (rotCF * pos) + Vector3.new(0, c.Height, c.Back)
end

local function stopEffect()
    isEnabled = false
    if updateConnection then 
        updateConnection:Disconnect()
        updateConnection = nil 
    end
    
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

    local allMyItems = {}
    local plotsFolder = Workspace:FindFirstChild("Plots")
    local plotItemsFolder = Workspace:FindFirstChild("PlotItems")

    local spawnedToys = Workspace:FindFirstChild(myName .. "SpawnedInToys")
    if spawnedToys then
        for _, item in ipairs(spawnedToys:GetChildren()) do
            table.insert(allMyItems, item)
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
                
                if isMine then
                    local targetFolder = plotItemsFolder:FindFirstChild(plot.Name)
                    if targetFolder then
                        for _, item in ipairs(targetFolder:GetChildren()) do
                            table.insert(allMyItems, item)
                        end
                    end
                    break
                end
            end
        end
    end

    for _, item in ipairs(Workspace:GetChildren()) do
        local ownerValue = item:FindFirstChild("Owner") or item:FindFirstChild("PartOwner")
        if item:IsA("Model") and ownerValue and ownerValue:IsA("StringValue") and ownerValue.Value == myName then
            if not table.find(allMyItems, item) then
                table.insert(allMyItems, item)
            end
        end
    end

    for _, item in ipairs(allMyItems) do
        if item:IsA("Model") and item.PrimaryPart and (selectedItemName == "全てのおもちゃ" or item.Name == selectedItemName) then
            table.insert(fws, item)
        end
    end

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

    for i, model in ipairs(fws) do
        local pp = model.PrimaryPart
        
        for _, d in ipairs(model:GetDescendants()) do 
            if d:IsA("BasePart") then
                d.AssemblyLinearVelocity = Vector3.zero
                d.AssemblyAngularVelocity = Vector3.zero
                pcall(function() d:SetNetworkOwner(LocalPlayer) end)
            end
        end
        
        if root then
            local relativePos = getPositionForMode(i, #fws, tick())
            pp.CFrame = root.CFrame:ToWorldSpace(CFrame.new(relativePos))
        end
        
        pp.Anchored = false
        pcall(function() pp:SetNetworkOwner(LocalPlayer) end)

        for _, d in ipairs(model:GetDescendants()) do 
            if d:IsA("BasePart") then 
                if originalCollisions[d] == nil then originalCollisions[d] = d.CanCollide end
                d.CanCollide = false
                d.CanTouch = false
                d.CanQuery = false
            end 
        end
        
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

        local baseCF = rootPart.CFrame
        local t = tick()
        
        for i, fw in ipairs(activeToys) do
            if fw.Part.Position.Y <= -90 then
                fw.Part.Anchored = true
            else
                fw.Part.Anchored = false

                local relativePos = getPositionForMode(i, #activeToys, t)
                local worldPos = baseCF:PointToWorldSpace(relativePos)
                fw.AP.Position = worldPos

                local side = (i % 2 == 1) and -1 or 1
                local baseRotation = CFrame.Angles(math.rad(90), 0, 0)
                if side == -1 then
                    fw.AO.CFrame = baseCF * baseRotation * CFrame.Angles(0, math.rad(180), 0)
                else
                    fw.AO.CFrame = baseCF * baseRotation
                end
            end
        end
    end)
end

local OrionUrl = "https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/source.txt"

local function StartHolonHUB()
    local OrionLib = loadstring(game:HttpGet(OrionUrl))()
    
    pcall(function()
        if game:GetService("CoreGui"):FindFirstChild("Orion") then 
            game:GetService("CoreGui").Orion:Destroy() 
        end
    end)

    local Window = OrionLib:MakeWindow({
        Name = "Wing",
        HidePremium = false,
        SaveConfig = false,
        ConfigFolder = "Wing",
        IntroEnabled = true,
        IntroText = "Wing Load!"
    })

    local UIElements = {}
    local MainTab = Window:MakeTab({ Name = "メイン"})
    local MainSec = MainTab:AddSection({ Name = "エフェクト制御" })

    UIElements.EffectToggle = MainSec:AddToggle({
        Name = "エフェクト有効化",
        Default = false,
        Callback = function(v)
            if v then startEffect() else stopEffect() end
        end    
    })

    local itemDropdown
    UIElements.ItemDropdown = MainSec:AddDropdown({
        Name = "制御対象の選択",
        Default = "なし",
        Options = {"なし"},
        Callback = function(v) selectedItemName = v end
    })
    itemDropdown = UIElements.ItemDropdown

    local function refreshToyList()
        detectedItems = {}
        local myName = LocalPlayer.Name
        local allMyItems = {}
        local plotsFolder = Workspace:FindFirstChild("Plots")
        local plotItemsFolder = Workspace:FindFirstChild("PlotItems")

        local spawnedToys = Workspace:FindFirstChild(myName .. "SpawnedInToys")
        if spawnedToys then
            for _, item in ipairs(spawnedToys:GetChildren()) do
                table.insert(allMyItems, item)
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
                    if isMine then
                        local targetFolder = plotItemsFolder:FindFirstChild(plot.Name)
                        if targetFolder then
                            for _, item in ipairs(targetFolder:GetChildren()) do
                                table.insert(allMyItems, item)
                            end
                        end
                        break
                    end
                end
            end
        end

        for _, item in ipairs(Workspace:GetChildren()) do
            local ownerValue = item:FindFirstChild("Owner") or item:FindFirstChild("PartOwner")
            if item:IsA("Model") and ownerValue and ownerValue:IsA("StringValue") and ownerValue.Value == myName then
                if not table.find(allMyItems, item) then
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
        end
    })

    task.spawn(refreshToyList)

    local WingSec = MainTab:AddSection({ Name = "羽設定" })

    WingSec:AddSlider({ Name = "サイズ", Min = 1, Max = 150, Default = cfg.Wing.Size, Callback = function(v) cfg.Wing.Size = v end })
    WingSec:AddSlider({ Name = "速度", Min = 0, Max = 100, Default = cfg.Wing.Speed, Callback = function(v) cfg.Wing.Speed = v end })
    WingSec:AddSlider({ Name = "高さ", Min = -50, Max = 50, Default = cfg.Wing.Height, Callback = function(v) cfg.Wing.Height = v end })
    WingSec:AddSlider({ Name = "奥行き", Min = -50, Max = 50, Default = cfg.Wing.Back, Callback = function(v) cfg.Wing.Back = v end })
    WingSec:AddSlider({ Name = "体との距離", Min = 0, Max = 50, Default = cfg.Wing.Gap, Callback = function(v) cfg.Wing.Gap = v end })
    WingSec:AddSlider({ Name = "関節数", Min = 0, Max = 10, Default = cfg.Wing.Joints, Callback = function(v) cfg.Wing.Joints = v end })
    WingSec:AddSlider({ Name = "羽ばたき強度", Min = 0, Max = 50, Default = cfg.Wing.Strength, Callback = function(v) cfg.Wing.Strength = v end })
    WingSec:AddToggle({ Name = "カーブ", Default = cfg.Wing.Curve, Callback = function(v) cfg.Wing.Curve = v end })
    WingSec:AddSlider({ Name = "カーブ強度", Min = -50, Max = 50, Default = cfg.Wing.CurveAmount, Callback = function(v) cfg.Wing.CurveAmount = v end })

    OrionLib:Init()
end

StartHolonHUB()
