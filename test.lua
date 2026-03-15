--[[
--[[
    Bliz/Iyhan Hub Style Script
    Author: Gemini Code Assist
    Objective: To provide a functional UI with various features, explaining client-side limitations.
]]

--============================================================================--
--                            SERVICES AND VARIABLES                          --
--============================================================================--

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Local Player
local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

-- Feature States
local states = {
    superStrong = false,
    deathGrab = false,
    noclipGrab = false,
    blobmanLock = false,
    autoAttacker = false,
    lineEsp = false,
    softLag = false,
    invisible = false,
    deathAura = false,
    radioactiveAura = false,
    clickTp = false,
    loopKill = false,
    autoAnchor = false,
    antiKick = false,
    noclip = false
}

-- Other Variables
local grabTarget = nil
local radioactivePart = nil
local lineAdornments = {}
local softLagTick = 0

--============================================================================--
--                                ORION UI SETUP                              --
--============================================================================--

-- Load Orion Library
local OrionUrl = "https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/source.txt"
local OrionLib = loadstring(game:HttpGet(OrionUrl))()

-- Create Window
local Window = OrionLib:MakeWindow({
    Name = "Feature Control Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "FeatureControlConfig",
    IntroEnabled = true,
    IntroText = "Loaded!"
})

-- Create Tabs
local CombatTab = Window:MakeTab({ Name = "Combat" })
local PlayerTab = Window:MakeTab({ Name = "Player" })
local VisualsTab = Window:MakeTab({ Name = "Visuals" })
local WorldTab = Window:MakeTab({ Name = "World" })
local MiscTab = Window:MakeTab({ Name = "Misc" })

--============================================================================--
--                              UI ELEMENT CREATION                           --
--============================================================================--

-- Combat Tab
CombatTab:AddToggle({
    Name = "Death Grab",
    Default = false,
    Callback = function(enabled) states.deathGrab = enabled end
})
CombatTab:AddToggle({
    Name = "Noclip Grab",
    Default = false,
    Callback = function(enabled) states.noclipGrab = enabled end
})
CombatTab:AddToggle({
    Name = "Auto Attacker (Death)",
    Default = false,
    Callback = function(enabled) states.autoAttacker = enabled end
})
CombatTab:AddToggle({
    Name = "Death Aura",
    Default = false,
    Callback = function(enabled) states.deathAura = enabled end
})
CombatTab:AddToggle({
    Name = "Loop Kill Target",
    Default = false,
    Callback = function(enabled) states.loopKill = enabled end
})
CombatTab:AddButton({
    Name = "Kill All",
    Callback = function()
        -- これはクライアント側のシミュレーションです。安全なゲームでは他のプレイヤーをキルしません。
        local originalPos = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character.HumanoidRootPart.CFrame
        if not originalPos then return end

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local targetHrp = p.Character.HumanoidRootPart
                localPlayer.Character.HumanoidRootPart.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
                p.Character.Humanoid.Health = 0 -- この行はFilteringEnabledのため、おそらく機能しません。
                task.wait(0.1)
            end
        end
        localPlayer.Character.HumanoidRootPart.CFrame = originalPos
    end
})

-- Player Tab
PlayerTab:AddToggle({
    Name = "Super Strong",
    Default = false,
    Callback = function(enabled)
        states.superStrong = enabled
        local character = localPlayer.Character
        if not (character and character:FindFirstChild("Humanoid")) then return end
        local humanoid = character.Humanoid
        if enabled then
            humanoid.WalkSpeed = 50
            humanoid.JumpPower = 100
            if not character:FindFirstChild("ForceField") then Instance.new("ForceField", character) end
        else
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            if character:FindFirstChild("ForceField") then character.ForceField:Destroy() end
        end
    end
})
PlayerTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(enabled) states.noclip = enabled end
})
PlayerTab:AddToggle({
    Name = "Invisible",
    Default = false,
    Callback = function(enabled)
        states.invisible = enabled
        local char = localPlayer.Character
        if not char then return end
        -- これはクライアント側のみです。他のプレイヤーには通常通り見えます。
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = states.invisible and 1 or 0
            end
        end
    end
})
PlayerTab:AddToggle({
    Name = "Anchor Self (Fixed)",
    Default = false,
    Callback = function(enabled)
        local char = localPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Anchored = enabled
        end
    end
})
PlayerTab:AddToggle({
    Name = "Auto Anchor (Re-anchor)",
    Default = false,
    Callback = function(enabled) states.autoAnchor = enabled end
})
PlayerTab:AddToggle({
    Name = "Click TP (Ctrl)",
    Default = false,
    Callback = function(enabled) states.clickTp = enabled end
})
PlayerTab:AddToggle({
    Name = "Perspective",
    Default = false,
    Callback = function(enabled)
        if enabled then
            localPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
        else
            localPlayer.CameraMode = Enum.CameraMode.Classic
            localPlayer.CameraMinZoomDistance = 0.5
            localPlayer.CameraMaxZoomDistance = 128
        end
    end
})

