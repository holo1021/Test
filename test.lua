-- 各種サービスを取得
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local DebrisService = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

-- GrabEventsを安全に取得 (タイムアウト付きで待機し、無限ロードを防ぐ)
local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents", 5)
if not GrabEvents then
    warn("GrabEvents not found. Some features may not work.")
end

local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

-- Orion Lib (HolonHubのUIライブラリ) をロード
local OrionUrl = "https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/source.txt"
local success, lib = pcall(function()
    return loadstring(game:HttpGet(OrionUrl))()
end)

if not success then
    warn("Failed to load OrionLib: " .. tostring(lib))
    return -- Stop the script if OrionLib fails to load
end

local OrionLib = lib

-- 既存のUIを強制削除（二重表示防止, holonhub.lua参考）
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("Orion") then 
        game:GetService("CoreGui").Orion:Destroy() 
    end
end)

-- UI要素を管理するテーブル
local UIElements = {}

-- 各種変数
local superStrengthEnabled = false
local strengthValue = 400
local deathGrabEnabled = false
local noclipGrabEnabled = false
local perspectiveGrabEnabled = false
local perspectiveSpeed = 50
local crazyLineEnabled = false
local invisibleLineEnabled = false

local lastGrabbedPart = nil
local noclipOriginalCollisions = {}
local auto_back_position = false
local targetPlayerName = "" -- ターゲットプレイヤー名を保存する変数
local counterMode = "Repulsion"

-- Blobman Kick用
local levitateRunning = false
local tpTargetName = ""
_G.AutoAttacker = false
_G.CounterMode = "Repulsion"
local loopKillEnabled = false
local loopKillTargetName = ""

-- Bliz Aura Variables
_G.DeathAura = false
_G.AttractionAura = false
_G.FlingAura = false
_G.FlingStrength = 400
_G.FlingTarget = "Players"

-- Helper Functions from Bliz (Moved up for wider scope)
local function CheckNetworkOwnerShipOnPart(part)
    local po = part:FindFirstChild("PartOwner")
    return po and po.Value == LocalPlayer.Name
end

local function SNOWship(part)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and part then
        -- Blizのオリジナルでは距離チェックが30
        if (LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude <= 30 then
             pcall(function()
                if GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner") then
                    GrabEvents.SetNetworkOwner:FireServer(part, CFrame.lookAt(LocalPlayer.Character.HumanoidRootPart.Position, part.Position))
                end
             end)
             return CheckNetworkOwnerShipOnPart(part)
        end
    end
    return false
end

local function SNOWshipPlayer(player)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
        -- Blizはプレイヤーの所有権チェックにHeadを使用
        local head = player.Character.Head
        if CheckNetworkOwnerShipOnPart(head) then return true end
        return SNOWship(player.Character.HumanoidRootPart)
    end
    return false
end

-- Bliz Logic: Check Objects Around Player
local function CheckObjectsAroundPlayer()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return {} end
    local myRoot = LocalPlayer.Character.HumanoidRootPart
    
    local params = OverlapParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, Workspace:FindFirstChild("Map"), Workspace:FindFirstChild("Plots")}
    params.FilterType = Enum.RaycastFilterType.Exclude
    
    local parts = Workspace:GetPartBoundsInRadius(myRoot.Position, 30, params)
    local objects = {}
    
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") and not part.Anchored and part.Name ~= "Handle" and part.Parent and not part.Parent:FindFirstChild("Humanoid") then
             table.insert(objects, part)
        end
    end
    return objects
end

-- UIを生成
local Window = OrionLib:MakeWindow({
    Name = "Test Hub (Bliz Strength)",
    HidePremium = false,
    SaveConfig = false, -- 保存機能を無効化 (クラッシュ防止)
    ConfigFolder = "TestHub",
    IntroEnabled = true,
    IntroText = "Bliz SuperStrength"
})

-- タブ作成
local GrabTab = Window:MakeTab({
	Name = "掴む",
	Icon = "rbxassetid://4483345998" -- Grab Icon
})

local DefenseTab = Window:MakeTab({
    Name = "無敵 (Invincibility)",
    Icon = "rbxassetid://7734056608"
})

local ActionTab = Window:MakeTab({
    Name = "アクション",
    Icon = "rbxassetid://7743875962" -- Player Icon
})

