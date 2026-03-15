--[[
	Bliz-style UI with Super Strong, Death Grab, Noclip Grab, and Perspective Toggles

	This script should be placed in StarterPlayer > StarterPlayerScripts as a LocalScript.
]]

--============================================================================--
--                            SERVICES AND VARIABLES                          --
--============================================================================--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

-- State variables
local isSuperStrong = false
local isDeathGrabActive = false
local isNoclipGrabActive = false
local isBlobmanLock = false
local isAutoAttacker = false
local isLineEsp = false
local isSoftLag = false
local isInvisible = false
local isDeathAura = false
local isRadioactive = false
local isClickTp = false
local isLoopKill = false
local isAutoAnchor = false
local isAntiKick = false

local grabTarget = nil
local noclipEnabled = false
local radioactivePart = nil
local lineAdornments = {}
local softLagTick = 0
local killAllActive = false

--============================================================================--
--                                FEATURE SETUP                               --
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
local MiscTab = Window:MakeTab({ Name = "Misc" })

-- Player Tab
PlayerTab:AddToggle({
	Name = "Super Strong",
	Default = false,
	Callback = function(enabled)
	isSuperStrong = enabled
	local character = localPlayer.Character
	if character and character:FindFirstChild("Humanoid") then
		local humanoid = character.Humanoid
		if isSuperStrong then
			humanoid.WalkSpeed = 50
			humanoid.JumpPower = 100
			Instance.new("ForceField", character)
		else
			humanoid.WalkSpeed = 16 -- Default
			humanoid.JumpPower = 50 -- Default
			if character:FindFirstChild("ForceField") then
				character.ForceField:Destroy()
			end
		end
	end
end})

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
end})

CombatTab:AddToggle({
	Name = "Death Grab",
	Default = false,
	Callback = function(enabled)
	isDeathGrabActive = enabled
	if not enabled and grabTarget then
		grabTarget = nil -- Clear target if disabled
	end
end})

CombatTab:AddToggle({
	Name = "Noclip Grab",
	Default = false,
	Callback = function(enabled)
	isNoclipGrabActive = enabled
	if not enabled and grabTarget then
		grabTarget = nil -- Clear target if disabled
	end
end})

PlayerTab:AddToggle({
	Name = "Noclip",
	Default = false,
	Callback = function(enabled)
	noclipEnabled = enabled
end})

VisualsTab:AddToggle({
	Name = "Blobman Lock",
	Default = false,
	Callback = function(enabled)
	isBlobmanLock = enabled
end})

CombatTab:AddToggle({
	Name = "Auto Attacker (Death)",
	Default = false,
	Callback = function(enabled)
	isAutoAttacker = enabled
end})

VisualsTab:AddToggle({
	Name = "Line ESP",
	Default = false,
	Callback = function(enabled)
	isLineEsp = enabled
	if not enabled then
		for _, line in pairs(lineAdornments) do line:Destroy() end
		lineAdornments = {}
	end
end})

MiscTab:AddToggle({
	Name = "Soft Lag",
	Default = false,
	Callback = function(enabled)
	isSoftLag = enabled
end})

PlayerTab:AddToggle({
	Name = "Invisible",
	Default = false,
	Callback = function(enabled)
	isInvisible = enabled
	local char = localPlayer.Character
	if char then
		-- Simple client-side vanish
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("Decal") then
				part.Transparency = isInvisible and 1 or 0
			end
		end
	end
end})

CombatTab:AddToggle({
	Name = "Death Aura",
	Default = false,
	Callback = function(enabled)
	isDeathAura = enabled
end})

VisualsTab:AddToggle({
	Name = "Radioactive Aura",
	Default = false,
	Callback = function(enabled)
	isRadioactive = enabled
end})

PlayerTab:AddToggle({
	Name = "Click TP (Ctrl)",
	Default = false,
	Callback = function(enabled)
	isClickTp = enabled
end})

PlayerTab:AddToggle({
	Name = "Anchor Self",
	Default = false,
	Callback = function(enabled)
	local char = localPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.Anchored = enabled
	end
end})

PlayerTab:AddToggle({
	Name = "Auto Anchor (Re-anchor)",
	Default = false,
	Callback = function(enabled)
	isAutoAnchor = enabled
end})

CombatTab:AddToggle({
	Name = "Loop Kill Target",
	Default = false,
	Callback = function(enabled)
	isLoopKill = enabled
end})

CombatTab:AddButton({
	Name = "Kill All",
	Callback = function()
	killAllActive = true
	wait(0.5)
	killAllActive = false
end})

MiscTab:AddButton({
	Name = "Bring All (Client)",
	Callback = function()
	-- Client side bring simulation (Teleport to them)
	killAllActive = true -- Reusing logic to visit everyone
	wait(0.5)
	killAllActive = false
end})

MiscTab:AddToggle({
	Name = "Anti-Kick (Iyhan)",
	Default = false,
	Callback = function(enabled)
	isAntiKick = enabled
	-- Try to hook Kick (Only works in exploit environments)
	if enabled and getrawmetatable and setreadonly then
		pcall(function()
			local mt = getrawmetatable(game)
			setreadonly(mt, false)
			local old = mt.__namecall
			mt.__namecall = function(self, ...)
				local method = getnamecallmethod()
				if method == "Kick" then return end
				return old(self, ...)
			end
			setreadonly(mt, true)
		end)
	end
end})

OrionLib:Init()

--============================================================================--
--                             FEATURE IMPLEMENTATION                         --
--============================================================================--

