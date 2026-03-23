-- 各種サーを取得
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

-- [[ Bliz Line Extender & Mobile Support ]] --
-- 変数定義 (Bliz初期値準拠)
local IncreaseLineExtend = 3
local pcDistance = 0
local senv = nil
local minDistance = 3

-- GUI作成
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Name = "LineExtendGUI"
if LocalPlayer.PlayerGui:FindFirstChild("ContextActionGui") then
    gui.Parent = LocalPlayer.PlayerGui
end

local function IsMobile()
    if LocalPlayer.PlayerGui:FindFirstChild("ContextActionGui") then
        return true
    end
    return false
end

local imageButton = Instance.new("ImageButton")
imageButton.Size = UDim2.new(0, 45, 0, 45)
imageButton.Position = UDim2.new(1, -70, 1, -259)
imageButton.Image = "rbxassetid://97166444"
imageButton.BackgroundTransparency = 1
imageButton.ImageTransparency = 0.2
imageButton.Visible = false
imageButton.ImageColor3 = Color3.fromRGB(142, 142, 142)
imageButton.Parent = gui
local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(1, 0, 1, 0)
imageLabel.Image = "rbxassetid://9603831913"
imageLabel.BackgroundTransparency = 1
imageLabel.Parent = imageButton

local imageButtonDe = Instance.new("ImageButton")
imageButtonDe.Size = UDim2.new(0, 45, 0, 45)
imageButtonDe.Position = UDim2.new(1, -70, 1, -211)
imageButtonDe.Image = "rbxassetid://97166444"
imageButtonDe.BackgroundTransparency = 1
imageButtonDe.ImageTransparency = 0.2
imageButtonDe.Visible = false
imageButtonDe.ImageColor3 = Color3.fromRGB(142, 142, 142)
imageButtonDe.Parent = gui
local imageLabelDe = Instance.new("ImageLabel")
imageLabelDe.Size = UDim2.new(1, 0, 1, 0)
imageLabelDe.Image = "rbxassetid://9603826756"
imageLabelDe.BackgroundTransparency = 1
imageLabelDe.Parent = imageButtonDe

local function updateSenv()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local script = char:WaitForChild("GrabbingScript", 10)
    if script and getsenv then
        senv = getsenv(script)
    end
end
LocalPlayer.CharacterAdded:Connect(updateSenv)
task.spawn(updateSenv)

local function buttonClicked()
    if senv and (senv.distance and _G.FutherExtend) then
        senv.distance = (senv.distance or 0) + IncreaseLineExtend
        if senv.distance < minDistance then
            senv.distance = minDistance
        end
    end
end

local function buttonClickedDE()
    if senv and (senv.distance and _G.FutherExtend) then
        senv.distance = (senv.distance or 0) - IncreaseLineExtend
        if senv.distance < minDistance then
            senv.distance = minDistance
        end
    end
end

local buttonClickedFlag = false
local function runButtonLoop(func)
    while buttonClickedFlag do
        func()
        task.wait(0.1)
    end
end

imageButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        buttonClickedFlag = true
        task.spawn(function() runButtonLoop(buttonClicked) end)
    end
end)
imageButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        buttonClickedFlag = false
    end
end)

imageButtonDe.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        buttonClickedFlag = true
        task.spawn(function() runButtonLoop(buttonClickedDE) end)
    end
end)
imageButtonDe.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        buttonClickedFlag = false
    end
end)

-- PC用マウスホイール操作
UserInputService.InputChanged:Connect(function(inputObject)
    if inputObject.UserInputType == Enum.UserInputType.MouseWheel then
        if pcDistance < 11 then
            pcDistance = 11
        end
        if inputObject.Position.Z <= 0 then
            if inputObject.Position.Z < 0 then
                pcDistance = pcDistance - IncreaseLineExtend
            end
        else
            pcDistance = pcDistance + IncreaseLineExtend
        end
    end
end)

local function toggleButtonState(visible)
    if visible and _G.FutherExtend and IsMobile() then
        imageButton.Visible = true
        imageButton.Active = true
        imageButtonDe.Visible = true
        imageButtonDe.Active = true
    else
        imageButton.Visible = false
        imageButton.Active = false
        imageButtonDe.Visible = false
        imageButtonDe.Active = false
    end
end

local function toggleDefaultExtendButtons(visible)
    local CAG = LocalPlayer.PlayerGui:FindFirstChild("ContextActionGui")
    if CAG then
        for _, desc in pairs(CAG:GetDescendants()) do
            if desc:IsA("ImageLabel") and (desc.Image == "rbxassetid://9603826756" or desc.Image == "rbxassetid://9603831913") then
                desc.Parent.Visible = visible
            end
        end
    end
end

-- BlizのLine Extenderロジックを移植
Workspace.ChildAdded:Connect(function(child)
    if child.Name == "GrabParts" and child:IsA("Model") then
        -- PC用の処理
        if _G.FutherExtend and not IsMobile() then
            local grabPartModel = child
            local dragPart = grabPartModel:WaitForChild("DragPart", 2)
            if not dragPart then return end

            local dragPartClone = dragPart:Clone()
            dragPartClone.Name = "DragPart1"
            dragPartClone.AlignPosition.Attachment1 = dragPartClone.DragAttach
            dragPartClone.Parent = grabPartModel

            pcDistance = (dragPartClone.Position - Camera.CFrame.Position).Magnitude
            dragPartClone.AlignOrientation.Enabled = false
            dragPart.AlignPosition.Enabled = false

            task.spawn(function()
                while grabPartModel.Parent do
                    dragPartClone.Position = Camera.CFrame.Position + Camera.CFrame.LookVector * pcDistance
                    task.wait()
                end
                pcDistance = 0
            end)
        end

        -- モバイル用の処理
        if _G.FutherExtend and IsMobile() then
            toggleDefaultExtendButtons(false)
            toggleButtonState(true)
        end
    end
end)

-- [[ End Bliz Logic ]] --

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
    Name = "Test Hub",
    HidePremium = false,
    SaveConfig = false, -- 保存機能を無効化 (クラッシュ防止)
    ConfigFolder = "TestHub",
    IntroEnabled = true,
    IntroText = "ホロンハブ追加予定"
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