local AuraTab = Window:MakeTab({
	Name = "オーラ",
	Icon = "rbxassetid://7733955740"
})

local KeyboardTab = Window:MakeTab({
	Name = "キーボード",
	Icon = "rbxassetid://10734950309" -- Config Icon
})

-- プレイヤーリスト取得関数 (holonhub.luaより)
local function getPList()
    local plist = {"選択してください"}
    for _, p in ipairs(Players:GetPlayers()) do
        -- 「表示名 (@ユーザー名)」の形式でテーブルに入れる
        table.insert(plist, p.DisplayName .. " (@" .. p.Name .. ")")
    end
    return plist
end

-- --- 掴むタブ ---
local GrabControlSec = GrabTab:AddSection({ Name = "掴み制御" })

UIElements.SuperStrengthToggle = GrabControlSec:AddToggle({
	Name = "SuperStrength (投げ飛ばし)",
	Default = false,
	Callback = function(v)
		superStrengthEnabled = v
	end    
})

UIElements.StrengthSlider = GrabControlSec:AddSlider({
	Name = "Strength (強さ)",
	Min = 400,
    Max = 10000,
    Default = 400,
    Increment = 100,
    ValueName = "Power",
	Callback = function(v)
		strengthValue = v
	end    
})

UIElements.DeathGrabToggle = GrabControlSec:AddToggle({
	Name = "Death Grab",
	Default = false,
	Callback = function(v)
		deathGrabEnabled = v
	end    
})

UIElements.NoclipGrabToggle = GrabControlSec:AddToggle({
    Name = "Noclip Grab",
    Default = false,
    Callback = function(v)
        noclipGrabEnabled = v
        -- トグルをOFFにした時に、もし掴んでいる最中なら当たり判定を元に戻す
        if not v then
            for part, state in pairs(noclipOriginalCollisions) do
                if part and part.Parent then
                    pcall(function() part.CanCollide = state end)
                end
            end
            noclipOriginalCollisions = {}
        end
    end
})

UIElements.LineToggle = GrabControlSec:AddToggle({
        Name = "Crazy Line",
        Default = false,
        Callback = function(v)
            _G.CrazyLine = v
            if v then
                task.spawn(function()
                    while _G.CrazyLine do
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character then
                                local targetPart = p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("HumanoidRootPart")
                                if targetPart then
                                    -- Blizのソースコードにある固定CFrameを使用
                                    pcall(function() GrabEvents.CreateGrabLine:FireServer(targetPart, CFrame.new(0.12640380859375, 0.9606337547302246, - 0.5000009536743164, 0.9985212683677673, 0, - 0.05436277016997337, - 6.4805472099749295e-9, 1, - 1.1903301100346653e-7, 0.05436277016997337, 5.960464477539063e-8, 0.9985212683677673)) end)
                                end
                            end
                        end
                        task.wait()
                    end
                end)
            end
        end
    })

UIElements.InvisibleLineToggle = GrabControlSec:AddToggle({
	Name = "Invisible Line",
	Default = false,
	Callback = function(v)
		invisibleLineEnabled = v
	end    
})

-- --- 防御タブ (Invincibility) ---
local CounterSec = DefenseTab:AddSection({ Name = "Counter-Attack" })

CounterSec:AddToggle({
    Name = "Auto-Attacker",
    Default = false,
    Callback = function(v)
        _G.AutoAttacker = v
    end,
    Save = true,
    Flag = "rinnegan_toggle"
})

CounterSec:AddDropdown({
    Name = "Counter Mode",
    Default = "Repulsion",
    Options = {"Repulsion", "Death"},
    Callback = function(v)
        counterMode = v
    end
})

