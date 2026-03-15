-- OrionLibを読み込み
local OrionUrl = "https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/source.txt"
local OrionLib = loadstring(game:HttpGet(OrionUrl))()

-- サービス定義
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- グローバル設定用テーブル（各機能の状態を保持）
_G.Settings = {
    SuperStrength = false,
    Strength = 400,
    DeathGrab = false,
    NoclipGrab = false,
    PerspectiveGrab = false,
    PerspectiveSpeed = 50,
    DeathAura = false,
    RadioactiveAura = false,
    LineExtend = false,
    ExtendAmount = 3,
    SoftLag = false,
    InvisibleLine = false,
    LoopKill = false,
    KillAll = false,
    BringAll = false,
    AntiKick = false,
    BlobmanLock = false,
    BlobmanTarget = nil,
    AutoAttackerDeath = false,
    AnchorButton = false,
    TeleportButton = false,
}

-- プレイヤー選択用のグローバル変数（各タブで共有）
local SelectedPlayer = nil
local SelectedPlayerName = ""

-- ヘルパー関数（bliz hubより抜粋）
local function GetPlayerCharacter()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character or nil
end

local function GetPlayerRoot()
    local char = GetPlayerCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function lookAt(from, to)
    return CFrame.lookAt(from, to)
end

local function SNOWshipOnce(part)
    local root = GetPlayerRoot()
    if not root then return false end
    if part:FindFirstChild("PartOwner") and part.PartOwner.Value == LocalPlayer.Name then
        return true
    end
    if (part.Position - root.Position).Magnitude <= 30 then
        ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner"):FireServer(part, lookAt(root.Position, part.Position))
    end
    return false
end

local function DeleteToy(toy)
    ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy"):FireServer(toy)
end

-- アンチキック関数（いやんはぶより抜粋・簡略化）
local function antiKickLoop()
    while _G.Settings.AntiKick do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") and not LocalPlayer:FindFirstChild("InPlot") then
            local backpack = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
            if backpack then
                local kunai = backpack:FindFirstChild("NinjaKunai")
                if kunai then
                    local sticky = kunai:FindFirstChild("StickyPart")
                    if sticky and sticky:FindFirstChild("StickyWeld") then
                        local weld = sticky.StickyWeld
                        if not weld.Part1 or weld.Part1 ~= char:FindFirstChild("Left Leg") then
                            local playerEvents = ReplicatedStorage:FindFirstChild("PlayerEvents")
                            if playerEvents then
                                local stickyEvent = playerEvents:FindFirstChild("StickyPartEvent")
                                if stickyEvent then
                                    stickyEvent:FireServer(sticky, char:FindFirstChild("Left Leg"), CFrame.new(0, -0.5, 0) * CFrame.Angles(0, 0, math.rad(90)))
                                end
                            end
                        end
                    end
                elseif LocalPlayer:FindFirstChild("CanSpawnToy") and LocalPlayer.CanSpawnToy.Value then
                    local spawnFunc = ReplicatedStorage:FindFirstChild("MenuToys") and ReplicatedStorage.MenuToys:FindFirstChild("SpawnToyRemoteFunction")
                    if spawnFunc then
                        spawnFunc:InvokeServer("NinjaKunai", char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5), Vector3.new(0, 0, 0))
                    end
                end
            end
        end
        task.wait(0.5)
    end
end

