-- 各種サービスを取得
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local DebrisService = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

-- --- Line Extender (Further Extend) ---
local LineExtendSec = GrabTab:AddSection({ Name = "Line Extender (距離延長)" })

local senv = nil
local furtherExtendEnabled = false
local extendAmount = 3
local pcDistance = 0
local minDistance = 3

-- GrabbingScriptの環境を取得する関数 (blizのロジック参考)
local function hookGrabbingScript()
    local char = LocalPlayer.Character
    if char then
        local scriptObj = char:WaitForChild("GrabbingScript", 3)
        if scriptObj and getsenv then
            senv = getsenv(scriptObj)
        end
    end
end

LocalPlayer.CharacterAdded:Connect(hookGrabbingScript)
if LocalPlayer.Character then task.spawn(hookGrabbingScript) end

UIElements.FurtherExtendToggle = LineExtendSec:AddToggle({
    Name = "Further Extend",
    Default = false,
    Callback = function(v)
        furtherExtendEnabled = v
        if v and not senv then hookGrabbingScript() end
    end
})

UIElements.ExtendAmountSlider = LineExtendSec:AddSlider({
    Name = "Increase Amount",
    Min = 1,
    Max = 25,
    Default = 3,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Studs",
    Callback = function(v)
        extendAmount = v
    end
})

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if not furtherExtendEnabled then return end
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        if pcDistance < 11 then
            pcDistance = 11
        end
        if input.Position.Z <= 0 then
            if input.Position.Z < 0 then
                pcDistance = pcDistance - extendAmount
            end
        else
            pcDistance = pcDistance + extendAmount
        end
    end
end)

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

        -- Further Extend Logic (Bliz Copy)
        if furtherExtendEnabled then
            local dragPart = child:WaitForChild("DragPart", 5)
            if dragPart then
                -- Bliz Logic: DragPartを複製して制御する
                local dragPartClone = dragPart:Clone()
                dragPartClone.Name = "DragPart1"
                
                -- 複製したDragPartのAlignPosition設定 (自分自身のアタッチメントに向ける)
                local cloneAP = dragPartClone:FindFirstChild("AlignPosition")
                local cloneDA = dragPartClone:FindFirstChild("DragAttach")
                if cloneAP and cloneDA then
                    cloneAP.Attachment1 = cloneDA
                end
                
                dragPartClone.Parent = child -- モデル内に追加

                -- 初期距離
                pcDistance = (dragPartClone.Position - Camera.CFrame.Position).Magnitude

                -- オリジナルのDragPartのAlignPositionを無効化 (マウス追従を切る)
                local origAP = dragPart:FindFirstChild("AlignPosition")
                if origAP then origAP.Enabled = false end

                -- Cloneの位置を制御するループ
                task.spawn(function()
                    while child.Parent do
                        dragPartClone.Position = Camera.CFrame.Position + Camera.CFrame.LookVector * pcDistance
                        task.wait()
                    end
                    pcDistance = 0
                end)
            end
        end

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

-- 起動完了通知
OrionLib:MakeNotification({
	Name = "test Hub",
	Content = "スクリプトが正常に読み込まれました",
	Time = 5
})

OrionLib:Init()