-- Bliz-like Counter Logic
local function PerformCounterAction(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hum = targetPlayer.Character:FindFirstChild("Humanoid")
    
    if not root or not hum then return end
    
    if counterMode == "Repulsion" then
        -- Repulsion Logic
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            local lookAtCFrame = CFrame.lookAt(myRoot.Position, root.Position)
            local bv = Instance.new("BodyVelocity")
            bv.Name = "RepulsionVelocity"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(lookAtCFrame.LookVector.X, 0.5, lookAtCFrame.LookVector.Z) * 100
            bv.Parent = root
            DebrisService:AddItem(bv, 0.5)
            
            if GrabEvents and GrabEvents:FindFirstChild("DestroyGrabLine") then
                GrabEvents.DestroyGrabLine:FireServer(root)
            end
        end
        
    elseif counterMode == "Death" then
        -- Death Logic
        if GrabEvents and GrabEvents:FindFirstChild("DestroyGrabLine") then
            -- Create SkyVelocity
            if not root:FindFirstChild("SkyVelocity") then
                local bv = Instance.new("BodyVelocity", root)
                bv.Name = "SkyVelocity"
                bv.Velocity = Vector3.new(0, 100000000000000, 0)
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            end
            
            for _ = 0, 20 do
                hum.BreakJointsOnDeath = false
                hum:ChangeState(Enum.HumanoidStateType.Dead)
                hum.Jump = true
                hum.Sit = true
            end
            task.wait()
            GrabEvents.DestroyGrabLine:FireServer(root)
        end
    end
end

local function AttemptCounter(targetPlayer)
    if not targetPlayer then return end
    
    task.spawn(function()
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        
        -- Bliz Loop Logic
        for i = 1, 50 do
            if not targetPlayer.Character or not targetPlayer.Character.Parent then break end
            
            local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local head = targetPlayer.Character:FindFirstChild("Head")
            if not root or not head then task.wait(0.1) continue end

            -- Check Ownership (Head.PartOwner)
            local po = head:FindFirstChild("PartOwner")
            if po and po.Value == LocalPlayer.Name then
                -- We have ownership, perform action
                PerformCounterAction(targetPlayer)
                break -- Exit loop after action
            else
                -- Request Ownership
                local Sno = GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner")
                if Sno and (root.Position - myRoot.Position).Magnitude <= 50 then
                    -- Bliz uses lookAt from Local to Target
                    local lookCF = CFrame.lookAt(myRoot.Position, root.Position)
                    pcall(function() 
                        Sno:FireServer(root, lookCF) 
                    end)
                end
            end
            task.wait(0.1)
        end
    end)
end

local PerspectiveGrabSec = GrabTab:AddSection({ Name = "三人称視点での掴み (Perspective Grab)" })

UIElements.PerspectiveGrabToggle = PerspectiveGrabSec:AddToggle({
	Name = "Perspective Grab",
	Default = false,
	Callback = function(v)
		perspectiveGrabEnabled = v
	end    
})

UIElements.PerspectiveSpeedSlider = PerspectiveGrabSec:AddSlider({
	Name = "Perspective Speed",
	Min = 20,
    Max = 200,
    Default = 50,
    Increment = 5,
	Callback = function(v) perspectiveSpeed = v end    
})

-- --- アクションタブ (UI構築をここに移動) ---
local BlobmanKickSec = ActionTab:AddSection({ Name = "Actions" })

BlobmanKickSec:AddDropdown({
    Name = "アクション対象",
    Default = "選択してください",
    Options = getPList(),
    Callback = function(v)
        if v == "選択してください" then
            tpTargetName = ""
        else
            tpTargetName = v:match("@([^)]+)")
        end
    end
})

BlobmanKickSec:AddButton({
    Name = "Blobman Bring",
    Callback = function()
        local target = Players:FindFirstChild(tpTargetName)

        if target and target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Blobmanを探す
            local blobman = nil
            local spawned = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
            if spawned then blobman = spawned:FindFirstChild("CreatureBlobman") end
            
            -- 自動生成ロジック
            if not blobman then
                local mt = ReplicatedStorage:FindFirstChild("MenuToys")
                local st = mt and mt:FindFirstChild("SpawnToyRemoteFunction")
                if st then
                    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local spawnCF = myRoot and (myRoot.CFrame + Vector3.new(0, 5, 0)) or CFrame.new(0, 50, 0)
                    st:InvokeServer("CreatureBlobman", spawnCF, Vector3.zero)
                    task.wait(0.5)
                    -- 再取得
                    spawned = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                    if spawned then blobman = spawned:FindFirstChild("CreatureBlobman") end
                end
            end

            if not blobman then
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj.Name == "CreatureBlobman" and obj:FindFirstChild("VehicleSeat") then
                        blobman = obj
                        break
                    end
                end
            end
            
            if blobman then
                -- 1. Remoteを探す
                local scriptObj = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
                local grabRemote = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
                local dropRemote = scriptObj and scriptObj:FindFirstChild("CreatureDrop")

                -- 2. DetectorとWeld/Constraintを探す
                local lDet = blobman:FindFirstChild("LeftDetector")
                local rDet = blobman:FindFirstChild("RightDetector")
                local lWeld = lDet and (lDet:FindFirstChild("LeftWeld") or lDet:FindFirstChild("RigidConstraint"))
                local rWeld = rDet and (rDet:FindFirstChild("RightWeld") or rDet:FindFirstChild("RigidConstraint"))
                
                -- Auto Sit
                local seat = blobman:FindFirstChild("VehicleSeat")
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                if seat and hum then
                    if seat.Occupant ~= hum then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
                        seat:Sit(hum)
                        task.wait(0.3)
                    end
                end
                
                if grabRemote and dropRemote and ((lDet and lWeld) or (rDet and rWeld)) then
                    OrionLib:MakeNotification({ Name = "実行", Content = "Blobman Bring (Once)", Time = 3 })

                    task.spawn(function()
                        local GE = ReplicatedStorage:WaitForChild("GrabEvents")
                        local blobRoot = blobman:FindFirstChild("HumanoidRootPart") or blobman.PrimaryPart
                        local SavedPos = blobRoot.CFrame
                        local Det = rDet or lDet
                        local Weld = rWeld or lWeld
                        
                        -- Phase 1: Capture (ターゲットを捕まえに行く)
                        local bringStart = tick()
                        while tick() - bringStart < 0.5 do
                            if not blobman or not blobman.Parent then break end
                            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                                local tRoot = target.Character.HumanoidRootPart
                                blobRoot.CFrame = tRoot.CFrame
                                blobRoot.AssemblyLinearVelocity = Vector3.zero
                                pcall(function()
                                    if Det then grabRemote:FireServer(Det, tRoot, Weld) end
                                    GE.CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false)
                                    GE.SetNetworkOwner:FireServer(tRoot, blobRoot.CFrame)
                                end)
                            end
                            RunService.Heartbeat:Wait()
                        end
                        
                        -- 元の位置に戻る
                        if blobRoot then
                            blobRoot.CFrame = SavedPos
                            blobRoot.AssemblyLinearVelocity = Vector3.zero
                            task.wait(0.05)
                        end

                        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                            local tRoot = target.Character.HumanoidRootPart
                            -- 1. 位置を1回だけ設定
                            tRoot.CFrame = blobRoot.CFrame * CFrame.new(0, 0, 0) 
                            tRoot.AssemblyLinearVelocity = Vector3.zero
                        end
                    end)
                else
                    local missing = {}
                    if not grabRemote then table.insert(missing, "CreatureGrab") end
                    if not dropRemote then table.insert(missing, "CreatureDrop") end
                    if not (lDet or rDet) then table.insert(missing, "Detector") end
                    if not (lWeld or rWeld) then table.insert(missing, "Weld/Constraint") end
                    OrionLib:MakeNotification({ Name = "エラー", Content = "不足: " .. table.concat(missing, ", "), Time = 5 })
                end
            else
                OrionLib:MakeNotification({ Name = "エラー", Content = "Blobmanが見つかりません", Time = 3 })
            end
        end
    end
})

