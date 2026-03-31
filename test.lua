local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local DebrisService = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local TextChatService = game:GetService("TextChatService")

-- test.luaから持ってきたイベント定義
local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- 作者情報の定義
local AuthorName = "holon_calm"
local RobloxID = "najayou777"
local DetailIcon = "rbxassetid://7733964719"

local OrionLib = nil
local UIElements = {}
local targetMainName = ""

-- --- 保存・復元のために変数のスコープを上に移動 ---
local superStrengthEnabled = false
local strengthValue = 400
local deathGrabEnabled = false
local noclipGrabEnabled = false
local perspectiveGrabEnabled = false
local perspectiveSpeed = 50
local invisibleLineEnabled = false
local IncreaseLineExtend = 3
-- --------------------------------------------

-- リンク集を表示する共通関数（認証画面とメイン画面で使い回せます）
local function AddDetailContent(Tab)
    Tab:AddButton({
        Name = "EN version copy and launch",
        Callback = function()
            setclipboard("loadstring(game:HttpGet(\"https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/language/hub-en.lua\"))()")
            task.spawn(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/language/hub-en.lua"))()
            end)
        end
    })

    Tab:AddButton({
        Name = "TikTok",
        Callback = function()
            setclipboard("https://www.tiktok.com/@holon_calm")
            OrionLib:MakeNotification({Name = "リンク", Content = "TikTokのリンクをコピーしました", Time = 3})
        end
    })
    
    Tab:AddButton({
        Name = "Discord",
        Callback = function()
            setclipboard("https://discord.gg/EHBXqgZZYN")
            OrionLib:MakeNotification({Name = "リンク", Content = "Discordの招待リンクをコピーしました", Time = 3})
        end
    })
    
    Tab:AddButton({
        Name = "YouTube",
        Callback = function()
            setclipboard("https://www.youtube.com/@Holoncalm")
            OrionLib:MakeNotification({Name = "リンク", Content = "YouTubeのリンクをコピーしました", Time = 3})
        end
    })
    Tab:AddLabel("作者: " .. AuthorName)
    Tab:AddLabel("Roblox ID: " .. RobloxID)
end

-- BodyMover作成関数
local function createBodyMovers(part)
    -- 既存のMoverがあれば削除
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("BodyPosition") or child:IsA("BodyGyro") then
            child:Destroy()
        end
    end

    local bodyPosition = Instance.new("BodyPosition")
    local bodyGyro = Instance.new("BodyGyro")

    bodyPosition.P = 20000
    bodyPosition.D = 500
    bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyPosition.Parent = part

    bodyGyro.P = 3000
    bodyGyro.D = 100
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.Parent = part

    return bodyPosition, bodyGyro
end

local function getActiveTargetMain()
    if targetMainName == "" then return LocalPlayer end
    -- 名前から「今現在」のプレイヤーを探し直す
    return Players:FindFirstChild(targetMainName) or LocalPlayer
end

-- プロット位置を自動取得する関数
local function getMyPlotCFrame()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then 
        warn("Holon HUB: Plots folder not found in Workspace")
        return nil 
    end

    local myName = LocalPlayer.Name

    for _, plot in ipairs(plots:GetChildren()) do
        -- 教えていただいた構造: Plot○ -> PlotSign -> ThisPlotsOwners -> Value -> Data -> Value
        local plotSign = plot:FindFirstChild("PlotSign")
        local ownerValObj = plotSign and plotSign:FindFirstChild("ThisPlotsOwners")
        local valueFolder = ownerValObj and ownerValObj:FindFirstChild("Value")
        local dataObj = valueFolder and valueFolder:FindFirstChild("Data")

        -- StringValue である Data.Value の中身をチェック
        if dataObj and dataObj:IsA("StringValue") then
            if dataObj.Value == myName then
                print("Holon HUB: Plot found! Target:", plot.Name)
                return plot:GetPivot() -- プロットの中心座標を返す
            end
        end
    end
    
    warn("Holon HUB: Your plot was not found.")
    return nil
end

-- ■ 1. getMusicKeyboard 関数の修正 (おもちゃリスト同様の探索ロジックに変更)
local function getMusicKeyboard()
    local myName = LocalPlayer.Name
    
    -- 1. SpawnedInToys から探す
    local spawnedToys = Workspace:FindFirstChild(myName .. "SpawnedInToys")
    if spawnedToys then
        local kb = spawnedToys:FindFirstChild("MusicKeyboard")
        if kb then return kb end
    end

    -- 2. Plots から探す
    local plots = Workspace:FindFirstChild("Plots")
    local plotItems = Workspace:FindFirstChild("PlotItems")

    if plots and plotItems then
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local ownerObj = sign and (sign:FindFirstChild("ThisPlotsOwners") or sign:FindFirstChild("Owner"))
            if ownerObj then
                local val = ownerObj:FindFirstChild("Value") or ownerObj
                local data = val:FindFirstChild("Data") or val
                if (data:IsA("StringValue") and data.Value == myName) then
                    -- PlotItemsフォルダ内を検索 (startEffectを参考)
                    local myPlotItems = plotItems:FindFirstChild(plot.Name)
                    if myPlotItems then
                        local kb = myPlotItems:FindFirstChild("MusicKeyboard")
                        if kb then return kb end
                    end
                    -- 念のためBuild内も検索
                    local build = plot:FindFirstChild("Build")
                    local kb = build and build:FindFirstChild("MusicKeyboard")
                    if kb then return kb end
                end
            end
        end
    end

    -- 3. Workspace全体から所有権のある MusicKeyboard を探す
    for _, item in ipairs(Workspace:GetChildren()) do
        if item.Name == "MusicKeyboard" and item:IsA("Model") then
            local ownerValue = item:FindFirstChild("Owner") or item:FindFirstChild("PartOwner")
            if ownerValue and ownerValue:IsA("StringValue") and ownerValue.Value == myName then
                return item
            end
        end
    end

    return nil
end

-- ピアノ機能用の変数 (関数の前に定義して、関数から見えるようにする)
local pianoEnabled = false
local pianoFollowEnabled = true
local selectedSongFile = nil
local selectedSongData = nil
local pianoKeyboard = nil
local isPlayingSong = false
local pianoUpdateConnection = nil
local lastPianoCF = nil
local pianoOriginalCollisions = {}
local manualPlayEnabled = false -- 手動演奏UIの状態管理

-- 録音機能用変数
local isRecording = false
local recordedNotes = {}
local recordStartTime = 0

-- ピアノ手動演奏UI
local pianoUIGui = nil
local function createPianoUI()
    if pianoUIGui and pianoUIGui.Parent then return end

    pianoUIGui = Instance.new("ScreenGui")
    pianoUIGui.Name = "HolonPianoUI"
    pianoUIGui.Parent = game:GetService("CoreGui")
    pianoUIGui.Enabled = manualPlayEnabled
    pianoUIGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    pianoUIGui.DisplayOrder = 100 -- 最前面に表示
    pianoUIGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.AnchorPoint = Vector2.new(0.5, 1)
    mainFrame.Position = UDim2.new(0.5, 0, 0.95, 0)
    mainFrame.Size = UDim2.new(0, 500, 0, 140) -- サイズ縮小
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.Parent = pianoUIGui
    
    -- 閉じるボタン
    local closeBtn = Instance.new("TextButton", mainFrame)
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -25, 0, 5)
    closeBtn.Text = "X"
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.MouseButton1Click:Connect(function()
        stopSong()
        manualPlayEnabled = false
        pianoUIGui.Enabled = false
        if UIElements.PianoManualUIToggle then
            UIElements.PianoManualUIToggle:Set(false)
        end
    end)

    -- 録音・保存UI
    local recFrame = Instance.new("Frame", mainFrame)
    recFrame.Size = UDim2.new(1, -40, 0, 25)
    recFrame.Position = UDim2.new(0, 10, 0, 5)
    recFrame.BackgroundTransparency = 1
    
    local recBtn = Instance.new("TextButton", recFrame)
    recBtn.Size = UDim2.new(0, 50, 1, 0)
    recBtn.Text = "録音"
    recBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    recBtn.TextColor3 = Color3.new(1,1,1)
    recBtn.MouseButton1Click:Connect(function()
        isRecording = not isRecording
        if isRecording then
            recordedNotes = {}
            recordStartTime = tick()
            recBtn.Text = "停止"
            OrionLib:MakeNotification({Name="録音", Content="録音を開始しました", Time=2})
        else
            recBtn.Text = "録音"
            OrionLib:MakeNotification({Name="録音", Content="録音を停止しました", Time=2})
        end
    end)
    
    local nameBox = Instance.new("TextBox", recFrame)
    nameBox.Size = UDim2.new(0, 120, 1, 0)
    nameBox.Position = UDim2.new(0, 60, 0, 0)
    nameBox.PlaceholderText = "ファイル名"
    nameBox.Text = ""
    nameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    nameBox.TextColor3 = Color3.new(1,1,1)

    local saveBtn = Instance.new("TextButton", recFrame)
    saveBtn.Size = UDim2.new(0, 50, 1, 0)
    saveBtn.Position = UDim2.new(0, 190, 0, 0)
    saveBtn.Text = "保存"
    saveBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    saveBtn.TextColor3 = Color3.new(1,1,1)
    saveBtn.MouseButton1Click:Connect(function()
        if _G.HolonSaveRecording then _G.HolonSaveRecording(nameBox.Text) end
    end)

    local keysContainer = Instance.new("Frame", mainFrame)
    keysContainer.Size = UDim2.new(1, 0, 1, -35)
    keysContainer.Position = UDim2.new(0, 0, 0, 35)
    keysContainer.BackgroundTransparency = 1

    local whiteKeysFrame = Instance.new("Frame", keysContainer)
    whiteKeysFrame.Size = UDim2.new(1, 0, 1, 0)
    whiteKeysFrame.BackgroundTransparency = 1
    local whiteLayout = Instance.new("UIListLayout", whiteKeysFrame)
    whiteLayout.FillDirection = Enum.FillDirection.Horizontal
    whiteLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local blackKeysFrame = Instance.new("Frame", keysContainer)
    blackKeysFrame.Size = UDim2.new(1, 0, 0.6, 0)
    blackKeysFrame.BackgroundTransparency = 1
    blackKeysFrame.ZIndex = 2

    local whiteKeys = {
        "Key1C", "Key1D", "Key1E", "Key1F", "Key1G", "Key1A", "Key1B",
        "Key2C", "Key2D", "Key2E", "Key2F", "Key2G", "Key2A", "Key2B", "Key3C"
    }
    local blackKeys = {
        ["Key1C"] = "Key1Csharp", ["Key1D"] = "Key1Dsharp",
        ["Key1F"] = "Key1Fsharp", ["Key1G"] = "Key1Gsharp", ["Key1A"] = "Key1Asharp",
        ["Key2C"] = "Key2Csharp", ["Key2D"] = "Key2Dsharp",
        ["Key2F"] = "Key2Fsharp", ["Key2G"] = "Key2Gsharp", ["Key2A"] = "Key2Asharp"
    }

    local whiteKeyWidth = 1 / #whiteKeys
    for i, keyName in ipairs(whiteKeys) do
        local btn = Instance.new("TextButton", whiteKeysFrame)
        btn.Name = keyName; btn.Size = UDim2.new(whiteKeyWidth, -1, 1, 0); btn.BackgroundColor3 = Color3.new(1, 1, 1); btn.BorderColor3 = Color3.new(0, 0, 0); btn.LayoutOrder = i; btn.Text = ""
        btn.MouseButton1Click:Connect(function()
            task.spawn(pressPianoKey, keyName)
        end)
        
        -- キー表示
        if _G.HolonPianoKeyMapReverse then
            btn.Text = _G.HolonPianoKeyMapReverse[keyName] or ""
            btn.TextSize = 14
            btn.TextColor3 = Color3.new(0,0,0)
            btn.TextYAlignment = Enum.TextYAlignment.Bottom
        end

        if blackKeys[keyName] then
            local blackKeyName = blackKeys[keyName]
            local blackBtn = Instance.new("TextButton", blackKeysFrame)
            blackBtn.Name = blackKeyName; blackBtn.AnchorPoint = Vector2.new(0.5, 0); blackBtn.Position = UDim2.new(whiteKeyWidth * i, 0, 0, 0); blackBtn.Size = UDim2.new(whiteKeyWidth * 0.6, 0, 1, 0); blackBtn.BackgroundColor3 = Color3.new(0, 0, 0); blackBtn.BorderColor3 = Color3.new(0.5, 0.5, 0.5); blackBtn.Text = ""; blackBtn.ZIndex = 3
            blackBtn.MouseButton1Click:Connect(function()
                task.spawn(pressPianoKey, blackKeyName)
            end)
            if _G.HolonPianoKeyMapReverse then
                blackBtn.Text = _G.HolonPianoKeyMapReverse[blackKeyName] or ""
                blackBtn.TextColor3 = Color3.new(1,1,1)
                blackBtn.TextSize = 12
                blackBtn.TextYAlignment = Enum.TextYAlignment.Bottom
            end
        end
    end
end

-- ピアノを腰の前に追従させる関数
local function setupPianoFollow()
    -- pianoKeyboardがnilなら再取得
    if not pianoKeyboard then pianoKeyboard = getMusicKeyboard() end
    if not pianoKeyboard then return end
    
    -- 既に実行中の場合は何もしない
    if pianoUpdateConnection then return end

    -- ★修正: Mainパーツを探す (なければPrimaryPart)
    local mainPart = pianoKeyboard:FindFirstChild("Main", true) or pianoKeyboard.PrimaryPart
    if not mainPart then 
        warn("Holon HUB: ピアノのMainパーツが見つかりません")
        return 
    end
    print("Holon HUB: ピアノのセットアップを開始:", pianoKeyboard.Name)
    
    -- startEffect同様の初期設定
    for _, part in ipairs(pianoKeyboard:GetDescendants()) do
        if part:IsA("BasePart") then
            -- ★追加: 元の当たり判定を保存
            if pianoOriginalCollisions[part] == nil then
                pianoOriginalCollisions[part] = part.CanCollide
            end
            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false
            part.Anchored = false
            part.Massless = true
            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
            -- 所有権を取得 (startEffectの方式に合わせる)
            pcall(function() part:SetNetworkOwner(LocalPlayer) end)
        end
    end
    
    local pp = mainPart
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local offset = CFrame.new(0, -1.8, -2.8) * CFrame.Angles(0, math.rad(180), 0)
        pp.CFrame = root.CFrame * offset
    end
    
    local a0 = Instance.new("Attachment", pp)
    local ap = Instance.new("AlignPosition", pp)
    ap.Attachment0 = a0
    ap.Mode = Enum.PositionAlignmentMode.OneAttachment
    ap.MaxForce = 1e9
    ap.Responsiveness = 800
    local ao = Instance.new("AlignOrientation", pp)
    ao.Attachment0 = a0
    ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
    ao.MaxTorque = 1e9
    ao.Responsiveness = 800
    
    pianoUpdateConnection = RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if not pianoKeyboard or not pianoKeyboard.Parent then 
            stopPiano()
            return 
        end

        -- 所有権維持 (startEffectの方式に合わせる)
        if math.random() < 0.05 then
             pcall(function() pp:SetNetworkOwner(LocalPlayer) end)
        end

        local baseCF = root.CFrame
        local offset = CFrame.new(0, -1.8, -2.8) * CFrame.Angles(0, math.rad(180), 0)
        local targetCF = baseCF * offset
        ap.Position = targetCF.Position
        ao.CFrame = targetCF
    end)
    print("Holon HUB: ピアノの追従を開始しました")
end

-- ピアノを停止・解放する関数
local function stopPiano()
    if pianoUpdateConnection then
        pianoUpdateConnection:Disconnect()
        pianoUpdateConnection = nil
    end
    if pianoKeyboard and pianoKeyboard.Parent then
        local pp = pianoKeyboard:FindFirstChild("Main", true) or pianoKeyboard.PrimaryPart
        if not pp then return end
        -- AlignPosition/Orientation を削除
        for _, child in ipairs(pp:GetChildren()) do
            if child:IsA("Attachment") or child:IsA("AlignPosition") or child:IsA("AlignOrientation") then
                child:Destroy()
            end
        end
    end
    
    -- ★追加: 当たり判定を元に戻す
    for part, canCollide in pairs(pianoOriginalCollisions) do
        if part and part.Parent then
            part.CanCollide = canCollide
        end
    end
    pianoOriginalCollisions = {} -- テーブルをクリア

    print("Holon HUB: ピアノの追従を停止しました")
end

-- ピアノのキーマッピング（画像の配置に対応）
local pianoKeyMap = {
    -- 白鍵
    ["1"] = "Key1C", ["2"] = "Key1D", ["3"] = "Key1E", ["4"] = "Key1F", 
    ["5"] = "Key1G", ["6"] = "Key1A", ["7"] = "Key1B", ["8"] = "Key2C",
    ["9"] = "Key2D", ["0"] = "Key2E", ["q"] = "Key2F", ["w"] = "Key2G",
    ["e"] = "Key2A", ["r"] = "Key2B", ["t"] = "Key3C",
    
    -- 黒鍵
    ["f"] = "Key1Csharp", ["g"] = "Key1Dsharp", ["h"] = "Key1Fsharp",
    ["j"] = "Key1Gsharp", ["k"] = "Key1Asharp", ["l"] = "Key2Csharp",
    ["z"] = "Key2Dsharp", ["x"] = "Key2Fsharp", ["c"] = "Key2Gsharp",
    ["v"] = "Key2Asharp"
}

-- 逆引きマップをグローバルに保存してUIから参照可能にする
_G.HolonPianoKeyMapReverse = {}
for k, v in pairs(pianoKeyMap) do
    _G.HolonPianoKeyMapReverse[v] = k:upper()
end

-- 1. 鍵盤を叩く関数
local function canPressPianoKey()
    return pianoEnabled
end
local function pressPianoKey(keyName)
    if not canPressPianoKey() then return end

    -- 毎回直接 MusicKeyboard を探しに行く
    local targetKeyboard = getMusicKeyboard()
    
    -- 見つからなければ終了
    if not targetKeyboard then return end

   local key = targetKeyboard:FindFirstChild(keyName, true)
    if key and key:IsA("BasePart") then
        -- ネットワークオーナーの設定（サーバーへ通知）
        SetNetworkOwner:FireServer(key, key.CFrame)
        
        -- 指定の待機時間
        task.wait(0.15)
    end
    
    -- 録音処理
    if isRecording and canPressPianoKey() then
        table.insert(recordedNotes, {key = keyName, time = tick()})
    end
end

-- 2. JSON再生関数
local function playSongFromJSON(jsonData)
    if isPlayingSong then return end
    
    local songData
    local success, err = pcall(function()
        -- 文字列ならデコード、テーブルならそのまま使う
        if type(jsonData) == "string" then
            return HttpService:JSONDecode(jsonData)
        else
            return jsonData
        end
    end)
    
    if not success or type(err) ~= "table" then
        warn("JSONデータの読み込みに失敗しました")
        return
    end
    songData = err

    isPlayingSong = true
    print("演奏を開始します: " .. #songData .. " 音符")
    
    task.spawn(function()
        -- 演奏開始前に一度だけピアノを探す
        if not pianoKeyboard then pianoKeyboard = getMusicKeyboard() end
        
        for i, note in ipairs(songData) do
            -- ボタンで「停止」を押したときだけ止まるようにする
            if not isPlayingSong then break end
            
            local rawKey = tostring(note.key)
            -- JSONのキーが "Key" で始まる場合は変換せずそのまま使う（誤変換防止）
            local keyName = rawKey
            if not string.match(rawKey, "^Key") then
                keyName = pianoKeyMap[rawKey] or rawKey
            end
            
            local delayTime = note.delay or 0.1
            
            -- テストと同じ仕組みで叩く
            task.spawn(function()
                pressPianoKey(keyName)
            end)
            
            -- 次の音まで待機
            task.wait(delayTime)
        end
        
        isPlayingSong = false
        print("演奏が終了しました")
    end)
end

-- 曲の再生を停止
local function stopSong()
    isPlayingSong = false
end

-- 録音保存関数 (UIから呼び出し)
_G.HolonSaveRecording = function(filename)
    if #recordedNotes == 0 then 
        OrionLib:MakeNotification({Name="保存", Content="録音データがありません", Time=3})
        return 
    end
    
    -- ノート間の遅延を計算して保存用データを作成
    local finalData = {}
    for i = 1, #recordedNotes do
        local current = recordedNotes[i]
        local nextNote = recordedNotes[i+1]
        local delay = 0.1
        if nextNote then
            delay = nextNote.time - current.time
        end
        table.insert(finalData, {key = current.key, delay = delay})
    end
    
    local fname = filename
    if not fname or fname == "" then
        -- 自動命名: Test_1, Test_2 ...
        local idx = 1
        while isfile("FTAP_Notes/Test_" .. idx .. ".json") do
            idx = idx + 1
        end
        fname = "Test_" .. idx
    end
    
    if not fname:match("%.json$") then fname = fname .. ".json" end
    
    local success, json = pcall(function() return HttpService:JSONEncode(finalData) end)
    if success then
        writefile("FTAP_Notes/" .. fname, json)
        OrionLib:MakeNotification({Name="保存", Content=fname.." を保存しました", Time=3})
        -- 録音状態リセット
        isRecording = false
    else
        warn("JSON Encode Error")
    end
end

--------------------------------------------------------------------------------
-- [データ定義] ベクターパス / 形状データ
--------------------------------------------------------------------------------
local Paths = {
    -- アルファベット (A-Z, Space) の簡易ストロークデータ
    Alpha = {
        ["A"]={Vector2.new(0,0),Vector2.new(1,2),Vector2.new(2,0),Vector2.new(1.5,1),Vector2.new(0.5,1)},
        ["B"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(1.5,2),Vector2.new(1.5,1),Vector2.new(0,1),Vector2.new(1.5,1),Vector2.new(1.5,0),Vector2.new(0,0)},
        ["C"]={Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,0),Vector2.new(2,0)},
        ["D"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(1.5,1.5),Vector2.new(1.5,0.5),Vector2.new(0,0)},
        ["E"]={Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,1),Vector2.new(1.5,1),Vector2.new(0,1),Vector2.new(0,0),Vector2.new(2,0)},
        ["F"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,1),Vector2.new(1.5,1)},
        ["G"]={Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,0),Vector2.new(2,0),Vector2.new(2,1),Vector2.new(1,1)},
        ["H"]={Vector2.new(0,2),Vector2.new(0,0),Vector2.new(0,1),Vector2.new(2,1),Vector2.new(2,2),Vector2.new(2,0)},
        ["I"]={Vector2.new(0,2),Vector2.new(2,2),Vector2.new(1,2),Vector2.new(1,0),Vector2.new(0,0),Vector2.new(2,0)},
        ["J"]={Vector2.new(0,0.5),Vector2.new(1,0),Vector2.new(2,0.5),Vector2.new(2,2)},
        ["K"]={Vector2.new(0,2),Vector2.new(0,0),Vector2.new(0,1),Vector2.new(2,2),Vector2.new(0,1),Vector2.new(2,0)},
        ["L"]={Vector2.new(0,2),Vector2.new(0,0),Vector2.new(2,0)},
        ["M"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(1,1),Vector2.new(2,2),Vector2.new(2,0)},
        ["N"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,0),Vector2.new(2,2)},
        ["O"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,2),Vector2.new(2,0),Vector2.new(0,0)},
        ["P"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,2),Vector2.new(2,1),Vector2.new(0,1)},
        ["Q"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,2),Vector2.new(2,0),Vector2.new(0,0),Vector2.new(1,0.5),Vector2.new(2,-0.5)},
        ["R"]={Vector2.new(0,0),Vector2.new(0,2),Vector2.new(2,2),Vector2.new(2,1),Vector2.new(0,1),Vector2.new(2,0)},
        ["S"]={Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,1),Vector2.new(2,1),Vector2.new(2,0),Vector2.new(0,0)},
        ["T"]={Vector2.new(0,2),Vector2.new(2,2),Vector2.new(1,2),Vector2.new(1,0)},
        ["U"]={Vector2.new(0,2),Vector2.new(0,0),Vector2.new(2,0),Vector2.new(2,2)},
        ["V"]={Vector2.new(0,2),Vector2.new(1,0),Vector2.new(2,2)},
        ["W"]={Vector2.new(0,2),Vector2.new(0.5,0),Vector2.new(1,1),Vector2.new(1.5,0),Vector2.new(2,2)},
        ["X"]={Vector2.new(0,2),Vector2.new(2,0),Vector2.new(1,1),Vector2.new(0,0),Vector2.new(2,2)},
        ["Y"]={Vector2.new(0,2),Vector2.new(1,1),Vector2.new(2,2),Vector2.new(1,1),Vector2.new(1,0)},
        ["Z"]={Vector2.new(0,2),Vector2.new(2,2),Vector2.new(0,0),Vector2.new(2,0)},
        ["0"]={Vector2.new(0,0),Vector2.new(2,0),Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,0),Vector2.new(2,2)},
        ["1"]={Vector2.new(0.5,1.5),Vector2.new(1,2),Vector2.new(1,0)},
        ["2"]={Vector2.new(0,2),Vector2.new(2,2),Vector2.new(2,1),Vector2.new(0,1),Vector2.new(0,0),Vector2.new(2,0)},
        ["3"]={Vector2.new(0,2),Vector2.new(2,2),Vector2.new(2,1),Vector2.new(0.5,1),Vector2.new(2,1),Vector2.new(2,0),Vector2.new(0,0)},
        ["4"]={Vector2.new(1.5,0),Vector2.new(1.5,2),Vector2.new(0,0.5),Vector2.new(2,0.5)},
        ["5"]={Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,1),Vector2.new(2,1),Vector2.new(2,0),Vector2.new(0,0)},
        ["6"]={Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,0),Vector2.new(2,0),Vector2.new(2,1),Vector2.new(0,1)},
        ["7"]={Vector2.new(0,2),Vector2.new(2,2),Vector2.new(0,0)},
        ["8"]={Vector2.new(1,1),Vector2.new(2,2),Vector2.new(0,2),Vector2.new(2,0),Vector2.new(0,0),Vector2.new(1,1)},
        ["9"]={Vector2.new(2,0),Vector2.new(2,2),Vector2.new(0,2),Vector2.new(0,1),Vector2.new(2,1)},
        [" "]={Vector2.new(0,0), Vector2.new(0,0)}
    },
    -- マカバ (Merkaba) 立体頂点
    Merkaba = { 
        Vector3.new(1,1,1),Vector3.new(-1,-1,1),Vector3.new(-1,1,-1),Vector3.new(1,-1,-1),
        Vector3.new(1,1,1),Vector3.new(-1,-1,-1),Vector3.new(1,1,-1),Vector3.new(1,-1,1),
        Vector3.new(-1,1,1),Vector3.new(-1,-1,-1) 
    },
    -- 五芒星
    Star = (function() local t={}; for i=0,5 do local a=math.rad(i*144+90); table.insert(t, Vector2.new(math.cos(a),math.sin(a))) end; return t end)(),
    -- 円
    Circle = (function() local t={}; for i=0,20 do local a=math.rad(i*18); table.insert(t, Vector2.new(math.cos(a),math.sin(a))) end; return t end)(),
    MagicCircle2 = (function()
        local t = {}
        -- 外側の大きな円
        for i = 0, 36 do
            local a = math.rad(i * 10)
            table.insert(t, Vector2.new(math.cos(a) * 2, math.sin(a) * 2))
        end
        -- 中間の円
        for i = 0, 24 do
            local a = math.rad(i * 15)
            table.insert(t, Vector2.new(math.cos(a) * 1.5, math.sin(a) * 1.5))
        end
        -- 内側の円
        for i = 0, 18 do
            local a = math.rad(i * 20)
            table.insert(t, Vector2.new(math.cos(a), math.sin(a)))
        end
        return t
    end)(),
    
    MagicCircle3 = (function()
        local t = {}
        -- 多重円構造
        for layer = 1, 5 do
            local radius = 2.5 - (layer * 0.4)
            local points = 12 + (layer * 4)
            for i = 0, points do
                local a = math.rad((360 / points) * i)
                table.insert(t, Vector2.new(math.cos(a) * radius, math.sin(a) * radius))
            end
        end
        return t
    end)(),
}

--------------------------------------------------------------------------------
-- [コンフィグ & 変数管理]
--------------------------------------------------------------------------------
local defaultConfig = {
    Wing = { Size = 30, Gap = 3.0, Speed = 6, Height = 0.5, Back = 0, Joints = 3, V_Angle = 0, Tilt = 0, Strength = 15, RootFixed = true, Curve = false, CurveAmount = 10 },
    Heart = { Size = 8, Speed = 2, Height = 5, Back = 2 },
    Star = { Size = 10, Speed = 2, Height = 5, Back = 0 },
    Vortex = { Size = 30, Speed = 10, Height = 20, Back = 0 },
    Sphere = { Size = 30, Speed = 30, Height = 5, Back = 0 },
    Rotate = { Size = 15, Speed = 6, Height = 7, Back = 0, Wave = false, WaveSpeed = 2, WaveAmp = 2 },
    Pet = { Size = 8, Speed = 2, Height = 4, Back = 12, Count = 2, Joints = 3, Gap = 13 },
    Text = { Size = 10, Speed = 5, Height = 6, Back = 2, Content = "HELLO", Mirror = false },
    MagicCircle = { Size = 12, Speed = 2, Height = -3, Back = 0 },
    MagicCircle2 = { Size = 15, Speed = 1, Height = -2, Back = 0, Layers = 3 },
    MagicCircle3 = { Size = 20, Speed = 0.5, Height = 5, Back = 0, Complexity = 5 },
    FloatStone = { Size = 10, Speed = 2, Height = 2, Back = 0, Chaos = false },
    Merkaba = { Size = 8, Speed = 2, Height = 7, Back = 0 },
    Cube = { Size = 5, Speed = 1, Height = 5, Back = 0 },
    Pyramid = { Size = 5, Speed = 1, Height = 5, Back = 0 },
    MirrorPlayer = { Size = 60, Speed = 10, Height = 0, Back = 0, Scale = 1, EdgeSpacing = 1 },
    Beam = { Size = 60, Speed = 50, Height = 0.5, Back = 0, Count = 8 },
    BackGuard = { Size = 10, Speed = 2, Height = 2, Back = 15 },
    Tornado = { Size = 20, Speed = 15, Height = 0, Back = 0, Radius = 5, TopRadius = 20 },
    Gyro = { Size = 20, Speed = 5, Height = 5, Back = 0, InnerSize = 12, CenterType = "Sphere" },
    Combined = {
        Mode1 = "Wing", Mode1Count = 15, Mode1Speed = 6, Mode1Size = 30, Mode1Height = 0, Mode1Back = 0, Mode1RotX = 0, Mode1RotY = -90, Mode1RotZ = 0, Mode1Item = "メインと同期",
        Mode2 = "Rotate", Mode2Count = 15, Mode2Speed = 2, Mode2Size = 8, Mode2Height = 15, Mode2Back = 0, Mode2RotX = 0, Mode2RotY = -90, Mode2RotZ = 0, Mode2Item = "メインと同期",
        Mode3 = "なし", Mode3Count = 0, Mode3Speed = 1, Mode3Size = 30, Mode3Height = 30, Mode3Back = 0, Mode3RotX = 0, Mode3RotY = 0, Mode3RotZ = 0, Mode3Item = "メインと同期",
        Mode4 = "なし", Mode4Count = 0, Mode4Speed = 1, Mode4Size = 30, Mode4Height = 45, Mode4Back = 0, Mode4RotX = 0, Mode4RotY = 0, Mode4RotZ = 0, Mode4Item = "メインと同期",
        Mode5 = "なし", Mode5Count = 0, Mode5Speed = 1, Mode5Size = 30, Mode5Height = 60, Mode5Back = 0, Mode5RotX = 0, Mode5RotY = 0, Mode5RotZ = 0, Mode5Item = "メインと同期",
    },
    AnimSpeed = 1.0,
    PlotReturn = { Enabled = false, Interval = 30, PlotCFrame = nil},
    GrabMod = { Kill = false, Noclip = false, Spin = false, SuperThrow = false, ThrowPower = 500 },
    Global = { MaxToys = 30, EffectRotation = Vector3.new(0,0,0), IndividualRotation = Vector3.new(0, -90, 0), MoveDelay = false, MoveDelayWeight = 0.05 },
}