-- グラブ関連の処理（bliz hubより）
local function onGrab(model)
    if model.Name ~= "GrabParts" then return end
    local grabbedPart = model:FindFirstChild("GrabPart") and model.GrabPart:FindFirstChild("WeldConstraint") and model.GrabPart.WeldConstraint.Part1
    if not grabbedPart then return end

    -- スーパーストレングス
    if _G.Settings.SuperStrength then
        local bv = Instance.new("BodyVelocity", grabbedPart)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Workspace.CurrentCamera.CFrame.LookVector * _G.Settings.Strength
        Debris:AddItem(bv, 1)
    end

    -- デスグラブ
    if _G.Settings.DeathGrab and grabbedPart.Parent:FindFirstChildOfClass("Humanoid") then
        local hum = grabbedPart.Parent:FindFirstChildOfClass("Humanoid")
        hum.Health = 0
    end

    -- ノクリップグラブ
    if _G.Settings.NoclipGrab and grabbedPart.Parent:IsA("Model") then
        for _, v in ipairs(grabbedPart.Parent:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
        model.AncestryChanged:Connect(function()
            for _, v in ipairs(grabbedPart.Parent:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end)
    end

    -- パースペクティブグラブ
    if _G.Settings.PerspectiveGrab then
        local cam = Workspace.CurrentCamera
        local debugPart = Instance.new("Part", Workspace)
        debugPart.Anchored = true
        debugPart.CanCollide = false
        debugPart.Transparency = 1
        debugPart.CFrame = cam.CFrame
        cam.CameraType = Enum.CameraType.Scriptable
        cam.CameraSubject = debugPart
        local heartbeat
        heartbeat = RunService.Heartbeat:Connect(function()
            if not model.Parent then
                heartbeat:Disconnect()
                debugPart:Destroy()
                cam.CameraType = Enum.CameraType.Custom
                cam.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                return
            end
            local moveDir = LocalPlayer.Character.Humanoid.MoveDirection * _G.Settings.PerspectiveSpeed
            debugPart.CFrame = debugPart.CFrame * CFrame.new(moveDir)
        end)
    end
end

Workspace.ChildAdded:Connect(onGrab)

-- オーラ処理（bliz hubより）
local poisonParts = {
    Workspace.Map and Workspace.Map:FindFirstChild("Hole") and Workspace.Map.Hole:FindFirstChild("PoisonBigHole") and Workspace.Map.Hole.PoisonBigHole:FindFirstChild("PoisonHurtPart"),
    Workspace.Map and Workspace.Map:FindFirstChild("Hole") and Workspace.Map.Hole:FindFirstChild("PoisonSmallHole") and Workspace.Map.Hole.PoisonSmallHole:FindFirstChild("PoisonHurtPart"),
    Workspace.Map and Workspace.Map:FindFirstChild("FactoryIsland") and Workspace.Map.FactoryIsland:FindFirstChild("PoisonContainer") and Workspace.Map.FactoryIsland.PoisonContainer:FindFirstChild("PoisonHurtPart")
}
local radioactivePart = Workspace.Map and Workspace.Map:FindFirstChild("AlwaysHereTweenedObjects") and Workspace.Map.AlwaysHereTweenedObjects:FindFirstChild("OuterUFO") and Workspace.Map.AlwaysHereTweenedObjects.OuterUFO:FindFirstChild("Object") and Workspace.Map.AlwaysHereTweenedObjects.OuterUFO.Object:FindFirstChild("ObjectModel") and Workspace.Map.AlwaysHereTweenedObjects.OuterUFO.Object.ObjectModel:FindFirstChild("PaintPlayerPart")

RunService.Heartbeat:Connect(function()
    -- デスオーラ
    if _G.Settings.DeathAura then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                local root = GetPlayerRoot()
                if root and (hrp.Position - root.Position).Magnitude < 20 then
                    if SNOWshipOnce(hrp) then
                        local hum = player.Character:FindFirstChildOfClass("Humanoid")
                        if hum then hum.Health = 0 end
                    end
                end
            end
        end
    end

    -- ラジオアクティブオーラ
    if _G.Settings.RadioactiveAura and radioactivePart then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local root = GetPlayerRoot()
                if root and (head.Position - root.Position).Magnitude < 20 then
                    if SNOWshipOnce(head) then
                        radioactivePart.CFrame = head.CFrame
                        task.wait()
                        radioactivePart.Position = Vector3.new(0, -50, 0)
                    end
                end
            end
        end
    end
end)

-- ラインエクステンダー・ソフトラグ・インビジブルライン
local lineExtendConnection
function toggleLineExtend(state)
    if state then
        -- 実際のライン延長はグラブ生成時に距離を操作する必要があるため、ここでは簡易的な処理
        lineExtendConnection = RunService.Heartbeat:Connect(function()
            -- ダミー：特に何もしないが、フラグとして機能
        end)
    elseif lineExtendConnection then
        lineExtendConnection:Disconnect()
    end
end

local softLagConnection
function toggleSoftLag(state)
    if state then
        softLagConnection = RunService.Heartbeat:Connect(function()
            for i = 1, 10 do
                local createLine = ReplicatedStorage:FindFirstChild("GrabEvents") and ReplicatedStorage.GrabEvents:FindFirstChild("CreateGrabLine")
                if createLine then
                    createLine:FireServer(Workspace:FindFirstChildOfClass("Part"), CFrame.new(0,0,0))
                end
            end
        end)
    elseif softLagConnection then
        softLagConnection:Disconnect()
    end
end

local invisibleLineConnection
function toggleInvisibleLine(state)
    if state then
        invisibleLineConnection = RunService.Heartbeat:Connect(function()
            -- ラインを非表示にするには、既存のラインの透明度を操作するか、生成を抑制する
            -- ここではダミー
        end)
    elseif invisibleLineConnection then
        invisibleLineConnection:Disconnect()
    end
end

-- ループキル
function loopKill()
    while _G.Settings.LoopKill do
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                if SNOWshipOnce(hrp) then
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.Health = 0 end
                end
            end
        end
        task.wait(0.5)
    end
end

-- キルオール
function killAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        end
    end
end

-- ブリングオール
function bringAll()
    local root = GetPlayerRoot()
    if not root then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0, 0, 5)
        end
    end
end

-- ブロブマンロック（自分が座っているブロブマンで対象を掴む）
function blobmanLock(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or not hum.SeatPart then return end
    local blob = hum.SeatPart.Parent
    if blob.Name ~= "CreatureBlobman" then return end
    local detector = blob:FindFirstChild("LeftDetector")
    if not detector then return end
    local weld = detector:FindFirstChild("LeftWeld")
    if not weld then return end
    local grabScript = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
    if grabScript then
        local grab = grabScript:FindFirstChild("CreatureGrab")
        if grab then
            grab:FireServer(detector, targetPlayer.Character.HumanoidRootPart, weld)
        end
    end
end

-- アンカーボタン（見ているオブジェクトをアンカー）
function anchorObject()
    local root = GetPlayerRoot()
    if not root then return end
    local ray = Ray.new(root.Position, Workspace.CurrentCamera.CFrame.LookVector * 100)
    local hit, pos = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
    if hit and hit.Parent and hit.Parent:IsA("Model") and not hit.Anchored then
        hit.Anchored = true
    end
end

-- テレポートボタン（視線先にテレポート）
function teleportToCursor()
    local root = GetPlayerRoot()
    if not root then return end
    local ray = Ray.new(Workspace.CurrentCamera.CFrame.Position, Workspace.CurrentCamera.CFrame.LookVector * 1000)
    local hit, pos = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
    if pos then
        root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

-- アンカー解除（再固定の接待）
function unanchorAll()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Anchored then
            v.Anchored = false
        end
    end
end

-- オートアタッカー（自分を掴んだプレイヤーを殺す）
local function onPartOwnerAdded(part)
    if part.Name == "PartOwner" and part.Value ~= LocalPlayer.Name then
        local attacker = Players:FindFirstChild(part.Value)
        if attacker and attacker.Character and _G.Settings.AutoAttackerDeath then
            local hum = attacker.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        end
    end
end
LocalPlayer.CharacterAdded:Connect(function(char)
    char.DescendantAdded:Connect(onPartOwnerAdded)
end)
if LocalPlayer.Character then
    LocalPlayer.Character.DescendantAdded:Connect(onPartOwnerAdded)
end

-- Orion UI作成
local Window = OrionLib:MakeWindow({
    Name = "Combined Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "CombinedHub",
    IntroEnabled = true,
    IntroText = "Loading...",
    IntroIcon = "rbxassetid://8834748103",
    Icon = "rbxassetid://8834748103"
})

-- プレイヤーリスト更新用関数
local function updatePlayerDropdown(dropdown)
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    dropdown:Refresh(names, true)
end

-- グラブタブ
local GrabTab = Window:MakeTab({ Name = "Grab", Icon = "rbxassetid://3944703587" })
GrabTab:AddToggle({ Name = "Super Strength", Default = false, Callback = function(v) _G.Settings.SuperStrength = v end })
GrabTab:AddSlider({ Name = "Strength", Min = 100, Max = 5000, Default = 400, Callback = function(v) _G.Settings.Strength = v end })
GrabTab:AddToggle({ Name = "Death Grab", Default = false, Callback = function(v) _G.Settings.DeathGrab = v end })
GrabTab:AddToggle({ Name = "Noclip Grab", Default = false, Callback = function(v) _G.Settings.NoclipGrab = v end })
GrabTab:AddToggle({ Name = "Perspective Grab", Default = false, Callback = function(v) _G.Settings.PerspectiveGrab = v end })
GrabTab:AddSlider({ Name = "Perspective Speed", Min = 10, Max = 200, Default = 50, Callback = function(v) _G.Settings.PerspectiveSpeed = v end })
GrabTab:AddButton({ Name = "Anchor Object", Callback = anchorObject })
GrabTab:AddButton({ Name = "Teleport to Cursor", Callback = teleportToCursor })

-- オーラタブ
local AuraTab = Window:MakeTab({ Name = "Aura", Icon = "rbxassetid://3944703587" })
AuraTab:AddToggle({ Name = "Death Aura", Default = false, Callback = function(v) _G.Settings.DeathAura = v end })
AuraTab:AddToggle({ Name = "Radioactive Aura", Default = false, Callback = function(v) _G.Settings.RadioactiveAura = v end })

-- ブロブマンタブ
local BlobmanTab = Window:MakeTab({ Name = "Blobman", Icon = "rbxassetid://3944703587" })
local blobmanTargetDropdown = BlobmanTab:AddDropdown({
    Name = "Select Target",
    Options = {},
    Callback = function(v)
        SelectedPlayerName = v
        _G.Settings.BlobmanTarget = Players:FindFirstChild(v)
    end
})
updatePlayerDropdown(blobmanTargetDropdown)
Players.PlayerAdded:Connect(function() updatePlayerDropdown(blobmanTargetDropdown) end)
Players.PlayerRemoving:Connect(function() updatePlayerDropdown(blobmanTargetDropdown) end)

BlobmanTab:AddButton({
    Name = "Lock (Grab with Blobman)",
    Callback = function()
        blobmanLock(_G.Settings.BlobmanTarget)
    end
})

-- プレイヤータブ
local PlayerTab = Window:MakeTab({ Name = "Player", Icon = "rbxassetid://3944703587" })
PlayerTab:AddToggle({ Name = "Auto Attacker (Death Mode)", Default = false, Callback = function(v) _G.Settings.AutoAttackerDeath = v end })
PlayerTab:AddToggle({
    Name = "Loop Kill",
    Default = false,
    Callback = function(v)
        _G.Settings.LoopKill = v
        if v then task.spawn(loopKill) end
    end
})
PlayerTab:AddButton({ Name = "Kill All", Callback = killAll })
PlayerTab:AddButton({ Name = "Bring All", Callback = bringAll })

-- ラインタブ
local LineTab = Window:MakeTab({ Name = "Line", Icon = "rbxassetid://3944703587" })
LineTab:AddToggle({ Name = "Line Extender", Default = false, Callback = toggleLineExtend })
LineTab:AddSlider({ Name = "Extend Amount", Min = 1, Max = 20, Default = 3, Callback = function(v) _G.LineExtendAmount = v end })
LineTab:AddToggle({ Name = "Soft Lag", Default = false, Callback = toggleSoftLag })
LineTab:AddToggle({ Name = "Invisible Line", Default = false, Callback = toggleInvisibleLine })

-- ディフェンスタブ
local DefenseTab = Window:MakeTab({ Name = "Defense", Icon = "rbxassetid://3944703587" })
DefenseTab:AddToggle({
    Name = "Anti-Kick (Iyan)",
    Default = false,
    Callback = function(v)
        _G.Settings.AntiKick = v
        if v then task.spawn(antiKickLoop) end
    end
})
DefenseTab:AddButton({ Name = "Unanchor All (Re-anchor)", Callback = unanchorAll })

OrionLib:Init()