-- Visuals Tab
VisualsTab:AddToggle({
    Name = "Line ESP",
    Default = false,
    Callback = function(enabled)
        states.lineEsp = enabled
        if not enabled then
            for _, line in pairs(lineAdornments) do if line then line:Destroy() end end
            lineAdornments = {}
        end
    end
})
VisualsTab:AddToggle({
    Name = "Radioactive Aura",
    Default = false,
    Callback = function(enabled) states.radioactiveAura = enabled end
})
VisualsTab:AddToggle({
    Name = "Blobman Lock",
    Default = false,
    Callback = function(enabled) states.blobmanLock = enabled end
})

-- World Tab
WorldTab:AddButton({
    Name = "Bring All (Client-Side)",
    Callback = function()
        -- これはあなたの画面上でのみ他のプレイヤーをテレポートさせます。他のプレイヤーには影響しません。
        local myHrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                -- ネットワークオーナーシップのため、ほとんどのゲームでは機能しません。
                p.Character:SetPrimaryPartCFrame(myHrp.CFrame * CFrame.new(math.random(-10, 10), 5, math.random(-10, 10)))
            end
        end
    end
})

-- Misc Tab
MiscTab:AddToggle({
    Name = "Soft Lag",
    Default = false,
    Callback = function(enabled) states.softLag = enabled end
})
MiscTab:AddToggle({
    Name = "Anti-Kick (Iyhan)",
    Default = false,
    Callback = function(enabled)
        states.antiKick = enabled
        -- この部分はエクスプロイト実行環境でのみ機能します。Roblox Studioでは何もしません。
        if enabled and getrawmetatable and setreadonly then
            pcall(function()
                local mt = getrawmetatable(game)
                local old_namecall = mt.__namecall
                setreadonly(mt, false)
                mt.__namecall = function(self, ...)
                    if getnamecallmethod():lower() == "kick" then
                        return "Player has been kicked." -- 偽の戻り値を返す
                    end
                    return old_namecall(self, ...)
                end
                setreadonly(mt, true)
            end)
        end
    end
})

OrionLib:Init()

--============================================================================--
--                           CORE FEATURE LOGIC                               --
--============================================================================--

-- Mouse Input Handler
mouse.Button1Down:Connect(function()
    if not mouse.Target then return end
    local char = localPlayer.Character

    -- Click TP Logic
    if states.clickTp and char and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
        char:MoveTo(mouse.Hit.p)
    end

    -- Grab Logic
    if (states.deathGrab or states.noclipGrab) and mouse.Target.Parent and mouse.Target.Parent:FindFirstChild("Humanoid") then
        local targetCharacter = mouse.Target.Parent
        if targetCharacter ~= char then
            grabTarget = targetCharacter
        end
    end
end)

mouse.Button1Up:Connect(function()
    grabTarget = nil
end)