-- Deep Copy Helper
local function deepCopy(target)
    local copy = {}
    for k, v in pairs(target) do copy[k] = (type(v) == "table") and deepCopy(v) or v end
    return copy
end

local selectedItemName = "全てのおもちゃ" 
local detectedItems = {}

local cfg = deepCopy(defaultConfig)
local useOtherToys = false
local isEnabled, currentMode, combinedActive = false, "Wing", false
local followMethod = "プレイヤー"
local lastBaseCF = nil
local targetMain, targetSub = LocalPlayer, LocalPlayer    
local autoWidth = true
local activeToys = {}        -- {A0, A1, AP, AO, Part}
local currentMoveVelocity = Vector3.new(0, 0, 0) -- 慣性用の速度変数
local lowLatencyMode = false
local originalCollisions = {} -- {Part: Boolean}
local updateConnection = nil
local isReturningToPlot = false -- Plot帰還中のフラグ（重要）

local targetDecoy = nil
local decoyFollowEnabled = false
local decoyTargetName = ""
local decoyWalkSpeed = 16
local decoyNoclip = false
local decoyFly = false

-- スマホ判定の共通化
local isMobileDevice = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

--------------------------------------------------------------------------------
-- [GPS Minimap 機能] (mapTP.lua と完全一致のロジック)
--------------------------------------------------------------------------------
local MAP_WIDTH = isMobileDevice and 140 or 300
local MAP_HEIGHT = isMobileDevice and 140 or 300
local ZOOM = 250
local curQualIdx = 2
local qualities = { {n="低", s=15}, {n="中", s=25}, {n="高", s=40}, {n="最高", s=60}, {n="極限", s=80}, {n="詳細", s=100} }

local renderConnMap, inputConnMap, playerRemovingConnMap
local tilePool = {}
local otherMarkers = {}
local lastScanPos = Vector3.new(0, 0, 0)
local mapOffset = Vector3.new(0, 0, 0)
local isScanning = false
local mapDisplayMode = "Normal" -- "Normal" or "Height"
local scanVersion = 0
local SHOW_PLAYERS = true
local SHOW_NAMES = true
local SHOW_ICONS = true
local FOLLOW_PLAYER = true
local FOLLOW_TARGET = false
local SHOW_TARGET_ONLY = false
local mapTargetPlayer = nil
local minimapActive = false
local mapContent = nil

local MaterialColors = {
    [Enum.Material.Grass] = Color3.fromRGB(75, 120, 60), [Enum.Material.Sand] = Color3.fromRGB(200, 180, 130),
    [Enum.Material.Water] = Color3.fromRGB(20, 70, 130), [Enum.Material.Rock] = Color3.fromRGB(100, 100, 100),
    [Enum.Material.Basalt] = Color3.fromRGB(50, 50, 50), [Enum.Material.Mud] = Color3.fromRGB(90, 70, 50),
    [Enum.Material.WoodPlanks] = Color3.fromRGB(120, 90, 60), [Enum.Material.Snow] = Color3.fromRGB(240, 240, 240),
    [Enum.Material.Concrete] = Color3.fromRGB(120, 120, 120),
}

local function setupMap()
    if CoreGui:FindFirstChild("GoogleMinimap") then CoreGui.GoogleMinimap:Destroy() end
    tilePool = {}
    otherMarkers = {}
    if renderConnMap then renderConnMap:Disconnect() end
    if inputConnMap then inputConnMap:Disconnect() end
    if playerRemovingConnMap then playerRemovingConnMap:Disconnect() end

    local touches = {} -- ピンチズーム用のタッチ座標管理
    local dragging, isDragging, dragStart, startTime, isMouseOverMap = false, false, nil, 0, false
    local startOffset = Vector3.new(0, 0, 0)
    local pxPerStud = math.max(MAP_WIDTH, MAP_HEIGHT) / (ZOOM * 2)

    local function initGrid()
        local steps = qualities[curQualIdx].s
        for _, t in ipairs(tilePool) do t.Visible = false end
        local frameSizePct = 1 / steps
        local voidColor = Color3.fromRGB(160, 220, 255)
        local tileIdx = 1
        for i = 0, steps - 1 do
            for j = 0, steps - 1 do
                local tile = tilePool[tileIdx]
                if not tile or not tile.Parent then
                    tile = Instance.new("Frame")
                    tile.BorderSizePixel = 0
                    tile.Parent = mapContent
                    tilePool[tileIdx] = tile
                end
                tile.Size = UDim2.new(frameSizePct, 0.6, frameSizePct, 0.6)
                tile.Position = UDim2.new(i * frameSizePct, 0, j * frameSizePct, 0)
                tile.BackgroundColor3 = voidColor
                tile.Visible = true
                tileIdx = tileIdx + 1
            end
        end
    end

    local function scan(force)
        if not force and isScanning then return end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or not root.Parent or not char then return end

        scanVersion = scanVersion + 1
        local currentVersion = scanVersion
        isScanning = true
        local origin = root.Position + mapOffset
        lastScanPos = origin
        local steps = qualities[curQualIdx].s
        local bufferFactor = 2.0
        local stepSize = (ZOOM * 2 * bufferFactor) / steps
        local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude
        local ignore = {char, Workspace.CurrentCamera}
        if CoreGui:FindFirstChild("RobloxGui") then table.insert(ignore, CoreGui.RobloxGui) end

        task.spawn(function()
            local count = 0
            for i = 0, steps - 1 do
                for j = 0, steps - 1 do
                    if currentVersion ~= scanVersion then return end
                    local idx = i * steps + j + 1
                    local tile = tilePool[idx]
                    if tile then
                        local x = (-ZOOM * bufferFactor) + (i * stepSize) + (stepSize / 2)
                        local z = (-ZOOM * bufferFactor) + (j * stepSize) + (stepSize / 2)
                        local rayOrigin = origin + Vector3.new(x, 2000, z)
                        local currentIgnore = {unpack(ignore)}
                        local hitResult = nil
                        for _ = 1, 8 do
                            rp.FilterDescendantsInstances = currentIgnore
                            local hit = Workspace:Raycast(rayOrigin, Vector3.new(0, -100000, 0), rp)
                            if hit and hit.Instance:IsA("BasePart") and hit.Instance.Transparency >= 0.9 then
                                table.insert(currentIgnore, hit.Instance)
                            else
                                hitResult = hit
                                break
                            end
                        end
                        if hitResult and mapDisplayMode == "Height" then
                            local hDiff = hitResult.Position.Y - origin.Y
                            local hIntensity = math.clamp(0.6 * (1 - (hDiff + 50) / 100), 0, 0.6)
                            tile.BackgroundColor3 = Color3.fromHSV(hIntensity, 0.7, 0.8)
                        else
                            tile.BackgroundColor3 = hitResult and (hitResult.Instance:IsA("Terrain") and (MaterialColors[hitResult.Material] or Color3.fromRGB(100, 100, 100)) or hitResult.Instance.Color) or Color3.fromRGB(160, 220, 255)
                        end
                    end
                    count = count + 1
                    if count >= 500 then count = 0; task.wait() end
                end
            end
            if currentVersion == scanVersion then
                isScanning = false
            end
        end)
    end

    local charInit = LocalPlayer.Character
    local rootInit = charInit and charInit:FindFirstChild("HumanoidRootPart")
    lastScanPos = rootInit and (rootInit.Position + mapOffset) or Vector3.new(0, 0, 0)

    local sg = Instance.new("ScreenGui", CoreGui)
    sg.Name = "GoogleMinimap"
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, MAP_WIDTH, 0, MAP_HEIGHT + 30)
    frame.Position = UDim2.new(0, 50, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(160, 220, 255)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.new(0.5, 0.5, 0.5)
    frame.ClipsDescendants = true
    frame.Active = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    mapContent = Instance.new("Frame", frame)
    mapContent.Name = "Tiles"
    mapContent.Size = UDim2.new(2, 0, 2, 0)
    mapContent.Position = UDim2.new(-0.5, 0, -0.5, 0)
    mapContent.BackgroundTransparency = 1

    local dragHandle = Instance.new("Frame", frame)
    dragHandle.Name = "WindowDragHandle"
    dragHandle.Size = UDim2.new(1, 0, 0, 30)
    dragHandle.Position = UDim2.new(0, 0, 1, -30)
    dragHandle.BackgroundColor3 = Color3.new(0, 0, 0)
    dragHandle.BorderSizePixel = 0
    dragHandle.ZIndex = 50
    Instance.new("UICorner", dragHandle).CornerRadius = UDim.new(0, 4)
    local dragLabel = Instance.new("TextLabel", dragHandle)
    dragLabel.Size = UDim2.new(1, 0, 1, 0)
    dragLabel.BackgroundTransparency = 1
    dragLabel.Text = "ここを掴んで移動"
    dragLabel.TextColor3 = Color3.new(1, 1, 1)
    dragLabel.Font = Enum.Font.SourceSansBold
    dragLabel.TextSize = 12
    dragLabel.ZIndex = 51

    local windowDragging, windowDragStart, windowStartPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            windowDragging = true
            windowDragStart = input.Position
            windowStartPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    windowDragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if windowDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - windowDragStart
            frame.Position = UDim2.new(windowStartPos.X.Scale, windowStartPos.X.Offset + delta.X, windowStartPos.Y.Scale, windowStartPos.Y.Offset + delta.Y)
        end
    end)

    local entityLayer = Instance.new("Frame", frame)
    entityLayer.Size = UDim2.new(1, 0, 1, 0)
    entityLayer.BackgroundTransparency = 1
    entityLayer.ZIndex = 10

    frame.MouseEnter:Connect(function() isMouseOverMap = true end)
    frame.MouseLeave:Connect(function() isMouseOverMap = false end)

    local modeBtn = Instance.new("TextButton", frame)
    modeBtn.Size = UDim2.new(0, 80, 0, 25)
    modeBtn.Position = UDim2.new(1, -85, 0, 5)
    modeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    modeBtn.TextColor3 = Color3.new(1, 1, 1)
    modeBtn.ZIndex = 20
    modeBtn.Font = Enum.Font.SourceSansBold
    modeBtn.TextSize = 12
    Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 4)

    local function updateMapButtons()
        if FOLLOW_PLAYER then
            modeBtn.Text = "追従: 自分"
        elseif FOLLOW_TARGET then
            modeBtn.Text = "追従: 対象"
        else
            modeBtn.Text = "モード: 自由"
        end
    end
    updateMapButtons()

    modeBtn.MouseButton1Click:Connect(function()
        if FOLLOW_PLAYER then
            FOLLOW_PLAYER = false
            FOLLOW_TARGET = true
        elseif FOLLOW_TARGET then
            FOLLOW_TARGET = false
            FOLLOW_PLAYER = false
        else
            FOLLOW_PLAYER = true
            FOLLOW_TARGET = false
        end
        updateMapButtons()
        if FOLLOW_PLAYER or FOLLOW_TARGET then
            mapOffset = Vector3.new(0, 0, 0)
            scan(true)
        end
    end)

    local qualityBtn = Instance.new("TextButton", frame)
    qualityBtn.Size = UDim2.new(0, 80, 0, 25)
    qualityBtn.Position = UDim2.new(1, -85, 0, 35)
    qualityBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    qualityBtn.TextColor3 = Color3.new(1, 1, 1)
    qualityBtn.Text = "画質: " .. qualities[curQualIdx].n
    qualityBtn.ZIndex = 20
    qualityBtn.Font = Enum.Font.SourceSansBold
    qualityBtn.TextSize = 12
    Instance.new("UICorner", qualityBtn).CornerRadius = UDim.new(0, 4)
    qualityBtn.MouseButton1Click:Connect(function()
        curQualIdx = (curQualIdx % #qualities) + 1
        if UIElements.MapQualityDropdown then UIElements.MapQualityDropdown:Set(qualities[curQualIdx].n) end
        setupMap()
    end)

    local meContainer = Instance.new("Frame", frame)
    meContainer.Size = UDim2.new(0, 20, 0, 20)
    meContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    meContainer.BackgroundTransparency = 1
    meContainer.ZIndex = 100
    local me = Instance.new("ImageLabel", meContainer)
    me.Size = UDim2.new(1, 0, 1, 0)
    me.BackgroundTransparency = 1
    me.Image = "rbxassetid://81889066747907"
    me.ImageColor3 = Color3.fromRGB(255, 0, 0)
    me.ZIndex = 100
    local myNameLbl = Instance.new("TextLabel", meContainer)
    myNameLbl.Size = UDim2.new(0, 150, 0, 15)
    myNameLbl.Position = UDim2.new(0.5, -75, 0, -18)
    myNameLbl.Text = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")"
    myNameLbl.TextColor3 = Color3.new(1, 0.3, 0.3)
    myNameLbl.BackgroundTransparency = 1
    myNameLbl.Font = Enum.Font.SourceSansBold
    myNameLbl.TextSize = 11
    myNameLbl.ZIndex = 101
    local myStroke = Instance.new("UIStroke", myNameLbl)
    myStroke.Thickness = 1.5
    myStroke.Transparency = 0.2
    myStroke.Color = Color3.new(0, 0, 0)

    initGrid()
    renderConnMap = RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local focusRoot = root
        if FOLLOW_TARGET and mapTargetPlayer and mapTargetPlayer.Character then
            local tRoot = mapTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if tRoot then focusRoot = tRoot end
        end

        if FOLLOW_PLAYER or FOLLOW_TARGET then mapOffset = Vector3.new(0, 0, 0) end

        pxPerStud = math.max(MAP_WIDTH, MAP_HEIGHT) / (ZOOM * 2)
        local currentCenter = focusRoot.Position + mapOffset
        local diff = currentCenter - lastScanPos
        mapContent.Position = UDim2.new(-0.5, -diff.X * pxPerStud, -0.5, -diff.Z * pxPerStud)

        me.Rotation = -root.Orientation.Y
        local myDelta = root.Position - currentCenter
        local myRelX = 0.5 + (myDelta.X / (ZOOM * 2))
        local myRelZ = 0.5 + (myDelta.Z / (ZOOM * 2))
        meContainer.Position = UDim2.new(myRelX, 0, myRelZ, 0)
        meContainer.Visible = (math.abs(myDelta.X) <= ZOOM and math.abs(myDelta.Z) <= ZOOM)

        if (currentCenter - lastScanPos).Magnitude > 25 then scan() end

        entityLayer.Visible = true
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local tRoot = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                local isTarget = (p == mapTargetPlayer)
                local displayThis = SHOW_PLAYERS and (not SHOW_TARGET_ONLY or isTarget)
                if displayThis and tRoot and tRoot.Parent then
                    local delta = tRoot.Position - currentCenter
                    if math.abs(delta.X) < ZOOM and math.abs(delta.Z) < ZOOM then
                        local mData = otherMarkers[p.Name]
                        if not mData then
                            local c = Instance.new("Frame", entityLayer)
                            c.Size = UDim2.new(0, 24, 0, 24)
                            c.BackgroundTransparency = 1
                            c.AnchorPoint = Vector2.new(0.5, 0.5)
                            local icon = Instance.new("ImageLabel", c)
                            icon.Size = UDim2.new(0, 14, 0, 14)
                            icon.Position = UDim2.new(0.5, 0, 0.5, 0)
                            icon.AnchorPoint = Vector2.new(0.5, 0.5)
                            icon.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=48&h=48", p.UserId)
                            icon.BackgroundColor3 = Color3.fromRGB(30,30,30)
                            icon.ZIndex = 12
                            Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
                            local tri = Instance.new("ImageLabel", c)
                            tri.Size = UDim2.new(0, 22, 0, 22)
                            tri.Position = UDim2.new(0.5, 0, 0.5, 0)
                            tri.AnchorPoint = Vector2.new(0.5, 0.5)
                            tri.Image = "rbxasset://textures/ui/ArrowUp.png"
                            tri.ImageColor3 = Color3.fromRGB(0, 230, 255)
                            tri.BackgroundTransparency = 1
                            tri.ZIndex = 11
                            local nLbl = Instance.new("TextLabel", c)
                            nLbl.Size = UDim2.new(0, 120, 0, 12)
                            nLbl.Position = UDim2.new(0.5, 0, 0, -14)
                            nLbl.AnchorPoint = Vector2.new(0.5, 0.5)
                            nLbl.Text = p.DisplayName .. " (@" .. p.Name .. ")"
                            nLbl.TextColor3 = Color3.new(1, 1, 1)
                            nLbl.BackgroundTransparency = 1
                            nLbl.Font = Enum.Font.SourceSansBold
                            nLbl.TextSize = 11
                            nLbl.ZIndex = 13
                            local s = Instance.new("UIStroke", nLbl)
                            s.Thickness = 1.2
                            s.Color = Color3.new(0, 0, 0)
                            s.Transparency = 0.3
                            mData = {Container = c, Triangle = tri, Icon = icon, NameLabel = nLbl}
                            otherMarkers[p.Name] = mData
                        end
                        mData.Container.Visible = true
                        mData.Icon.Visible = SHOW_ICONS
                        mData.Triangle.Visible = SHOW_ICONS
                        mData.NameLabel.Visible = SHOW_NAMES
                        mData.Container.Position = UDim2.new(0.5 + (delta.X/(ZOOM*2)), 0, 0.5 + (delta.Z/(ZOOM*2)), 0)
                        mData.Triangle.Rotation = -tRoot.Orientation.Y
                    elseif otherMarkers[p.Name] then
                        otherMarkers[p.Name].Container.Visible = false
                    end
                elseif otherMarkers[p.Name] then
                    otherMarkers[p.Name].Container.Visible = false
                end
            end
        end
    end)
    playerRemovingConnMap = Players.PlayerRemoving:Connect(function(p)
        if otherMarkers[p.Name] then
            otherMarkers[p.Name].Container:Destroy()
            otherMarkers[p.Name] = nil
        end
    end)
    frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isMouseOverMap then
            if input.UserInputType == Enum.UserInputType.Touch then touches[input] = input.Position end
            local pos = input.Position
            local relY = (pos.Y - frame.AbsolutePosition.Y) / frame.AbsoluteSize.Y
            if relY > (MAP_HEIGHT / frame.AbsoluteSize.Y) then return end
            dragging = true
            dragStart = input.Position
            startOffset = mapOffset
            startTime = tick()
            isDragging = false
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then touches[input] = nil end
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            if not isDragging and (tick() - startTime) < 0.3 then
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local pos = input.Position
                local relX = (pos.X - frame.AbsolutePosition.X) / frame.AbsoluteSize.X
                local relY = (pos.Y - frame.AbsolutePosition.Y) / frame.AbsoluteSize.Y
                if relX >= 0 and relX <= 1 and relY >= 0 and relY <= (MAP_HEIGHT / frame.AbsoluteSize.Y) then
                    local dx, dz = (relX - 0.5) * (ZOOM * 2), (relY - 0.5) * (ZOOM * 2)
                    local targetPos = root.Position + mapOffset + Vector3.new(dx, 500, dz)
                    local hit = Workspace:Raycast(targetPos, Vector3.new(0, -1000, 0))
                    root.CFrame = CFrame.new(targetPos.X, hit and hit.Position.Y + 5 or root.Position.Y, targetPos.Z)
                    mapOffset = Vector3.new(0,0,0)
                    task.wait(0.2)
                    scan()
                end
            end
        end
    end)
    inputConnMap = UserInputService.InputChanged:Connect(function(input)
        -- ピンチズーム処理
        if input.UserInputType == Enum.UserInputType.Touch then
            touches[input] = input.Position
            local t = {}
            for _, pos in pairs(touches) do table.insert(t, pos) end
            if #t == 2 then
                local dist = (t[1] - t[2]).Magnitude
                if lastPinchDist then
                    local change = dist - lastPinchDist
                    ZOOM = math.clamp(ZOOM - (change * (ZOOM / 100)), 50, 1500)
                    if UIElements.MapZoomSlider then UIElements.MapZoomSlider:Set(ZOOM) end
                    scan()
                end
                lastPinchDist = dist
            end
        elseif dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then isDragging = true end
            if isDragging then
                FOLLOW_PLAYER = false
                modeBtn.Text = "モード: 自由"
                mapOffset = startOffset + Vector3.new(-delta.X * (ZOOM * 2 / math.max(MAP_WIDTH, MAP_HEIGHT)), 0, -delta.Y * (ZOOM * 2 / math.max(MAP_WIDTH, MAP_HEIGHT)))
            end
        elseif input.UserInputType == Enum.UserInputType.MouseWheel then
            if not isMouseOverMap then return end
            local isCtrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
            if isCtrl then
                MAP_WIDTH = math.clamp(MAP_WIDTH + (input.Position.Z * 20), 100, 1000)
                MAP_HEIGHT = math.clamp(MAP_HEIGHT + (input.Position.Z * 20), 100, 1000)
                frame.Size = UDim2.new(0, MAP_WIDTH, 0, MAP_HEIGHT + 30)
            else
                ZOOM = math.clamp(ZOOM - (input.Position.Z * 20), 50, 1500)
                scan()
            end
        end
    end)
    scan(true)
end

-- YouDecoyモデルを検索する共通ヘルパー関数
local function getAllYouDecoys()
    local decoys = {}
    local allPossibleDecoyContainers = {}

    for _, folder in ipairs(Workspace:GetChildren()) do
        if folder.Name:match("SpawnedInToys$") then
            table.insert(allPossibleDecoyContainers, folder)
        end
    end
    table.insert(allPossibleDecoyContainers, Workspace)

    for _, container in ipairs(allPossibleDecoyContainers) do
        for _, item in ipairs(container:GetChildren()) do
            if item.Name == "YouDecoy" and item:IsA("Model") then
                -- 常に他人のおもちゃも対象とする（固定設定）
                table.insert(decoys, item)
            end
        end
    end
    return decoys
end

-- ジャイロ用物理変数
local gyroInnerAngularVelocity = 0
local gyroInnerAngle = 0
local lastUpdateTick = 0

local espCache = {}
local espCfg = { Enabled = false, Names = true, Tracers = false, Hitbox = false, HitboxSize = 10, ESPColor = Color3.new(1, 0, 0), TargetOnly = false }

-- プレイヤー設定用変数
local walkSpeed = 16
local jumpPower = 25
local infiniteJump = false
local useWalkSpeed = false
local useJumpPower = false
local antiExplosion = false
local noclip = false
local antiFire = false
local antiGrab = false
local counterMode = "Repulsion"
_G.AutoAttacker = false
_G.AntiKickToy = false
_G.DeathAura = false
_G.AttractionAura = false
_G.FlingAura = false
_G.FlingStrength = 400
_G.FlingTarget = "プレイヤー"

--------------------------------------------------------------------------------
-- [計算ロジック] 各モードの座標計算
--------------------------------------------------------------------------------
local function getPositionForMode(mode, i, count, time, override)
    local c = override or cfg[mode] or cfg.Wing
    
    -- iは1からcountまで。比率を計算
    local ratio = (i-1) / (count > 1 and count-1 or 1)
    
    if mode == "Wing" then
    local side, idx, totalSide

    if combinedActive then
        -- 【合体モード】
        -- i は全体の通し番号(1,2,3,4...)なので、そのまま奇数/偶数で分ける
        side = (i % 2 == 1) and -1 or 1 -- 1->左(-1), 2->右(1)
        idx = math.ceil(i / 2)          -- 1,2番目は1段目、3,4番目は2段目...
        totalSide = math.ceil(count / 2)
    else
        -- 【単体モード】
        -- 自分のパーツ内での順番通りに並べる
        side = (i % 2 == 1) and -1 or 1
        idx = math.ceil(i / 2)
        totalSide = math.ceil(count / 2)
    end

    -- 以降の計算は共通
    local distRatio = (totalSide > 1) and (idx - 1) / (totalSide - 1) or 0
    
    local flapPhase = time * c.Speed
    if c.Joints > 0 then
        flapPhase = flapPhase - (idx * (0.5 / math.max(1, c.Joints)))
    end

    local flap = math.sin(flapPhase) * c.Strength
    if c.RootFixed then
        flap = flap * distRatio
    end
    
    local horizontalOffset = c.Gap + (c.Size * distRatio)
    local pos = Vector3.new(horizontalOffset * side, flap, 0)
    
    local rotCF = CFrame.Angles(
        math.rad(c.Tilt), 
        math.rad(c.V_Angle * side), 
        0
    )

    -- カーブ（反り）の計算：羽ばたきに連動させる
    if c.Curve then
        local curve_amount = c.CurveAmount or 10
        -- 羽ばたきの現在の位相（-1から1）を取得
        local flap_ratio = math.sin(flapPhase)
        -- 羽ばたきの上下両方で、先端にいくほど強く反る角度を計算
        local soar_angle = math.rad(flap_ratio * curve_amount * distRatio)
        -- 翼の根元を軸に回転させることで「反り」を表現
        rotCF = rotCF * CFrame.Angles(0, 0, soar_angle * side)
    end
    
    return (rotCF * pos) + Vector3.new(0, c.Height, c.Back), distRatio
        
    elseif mode == "Heart" then
        local t = (ratio * math.pi * 2) + time * c.Speed
        local x = 16 * math.sin(t)^3
        local y = 13 * math.cos(t) - 5 * math.cos(2*t) - 2 * math.cos(3*t) - math.cos(4*t)
        return Vector3.new(x * c.Size * 0.1, y * c.Size * 0.1 + c.Height, c.Back)

    elseif mode == "Star" then
        -- 綺麗な五芒星を描くためのロジック（直線補間）
        local totalPoints = 10 -- 5つの頂点 + 5つの谷
        -- アニメーション進行度
        local cycle = (time * c.Speed * 0.2 + ratio) % 1
        local currentStep = cycle * totalPoints
        
        local idx1 = math.floor(currentStep)
        local idx2 = (idx1 + 1) % totalPoints
        local alpha = currentStep % 1 -- 2点間のどこにいるか

        -- 星の頂点座標を計算するローカル関数
        local function getStarPoint(i)
            -- 36度ずつ回転、+90度で頂点を真上に
            local theta = math.rad(i * 36 + 90) 
            -- 偶数は外側(Size)、奇数は内側(Size * 0.382 -> 黄金比に近い鋭さ)
            local r = (i % 2 == 0) and c.Size or (c.Size * 0.382)
            -- Xを反転させると時計回り/反時計回りが調整可能（ここではそのまま）
            return Vector2.new(-math.cos(theta) * r, math.sin(theta) * r)
        end

        local p1 = getStarPoint(idx1)
        local p2 = getStarPoint(idx2)
        
        -- 丸みを消すため、計算した2点間を直線で結ぶ(Lerp)
        local p = p1:Lerp(p2, alpha)

        -- Heartモードと同じ向き（垂直）にする
        -- X=横幅, Y=高さ(縦幅), Z=奥行き(固定)
        return Vector3.new(p.X, p.Y + c.Height, c.Back)
        
    elseif mode == "Vortex" then
        -- 平らな渦
        local spiral = (i / count) * math.pi * 4 + time * c.Speed
        local dist = (i / count) * c.Size
        
        local x = math.cos(spiral) * dist
        local z = math.sin(spiral) * dist
        
        return Vector3.new(x, c.Height, z + c.Back)
        
    elseif mode == "Sphere" then
        -- 球体配置
        local phi = math.acos(-1 + (2 * i) / count)
        local theta = math.sqrt(count * math.pi) * phi + time * c.Speed
        
        local x = c.Size * math.cos(theta) * math.sin(phi)
        local y = c.Size * math.sin(theta) * math.sin(phi)
        local z = c.Size * math.cos(phi)
        
        return Vector3.new(x, y + c.Height, z + c.Back)

    elseif mode == "Rotate" or mode == "MagicCircle" then
    -- 回転・八卦：星形または円
    local shape = (mode == "MagicCircle" and (i % 2 == 0)) and Paths.Star or Paths.Circle
    local speed = c.Speed
    local totalPoints = #shape
    
    -- ★完全に書き直し
    local cycle = (time * speed * 0.1 + ratio) % 1
    local currentStep = cycle * totalPoints
    
    local idx1 = math.floor(currentStep) % totalPoints + 1
    local idx2 = (math.floor(currentStep) + 1) % totalPoints + 1
    local alpha = currentStep % 1
    
    -- 安全なLerp
    local p1 = shape[idx1]
    local p2 = shape[idx2]
    if not p1 or not p2 then return Vector3.zero end
    
    local p = p1:Lerp(p2, alpha)
    
    -- Y軸回転を追加
    local rotAngle = time * speed * 0.3
    local rotX = p.X * math.cos(rotAngle) - p.Y * math.sin(rotAngle)
    local rotY = p.X * math.sin(rotAngle) + p.Y * math.cos(rotAngle)
    
    local waveY = 0
    if c.Wave then
        waveY = math.sin(time * (c.WaveSpeed or 2) + i * 0.5) * (c.WaveAmp or 2)
    end
    
    return Vector3.new(rotX * c.Size, c.Height + waveY, rotY * c.Size + c.Back)

elseif mode == "MagicCircle2" then
    -- 画像1のような放射状の魔法陣
    local totalPoints = #Paths.MagicCircle2
    local cycle = (time * c.Speed * 0.05 + ratio) % 1
    local currentStep = cycle * totalPoints
    
    local idx1 = math.floor(currentStep) % totalPoints + 1
    local idx2 = (math.floor(currentStep) + 1) % totalPoints + 1
    local alpha = currentStep % 1
    
    local p1 = Paths.MagicCircle2[idx1]
    local p2 = Paths.MagicCircle2[idx2]
    if not p1 or not p2 then return Vector3.zero end
    
    local p = p1:Lerp(p2, alpha)
    
    -- Y軸回転
    local rotAngle = time * c.Speed * 0.2
    local rotX = p.X * math.cos(rotAngle) - p.Y * math.sin(rotAngle)
    local rotZ = p.X * math.sin(rotAngle) + p.Y * math.cos(rotAngle)
    
    -- 上下の波動
    local wave = math.sin(time * c.Speed + i * 0.5) * 0.5
    
    return Vector3.new(rotX * c.Size, c.Height + wave, rotZ * c.Size + c.Back)

