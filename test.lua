local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- === 設定 ===
local targets = {"najayou777", "najryou777"}
local triggerMessage = "/cほろん"
local responseMessage = "ほろん"
local isActive = false 

-- === UIの作成 ===
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

-- === 修正されたチャット監視イベント ===
TextChatService.MessageReceived:Connect(function(message)
	if not isActive then return end
	
	-- TextSourceが存在するかチェック
	local source = message.TextSource
	if not source then return end
	
	-- 送信者のプレイヤーを取得
	local sender = Players:GetPlayerByUserId(source.UserId)
	if not sender then return end
	
	-- 特定のユーザーかチェック
	local isTarget = false
	for _, name in ipairs(targets) do
		if sender.Name == name then
			isTarget = true
			break
		end
	end
	
	-- message.RawText の代わりに message.Text を使用
	-- 文字列が一致するか判定
	if isTarget and message.Text == triggerMessage then
		local channel = message.TextChannel
		if channel then
			task.wait(0.5) -- 即レス防止
			channel:SendAsync(responseMessage)
		end
	end
end)
