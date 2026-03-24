local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- === 設定 ===
local targets = {"najayou777", "najryou777"}
local triggerMessage = "/cholon"
local responseMessage = "ほろん"
local isActive = false 

-- === UIの作成 (前回と同じ) ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoChatControl"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 150, 0, 50)
mainButton.Position = UDim2.new(0.5, -75, 0, 50)
mainButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
mainButton.Text = "自動応答: OFF"
mainButton.TextColor3 = Color3.new(1, 1, 1)
mainButton.Font = Enum.Font.SourceSansBold
mainButton.TextSize = 20
mainButton.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainButton

mainButton.MouseButton1Click:Connect(function()
	isActive = not isActive
	mainButton.Text = isActive and "自動応答: ON" or "自動応答: OFF"
	mainButton.BackgroundColor3 = isActive and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

-- === エラー対策済みのチャット監視 ===
TextChatService.MessageReceived:Connect(function(message)
	if not isActive then return end
	
	-- TextSourceが存在するかチェック (エラー回避の要)
	local source = message.TextSource
	if not source then return end
	
	-- UserIdからプレイヤー名を取得して判定
	local sender = Players:GetPlayerByUserId(source.UserId)
	if not sender then return end
	
	local isTarget = false
	for _, name in ipairs(targets) do
		if sender.Name == name then
			isTarget = true
			break
		end
	end
	
	if isTarget and message.RawText == triggerMessage then
		-- 送信先チャンネルを確認して返信
		local channel = message.TextChannel
		if channel then
			task.wait(0.5)
			channel:SendAsync(responseMessage)
		end
	end
end)
