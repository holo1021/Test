local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- === 設定 ===
local targets = {"najayou777", "najryou777"}
local triggerMessage = "/cholon"
local responseMessage = "ほろん"
local isActive = false -- 最初はオフ

-- === UIの作成 ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoChatControl"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 150, 0, 50)
mainButton.Position = UDim2.new(0.5, -75, 0, 50) -- 画面上部中央
mainButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- 最初は赤
mainButton.Text = "自動応答: OFF"
mainButton.TextColor3 = Color3.new(1, 1, 1)
mainButton.Font = Enum.Font.SourceSansBold
mainButton.TextSize = 20
mainButton.Parent = screenGui

-- 角を丸くする
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainButton

-- === ボタンのクリックイベント ===
mainButton.MouseButton1Click:Connect(function()
	isActive = not isActive
	if isActive then
		mainButton.Text = "自動応答: ON"
		mainButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- オンなら緑
	else
		mainButton.Text = "自動応答: OFF"
		mainButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- オフなら赤
	end
end)

-- === チャット監視イベント ===
TextChatService.MessageReceived:Connect(function(message)
	-- 機能がオフなら何もしない
	if not isActive then return end
	
	local textSource = message.TextSource
	if not textSource then return end
	
	-- 特定のユーザーかチェック
	local isTarget = false
	for _, name in ipairs(targets) do
		if textSource.Name == name then
			isTarget = true
			break
		end
	end
	
	-- 条件一致で返信
	if isTarget and message.RawText == triggerMessage then
		local channel = message.TextChannel
		if channel then
			task.wait(0.5) -- 即レス防止
			channel:SendAsync(responseMessage)
		end
	end
end)