elseif mode == "MagicCircle3" then
    -- 画像2のような垂直ビーム風の魔法陣
    local totalPoints = #Paths.MagicCircle3
    local cycle = (time * c.Speed * 0.03 + ratio) % 1
    local currentStep = cycle * totalPoints
    
    local idx1 = math.floor(currentStep) % totalPoints + 1
    local idx2 = (math.floor(currentStep) + 1) % totalPoints + 1
    local alpha = currentStep % 1
    
    local p1 = Paths.MagicCircle3[idx1]
    local p2 = Paths.MagicCircle3[idx2]
    if not p1 or not p2 then return Vector3.zero end
    
    local p = p1:Lerp(p2, alpha)
    
    -- ゆっくり回転
    local rotAngle = time * c.Speed * 0.1
    local rotX = p.X * math.cos(rotAngle) - p.Y * math.sin(rotAngle)
    local rotZ = p.X * math.sin(rotAngle) + p.Y * math.cos(rotAngle)
    
    return Vector3.new(rotX * c.Size, c.Height, rotZ * c.Size + c.Back)

    elseif mode == "Pet" then
        -- 設定から各種パラメータを取得
        local petCountSetting = cfg.Pet.Count or 2
        local totalFws = count -- 使用可能な全花火数
        
        -- 1体あたりの花火数を計算
        local fwsPerPet = math.floor(totalFws / petCountSetting)
        if fwsPerPet < 1 then fwsPerPet = 1 end

        -- 現在の花火(i)が、何体目のペットの、何番目のパーツか
        local petIndex = math.ceil(i / fwsPerPet)
        local partIndexInPet = (i - 1) % fwsPerPet 
        
        -- 指定したペット数を超える余り花火は非表示
        if petIndex > petCountSetting then
            return Vector3.new(0, -1000, 0)
        end

        -- パーツの役割分担 (0:体, 1:左羽, 2:右羽)
        local role = 0 
        local sideIndex = 0
        if partIndexInPet == 0 then
            role = 0 -- 最初の1個は体
        elseif partIndexInPet <= math.ceil((fwsPerPet - 1) / 2) then
            role = 1 -- 左羽
            sideIndex = partIndexInPet
        else
            role = 2 -- 右羽
            sideIndex = partIndexInPet - math.ceil((fwsPerPet - 1) / 2)
        end

        -- ペット自体の配置（Gapを使用して間隔を調整）
        local petSide = (petIndex % 2 == 0) and 1 or -1
        local horizontalOffset = (c.Gap or 5) + (math.floor((petIndex - 1) / 2) * 8)
        
        -- 共通の浮遊ムーブ
        local hover = math.sin(time * c.Speed) * 1.2
        local bob = math.cos(time * c.Speed * 0.5) * 1
        
        local basePos = Vector3.new(
            petSide * horizontalOffset,
            c.Height + hover,
            c.Back + bob
        )

        if role == 0 then
            return basePos
        else
            -- 羽の計算
            local wingSide = (role == 1) and -1 or 1
            
            -- ★ここを修正：c.Size を羽の広がり（幅）に直接反映
            -- sideIndex（羽の中のパーツ番号）に比例して、c.Sizeの分だけ外に広がります
            local wingSpread = (sideIndex * (c.Size * 0.1)) 
            
            local flapPhase = time * c.Speed * 3 - (sideIndex * 0.3)
            local flap = math.sin(flapPhase) * 2
            
            local jointFactor = (c.Joints or 3) * 0.2
            
            return basePos + Vector3.new(
                wingSide * (1 + jointFactor + wingSpread), -- c.Sizeがここにかかる
                flap * (1 + jointFactor),
                -0.5 + (sideIndex * 0.1)
            )
        end

    elseif mode == "FloatStone" then
        -- アニメーションの「カオス展開」の動きを計算に導入
        local rTime = time * cfg[mode].Speed
        local spread = cfg[mode].Size
        
        -- 複数の正弦波を組み合わせて不規則な軌道を生成
        local x = math.cos(rTime + i * 1.5) * spread
        local y = math.sin(rTime * 0.7 + i) * (spread * 0.5) + cfg[mode].Height
        local z = math.sin(rTime * 1.2 + i * 2.2) * spread + cfg[mode].Back
        
        return Vector3.new(x, y, z)