-- ループキルセクション
local LoopKillSec = ActionTab:AddSection({ Name = "Loop Kill" })

LoopKillSec:AddDropdown({
    Name = "ターゲット選択",
    Default = "選択してください",
    Options = getPList(),
    Callback = function(v)
        if v == "選択してください" then
            loopKillTargetName = ""
        else
            -- @以降のユーザー名を正確に切り出す
            loopKillTargetName = v:match("@([^)]+)")
        end
    end
})

LoopKillSec:AddToggle({
        Name = "Loop Kill",
        Default = false,
        Callback = function(loopKill)
            _G.LoopKill = loopKill
            if loopKill then
                while _G.LoopKill do
                    playerCFrame = GetPlayerCFrame()
                    local index5, playerValue5, playerKey5 = pairs(playerList)
                    while true do
                        local playerName5
                        playerKey5, playerName5 = index5(playerValue5, playerKey5)
                        if playerKey5 == nil then
                            break
                        end
                        local playerInstance3 = playersService:FindFirstChild(playerName5)
                        if CheckPlayerForLoopKill(playerInstance3) and ChangeActivityPriority(2) then
                            local humanoidRootPart = playerInstance3.Character:FindFirstChild("HumanoidRootPart")
                            local headPart = playerInstance3.Character:FindFirstChild("Head")
                            local characterHumanoid = playerInstance3.Character:FindFirstChild("Humanoid")
                            if playerInstance3 and (humanoidRootPart and headPart) then
                                for _ = 0, 50 do
                                    dialogueFunction2()
                                    SNOWship(humanoidRootPart)
                                    if not CheckPlayerForLoopKill(playerInstance3) or (not _G.LoopKill or (CheckNetworkOwnerShipOnPlayer(playerInstance3) or humanoidRootPart.AssemblyLinearVelocity.Magnitude > 500)) then
                                        destroyGrabLineEvent:FireServer(humanoidRootPart)
                                        CreateSkyVelocity(humanoidRootPart)
                                        break
                                    end
                                    task.wait()
                                    if humanoidRootPart.Position.Y <= - 12 then
                                        TeleportPlayer(CFrame.new(humanoidRootPart.Position + Vector3.new(0, 5, - 15)), 2)
                                    else
                                        TeleportPlayer(CFrame.new(humanoidRootPart.Position + Vector3.new(0, - 10, - 10)), 2)
                                    end
                                    characterHumanoid.BreakJointsOnDeath = false
                                    characterHumanoid:ChangeState(Enum.HumanoidStateType.Dead)
                                    characterHumanoid.Jump = true
                                    characterHumanoid.Sit = false
                                end
                            end
                            ChangeActivityPriority(0)
                        end
                    end
                    TeleportPlayer(playerCFrame)
                    task.wait(0.2)
                end
                dialogueFunction1()
                TeleportPlayer(playerCFrame)
                print("End LoopKill")
                    print("ts was renamed by itsjose4")
            end
        end,
        Save = true,
        Flag = "lk_toggle"
    })