UIElements.RainbowLineToggle = GrabControlSec:AddToggle({
	Name = "Rainbow Line",
	Default = false,
	Callback = function(v)
		_G.RainbowLine = v
		if v then
			task.spawn(function()
				local hueOffset = 0
				local DataEvents = ReplicatedStorage:FindFirstChild("DataEvents")
				local UpdateLineColorsEvent = DataEvents and DataEvents:FindFirstChild("UpdateLineColorsEvent")

				while _G.RainbowLine do
					hueOffset = (hueOffset + 0.005) % 1
					if UpdateLineColorsEvent then
						local keypoints = {}
						for i = 0, 10 do
							table.insert(keypoints, ColorSequenceKeypoint.new(i / 10, Color3.fromHSV((i / 10 + hueOffset) % 1, 1, 1)))
						end
						local cs = ColorSequence.new(keypoints)
						pcall(function()
							UpdateLineColorsEvent:FireServer(cs, cs.Keypoints[1].Value, cs.Keypoints[2].Value, cs.Keypoints[3].Value, cs.Keypoints[4].Value, cs.Keypoints[5].Value, cs.Keypoints[6].Value, cs.Keypoints[7].Value, cs.Keypoints[8].Value, cs.Keypoints[9].Value)
						end)
					else
						local color = Color3.fromHSV(hueOffset, 1, 1)
						local grabParts = Workspace:FindFirstChild("GrabParts")
						if grabParts then
							for _, d in ipairs(grabParts:GetDescendants()) do
								if d:IsA("Beam") then
									d.Color = ColorSequence.new(color)
								end
							end
						end
					end
					RunService.Heartbeat:Wait()
				end
				if not _G.RainbowLine and UpdateLineColorsEvent then
					local white = Color3.new(1, 1, 1)
					pcall(function()
						UpdateLineColorsEvent:FireServer(white, white, white, white, white, white, white, white, white, white)
					end)
				end
			end)
		end
	end    
})

local FurtherExtendSec = GrabTab:AddSection({
    Name = "Line Extender"
})

FurtherExtendSec:AddToggle({
    Name = "Further Extend",
    Default = false,
    Callback = function(Value)
        _G.FutherExtend = Value
    end
})