-- Grab Logic
mouse.Button1Down:Connect(function()
	if (isDeathGrabActive or isNoclipGrabActive) and mouse.Target and mouse.Target.Parent:FindFirstChild("Humanoid") then
		local targetCharacter = mouse.Target.Parent
		if targetCharacter ~= localPlayer.Character then
			grabTarget = targetCharacter
		end
	end
end)

mouse.Button1Down:Connect(function()
	if isClickTp and mouse.Target and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
		local char = localPlayer.Character
		if char then
			char:MoveTo(mouse.Hit.Position)
		end
	end
end)

mouse.Button1Up:Connect(function()
	grabTarget = nil
end)

-- Key press for death grab action
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then return end

	if input.KeyCode == Enum.KeyCode.Q and isDeathGrabActive and grabTarget then
		-- This part is tricky and often patched.
		-- A common old method was to set network ownership and manipulate.
		-- For demonstration, we'll just print. A real implementation would need a RemoteEvent.
		print("Attempting to 'eliminate' " .. grabTarget.Name)
		-- In a real scenario, you would fire a remote event to the server
		-- to handle the "kill" action to ensure it replicates.
		-- Example: game.ReplicatedStorage.KillEvent:FireServer(grabTarget)
	end
end)

-- Noclip and Grab Movement Loop
RunService.RenderStepped:Connect(function()
	local character = localPlayer.Character
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChild("Humanoid")

	-- Noclip Logic
	if noclipEnabled then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end

	-- Grab Movement
	if grabTarget and grabTarget.PrimaryPart then
		if isNoclipGrabActive or isDeathGrabActive then
			-- Move the grabbed target in front of the player's camera
			local camera = workspace.CurrentCamera
			local newPosition = camera.CFrame.p + camera.CFrame.LookVector * 10
			grabTarget:SetPrimaryPartCFrame(CFrame.new(newPosition))
		end
	end

	-- Blobman Lock (Look at nearest player)
	if isBlobmanLock then
		local nearest = nil
		local minDist = 9999
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") then
				local dist = (p.Character.Head.Position - character.Head.Position).Magnitude
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

	-- Line ESP
	if isLineEsp then
		-- Clear old lines that are invalid
		for p, line in pairs(lineAdornments) do
			if not p.Parent or not p.Character then
				line:Destroy()
				lineAdornments[p] = nil
			end
		end
		-- Draw new lines
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				if not lineAdornments[p] then
					local a = Instance.new("LineHandleAdornment")
					a.Parent = workspace
					a.Adornee = nil -- We set points manually
					a.Color3 = Color3.new(1, 0, 0)
					a.Thickness = 2
					a.AlwaysOnTop = true
					lineAdornments[p] = a
				end
				local line = lineAdornments[p]
				if hrp then
					line.Length = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
					line.CFrame = CFrame.lookAt(hrp.Position, p.Character.HumanoidRootPart.Position)
				end
			end
		end
	end

	-- Soft Lag (Toggle Anchor rapidly)
	if isSoftLag and hrp then
		softLagTick = softLagTick + 1
		if softLagTick % 10 == 0 then
			hrp.Anchored = not hrp.Anchored
		end
	end

	-- Auto Anchor
	if isAutoAnchor and hrp then
		hrp.Anchored = true
	end

	-- Death Aura / Auto Attacker / Kill All Logic
	if isDeathAura or isAutoAttacker or killAllActive or isLoopKill then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character:FindFirstChild("HumanoidRootPart") then
				local targetHrp = p.Character.HumanoidRootPart
				local dist = (targetHrp.Position - hrp.Position).Magnitude
				
				local shouldAttack = false
				
				if killAllActive then shouldAttack = true end
				if isLoopKill and grabTarget and p.Character == grabTarget then shouldAttack = true end
				if (isDeathAura or isAutoAttacker) and dist < 25 then shouldAttack = true end

				if shouldAttack then
					-- Teleport to them if Kill All
					if killAllActive then
						hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 2)
					end
					
					-- "Attack" (Client side attempt)
					if humanoid then
						-- Animation or Tool activation would go here
						-- Simulation of damage:
						p.Character.Humanoid.Health = 0 -- Only works if you have network ownership (unlikely)
					end
				end
			end
		end
	end

	-- Radioactive Aura (Visuals)
	if isRadioactive and hrp then
		if not radioactivePart then
			radioactivePart = Instance.new("Part")
			radioactivePart.Name = "RadioactiveField"
			radioactivePart.CanCollide = false
			radioactivePart.Anchored = true
			radioactivePart.Shape = Enum.PartType.Ball
			radioactivePart.Size = Vector3.new(15, 15, 15)
			radioactivePart.Color = Color3.fromRGB(0, 255, 0)
			radioactivePart.Transparency = 0.7
			radioactivePart.Material = Enum.Material.Neon
			radioactivePart.Parent = workspace
		end
		radioactivePart.CFrame = hrp.CFrame
		-- Reuse death aura logic for damage if needed
	else
		if radioactivePart then
			radioactivePart:Destroy()
			radioactivePart = nil
		end
	end
end)

-- Reset states on death
localPlayer.CharacterAdded:Connect(function(character)
	-- Reset super strong if it was on
	if isSuperStrong then
		-- Wait for humanoid to exist
		character:WaitForChild("Humanoid")
		wait(0.1) -- Give it a moment to initialize
		local humanoid = character.Humanoid
		humanoid.WalkSpeed = 50
		humanoid.JumpPower = 100
		Instance.new("ForceField", character)
	end

	-- Reset noclip
	noclipEnabled = false
end)
