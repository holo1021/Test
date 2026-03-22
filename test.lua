--[[
    チャットブロック トグル (外部エクゼキューター用)
    ・SayMessageRequest リモートイベントをフック
    ・TextChatService の TextSource.CanSend も制御
    ・UIボタンでON/OFF切り替え可能
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- 保存用
local originalFire = nil
local chatEvent = nil
local myTextSource = nil

-- 状態
local isBlocking = false

-- UI作成
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatBlockToggle"
screenGui.ResetOnSpawn = false  -- リスポーン時に消えないように
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 40)
button.Position = UDim2.new(0.5, -75, 0.5, -20)  -- 中央付近
button.Text = "Chat Block: OFF"
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.BorderSizePixel = 0
button.Parent = screenGui

-- ドラッグ用変数
local dragging = false
local dragStart = nil
local startPos = nil

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = button.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                     startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- 旧チャットシステム対応: SayMessageRequest をフックする関数
local function hookSayMessageRequest(enable)
    if not chatEvent then
        local defaultChat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if defaultChat then
            chatEvent = defaultChat:FindFirstChild("SayMessageRequest")
        end
    end
    if not chatEvent then return end

    if enable then
        if not originalFire then
            originalFire = chatEvent.FireServer
        end
        -- オーバーライド：何も送信しない
        chatEvent.FireServer = function(...)
            if isBlocking then
                -- ブロック中は何もしない
                return
            else
                -- ブロック解除中なら本来の処理
                return originalFire(chatEvent, ...)
            end
        end
    else
        if originalFire then
            chatEvent.FireServer = originalFire
            originalFire = nil
        end
    end
end

-- 新チャットシステム対応: TextSource.CanSend を操作
local function setTextSourceCanSend(value)
    if not myTextSource then
        for _, source in ipairs(TextChatService:GetDescendants()) do
            if source:IsA("TextSource") and source.UserId == player.UserId then
                myTextSource = source
                break
            end
        end
        if not myTextSource then
            -- まだ生成されていない場合、監視を開始
            local conn
            conn = TextChatService.DescendantAdded:Connect(function(desc)
                if desc:IsA("TextSource") and desc.UserId == player.UserId then
                    myTextSource = desc
                    myTextSource.CanSend = value
                    conn:Disconnect()
                end
            end)
            return
        end
    end
    if myTextSource then
        myTextSource.CanSend = value
    end
end

-- トグル処理
local function toggleBlock()
    isBlocking = not isBlocking
    if isBlocking then
        -- ブロックON
        hookSayMessageRequest(true)   -- フックを有効化（内部で状態参照）
        setTextSourceCanSend(false)   -- TextSource の送信権限を奪う
        button.Text = "Chat Block: ON"
        button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)  -- 赤系
    else
        -- ブロックOFF
        hookSayMessageRequest(false)  -- フック解除
        setTextSourceCanSend(true)    -- 送信権限を戻す
        button.Text = "Chat Block: OFF"
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)   -- 暗いグレー
    end
end

-- ボタンクリックで切り替え
button.MouseButton1Click:Connect(toggleBlock)

-- 初期状態: OFF (何もしない)
print("チャットブロックトグルUIが起動しました。ボタンをクリックしてON/OFFしてください。")
