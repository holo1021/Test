-- 常時ブロック版（テスト用）
local repStorage = game:GetService("ReplicatedStorage")
local chatEvent = repStorage:FindFirstChild("DefaultChatSystemChatEvents")
if chatEvent then
    chatEvent = chatEvent:FindFirstChild("SayMessageRequest")
end
if chatEvent then
    local original = chatEvent.FireServer
    chatEvent.FireServer = function(...)
        print("ブロックされました")  -- コンソールに表示されるか確認
        return
    end
    print("SayMessageRequest をブロック中")
else
    print("SayMessageRequest が見つかりません")
end

-- 新チャット対応
local textChatService = game:GetService("TextChatService")
local player = game:GetService("Players").LocalPlayer
local function disableNewChat()
    for _, source in ipairs(textChatService:GetDescendants()) do
        if source:IsA("TextSource") and source.UserId == player.UserId then
            source.CanSend = false
            print("TextSource.CanSend = false に設定")
            return true
        end
    end
    return false
end
if not disableNewChat() then
    textChatService.DescendantAdded:Connect(function(desc)
        if desc:IsA("TextSource") and desc.UserId == player.UserId then
            desc.CanSend = false
            print("TextSource が追加されました → CanSend = false")
        end
    end)
end