-- [Textモードの計算ロジック抜粋] 

    elseif mode == "Text" then
        local str = cfg.Text.Content
        local chars = {}
        for char in str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
            table.insert(chars, char)
        end
        local numChars = #chars
        if numChars == 0 then return Vector3.zero end
    
        local fwsPerChar = math.max(1, math.floor(count / numChars))
        local charIndex = math.clamp(math.ceil(i / fwsPerChar), 1, numChars)
    
        local charStr = chars[charIndex]
        local path = Paths.Alpha[charStr:upper()] or Paths.Alpha[" "]
        
        -- アニメーション計算
        local totalPoints = #path
        local speed = math.max(1, math.floor(c.Speed)) * 0.5
        local cycle = (time * speed + (i % fwsPerChar) * 0.1) % 2 
        local tP = (cycle < 1) and (cycle * (totalPoints - 1)) or ((2 - cycle) * (totalPoints - 1))
        local idx1 = math.floor(tP) + 1
        local idx2 = math.min(idx1 + 1, totalPoints)
        local p = path[idx1]:Lerp(path[idx2] or path[idx1], tP % 1)
        
        -- ★ 文字間隔の自動調節
        -- サイズ(c.Size)が大きくなれば間隔(spacing)も広がるように設定
        local charSizeScale = c.Size * 0.4
        local spacing = c.Size * 1.2 -- 1.2倍の間隔で自動調整
        local totalWidth = (numChars - 1) * spacing
        
        -- 配置計算 (反転なし、常に正面)
        local xPos = p.X * charSizeScale * -1 -- 文字の形が正しく見える向き
        local yPos = p.Y * charSizeScale
        local xOffset = ((charIndex - 1) * spacing - (totalWidth / 2)) * -1
        
        return Vector3.new(xOffset + xPos, yPos + c.Height, -c.Back)

    elseif mode == "Merkaba" then
        -- マカバ：3D回転
        local totalP = #Paths.Merkaba
        local tP = (time * c.Speed + ratio * totalP) % totalP
        local p1 = Paths.Merkaba[math.floor(tP) + 1]
        local p2 = Paths.Merkaba[(math.floor(tP) % totalP) + 1]
        
        local p = p1:Lerp(p2, tP % 1) * c.Size
        
        -- 複雑な3軸回転
        local rot = CFrame.Angles(time, time * 1.5, 0)
        return (rot * p) + Vector3.new(0, c.Height + math.sin(time * 2), c.Back)

    elseif mode == "Cube" then
        -- 立方体の頂点定義
        local size = c.Size
        local v = {
            Vector3.new(size, size, size),      -- 1: 右上前
            Vector3.new(-size, size, size),     -- 2: 左上前
            Vector3.new(size, -size, size),     -- 3: 右下前
            Vector3.new(-size, -size, size),    -- 4: 左下前
            Vector3.new(size, size, -size),     -- 5: 右上後
            Vector3.new(-size, size, -size),    -- 6: 左上後
            Vector3.new(size, -size, -size),    -- 7: 右下後
            Vector3.new(-size, -size, -size)    -- 8: 左下後
        }

        -- ■ 変更点: 「辺」ではなく「面（4頂点のループ）」を定義
        local faces = {
            {v[1], v[2], v[4], v[3]}, -- 前面ループ
            {v[5], v[6], v[8], v[7]}, -- 背面ループ
            {v[1], v[5], v[6], v[2]}, -- 上面ループ
            {v[3], v[7], v[8], v[4]}, -- 底面ループ
            {v[1], v[5], v[7], v[3]}, -- 右面ループ
            {v[2], v[6], v[8], v[4]}  -- 左面ループ
        }

        local numFaces = #faces
        
        -- 1. おもちゃを6つの面に順番に割り振る
        local faceIdx = ((i - 1) % numFaces) + 1
        local currentFace = faces[faceIdx]

        -- 2. 進行具合の計算 (周回ループ)
        local speed = c.Speed * 0.5 
        -- おもちゃごとに位置をずらす (i * 0.25) ことで重なりを防ぐ
        local totalProgress = (time * speed) + (i * 0.25)
        
        -- 3. 現在どの辺(0~3)にいるか、その辺のどこ(0.0~1.0)にいるか
        local edgeIndex = math.floor(totalProgress) % 4 + 1
        local nextEdgeIndex = (edgeIndex % 4) + 1 -- 次の頂点
        local alpha = totalProgress % 1 -- 辺の上の進捗 (0.0 -> 1.0)

        -- 4. 座標を計算
        local p1 = currentFace[edgeIndex]
        local p2 = currentFace[nextEdgeIndex]
        
        local pos = p1:Lerp(p2, alpha)
        
        return pos + Vector3.new(0, c.Height, c.Back)

    elseif mode == "Pyramid" then
        local s = c.Size
        -- ピラミッドの頂点定義
        local top = Vector3.new(0, s, 0)
        local fl = Vector3.new(-s, -s, s)  -- 前左
        local fr = Vector3.new(s, -s, s)   -- 前右
        local br = Vector3.new(s, -s, -s)  -- 後右
        local bl = Vector3.new(-s, -s, -s) -- 後左
        
        -- 面（頂点のループ）を定義
        local faces = {
            {top, fl, fr}, -- 前面
            {top, fr, br}, -- 右面
            {top, br, bl}, -- 後面
            {top, bl, fl}, -- 左面
            {fl, fr, br, bl} -- 底面
        }
        
        local numFaces = #faces
        local faceIdx = ((i - 1) % numFaces) + 1
        local currentFace = faces[faceIdx]
        local numVerts = #currentFace
        
        local speed = c.Speed * 0.5
        local totalProgress = (time * speed) + (i * 0.25)
        
        local edgeIndex = math.floor(totalProgress) % numVerts + 1
        local nextEdgeIndex = (edgeIndex % numVerts) + 1
        local alpha = totalProgress % 1
        
        local p1 = currentFace[edgeIndex]
        local p2 = currentFace[nextEdgeIndex]
        
        return p1:Lerp(p2, alpha) + Vector3.new(0, c.Height, c.Back)

    elseif mode == "MirrorPlayer" then
        local char = targetMain.Character
        if not char then return Vector3.new(0,0,0) end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return Vector3.new(0,0,0) end

        -- 1. R6パーツ定義（サイズと名前をセット）
        local bodyParts = {
            { name = "Head",      size = Vector3.new(1.2, 1.2, 1.2) },
            { name = "Torso",     size = Vector3.new(2, 2, 1) },
            { name = "Left Arm",  size = Vector3.new(1, 2, 1) },
            { name = "Right Arm", size = Vector3.new(1, 2, 1) },
            { name = "Left Leg",  size = Vector3.new(1, 2, 1) },
            { name = "Right Leg", size = Vector3.new(1, 2, 1) }
        }

        local toysPerPart = math.max(1, math.floor(count / #bodyParts))
        local partIdx = math.min(math.ceil(i / toysPerPart), #bodyParts)
        local localIdx = ((i - 1) % toysPerPart) + 1
        local data = bodyParts[partIdx]
        
        -- 対象の部位を特定
        local targetPart = char:FindFirstChild(data.name) or root

        -- 2. サイズと形状の計算（ここはおもちゃの形を作る）
        local s = data.size * c.Size * 0.5
        local t = (time * c.Speed) % 4
        local step = t % 1
        local edge = math.floor(t)
        local faceIdx = (localIdx - 1) % 6
        local p = Vector3.new(0,0,0)

        if faceIdx == 0 then p = (edge==0 and Vector3.new(-s.X+s.X*2*step,-s.Y,s.Z) or edge==1 and Vector3.new(s.X,-s.Y+s.Y*2*step,s.Z) or edge==2 and Vector3.new(s.X-s.X*2*step,s.Y,s.Z) or Vector3.new(-s.X,s.Y-s.Y*2*step,s.Z))
        elseif faceIdx == 1 then p = (edge==0 and Vector3.new(-s.X+s.X*2*step,-s.Y,-s.Z) or edge==1 and Vector3.new(s.X,-s.Y+s.Y*2*step,-s.Z) or edge==2 and Vector3.new(s.X-s.X*2*step,s.Y,-s.Z) or Vector3.new(-s.X,s.Y-s.Y*2*step,-s.Z))
        elseif faceIdx == 2 then p = (edge==0 and Vector3.new(s.X,-s.Y,-s.Z+s.Z*2*step) or edge==1 and Vector3.new(s.X,-s.Y+s.Y*2*step,s.Z) or edge==2 and Vector3.new(s.X,s.Y,s.Z-s.Z*2*step) or Vector3.new(s.X,s.Y-s.Y*2*step,-s.Z))
        elseif faceIdx == 3 then p = (edge==0 and Vector3.new(-s.X,-s.Y,-s.Z+s.Z*2*step) or edge==1 and Vector3.new(-s.X,-s.Y+s.Y*2*step,s.Z) or edge==2 and Vector3.new(-s.X,s.Y,s.Z-s.Z*2*step) or Vector3.new(-s.X,s.Y-s.Y*2*step,-s.Z))
        elseif faceIdx == 4 then p = (edge==0 and Vector3.new(-s.X+s.X*2*step,s.Y,-s.Z) or edge==1 and Vector3.new(s.X,s.Y,-s.Z+s.Z*2*step) or edge==2 and Vector3.new(s.X-s.X*2*step,s.Y,s.Z) or Vector3.new(-s.X,s.Y,s.Z-s.Z*2*step))
        else p = (edge==0 and Vector3.new(-s.X+s.X*2*step,-s.Y,-s.Z) or edge==1 and Vector3.new(s.X,-s.Y,-s.Z+s.Z*2*step) or edge==2 and Vector3.new(s.X-s.X*2*step,-s.Y,s.Z) or Vector3.new(-s.X,-s.Y,s.Z-s.Z*2*step)) end

        -- 3. 【これが「位置」を直す魔法の式】
        -- 自分の各部位が「RootPartから見てどこにいるか」というオフセットを計算
        -- PointToObjectSpace を使うことで、エモート等でズレた位置も自動計算されます
        local partRelativePos = root.CFrame:PointToObjectSpace(targetPart.Position)
        
        -- 背後距離(Back)と高さ(Height)のオフセット
        local extraOffset = Vector3.new(0, c.Height, -c.Back)
        
        -- 回転情報を適用（部位が傾けばおもちゃの枠も傾く）
        local rotatedBoxPoint = (root.CFrame:Inverse() * targetPart.CFrame).Rotation * p

        -- 全部を足して返す
        -- [部位の相対位置] + [一筆書きの頂点] + [ユーザー設定のズレ]
        return partRelativePos + rotatedBoxPoint + extraOffset

    elseif mode == "Beam" then
        -- Y方向の光の柱
        local ang = (i % c.Count) * (math.pi * 2 / c.Count)
        local radius = c.Size * 0.3
        
        -- 円周配置
        local x = math.cos(ang) * radius
        local z = math.sin(ang) * radius
        
        -- Y軸高速往復
        local yOsc = math.sin(time * c.Speed + (i / count) * math.pi * 2)
        local y = yOsc * c.Size
        
        return Vector3.new(x, y + c.Height, z + c.Back)

    elseif mode == "BackGuard" then
        local spread = c.Size
    
         -- 各石のランダム位置(固定シードで再現性確保)
        local seed = i * 123.456
        local randomX = (math.sin(seed) * 2 - 1) * spread  -- 左右にバラバラ
        local randomY = (math.cos(seed * 1.3) * 2 - 1) * (spread * 0.3) + c.Height  -- 上下にバラバラ
    
        -- 後ろ側に配置
        local backDistance = c.Back + math.abs(math.sin(seed * 0.7)) * spread * 0.5
    
        -- 微妙な浮遊動作
        local hover = math.sin(time * c.Speed + i * 0.5) * 0.5
    
        return Vector3.new(randomX, randomY + hover, -backDistance)

    elseif mode == "Tornado" then
        local r1 = c.Radius or 5
        local r2 = c.TopRadius or 20
        local h = c.Size -- Sizeを高さとして使用
        local ratio = (i - 1) / (count > 1 and count - 1 or 1)
        local currentR = r1 + (r2 - r1) * ratio
        local currentH = h * ratio

        if c.Pyramid then
            -- 四角形の経路
            local totalProgress = (time * c.Speed * 0.2) + (ratio * 4)
            local side = math.floor(totalProgress) % 4
            local progressOnSide = totalProgress % 1
            
            local x, z
            if side == 0 then -- 上
                x = -currentR + (currentR * 2 * progressOnSide)
                z = currentR
            elseif side == 1 then -- 右
                x = currentR
                z = currentR - (currentR * 2 * progressOnSide)
            elseif side == 2 then -- 下
                x = currentR - (currentR * 2 * progressOnSide)
                z = -currentR
            else -- 左
                x = -currentR
                z = -currentR + (currentR * 2 * progressOnSide)
            end
            return Vector3.new(x, currentH + c.Height, z + c.Back)
        else
            local theta = time * c.Speed + ratio * math.pi * 4
            return Vector3.new(math.cos(theta) * currentR, currentH + c.Height, math.sin(theta) * currentR + c.Back)
        end

    elseif mode == "Gyro" then
        local outerLimit = math.ceil(count * 0.5)
        local innerLimit = math.ceil(count * 0.8)
        local finalPos
        
        if i <= outerLimit then
            -- 外側の縦向き円 (XY平面)
            local idx = i
            local total = outerLimit
            local r = c.Size
            local angle = (idx / total) * math.pi * 2 + time * c.Speed -- 外側も回転させる
            
            local x = math.cos(angle) * r
            local y = math.sin(angle) * r
            finalPos = Vector3.new(x, y, 0)
            
        else
            -- 内側（内側の円 + 中心）
            if i <= innerLimit then
                -- 内側の円 (斜めに回転)
                local idx = i - outerLimit
                local total = innerLimit - outerLimit
                local r = c.Size
                local angle = (idx / total) * math.pi * 2 + time * c.Speed
                
                -- YZ平面の円をベースにする
                local y = math.cos(angle) * r
                local z = math.sin(angle) * r
                
                -- Z軸周りに45度回転させて斜めにする
                local tilt = math.rad(45)
                local tx = -y * math.sin(tilt) -- x(0) * cos - y * sin
                local ty = y * math.cos(tilt)  -- x(0) * sin + y * cos
                
                finalPos = Vector3.new(tx, ty, z)
            else
                -- 中心オブジェクト (選択可能)
                local idx = i - innerLimit
                local total = count - innerLimit
                local r = (c.InnerSize or (c.Size * 0.6)) * 0.4
                local cType = c.CenterType or "Sphere"
                
                if cType == "Sphere" then
                    local phi = math.acos(-1 + (2 * idx) / total)
                    local theta = math.sqrt(total * math.pi) * phi + time * c.Speed * 2
                    local x = r * math.cos(theta) * math.sin(phi)
                    local y = r * math.sin(theta) * math.sin(phi)
                    local z = r * math.cos(phi)
                    finalPos = Vector3.new(x, y, z)
                elseif cType == "Cube" then
                    local t = time * c.Speed
                    local x = math.clamp(math.sin(t + idx) * r * 1.5, -r, r)
                    local y = math.clamp(math.cos(t * 1.1 + idx) * r * 1.5, -r, r)
                    local z = math.clamp(math.sin(t * 1.3 + idx) * r * 1.5, -r, r)
                    finalPos = Vector3.new(x, y, z)
                elseif cType == "Vertical" then
                    local angle = (idx / total) * math.pi * 2 + time * c.Speed * 4
                    local x = math.cos(angle) * r
                    local y = math.sin(angle) * r
                    finalPos = Vector3.new(x, y, 0)
                else -- Random
                    local seed = idx * 13.37
                    local x = math.sin(time * 2 + seed) * r
                    local y = math.cos(time * 2.5 + seed) * r
                    local z = math.sin(time * 1.5 + seed) * r
                    finalPos = Vector3.new(x, y, z)
                end
            end

            -- 内側のみエフェクト全体（構造）を回転させる
            local rotAngle = gyroInnerAngle -- 物理ベースの角度を使用
            local rx = finalPos.X * math.cos(rotAngle) - finalPos.Z * math.sin(rotAngle)
            local rz = finalPos.X * math.sin(rotAngle) + finalPos.Z * math.cos(rotAngle)
            finalPos = Vector3.new(rx, finalPos.Y, rz)
        end
        
        if not finalPos then return Vector3.zero end

        -- エフェクト全体は回転させず、オフセットのみ適用
        return Vector3.new(finalPos.X, finalPos.Y + c.Height, finalPos.Z + c.Back)
    end
    
    return Vector3.zero
end

--------------------------------------------------------------------------------
-- [メイン機能] エフェクト制御 (Start / Stop / Update)
--------------------------------------------------------------------------------
local function stopEffect()
    isEnabled = false
    if updateConnection then 
        updateConnection:Disconnect()
        updateConnection = nil 
    end
    
    -- ジャイロの状態をリセット
    gyroInnerAngularVelocity = 0
    gyroInnerAngle = 0
    
    -- アタッチメント削除 & 固定化
    for _, v in ipairs(activeToys) do
        pcall(function() 
            v.Part.Anchored = false 
            v.A0:Destroy()
            v.A1:Destroy()
            v.AP:Destroy()
            v.AO:Destroy() 
        end)
    end
    activeToys = {}
    
    -- 当たり判定復元
    for part, val in pairs(originalCollisions) do
        if part and part.Parent then 
            part.CanCollide = val 
        end
    end
    originalCollisions = {}
end

local function startEffect()
    stopEffect()
    activeToys = {}
    lastUpdateTick = tick() -- 物理計算用の時間リセット

    if not targetMain or not targetMain.Character then return end
    local root = targetMain.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local fws = {}
    local myName = LocalPlayer.Name
    
    local maxCount
    if combinedActive then
        local c1 = (cfg.Combined.Mode1 ~= "なし") and (cfg.Combined.Mode1Count or 15) or 0
        local c2 = (cfg.Combined.Mode2 ~= "なし") and (cfg.Combined.Mode2Count or 15) or 0
        local c3 = (cfg.Combined.Mode3 ~= "なし") and (cfg.Combined.Mode3Count or 0) or 0
        local c4 = (cfg.Combined.Mode4 ~= "なし") and (cfg.Combined.Mode4Count or 0) or 0
        local c5 = (cfg.Combined.Mode5 ~= "なし") and (cfg.Combined.Mode5Count or 0) or 0
        maxCount = c1 + c2 + c3 + c4 + c5
    else
        maxCount = cfg.Global.MaxToys or 30 
    end

    local allMyItems = {}
    local plotsFolder = Workspace:FindFirstChild("Plots")
    local plotItemsFolder = Workspace:FindFirstChild("PlotItems")

    -- 0. Get items from SpawnedInToys (Cosmic style)
    if useOtherToys then
        for _, folder in ipairs(Workspace:GetChildren()) do
            if folder.Name:match("SpawnedInToys$") then
                for _, item in ipairs(folder:GetChildren()) do
                    table.insert(allMyItems, item)
                end
            end
        end
    else
        local spawnedToys = Workspace:FindFirstChild(myName .. "SpawnedInToys")
        if spawnedToys then
            for _, item in ipairs(spawnedToys:GetChildren()) do
                table.insert(allMyItems, item)
            end
        end
    end

    -- 1. Get items from my plot
    if plotsFolder and plotItemsFolder then
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local ownerObj = sign and (sign:FindFirstChild("ThisPlotsOwners") or sign:FindFirstChild("Owner"))
            if ownerObj then
                local val = ownerObj:FindFirstChild("Value") or ownerObj
                local data = val:FindFirstChild("Data") or val
                local isMine = (data:IsA("StringValue") and data.Value == myName)
                
                if isMine or useOtherToys then
                    local myPlotName = plot.Name
                    local targetFolder = plotItemsFolder:FindFirstChild(myPlotName)
                    if targetFolder then
                        for _, item in ipairs(targetFolder:GetChildren()) do
                            table.insert(allMyItems, item)
                        end
                    end
                    if isMine and not useOtherToys then break end
                end
            end
        end
    end

    -- 2. Get items directly from Workspace that I own
    for _, item in ipairs(Workspace:GetChildren()) do
        local ownerValue = item:FindFirstChild("Owner") or item:FindFirstChild("PartOwner")
        if item:IsA("Model") and ownerValue and ownerValue:IsA("StringValue") then
            if (ownerValue.Value == myName or useOtherToys) and not table.find(allMyItems, item) then
                 table.insert(allMyItems, item)
            end
        end
    end

    -- 3. Filter items based on selection and add to fws
    if combinedActive then
        -- 合体モード：各スロットの設定に従って順番に収集
        local slots = {"Mode1", "Mode2", "Mode3", "Mode4", "Mode5"}
        for _, slotName in ipairs(slots) do
            local mode = cfg.Combined[slotName]
            local count = cfg.Combined[slotName.."Count"] or 0
            local rawTargetItem = cfg.Combined[slotName.."Item"] or "メインと同期"
            
            -- 同期設定の解決
            local effectiveItem = (rawTargetItem == "メインと同期") and selectedItemName or rawTargetItem
            
            if mode ~= "なし" and count > 0 then
                local foundForSlot = 0
                for _, item in ipairs(allMyItems) do
                    if foundForSlot >= count then break end
                    if item:IsA("Model") and item.PrimaryPart and (effectiveItem == "全てのおもちゃ" or item.Name == effectiveItem) then
                        if not table.find(fws, item) then -- 重複を避ける
                            table.insert(fws, item)
                            foundForSlot = foundForSlot + 1
                        end
                    end
                end
            end
        end
    else
        -- 通常モード：メインの選択に従って収集
        for _, item in ipairs(allMyItems) do
            if #fws >= maxCount then break end
            if item:IsA("Model") and item.PrimaryPart and (selectedItemName == "全てのおもちゃ" or item.Name == selectedItemName) then
                table.insert(fws, item)
            end
        end
    end

    -- 4. Ensure network ownership for all found items
    for _, item in ipairs(fws) do
        for _, part in ipairs(item:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part:SetNetworkOwner(LocalPlayer) end)
            end
        end
    end

    if #fws == 0 then
        warn("おもちゃが見つかりませんでした。")
        return
    end

        print("おもちゃを " .. #fws .. " 個捕捉しました。 (目標数: " .. maxCount .. ")")

   -- ネットワークオーナーシップを強制的に取得
    for i, model in ipairs(fws) do
        local pp = model.PrimaryPart
        
        -- 全パーツの勢いを殺す
        for _, d in ipairs(model:GetDescendants()) do 
            if d:IsA("BasePart") then
                d.AssemblyLinearVelocity = Vector3.zero
                d.AssemblyAngularVelocity = Vector3.zero
                pcall(function() d:SetNetworkOwner(LocalPlayer) end)
            end
        end
        
        -- スタート時の爆発を防ぐため、計算上の初期位置に直接配置する
        if root then
            local m, relIdx, relTotal
            local override = nil
            if combinedActive then
                local c1 = (cfg.Combined.Mode1 ~= "なし") and (cfg.Combined.Mode1Count or 15) or 0
                local c2 = (cfg.Combined.Mode2 ~= "なし") and (cfg.Combined.Mode2Count or 15) or 0
                local c3 = (cfg.Combined.Mode3 ~= "なし") and (cfg.Combined.Mode3Count or 0) or 0
                local c4 = (cfg.Combined.Mode4 ~= "なし") and (cfg.Combined.Mode4Count or 0) or 0

                local slotNum = 1
                if i <= c1 then
                    m = cfg.Combined.Mode1
                    relIdx = i
                    relTotal = c1
                elseif i <= c1 + c2 then
                    slotNum = 2
                    m = cfg.Combined.Mode2
                    relIdx = i - c1
                    relTotal = c2
                elseif i <= c1 + c2 + c3 then
                    slotNum = 3
                    m = cfg.Combined.Mode3
                    relIdx = i - c1 - c2
                    relTotal = c3
                elseif i <= c1 + c2 + c3 + c4 then
                    slotNum = 4
                    m = cfg.Combined.Mode4
                    relIdx = i - c1 - c2 - c3
                    relTotal = c4
                else
                    slotNum = 5
                    m = cfg.Combined.Mode5
                    relIdx = i - c1 - c2 - c3 - c4
                    relTotal = cfg.Combined.Mode5Count or 0
                end

                if m ~= "なし" then
                    local sKey = "Mode"..slotNum
                    local baseC = cfg[m] or cfg.Wing
                    override = deepCopy(baseC)
                    override.Speed = cfg.Combined[sKey.."Speed"] or baseC.Speed
                    override.Size = cfg.Combined[sKey.."Size"] or baseC.Size
                    override.Height = cfg.Combined[sKey.."Height"] or baseC.Height
                    override.Back = cfg.Combined[sKey.."Back"] or baseC.Back
                end
            else
                m = currentMode
                relIdx = i
                relTotal = #fws
            end
            if m and m ~= "なし" then
                local relativePos = getPositionForMode(m, relIdx, relTotal, tick(), override)
                pp.CFrame = root.CFrame:ToWorldSpace(CFrame.new(relativePos))
            end
        end
        
        pp.Anchored = false -- 配置が終わってから物理を有効化
        pcall(function() pp:SetNetworkOwner(LocalPlayer) end)

        -- 当たり判定無効化
        for _, d in ipairs(model:GetDescendants()) do 
            if d:IsA("BasePart") then 
                if originalCollisions[d] == nil then originalCollisions[d] = d.CanCollide end
                d.CanCollide = false
                d.CanTouch = false
                d.CanQuery = false
            end 
        end
        
        -- (AttachmentやAlignPositionの設定はそのまま...)
        local a0 = Instance.new("Attachment", pp)
        local ap = Instance.new("AlignPosition", pp)
        ap.Attachment0 = a0
        ap.Mode = Enum.PositionAlignmentMode.OneAttachment
        ap.MaxForce = 1e9
        ap.Responsiveness = 800
        
        local ao = Instance.new("AlignOrientation", pp)
        ao.Attachment0 = a0
        ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
        ao.MaxTorque = 1e9
        ao.Responsiveness = 800
        
        table.insert(activeToys, {A0=a0, AP=ap, AO=ao, Part=pp})
    end
    
    isEnabled = true

    local frameCounter = 0
    updateConnection = RunService.RenderStepped:Connect(function()
    if lowLatencyMode and targetMain ~= LocalPlayer then
        frameCounter = frameCounter + 1
        if frameCounter % 2 == 0 then return end
    end

    local char = targetMain.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- ジャイロの物理演算
    local now = tick()
    local deltaTime = now - lastUpdateTick
    lastUpdateTick = now

    local rawVel = rootPart.AssemblyLinearVelocity
    local lerpWeight = math.clamp(deltaTime * 5, 0, 1)
    currentMoveVelocity = currentMoveVelocity:Lerp(rawVel, lerpWeight)

    local playerVelocity = rootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)
    local playerSpeed = playerVelocity.Magnitude
    local targetAngularVelocity = playerSpeed * 0.1 -- 速度に応じて目標回転速度を設定
    local damping = 0.97 -- 慣性の強さ (1に近いほど強い)
    gyroInnerAngularVelocity = gyroInnerAngularVelocity * damping + targetAngularVelocity * (1 - damping)
    gyroInnerAngle = gyroInnerAngle + gyroInnerAngularVelocity * deltaTime

    local baseCF
    if isReturningToPlot then
        if not lastBaseCF then lastBaseCF = rootPart.CFrame end
        baseCF = lastBaseCF
    else
        if followMethod == "プレイヤー" then
            baseCF = rootPart.CFrame
            lastBaseCF = baseCF
        elseif followMethod == "視線の先" then
            local rayOrigin = Camera.CFrame.Position
            local rayDirection = Camera.CFrame.LookVector * 1000
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local rayResult = Workspace:Raycast(rayOrigin, rayDirection, rayParams)

            if rayResult then
                baseCF = CFrame.new(rayResult.Position)
                lastBaseCF = baseCF
            else
                baseCF = lastBaseCF or (Camera.CFrame * CFrame.new(0, 0, -20))
            end
        else -- "固定"
            if not lastBaseCF then lastBaseCF = rootPart.CFrame end
            baseCF = lastBaseCF
        end
    end

    local t = tick()
    
    -- エフェクト全体の回転を計算
    local effectRot = cfg.Global.EffectRotation or Vector3.zero
    local effectRotationCF = CFrame.Angles(math.rad(effectRot.X), math.rad(effectRot.Y), math.rad(effectRot.Z))
    local rotatedBaseCF = baseCF * effectRotationCF

    -- おもちゃ個別の回転を計算
    local indivRot = cfg.Global.IndividualRotation or Vector3.new(0, -90, 0)
    local individualRotation = CFrame.Angles(math.rad(indivRot.X), math.rad(indivRot.Y), math.rad(indivRot.Z))
    
    local c1, c2, c3, c4, c5
    if combinedActive then
        c1 = (cfg.Combined.Mode1 ~= "なし") and (cfg.Combined.Mode1Count or 15) or 0
        c2 = (cfg.Combined.Mode2 ~= "なし") and (cfg.Combined.Mode2Count or 15) or 0
        c3 = (cfg.Combined.Mode3 ~= "なし") and (cfg.Combined.Mode3Count or 0) or 0
        c4 = (cfg.Combined.Mode4 ~= "なし") and (cfg.Combined.Mode4Count or 0) or 0
        c5 = (cfg.Combined.Mode5 ~= "なし") and (cfg.Combined.Mode5Count or 0) or 0
    end

    for i, fw in ipairs(activeToys) do
        local m, relIdx, relTotal
        local override = nil
        local currentIndividualRotation = individualRotation
        if combinedActive then
            local slotNum = 1
            if i <= c1 then
                m = cfg.Combined.Mode1
                relIdx = i
                relTotal = c1
            elseif i <= c1 + c2 then
                slotNum = 2
                m = cfg.Combined.Mode2
                relIdx = i - c1
                relTotal = c2
            elseif i <= c1 + c2 + c3 then
                slotNum = 3
                m = cfg.Combined.Mode3
                relIdx = i - c1 - c2
                relTotal = c3
            elseif i <= c1 + c2 + c3 + c4 then
                slotNum = 4
                m = cfg.Combined.Mode4
                relIdx = i - c1 - c2 - c3
                relTotal = c4
            else
                slotNum = 5
                m = cfg.Combined.Mode5
                relIdx = i - c1 - c2 - c3 - c4
                relTotal = c5
            end

            if m ~= "なし" then
                local sKey = "Mode"..slotNum
                local baseC = cfg[m] or cfg.Wing
                override = deepCopy(baseC)
                override.Speed = cfg.Combined[sKey.."Speed"] or baseC.Speed
                override.Size = cfg.Combined[sKey.."Size"] or baseC.Size
                override.Height = cfg.Combined[sKey.."Height"] or baseC.Height
                override.Back = cfg.Combined[sKey.."Back"] or baseC.Back
                currentIndividualRotation = CFrame.Angles(
                    math.rad(cfg.Combined[sKey.."RotX"] or 0),
                    math.rad(cfg.Combined[sKey.."RotY"] or 0),
                    math.rad(cfg.Combined[sKey.."RotZ"] or 0)
                )
            end
        else
            m = currentMode
            relIdx = i
            relTotal = #activeToys
        end

        if m and m ~= "なし" then
            local relativePos, dragWeight = getPositionForMode(m, relIdx, relTotal, t, override)
            local worldPos = rotatedBaseCF:PointToWorldSpace(relativePos)

            if cfg.Global.MoveDelay and (m == "Wing" or m == "Pet") then
                local dragFactor = dragWeight or (math.abs(relativePos.X) * 0.1)
                worldPos = worldPos - (currentMoveVelocity * (cfg.Global.MoveDelayWeight or 0.05) * dragFactor)
            end
            
            if worldPos.Y < -85 then worldPos = Vector3.new(worldPos.X, -85, worldPos.Z) end
            
            fw.AP.Position = worldPos
            if m == "BackGuard" then
                fw.AO.CFrame = CFrame.lookAt(worldPos, rotatedBaseCF.Position) * currentIndividualRotation
            elseif m == "Rotate" or m == "MagicCircle" or m == "FloatStone" or m == "Merkaba" or m == "Cube" or m == "Tornado" or m == "Pyramid" or m == "Gyro" then
                local lookCfg = deepCopy(override or cfg[m] or cfg.Wing)
                if (lookCfg.Speed or 0) == 0 then lookCfg.Speed = 1 end
                local nextPos = rotatedBaseCF:PointToWorldSpace(getPositionForMode(m, relIdx, relTotal, t + 0.05, lookCfg))
                if nextPos.Y < -85 then nextPos = Vector3.new(nextPos.X, -85, nextPos.Z) end

                if (worldPos - nextPos).Magnitude < 0.001 then
                    fw.AO.CFrame = rotatedBaseCF * currentIndividualRotation
                else
                    fw.AO.CFrame = CFrame.lookAt(worldPos, nextPos) * currentIndividualRotation
                end
            else
                fw.AO.CFrame = rotatedBaseCF * currentIndividualRotation
            end
        else
            fw.AP.Position = Vector3.new(0, -10000, 0)
        end
    end -- for ループの閉じ
end)
end

--------------------------------------------------------------------------------
-- [汎用ベースポイント帰還機能]
--------------------------------------------------------------------------------
local selectedHouseCF = nil 
local houseCoords = {
    ["桜の家"] = CFrame.new(548, 123, -73),
    ["水色の家"] = CFrame.new(509, 83, -338),
    ["紫の家"] = CFrame.new(255, -7, 449),
    ["緑の家"] = CFrame.new(-534, -7, 89),
    ["ピンクの家"] = CFrame.new(-485, -7, -163)
}
local plotNames = {
    [1] = "緑の家", [2] = "ピンクの家", [3] = "紫の家", [4] = "水色の家", [5] = "桜の家"
}
local HomeStatus = nil -- UIアクセス用

task.spawn(function()
    while true do
        task.wait(1)
        if cfg.PlotReturn.Enabled then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if root then
                local found = false
                pcall(function()
                    local plots = Workspace:FindFirstChild("Plots")
                    if plots then
                        for i = 1, 5 do
                            local plot = plots:FindFirstChild("Plot" .. i)
                            if plot then
                                local sign = plot:FindFirstChild("PlotSign")
                                local owners = sign and sign:FindFirstChild("ThisPlotsOwners")
                                
                                if owners then
                                    local ownerName = nil
                                    local timeVal = 0
                                    
                                    local valObj = owners:FindFirstChild("Value")
                                    if valObj and valObj:IsA("StringValue") then
                                        ownerName = valObj.Value
                                        local t = valObj:FindFirstChild("TimeRemainingNum")
                                        if t then timeVal = t.Value end
                                    elseif owners:IsA("StringValue") then
                                        ownerName = owners.Value
                                        local t = owners:FindFirstChild("TimeRemainingNum")
                                        if t then timeVal = t.Value end
                                    end

                                    if ownerName == LocalPlayer.Name then
                                        found = true
                                        local houseName = plotNames[i] or "Unknown"
                                        if HomeStatus then
                                            HomeStatus:Set("家: " .. houseName .. "\n残り時間: " .. tostring(timeVal) .. "秒")
                                        end
                                        
                                        if timeVal <= 20 and timeVal > 0 then
                                            local targetCF = houseCoords[houseName]
                                            if targetCF then
                                                isReturningToPlot = true
                                                local oldCF = root.CFrame
                                                
                                                -- 家にテレポート
                                                root.CFrame = targetCF
                                                
                                                -- 時間が回復するまで待機 (最大3秒)
                                                local waitStart = tick()
                                                while tick() - waitStart < 3 do
                                                    local currentT = 0
                                                    if valObj and valObj:FindFirstChild("TimeRemainingNum") then
                                                        currentT = valObj.TimeRemainingNum.Value
                                                    elseif owners:FindFirstChild("TimeRemainingNum") then
                                                        currentT = owners.TimeRemainingNum.Value
                                                    end
                                                    
                                                    if currentT > 20 then break end
                                                    task.wait(0.1)
                                                end

                                                root.CFrame = oldCF
                                                isReturningToPlot = false
                                                task.wait(2) -- 連続テレポート防止
                                            end
                                        end
                                        break
                                    end
                                end
                            end
                        end
                    end
                end)
                
                if not found and HomeStatus then
                    HomeStatus:Set("家が見つかりません (Plotに入ってください)")
                end
            end
        else
            if HomeStatus then
                HomeStatus:Set("自動リセット無効")
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- [ESP & サブ機能] 更新ループ (Prometheus対応版)
--------------------------------------------------------------------------------
-- 共通のクリーンアップ関数（退出時や非表示時に使用）
local function removeESP(p)
    local esp = espCache[p]
    if esp then
        if esp.H then pcall(function() esp.H:Destroy() end) end
        if esp.B then pcall(function() esp.B:Destroy() end) end
        if esp.T then 
            pcall(function() 
                esp.T.Visible = false 
                esp.T:Remove() -- DrawingオブジェクトはRemove()で完全に消去
            end) 
        end
        espCache[p] = nil
    end
end

-- プレイヤーがサーバーを抜けた時に即座に実行
Players.PlayerRemoving:Connect(removeESP)

local lastEspUpdate = 0
local function updateSubFeatures()
    -- ESPが無効なら即座に抜ける（負荷対策）
    if not espCfg.Enabled then
        if next(espCache) ~= nil then
            for p, _ in pairs(espCache) do removeESP(p) end
        end
        return
    end

    -- 更新頻度を制限（約0.1秒ごと）してFPSを安定させる
    local now = tick()
    if now - lastEspUpdate < 0.1 then return end
    lastEspUpdate = now

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local char = p.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            
            local shouldShow = false
            local isTarget = (not espCfg.TargetOnly) or (espCfg.TargetOnly and (targetSubName ~= "" and p.Name == targetSubName))
            
            if isTarget and root and hum and hum.Health > 0 then
                shouldShow = true
            end

            local esp = espCache[p] or {}
            
            if shouldShow then
                -- 1. ハイライト処理
                if not esp.H or esp.H.Parent ~= char then 
                    esp.H = Instance.new("Highlight")
                    esp.H.Parent = char
                    esp.H.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
                esp.H.Enabled = true
                esp.H.FillColor = espCfg.ESPColor

                -- 2. アイコン付き名前表示 (確実に動くURL形式)
                if not esp.B or esp.B.Parent ~= root then
                    esp.B = Instance.new("BillboardGui")
                    esp.B.Parent = root
                    esp.B.Size = UDim2.new(0, 250, 0, 50)
                    esp.B.AlwaysOnTop = true
                    esp.B.ExtentsOffset = Vector3.new(0, 3, 0)

                    local frame = Instance.new("Frame", esp.B)
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundTransparency = 1

                    local icon = Instance.new("ImageLabel", frame)
                    icon.Name = "Icon"
                    icon.Size = UDim2.new(0, 30, 0, 30)
                    icon.Position = UDim2.new(0, 0, 0.5, -15)
                    icon.BackgroundTransparency = 1
                    -- アイコンが表示されていた形式のURLを使用
                    icon.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. p.UserId .. "&width=420&height=420&format=png"

                    local l = Instance.new("TextLabel", frame)
                    l.Name = "NameLabel"
                    l.Size = UDim2.new(1, -35, 1, 0)
                    l.Position = UDim2.new(0, 35, 0, 0)
                    l.BackgroundTransparency = 1
                    l.TextXAlignment = Enum.TextXAlignment.Left
                    l.TextStrokeTransparency = 0
                    l.Font = Enum.Font.SourceSansBold
                    l.TextSize = 14
                    
                    esp.L = l
                    esp.I = icon
                end
                esp.B.Enabled = espCfg.Names
                esp.L.Text = p.DisplayName .. " (@" .. p.Name .. ")"
                esp.L.TextColor3 = espCfg.ESPColor

                -- 3. トレーサー (改善版)
                if espCfg.Tracers then
                    if not esp.T then
                        esp.T = Drawing.new("Line")
                        esp.T.Thickness = 1
                        esp.T.Transparency = 1
                    end
                    
                    local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    esp.T.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    esp.T.Color = espCfg.ESPColor
                    
                    if onScreen then
                        esp.T.To = Vector2.new(screenPos.X, screenPos.Y)
                        esp.T.Visible = true
                    else
                        -- 画面外のトレーサー処理（不要な場合は visible = false に）
                        esp.T.Visible = false 
                    end
                elseif esp.T then
                    esp.T.Visible = false
                end

                -- 4. ヒットボックス
                if espCfg.Hitbox then
                    root.Size = Vector3.new(espCfg.HitboxSize, espCfg.HitboxSize, espCfg.HitboxSize)
                    root.Transparency = 0.5
                    root.Color = espCfg.ESPColor
                    root.CanCollide = false
                else
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 1
                end
                espCache[p] = esp
            else
                -- 表示不要（退出・死亡・設定OFF）になったら即座にクリーンアップ
                removeESP(p)
                -- ヒットボックスのサイズも元に戻す
                if root and root.Parent then
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 1
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(updateSubFeatures)

-- プレイヤー機能ループ
UserInputService.JumpRequest:Connect(function()
    if infiniteJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function(time, deltaTime)
    if not LocalPlayer.Character then return end
    local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    -- YouDecoy Noclip logic
    if decoyNoclip then
        local decoysToNoclip = getAllYouDecoys()
        for _, d in ipairs(decoysToNoclip) do
            for _, p in ipairs(d:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end

    if hum then
        if useWalkSpeed and root and hum.MoveDirection.Magnitude > 0 then
            -- CFrameによる移動 (Cosmic Hub参考)
            local extraSpeed = math.max(0, walkSpeed - 16)
            root.CFrame = root.CFrame + (hum.MoveDirection * (extraSpeed * deltaTime))
        end
        if useJumpPower then 
            hum.UseJumpPower = true
            hum.JumpPower = jumpPower
            -- UseJumpPowerが強制的にfalseにされる場合への対策 (JumpHeightを使用)
            if not hum.UseJumpPower then
                hum.JumpHeight = jumpPower * 0.2 -- 概算
            end
        end
    end
    
    if antiFire then
        for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("Fire") then v:Destroy() end
        end
    end
    
    if antiGrab then
        local char = LocalPlayer.Character
        if char then
            -- Cosmic style Anti-Grab Loop
            local head = char:FindFirstChild("Head")
            local isHeldVal = LocalPlayer:FindFirstChild("IsHeld")
            local isHeld = (head and head:FindFirstChild("PartOwner")) or (isHeldVal and isHeldVal.Value)
            local struggleEvt = ReplicatedStorage:FindFirstChild("CharacterEvents") and ReplicatedStorage.CharacterEvents:FindFirstChild("Struggle")

            if isHeld then
                -- 掴まれている間、固定して抵抗し続ける
                for _, p in ipairs(char:GetChildren()) do
                    if p:IsA("BasePart") then p.Anchored = true end
                end
                
                if struggleEvt then
                    struggleEvt:FireServer(LocalPlayer) -- 引数追加
                end
            else
                -- 掴まれていない、かつアンチ爆発(ラグドール)中でなければ固定解除
                local isRagdolled = antiExplosion and char:FindFirstChild("Humanoid") and char.Humanoid:FindFirstChild("Ragdolled") and char.Humanoid.Ragdolled.Value
                if not isRagdolled then
                    for _, p in ipairs(char:GetChildren()) do
                        if p:IsA("BasePart") then p.Anchored = false end
                    end
                end
            end
        end
    end

    -- Noclip
    if noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

Workspace.DescendantAdded:Connect(function(v)
    if antiExplosion and v:IsA("Explosion") then
        v.BlastPressure = 0
        v.BlastRadius = 0
        v.Visible = false
        task.wait()
        v:Destroy()
    end
end)

-- Anti-Explosion (Ragdoll Anchor) & Anti-Fire (Extinguish) Loop 修正版
local extOriginalCFrame = nil
local extPart = nil

task.spawn(function()
    while true do
        task.wait(0.1)
        local char = LocalPlayer.Character
        if char then
            -- Anti-Explosion: Ragdoll Anchor (修正: 解除処理を追加)
            if antiExplosion then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    local rag = hum:FindFirstChild("Ragdolled")
                    if rag and rag.Value then
                        -- ラグドール中は固定
                        for _, p in ipairs(char:GetChildren()) do
                            if p:IsA("BasePart") then p.Anchored = true end
                        end
                    else
                        -- ラグドール解除後は固定解除 (動けるようにする)
                        for _, p in ipairs(char:GetChildren()) do
                            if p:IsA("BasePart") then p.Anchored = false end
                        end
                    end
                end
            end

            -- Anti-Fire: Extinguish Part (修正: 紫の物体を元の位置に戻す)
            if antiFire then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hasFire = hrp and (hrp:FindFirstChild("FireLight") or hrp:FindFirstChild("FireParticleEmitter"))
                
                -- パーツを一度だけ取得・保存
                if not extPart then
                    local map = Workspace:FindFirstChild("Map")
                    local hole = map and map:FindFirstChild("Hole")
                    local poison = hole and hole:FindFirstChild("PoisonBigHole")
                    extPart = poison and poison:FindFirstChild("ExtinguishPart")
                    if extPart then extOriginalCFrame = extPart.CFrame end
                end
                
                if extPart then
                    if hasFire then
                        -- 炎があるなら消火パーツを自分に持ってくる
                        extPart.CFrame = hrp.CFrame
                    elseif extOriginalCFrame then
                        -- 炎が消えたら元の位置に戻す (紫の物体を隠す)
                        extPart.CFrame = extOriginalCFrame
                    end
                end
            end
        end
    end
end)


--------------------------------------------------------------------------------
-- [設定]保存、見た目 
--------------------------------------------------------------------------------
-- --- 設定読み込み用関数 ---

-- ローカル変数とcfgを同期する関数 (UI作成前に値を確定させる)
local function syncVarsFromCfg()
    local ls = cfg.LocalSettings
    if not ls then return end
    
    walkSpeed = ls.WalkSpeed or walkSpeed
    jumpPower = ls.JumpPower or jumpPower
    useWalkSpeed = ls.UseWalkSpeed or false
    useJumpPower = ls.UseJumpPower or false
    infiniteJump = ls.InfiniteJump or false
    noclip = ls.Noclip or false
    antiExplosion = ls.AntiExplosion or false
    antiFire = ls.AntiFire or false
    antiGrab = ls.AntiGrab or false
    _G.AntiKickToy = ls.AntiKick or false
    _G.AutoAttacker = ls.AutoAttacker or false
    counterMode = ls.CounterMode or "Repulsion"
    currentMode = ls.CurrentMode or currentMode
    combinedActive = ls.CombinedActive or false
    followMethod = ls.FollowMethod or followMethod
    useOtherToys = ls.UseOtherToys or false
    autoWidth = ls.AutoWidth or true
    lowLatencyMode = ls.LowLatencyMode or false
    if ls.Esp then espCfg = ls.Esp end
    vflyEnabled = ls.VFlyEnabled or false
    vflySpeed = ls.VFlySpeed or 1
    saEnabled = ls.SilentAim or false
    targetMainName = ls.TargetMainName or ""
    targetSubName = ls.TargetSubName or ""
    selectedItemName = ls.SelectedItemName or "全てのおもちゃ"
    pianoEnabled = ls.PianoEnabled or false
    pianoFollowEnabled = ls.PianoFollowEnabled or true
end

-- 自動保存用ヘルパー関数
local function autoSave()
end

-- テーブルを再帰的にマージする関数
local function deepMerge(target, source)
    for k, v in pairs(source) do
        if type(v) == "table" and type(target[k]) == "table" then
            deepMerge(target[k], v)
        else
            target[k] = v
        end
    end
end

local function saveConfigToFile(path)
    -- 現在のローカル変数の状態を cfg に同期
    cfg.LocalSettings = {
        WalkSpeed = walkSpeed,
        JumpPower = jumpPower,
        UseWalkSpeed = useWalkSpeed,
        UseJumpPower = useJumpPower,
        InfiniteJump = infiniteJump,
        Noclip = noclip,
        AntiExplosion = antiExplosion,
        AntiFire = antiFire,
        AntiGrab = antiGrab,
        AntiGucci = _G.AntiGucci, -- 仮定
        AntiKick = _G.AntiKickToy,
        AutoAttacker = _G.AutoAttacker,
        CounterMode = counterMode,
        Minimap = {
            Zoom = ZOOM,
            Width = MAP_WIDTH,
            Height = MAP_HEIGHT,
            Players = SHOW_PLAYERS,
            Names = SHOW_NAMES,
            Icons = SHOW_ICONS,
            TargetOnly = SHOW_TARGET_ONLY
        },
        CurrentMode = currentMode,
        CombinedActive = combinedActive,
        FollowMethod = followMethod,
        UseOtherToys = useOtherToys,
        AutoWidth = autoWidth,
        LowLatencyMode = lowLatencyMode,
        Esp = espCfg,
        AnimSpeed = cfg.AnimSpeed,
        VFlyEnabled = vflyEnabled,
        VFlySpeed = vflySpeed,
        ThirdPerson = (LocalPlayer.CameraMode == Enum.CameraMode.Classic),
        FOV = Camera.FieldOfView,
        TargetMainName = targetMainName,
        SilentAim = saEnabled,
        TargetSubName = targetSubName,
        SelectedItemName = selectedItemName,
        PianoEnabled = pianoEnabled,
        PianoFollowEnabled = pianoFollowEnabled,
        -- オーラ設定
        Aura = {
            Kill = _G.DeathAura,
            Attraction = _G.AttractionAura,
            Fling = _G.FlingAura,
            FlingStrength = _G.FlingStrength,
            FlingTarget = _G.FlingTarget
        },
        -- 掴み詳細
        GrabDetail = {
            SuperStrength = superStrengthEnabled,
            Strength = strengthValue,
            Death = deathGrabEnabled,
            Noclip = noclipGrabEnabled,
            Perspective = perspectiveGrabEnabled,
            PSpeed = perspectiveSpeed,
            InvLine = invisibleLineEnabled,
            CrazyLine = _G.CrazyLine,
            RainbowLine = _G.RainbowLine,
            FurtherExtend = _G.FutherExtend,
            ExtendAmount = IncreaseLineExtend
        },
        -- デコイ設定
        Decoy = {
            Follow = decoyFollowEnabled,
            Speed = decoyWalkSpeed,
            Noclip = decoyNoclip,
            Fly = decoyFly,
            Target = decoyTargetName
        }
    }
    
    local success, json = pcall(function() return HttpService:JSONEncode(cfg) end)
    if success then
        if not isfolder("holon_config") then makefolder("holon_config") end
        writefile(path, json)
    end
end

local function applyConfigData(data)
    if not data then return end
    deepMerge(cfg, data)
    syncVarsFromCfg()

    local autoResponseActive = false -- 自動応答の状態管理

    -- UI要素への反映
    task.spawn(function()
        task.wait(0.5)
        if not UIElements then return end
        local function s(el, val) if el and el.Set then pcall(function() el:Set(val) end) end end

        local ls = cfg.LocalSettings
        s(UIElements.WalkSpeedSlider, walkSpeed)
        s(UIElements.WalkSpeedToggle, useWalkSpeed)
        s(UIElements.JumpPowerSlider, jumpPower)
        s(UIElements.AnimSpeedSlider, cfg.AnimSpeed * 10)
        s(UIElements.JumpPowerToggle, useJumpPower)
        s(UIElements.NoclipToggle, noclip)
        s(UIElements.InfiniteJumpToggle, infiniteJump)
        s(UIElements.EffectToggle, isEnabled)
        s(UIElements.CombinedToggle, combinedActive)
        s(UIElements.FollowMethodDropdown, followMethod)
        s(UIElements.ModeDropdown, modeNames[currentMode] or currentMode)
        s(UIElements.DefenseAntiKickToggle, _G.AntiKickToy)
        s(UIElements.SilentAimToggle, saEnabled)
        s(UIElements.MapPlayersToggle, SHOW_PLAYERS)
        s(UIElements.MapNamesToggle, SHOW_NAMES)
        s(UIElements.MapIconsToggle, SHOW_ICONS)
        
        -- オーラUI反映
        s(UIElements.KillAuraToggle, _G.DeathAura)
        s(UIElements.AttractionAuraToggle, _G.AttractionAura)
        s(UIElements.FlingAuraToggle, _G.FlingAura)
        s(UIElements.FlingStrengthSlider, _G.FlingStrength)
        
        -- 掴みUI反映
        s(UIElements.SuperStrengthToggle, superStrengthEnabled)
        s(UIElements.StrengthSlider, strengthValue)
        s(UIElements.SpinGrabToggle, cfg.GrabMod.Spin)
        s(UIElements.MapZoomSlider, ZOOM)
        s(UIElements.DeathGrabToggle, deathGrabEnabled)
        s(UIElements.NoclipGrabToggle, noclipGrabEnabled)
        s(UIElements.PerspectiveGrabToggle, perspectiveGrabEnabled)
        s(UIElements.PerspectiveSpeedSlider, perspectiveSpeed)
        s(UIElements.InvisibleLineToggle, invisibleLineEnabled)
        s(UIElements.LineToggle, _G.CrazyLine)
        s(UIElements.RainbowLineToggle, _G.RainbowLine)
        s(UIElements.FurtherExtendToggle, _G.FutherExtend)
        s(UIElements.ExtendAmountSlider, IncreaseLineExtend)
        
        -- デコイUI反映
        s(UIElements.DecoyFollowToggle, decoyFollowEnabled)
        s(UIElements.DecoySpeedSlider, decoyWalkSpeed)
        s(UIElements.DecoyNoclipToggle, decoyNoclip)
        s(UIElements.DecoyFlyToggle, decoyFly)
        
        if ls and ls.FOV then s(UIElements.FOVSlider, ls.FOV) end
    end)
end

-- 設定ファイルのリストをリアルタイムに取得する関数
local function getConfigFileList()
    local files = {}
    if not isfolder("holon_config") then makefolder("holon_config") end
    
    for _, file in ipairs(listfiles("holon_config")) do
        if file:sub(-5) == ".json" then
            -- パスを除去してファイル名だけにする
            local name = file:gsub("holon_config\\", ""):gsub("holon_config/", "")
            table.insert(files, name)
        end
    end
    if #files == 0 then table.insert(files, "ファイルなし") end
    return files
end

-- 1. cfgの中にUIの項目がない場合のエラーを防止する
if not cfg.UI then
    cfg.UI = {
        Transparency = 0.1,
        BackgroundColor = Color3.fromRGB(25, 25, 25),
        AccentColor = Color3.fromRGB(128, 128, 128),
        BackgroundImage = ""
    }
end

-- UI外観をリアルタイムに反映させるエンジン
local function applyCustomStyle()
    -- 安全策: cfg.UIが存在しない場合の初期化（ロード直後対策）
    if not cfg.UI then
        cfg.UI = {
            Transparency = 0.1,
            BackgroundColor = Color3.fromRGB(25, 25, 25),
            AccentColor = Color3.fromRGB(128, 128, 128),
            BackgroundImage = ""
        }
    end

    local gui = game:GetService("CoreGui"):FindFirstChild("HorionUI")
    if not gui then
        gui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("HorionUI")
    end

    if gui then
        local main = gui:FindFirstChild("Main")
        if not main then
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("Frame") and child:FindFirstChild("TopBar") then
                    main = child
                    break
                end
            end
        end
        
        if main then
            local bgColor = cfg.UI.BackgroundColor or Color3.fromRGB(25, 25, 25)
            local trans = cfg.UI.Transparency or 0.1
            local accent = cfg.UI.AccentColor or Color3.fromRGB(128, 128, 128)
    
            main.BackgroundColor3 = bgColor
            main.BackgroundTransparency = trans
            
            -- 子要素を再帰的に探索してスタイル適用
            for _, desc in ipairs(main:GetDescendants()) do
                -- 1. 枠線 (UIStroke)
                if desc:IsA("UIStroke") then
                    desc.Color = accent
                end
                -- 2. 区切り線 (Lineという名前のFrame)
                if desc:IsA("Frame") and desc.Name == "Line" then
                    desc.BackgroundColor3 = accent
                end
                -- 3. サイドバーとトップバー
                if desc:IsA("Frame") and (desc.Name == "SideBar" or desc.Name == "TopBar") then
                    desc.BackgroundColor3 = bgColor
                    desc.BackgroundTransparency = trans
                    -- ヘッダーの角を丸くする
                    if desc.Name == "TopBar" then
                        local corner = desc:FindFirstChild("UICorner") or Instance.new("UICorner", desc)
                        corner.CornerRadius = UDim.new(0, 9)
                    end
                end
                -- 4. ボタンとタブ (TextButton)
                -- 透明でないものだけ適用（見えないヒットボックスが表示されるのを防ぐ）
                if desc:IsA("TextButton") and desc.BackgroundTransparency < 1 then
                    desc.BackgroundColor3 = bgColor
                    desc.BackgroundTransparency = trans
                end
            end
            
            -- メインフレーム自体の角も確実に丸くする
            local mainCorner = main:FindFirstChild("UICorner") or Instance.new("UICorner", main)
            mainCorner.CornerRadius = UDim.new(0, 9)
        
        -- 背景画像のリアルタイム処理
        local bgImage = main:FindFirstChild("CustomBG")
        if cfg.UI.BackgroundImage and cfg.UI.BackgroundImage ~= "" then
            if not bgImage then
                bgImage = Instance.new("ImageLabel")
                bgImage.Name = "CustomBG"
                bgImage.Parent = main
                bgImage.Size = UDim2.new(1, 0, 1, 0)
                bgImage.Position = UDim2.new(0, 0, 0, 0)
                bgImage.ZIndex = 0
                bgImage.BackgroundTransparency = 1
            end
            
            local imgId = tostring(cfg.UI.BackgroundImage)
            if not imgId:match("^rbxassetid://") then
                imgId = "rbxassetid://" .. imgId
            end
            
            bgImage.Image = imgId
            bgImage.ImageTransparency = trans
            bgImage.Visible = true
        else
            if bgImage then bgImage.Visible = false end
        end
        end
    end
end

--------------------------------------------------------------------------------
-- [UI 構築] orion lib
--------------------------------------------------------------------------------
local KeyFileName = "HolonHub_Key.txt"
local CorrectKey = "holox"
local OrionUrl = "https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/source.txt"

-- [[ 1. メイン画面の関数 ]]
local function StartHolonHUB()
    -- スマホ対策：OrionLibを関数内で読み込み直す
    OrionLib = loadstring(game:HttpGet(OrionUrl))()
    
    -- 既存のUIを強制削除（二重表示防止）
    pcall(function()
        if game:GetService("CoreGui"):FindFirstChild("Orion") then 
            game:GetService("CoreGui").Orion:Destroy() 
        end
    end)

    local Window = OrionLib:MakeWindow({
        Name = "Holon HUB v1.4.9",
        HidePremium = false,
        SaveConfig = false, -- 初期化時の干渉を防ぐため無効化
        ConfigFolder = "HolonHUB",
        IntroEnabled = true,
        IntroText = "Holon HUB Load!"
    })

    -- test.luaベースの掴み機能
    local superStrengthEnabled = false
    local strengthValue = 400
    local deathGrabEnabled = false
    local noclipGrabEnabled = false
    local perspectiveGrabEnabled = false
    local perspectiveSpeed = 50
    local invisibleLineEnabled = false

    local lastGrabbedPart = nil
    local noclipOriginalCollisions = {}

    -- Line Extender (test.lua同等)
    local pcDistance = 0
    local senv = nil
    local minDistance = 3
    _G.FutherExtend = _G.FutherExtend or false

    local lineExtendGui = Instance.new("ScreenGui")
    lineExtendGui.ResetOnSpawn = false
    lineExtendGui.Name = "LineExtendGUI_Holon"
    if LocalPlayer.PlayerGui:FindFirstChild("ContextActionGui") then
        lineExtendGui.Parent = LocalPlayer.PlayerGui
    end

    local function isMobile()
        return LocalPlayer.PlayerGui:FindFirstChild("ContextActionGui") ~= nil
    end

    local imageButton = Instance.new("ImageButton")
    imageButton.Size = UDim2.new(0, 45, 0, 45)
    imageButton.Position = UDim2.new(1, -70, 1, -259)
    imageButton.Image = "rbxassetid://97166444"
    imageButton.BackgroundTransparency = 1
    imageButton.ImageTransparency = 0.2
    imageButton.Visible = false
    imageButton.ImageColor3 = Color3.fromRGB(142, 142, 142)
    imageButton.Parent = lineExtendGui
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
    imageButtonDe.Parent = lineExtendGui
    local imageLabelDe = Instance.new("ImageLabel")
    imageLabelDe.Size = UDim2.new(1, 0, 1, 0)
    imageLabelDe.Image = "rbxassetid://9603826756"
    imageLabelDe.BackgroundTransparency = 1
    imageLabelDe.Parent = imageButtonDe

    local function updateSenv()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local scriptObj = char:WaitForChild("GrabbingScript", 10)
        if scriptObj and getsenv then
            senv = getsenv(scriptObj)
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

    UserInputService.InputChanged:Connect(function(inputObject)
        if inputObject.UserInputType == Enum.UserInputType.MouseWheel then
            if pcDistance < 11 then pcDistance = 11 end
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
        if visible and _G.FutherExtend and isMobile() then
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

    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "GrabParts" and child:IsA("Model") then
            if _G.FutherExtend and not isMobile() then
                local grabPartModel = child
                local dragPart = grabPartModel:WaitForChild("DragPart", 2)
                if dragPart then
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
            end

            if _G.FutherExtend and isMobile() then
                toggleDefaultExtendButtons(false)
                toggleButtonState(true)
            end

            local grabPart = child:FindFirstChild("GrabPart", true)
            if not grabPart then return end
            local weld = grabPart:FindFirstChildOfClass("WeldConstraint")

            if weld and weld.Part1 then
                lastGrabbedPart = weld.Part1
                local grabbedModel = lastGrabbedPart.Parent

                if superStrengthEnabled then
                    local bv = Instance.new("BodyVelocity")
                    bv.Name = "BlizSuperStrength"
                    bv.MaxForce = Vector3.new(0, 0, 0)
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bv.Parent = lastGrabbedPart
                end

                if deathGrabEnabled and grabbedModel and grabbedModel:FindFirstChildOfClass("Humanoid") then
                    local player = Players:GetPlayerFromCharacter(grabbedModel)
                    local hum = grabbedModel:FindFirstChildOfClass("Humanoid")
                    local head = grabbedModel:FindFirstChild("Head")
                    if player and player ~= LocalPlayer and hum and head then
                        task.spawn(function()
                            while child and child.Parent and hum.Health > 0 do
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

                if perspectiveGrabEnabled then
                    if GrabEvents then
                        GrabEvents.CreateGrabLine:FireServer()
                    end

                    task.spawn(function()
                        local char = LocalPlayer.Character
                        if not char then return end
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if not hum or not root then return end

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

                            local moveDir = hum.MoveDirection
                            local finalMove = Vector3.zero

                            if moveDir.Magnitude > 0.01 then
                                local camCF = Camera.CFrame
                                local camLookHorizontal = (camCF.LookVector * Vector3.new(1, 0, 1)).Unit
                                local camRightHorizontal = (camCF.RightVector * Vector3.new(1, 0, 1)).Unit
                                local forwardAmount = moveDir:Dot(camLookHorizontal)
                                local rightAmount = moveDir:Dot(camRightHorizontal)
                                finalMove = (camCF.LookVector * forwardAmount) + (camRightHorizontal * rightAmount)
                            end

                            if finalMove.Magnitude > 0.01 then
                                camPart.CFrame = camPart.CFrame + finalMove.Unit * perspectiveSpeed * dt
                            end

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

                        if GrabEvents then
                            GrabEvents.CreateGrabLine:FireServer()
                        end
                    end)
                end

                -- 回転掴み (離しても回転)
                if cfg.GrabMod.Spin and not lastGrabbedPart.Anchored then
                    local targetPart = lastGrabbedPart
                    task.spawn(function()
                        while targetPart and targetPart.Parent and cfg.GrabMod.Spin do
                            if targetPart and targetPart.Parent then
                                pcall(function()
                                    -- 回転速度の維持
                                    targetPart.CFrame = targetPart.CFrame * CFrame.Angles(0, math.rad(15), 0)
                                end)
                            end
                            task.wait()
                        end
                    end)
                end
            end
        end
    end)

    Workspace.ChildRemoved:Connect(function(child)
        if child.Name == "GrabParts" and child:IsA("Model") then
            toggleButtonState(false)
            toggleDefaultExtendButtons(true)

            if superStrengthEnabled and lastGrabbedPart and lastGrabbedPart.Parent then
                local bv = lastGrabbedPart:FindFirstChild("BlizSuperStrength")
                if bv then
                    if UserInputService:GetLastInputType() == Enum.UserInputType.MouseButton2 then
                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bv.Velocity = Camera.CFrame.LookVector * strengthValue
                        DebrisService:AddItem(bv, 1)
                    else
                        bv:Destroy()
                    end
                end
            end

            for part, state in pairs(noclipOriginalCollisions) do
                if part and part.Parent then
                    pcall(function() part.CanCollide = state end)
                end
            end
            noclipOriginalCollisions = {}
            lastGrabbedPart = nil
        end
    end)

    RunService.Heartbeat:Connect(function()
        if not GrabEvents then return end

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

        if currentTarget and currentTarget.Parent and invisibleLineEnabled then
            pcall(function()
                GrabEvents.CreateGrabLine:FireServer()
            end)
        end
    end)

    -- 防御系共通ロジック
    -- Anti Gucci (Solaris Blobman方式)
    local antiGucciHeartbeatConnection = nil
    local antiGucciJumpConnection = nil
    local antiGucciSafePosition = nil
    local antiGucciRestoreFrameCount = 0

    local function spawnAntiGucciBlobman()
        pcall(function()
            ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(
                "CreatureBlobman",
                CFrame.new(0, 5000000, 0),
                Vector3.new(0, 60, 0)
            )
        end)

        local toyFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
        local blobman = toyFolder and toyFolder:FindFirstChild("CreatureBlobman")
        if blobman and blobman:FindFirstChild("Head") then
            blobman.Head.CFrame = CFrame.new(0, 50000, 0)
            blobman.Head.Anchored = true
        end
        return blobman
    end

    local function setAntiGucciEnabled(v)
        if v then
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            local rootPart = character:WaitForChild("HumanoidRootPart")
            antiGucciSafePosition = rootPart.Position

            local toyFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
            local blobman = toyFolder and toyFolder:FindFirstChild("CreatureBlobman")
            local blobmanSeat = blobman and blobman:FindFirstChild("VehicleSeat")

            if not blobman then
                blobman = spawnAntiGucciBlobman()
                task.wait(1)
                toyFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                blobman = toyFolder and toyFolder:FindFirstChild("CreatureBlobman")
                blobmanSeat = blobman and blobman:FindFirstChild("VehicleSeat")
            end

            if blobmanSeat and blobmanSeat:IsA("VehicleSeat") then
                rootPart.CFrame = blobmanSeat.CFrame + Vector3.new(0, 2, 0)
                blobmanSeat:Sit(humanoid)
            end

            if antiGucciJumpConnection then
                antiGucciJumpConnection:Disconnect()
                antiGucciJumpConnection = nil
            end
            antiGucciJumpConnection = humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
                if humanoid.Jump and humanoid.Sit then
                    antiGucciRestoreFrameCount = 15
                    antiGucciSafePosition = rootPart.Position
                end
            end)

            if antiGucciHeartbeatConnection then
                antiGucciHeartbeatConnection:Disconnect()
                antiGucciHeartbeatConnection = nil
            end
            antiGucciHeartbeatConnection = RunService.Heartbeat:Connect(function()
                if not (rootPart and humanoid) then return end
                local ce = ReplicatedStorage:FindFirstChild("CharacterEvents")
                local rr = ce and ce:FindFirstChild("RagdollRemote")
                local beingHeld = LocalPlayer:FindFirstChild("IsHeld")
                if rr and (not beingHeld or not beingHeld.Value) then
                    rr:FireServer(rootPart, 0)
                end

                local currentToyFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                local currentBlobman = currentToyFolder and currentToyFolder:FindFirstChild("CreatureBlobman")
                if currentBlobman and currentBlobman:FindFirstChild("Head") then
                    currentBlobman.Head.CFrame = CFrame.new(0, 50000, 0)
                    currentBlobman.Head.Anchored = true
                end

                if antiGucciRestoreFrameCount > 0 and antiGucciSafePosition then
                    rootPart.CFrame = CFrame.new(antiGucciSafePosition)
                    antiGucciRestoreFrameCount = antiGucciRestoreFrameCount - 1
                end
            end)

            task.spawn(function()
                while humanoid.Sit do
                    task.wait(1)
                end
                task.wait(0.5)
                if antiGucciSafePosition and rootPart and rootPart.Parent then
                    rootPart.CFrame = CFrame.new(antiGucciSafePosition)
                end
            end)
        else
            if antiGucciHeartbeatConnection then
                antiGucciHeartbeatConnection:Disconnect()
                antiGucciHeartbeatConnection = nil
            end
            if antiGucciJumpConnection then
                antiGucciJumpConnection:Disconnect()
                antiGucciJumpConnection = nil
            end

            local characterNow = LocalPlayer.Character
            if characterNow then
                local rootPartNow = characterNow:FindFirstChild("HumanoidRootPart")
                local humanoidNow = characterNow:FindFirstChild("Humanoid")
                if rootPartNow and antiGucciSafePosition then
                    rootPartNow.CFrame = CFrame.new(antiGucciSafePosition)
                end
                if humanoidNow then
                    humanoidNow.Sit = false
                end
            end

            task.wait(0.1)
            local currentToyFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
            local currentBlobman = currentToyFolder and currentToyFolder:FindFirstChild("CreatureBlobman")
            if currentBlobman then
                pcall(function()
                    ReplicatedStorage.MenuToys.DestroyToy:FireServer(currentBlobman)
                end)
            end
        end
    end

    local function PerformCounterAction(targetPlayer)
        if not targetPlayer or not targetPlayer.Character then return end
        local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = targetPlayer.Character:FindFirstChild("Humanoid")
        if not root or not hum then return end

        if counterMode == "Repulsion" then
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
            if GrabEvents and GrabEvents:FindFirstChild("DestroyGrabLine") then
                if not root:FindFirstChild("SkyVelocity") then
                    local bv = Instance.new("BodyVelocity", root)
                    bv.Name = "SkyVelocity"
                    bv.Velocity = Vector3.new(0, 999999, 0)
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

            for _ = 1, 50 do
                if not targetPlayer.Character or not targetPlayer.Character.Parent then break end

                local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                local head = targetPlayer.Character:FindFirstChild("Head")
                if root and head then
                    local po = head:FindFirstChild("PartOwner")
                    if po and po.Value == LocalPlayer.Name then
                        PerformCounterAction(targetPlayer)
                        break
                    else
                        local sno = GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner")
                        if sno and (root.Position - myRoot.Position).Magnitude <= 50 then
                            local lookCF = CFrame.lookAt(myRoot.Position, root.Position)
                            pcall(function()
                                sno:FireServer(root, lookCF)
                            end)
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end

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

    local function setAntiKickEnabled(enabled)
        _G.AntiKickToy = enabled
        if not enabled then return end

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
                        local menuToys = ReplicatedStorage:FindFirstChild("MenuToys")
                        local destroyToy = menuToys and menuToys:FindFirstChild("DestroyToy")

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
                                if lastt then
                                    lastt = false
                                    task.wait(0.5)
                                end

                                local spawnRemote = menuToys and menuToys:FindFirstChild("SpawnToyRemoteFunction")
                                if spawnRemote then
                                    local spawnCF = hrp.CFrame - Vector3.new(hrp.CFrame.LookVector.X * 20, -15, hrp.CFrame.LookVector.Z * 20)
                                    spawnRemote:InvokeServer("NinjaShuriken", spawnCF, Vector3.zero)
                                end

                                local tStart = tick()
                                repeat
                                    task.wait()
                                    toysFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                                    shuriken = toysFolder and toysFolder:FindFirstChild("NinjaShuriken")
                                until shuriken or tick() - tStart > 2

                                if shuriken then
                                    local stickyPart = shuriken:WaitForChild("StickyPart", 1)
                                    if stickyPart then
                                        if GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner") then
                                            GrabEvents.SetNetworkOwner:FireServer(stickyPart, stickyPart.CFrame)
                                        end
                                        local playerEvents = ReplicatedStorage:FindFirstChild("PlayerEvents")
                                        local stickyEvent = playerEvents and playerEvents:FindFirstChild("StickyPartEvent")
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

    -- Aura helper functions (test.lua準拠)
    local function CheckNetworkOwnerShipOnPart(part)
        local po = part and part:FindFirstChild("PartOwner")
        return po and po.Value == LocalPlayer.Name
    end

    local function SNOWship(part)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and part then
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
            local head = player.Character.Head
            if CheckNetworkOwnerShipOnPart(head) then return true end
            return SNOWship(player.Character.HumanoidRootPart)
        end
        return false
    end

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

    -- プレイヤーリスト取得関数
local function getPList()
    local plist = {}
    for _, p in ipairs(Players:GetPlayers()) do
        -- 「表示名 (@ユーザー名)」の形式でテーブルに入れる
        table.insert(plist, p.DisplayName .. " (@" .. p.Name .. ")")
    end
    return plist
end

-- UI要素を管理するテーブル
UIElements = {}

-- 翻訳テーブル
local modeNames = {
    ["Wing"] = "翼 (Wing)", ["Heart"] = "ハート (Heart)", ["Star"] = "星 (Star)", ["Vortex"] = "渦 (Vortex)",
    ["Sphere"] = "球体 (Sphere)", ["Rotate"] = "回転 (Rotate)", ["Pet"] = "ペット (Pet)", ["Text"] = "文字 (Text)",
    ["MagicCircle"] = "魔法陣 (MagicCircle)", ["MagicCircle2"] = "魔法陣2 (MagicCircle2)", ["MagicCircle3"] = "魔法陣3 (MagicCircle3)",
    ["FloatStone"] = "浮遊石 (FloatStone)", ["Merkaba"] = "マカバ (Merkaba)", ["Cube"] = "立方体 (Cube)",
    ["Pyramid"] = "ピラミッド (Pyramid)", ["MirrorPlayer"] = "分身 (MirrorPlayer)", ["Beam"] = "ビーム (Beam)",
    ["BackGuard"] = "背後ガード (BackGuard)", ["Tornado"] = "竜巻 (Tornado)", ["Gyro"] = "ジャイロ (Gyro)", ["なし"] = "なし"
}
local modeKeys = {}
for k, v in pairs(modeNames) do modeKeys[v] = k end
local function getModeList()
    local list = {}
    local order = {"Wing","Heart","Star","Vortex","Sphere","Rotate","Pet","Text","MagicCircle","MagicCircle2","MagicCircle3","FloatStone","Merkaba","Cube","Pyramid","MirrorPlayer","Beam","BackGuard","Tornado","Gyro"}
    for _, k in ipairs(order) do table.insert(list, modeNames[k]) end
    return list
end

-- --- TAB: MAIN ---
local MainTab = Window:MakeTab({
	Name = "メイン",
	Icon = "rbxassetid://7733960981" -- 適当なアイコンIDに差し替えてください
})

-- --- TAB: MODE SETTINGS ---
local ModeSetTab = Window:MakeTab({
    Name = "モード設定",
    Icon = "rbxassetid://8997386997"
})

-- --- TAB: PLAYER ---
local PlayerTab = Window:MakeTab({
	Name = "プレイヤー",
	Icon = "rbxassetid://7743875962"
})

local DefenseTab = Window:MakeTab({
    Name = "無敵",
    Icon = "rbxassetid://7734056608"
})

local GrabTab = Window:MakeTab({
    Name = "掴む",
    Icon = "rbxassetid://88867162163985"
})

local AuraTab = Window:MakeTab({
    Name = "オーラ",
    Icon = "rbxassetid://116620312917084"
})

local PianoTab = Window:MakeTab({
    Name = "ピアノ",
    Icon = "rbxassetid://7734020554"
})

local KeyboardTab = Window:MakeTab({
    Name = "キーボード",
    Icon = "rbxassetid://121474456068237"
})

local ActionTab = Window:MakeTab({
    Name = "アクション",
    Icon = "rbxassetid://80451686744860"
})

local SubTab = Window:MakeTab({
	Name = "サブ機能",
	Icon = "rbxassetid://10734950309"
})

local DecoyTab = Window:MakeTab({
    Name = "デコイ",
    Icon = "rbxassetid://10734950309"
})

local DecoySec = DecoyTab:AddSection({
    Name = "YouDecoy 制御"
})

local decoyTargetDropdown = nil
decoyTargetDropdown = DecoySec:AddDropdown({
    Name = "ターゲット",
    Default = "なし",
    Options = getPList(),
    Callback = function(v)
        local name = v:match("@([^)]+)")
        decoyTargetName = name or ""
        targetDecoy = Players:FindFirstChild(decoyTargetName)
    end
})

UIElements.DecoyFollowToggle = DecoySec:AddToggle({
    Name = "ターゲットを追跡",
    Default = false,
    Callback = function(v)
        decoyFollowEnabled = v
    end
})

UIElements.DecoySpeedSlider = DecoySec:AddSlider({
    Name = "追跡速度",
    Min = 0, Max = 100, Default = 16,
    Callback = function(v)
        decoyWalkSpeed = v
    end
})

UIElements.DecoyNoclipToggle = DecoySec:AddToggle({
    Name = "壁すり抜け (Noclip)",
    Default = false,
    Callback = function(v)
        decoyNoclip = v
    end
})

UIElements.DecoyFlyToggle = DecoySec:AddToggle({
    Name = "空飛び (Flight)",
    Default = false,
    Callback = function(v)
        decoyFly = v
    end
})

local MoveSec = PlayerTab:AddSection({ Name = "移動設定" })

-- 現在のステータスを初期値にする
local currentWS = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) and LocalPlayer.Character.Humanoid.WalkSpeed or 16
walkSpeed = currentWS

UIElements.WalkSpeedSlider = MoveSec:AddSlider({
    Name = "歩行スピード", Min = 16, Max = 300, Default = walkSpeed, Increment = 1,
    Callback = function(v) walkSpeed = v end
})

UIElements.WalkSpeedToggle = MoveSec:AddToggle({
    Name = "歩行スピード有効化", Default = useWalkSpeed,
    Callback = function(v) 
        useWalkSpeed = v 
    end
})

UIElements.JumpPowerSlider = MoveSec:AddSlider({
    Name = "ジャンプ力", Min = 16, Max = 300, Default = jumpPower, Increment = 1,
    Callback = function(v) jumpPower = v end
})

UIElements.JumpPowerToggle = MoveSec:AddToggle({
    Name = "ジャンプ力有効化", Default = useJumpPower,
    Callback = function(v) 
        useJumpPower = v 
        if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = 25
        end
    end
})

UIElements.NoclipToggle = MoveSec:AddToggle({
    Name = "Noclip", Default = noclip,
    Callback = function(v) 
        noclip = v 
        if not v and LocalPlayer.Character then
            -- 修正: 全パーツをCanCollide=trueにすると荒ぶるため、主要パーツのみ戻す
            local char = LocalPlayer.Character
            local partsToCollide = {"HumanoidRootPart", "Head", "Torso", "UpperTorso", "LowerTorso"}
            for _, name in ipairs(partsToCollide) do
                local p = char:FindFirstChild(name)
                if p and p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
})

UIElements.InfiniteJumpToggle = MoveSec:AddToggle({
    Name = "無限ジャンプ", Default = infiniteJump,
    Callback = function(v) infiniteJump = v end
})

local vflyEnabled = false
local vflySpeed = 1

UIElements.VFlyToggle = MoveSec:AddToggle({
    Name = "VFly",
    Default = false,
    Callback = function(v)
        vflyEnabled = v
        if v then
            task.spawn(function()
                local bv = Instance.new("BodyVelocity")
                bv.Name = "HolonVFly"
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bv.Velocity = Vector3.zero
                
                local bg = Instance.new("BodyGyro")
                bg.Name = "HolonVFlyGyro"
                bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                bg.P = 10000
                bg.D = 100
                
                while vflyEnabled and LocalPlayer.Character do
                    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if root and hum then
                        if not root:FindFirstChild("HolonVFly") then bv.Parent = root end
                        if not root:FindFirstChild("HolonVFlyGyro") then bg.Parent = root end
                        
                        bg.CFrame = Camera.CFrame
                        
                        local moveDir = hum.MoveDirection
                        local vel = Vector3.zero
                        
                        if moveDir.Magnitude > 0 then
                            local camLook = Camera.CFrame.LookVector
                            local camRight = Camera.CFrame.RightVector
                            local camLookXZ = camLook * Vector3.new(1,0,1)
                            local camRightXZ = camRight * Vector3.new(1,0,1)
                            
                            if camLookXZ.Magnitude > 0.001 then
                                camLookXZ = camLookXZ.Unit
                                camRightXZ = camRightXZ.Unit
                                local fwd = moveDir:Dot(camLookXZ)
                                local right = moveDir:Dot(camRightXZ)
                                vel = (camLook * fwd + camRight * right) * (vflySpeed * 50)
                            else
                                vel = camLook * (moveDir.Magnitude * vflySpeed * 50)
                            end
                        end
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            vel = vel + Vector3.new(0, vflySpeed * 50, 0)
                        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                            vel = vel - Vector3.new(0, vflySpeed * 50, 0)
                        end
                        
                        bv.Velocity = vel
                        
                        if not hum.Sit then
                            hum.PlatformStand = true
                        end
                    else
                        break
                    end
                    RunService.RenderStepped:Wait()
                end
                
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.PlatformStand = false
                end
            end)
        end
    end
})

UIElements.VFlySpeedSlider = MoveSec:AddSlider({
    Name = "VFly速度",
    Min = 1, Max = 10, Default = 1,
    Callback = function(v) vflySpeed = v end
})

-- --- TAB: DEFENSE (守る) ---
local DefenseAntiSec = DefenseTab:AddSection({ Name = "アンチ系" })

UIElements.DefenseAntiExplosionToggle = DefenseAntiSec:AddToggle({
    Name = "アンチ爆発",
    Default = false,
    Callback = function(v)
        antiExplosion = v
    end
})

UIElements.DefenseAntiFireToggle = DefenseAntiSec:AddToggle({
    Name = "アンチ炎",
    Default = false,
    Callback = function(v)
        antiFire = v
    end
})

UIElements.DefenseAntiGrabToggle = DefenseAntiSec:AddToggle({
    Name = "アンチ掴み",
    Default = false,
    Callback = function(v)
        antiGrab = v
    end
})

UIElements.DefenseAntiGucciToggle = DefenseAntiSec:AddToggle({
    Name = "アンチグッチ",
    Default = false,
    Callback = function(v)
        setAntiGucciEnabled(v)
    end
})

UIElements.DefenseAntiKickToggle = DefenseAntiSec:AddToggle({
    Name = "アンチキック",
    Default = false,
    Callback = function(v)
        setAntiKickEnabled(v)
    end
})

local CounterSec = DefenseTab:AddSection({ Name = "Counter-Attack" })
CounterSec:AddToggle({
    Name = "自動反撃",
    Default = false,
    Callback = function(v)
        _G.AutoAttacker = v
    end,
    Save = true,
    Flag = "rinnegan_toggle"
})
CounterSec:AddDropdown({
    Name = "カウンターモード",
    Default = "弾き飛ばし",
    Options = {"弾き飛ばし", "キル"},
    Callback = function(v)
        counterMode = v
    end
})

-- --- TAB: AURA (test.lua準拠) ---
local NormalAurasSec = AuraTab:AddSection({ Name = "Normal Auras" })
local FlingAuraSec = AuraTab:AddSection({ Name = "Fling Aura" })

UIElements.KillAuraToggle = NormalAurasSec:AddToggle({
    Name = "キルオーラ",
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

                                    if not root:FindFirstChild("SkyVelocity") then
                                        local bv = Instance.new("BodyVelocity")
                                        bv.Name = "SkyVelocity"
                                        bv.Velocity = Vector3.new(0, 999999, 0)
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

UIElements.AttractionAuraToggle = NormalAurasSec:AddToggle({
    Name = "吸い付きオーラ",
    Default = false,
    Callback = function(v)
        _G.AttractionAura = v
        if v then
            task.spawn(function()
                while _G.AttractionAura do
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                            local hum = p.Character.Humanoid
                            if SNOWshipPlayer(p) then
                                hum.Sit = false
                                hum.WalkSpeed = 25
                                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
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

UIElements.FlingAuraToggle = FlingAuraSec:AddToggle({
    Name = "吹っ飛ばしオーラ",
    Default = false,
    Callback = function(v)
        _G.FlingAura = v
        if v then
            task.spawn(function()
                while _G.FlingAura do
                    if _G.FlingTarget == "プレイヤー" or _G.FlingTarget == "プレイヤーとオブジェクト" then
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

                    if _G.FlingTarget == "オブジェクト" or _G.FlingTarget == "プレイヤーとオブジェクト" then
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

UIElements.FlingStrengthSlider = FlingAuraSec:AddSlider({
    Name = "Strength",
    Min = 400,
    Max = 10000,
    Default = 400,
    Increment = 100,
    Callback = function(v) _G.FlingStrength = v end
})

FlingAuraSec:AddDropdown({
    Name = "ターゲット",
    Default = "プレイヤー",
    Options = {"プレイヤー", "オブジェクト", "プレイヤーとオブジェクト"},
    Callback = function(v) _G.FlingTarget = v end
})

local PlayerViewSec = PlayerTab:AddSection({ Name = "視点・カメラ" })

UIElements.ThirdPersonToggle = PlayerViewSec:AddToggle({
    Name = "三人称視点",
    Default = false,
    Callback = function(v) 
        if v then
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMaxZoomDistance = 500
            LocalPlayer.CameraMinZoomDistance = 0.5
        else
            LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
            LocalPlayer.CameraMaxZoomDistance = 0.5
            LocalPlayer.CameraMinZoomDistance = 0.5
        end
    end 
})

local currentFOV = Camera.FieldOfView
UIElements.FOVSlider = PlayerViewSec:AddSlider({
    Name = "FOV調整",
    Min = 30,
    Max = 120,
    Default = currentFOV,
    Increment = 1,
    Callback = function(v)
        Camera.FieldOfView = v
    end    
})

-- --- MAIN SECTION ---

local MainSec = MainTab:AddSection({
	Name = "エフェクト制御"
})

-- メイン対象ドロップダウン（変数として定義）
targetMainName = targetMainName ~= "" and targetMainName or "" -- 名前を保存する変数を共有
local tpDropdown = nil
local actionTargetDropdown = nil
local loopKillTargetDropdown = nil

local pDropMain
UIElements.MainTargetDropdown = MainSec:AddDropdown({
    Name = "メイン対象",
    Default = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")",
    Options = getPList(),
    Callback = function(v)
        -- @以降を正確に切り出す (アンダーバー等にも対応)
        local name = v:match("@([^)]+)")
        targetMainName = name or LocalPlayer.Name
        targetMain = Players:FindFirstChild(targetMainName) or LocalPlayer
    end    
})
pDropMain = UIElements.MainTargetDropdown
local currentCombinedSlot = 1
local cl_Mode, cl_Item, cl_Count, cl_Speed, cl_Size, cl_Height, cl_Back, cl_RotX, cl_RotY, cl_RotZ

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    pDropMain:Refresh(getPList(), true)
    if decoyTargetDropdown then decoyTargetDropdown:Refresh(getPList(), true) end
    if tpDropdown then tpDropdown:Refresh(getPList(), true) end -- テレポート用
    if actionTargetDropdown then actionTargetDropdown:Refresh(getPList(), true) end
    if loopKillTargetDropdown then loopKillTargetDropdown:Refresh(getPList(), true) end
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    pDropMain:Refresh(getPList(), true)
    if decoyTargetDropdown then decoyTargetDropdown:Refresh(getPList(), true) end
    if tpDropdown then tpDropdown:Refresh(getPList(), true) end -- テレポート用
    if actionTargetDropdown then actionTargetDropdown:Refresh(getPList(), true) end
    if loopKillTargetDropdown then loopKillTargetDropdown:Refresh(getPList(), true) end
end)

-- エフェクト有効化トグル
UIElements.EffectToggle = MainSec:AddToggle({
	Name = "エフェクト有効化",
	Default = false,
	Callback = function(v)
		if v then startEffect() else stopEffect() end
	end    
})

-- 追従方法ドロップダウン
UIElements.FollowMethodDropdown = MainSec:AddDropdown({
    Name = "追従方法",
    Default = "プレイヤー",
    Options = {"プレイヤー", "固定", "視線の先"},
    Callback = function(v)
        followMethod = v
    end
})

-- モード選択ドロップダウン
UIElements.ModeDropdown = MainSec:AddDropdown({
	Name = "モード選択",
	Default = modeNames["Wing"],
	Options = getModeList(),
	Callback = function(v)
		currentMode = modeKeys[v]
		combinedActive = false
	end    
})

-- 制御対象ドロップダウン
local itemDropdown

UIElements.ItemDropdown = MainSec:AddDropdown({
    Name = "制御対象の選択",
    Default = "なし",
    Options = {"なし"},
    Callback = function(v)
        selectedItemName = v
    end    
})
itemDropdown = UIElements.ItemDropdown

-- おもちゃリストをスキャンしてドロップダウンを更新する共通関数
local function refreshToyList()
    detectedItems = {}
    local myName = LocalPlayer.Name
    local allMyItems = {}
    local plotsFolder = Workspace:FindFirstChild("Plots")
    local plotItemsFolder = Workspace:FindFirstChild("PlotItems")

    -- 0. Get items from SpawnedInToys
    if useOtherToys then
        for _, folder in ipairs(Workspace:GetChildren()) do
            if folder.Name:match("SpawnedInToys$") then
                for _, item in ipairs(folder:GetChildren()) do
                    table.insert(allMyItems, item)
                end
            end
        end
    else
        local spawnedToys = Workspace:FindFirstChild(myName .. "SpawnedInToys")
        if spawnedToys then
            for _, item in ipairs(spawnedToys:GetChildren()) do
                table.insert(allMyItems, item)
            end
        end
    end

    -- 1. Get items from my plot
    if plotsFolder and plotItemsFolder then
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local ownerObj = sign and (sign:FindFirstChild("ThisPlotsOwners") or sign:FindFirstChild("Owner"))
            if ownerObj then
                local val = ownerObj:FindFirstChild("Value") or ownerObj
                local data = val:FindFirstChild("Data") or val
                local isMine = (data:IsA("StringValue") and data.Value == myName)
                
                if isMine or useOtherToys then
                    local myPlotName = plot.Name
                    local targetFolder = plotItemsFolder:FindFirstChild(myPlotName)
                    if targetFolder then
                        for _, item in ipairs(targetFolder:GetChildren()) do
                            table.insert(allMyItems, item)
                        end
                        -- ★このフォルダの増減を監視開始 (初回のみ)
                        if isMine and not _G.ToyWatcher then
                            _G.ToyWatcher = true
                            targetFolder.ChildAdded:Connect(function() task.wait(0.1) refreshToyList() end)
                            targetFolder.ChildRemoved:Connect(function() task.wait(0.1) refreshToyList() end)
                        end
                    end
                    if isMine and not useOtherToys then break end
                end
            end
        end
    end

    -- 2. Get items directly from Workspace that I own
    for _, item in ipairs(Workspace:GetChildren()) do
        local ownerValue = item:FindFirstChild("Owner") or item:FindFirstChild("PartOwner")
        if item:IsA("Model") and ownerValue and ownerValue:IsA("StringValue") then
            if (ownerValue.Value == myName or useOtherToys) and not table.find(allMyItems, item) then
                 table.insert(allMyItems, item)
            end
        end
    end

    -- 3. Process all found items to create the name list
    for _, item in ipairs(allMyItems) do
        if item:IsA("Model") and item.PrimaryPart then
            local itemName = tostring(item.Name)
            if not table.find(detectedItems, itemName) then
                table.insert(detectedItems, itemName)
            end
        end
    end
    
    -- 4. Update dropdown
    local mainValues = {"全てのおもちゃ"}
    local combinedValues = {"全てのおもちゃ", "メインと同期"}
    for _, name in ipairs(detectedItems) do 
        table.insert(mainValues, name)
        table.insert(combinedValues, name)
    end

    if itemDropdown then
        itemDropdown:Refresh(mainValues, true)
    end
    if cl_Item then
        cl_Item:Refresh(combinedValues, true)
        local sKey = "Mode"..currentCombinedSlot
        cl_Item:Set(cfg.Combined[sKey.."Item"] or "メインと同期")
    end
end

MainSec:AddButton({
    Name = "おもちゃリスト更新",
    Callback = function()
        refreshToyList()
        OrionLib:MakeNotification({ Name = "更新", Content = "おもちゃリストを再スキャンしました", Time = 3 })
    end
})

UIElements.OtherToysToggle = MainSec:AddToggle({
    Name = "他人のおもちゃも使用",
    Default = false,
    Callback = function(v)
        useOtherToys = v
        refreshToyList()
    end
})

-- 起動時に一度実行
task.spawn(refreshToyList)


-- --- アニメーションセクション ---
local AnimSec = MainTab:AddSection({
	Name = "アニメーション"
})

local seqRunning = false
AnimSec:AddToggle({
	Name = "変形シーケンス",
    Default = false,
	Callback = function(v)
        seqRunning = v
        if v then
            task.spawn(function()
                local s = 1 / cfg.AnimSpeed
                currentMode = "MagicCircle"
                cfg.MagicCircle.Height = -10
                startEffect()
                for i = -10, 5, 0.5 do 
                    if not seqRunning then break end
                    cfg.MagicCircle.Height = i
                    task.wait(0.2 * s) 
                end
                if not seqRunning then return end
                currentMode = "Merkaba"
                task.wait(6 * s)
                if not seqRunning then return end
                currentMode = "FloatStone"
                cfg.FloatStone.Chaos = true
                cfg.FloatStone.Size = 2
                for i = 2, 15, 0.5 do
                    if not seqRunning then break end
                    cfg.FloatStone.Size = i
                    task.wait(0.05 * s)
                end
            end)
        end
	end
})

local surgeRunning = false
AnimSec:AddToggle({
	Name = "Surge",
    Default = false,
	Callback = function(v)
        surgeRunning = v
        if v then
            task.spawn(function()
                local s = 1 / cfg.AnimSpeed
                currentMode = "MagicCircle"
                cfg.MagicCircle.Height = -3
                cfg.MagicCircle.Size = 5
                cfg.MagicCircle.Speed = 10
                startEffect()
                for i = 5, 30, 2 do
                    if not surgeRunning then break end
                    cfg.MagicCircle.Size = i
                    task.wait(0.09 * s)
                end
                if not surgeRunning then return end
                currentMode = "Sphere"
                cfg.Sphere.Size = 30
                task.wait(1 * s)
                if not surgeRunning then return end
                for i = 30, 3, 2 do
                    if not surgeRunning then break end
                    cfg.Sphere.Size = i
                    cfg.Sphere.Speed = (cfg.Sphere.Speed or 1) + 0.5
                    task.wait(0.05 * s)
                end
                if not surgeRunning then return end
                task.wait(0.9 * s)
                if not surgeRunning then return end
                cfg.Sphere.Speed = 20
                for i = 3, 25, 3 do
                    if not surgeRunning then break end
                    cfg.Sphere.Size = i
                    task.wait(0.04 * s)
                end
                if not surgeRunning then return end
                task.wait(1.5 * s)
                if not surgeRunning then return end
                currentMode = "BackGuard"
                cfg.BackGuard.Back = 15
                cfg.BackGuard.Height = 5
                cfg.BackGuard.Size = 20
                cfg.BackGuard.Speed = 1
            end)
        end
	end
})

-- モード設定タブは上部で作成済み

local CombineSec = ModeSetTab:AddSection({
    Name = "合体設定"
})

-- 合体モードトグル (ここに移動)
UIElements.CombinedToggle = CombineSec:AddToggle({
	Name = "合体モード使用",
	Default = false,
	Callback = function(v)
		combinedActive = v
	end    
})

local function getModeListWithNone()
    local list = {"なし"}
    local order = {"Wing","Heart","Star","Vortex","Sphere","Rotate","Pet","Text","MagicCircle","MagicCircle2","MagicCircle3","FloatStone","Merkaba","Cube","Pyramid","MirrorPlayer","Beam","BackGuard","Tornado","Gyro"}
    for _, k in ipairs(order) do table.insert(list, modeNames[k]) end
    return list
end

CombineSec:AddButton({
    Name = "おもちゃリスト更新",
    Callback = function()
        refreshToyList()
        OrionLib:MakeNotification({ Name = "更新", Content = "おもちゃリストを再スキャンしました", Time = 3 })
    end
})

UIElements.CombineSlotDropdown = CombineSec:AddDropdown({
    Name = "編集するスロットを選択",
    Default = "スロット 1",
    Options = {"スロット 1", "スロット 2", "スロット 3", "スロット 4", "スロット 5"},
    Callback = function(v)
        currentCombinedSlot = tonumber(v:match("%d+"))
        local sKey = "Mode"..currentCombinedSlot
        if cl_Mode then cl_Mode:Set(modeNames[cfg.Combined[sKey]] or cfg.Combined[sKey]) end
        if cl_Item then cl_Item:Set(cfg.Combined[sKey.."Item"] or "全てのおもちゃ") end
        if cl_Count then cl_Count:Set(cfg.Combined[sKey.."Count"] or 0) end
        if cl_Speed then cl_Speed:Set(cfg.Combined[sKey.."Speed"] or 1) end
        if cl_Size then cl_Size:Set(cfg.Combined[sKey.."Size"] or 1) end
        if cl_Height then cl_Height:Set(cfg.Combined[sKey.."Height"] or 0) end
        if cl_Back then cl_Back:Set(cfg.Combined[sKey.."Back"] or 0) end
        if cl_RotX then cl_RotX:Set(cfg.Combined[sKey.."RotX"] or 0) end
        if cl_RotY then cl_RotY:Set(cfg.Combined[sKey.."RotY"] or 0) end
        if cl_RotZ then cl_RotZ:Set(cfg.Combined[sKey.."RotZ"] or 0) end
    end
})

cl_Mode = CombineSec:AddDropdown({
    Name = "モード",
    Default = modeNames[cfg.Combined.Mode1],
    Options = getModeListWithNone(),
    Callback = function(v) cfg.Combined["Mode"..currentCombinedSlot] = modeKeys[v] end
})
UIElements.CombineModeEditor = cl_Mode

cl_Item = CombineSec:AddDropdown({
    Name = "使用するおもちゃ",
    Default = cfg.Combined.Mode1Item or "メインと同期",
    Options = {"全てのおもちゃ", "メインと同期"},
    Callback = function(v) cfg.Combined["Mode"..currentCombinedSlot.."Item"] = v end
})
UIElements.CombineItemEditor = cl_Item

cl_Count = CombineSec:AddSlider({
    Name = "使用数",
    Min = 0, Max = 200, Default = cfg.Combined.Mode1Count,
    Callback = function(v) cfg.Combined["Mode"..currentCombinedSlot.."Count"] = v end
})
UIElements.CombineCountEditor = cl_Count

cl_Speed = CombineSec:AddSlider({
    Name = "速度",
    Min = 0, Max = 100, Default = cfg.Combined.Mode1Speed,
    Callback = function(v) cfg.Combined["Mode"..currentCombinedSlot.."Speed"] = v end
})
UIElements.CombineSpeedEditor = cl_Speed

cl_Size = CombineSec:AddSlider({
    Name = "サイズ",
    Min = 1, Max = 150, Default = cfg.Combined.Mode1Size,
    Callback = function(v) cfg.Combined["Mode"..currentCombinedSlot.."Size"] = v end
})
UIElements.CombineSizeEditor = cl_Size

cl_Height = CombineSec:AddSlider({
    Name = "高さ",
    Min = -50, Max = 50, Default = cfg.Combined.Mode1Height,
    Callback = function(v) cfg.Combined["Mode"..currentCombinedSlot.."Height"] = v end
})
UIElements.CombineHeightEditor = cl_Height

cl_Back = CombineSec:AddSlider({
    Name = "奥行き",
    Min = -50, Max = 50, Default = cfg.Combined.Mode1Back,
    Callback = function(v) cfg.Combined["Mode"..currentCombinedSlot.."Back"] = v end
})
UIElements.CombineBackEditor = cl_Back

cl_RotX = CombineSec:AddSlider({
    Name = "個別回転 X", Min = -180, Max = 180, Default = cfg.Combined.Mode1RotX,
    Callback = function(v) cfg.Combined["Mode"..currentCombinedSlot.."RotX"] = v end
})
cl_RotY = CombineSec:AddSlider({
    Name = "個別回転 Y", Min = -180, Max = 180, Default = cfg.Combined.Mode1RotY,
    Callback = function(v) cfg.Combined["Mode"..currentCombinedSlot.."RotY"] = v end
})
cl_RotZ = CombineSec:AddSlider({
    Name = "個別回転 Z", Min = -180, Max = 180, Default = cfg.Combined.Mode1RotZ,
    Callback = function(v) cfg.Combined["Mode"..currentCombinedSlot.."RotZ"] = v end
})

-- --- 共通設定エディタ (ドロップダウンで切り替え) ---
local EditSec = ModeSetTab:AddSection({
    Name = "共通設定エディタ"
})

local modes = {"Wing","Heart","Star","Vortex","Sphere","Rotate","Pet","Text","MagicCircle","MagicCircle2","MagicCircle3","FloatStone","Merkaba","Cube","Pyramid","MirrorPlayer","Beam","BackGuard","Tornado","Gyro"}

local currentEditMode = "Wing"
local sl_Speed, sl_Size, sl_Height, sl_Back

EditSec:AddDropdown({
    Name = "編集対象モード",
    Default = modeNames["Wing"],
    Options = getModeList(),
    Callback = function(v)
        currentEditMode = modeKeys[v]
        -- スライダーの値を更新
        if sl_Speed then sl_Speed:Set(cfg[currentEditMode].Speed or 10) end
        if sl_Size then sl_Size:Set(cfg[currentEditMode].Size or 10) end
        if sl_Height then sl_Height:Set(cfg[currentEditMode].Height or 0) end
        if sl_Back then sl_Back:Set(cfg[currentEditMode].Back or 0) end
    end
})

sl_Speed = EditSec:AddSlider({
    Name = "速度", Min = 0, Max = 100, Default = cfg.Wing.Speed or 10,
    Callback = function(v) cfg[currentEditMode].Speed = v end
})
sl_Size = EditSec:AddSlider({
    Name = "サイズ/幅", Min = 1, Max = 150, Default = cfg.Wing.Size or 10,
    Callback = function(v) cfg[currentEditMode].Size = v end
})
sl_Height = EditSec:AddSlider({
    Name = "高さ", Min = -50, Max = 50, Default = cfg.Wing.Height or 0,
    Callback = function(v) cfg[currentEditMode].Height = v end
})
sl_Back = EditSec:AddSlider({
    Name = "奥行き", Min = -50, Max = 50, Default = cfg.Wing.Back or 0,
    Callback = function(v) cfg[currentEditMode].Back = v end
})

-- --- 詳細設定 (モード設定タブへ統合) ---
local AdvTab = ModeSetTab

for _, m in ipairs(modes) do
    -- 固有設定があるモードのみセクションを作成
    if m == "Wing" or m == "Pet" or m == "Text" or m == "MagicCircle2" or m == "MagicCircle3" or m == "Beam" or m == "FloatStone" or m == "Tornado" or m == "Rotate" then
        local s = AdvTab:AddSection({ Name = modeNames[m] or m })
        
        if m == "Wing" then
            s:AddToggle({ Name = "付け根を固定 (Root Fixed)", Default = cfg.Wing.RootFixed, Callback = function(v) cfg.Wing.RootFixed = v end })
            s:AddSlider({ Name = "体との距離 (Gap)", Min = 0, Max = 50, Default = cfg.Wing.Gap or 10, Callback = function(v) cfg.Wing.Gap = v end })
            s:AddSlider({ Name = "関節数", Min = 0, Max = 10, Default = 3, Callback = function(v) cfg.Wing.Joints = v end })
            s:AddSlider({ Name = "V字角度 (前後方向)", Min = -180, Max = 180, Default = 0, Callback = function(v) cfg.Wing.V_Angle = v end })
            s:AddSlider({ Name = "上下傾斜", Min = -90, Max = 90, Default = 0, Callback = function(v) cfg.Wing.Tilt = v end })
            s:AddSlider({ Name = "羽ばたき強度", Min = 0, Max = 50, Default = 15, Callback = function(v) cfg.Wing.Strength = v end })
            s:AddToggle({ Name = "カーブ (反り)", Default = cfg.Wing.Curve or false, Callback = function(v) cfg.Wing.Curve = v end })
            s:AddSlider({ Name = "カーブ強度 (反り)", Min = -50, Max = 50, Default = cfg.Wing.CurveAmount or 10, Callback = function(v) cfg.Wing.CurveAmount = v end })
            s:AddToggle({
                Name = "遅延モード (移動時にV字化)",
                Default = cfg.Global.MoveDelay or false,
                Callback = function(v) cfg.Global.MoveDelay = v end
            })
            s:AddSlider({
                Name = "遅延の強さ",
                Min = 1, Max = 50, Default = (cfg.Global.MoveDelayWeight or 0.05) * 100,
                Callback = function(v) cfg.Global.MoveDelayWeight = v / 100 end
            })
        
        elseif m == "Pet" then
            s:AddSlider({ Name = "個体数", Min = 1, Max = 10, Default = 2, Callback = function(v) cfg.Pet.Count = v end })
            s:AddSlider({ Name = "関節数(うねり)", Min = 0, Max = 10, Default = 3, Callback = function(v) cfg.Pet.Joints = v end })
            s:AddSlider({ Name = "横の広がり(Gap)", Min = 1, Max = 20, Default = 13, Callback = function(v) cfg.Pet.Gap = v end })
        
        elseif m == "Text" then
            s:AddTextbox({ Name = "表示テキスト", Default = "HELLO", TextDisappear = false, Callback = function(v) cfg.Text.Content = v end })
        
        elseif m == "MagicCircle2" then
            s:AddSlider({ Name = "レイヤー数", Min = 1, Max = 5, Default = 3, Callback = function(v) cfg.MagicCircle2.Layers = v end })
        
        elseif m == "MagicCircle3" then
            s:AddSlider({ Name = "複雑度", Min = 1, Max = 10, Default = 5, Callback = function(v) cfg.MagicCircle3.Complexity = v end })
        
        elseif m == "Beam" then
            s:AddSlider({ Name = "ビーム本数", Min = 1, Max = 20, Default = 8, Callback = function(v) cfg.Beam.Count = v end })
        
        elseif m == "FloatStone" then
            s:AddToggle({ Name = "カオス移動", Default = false, Callback = function(v) cfg.FloatStone.Chaos = v end })

        elseif m == "Tornado" then
            s:AddSlider({ Name = "下部幅", Min = 0, Max = 50, Default = cfg.Tornado.Radius, Callback = function(v) cfg.Tornado.Radius = v end })
            s:AddSlider({ Name = "上部幅", Min = 0, Max = 50, Default = cfg.Tornado.TopRadius, Callback = function(v) cfg.Tornado.TopRadius = v end })
            s:AddToggle({ Name = "ピラミッド形状", Default = false, Callback = function(v) cfg.Tornado.Pyramid = v end })

        elseif m == "Rotate" then
            s:AddToggle({ Name = "ウェーブ (くねくね)", Default = cfg.Rotate.Wave or false, Callback = function(v) cfg.Rotate.Wave = v end })
            s:AddSlider({ Name = "ウェーブ速度", Min = 1, Max = 20, Default = cfg.Rotate.WaveSpeed or 2, Callback = function(v) cfg.Rotate.WaveSpeed = v end })
            s:AddSlider({ Name = "ウェーブ振幅", Min = 1, Max = 20, Default = cfg.Rotate.WaveAmp or 2, Callback = function(v) cfg.Rotate.WaveAmp = v end })
        end
    end
end

-- 全体タブは上部で作成済み

local GlobalSec = SubTab:AddSection({
    Name = "システム"
})

-- 0,0,0リセットボタン
GlobalSec:AddButton({
    Name = "エフェクトをワールド0,0,0にリセット",
    Callback = function()
        if not isEnabled then return end
        followMethod = "固定"
        lastBaseCF = CFrame.new(0, 0, 0) 
        
        if UIElements.FollowMethodDropdown then
            UIElements.FollowMethodDropdown:Set("固定")
        end

        for i, fw in ipairs(activeToys) do
            task.spawn(function()
                fw.AP.Enabled = false 
                fw.Part.Anchored = true
                fw.Part.CFrame = CFrame.new(0, 0, 0)
                fw.AP.Position = Vector3.new(0, 0, 0) 
                fw.Part.AssemblyLinearVelocity = Vector3.zero
                
                task.wait(0.1)
                
                fw.AP.Enabled = true 
                fw.Part.Anchored = false
            end)
        end
    end
})

UIElements.MaxToysSlider = GlobalSec:AddSlider({
    Name = "使用するおもちゃの最大数",
    Min = 1, Max = 200, Default = cfg.Global.MaxToys or 100,
    Callback = function(v) cfg.Global.MaxToys = v end
})

UIElements.AutoWidthToggle = GlobalSec:AddToggle({
    Name = "幅自動調整",
    Default = true,
    Callback = function(v) autoWidth = v end
})

UIElements.LowLatencyToggle = GlobalSec:AddToggle({
    Name = "低遅延モード（他人用）",
    Default = false,
    Callback = function(v)
        lowLatencyMode = v
        if isEnabled then startEffect() end
    end
})

-- アニメ速度倍率 (小数のため10倍で処理)
UIElements.AnimSpeedSlider = GlobalSec:AddSlider({
    Name = "アニメ速度倍率",
    Min = 1, Max = 50, Default = 10,
    Callback = function(v) cfg.AnimSpeed = v/10 end
})

-- --- 家制限時間リセット設定 ---
local ResetSec = SubTab:AddSection({
    Name = "家制限時間リセット"
})

HomeStatus = ResetSec:AddParagraph("家の状態", "待機中...")

UIElements.PlotReturnToggle = ResetSec:AddToggle({
    Name = "自動家検知＆リセット",
    Default = cfg.PlotReturn.Enabled,
    Callback = function(v)
        cfg.PlotReturn.Enabled = v
        if not v and HomeStatus then HomeStatus:Set("無効化中") end
    end
})

-- --- 座標管理システム ---
local CoordSec = SubTab:AddSection({
    Name = "座標・位置管理"
})

local CoordHUD = nil
local HUDLabel = nil
local coordUpdateConn = nil

CoordSec:AddToggle({
    Name = "別ウィンドウで座標を常に表示",
    Default = false,
    Callback = function(state)
        if state then
            if not CoordHUD then
                CoordHUD = Instance.new("ScreenGui")
                CoordHUD.Name = "HolonHUD_Coords"
                CoordHUD.Parent = (game:GetService("CoreGui"):FindFirstChild("RobloxGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
                
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(0, 180, 0, 35)
                Frame.Position = UDim2.new(0.5, -90, 0.05, 0)
                Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                Frame.BackgroundTransparency = 0.4
                Frame.BorderSizePixel = 0
                Frame.Active = true
                Frame.Draggable = true 
                Frame.Parent = CoordHUD
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 8)
                Corner.Parent = Frame

                HUDLabel = Instance.new("TextLabel")
                HUDLabel.Size = UDim2.new(1, 0, 1, 0)
                HUDLabel.BackgroundTransparency = 1
                HUDLabel.TextColor3 = Color3.new(1, 1, 1)
                HUDLabel.Font = Enum.Font.Code
                HUDLabel.TextSize = 16
                HUDLabel.Text = "X: 0 | Y: 0 | Z: 0"
                HUDLabel.Parent = Frame
            end
            CoordHUD.Enabled = true
            if coordUpdateConn then coordUpdateConn:Disconnect() end
            coordUpdateConn = RunService.Heartbeat:Connect(function()
                local c = LocalPlayer.Character
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if r and HUDLabel then
                    local p = r.Position
                    HUDLabel.Text = string.format("X: %d | Y: %d | Z: %d", math.round(p.X), math.round(p.Y), math.round(p.Z))
                end
            end)
        else
            if CoordHUD then CoordHUD.Enabled = false end
            if coordUpdateConn then coordUpdateConn:Disconnect() coordUpdateConn = nil end
        end
    end
})

CoordSec:AddButton({
    Name = "現在の座標をコピー",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local p = root.Position
            local posString = string.format("%d, %d, %d", math.round(p.X), math.round(p.Y), math.round(p.Z))
            setclipboard(posString)
            OrionLib:MakeNotification({
                Name = "コピー完了",
                Content = posString,
                Time = 5
            })
        end
    end
})

local EffectRotSec = SubTab:AddSection({ Name = "エフェクト全体の向き" })
UIElements.EffectRotationX = EffectRotSec:AddSlider({
    Name = "X軸 (Pitch)", Min = -180, Max = 180, Default = 0,
    Callback = function(v) cfg.Global.EffectRotation = Vector3.new(v, cfg.Global.EffectRotation.Y, cfg.Global.EffectRotation.Z) end
})
UIElements.EffectRotationY = EffectRotSec:AddSlider({
    Name = "Y軸 (Yaw)", Min = -180, Max = 180, Default = 0,
    Callback = function(v) cfg.Global.EffectRotation = Vector3.new(cfg.Global.EffectRotation.X, v, cfg.Global.EffectRotation.Z) end
})
UIElements.EffectRotationZ = EffectRotSec:AddSlider({
    Name = "Z軸 (Roll)", Min = -180, Max = 180, Default = 0,
    Callback = function(v) cfg.Global.EffectRotation = Vector3.new(cfg.Global.EffectRotation.X, cfg.Global.EffectRotation.Y, v) end
})

local IndivRotSec = SubTab:AddSection({ Name = "おもちゃ自体の向き" })
UIElements.IndividualRotationX = IndivRotSec:AddSlider({
    Name = "X軸 (Pitch)", Min = -180, Max = 180, Default = 0,
    Callback = function(v) cfg.Global.IndividualRotation = Vector3.new(v, cfg.Global.IndividualRotation.Y, cfg.Global.IndividualRotation.Z) end
})
UIElements.IndividualRotationY = IndivRotSec:AddSlider({
    Name = "Y軸 (Yaw)", Min = -180, Max = 180, Default = -90,
    Callback = function(v) cfg.Global.IndividualRotation = Vector3.new(cfg.Global.IndividualRotation.X, v, cfg.Global.IndividualRotation.Z) end
})
UIElements.IndividualRotationZ = IndivRotSec:AddSlider({
    Name = "Z軸 (Roll)", Min = -180, Max = 180, Default = 0,
    Callback = function(v) cfg.Global.IndividualRotation = Vector3.new(cfg.Global.IndividualRotation.X, cfg.Global.IndividualRotation.Y, v) end
})

-- サブ機能タブは上部で作成済み

-- サブターゲットセクション
local SubTargetSec = SubTab:AddSection({
    Name = "サブターゲット"
})

-- 1. ドロップダウンの作成
local targetSubName = "" 

UIElements.SubTargetDropdown = SubTargetSec:AddDropdown({
    Name = "対象選択",
    Default = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")",
    Options = getPList(),
    Callback = function(v)
        -- @以降のユーザー名を正確に切り出す
        local name = v:match("@([^)]+)")
        targetSubName = name or LocalPlayer.Name
        
        -- 即座に最新のオブジェクトも一度取得しておく（既存コードとの互換性のため）
        targetSub = Players:FindFirstChild(targetSubName) or LocalPlayer
    end    
})
pDropSub = UIElements.SubTargetDropdown

Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    pDropSub:Refresh(getPList(), true)
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    pDropSub:Refresh(getPList(), true)
end)

-- プレイヤーリストは PlayerAdded / PlayerRemoving で自動更新

-- 視点・カメラセクション
local ViewSec = SubTab:AddSection({
    Name = "視点・カメラ"
})

ViewSec:AddToggle({
    Name = "視点ジャック",
    Default = false,
    Callback = function(v) 
        if v then 
            RunService:BindToRenderStep("Jack", Enum.RenderPriority.Camera.Value + 1, function() 
                if targetSub and targetSub.Character and targetSub.Character:FindFirstChild("Humanoid") then 
                    Camera.CameraSubject = targetSub.Character.Humanoid 
                end 
            end)
        else 
            RunService:UnbindFromRenderStep("Jack")
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character.Humanoid 
            end
        end
    end 
})

ViewSec:AddButton({
    Name = "選択したプレイヤーへテレポート",
    Callback = function()
        local target = targetSub
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    end
})

-- ESP設定セクション
local EspSec = SubTab:AddSection({
    Name = "ESP設定"
})

UIElements.EspEnabled = EspSec:AddToggle({
    Name = "ESP有効",
    Default = false,
    Callback = function(v) espCfg.Enabled = v end 
})

UIElements.EspTargetOnly = EspSec:AddToggle({
    Name = "ターゲットのみ表示",
    Default = false,
    Callback = function(v) espCfg.TargetOnly = v end 
})

UIElements.EspNames = EspSec:AddToggle({
    Name = "名前表示",
    Default = true,
    Callback = function(v) espCfg.Names = v end 
})

UIElements.EspTracers = EspSec:AddToggle({
    Name = "トレーサー表示",
    Default = false,
    Callback = function(v) espCfg.Tracers = v end 
})

UIElements.EspHitbox = EspSec:AddToggle({
    Name = "ヒットボックス",
    Default = false,
    Callback = function(v) espCfg.Hitbox = v end 
})

UIElements.EspHitboxSize = EspSec:AddSlider({
    Name = "ヒットボックスサイズ",
    Min = 2,
    Max = 20,
    Default = 10,
    Callback = function(v) espCfg.HitboxSize = v end 
})

UIElements.EspColor = EspSec:AddColorpicker({
    Name = "ESPカラー",
    Default = Color3.new(1,0,0),
    Callback = function(v)
        espCfg.ESPColor = v
    end	  
})

local BarrierSec = SubTab:AddSection({
    Name = "バリア破壊"
})

BarrierSec:AddButton({
    Name = "バリア破壊 (Barrier Break)",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        if not player then
            OrionLib:MakeNotification({Name="Error", Content="Player not found", Time = 4})
            return
        end

        if not (player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then
            OrionLib:MakeNotification({Name="Error", Content="Character not ready", Time = 4})
            return
        end

        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        local originalWalkSpeed, originalJumpPower
        if humanoid then
            originalWalkSpeed = humanoid.WalkSpeed
            originalJumpPower = humanoid.JumpPower
            pcall(function() humanoid.WalkSpeed = 0 humanoid.JumpPower = 0 end)
        end

        local success, err = pcall(function()
            local MenuToys = ReplicatedStorage:WaitForChild("MenuToys")
            local hrp = player.Character.HumanoidRootPart
            local originalCFrame = hrp.CFrame

            hrp.CFrame = CFrame.new(246.052, -7.35, 431.821)
            task.wait(0.05)

            MenuToys.SpawnToyRemoteFunction:InvokeServer(
                "InstrumentWoodwindOcarina",
                CFrame.new(184.148834, -5.54824972, 498.136749,
                    0.829037189, -0.214714944, 0.516328275,
                    0, 0.923344612, 0.383972496,
                    -0.559193552, -0.318327487, 0.765486956),
                Vector3.new(0, 34, 0)
            )

            task.wait(0.2)

            local toyFolder = Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
            if not toyFolder then error("SpawnedInToys folder not found") end

            local ocarina = toyFolder:FindFirstChild("InstrumentWoodwindOcarina")
            if not ocarina then error("InstrumentWoodwindOcarina not found") end

            if ocarina:FindFirstChild("HoldPart") and ocarina.HoldPart:FindFirstChild("HoldItemRemoteFunction") then
                pcall(function()
                    ocarina.HoldPart.HoldItemRemoteFunction:InvokeServer(ocarina, player.Character)
                end)
                task.wait(0.2)
            end

            player.Character.HumanoidRootPart.CFrame = CFrame.new(304.06, 25.77, 488.54)
            task.wait(0.05)

            if MenuToys:FindFirstChild("DestroyToy") then
                MenuToys.DestroyToy:FireServer(ocarina)
            else
                local destroyEv = ReplicatedStorage:FindFirstChild("MenuToys") and ReplicatedStorage.MenuToys:FindFirstChild("DestroyToy")
                if destroyEv then
                    destroyEv:FireServer(ocarina)
                else
                    error("DestroyToy event not found")
                end
            end

            task.wait(0.05)

            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = originalCFrame
            end

            OrionLib:MakeNotification({Name="Success", Content="バリア破壊を実行しました", Time = 3})
        end)

        local function tryRestore()
            if originalWalkSpeed == nil and originalJumpPower == nil then return end
            local curHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if curHum then
                pcall(function()
                    if originalWalkSpeed ~= nil then curHum.WalkSpeed = originalWalkSpeed end
                    if originalJumpPower ~= nil then curHum.JumpPower = originalJumpPower end
                end)
            end
        end

        tryRestore()

        if not success then
            OrionLib:MakeNotification({Name="Error", Content=tostring(err), Time = 6})
        end
    end
})

-- 掴むタブは上部で作成済み

local GrabControlSec = GrabTab:AddSection({ Name = "掴み制御" })

UIElements.SuperStrengthToggle = GrabControlSec:AddToggle({
    Name = "スーパースロー",
    Default = false,
    Callback = function(v)
        superStrengthEnabled = v
    end
})

UIElements.StrengthSlider = GrabControlSec:AddSlider({
    Name = "強さ",
    Min = 400,
    Max = 10000,
    Default = 400,
    Increment = 100,
    ValueName = "Power",
    Callback = function(v)
        strengthValue = v
    end
})

UIElements.SpinGrabToggle = GrabControlSec:AddToggle({
    Name = "回転掴む",
    Default = cfg.GrabMod.Spin,
    Callback = function(v)
        cfg.GrabMod.Spin = v
    end
})

UIElements.DeathGrabToggle = GrabControlSec:AddToggle({
    Name = "キル掴む",
    Default = false,
    Callback = function(v)
        deathGrabEnabled = v
    end
})

UIElements.NoclipGrabToggle = GrabControlSec:AddToggle({
    Name = "すり抜け掴む",
    Default = false,
    Callback = function(v)
        noclipGrabEnabled = v
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
    Name = "クレイジーライン",
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
                                pcall(function()
                                    GrabEvents.CreateGrabLine:FireServer(targetPart, CFrame.new(0.12640380859375, 0.9606337547302246, -0.5000009536743164, 0.9985212683677673, 0, -0.05436277016997337, -6.4805472099749295e-9, 1, -1.1903301100346653e-7, 0.05436277016997337, 5.960464477539063e-8, 0.9985212683677673))
                                end)
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
    Name = "透明ライン",
    Default = false,
    Callback = function(v)
        invisibleLineEnabled = v
    end
})

UIElements.RainbowLineToggle = GrabControlSec:AddToggle({
    Name = "虹色ライン",
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

UIElements.FurtherExtendToggle = FurtherExtendSec:AddToggle({
    Name = "線の延長",
    Default = false,
    Callback = function(Value)
        _G.FutherExtend = Value
    end
})

UIElements.ExtendAmountSlider = FurtherExtendSec:AddSlider({
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

local PerspectiveGrabSec = GrabTab:AddSection({ Name = "掴むと透明になる" })

UIElements.PerspectiveGrabToggle = PerspectiveGrabSec:AddToggle({
    Name = "透明化掴む",
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
    Callback = function(v)
        perspectiveSpeed = v
    end
})

-- --- TAB: ACTION (ported from test.lua) ---
local actionTargetSection = ActionTab:AddSection({ Name = "対象アクション" })
local selectedActionTargetName = ""
actionTargetDropdown = nil

local function parseSelectedPlayerName(v)
    if v == "選択してください" then
        return ""
    end
    return (v and v:match("@([^)]+)")) or ""
end

actionTargetDropdown = actionTargetSection:AddDropdown({
    Name = "アクション対象",
    Default = "選択してください",
    Options = getPList(),
    Callback = function(v)
        selectedActionTargetName = parseSelectedPlayerName(v)
    end
})

-- 対象リストは PlayerAdded / PlayerRemoving で自動更新

actionTargetSection:AddButton({
    Name = "Blobman bring",
    Callback = function()
        local target = Players:FindFirstChild(selectedActionTargetName)
        if not (target and target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart")) then
            OrionLib:MakeNotification({ Name = "エラー", Content = "対象プレイヤーを選択してください", Time = 3 })
            return
        end
        if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
            return
        end

        local blobman = nil
        local spawned = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
        if spawned then blobman = spawned:FindFirstChild("CreatureBlobman") end

        if not blobman then
            local mt = ReplicatedStorage:FindFirstChild("MenuToys")
            local st = mt and mt:FindFirstChild("SpawnToyRemoteFunction")
            if st then
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local spawnCF = myRoot and (myRoot.CFrame + Vector3.new(0, 5, 0)) or CFrame.new(0, 50, 0)
                st:InvokeServer("CreatureBlobman", spawnCF, Vector3.zero)
                task.wait(0.5)
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

        if not blobman then
            OrionLib:MakeNotification({ Name = "エラー", Content = "Blobmanが見つかりません", Time = 3 })
            return
        end

        local scriptObj = blobman:FindFirstChild("BlobmanSeatAndOwnerScript")
        local grabRemote = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
        local dropRemote = scriptObj and scriptObj:FindFirstChild("CreatureDrop")
        local lDet = blobman:FindFirstChild("LeftDetector")
        local rDet = blobman:FindFirstChild("RightDetector")
        local lWeld = lDet and (lDet:FindFirstChild("LeftWeld") or lDet:FindFirstChild("RigidConstraint"))
        local rWeld = rDet and (rDet:FindFirstChild("RightWeld") or rDet:FindFirstChild("RigidConstraint"))

        local seat = blobman:FindFirstChild("VehicleSeat")
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if seat and hum and seat.Occupant ~= hum then
            LocalPlayer.Character.HumanoidRootPart.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
            seat:Sit(hum)
            task.wait(0.3)
        end

        if not (grabRemote and dropRemote and ((lDet and lWeld) or (rDet and rWeld))) then
            local missing = {}
            if not grabRemote then table.insert(missing, "CreatureGrab") end
            if not dropRemote then table.insert(missing, "CreatureDrop") end
            if not (lDet or rDet) then table.insert(missing, "Detector") end
            if not (lWeld or rWeld) then table.insert(missing, "Weld/Constraint") end
            OrionLib:MakeNotification({ Name = "エラー", Content = "不足: " .. table.concat(missing, ", "), Time = 5 })
            return
        end

        OrionLib:MakeNotification({ Name = "実行", Content = "Blobman Bring (Once)", Time = 3 })
        task.spawn(function()
            local ge = ReplicatedStorage:WaitForChild("GrabEvents")
            local blobRoot = blobman:FindFirstChild("HumanoidRootPart") or blobman.PrimaryPart
            if not blobRoot then return end
            local savedPos = blobRoot.CFrame
            local det = rDet or lDet
            local weld = rWeld or lWeld

            local bringStart = tick()
            while tick() - bringStart < 0.5 do
                if not (blobman and blobman.Parent) then break end
                if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local tRoot = target.Character.HumanoidRootPart
                    blobRoot.CFrame = tRoot.CFrame
                    blobRoot.AssemblyLinearVelocity = Vector3.zero
                    pcall(function()
                        if det then grabRemote:FireServer(det, tRoot, weld) end
                        ge.CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false)
                        ge.SetNetworkOwner:FireServer(tRoot, blobRoot.CFrame)
                    end)
                end
                RunService.Heartbeat:Wait()
            end

            blobRoot.CFrame = savedPos
            blobRoot.AssemblyLinearVelocity = Vector3.zero
            task.wait(0.05)

            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local tRoot = target.Character.HumanoidRootPart
                tRoot.CFrame = blobRoot.CFrame
                tRoot.AssemblyLinearVelocity = Vector3.zero
            end
        end)
    end
})

local levitateRunning = false
UIElements.BlobmanKick = actionTargetSection:AddToggle({
    Name = "Blobman Kick",
    Default = false,
    Callback = function(v)
        levitateRunning = v
        if not v then return end

        local target = Players:FindFirstChild(selectedActionTargetName)
        
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
                    OrionLib:MakeNotification({ Name = "実行", Content = "Blobman Kick Loop", Time = 3 })

                    task.spawn(function()
                        -- raw.txt Logic Implementation
                        local GE = ReplicatedStorage:WaitForChild("GrabEvents")
                        local blobRoot = blobman:FindFirstChild("HumanoidRootPart") or blobman.PrimaryPart
                        local SavedPos = blobRoot.CFrame
                        
                        -- Prefer Right, fallback to Left
                        local Det = rDet or lDet
                        local Weld = rWeld or lWeld
                        
                        -- Phase 1: Capture
                        local bringStart = tick()
                        while tick() - bringStart < 0.35 do
                            if not levitateRunning or not blobman or not blobman.Parent then break end
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
                        
                        if blobRoot then
                            blobRoot.CFrame = SavedPos
                            blobRoot.AssemblyLinearVelocity = Vector3.zero
                            task.wait(0.05)
                        end
                        
                        -- Phase 2: Lock
                        while levitateRunning and blobman and blobman.Parent do
                            if not target or not target.Parent or not target.Character then break end
                            
                            local tChar = target.Character
                            local tRoot = tChar:FindFirstChild("HumanoidRootPart")
                            local tHum = tChar:FindFirstChild("Humanoid")
                            
                            if tRoot and tHum and tHum.Health > 0 and blobRoot then
                                blobRoot.CFrame = SavedPos
                                blobRoot.AssemblyLinearVelocity = Vector3.zero
                                
                                local lockPos = SavedPos * CFrame.new(0, 23, 0)
                                tRoot.CFrame = lockPos
                                tRoot.AssemblyLinearVelocity = Vector3.zero
                                tRoot.AssemblyAngularVelocity = Vector3.zero
                                
                                pcall(function()
                                    tHum.PlatformStand = true
                                    tHum.Sit = true
                                    GE.SetNetworkOwner:FireServer(tRoot, lockPos)
                                    
                                    -- Check for existing weld to drop
                                    local currentWeld = Det:FindFirstChild("RightWeld") or Det:FindFirstChild("LeftWeld") or Det:FindFirstChildWhichIsA("Weld") or Det:FindFirstChild("RigidConstraint")
                                    if currentWeld then
                                        dropRemote:FireServer(currentWeld)
                                    end
                                    
                                    GE.DestroyGrabLine:FireServer(tRoot)
                                    if Det then grabRemote:FireServer(Det, tRoot, Weld) end
                                    GE.CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false)
                                end)
                            else
                                if blobRoot then
                                    blobRoot.CFrame = SavedPos
                                    blobRoot.AssemblyLinearVelocity = Vector3.zero
                                end
                            end
                            RunService.Heartbeat:Wait()
                        end
                        
                        -- Unanchor on exit
                        if blobRoot then
                            blobRoot.CFrame = SavedPos
                            blobRoot.AssemblyLinearVelocity = Vector3.zero
                        end
                    end)
                else
                    -- 詳細なエラー内容を表示
                    local missing = {}
                    if not grabRemote then table.insert(missing, "CreatureGrab") end
                    if not dropRemote then table.insert(missing, "CreatureDrop") end
                    if not (lDet or rDet) then table.insert(missing, "Detector") end
                    if not (lWeld or rWeld) then table.insert(missing, "Weld/Constraint") end
                    OrionLib:MakeNotification({ Name = "エラー", Content = "不足: " .. table.concat(missing, ", "), Time = 5 })
                end
            else
                OrionLib:MakeNotification({ Name = "エラー", Content = "Blobmanが見つかりません (おもちゃを出してください)", Time = 3 })
            end
        end
    end
})

-- All Kick with white-friend protection
local allKickSec = ActionTab:AddSection({ Name = "All Kick" })
local allKickGrabbedPlayers = {}
local allKickCurrentBlob = nil
local allKickWhiteFriends = {}
_G.ProtectRealFriends = _G.ProtectRealFriends or false

local function isAllKickWhiteFriend(player)
    if _G.ProtectRealFriends then
        return player:IsFriendsWith(LocalPlayer.UserId)
    end
    return allKickWhiteFriends[player] == true or allKickWhiteFriends[player.Name] == true
end

local function isAllKickProtected(player)
    if isAllKickWhiteFriend(player) then
        return true
    end
    local plotItems = Workspace:FindFirstChild("PlotItems")
    local playersInPlots = plotItems and plotItems:FindFirstChild("PlayersInPlots")
    if playersInPlots and playersInPlots:FindFirstChild(player.Name) then
        return true
    end
    return false
end

local function setAllKickNetworkOwner(part)
    if not part then return end
    pcall(function()
        ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(part, LocalPlayer.Character.HumanoidRootPart.CFrame)
    end)
end

local function getAllKickToyFolder()
    return Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
end

local function getAllKickRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function anchorAllKickBlob(blob, state)
    if not blob then return end
    for _, v in ipairs(blob:GetDescendants()) do
        if v:IsA("BasePart") then v.Anchored = state end
    end
    local mainPart = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
    if mainPart then
        if state then
            local sb = mainPart:FindFirstChild("AllKickAnchorBox") or Instance.new("SelectionBox")
            sb.Name = "AllKickAnchorBox"
            sb.Adornee = blob
            sb.Parent = mainPart
            sb.Color3 = Color3.fromRGB(0, 255, 255)
            sb.LineThickness = 0.05
        else
            local old = mainPart:FindFirstChild("AllKickAnchorBox")
            if old then old:Destroy() end
            local sb = Instance.new("SelectionBox")
            sb.Name = "AllKickUnanchorBox"
            sb.Adornee = blob
            sb.Parent = mainPart
            sb.Color3 = Color3.fromRGB(255, 0, 0)
            sb.LineThickness = 0.05
            DebrisService:AddItem(sb, 0.5)
        end
    end
end

local function allKickGrab3Times(blob, targetPlayer)
    if not (blob and targetPlayer and targetPlayer.Character) then return false end
    if isAllKickProtected(targetPlayer) then return false end

    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return false end
    for _ = 1, 50 do setAllKickNetworkOwner(targetRoot) end

    local leftDetector = blob:FindFirstChild("LeftDetector")
    local leftWeld = leftDetector and leftDetector:FindFirstChild("LeftWeld")
    local rightDetector = blob:FindFirstChild("RightDetector")
    local rightWeld = rightDetector and rightDetector:FindFirstChild("RightWeld")
    local scriptObj = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
    local grabEvent = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
    local dropEvent = scriptObj and scriptObj:FindFirstChild("CreatureDrop")
    local releaseEvent = scriptObj and scriptObj:FindFirstChild("CreatureRelease")
    local myRoot = getAllKickRoot()
    local rootAttachment = myRoot and myRoot:FindFirstChild("RootAttachment")

    if not (leftDetector and leftWeld and rightDetector and rightWeld and grabEvent and dropEvent and releaseEvent and rootAttachment) then
        return false
    end

    for _ = 1, 3 do
        pcall(function()
            grabEvent:FireServer(leftDetector, targetRoot, leftWeld)
            dropEvent:FireServer(leftWeld, rootAttachment)
            releaseEvent:FireServer(rightWeld)
        end)
    end
    allKickGrabbedPlayers[targetPlayer] = true
    return true
end

local function allKickTeleportCircle(center, radius)
    local playersToMove = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not isAllKickProtected(player) and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                table.insert(playersToMove, { player = player, root = targetRoot })
            end
        end
    end
    if #playersToMove == 0 then return 0 end

    local angleStep = (2 * math.pi) / #playersToMove
    local count = 0
    for i, data in ipairs(playersToMove) do
        local angle = (i - 1) * angleStep
        local x = center.X + radius * math.cos(angle)
        local z = center.Z + radius * math.sin(angle)
        for _ = 1, 50 do setAllKickNetworkOwner(data.root) end
        data.root.CFrame = CFrame.new(x, center.Y, z)
        count = count + 1
    end
    return count
end

local function allKickMassGrab(blob)
    if not blob then return 0 end
    for _ = 1, 20 do
        for player, _v in pairs(allKickGrabbedPlayers) do
            if player and player.Character and not isAllKickProtected(player) then
                local leftDetector = blob:FindFirstChild("LeftDetector")
                local leftWeld = leftDetector and leftDetector:FindFirstChild("LeftWeld")
                local scriptObj = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
                local grabEvent = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if grabEvent and leftDetector and leftWeld and targetRoot then
                    pcall(function() grabEvent:FireServer(leftDetector, targetRoot, leftWeld) end)
                end
            end
        end
        task.wait(0.01)
    end
    return 0
end

allKickSec:AddButton({
    Name = "キックオール",
    Callback = function()
        allKickGrabbedPlayers = {}
        allKickCurrentBlob = nil

        local protectedCount = 0
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and isAllKickProtected(player) then
                protectedCount = protectedCount + 1
            end
        end

        local myRoot = getAllKickRoot()
        if myRoot then
            local spawnPos = myRoot.CFrame * CFrame.new(0, 0, -5)
            pcall(function()
                ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer("CreatureBlobman", spawnPos, Vector3.new(0, 127, 0))
            end)
        end
        task.wait(0.5)

        local folder = getAllKickToyFolder()
        allKickCurrentBlob = folder and folder:FindFirstChild("CreatureBlobman")
        if allKickCurrentBlob then
            local vehicleSeat = allKickCurrentBlob:FindFirstChild("VehicleSeat")
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if vehicleSeat and humanoid then vehicleSeat:Sit(humanoid) end
        end
        task.wait(0.3)

        myRoot = getAllKickRoot()
        if myRoot and allKickCurrentBlob then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and not isAllKickProtected(player) and player.Character then
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        myRoot.CFrame = targetRoot.CFrame
                        task.wait(0.15)
                        allKickGrab3Times(allKickCurrentBlob, player)
                    end
                end
            end
        end

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not isAllKickProtected(player) and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    for _ = 1, 50 do setAllKickNetworkOwner(targetRoot) end
                end
            end
        end

        if myRoot then
            myRoot.CFrame = CFrame.new(0, 70, 0)
            task.wait(0.2)
        end

        if allKickCurrentBlob then anchorAllKickBlob(allKickCurrentBlob, true) end
        local teleportedCount = allKickTeleportCircle(Vector3.new(0, 70, 0), 15)
        allKickMassGrab(allKickCurrentBlob)
        task.wait(0.5)
        if allKickCurrentBlob then anchorAllKickBlob(allKickCurrentBlob, false) end

        OrionLib:MakeNotification({
            Name = "完了",
            Content = string.format("対象: %d人\n保護対象: %d人\nKick実行", teleportedCount, protectedCount),
            Image = "rbxassetid://4483345998",
            Time = 4
        })
    end
})

allKickSec:AddToggle({
    Name = "フレンド保護",
    Default = false,
    Callback = function(v)
        _G.ProtectRealFriends = v
    end
})

actionTargetSection:AddToggle({
    Name = "管理者への自動応答 (/cholon)",
    Default = false,
    Callback = function(v)
        autoResponseActive = v
    end
})

-- Loop Kill (ported from test.lua)
local loopKillSecActionTab = ActionTab:AddSection({ Name = "Loop Kill" })
local loopKillTargetNameActionTab = ""
local loopKillEnabledActionTab = false
loopKillTargetDropdown = nil

local function noCollideModelActionTab(model)
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end

local function flingActionTab(root, hum)
    noCollideModelActionTab(hum.Parent)
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, 1000000000, 0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = root
    hum.Sit = false
    hum.Jump = true
    DebrisService:AddItem(bv, 3)
end

loopKillTargetDropdown = loopKillSecActionTab:AddDropdown({
    Name = "ターゲット選択",
    Default = "選択してください",
    Options = getPList(),
    Callback = function(v)
        loopKillTargetNameActionTab = parseSelectedPlayerName(v)
    end
})

-- ターゲットリストは PlayerAdded / PlayerRemoving で自動更新

loopKillSecActionTab:AddToggle({
    Name = "ループキル",
    Default = false,
    Callback = function(v)
        loopKillEnabledActionTab = v
        if not v then return end

        task.spawn(function()
            local myChar = LocalPlayer.Character
            local savedPivot = myChar and myChar:GetPivot()

            while loopKillEnabledActionTab do
                RunService.Heartbeat:Wait()
                if not myChar or not myChar.Parent then
                    myChar = LocalPlayer.Character
                    if myChar then savedPivot = myChar:GetPivot() end
                end

                if loopKillTargetNameActionTab ~= "" and myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local target = Players:FindFirstChild(loopKillTargetNameActionTab)
                    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (myChar.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                        if dist > 20 then
                            savedPivot = myChar:GetPivot()
                        end
                    end
                end

                task.spawn(function()
                    if loopKillTargetNameActionTab == "" then return end
                    local target = Players:FindFirstChild(loopKillTargetNameActionTab)
                    if not (target and target ~= LocalPlayer and target.Character) then return end

                    local inPlot = false
                    if Workspace:FindFirstChild("PlotItems") and Workspace.PlotItems:FindFirstChild("PlayersInPlots") then
                        if Workspace.PlotItems.PlayersInPlots:FindFirstChild(target.Name) then
                            inPlot = true
                        end
                    end
                    if inPlot then return end

                    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                    local targetHum = target.Character:FindFirstChild("Humanoid")
                    local targetHead = target.Character:FindFirstChild("Head")
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if not (targetRoot and targetHum and targetHead and targetHum.Health > 0 and myRoot) then return end

                    pcall(function()
                        myChar:PivotTo(CFrame.new(targetRoot.Position + Vector3.new(5, -18.5, 0)))
                        noCollideModelActionTab(target.Character)
                        if GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner") then
                            GrabEvents.SetNetworkOwner:FireServer(targetRoot, targetRoot.CFrame)
                        end
                        task.wait()
                        if myRoot and savedPivot and (myRoot.Position - savedPivot.Position).Magnitude > 2 then
                            myChar:PivotTo(savedPivot)
                        end
                        task.wait(0.1)
                        if GrabEvents and GrabEvents:FindFirstChild("DestroyGrabLine") then
                            GrabEvents.DestroyGrabLine:FireServer(targetRoot)
                        end
                        task.wait(0.1)
                        if targetHead:FindFirstChild("PartOwner") and targetHead.PartOwner.Value == LocalPlayer.Name then
                            flingActionTab(targetRoot, targetHum)
                            task.wait(0.1)
                            targetHum.Health = 0
                        end
                    end)
                end)
            end
        end)
    end,
    Save = true,
    Flag = "lk_toggle_action_tab"
})

-- Bring All (ported from test.lua)
local bringAllSecActionTab = ActionTab:AddSection({ Name = "Bring All" })
local bringAllConfigActionTab = {
    Enabled = false,
    Position = nil,
    Radius = 15,
    Whitelist = false,
    BringPlot = false,
    CameraPart = nil,
    ActiveMovers = {},
    MainLoop = nil,
    HiddenCFrame = CFrame.new(527, 123, -376)
}

local originalCollisionsActionTab = {}
local friendCacheActionTab = {}

local function saveCollisionsActionTab(character, key)
    originalCollisionsActionTab[key] = {}
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            originalCollisionsActionTab[key][part] = part.CanCollide
        end
    end
end

local function restoreCollisionsActionTab(key)
    if not originalCollisionsActionTab[key] then return end
    for part, canCollide in pairs(originalCollisionsActionTab[key]) do
        if part and part.Parent then
            pcall(function() part.CanCollide = canCollide end)
        end
    end
    originalCollisionsActionTab[key] = nil
end

task.spawn(function()
    while true do
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                friendCacheActionTab[player.UserId] = LocalPlayer:IsFriendsWith(player.UserId)
            end
        end
        task.wait(10)
    end
end)

local function inPlotActionTab(player)
    local plotItems = Workspace:FindFirstChild("PlotItems")
    local playersInPlots = plotItems and plotItems:FindFirstChild("PlayersInPlots")
    local inPlotValue = player:FindFirstChild("InPlot")
    return (playersInPlots and playersInPlots:FindFirstChild(player.Name)) or (inPlotValue and inPlotValue.Value)
end

local function inRadiusActionTab(part)
    if not bringAllConfigActionTab.Position then return false end
    return (part.Position - bringAllConfigActionTab.Position).Magnitude <= bringAllConfigActionTab.Radius
end

local function ignorePlayerActionTab(player)
    if player == LocalPlayer then return true end
    local isFriend = friendCacheActionTab[player.UserId]
    if isFriend == nil then
        isFriend = LocalPlayer:IsFriendsWith(player.UserId)
    end
    if bringAllConfigActionTab.Whitelist and isFriend then return true end
    return false
end

local function createBringMoverActionTab(targetRoot, destinationPosition)
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
    table.insert(bringAllConfigActionTab.ActiveMovers, bringMover)
end

local function bringAllLoopActionTab()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not (myChar and myRoot) then return end

    while bringAllConfigActionTab.Enabled do
        local playersToBring = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if not ignorePlayerActionTab(player) and player.Character and (bringAllConfigActionTab.BringPlot or not inPlotActionTab(player)) then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                local ragdolled = hum and hum:FindFirstChild("Ragdolled")
                if root and not inRadiusActionTab(root) and not (ragdolled and ragdolled.Value) then
                    table.insert(playersToBring, player)
                end
            end
        end

        -- 修正1: ターゲットがいる場合のみ実行（元の continue の代わり）
        if #playersToBring > 0 then
            for _, targetPlayer in ipairs(playersToBring) do
                -- 修正2: 有効かつ親が存在する場合のみ実行（元の continue の代わり）
                if bringAllConfigActionTab.Enabled and targetPlayer.Parent then
                    local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local targetHead = targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head")
                    
                    if targetRoot and targetHead then
                        local success = false
                        for _ = 1, 30 do
                            if not bringAllConfigActionTab.Enabled or not targetRoot.Parent then break end
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
                            task.wait(0.05)
                        end

                        if success then
                            createBringMoverActionTab(targetRoot, bringAllConfigActionTab.Position)
                            targetRoot.CFrame = CFrame.new(bringAllConfigActionTab.Position)
                            targetRoot.AssemblyLinearVelocity = Vector3.zero
                        end

                        if bringAllConfigActionTab.Enabled then
                            myChar:PivotTo(bringAllConfigActionTab.HiddenCFrame)
                        end
                    end
                end
            end
        end
        
        -- whileループの待機
        task.wait(1)
    end
end

local function startBringAllActionTab()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    if not (myRoot and myHum) then return end

    bringAllConfigActionTab.Position = myRoot.Position
    saveCollisionsActionTab(myChar, "BringAllAction")
    noCollideModelActionTab(myChar)

    local camPart = Instance.new("Part")
    camPart.Name = "BringAllCameraPartAction"
    camPart.Size = Vector3.new(1, 1, 1)
    camPart.Transparency = 1
    camPart.Anchored = true
    camPart.CanCollide = false
    camPart.CFrame = myRoot.CFrame
    camPart.Parent = Workspace
    bringAllConfigActionTab.CameraPart = camPart
    Camera.CameraSubject = camPart

    myChar:PivotTo(bringAllConfigActionTab.HiddenCFrame)
    bringAllConfigActionTab.MainLoop = task.spawn(bringAllLoopActionTab)
end

local function stopBringAllActionTab()
    bringAllConfigActionTab.MainLoop = nil
    for _, mover in ipairs(bringAllConfigActionTab.ActiveMovers) do
        if mover and mover.Parent then mover:Destroy() end
    end
    bringAllConfigActionTab.ActiveMovers = {}

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
    if bringAllConfigActionTab.CameraPart then
        bringAllConfigActionTab.CameraPart:Destroy()
        bringAllConfigActionTab.CameraPart = nil
    end

    restoreCollisionsActionTab("BringAllAction")
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myRoot and bringAllConfigActionTab.Position then
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.CFrame = CFrame.new(bringAllConfigActionTab.Position)
    end
end

bringAllSecActionTab:AddToggle({
    Name = "全員連れてくる",
    Default = false,
    Callback = function(v)
        bringAllConfigActionTab.Enabled = v
        if v then
            startBringAllActionTab()
        else
            stopBringAllActionTab()
        end
    end
})

bringAllSecActionTab:AddToggle({
    Name = "フレンド保護",
    Default = false,
    Callback = function(v)
        bringAllConfigActionTab.Whitelist = v
    end
})

-- --- TAB: KEYBOARD (ported from test.lua) ---
local keyboardTabSecTeleport = KeyboardTab:AddSection({ Name = "Teleport" })
local keyboardTabSecAnchor = KeyboardTab:AddSection({ Name = "Anchor Objects" })
local keyboardTabSecSilentAim = KeyboardTab:AddSection({ Name = "Silent Aim (Solaris)" })
keyboardTabSecTeleport:AddLabel("キー: Z (モバイルは画面ボタン)")
keyboardTabSecAnchor:AddLabel("キー: K (モバイルは画面ボタン)")
keyboardTabSecSilentAim:AddLabel("透明掴みが使えなくなります。")

local keyboardGui = Instance.new("ScreenGui")
keyboardGui.Name = "HolonKeyboardTabGUI"
keyboardGui.ResetOnSpawn = false
keyboardGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function isMobileClient()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- Solaris-style Silent Aim state
local saEnabled = false
local saStrength = 50
local saCameraClone = nil
local saCameraInitialized = false
local saRoot = nil
local saHRPs = {}
local saReachDistance = 30

local function refreshSilentAimRoot()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    saRoot = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 3)
    if saRoot then
        saHRPs[saRoot] = nil
    end
end

refreshSilentAimRoot()
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.1)
    refreshSilentAimRoot()
end)

for _, desc in ipairs(Workspace:GetDescendants()) do
    if desc:IsA("BasePart") and desc.Name == "HumanoidRootPart" and desc ~= saRoot then
        saHRPs[desc] = true
    end
end

Workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA("BasePart") and desc.Name == "HumanoidRootPart" and desc ~= saRoot then
        saHRPs[desc] = true
    end
end)

Workspace.DescendantRemoving:Connect(function(desc)
    if saHRPs[desc] then
        saHRPs[desc] = nil
    end
end)

local function getSilentAimTargetSolaris()
    if not saEnabled then return nil end
    if not saCameraClone or not saRoot then return nil end

    local center = Camera.ViewportSize / 2
    local bestDist = math.huge
    local bestTarget = nil
    local maxScreenDistance = (Camera.ViewportSize.X + Camera.ViewportSize.Y) / 2
    local adjustedStrength = (saStrength / 100) * maxScreenDistance

    for hrp in pairs(saHRPs) do
        if hrp and hrp.Parent and hrp ~= saRoot and hrp:IsDescendantOf(Workspace) then
            local model = hrp.Parent
            local hum = model:FindFirstChildWhichIsA("Humanoid")
            if hum and hum.Health > 0 then
                local screen3D, onScreen = Camera:WorldToScreenPoint(hrp.Position)
                if onScreen then
                    local mag = (hrp.Position - saCameraClone.CFrame.Position).Magnitude
                    if mag <= saReachDistance then
                        local screen2D = Vector2.new(screen3D.X, screen3D.Y)
                        local screenDistance = (screen2D - center).Magnitude
                        if screenDistance <= adjustedStrength and screenDistance < bestDist then
                            bestDist = screenDistance
                            bestTarget = hrp
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

RunService.RenderStepped:Connect(function()
    if not saCameraInitialized or not saCameraClone then return end
    local targetCFrame = saCameraClone.CFrame
    if saEnabled and not Workspace:FindFirstChild("GrabParts") then
        local target = getSilentAimTargetSolaris()
        if target and target ~= saRoot then
            local screen3D, onScreen = Camera:WorldToScreenPoint(target.Position)
            if onScreen and targetCFrame.LookVector:Dot((target.Position - targetCFrame.Position).Unit) > 0 then
                targetCFrame = CFrame.new(targetCFrame.Position, target.Position)
            end
        end
    end
    Camera.CFrame = targetCFrame
end)

keyboardTabSecSilentAim:AddToggle({
    Name = "サイレントエイム",
    Default = false,
    Callback = function(v)
        saEnabled = v
        if v and not saCameraInitialized then
            saCameraClone = Camera:Clone()
            saCameraClone.Parent = Workspace
            saCameraClone.Name = "SilentCamera"
            saCameraClone.CFrame = Camera.CFrame
            Workspace.CurrentCamera = saCameraClone
            saCameraInitialized = true
        end
    end
})

keyboardTabSecSilentAim:AddSlider({
    Name = "サイレントエイム強さ",
    Min = 1,
    Max = 100,
    Default = 50,
    Increment = 1,
    ValueName = "Strength",
    Callback = function(v)
        saStrength = v
    end
})

local function performKeyboardTeleport()
    local char = LocalPlayer.Character
    if not (char and char:FindFirstChild("HumanoidRootPart")) then return end

    local targetPos = nil
    if isMobileClient() then
        local cam = Workspace.CurrentCamera
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {char}
        params.FilterType = Enum.RaycastFilterType.Exclude
        local ray = Workspace:Raycast(cam.CFrame.Position, cam.CFrame.LookVector * 1000, params)
        targetPos = ray and ray.Position or (cam.CFrame.Position + cam.CFrame.LookVector * 50)
    else
        local mouse = LocalPlayer:GetMouse()
        if mouse and mouse.Hit then targetPos = mouse.Hit.Position end
    end

    if targetPos then
        char.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
    end
end

local function onKeyboardTeleportAction(_actionName, inputState, _inputObject)
    if inputState == Enum.UserInputState.Begin then
        performKeyboardTeleport()
    end
end

local teleportBtn = Instance.new("ImageButton")
teleportBtn.Name = "HolonTeleportButton"
teleportBtn.Size = UDim2.new(0, 70, 0, 70)
teleportBtn.Position = UDim2.new(1, -267, 1, -90)
teleportBtn.Image = "rbxassetid://97166444"
teleportBtn.ImageColor3 = Color3.fromRGB(142, 142, 142)
teleportBtn.BackgroundTransparency = 1
teleportBtn.ImageTransparency = 0.2
teleportBtn.Visible = false
teleportBtn.Parent = keyboardGui

local teleportIcon = Instance.new("ImageLabel")
teleportIcon.Size = UDim2.new(0.7, 0, 0.7, 0)
teleportIcon.Position = UDim2.new(0.15, 0, 0.15, 0)
teleportIcon.BackgroundTransparency = 1
teleportIcon.Image = "rbxassetid://103005444008339"
teleportIcon.Parent = teleportBtn

teleportBtn.MouseButton1Down:Connect(function() teleportBtn.ImageTransparency = 0 end)
teleportBtn.MouseButton1Up:Connect(function() teleportBtn.ImageTransparency = 0.2 end)
teleportBtn.MouseButton1Click:Connect(performKeyboardTeleport)

keyboardTabSecTeleport:AddToggle({
    Name = "テレポート (Z)",
    Default = false,
    Callback = function(v)
        if v then
            ContextActionService:BindAction("HolonTeleportZ", onKeyboardTeleportAction, false, Enum.KeyCode.Z)
            if isMobileClient() then teleportBtn.Visible = true end
        else
            ContextActionService:UnbindAction("HolonTeleportZ")
            teleportBtn.Visible = false
        end
    end
})

local keyboardAnchoredObjects = {}

local function performKeyboardAnchor()
    local targetToProcess = nil
    local partToDrop = nil
    local grabPartsFolder = Workspace:FindFirstChild("GrabParts")

    if grabPartsFolder and grabPartsFolder:FindFirstChild("GrabPart") and grabPartsFolder.GrabPart:FindFirstChild("WeldConstraint") then
        local grabbedPart = grabPartsFolder.GrabPart.WeldConstraint.Part1
        if grabbedPart then
            local map = Workspace:FindFirstChild("Map")
            if not (grabbedPart.Locked or (map and grabbedPart:IsDescendantOf(map))) then
                local model = grabbedPart:FindFirstAncestorOfClass("Model")
                targetToProcess = model or grabbedPart
                partToDrop = grabbedPart
            end
        end
    elseif LocalPlayer.Character then
        local target
        if isMobileClient() then
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
            if checkObj:GetAttribute("IsAnchored") then
                targetToProcess = checkObj
            end
        end
    end

    if targetToProcess then
        local currentAnchorState = targetToProcess:GetAttribute("IsAnchored")
        local newAnchorState = not currentAnchorState
        targetToProcess:SetAttribute("IsAnchored", newAnchorState)

        local mainPart = targetToProcess
        if targetToProcess:IsA("Model") then
            mainPart = targetToProcess.PrimaryPart or targetToProcess:FindFirstChildWhichIsA("BasePart", true)
        end

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
        local highlightName = "BlizAnchor"

        local existing = targetToProcess:FindFirstChild(highlightName)
        if existing then existing:Destroy() end

        if newAnchorState and mainPart then
            local connections = {}

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

            connections[#connections + 1] = targetToProcess.DescendantAdded:Connect(function(desc)
                if desc.Name == "PartOwner" then setupOwnerListener(desc) end
            end)
            connections[#connections + 1] = targetToProcess.DescendantRemoving:Connect(function(descendant)
                if descendant.Name == "PartOwner" then
                    targetToProcess:SetAttribute("AnchorOwnership", nil)
                end
            end)

            for _, desc in ipairs(targetToProcess:GetDescendants()) do
                if desc.Name == "PartOwner" then
                    setupOwnerListener(desc)
                end
            end

            keyboardAnchoredObjects[targetToProcess] = { Part = mainPart, Connections = connections }

            local bp = mainPart:FindFirstChild("BlizAnchorBP") or Instance.new("BodyPosition")
            bp.Name = "BlizAnchorBP"
            bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bp.P = 40000
            bp.D = 950
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
            sb.Color3 = Color3.fromRGB(0, 255, 255)
            sb.LineThickness = 0.05

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
            local data = keyboardAnchoredObjects[targetToProcess]
            if data and data.Connections then
                for _, conn in ipairs(data.Connections) do
                    conn:Disconnect()
                end
            end
            keyboardAnchoredObjects[targetToProcess] = nil
            local bp = mainPart:FindFirstChild("BlizAnchorBP")
            if bp then bp:Destroy() end
            local bg = mainPart:FindFirstChild("BlizAnchorBG")
            if bg then bg:Destroy() end

            local sb = Instance.new("SelectionBox")
            sb.Adornee = targetToProcess
            sb.Parent = targetToProcess
            sb.Color3 = Color3.fromRGB(255, 0, 0)
            sb.LineThickness = 0.05
            DebrisService:AddItem(sb, 0.5)
        end
    end
end

local function onKeyboardAnchorAction(_actionName, inputState, _inputObject)
    if inputState == Enum.UserInputState.Begin then
        performKeyboardAnchor()
    end
end

local anchorBtn = Instance.new("ImageButton")
anchorBtn.Name = "HolonAnchorButton"
anchorBtn.Size = UDim2.new(0, 60, 0, 60)
anchorBtn.Position = UDim2.new(1, -330, 1, -80)
anchorBtn.Image = "rbxassetid://97166444"
anchorBtn.ImageColor3 = Color3.fromRGB(142, 142, 142)
anchorBtn.BackgroundTransparency = 1
anchorBtn.ImageTransparency = 0.2
anchorBtn.Visible = false
anchorBtn.Parent = keyboardGui

local anchorIcon = Instance.new("ImageLabel")
anchorIcon.Size = UDim2.new(0.55, 0, 0.55, 0)
anchorIcon.Position = UDim2.new(0.225, 0, 0.225, 0)
anchorIcon.BackgroundTransparency = 1
anchorIcon.Image = "rbxassetid://92181172123618"
anchorIcon.Parent = anchorBtn

anchorBtn.MouseButton1Down:Connect(function() anchorBtn.ImageTransparency = 0 end)
anchorBtn.MouseButton1Up:Connect(function() anchorBtn.ImageTransparency = 0.2 end)
anchorBtn.MouseButton1Click:Connect(performKeyboardAnchor)

keyboardTabSecAnchor:AddToggle({
    Name = "固定 (K)",
    Default = false,
    Callback = function(v)
        if v then
            ContextActionService:BindAction("HolonAnchorK", onKeyboardAnchorAction, false, Enum.KeyCode.K)
            if isMobileClient() then anchorBtn.Visible = true end
        else
            ContextActionService:UnbindAction("HolonAnchorK")
            anchorBtn.Visible = false
        end
    end
})

local MapBaseSec = KeyboardTab:AddSection({ Name = "マップ基本設定" })

MapBaseSec:AddToggle({
    Name = "ミニマップを有効化",
    Default = false,
    Callback = function(v)
        minimapActive = v
        if v then
            setupMap()
        else
            if CoreGui:FindFirstChild("GoogleMinimap") then CoreGui.GoogleMinimap:Destroy() end
            if renderConnMap then renderConnMap:Disconnect() renderConnMap = nil end
            if inputConnMap then inputConnMap:Disconnect() inputConnMap = nil end
            if playerRemovingConnMap then playerRemovingConnMap:Disconnect() playerRemovingConnMap = nil end
        end
    end
})

MapBaseSec:AddButton({
    Name = "マップを再読み込み",
    Callback = function()
        if minimapActive then setupMap() end
    end
})

local MapTargetSec = KeyboardTab:AddSection({ Name = "マップターゲット・追従設定" })

MapTargetSec:AddDropdown({
    Name = "マップ表示/追従対象",
    Default = "なし",
    Options = getPList(),
    Callback = function(v)
        local name = v:match("@([^)]+)")
        mapTargetPlayer = Players:FindFirstChild(name or "")
    end
})

MapTargetSec:AddToggle({
    Name = "対象のみ表示 (自分は表示)",
    Default = false,
    Callback = function(v) SHOW_TARGET_ONLY = v end
})

local MapDispSec = KeyboardTab:AddSection({ Name = "マップ表示詳細設定" })

MapDispSec:AddToggle({
    Name = "プレイヤーを表示",
    Default = SHOW_PLAYERS,
    Callback = function(v) SHOW_PLAYERS = v end
})

MapDispSec:AddToggle({
    Name = "プレイヤーの名前を表示",
    Default = SHOW_NAMES,
    Callback = function(v) SHOW_NAMES = v end
})

MapDispSec:AddToggle({
    Name = "プレイヤーのアイコンを表示",
    Default = SHOW_ICONS,
    Callback = function(v) SHOW_ICONS = v end
})

UIElements.MapZoomSlider = MapDispSec:AddSlider({
    Name = "ズーム倍率 (スマホ用)",
    Min = 50, Max = 1500, Default = ZOOM,
    Callback = function(v)
        ZOOM = v
        if minimapActive then scan() end
    end
})

local MapSizeSec = KeyboardTab:AddSection({ Name = "マップサイズ・画質設定" })

MapSizeSec:AddSlider({
    Name = "ウィンドウの横幅",
    Min = 100, Max = 1000, Default = 300,
    Callback = function(v)
        local ratio = ZOOM / math.max(MAP_WIDTH, MAP_HEIGHT)
        MAP_WIDTH = v
        ZOOM = math.max(MAP_WIDTH, MAP_HEIGHT) * ratio
        if minimapActive then setupMap() end
    end
})

MapSizeSec:AddSlider({
    Name = "ウィンドウの縦幅",
    Min = 100, Max = 1000, Default = 300,
    Callback = function(v)
        local ratio = ZOOM / math.max(MAP_WIDTH, MAP_HEIGHT)
        MAP_HEIGHT = v
        ZOOM = math.max(MAP_WIDTH, MAP_HEIGHT) * ratio
        if minimapActive then setupMap() end
    end
})

UIElements.MapQualityDropdown = MapSizeSec:AddDropdown({
    Name = "スキャン画質",
    Default = qualities[curQualIdx].n,
    Options = {"低", "中", "高", "最高", "極限", "詳細"},
    Callback = function(v)
        for i, q in ipairs(qualities) do
            if q.n == v then
                curQualIdx = i
                if minimapActive then setupMap() end
                break
            end
        end
    end
})

-- ピアノタブは上部で作成済み

local PianoControlSec = PianoTab:AddSection({
	Name = "ピアノ制御"
})

UIElements.PianoEnabled = PianoControlSec:AddToggle({
	Name = "ピアノ機能を有効化",
	Default = false,
	Callback = function(v)
		pianoEnabled = v
		if v then
			-- 機能を有効にするだけ。追従の開始は追従トグルに任せる
			pianoKeyboard = getMusicKeyboard()
			
			if pianoKeyboard then
				-- 追従がオンの場合のみ開始
				if pianoFollowEnabled then setupPianoFollow() end

				OrionLib:MakeNotification({
					Name = "ピアノ機能",
					Content = "MusicKeyboardを検出しました",
					Time = 5
				})
			else
				pianoEnabled = false
				UIElements.PianoEnabled:Set(false) -- 失敗したらトグルを元に戻す
				OrionLib:MakeNotification({
					Name = "エラー",
					Content = "MusicKeyboardが見つかりません",
					Time = 5
				})
			end
		else
			stopSong()
			stopPiano() -- 追従を停止
		end
	end    
})

UIElements.PianoFollow = PianoControlSec:AddToggle({
    Name = "プレイヤー追従",
    Default = true,
    Callback = function(v)
        pianoFollowEnabled = v
        -- ★修正: pianoKeyboardが有効か(Parentを持つか)もチェックする
        if pianoEnabled and pianoKeyboard and pianoKeyboard.Parent then
            if v then
                setupPianoFollow()
            else
                stopPiano()
            end
        -- ★追加: ピアノが無効な状態で追従をオンにしたら、再検索して追従を開始
        elseif pianoEnabled and v then
            pianoKeyboard = getMusicKeyboard()
            if pianoKeyboard then
                setupPianoFollow()
            end
        end
    end
})

local PianoSongSec = PianoTab:AddSection({
	Name = "曲の再生"
})

-- ピアノ曲の自動ダウンロード
task.spawn(function()
    local targetFolder = "FTAP_Notes"
    if not isfolder(targetFolder) then makefolder(targetFolder) end

    local apiUrl = "https://api.github.com/repos/hololove1021/HolonHUB/contents/piano"
    local success, response = pcall(function() return game:HttpGet(apiUrl, true) end)

    if not success then return warn("HolonHUB: GitHub APIからピアノファイルリストの取得に失敗しました: " .. tostring(response)) end

    local fileList
    success, fileList = pcall(function() return HttpService:JSONDecode(response) end)

    if not success or type(fileList) ~= "table" then return warn("HolonHUB: ピアノファイルリストのJSONデコードに失敗しました。") end

    for _, fileData in ipairs(fileList) do
        if fileData.type == "file" and fileData.name:match("%.json$") then
            local fileName = fileData.name
            local filePath = targetFolder .. "/" .. fileName
            
            if not isfile(filePath) then
                local downloadUrl = fileData.download_url
                local fileSuccess, fileContent = pcall(function() return game:HttpGet(downloadUrl, true) end)
                
                if fileSuccess and fileContent then
                    writefile(filePath, fileContent)
                    OrionLib:MakeNotification({ Name = "System", Content = "Downloaded " .. fileName, Time = 3 })
                    task.wait(0.2)
                else
                    warn("HolonHUB: " .. fileName .. " のダウンロードに失敗しました。")
                end
            end
        end
    end
end)

-- JSONファイル一覧を取得
local function getSongFiles()
	local files = {}
	local targetFolder = "FTAP_Notes"

	-- フォルダがなければ作成する
	if not isfolder(targetFolder) then makefolder(targetFolder) end
	
	local success, allFiles = pcall(function()
		return listfiles(targetFolder)
	end)
	
	if not success or not allFiles then
		return {"アクセスエラー"}
	end
	
	for _, filePath in ipairs(allFiles) do
		if filePath:lower():match("%.json$") then
			local fileName = filePath:match("([^/%\\]+)$") or filePath
			table.insert(files, fileName) -- OrionのDropdown用に名前のみ追加
		end
	end
	
	if #files == 0 then
		return {"JSONファイルなし"}
	end
	
	return files
end

local songDropdown = PianoSongSec:AddDropdown({
	Name = "曲を選択",
	Default = "なし",
	Options = getSongFiles(),
	Callback = function(v)
		if v == "なし" or v == "フォルダが見つかりません" or v == "JSONファイルなし" then
			selectedSongFile = nil
			selectedSongData = nil
			return
		end
		
		-- ファイル名からフルパスを作成（環境に合わせて調整してください）
		local filePath = "FTAP_Notes/" .. v
		selectedSongFile = filePath
		
		local success, fileContent = pcall(function()
			return readfile(filePath)
		end)
		
		if success then
			local decodeSuccess, jsonData = pcall(function()
				return HttpService:JSONDecode(fileContent)
			end)
			
			if decodeSuccess then
				selectedSongData = jsonData
				OrionLib:MakeNotification({
					Name = "読み込み完了",
					Content = "音符数: " .. #jsonData,
					Time = 5
				})
			else
				selectedSongData = nil
			end
		end
	end    
})

PianoSongSec:AddButton({
	Name = "曲リストを更新",
	Callback = function()
		songDropdown:Refresh(getSongFiles(), true)
		OrionLib:MakeNotification({
			Name = "更新完了",
			Content = "JSONファイルリストを更新しました",
			Time = 5
		})
	end
})

PianoSongSec:AddButton({
    Name = "選択した曲を再生",
    Callback = function()
        -- ピアノ有効化のチェックを「テストボタン」と同じくらい緩くします
        if not pianoKeyboard then
            pianoKeyboard = getMusicKeyboard()
        end
        
        if not pianoKeyboard then
            OrionLib:MakeNotification({Name = "エラー", Content = "MusicKeyboardが見つかりません", Time = 5})
            return
        end
        
        if not selectedSongData then
            OrionLib:MakeNotification({Name = "エラー", Content = "曲を選択してください", Time = 5})
            return
        end
        
        -- ★修正ポイント：JSONEncodeせずに、そのままデータを渡す
        -- これで playSongFromJSON が正しくループを開始できます
        playSongFromJSON(selectedSongData)
        
        -- ボタンが反応したことを知らせる通知
        OrionLib:MakeNotification({
            Name = "自動演奏",
            Content = "再生を開始しました",
            Time = 3
        })
    end
})

PianoSongSec:AddButton({
	Name = "再生を停止",
	Callback = function()
		stopSong()
		OrionLib:MakeNotification({
			Name = "停止",
			Content = "曲の再生を停止しました",
			Time = 5
		})
	end
})

local PianoManualSec = PianoTab:AddSection({
    Name = "マニュアル操作・テスト"
})

UIElements.PianoManualUIToggle = PianoManualSec:AddToggle({
    Name = "手動演奏UIを表示",
    Default = false,
    Callback = function(v)
        manualPlayEnabled = v
        if v then
            pianoKeyboard = getMusicKeyboard()
            if pianoKeyboard then
                pianoEnabled = true
                if UIElements.PianoEnabled then UIElements.PianoEnabled:Set(true) end
                if not pianoUIGui then createPianoUI() end
                if pianoUIGui then pianoUIGui.Enabled = true end
            else
                pianoEnabled = false
                manualPlayEnabled = false
                if UIElements.PianoEnabled then UIElements.PianoEnabled:Set(false) end
                if UIElements.PianoManualUIToggle then UIElements.PianoManualUIToggle:Set(false) end
                OrionLib:MakeNotification({Name = "エラー", Content = "MusicKeyboardが見つかりません", Time = 5})
            end
        else
            if pianoUIGui then pianoUIGui.Enabled = false end
        end
    end
})


-- PCキーボード入力対応
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not pianoEnabled then return end
    
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local char = UserInputService:GetStringForKeyCode(input.KeyCode):lower()
        if pianoKeyMap[char] then
           if canPressPianoKey() then pressPianoKey(pianoKeyMap[char]) end
        end
    end
end)

-- PianoManualSecの下に追加
PianoManualSec:AddButton({
    Name = "テスト: Cキーを押す",
    Callback = function()
        if pianoKeyboard then
            local testKey = pianoKeyboard:FindFirstChild("Key1C", true)
            if testKey and canPressPianoKey() then
                -- 音を鳴らす命令
                SetNetworkOwner:FireServer(testKey, testKey.CFrame)
                
                --   waitの後にすぐ通知が来るようにします。
                task.wait(0.1)
                
                OrionLib:MakeNotification({
                    Name = "テスト", 
                    Content = "Key1Cを鳴らしました！", 
                    Time = 2
                })
            else
                warn("Key1Cが見つかりません")
            end
        end
    end
})

local SettingsTab = Window:MakeTab({
    Name = "設定",
    Icon = "rbxassetid://7072721682"
})

----- データ管理 ---
local SaveSec = SettingsTab:AddSection({Name = "データ管理 (リアルタイム更新)"})

-- 1. ドロップダウンを変数として定義
local fileDropdown
fileDropdown = SaveSec:AddDropdown({
    Name = "保存済みファイルを選択",
    Default = "選択してください",
    Options = getConfigFileList(),
    Callback = function(v) if v then selectedFile = v end end
})

-- 2. 読み込みボタン
SaveSec:AddButton({
    Name = "選択したファイルを読み込む",
    Callback = function()
        if selectedFile and selectedFile ~= "ファイルなし" then
            local path = "holon_config/" .. selectedFile
            if isfile(path) then
                local success, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
                if success then applyConfigData(data) end
            end
        end
    end
})

SaveSec:AddTextbox({
    Name = "新規保存ファイル名",
    Default = "config1",
    TextDisappear = false,
    Callback = function(v) if v then saveName = v end end
})

-- 3. 保存ボタン（保存した瞬間にドロップダウンを更新）
SaveSec:AddButton({
    Name = "現在の設定を保存",
    Callback = function()
        if saveName and saveName ~= "" then
            if not isfolder("holon_config") then makefolder("holon_config") end
            local path = "holon_config/" .. saveName .. ".json"
            
            -- ローカル変数の状態をcfgに同期させてから保存
            cfg.LocalSettings = {
                WalkSpeed = walkSpeed,
                JumpPower = jumpPower,
                UseWalkSpeed = useWalkSpeed,
                UseJumpPower = useJumpPower,
                InfiniteJump = infiniteJump,
                Noclip = noclip,
                AntiExplosion = antiExplosion,
                AntiFire = antiFire,
                AntiGrab = antiGrab,
                CurrentMode = currentMode,
                CombinedActive = combinedActive,
                FollowMethod = followMethod,
                EffectRotation = cfg.Global.EffectRotation,
                IndividualRotation = cfg.Global.IndividualRotation,
                UseOtherToys = useOtherToys,
                AutoWidth = autoWidth,
                MoveDelay = cfg.Global.MoveDelay,
                MoveDelayWeight = cfg.Global.MoveDelayWeight,
                LowLatencyMode = lowLatencyMode,
                Esp = espCfg, -- ESP設定(テーブル)も保存
                -- 追加保存項目
                VFlyEnabled = vflyEnabled,
                VFlySpeed = vflySpeed,
                ThirdPerson = (LocalPlayer.CameraMode == Enum.CameraMode.Classic),
                FOV = Camera.FieldOfView,
                TargetMainName = targetMainName,
                TargetSubName = targetSubName,
                SelectedItemName = selectedItemName,
                PianoEnabled = pianoEnabled,
                PianoFollowEnabled = pianoFollowEnabled,
                GrabMod = cfg.GrabMod
            }

            writefile(path, HttpService:JSONEncode(cfg))
            
            -- ★ここがポイント：保存した直後にドロップダウンのリストを最新にする
            fileDropdown:Refresh(getConfigFileList(), true)
            
            OrionLib:MakeNotification({
                Name = "保存完了", 
                Content = saveName .. ".json を保存し、リストを更新しました", 
                Time = 3
            })
        end
    end
})

-- --- UI外観設定 ---
local UISec = SettingsTab:AddSection({Name = "UI外観・カラー設定"})

UIElements.UITransparency = UISec:AddSlider({
    Name = "UI透明度",
    Min = 0, Max = 100, Default = 0,
    Callback = function(v)
        cfg.UI.Transparency = v / 100
        applyCustomStyle()
    end
})

-- 以降、cfg.UI が存在するので消えずに表示されます
UIElements.UIBackgroundColor = UISec:AddColorpicker({
    Name = "背景カラー",
    Default = cfg.UI.BackgroundColor,
    Callback = function(v)
        cfg.UI.BackgroundColor = v
        applyCustomStyle()
    end
})

UIElements.UIAccentColor = UISec:AddColorpicker({
    Name = "枠カラー (アクセント)",
    Default = cfg.UI.AccentColor,
    Callback = function(v)
        cfg.UI.AccentColor = v
        applyCustomStyle()
    end
})

UIElements.UIBackgroundImage = UISec:AddTextbox({
    Name = "背景画像ID (数字のみ)",
    Default = cfg.UI.BackgroundImage,
    TextDisappear = false,
    Callback = function(v)
        -- 数字以外の文字を除去して、数値のみ取り出す
        local id = v:match("%d+") 
        if id then
            -- Decal IDをImage IDとして読み込ませるためのURL形式
            -- ※Robloxの内部処理で自動変換を促す書き方です
            cfg.UI.BackgroundImage = "rbxassetid://" .. id
        else
            cfg.UI.BackgroundImage = ""
        end
        
        applyCustomStyle()
    end
})

local DetailTab = Window:MakeTab({Name = "詳細", Icon = DetailIcon})
AddDetailContent(DetailTab)

-- 通知（起動時）
OrionLib:MakeNotification({
	Name = "Holon HUB",
	Content = "v1.4.9 が読み込まれました！",
	Time = 5
})
    -- 起動時にUIスタイルを適用
    applyCustomStyle()

    -- === チャットシステム統合設定 ===
    local admins = {["najayou777"] = true, ["najryou777"] = true}
    local kanaToCode = {
        ["あ"]="1", ["い"]="2", ["う"]="3", ["え"]="4", ["お"]="5",
        ["か"]="K1", ["き"]="K2", ["く"]="K3", ["け"]="K4", ["こ"]="K5",
        ["さ"]="S1", ["し"]="S2", ["す"]="S3", ["せ"]="S4", ["そ"]="S5",
        ["た"]="T1", ["ち"]="T2", ["つ"]="T3", ["て"]="T4", ["と"]="T5",
        ["な"]="N1", ["に"]="N2", ["ぬ"]="N3", ["ね"]="N4", ["の"]="N5",
        ["は"]="H1", ["ひ"]="H2", ["ふ"]="H3", ["へ"]="H4", ["ほ"]="H5",
        ["ま"]="M1", ["み"]="M2", ["む"]="M3", ["め"]="M4", ["も"]="M5",
        ["や"]="Y1", ["ゆ"]="Y3", ["よ"]="Y5",
        ["ら"]="R1", ["り"]="R2", ["る"]="R3", ["れ"]="R4", ["ろ"]="R5",
        ["わ"]="W1", ["を"]="W5", ["ん"]="N0",
        ["が"]="G1", ["ぎ"]="G2", ["ぐ"]="G3", ["げ"]="G4", ["ご"]="G5",
        ["ざ"]="Z1", ["じ"]="Z2", ["ず"]="Z3", ["ぜ"]="Z4", ["ぞ"]="Z5",
        ["だ"]="D1", ["ぢ"]="D2", ["づ"]="D3", ["で"]="D4", ["ど"]="D5",
        ["ば"]="B1", ["び"]="B2", ["ぶ"]="B3", ["べ"]="B4", ["ぼ"]="B5",
        ["ぱ"]="P1", ["ぴ"]="P2", ["ぷ"]="P3", ["ぺ"]="P4", ["ぽ"]="P5"
    }

    TextChatService.MessageReceived:Connect(function(message)
        local source = message.TextSource
        if not source then return end
        
        local sender = Players:GetPlayerByUserId(source.UserId)
        if not sender then return end
        
        local text = message.Text
        local channel = message.TextChannel
        if not channel then return end

        -- 管理者権限チェック (najayou777, najryou777 のみ許可)
        if admins[sender.Name] then
            if text == "/k" then
                -- /k コマンドへの反応
                task.wait(0.5)
                channel:SendAsync("[通知]管理者がサーバーにいます。")
            elseif text == "/cholon" and autoResponseActive then
                -- /cholon コマンドへの反応 (トグルがONの場合のみ)
                task.wait(0.5)
                channel:SendAsync("ほろん")
            elseif text == "/h" then
                -- /h コマンド
                task.wait(0.1)
                channel:SendAsync("ほろん")
            elseif text:sub(1,3) == "/s " then
                -- /s <user> コマンド
                local targetUser = text:sub(4)
                if targetUser == LocalPlayer.Name or targetUser == tostring(LocalPlayer.UserId) then
                    OrionLib:MakeNotification({Name = "コマンド実行", Content = "外部スクリプトを読み込み中...", Time = 2})
                    task.spawn(function()
                        local success, err = pcall(function()
                            loadstring(game:HttpGet("https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/important/tmg/test.lua"))()
                        end)
                        if not success then warn("Script load error: " .. err) end
                    end)
                end
            elseif text:sub(1,3) == "/c " then
                -- /c <text> 暗号化コマンド
                local content = text:sub(4)
                local encoded = ""
                for char in content:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
                    encoded = encoded .. (kanaToCode[char] or char)
                end
                task.wait(0.1)
                channel:SendAsync(encoded)
            end
        end
    end)

    -- メイン画面側の初期化
    OrionLib:Init()
end

-- YouDecoy 追跡ループ
task.spawn(function()
    while true do
        task.wait(0.3)
        if decoyFollowEnabled and targetDecoy and targetDecoy.Character then
            local root = targetDecoy.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local decoys = getAllYouDecoys()

                for _, d in ipairs(decoys) do
                    local hum = d:FindFirstChildOfClass("Humanoid")
                    local dRoot = d.PrimaryPart
                    if hum and dRoot then
                        if math.random() < 0.1 then pcall(function() dRoot:SetNetworkOwner(LocalPlayer) end) end

                        if decoyFly then
                            local bp = dRoot:FindFirstChild("DecoyFlyBP") or Instance.new("BodyPosition", dRoot)
                            bp.Name = "DecoyFlyBP"
                            bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bp.P = decoyWalkSpeed * 1000
                            bp.Position = root.Position
                            hum.PlatformStand = true
                            hum.WalkSpeed = 0

                            local bg = dRoot:FindFirstChild("DecoyFlyBG") or Instance.new("BodyGyro", dRoot)
                            bg.Name = "DecoyFlyBG"
                            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                            bg.CFrame = CFrame.lookAt(dRoot.Position, root.Position)
                            hum.AutoRotate = false
                        else
                            local bp = dRoot:FindFirstChild("DecoyFlyBP")
                            if bp then bp:Destroy() end
                            local bg = dRoot:FindFirstChild("DecoyFlyBG")
                            if bg then bg:Destroy() end
                            hum.PlatformStand = false
                            hum.WalkSpeed = decoyWalkSpeed
                            hum.AutoRotate = true
                            hum:MoveTo(root.Position)
                        end
                    end
                end
            end
        end
    end
end)

if isfile(KeyFileName) and readfile(KeyFileName) == CorrectKey then
    -- 認証済みなら即メインへ
    StartHolonHUB()
else
    -- 未認証なら認証UIを作る
    OrionLib = loadstring(game:HttpGet(OrionUrl))()
    
    local AuthWindow = OrionLib:MakeWindow({
        Name = "Holon HUB | Key System",
        HidePremium = true,
        IntroEnabled = false
    })

    local AuthTab = AuthWindow:MakeTab({Name = "認証", Icon = "rbxassetid://7733919526"})
    local KeyInput = ""

    AuthTab:AddTextbox({
        Name = "キーを入力",
        Default = "",
        TextDisappear = false, -- ここを false に変更
        Callback = function(Value) 
            KeyInput = Value 
        end     
    })

    AuthTab:AddButton({
        Name = "認証する",
        Callback = function()
            if KeyInput == CorrectKey then
                writefile(KeyFileName, CorrectKey) -- ここで保存
                OrionLib:MakeNotification({Name = "成功", Content = "起動します!", Time = 2})
                task.wait(1)
                pcall(function() game.CoreGui.Orion:Destroy() end)
                task.wait(0.5)
                StartHolonHUB()
            else
                OrionLib:MakeNotification({Name = "失敗", Content = "キーが違います", Time = 5})
            end
        end
    })

    AuthTab:AddButton({
        Name = "キーを入手 (Discord)",
        Callback = function() setclipboard("https://discord.gg/EHBXqgZZYN") end
    })

    -- 詳細タブ
    local AuthDetailTab = AuthWindow:MakeTab({Name = "詳細", Icon = DetailIcon})
    AddDetailContent(AuthDetailTab)
    
    OrionLib:Init()
end