FurtherExtendSec:AddSlider({
    Name = "Increase Extend Amount",
    Min = 1,
    Max = 25,
    Default = 3,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "Amount",
    Callback = function(value)
        IncreaseLineExtend = value
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

local AntiKick = DefenseTab:AddToggle({
    Name = "アンチキック",
    CurrentValue = false,
    Flag = "AntiKickToy",
    Callback = function(Value)
        _G.AntiKickToy = Value
        if not _G.AntiKickToy then return end

        task.spawn(function()
            local lastt = false
            while _G.AntiKickToy do
                pcall(function()
                    local char = LocalPlayer.Character
                    if not char then return end
                    
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChild("Humanoid")
                    local rightLeg = char:FindFirstChild("Right Leg")
                    
                    if not (hrp and hum and rightLeg) or hum.Health <= 0 then return end
                    
                    local inPlot = false
                    local inPlotVal = LocalPlayer:FindFirstChild("InPlot")
                    if inPlotVal and inPlotVal.Value then inPlot = true end
                    
                    if not inPlot then
                        local toysFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                        local shuriken = toysFolder and toysFolder:FindFirstChild("NinjaShuriken")
                        local destroyToy = ReplicatedStorage.MenuToys:FindFirstChild("DestroyToy")
                        
                        if shuriken then
                            local stickyPart = shuriken:FindFirstChild("StickyPart")
                            local stickyWeld = stickyPart and stickyPart:FindFirstChild("StickyWeld")
                            
                            local valid = false
                            if stickyWeld and stickyWeld.Part1 == rightLeg then valid = true end
                            
                            if not valid and destroyToy then
                                destroyToy:FireServer(shuriken)
                                task.wait(0.1)
                            end
                        else
                            local canSpawn = LocalPlayer:FindFirstChild("CanSpawnToy")
                            if canSpawn and canSpawn.Value then
                                if lastt then lastt = false; task.wait(0.5) end
                                
                                local spawnRemote = ReplicatedStorage.MenuToys:FindFirstChild("SpawnToyRemoteFunction")
                                if spawnRemote then
                                    local spawnCF = hrp.CFrame - Vector3.new(hrp.CFrame.LookVector.X * 20, -15, hrp.CFrame.LookVector.Z * 20)
                                    spawnRemote:InvokeServer("NinjaShuriken", spawnCF, Vector3.zero)
                                end
                                
                                local tStart = tick()
                                repeat task.wait() 
                                    toysFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                                    shuriken = toysFolder and toysFolder:FindFirstChild("NinjaShuriken")
                                until shuriken or tick() - tStart > 2
                                
                                if shuriken then
                                    local stickyPart = shuriken:WaitForChild("StickyPart", 1)
                                    if stickyPart then
                                        if GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner") then
                                            GrabEvents.SetNetworkOwner:FireServer(stickyPart, stickyPart.CFrame)
                                        end
                                        local stickyEvent = ReplicatedStorage.PlayerEvents:FindFirstChild("StickyPartEvent")
                                        if stickyEvent then
                                            stickyEvent:FireServer(stickyPart, rightLeg, CFrame.new(0.0490287527, 0.5, 0.00000000, -0.00000000, 0.00739139877, -0.999561906, -0.998452604, -0.0478846952, 0.0282763243, -0.0476547107, 0.99882561, 0.00000000000))
                                        end
                                    end
                                end
                            end
                        end
                    else
                        lastt = true
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

-- Anti-Kick Release (SprayCanWD) Logic from Iyan Hub
local function AntiKickReleaseLoop()
    while _G.AntiKickRelease do
        local success, err = pcall(function()
            local mt = ReplicatedStorage:FindFirstChild("MenuToys")
            local spawnRemote = mt and mt:FindFirstChild("SpawnToyRemoteFunction")
            local destroyRemote = mt and mt:FindFirstChild("DestroyToy")
            local toysName = LocalPlayer.Name .. "SpawnedInToys"
            local toysFolder = Workspace:FindFirstChild(toysName)

            -- 既存のSprayCanがあれば削除
            if toysFolder and toysFolder:FindFirstChild("SprayCanWD") and destroyRemote then
                destroyRemote:FireServer(toysFolder.SprayCanWD)
                task.wait(0.5)
            end

            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot or not spawnRemote then return end

            -- SprayCanをスポーン
            spawnRemote:InvokeServer("SprayCanWD", myRoot.CFrame, Vector3.zero)
            
            local sprayCan = nil
            local tStart = tick()
            repeat
                toysFolder = Workspace:FindFirstChild(toysName)
                if toysFolder then sprayCan = toysFolder:FindFirstChild("SprayCanWD") end
                task.wait()
            until sprayCan or tick() - tStart > 2

            if sprayCan then
                local stickyPart = nil
                for _, part in ipairs(sprayCan:GetChildren()) do
                    if part.Name == "StickyRemoverPart" then
                        part.Size = Vector3.new(10, 10, 10)
                        stickyPart = part
                        break
                    end
                end

                if stickyPart then
                    if GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner") then
                        GrabEvents.SetNetworkOwner:FireServer(stickyPart, stickyPart.CFrame)
                    end
                    
                    local mainPart = sprayCan:FindFirstChild("Main")
                    if mainPart then
                        local bp = Instance.new("BodyPosition", mainPart)
                        bp.P = 20000
                        bp.Position = Vector3.new(0, 600, 0) -- 本体を上空へ待機
                    end

                    while _G.AntiKickRelease and sprayCan.Parent do
                        for _, player in ipairs(Players:GetPlayers()) do
                            if not _G.AntiKickRelease then break end
                            if player ~= LocalPlayer and player.Character then
                                local target = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Head")
                                if target then
                                    stickyPart.Position = target.Position
                                    task.wait(0.01)
                                end
                            end
                        end
                        task.wait(0.01)
                    end
                end
            end
        end)
        if not success then task.wait(1) end
        task.wait()
    end
    
    -- 終了時のクリーンアップ
    local mt = ReplicatedStorage:FindFirstChild("MenuToys")
    local destroyRemote = mt and mt:FindFirstChild("DestroyToy")
    local toysFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
    if toysFolder and toysFolder:FindFirstChild("SprayCanWD") and destroyRemote then
        destroyRemote:FireServer(toysFolder.SprayCanWD)
    end
end

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

local Tab = Window:MakeTab({
    Name = "メインタブ",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local FriendTab = Window:MakeTab({
    Name = "ホワイトフレンド",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local grabbedPlayers = {}
local currentBlob = nil
local whiteFriends = {}

local function IsWhiteFriend(player)
    if _G.ProtectRealFriends then
        return player:IsFriendsWith(LocalPlayer.UserId)
    end
    return whiteFriends[player] == true or whiteFriends[player.Name] == true
end

local function GetPlayersInPlots()
    local plotPlayers = {}
    local plotItems = workspace:FindFirstChild("PlotItems")
    
    if plotItems then
        local playersInPlots = plotItems:FindFirstChild("PlayersInPlots")
        if playersInPlots then
            for _, v in ipairs(playersInPlots:GetChildren()) do
                local player = Players:FindFirstChild(v.Name)
                if player then
                    plotPlayers[player] = true
                end
            end
        end
    end
    
    return plotPlayers
end

local function IsPlayerProtected(player)
    if IsWhiteFriend(player) then
        return true
    end
    
    local plotItems = workspace:FindFirstChild("PlotItems")
    if plotItems then
        local playersInPlots = plotItems:FindFirstChild("PlayersInPlots")
        if playersInPlots then
            for _, v in ipairs(playersInPlots:GetChildren()) do
                if v.Name == player.Name then
                    return true
                end
            end
        end
    end
    
    return false
end

local function SetNetworkOwner(part)
    if not part then return end
    pcall(function()
        ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(part, LocalPlayer.Character.HumanoidRootPart.CFrame)
    end)
end

local function GetMyToyFolder()
    return workspace[LocalPlayer.Name .. "SpawnedInToys"]
end

local function GetMyRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function AnchorBlobman(blob, state)
    if not blob then return end
    for _, v in ipairs(blob:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Anchored = state
        end
    end
end

local function GrabPlayer(blob, targetPlayer)
    if not blob or not targetPlayer or not targetPlayer.Character then return end
    
    if IsPlayerProtected(targetPlayer) then
        return
    end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    local leftDetector = blob:FindFirstChild("LeftDetector")
    if not leftDetector then return end
    
    local leftWeld = leftDetector:FindFirstChild("LeftWeld")
    if not leftWeld then return end
    
    local script = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
    if not script then return end
    
    local grabEvent = script:FindFirstChild("CreatureGrab")
    if not grabEvent then return end
    
    pcall(function()
        grabEvent:FireServer(leftDetector, targetRoot, leftWeld)
    end)
end

local function Grab3Times(blob, targetPlayer)
    if not blob or not targetPlayer or not targetPlayer.Character then return false end
    
    if IsPlayerProtected(targetPlayer) then
        return false
    end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return false end
    
    for i = 1, 50 do
        SetNetworkOwner(targetRoot)
    end
    
    local leftDetector = blob:FindFirstChild("LeftDetector")
    if not leftDetector then return end
    
    local leftWeld = leftDetector:FindFirstChild("LeftWeld")
    if not leftWeld then return end
    
    local rightDetector = blob:FindFirstChild("RightDetector")
    if not rightDetector then return end
    
    local rightWeld = rightDetector:FindFirstChild("RightWeld")
    if not rightWeld then return end
    
    local script = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
    if not script then return end
    
    local grabEvent = script:FindFirstChild("CreatureGrab")
    if not grabEvent then return end
    
    local dropEvent = script:FindFirstChild("CreatureDrop")
    if not dropEvent then return end
    
    local releaseEvent = script:FindFirstChild("CreatureRelease")
    if not releaseEvent then return end
    
    local myRoot = GetMyRoot()
    if not myRoot then return end
    
    local rootAttachment = myRoot:FindFirstChild("RootAttachment")
    if not rootAttachment then return end
    
    for i = 1, 3 do
        pcall(function()
            grabEvent:FireServer(leftDetector, targetRoot, leftWeld)
            dropEvent:FireServer(leftWeld, rootAttachment)
            releaseEvent:FireServer(rightWeld)
        end)
    end
    
    grabbedPlayers[targetPlayer] = true
    return true
end

local function TeleportAllToCircleInstant(center, radius)
    local players = {}
    local count = 0
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not IsPlayerProtected(player) and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                table.insert(players, {
                    player = player,
                    root = targetRoot
                })
            end
        end
    end
    
    local angleStep = (2 * math.pi) / #players
    for i, data in ipairs(players) do
        local angle = (i - 1) * angleStep
        local x = center.X + radius * math.cos(angle)
        local z = center.Z + radius * math.sin(angle)
        
        for j = 1, 50 do
            SetNetworkOwner(data.root)
        end
        
        data.root.CFrame = CFrame.new(x, center.Y, z)
        count = count + 1
    end
    
    return count
end

local function MassGrab20(blob)
    for grabCount = 1, 10 do
        for player, _ in pairs(grabbedPlayers) do
            if player and player.Character and not IsPlayerProtected(player) then
                GrabPlayer(blob, player)
            end
        end
        task.wait(0.01)
    end
    
    task.wait(0.02)
    
    for grabCount = 1, 10 do
        for player, _ in pairs(grabbedPlayers) do
            if player and player.Character and not IsPlayerProtected(player) then
                GrabPlayer(blob, player)
            end
        end
        task.wait(0.01)
    end
    
    return #grabbedPlayers
end

FriendTab:AddToggle({
    Name = "Robloxフレンド保護 (Real Friends)",
    Default = false,
    Callback = function(v)
        _G.ProtectRealFriends = v
    end
})

Tab:AddButton({
    Name = "キックオール",
    Callback = function()
        grabbedPlayers = {}
        currentBlob = nil
        local totalPlayers = 0
        
        local protectedCount = 0
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsPlayerProtected(player) then
                protectedCount = protectedCount + 1
            end
        end

        
        local character = LocalPlayer.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local spawnPos = rootPart.CFrame * CFrame.new(0, 0, -5)
                ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(table.unpack({
                    [1] = "CreatureBlobman",
                    [2] = spawnPos,
                    [3] = Vector3.new(0, 127, 0),
                }))
            end
        end
        task.wait(0.5)
        
        local folder = GetMyToyFolder()
        currentBlob = folder and folder:FindFirstChild("CreatureBlobman")
        
        if currentBlob then
            local vehicleSeat = currentBlob:FindFirstChild("VehicleSeat")
            if vehicleSeat then
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    vehicleSeat:Sit(humanoid)
                end
            end
        end
        task.wait(0.3)
        
        local myRoot = GetMyRoot()
        if myRoot and currentBlob then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and not IsPlayerProtected(player) and player.Character then
                    totalPlayers = totalPlayers + 1
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        myRoot.CFrame = targetRoot.CFrame
                        task.wait(0.15)
                        Grab3Times(currentBlob, player)
                    end
                end
            end
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not IsPlayerProtected(player) and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    for i = 1, 50 do
                        SetNetworkOwner(targetRoot)
                    end
                end
            end
        end
        
        if myRoot then
            myRoot.CFrame = CFrame.new(0, 70, 0)
            task.wait(0.2)
        end
        
        if currentBlob then
            AnchorBlobman(currentBlob, true)
        end
        
        local center = Vector3.new(0, 70, 0)
        local teleportedCount = TeleportAllToCircleInstant(center, 15)
        
        local grabbedCount = MassGrab20(currentBlob)
        
        task.wait(0.5)
        if currentBlob then
            AnchorBlobman(currentBlob, false)
        end
        
        OrionLib:MakeNotification({
            Name = "完了",
            Content = string.format("対象: %d人\n保護対象: %d人\nGrab20回完了", teleportedCount, protectedCount),
            Image = "rbxassetid://4483345998",
            Time = 4
        })
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

-- Loop Kill Helpers (Comic Logic)
local function nocoll(model)
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end

local function fling(root, hum)
    nocoll(hum.Parent)
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, 1000000000, 0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = root
    
    hum.Sit = false
    hum.Jump = true
    
    DebrisService:AddItem(bv, 3)
end

LoopKillSec:AddToggle({
    Name = "Loop Kill",
    Default = false,
    Callback = function(v)
        loopKillEnabled = v
        if v then
            task.spawn(function()
                local myChar = LocalPlayer.Character
                local savedPivot = myChar and myChar:GetPivot()

                while loopKillEnabled do
                  RunService.Heartbeat:Wait()
                  if not myChar or not myChar.Parent then
                      myChar = LocalPlayer.Character
                      if myChar then savedPivot = myChar:GetPivot() end
                  end

                  if loopKillTargetName ~= "" and myChar and myChar:FindFirstChild("HumanoidRootPart") then
                      local target = Players:FindFirstChild(loopKillTargetName)
                      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                          local dist = (myChar.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                          -- ターゲットから十分離れている場合のみ位置を更新（移動可能にする）
                          if dist > 20 then
                              savedPivot = myChar:GetPivot()
                          end
                      end
                  end

                  task.spawn(function()
                    if loopKillTargetName ~= "" then
                        local target = Players:FindFirstChild(loopKillTargetName)
                        
                        -- Check if in plot (Comic logic)
                        local inPlot = false
                        if Workspace:FindFirstChild("PlotItems") and Workspace.PlotItems:FindFirstChild("PlayersInPlots") then
                            if Workspace.PlotItems.PlayersInPlots:FindFirstChild(target.Name) then
                                inPlot = true
                            end
                        end

                        if target and target ~= LocalPlayer and target.Character and not inPlot then
                            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                            local targetHum = target.Character:FindFirstChild("Humanoid")
                            local targetHead = target.Character:FindFirstChild("Head")
                            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

                            if targetRoot and targetHum and targetHead and targetHum.Health > 0 and myRoot then
                                pcall(function()
                                    
                                    -- tp to target + offset (Comic Hub: 5, -18.5, 0)
                                    local offset = Vector3.new(5, -18.5, 0)
                                    myChar:PivotTo(CFrame.new(targetRoot.Position + offset))
                                    
                                    -- nocoll target
                                    nocoll(target.Character)
                                    
                                    -- SetNetworkOwner
                                    if GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner") then
                                        GrabEvents.SetNetworkOwner:FireServer(targetRoot, targetRoot.CFrame)
                                    end
                                    
                                    task.wait()
                                    
                                    -- ret (return to saved pos if far enough)
                                    if myRoot and savedPivot and (myRoot.Position - savedPivot.Position).Magnitude > 2 then
                                        myChar:PivotTo(savedPivot)
                                    end

                                    task.wait(0.1)
                                    
                                    -- DestroyGrabLine
                                    if GrabEvents and GrabEvents:FindFirstChild("DestroyGrabLine") then
                                        GrabEvents.DestroyGrabLine:FireServer(targetRoot)
                                    end

                                    task.wait(0.1)
                                    
                                    -- Kill if owned
                                    if targetHead:FindFirstChild("PartOwner") and targetHead.PartOwner.Value == LocalPlayer.Name then
                                        fling(targetRoot, targetHum)
                                        task.wait(0.1)
                                        targetHum.Health = 0
                                    end
                                end)
                            end
                        end
                    end
                  end)
                end
            end)
        end
    end,
    Save = true,
    Flag = "lk_toggle"
})
                            
-- --- キーボードタブ (Bliz Keybinds) ---
local keyboardTargetName = ""

-- 1. Teleport Section
local TeleportSec = KeyboardTab:AddSection({ Name = "Teleport" })

local function PerformTeleport()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local targetPos
    if IsMobile() then
        local cam = Workspace.CurrentCamera
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {char}
        params.FilterType = Enum.RaycastFilterType.Exclude
        local ray = Workspace:Raycast(cam.CFrame.Position, cam.CFrame.LookVector * 1000, params)
        targetPos = ray and ray.Position or (cam.CFrame.Position + cam.CFrame.LookVector * 50)
    else
        local mouse = LocalPlayer:GetMouse()
        if mouse and mouse.Hit then
            targetPos = mouse.Hit.Position
        end
    end

    if targetPos then
        char.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
    end
end

local function onTeleportAction(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        PerformTeleport()
    end
end

-- Mobile Teleport Button (Bliz Style)
local TeleportBtn = Instance.new("ImageButton")
TeleportBtn.Name = "TeleportButton"
TeleportBtn.Size = UDim2.new(0, 70, 0, 70)
TeleportBtn.Position = UDim2.new(1, - 267, 1, - 90)
TeleportBtn.Image = "rbxassetid://97166444"
TeleportBtn.ImageColor3 = Color3.fromRGB(142, 142, 142)
TeleportBtn.BackgroundTransparency = 1
TeleportBtn.ImageTransparency = 0.2
TeleportBtn.Visible = false
TeleportBtn.Parent = gui

TeleportBtn.MouseButton1Down:Connect(function()
    TeleportBtn.ImageTransparency = 0
end)

TeleportBtn.MouseButton1Up:Connect(function()
    TeleportBtn.ImageTransparency = 0.2
end)

local TeleportIcon = Instance.new("ImageLabel")
TeleportIcon.Size = UDim2.new(0.7, 0, 0.7, 0)
TeleportIcon.Position = UDim2.new(0.15, 0, 0.15, 0)
TeleportIcon.BackgroundTransparency = 1
TeleportIcon.Image = "rbxassetid://10650996837" -- Teleport Icon
TeleportIcon.Parent = TeleportBtn

TeleportBtn.MouseButton1Click:Connect(PerformTeleport)


TeleportSec:AddToggle({
    Name = "Teleport (Z)",
    Default = false,
    Callback = function(v)
        if v then
            ContextActionService:BindAction("TeleportZ", onTeleportAction, false, Enum.KeyCode.Z)
            if IsMobile() then TeleportBtn.Visible = true end
        else
            ContextActionService:UnbindAction("TeleportZ")
            TeleportBtn.Visible = false
        end
    end
})





-- 2. Anchor Objects Section
local AnchorSec = KeyboardTab:AddSection({ Name = "Anchor Objects" })

local AnchoredObjects = {}

local function PerformAnchor()
        local targetToProcess = nil
        local partToDrop = nil
        local grabPartsFolder = Workspace:FindFirstChild("GrabParts")

        -- 1. 掴んでいるオブジェクトがある場合 (Bliz仕様: 新規固定は掴んでいる時のみ)
        if grabPartsFolder and grabPartsFolder:FindFirstChild("GrabPart") and grabPartsFolder.GrabPart:FindFirstChild("WeldConstraint") then
            local grabbedPart = grabPartsFolder.GrabPart.WeldConstraint.Part1
            if grabbedPart then
                -- マップの一部やロックされたパーツは除外
                local map = Workspace:FindFirstChild("Map")
                if not (grabbedPart.Locked or (map and grabbedPart:IsDescendantOf(map))) then
                     local model = grabbedPart:FindFirstAncestorOfClass("Model")
                     targetToProcess = model or grabbedPart
                     partToDrop = grabbedPart
                end
            end
        elseif LocalPlayer.Character then
            -- 2. 掴んでいない場合: 既にこのスクリプトでアンカーされた("IsAnchored"属性がある)オブジェクトのみ操作可能
            local target
            if IsMobile() then
                local cam = Workspace.CurrentCamera
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {LocalPlayer.Character}
                params.FilterType = Enum.RaycastFilterType.Exclude
                local ray = Workspace:Raycast(cam.CFrame.Position, cam.CFrame.LookVector * 1000, params)
                if ray then target = ray.Instance end
            else
                local mouse = LocalPlayer:GetMouse()
                target = mouse.Target
            end

            if target then
                local model = target:FindFirstAncestorOfClass("Model")
                local checkObj = model or target
                -- Bliz仕様: IsAnchored属性を持っている場合のみ反応 (解除など)
                if checkObj:GetAttribute("IsAnchored") then
                    targetToProcess = checkObj
                end
            end
        end

        if targetToProcess then
            -- トグル処理 (属性IsAnchoredを基準にする)
            local currentAnchorState = targetToProcess:GetAttribute("IsAnchored")
            local newAnchorState = not currentAnchorState
            
            -- 属性を更新
            targetToProcess:SetAttribute("IsAnchored", newAnchorState)

            -- メインパーツ特定 (BodyMover用)
            local mainPart = targetToProcess
            if targetToProcess:IsA("Model") then
                mainPart = targetToProcess.PrimaryPart or targetToProcess:FindFirstChildWhichIsA("BasePart", true)
            end

            -- Network Ownership Request (Bliz Logic: Ensure control before anchoring)
            if mainPart and GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner") and not partToDrop then
                task.spawn(function()
                    pcall(function() GrabEvents.SetNetworkOwner:FireServer(mainPart, mainPart.CFrame) end)
                end)
            end

            OrionLib:MakeNotification({
                Name = "Anchor",
                Content = (newAnchorState and "[Anchored] " or "[Unanchored] ") .. targetToProcess.Name,
                Time = 1
            })
            -- エフェクト用 (Bliz参考)
            local highlightName = "BlizAnchor"

            local existing = targetToProcess:FindFirstChild(highlightName)
            if existing then existing:Destroy() end

            if newAnchorState and mainPart then
                -- 固定時: BodyMoversで固定 (Fake Anchor - Bliz仕様)
                local connections = {}
                
                -- PartOwnerの監視関数
                local function setupOwnerListener(po)
                    if not po then return end
                    if po.Value ~= LocalPlayer.Name then
                        targetToProcess:SetAttribute("AnchorOwnership", nil)
                    end
                    local conn = po:GetPropertyChangedSignal("Value"):Connect(function()
                        if po.Value ~= LocalPlayer.Name then
                            targetToProcess:SetAttribute("AnchorOwnership", nil)
                        end
                    end)
                    table.insert(connections, conn)
                end
                
                connections[#connections+1] = targetToProcess.DescendantAdded:Connect(function(desc)
                    if desc.Name == "PartOwner" then setupOwnerListener(desc) end
                end)
                connections[#connections+1] = targetToProcess.DescendantRemoving:Connect(function(descendant)
                    if descendant.Name == "PartOwner" then
                        targetToProcess:SetAttribute("AnchorOwnership", nil)
                    end
                end)
                
                -- 既存のPartOwnerに対しても監視を設定（ここが重要）
                for _, desc in ipairs(targetToProcess:GetDescendants()) do
                    if desc.Name == "PartOwner" then
                        setupOwnerListener(desc)
                    end
                end
                
                AnchoredObjects[targetToProcess] = {Part = mainPart, Connections = connections}
                
                -- Bliz仕様: BodyPosition (重力落下防止)
                local bp = mainPart:FindFirstChild("BlizAnchorBP") or Instance.new("BodyPosition")
                bp.Name = "BlizAnchorBP"
                bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bp.P = 40000
                bp.D = 950 -- Blizの値に合わせる
                bp.Position = mainPart.Position
                bp.Parent = mainPart

                local bg = mainPart:FindFirstChild("BlizAnchorBG") or Instance.new("BodyGyro")
                bg.Name = "BlizAnchorBG"
                bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bg.P = 40000
                bg.D = 950
                bg.CFrame = mainPart.CFrame
                bg.Parent = mainPart

                local sb = mainPart:FindFirstChild(highlightName) or Instance.new("SelectionBox")
                sb.Name = highlightName
                sb.Adornee = targetToProcess
                sb.Parent = targetToProcess
                sb.Color3 = Color3.fromRGB(0, 255, 255) -- Cyan
                sb.LineThickness = 0.05

                -- Bliz仕様: 位置を微調整し続けて物理演算を維持する (Jitter Loop)
                task.spawn(function()
                    local initialPos = mainPart.Position
                    while targetToProcess:GetAttribute("IsAnchored") and bp.Parent do
                        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                        
                        bp.Position = initialPos + Vector3.new(0, 0.001, 0)
                        task.wait()
                        bp.Position = initialPos
                    end
                end)

            elseif mainPart then
                -- 解除時: BodyMoversを削除
                local data = AnchoredObjects[targetToProcess]
                if data and data.Connections then
                    for _, conn in ipairs(data.Connections) do
                        conn:Disconnect()
                    end
                end
                AnchoredObjects[targetToProcess] = nil
                local bp = mainPart:FindFirstChild("BlizAnchorBP")
                if bp then bp:Destroy() end
                local bg = mainPart:FindFirstChild("BlizAnchorBG")
                if bg then bg:Destroy() end

                local sb = Instance.new("SelectionBox")
                sb.Adornee = targetToProcess
                sb.Parent = targetToProcess
                sb.Color3 = Color3.fromRGB(255, 0, 0) -- Red
                sb.LineThickness = 0.05
                DebrisService:AddItem(sb, 0.5)
            end
        end
end

local function onAnchorAction(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        PerformAnchor()
    end
end

-- Mobile Anchor Button (Bliz Style)
local AnchorBtn = Instance.new("ImageButton")
AnchorBtn.Name = "AnchorButton"
AnchorBtn.Size = UDim2.new(0, 60, 0, 60)
AnchorBtn.Position = UDim2.new(1, - 320, 1, - 80)
AnchorBtn.Image = "rbxassetid://97166444"
AnchorBtn.ImageColor3 = Color3.fromRGB(142, 142, 142)
AnchorBtn.BackgroundTransparency = 1
AnchorBtn.ImageTransparency = 0.2
AnchorBtn.Visible = false
AnchorBtn.Parent = gui

AnchorBtn.MouseButton1Down:Connect(function()
    AnchorBtn.ImageTransparency = 0
end)

AnchorBtn.MouseButton1Up:Connect(function()
    AnchorBtn.ImageTransparency = 0.2
end)



local AnchorIcon = Instance.new("ImageLabel")
AnchorIcon.Size = UDim2.new(0.55, 0, 0.55, 0)
AnchorIcon.Position = UDim2.new(0.225, 0, 0.225, 0)
AnchorIcon.BackgroundTransparency = 1
AnchorIcon.Image = "rbxassetid://357069505" -- Anchor Icon
AnchorIcon.Parent = AnchorBtn
AnchorBtn.MouseButton1Click:Connect(PerformAnchor)


AnchorSec:AddToggle({
    Name = "Anchor (K)",
    Default = false,
    Callback = function(v)
        if v then
            ContextActionService:BindAction("AnchorK", onAnchorAction, false, Enum.KeyCode.K)
            if IsMobile() then AnchorBtn.Visible = true end
        else
            ContextActionService:UnbindAction("AnchorK")
            AnchorBtn.Visible = false
        end
    end
})

-- --- Silent Aim Tab (Ported from Comic Hub) ---
local SilentAimTab = Window:MakeTab({
	Name = "Silent Aim",
	Icon = "rbxassetid://6031091005"
})

local ConfigContainer = {
    SA = {
        En = false, 
        Key = "RightAlt", 
        TP = "HumanoidRootPart", 
        Show = false, 
        MHP = false, 
        AP = true, 
        MHP_A = 0.165, 
        HC = 100, 
        Col = Color3.fromRGB(54, 57, 241)
    }, 
    Cam = Workspace.CurrentCamera, 
    P = game:GetService("Players"), 
    RS = game:GetService("RunService"), 
    GS = game:GetService("GuiService"), 
    UIS = game:GetService("UserInputService"), 
    ST = game:GetService("Stats"), 
    LP = game:GetService("Players").LocalPlayer, 
    MC = nil, 
    MB = nil, 
    M = nil, 
    MBX = nil, 
    VTP = {
        "Head", 
        "HumanoidRootPart"
    }, 
    CPA = 0.165, 
    EA = {
        Raycast = {
            AC = 3, 
            Args = {
                "Instance", 
                "Vector3", 
                "Vector3", 
                "RaycastParams"
            }
        }
    }, 
    CoR = coroutine.resume, 
    CoC = coroutine.create
}

if getgenv then
    getgenv().SilentAimSettings = ConfigContainer.SA
end

ConfigContainer.M = ConfigContainer.LP:GetMouse()
local DrawingObject = pcall(function() return Drawing.new("Square") end)

if DrawingObject then
    ConfigContainer.MBX = Drawing.new("Square")
    ConfigContainer.MBX.Visible = false
    ConfigContainer.MBX.ZIndex = 999
    ConfigContainer.MBX.Color = ConfigContainer.SA.Col
    ConfigContainer.MBX.Thickness = 2
    ConfigContainer.MBX.Size = Vector2.new(30, 30)
    ConfigContainer.MBX.Filled = true
else
    ConfigContainer.MBX = {
        Visible = false, 
        Position = Vector2.new(), 
        Color = ConfigContainer.SA.Col
    }
    ConfigContainer.SA.Show = false
end

ConfigContainer.MC = ConfigContainer.UIS.TouchEnabled and not ConfigContainer.UIS.KeyboardEnabled

local function Ch(Param5)
    Param5 = math.floor(Param5)
    return math.floor(math.random() * 100) / 100 <= Param5 / 100
end

local function GPx(Object1)
    local ScreenPoint1, ScreenPoint2 = ConfigContainer.Cam:WorldToScreenPoint(Object1)
    return Vector2.new(ScreenPoint1.X, ScreenPoint1.Y), ScreenPoint2
end

local function VA(Param6, Param7)
    local DefaultValue = 0
    if #Param6 < Param7.AC then
        return false
    else
        for LoopVariable1, LoopVariable2 in next, Param6 do
            if typeof(LoopVariable2) == Param7.Args[LoopVariable1] then
                DefaultValue = DefaultValue + 1
            end
        end
        return Param7.AC <= DefaultValue
    end
end

local function GD(Param8, Param9)
    return (Param9 - Param8).Unit * 1000
end

local function GMP()
    return ConfigContainer.UIS:GetMouseLocation()
end

local function GPP(VelocityObject)
    local DefaultVelocity = VelocityObject.Velocity or Vector3.new()
    return VelocityObject.Position + (ConfigContainer.SA.MHP and DefaultVelocity * ConfigContainer.CPA or Vector3.new())
end

local function GCP()
    if not ConfigContainer.SA.TP then return end
    
    local BestTarget = nil
    local ClosestDist = math.huge
    local MyRoot = ConfigContainer.LP.Character and ConfigContainer.LP.Character:FindFirstChild("HumanoidRootPart")
    if not MyRoot then return nil end
    local MyPos = MyRoot.Position

    for _, LoopCharacter in next, ConfigContainer.P:GetPlayers() do
        if LoopCharacter ~= ConfigContainer.LP then
            local TargetCharacter = LoopCharacter.Character
            if TargetCharacter then
                local HumanoidRootPart = TargetCharacter:FindFirstChild("HumanoidRootPart")
                local Humanoid = TargetCharacter:FindFirstChild("Humanoid")
                if HumanoidRootPart and Humanoid and Humanoid.Health > 0 then
                    local Dist = (MyPos - HumanoidRootPart.Position).Magnitude
                    if Dist < ClosestDist then
                        ClosestDist = Dist
                        BestTarget = ConfigContainer.SA.TP == "Random" and TargetCharacter[ConfigContainer.VTP[math.random(1, #ConfigContainer.VTP)]] or TargetCharacter[ConfigContainer.SA.TP]
                    end
                end
            end
        end
    end
    return BestTarget
end

SilentAimTab:AddToggle({Name = "Enabled (有効化)", Default = ConfigContainer.SA.En, Callback = function(v) ConfigContainer.SA.En = v end})

ConfigContainer.RS.Heartbeat:Connect(function()
    if ConfigContainer.SA.AP then
        local StatusResult, ActionResult = pcall(function()
            return ConfigContainer.ST.Network.ServerStatsItem["Data Ping"]:GetValueString()
        end)
        if StatusResult then
            local ActionResultValue = tonumber(ActionResult:match("(%d+)")) or 50
            if ActionResultValue < 20 then ConfigContainer.CPA = 0.11
            elseif ActionResultValue < 30 then ConfigContainer.CPA = 0.115
            elseif ActionResultValue < 40 then ConfigContainer.CPA = 0.12
            elseif ActionResultValue < 50 then ConfigContainer.CPA = 0.125
            elseif ActionResultValue < 60 then ConfigContainer.CPA = 0.13
            elseif ActionResultValue < 70 then ConfigContainer.CPA = 0.135
            elseif ActionResultValue < 80 then ConfigContainer.CPA = 0.14
            elseif ActionResultValue < 90 then ConfigContainer.CPA = 0.145
            elseif ActionResultValue < 100 then ConfigContainer.CPA = 0.15
            elseif ActionResultValue < 110 then ConfigContainer.CPA = 0.155
            else ConfigContainer.CPA = 0.16 end
        end
    else
        ConfigContainer.CPA = ConfigContainer.SA.MHP_A
    end
end)

ConfigContainer.RS.RenderStepped:Connect(function()
    if ConfigContainer.SA.Show and ConfigContainer.SA.En and DrawingObject then
        local target = GCP()
        if target then
            local PrimaryPart = target.Parent.PrimaryPart or target
            local ViewportPoint1, ViewportPoint2 = ConfigContainer.Cam:WorldToViewportPoint(PrimaryPart.Position)
            ConfigContainer.MBX.Visible = ViewportPoint2
            ConfigContainer.MBX.Position = Vector2.new(ViewportPoint1.X, ViewportPoint1.Y)
        else
            ConfigContainer.MBX.Visible = false
            ConfigContainer.MBX.Position = Vector2.new()
        end
    end
end)

local CheckCallerFunc = checkcaller or function() return false end
local NewCcClosureFunc = newcclosure or function(Param18) return Param18 end
local oldNC

if hookmetamethod then
    pcall(function()
        oldNC = hookmetamethod(game, "__namecall", NewCcClosureFunc(function(...)
            local args = {...}
            local self = args[1]
            if ConfigContainer.SA.En and self == Workspace and not CheckCallerFunc() and Ch(ConfigContainer.SA.HC) and getnamecallmethod() == "Raycast" and VA(args, ConfigContainer.EA.Raycast) then
                local targetPart = GCP()
                if targetPart then
                    args[3] = GD(args[2], GPP(targetPart))
                    return oldNC(unpack(args))
                end
            end
            return oldNC(...)
        end))
    end)
end

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
        toggleButtonState(false)
        toggleDefaultExtendButtons(true)
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

-- 当たり判定を保存・復元するためのグローバルなテーブルと関数
local originalCollisions = {}

local function saveCollisions(character, key)
    originalCollisions[key] = {}
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            originalCollisions[key][part] = part.CanCollide
        end
    end
end

local function restoreCollisions(key)
    if not originalCollisions[key] then return end
    for part, canCollide in pairs(originalCollisions[key]) do
        if part and part.Parent then
            pcall(function() part.CanCollide = canCollide end)
        end
    end
    originalCollisions[key] = nil
end

-- Bring All Logic (Ported from Comic Hub)
local BringAllSec = ActionTab:AddSection({ Name = "Bring All" })

-- Bring All Logic (Ported from Comic Hub & Inspired by Bliz)
local BringAllConfig = {
    Enabled = false,
    Position = nil,
    Radius = 15,
    Whitelist = false,
    BringPlot = false,
    CameraPart = nil,
    ActiveMovers = {},
    MainLoop = nil,
    HiddenCFrame = CFrame.new(527, 123, -376) -- Bliz's hiding spot
}

-- フレンド判定のキャッシュ（IsFriendsWithの遅延・エラー対策）
local FriendCache = {}
task.spawn(function()
    while true do
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                FriendCache[player.UserId] = LocalPlayer:IsFriendsWith(player.UserId)
            end
        end
        task.wait(10)
    end
end)

local function InPlot(player)
    local plotItems = Workspace:FindFirstChild("PlotItems")
    local playersInPlots = plotItems and plotItems:FindFirstChild("PlayersInPlots")
    local inPlotValue = player:FindFirstChild("InPlot")
    return (playersInPlots and playersInPlots:FindFirstChild(player.Name)) or (inPlotValue and inPlotValue.Value)
end

local function InRad(part)
    if not BringAllConfig.Position then return false end
    return (part.Position - BringAllConfig.Position).Magnitude <= BringAllConfig.Radius
end

local function Ignore(player)
    if player == LocalPlayer then return true end
    local isFriend = FriendCache[player.UserId]
    if isFriend == nil then isFriend = LocalPlayer:IsFriendsWith(player.UserId) end
    if BringAllConfig.Whitelist and isFriend then return true end
    return false
end

-- Bliz-inspired helper functions
local function GetPlayerVelocity(player)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        return player.Character.AssemblyLinearVelocity.Magnitude
    end
    return 0
end

local function CreateBringMover(targetRoot, destinationPosition)
    local existingMover = targetRoot:FindFirstChild("BringAllMover")
    if existingMover and existingMover:IsA("BodyPosition") then
        existingMover.Position = destinationPosition
        return
    end

    if existingMover then existingMover:Destroy() end

    local bringMover = Instance.new("BodyPosition")
    bringMover.Name = "BringAllMover"
    bringMover.Position = destinationPosition
    bringMover.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bringMover.D = 5000
    bringMover.P = 1500000
    bringMover.Parent = targetRoot

    table.insert(BringAllConfig.ActiveMovers, bringMover)
end

-- The main loop function
local function BringAllLoop()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    while BringAllConfig.Enabled do
        local playersToBring = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if not Ignore(player) and player.Character and (BringAllConfig.BringPlot or not InPlot(player)) then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                local isRagdolled = hum and hum:FindFirstChild("Ragdolled")
                if root and not InRad(root) and not (isRagdolled and isRagdolled.Value) then
                    table.insert(playersToBring, player)
                end
            end
        end

        if #playersToBring == 0 then
            task.wait(1) -- No one to bring, wait and re-scan
            continue
        end

        for _, targetPlayer in ipairs(playersToBring) do
            if not BringAllConfig.Enabled or not targetPlayer.Parent then continue end

            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetHead = targetPlayer.Character:FindFirstChild("Head")

            if targetRoot and targetHead then                
                local success = false
                for i = 1, 30 do -- Try more aggressively (approx 1.5s)
                    if not BringAllConfig.Enabled or not targetPlayer.Parent or not targetRoot.Parent then break end

                    -- Loop内で常に相手の位置に追従する (重要)
                    myChar:PivotTo(targetRoot.CFrame * CFrame.new(0, 0, 2))

                    if targetHead:FindFirstChild("PartOwner") and targetHead.PartOwner.Value == LocalPlayer.Name then
                        success = true
                        break
                    end
                    
                    if GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner") then
                        pcall(function()
                            GrabEvents.SetNetworkOwner:FireServer(targetRoot, CFrame.lookAt(myRoot.Position, targetRoot.Position))
                        end)
                    end
                    task.wait(0.05) -- チェック間隔を短縮
                end

                if success then
                    CreateBringMover(targetRoot, BringAllConfig.Position)
                    -- 初期位置を強制的にセットして勢いをつける
                    targetRoot.CFrame = CFrame.new(BringAllConfig.Position)
                    targetRoot.AssemblyLinearVelocity = Vector3.zero
                end

                if myRoot and BringAllConfig.Enabled then
                    myChar:PivotTo(BringAllConfig.HiddenCFrame)
                end
            end
        end
        
        task.wait(1) -- Wait after a full pass
    end
end

local function StartBringAll()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    if not myRoot or not myHum then return end
    
    BringAllConfig.Position = myRoot.Position
    saveCollisions(myChar, "BringAll")
    nocoll(myChar)

    local camPart = Instance.new("Part")
    camPart.Name = "BringAllCameraPart"
    camPart.Size = Vector3.new(1, 1, 1)
    camPart.Transparency = 1
    camPart.Anchored = true
    camPart.CanCollide = false
    camPart.CFrame = myRoot.CFrame
    camPart.Parent = Workspace
    BringAllConfig.CameraPart = camPart
    Camera.CameraSubject = camPart

    myChar:PivotTo(BringAllConfig.HiddenCFrame)

    BringAllConfig.MainLoop = task.spawn(BringAllLoop)
end

local function StopBringAll()
    BringAllConfig.MainLoop = nil

    for _, mover in ipairs(BringAllConfig.ActiveMovers) do
        if mover and mover.Parent then
            mover:Destroy()
        end
    end
    BringAllConfig.ActiveMovers = {}

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
    if BringAllConfig.CameraPart then
        BringAllConfig.CameraPart:Destroy()
        BringAllConfig.CameraPart = nil
    end
    
    restoreCollisions("BringAll")
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myRoot and BringAllConfig.Position then
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.CFrame = CFrame.new(BringAllConfig.Position)
    end
end

BringAllSec:AddToggle({
    Name = "Bring All", 
    Default = false, 
    Callback = function(v)
        BringAllConfig.Enabled = v
        if v then
            StartBringAll()
        else
            StopBringAll()
        end
    end
})

BringAllSec:AddToggle({
    Name = "Whitelist Friends", 
    Default = false, 
    Callback = function(v)
        BringAllConfig.Whitelist = v
    end
})

-- 起動完了通知
OrionLib:MakeNotification({
	Name = "test Hub",
	Content = "スクリプトが正常に読み込まれました",
	Time = 5
})

OrionLib:Init()