-- --- キーボードタブ (Bliz Keybinds) ---
local keyboardTargetName = ""

-- 1. Teleport Section
local TeleportSec = KeyboardTab:AddSection({ Name = "Teleport" })

local function onTeleportAction(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        local mouse = LocalPlayer:GetMouse()
        if mouse.Hit then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                -- マウスの位置の少し上にテレポート
                char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 5, 0))
            end
        end
    end
end

TeleportSec:AddToggle({
    Name = "Teleport (Z)",
    Default = false,
    Callback = function(v)
        if v then
            ContextActionService:BindAction("TeleportZ", onTeleportAction, false, Enum.KeyCode.Z)
        else
            ContextActionService:UnbindAction("TeleportZ")
        end
    end
})

-- 2. Anchor Objects Section
local AnchorSec = KeyboardTab:AddSection({ Name = "Anchor Objects" })

local function onAnchorAction(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target then
            local model = target:FindFirstAncestorOfClass("Model")
            local targetToProcess = model or target -- モデルが見つからない場合はパーツ自体を対象
            
            -- 新しいアンカー状態を決定（クリックしたパーツの状態を基準にする）
            local newAnchorState = not target.Anchored

            -- モデル内のすべてのパーツを固定/解除
            if targetToProcess:IsA("Model") then
                for _, part in ipairs(targetToProcess:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Anchored = newAnchorState
                    end
                end
            else -- モデルでない場合はパーツのみ
                targetToProcess.Anchored = newAnchorState
            end

            OrionLib:MakeNotification({
                Name = "Anchor",
                Content = targetToProcess.Name .. (newAnchorState and " [固定]" or " [解除]"),
                Time = 1
            })
            -- エフェクト用 (Bliz参考)
            if newAnchorState then
                -- 固定時: 永続的なハイライトを追加 (既にない場合のみ)
                if not targetToProcess:FindFirstChild("AnchorHighlight") then
                    local selectionBox = Instance.new("SelectionBox")
                    selectionBox.Name = "AnchorHighlight"
                    selectionBox.Adornee = targetToProcess
                    selectionBox.Parent = targetToProcess
                    selectionBox.Color3 = Color3.fromRGB(173, 216, 230)
                end
            else
                -- 解除時: ハイライトを削除し、一瞬だけ赤く表示
                local existing = targetToProcess:FindFirstChild("AnchorHighlight")
                if existing then existing:Destroy() end

                local selectionBox = Instance.new("SelectionBox")
                selectionBox.Adornee = targetToProcess
                selectionBox.Parent = targetToProcess
                selectionBox.Color3 = Color3.new(1, 0, 0)
                DebrisService:AddItem(selectionBox, 0.5)
            end
        end
    end
end

AnchorSec:AddToggle({
    Name = "Anchor (K)",
    Default = false,
    Callback = function(v)
        if v then
            ContextActionService:BindAction("AnchorK", onAnchorAction, false, Enum.KeyCode.K)
        else
            ContextActionService:UnbindAction("AnchorK")
        end
    end
})

-- --- Aura Tab Implementation (Matching Bliz Logic) ---

local NormalAurasSec = AuraTab:AddSection({ Name = "Normal Auras" })
local FlingAuraSec = AuraTab:AddSection({ Name = "Fling Aura" })

NormalAurasSec:AddToggle({
    Name = "Death Aura",
    Default = false,
    Callback = function(v)
        _G.DeathAura = v
        if v then
            task.spawn(function()
                while _G.DeathAura do
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                             if p.Character.Humanoid.Health > 0 then
                                 if SNOWshipPlayer(p) then
                                     local root = p.Character.HumanoidRootPart
                                     local hum = p.Character.Humanoid
                                     pcall(function() GrabEvents.DestroyGrabLine:FireServer(root) end)
                                     
                                     -- SkyVelocity
                                     if not root:FindFirstChild("SkyVelocity") then
                                         local bv = Instance.new("BodyVelocity")
                                         bv.Name = "SkyVelocity"
                                         bv.Velocity = Vector3.new(0, 100000000000000, 0)
                                         bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                         bv.Parent = root
                                         DebrisService:AddItem(bv, 1)
                                     end
                                     
                                     hum.BreakJointsOnDeath = false
                                     hum:ChangeState(Enum.HumanoidStateType.Dead)
                                     hum.Jump = true
                                     hum.Sit = false
                                 end
                             end
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
})

NormalAurasSec:AddToggle({
    Name = "Attraction Aura",
    Default = false,
    Callback = function(v)
        _G.AttractionAura = v
        if v then
            task.spawn(function()
                while _G.AttractionAura do
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                            local root = p.Character.HumanoidRootPart
                            local hum = p.Character.Humanoid
                            if SNOWshipPlayer(p) then
                                hum.Sit = false
                                hum.WalkSpeed = 25
                                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    -- Bliz uses MoveTo with offset
                                    hum:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position)
                                end
                            end
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
})

FlingAuraSec:AddToggle({
    Name = "Fling Aura",
    Default = false,
    Callback = function(v)
        _G.FlingAura = v
        if v then
            task.spawn(function()
                while _G.FlingAura do
                    -- Target Players
                    if _G.FlingTarget == "Players" or _G.FlingTarget == "Players and Objects" then
                        for _, p in ipairs(Players:GetPlayers()) do
                             if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                 local root = p.Character.HumanoidRootPart
                                 if SNOWshipPlayer(p) and not root:FindFirstChild("FlingAuraVelocity") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                     local myRoot = LocalPlayer.Character.HumanoidRootPart
                                     local lookCF = CFrame.lookAt(myRoot.Position, root.Position)
                                     local bv = Instance.new("BodyVelocity")
                                     bv.Name = "FlingAuraVelocity"
                                     bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                     bv.Velocity = Vector3.new(lookCF.LookVector.X, 0.5, lookCF.LookVector.Z) * _G.FlingStrength
                                     bv.Parent = root
                                     DebrisService:AddItem(bv, 0.1)
                                 end
                             end
                        end
                    end

                    -- Target Objects
                    if _G.FlingTarget == "Objects" or _G.FlingTarget == "Players and Objects" then
                        local objects = CheckObjectsAroundPlayer()
                        for _, part in ipairs(objects) do
                             if part and part:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                 if SNOWship(part) and not part:FindFirstChild("FlingAuraVelocity") then
                                     local myRoot = LocalPlayer.Character.HumanoidRootPart
                                     local lookCF = CFrame.lookAt(myRoot.Position, part.Position)
                                     local bv = Instance.new("BodyVelocity")
                                     bv.Name = "FlingAuraVelocity"
                                     bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                     bv.Velocity = Vector3.new(lookCF.LookVector.X, 0.5, lookCF.LookVector.Z) * _G.FlingStrength
                                     bv.Parent = part
                                     DebrisService:AddItem(bv, 0.1)
                                 end
                             end
                        end
                    end

                    task.wait(0.1)
                end
            end)
        end
    end
})

FlingAuraSec:AddSlider({
    Name = "Strength",
    Min = 400,
    Max = 10000,
    Default = 400,
    Increment = 100,
    Callback = function(v) _G.FlingStrength = v end
})

FlingAuraSec:AddDropdown({
    Name = "Target",
    Default = "Players",
    Options = {"Players", "Objects", "Players and Objects"},
    Callback = function(v) _G.FlingTarget = v end
})

-- キャラクターイベントの監視 (カウンター用)
local function OnCharacterAdded(char)
    char.DescendantAdded:Connect(function(descendant)
        if _G.AutoAttacker and descendant.Name == "PartOwner" then
            local attackerName = tostring(descendant.Value)
            local attacker = Players:FindFirstChild(attackerName)
            if attacker and attacker ~= LocalPlayer then
                OrionLib:MakeNotification({ Name = "Counter", Content = "Countering: " .. attackerName, Time = 3 })
                AttemptCounter(attacker)
            end
        end
    end)
end
LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
if LocalPlayer.Character then OnCharacterAdded(LocalPlayer.Character) end

-- 掴んだオブジェクトを追跡
Workspace.ChildAdded:Connect(function(child)
    if child.Name == "GrabParts" and child:IsA("Model") then
        local grabPart = child:FindFirstChild("GrabPart", true)
        if not grabPart then return end
        local weld = grabPart:FindFirstChildOfClass("WeldConstraint")

        if weld and weld.Part1 then
            lastGrabbedPart = weld.Part1
            local grabbedModel = lastGrabbedPart.Parent
            
            -- SuperStrength (投げ飛ばし)
            if superStrengthEnabled then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "BlizSuperStrength"
                bv.MaxForce = Vector3.new(0, 0, 0)
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.Parent = lastGrabbedPart
            end

            -- Death Grab
            if deathGrabEnabled and grabbedModel and grabbedModel:FindFirstChildOfClass("Humanoid") then
                local player = Players:GetPlayerFromCharacter(grabbedModel)
                local hum = grabbedModel:FindFirstChildOfClass("Humanoid")
                local head = grabbedModel:FindFirstChild("Head")
                
                if player and player ~= LocalPlayer and hum and head then
                    task.spawn(function()
                        while child and child.Parent and hum.Health > 0 do
                            -- Blizのキルロジック (所有権がある場合、ステータスをDeadに変更)
                            if head:FindFirstChild("PartOwner") and head.PartOwner.Value == LocalPlayer.Name then
                                hum.BreakJointsOnDeath = false
                                hum:ChangeState(Enum.HumanoidStateType.Dead)
                                hum.Jump = true
                                hum.Sit = false
                            end
                            task.wait(0.1)
                        end
                    end)
                end
            end

            -- Noclip Grab
            if noclipGrabEnabled and grabbedModel and not lastGrabbedPart.Anchored then
                noclipOriginalCollisions = {}
                task.spawn(function()
                    for _, p in ipairs(grabbedModel:GetDescendants()) do
                        if p:IsA("BasePart") then noclipOriginalCollisions[p] = p.CanCollide end
                    end
                    while child and child.Parent do
                        for p in pairs(noclipOriginalCollisions) do
                            if p and p.Parent then p.CanCollide = false end
                        end
                        task.wait(0.2)
                    end
                end)
            end

            -- Perspective Grab
            if perspectiveGrabEnabled then
                -- Blizと同様に、デフォルトのグラブラインを非表示にする
                if GrabEvents then
                    GrabEvents.CreateGrabLine:FireServer()
                end

                task.spawn(function()
                    local char = LocalPlayer.Character
                    if not char then return end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not hum or not root then return end

                    local originalCF = root.CFrame
                    local camPart = Instance.new("Part")
                    camPart.Name = "PerspectiveFocus"
                    camPart.Transparency = 1
                    camPart.CanCollide = false
                    camPart.Anchored = true
                    camPart.Parent = Workspace
                    camPart.CFrame = Camera.CFrame
                    
                    Camera.CameraSubject = camPart
                    Camera.CameraType = Enum.CameraType.Follow
                    
                    local conn = RunService.Heartbeat:Connect(function(dt)
                        if not camPart or not camPart.Parent then return end

                        -- [修正] より直感的で安定した飛行操作（フライ）になるように移動計算ロジックを刷新
                        local moveDir = hum.MoveDirection
                        local finalMove = Vector3.zero

                        if moveDir.Magnitude > 0.01 then
                            local camCF = Camera.CFrame

                            -- カメラの水平方向の「前」と「右」のベクトルを基準にする
                            local camLookHorizontal = (camCF.LookVector * Vector3.new(1, 0, 1)).Unit
                            local camRightHorizontal = (camCF.RightVector * Vector3.new(1, 0, 1)).Unit

                            -- プレイヤーの入力（MoveDirection）が、カメラから見てどれだけ「前」と「右」の成分を持っているか計算
                            local forwardAmount = moveDir:Dot(camLookHorizontal)
                            local rightAmount = moveDir:Dot(camRightHorizontal)

                            -- 「前」成分はカメラの実際の向き（上下含む）に、「右」成分は水平方向に適用する
                            finalMove = (camCF.LookVector * forwardAmount) + (camRightHorizontal * rightAmount)
                        end

                        if finalMove.Magnitude > 0.01 then
                            camPart.CFrame = camPart.CFrame + finalMove.Unit * perspectiveSpeed * dt
                        end

                        -- Bliz同様、キャラクター本体は遠くに隠す
                        root.CFrame = CFrame.new(527, 123, -376) 
                        root.AssemblyLinearVelocity = Vector3.zero
                    end)
                    
                    while child.Parent do task.wait() end
                    
                    conn:Disconnect()
                    local finalCamCF = Camera.CFrame
                    Camera.CameraSubject = hum
                    Camera.CameraType = Enum.CameraType.Custom
                    camPart:Destroy()
                    root.CFrame = finalCamCF

                    -- Blizと同様に、グラブラインの挙動をリセットする
                    if GrabEvents then
                        GrabEvents.CreateGrabLine:FireServer()
                    end
                end)
            end
        end
    end
end)

-- オブジェクトを離した時の処理 (blizのロジックを再現)
Workspace.ChildRemoved:Connect(function(child)
    if child.Name == "GrabParts" and child:IsA("Model") then
        -- SuperStrength 処理
        if superStrengthEnabled and lastGrabbedPart and lastGrabbedPart.Parent then
            local bv = lastGrabbedPart:FindFirstChild("BlizSuperStrength")
            if bv then
                if UserInputService:GetLastInputType() == Enum.UserInputType.MouseButton2 then
                    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bv.Velocity = Camera.CFrame.LookVector * strengthValue
                    DebrisService:AddItem(bv, 1) -- 1秒後に自動で削除
                else
                    bv:Destroy()
                end
            end
        end
        
        -- Noclip Grab の当たり判定を元に戻す
        for part, state in pairs(noclipOriginalCollisions) do
            if part and part.Parent then
                pcall(function() part.CanCollide = state end)
            end
        end
        noclipOriginalCollisions = {}

        -- 最後にリセット
        lastGrabbedPart = nil
    end
end)

-- クレイジーラインとインビジブルラインの常時ループ処理 (Bliz参考: 掴み中の動的変更に対応)
RunService.Heartbeat:Connect(function()
    if not GrabEvents then return end
    
    -- Blizと同様に毎回GrabPartsを強制検索する (ChildAddedの不発を防ぎ、確実に動作させる)
    local grabbedModel = Workspace:FindFirstChild("GrabParts")
    local currentTarget = lastGrabbedPart

    if grabbedModel then
        local gp = grabbedModel:FindFirstChild("GrabPart")
        if gp then
            local wc = gp:FindFirstChildOfClass("WeldConstraint")
            if wc and wc.Part1 then
                currentTarget = wc.Part1
            end
        end
    end

    if currentTarget and currentTarget.Parent then
        if invisibleLineEnabled then
             pcall(function()
                 GrabEvents.CreateGrabLine:FireServer()
             end)
        end
    end
end)

-- 起動完了通知
OrionLib:MakeNotification({
	Name = "test Hub",
	Content = "スクリプトが正常に読み込まれました",
	Time = 5
})

OrionLib:Init()
