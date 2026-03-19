-- Orionライブラリのロード
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jadpy/suki/refs/heads/main/orion"))()

-- メインウィンドウの作成
local Window = OrionLib:MakeWindow({
    Name = "Kick All Test",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "KickAllConfig",
    IntroEnabled = true,
    IntroText = "Kick All Test"
})

-- メインタブの作成
local Tab = Window:MakeTab({
    Name = "メインタブ",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- ホワイトフレンドタブの作成
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
local whiteFriends = {}  -- ホワイトフレンド保存用

-- ホワイトフレンドかチェックする関数
local function IsWhiteFriend(player)
    return whiteFriends[player] == true or whiteFriends[player.Name] == true
end

-- プロット内プレイヤーを取得する関数
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

-- プレイヤーが保護対象かチェック（プロット内またはホワイトフレンド）
local function IsPlayerProtected(player)
    -- ホワイトフレンドは保護
    if IsWhiteFriend(player) then
        return true
    end
    
    -- プロット内プレイヤーも保護
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
    
    -- 保護対象はスキップ
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
    
    -- 保護対象はスキップ
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
        -- 自分自身と保護対象は除外
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
    -- Grab20回実行（0.01秒間隔）
    for grabCount = 1, 10 do  -- 1-10回目
        for player, _ in pairs(grabbedPlayers) do
            if player and player.Character and not IsPlayerProtected(player) then
                GrabPlayer(blob, player)
            end
        end
        task.wait(0.01)  -- 0.01秒間隔
    end
    
    task.wait(0.02)  -- 中間待機
    
    for grabCount = 1, 10 do  -- 11-20回目
        for player, _ in pairs(grabbedPlayers) do
            if player and player.Character and not IsPlayerProtected(player) then
                GrabPlayer(blob, player)
            end
        end
        task.wait(0.01)  -- 0.01秒間隔
    end
    
    return #grabbedPlayers
end

-- プレイヤーリストを更新する関数
local function UpdatePlayerDropdown()
    local players = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end

-- ホワイトフレンド追加用ドロップダウン
FriendTab:AddDropdown({
    Name = "フレンドを選択",
    Default = "",
    Options = UpdatePlayerDropdown(),
    Callback = function(selected)
        -- 選択されたプレイヤーをホワイトフレンドに追加
        local player = Players:FindFirstChild(selected)
        if player then
            whiteFriends[player] = true
            whiteFriends[player.Name] = true
            OrionLib:MakeNotification({
                Name = "ホワイトフレンド追加",
                Content = selected .. " を保護リストに追加しました",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    end
})

-- ホワイトフレンド削除用ドロップダウン
FriendTab:AddDropdown({
    Name = "削除するフレンド",
    Default = "",
    Options = UpdatePlayerDropdown(),
    Callback = function(selected)
        local player = Players:FindFirstChild(selected)
        if player then
            whiteFriends[player] = nil
            whiteFriends[player.Name] = nil
            OrionLib:MakeNotification({
                Name = "ホワイトフレンド削除",
                Content = selected .. " を保護リストから削除しました",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    end
})

-- ホワイトフレンド一覧表示
FriendTab:AddButton({
    Name = "ホワイトフレンド一覧",
    Callback = function()
        local friendList = "保護中のフレンド:"
        local count = 0
        for name, _ in pairs(whiteFriends) do
            if type(name) == "string" and name ~= "" then
                friendList = friendList .. "\n・" .. name
                count = count + 1
            end
        end
        if count == 0 then
            friendList = "保護中のフレンドはいません"
        end
        OrionLib:MakeNotification({
            Name = "ホワイトフレンド一覧",
            Content = friendList,
            Image = "rbxassetid://4483345998",
            Time = 4
        })
    end
})

-- メイン実行ボタン
Tab:AddButton({
    Name = "キックオール",
    Callback = function()
        grabbedPlayers = {}
        currentBlob = nil
        local totalPlayers = 0
        
        -- 保護対象をカウント
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

OrionLib:Init()
