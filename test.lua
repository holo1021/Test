-- TextChatService 完全ブロック (UI無し・常時ON版)
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- チャンネル取得
local textChannels = TextChatService:FindFirstChild("TextChannels")
local rbxGeneral = textChannels and textChannels:FindFirstChild("RBXGeneral")
if rbxGeneral then
    local originalSend = rbxGeneral.SendAsync
    rbxGeneral.SendAsync = function(self, message, ...)
        print("ブロック: " .. tostring(message))  -- コンソール確認用
        return  -- 一切送信しない
    end
    print("RBXGeneral.SendAsync をフックしました")
else
    print("RBXGeneral チャンネルが見つかりません")
end

-- TextSource の CanSend を false にし、リセットされても監視する
local mySource = nil
local function findAndSet()
    for _, source in ipairs(TextChatService:GetDescendants()) do
        if source:IsA("TextSource") and source.UserId == player.UserId then
            if mySource ~= source then
                mySource = source
                source.CanSend = false
                print("TextSource を false に設定")
                -- プロパティ変更を監視して、trueに戻されたら再びfalseに
                local conn
                conn = source:GetPropertyChangedSignal("CanSend"):Connect(function()
                    if source.CanSend == true then
                        source.CanSend = false
                        print("CanSend が true に戻されたので再ブロック")
                    end
                end)
                -- ソースが削除されたら監視解除（任意）
                source.AncestryChanged:Connect(function()
                    if not source.Parent then
                        conn:Disconnect()
                        mySource = nil
                    end
                end)
            end
            return true
        end
    end
    return false
end

if not findAndSet() then
    TextChatService.DescendantAdded:Connect(function(desc)
        if desc:IsA("TextSource") and desc.UserId == player.UserId then
            findAndSet()
        end
    end)
end