-- Keyboard Input Handler
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    -- Death Grab Action Key
    if input.KeyCode == Enum.KeyCode.Q and states.deathGrab and grabTarget and grabTarget:FindFirstChild("Humanoid") then
        -- これはクライアント側のシミュレーションです。安全なゲームでは他のプレイヤーをキルしません。
        -- これを機能させるには、サーバーにアクションを実行するよう依頼するRemoteEventが必要です。
        print("Attempting to 'eliminate' " .. grabTarget.Name)
        grabTarget.Humanoid.Health = 0
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    local char = localPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Noclip Logic
    if states.noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- Grab Movement Logic
    if grabTarget and grabTarget.PrimaryPart then
        if states.deathGrab or states.noclipGrab then
            -- 掴んだターゲットをクライアントのカメラの前に移動させます。
            -- ネットワークオーナーシップのため、安全なゲームでは機能しないか、他のプレイヤーに複製されません。
            local camera = workspace.CurrentCamera
            local newPosition = camera.CFrame.p + camera.CFrame.LookVector * 10
            grabTarget:SetPrimaryPartCFrame(CFrame.new(newPosition))
        end
    end

    -- Blobman Lock (Aim at nearest player)
    if states.blobmanLock then
        local nearest, minDist = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local dist = (p.Character.Head.Position - hrp.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = p.Character
                end
            end
        end
        if nearest then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, nearest.Head.Position)
        end
    end

    -- Line ESP Logic
    if states.lineEsp then
        for p, line in pairs(lineAdornments) do
            if not (p and p.Parent and p.Character and p.Character.Parent) then
                if line then line:Destroy() end
                lineAdornments[p] = nil
            end
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if not lineAdornments[p] then
                    local line = Instance.new("LineHandleAdornment")
                    line.Adornee = hrp
                    line.Target = p.Character.HumanoidRootPart
                    line.Color3 = Color3.new(1, 0, 0)
                    line.Thickness = 1
                    line.AlwaysOnTop = true
                    line.Parent = workspace
                    lineAdornments[p] = line
                end
            end
        end
    end

    -- Soft Lag Logic
    if states.softLag then
        softLagTick = softLagTick + 1
        if softLagTick % 10 == 0 then
            hrp.Anchored = not hrp.Anchored
        end
    end

    -- Auto Anchor Logic
    if states.autoAnchor then
        hrp.Anchored = true
    end

    -- Aura / Auto-Attack Logic
    if states.deathAura or states.autoAttacker or (states.loopKill and grabTarget) then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local targetHrp = p.Character.HumanoidRootPart
                local dist = (targetHrp.Position - hrp.Position).Magnitude
                
                local shouldAttack = false
                if states.loopKill and p.Character == grabTarget then shouldAttack = true end
                if (states.deathAura or states.autoAttacker) and dist < 25 then shouldAttack = true end

                if shouldAttack then
                    -- これはクライアント側のシミュレーションです。安全なゲームでは他のプレイヤーをキルしません。
                    p.Character.Humanoid.Health = 0
                end
            end
        end
    end

    -- Radioactive Aura (Visual)
    if states.radioactiveAura then
        if not radioactivePart or not radioactivePart.Parent then
            radioactivePart = Instance.new("Part")
            radioactivePart.Name = "RadioactiveField"
            radioactivePart.CanCollide = false
            radioactivePart.Anchored = true
            radioactivePart.Shape = Enum.PartType.Ball
            radioactivePart.Size = Vector3.new(20, 20, 20)
            radioactivePart.Color = Color3.fromRGB(0, 255, 0)
            radioactivePart.Transparency = 0.7
            radioactivePart.Material = Enum.Material.Neon
            radioactivePart.Parent = workspace
        end
        radioactivePart.CFrame = hrp.CFrame
    elseif radioactivePart then
        radioactivePart:Destroy()
        radioactivePart = nil
    end
end)

-- Character Reset Logic
localPlayer.CharacterAdded:Connect(function(character)
    -- Re-apply super strong if it was enabled
    if states.superStrong then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = 50
        humanoid.JumpPower = 100
        if not character:FindFirstChild("ForceField") then Instance.new("ForceField", character) end
    end

    -- Re-apply invisibility if it was enabled
    if states.invisible then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 1
            end
        end
    end

    -- Reset noclip state variable
    states.noclip = false
end)

-- Cleanup on script removal
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == localPlayer then
        if radioactivePart then radioactivePart:Destroy() end
        for _, line in pairs(lineAdornments) do if line then line:Destroy() end end
    end
end)
