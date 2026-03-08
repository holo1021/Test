local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Siro-script/FtaP.90hub/refs/heads/main/Orion"))()
local Window = OrionLib:MakeWindow({Name = "キックオール", IntroText = "KickAll", HidePremium = false, SaveConfig = false, ConfigFolder = "KickAll"})
local Tab = Window:MakeTab({Name = "💥 キックオール", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local kickAllCoro = nil
local liftHeight = 10
local holdTime = 0.5
local running = false

local function findBlobman()
    local char = LP.Character
    if not char then return nil end
    for _, desc in pairs(workspace:GetDescendants()) do
        if desc.Name == "CreatureBlobman" then
            local vs = desc:FindFirstChild("VehicleSeat")
            if vs then
                local sw = vs:FindFirstChild("SeatWeld")
                if sw and sw.Part1 and sw.Part1:IsDescendantOf(char) then
                    return desc
                end
            end
        end
    end
    return nil
end

local function showMsg(txt, color)
    local sg = Instance.new("ScreenGui"); sg.ResetOnSpawn = false; sg.Parent = LP.PlayerGui
    local lb = Instance.new("TextLabel"); lb.Size = UDim2.new(1,0,0,60); lb.Position = UDim2.new(0,0,0.4,0)
    lb.BackgroundTransparency = 0.3; lb.BackgroundColor3 = Color3.fromRGB(0,0,0)
    lb.TextColor3 = color or Color3.fromRGB(255,50,50); lb.TextScaled = true; lb.Text = txt; lb.Parent = sg
    task.delay(2, function() sg:Destroy() end)
end

Tab:AddSection({Name = "💥 ブロブマンでキックオール"})
Tab:AddSlider({Name = "⏱ 掴み時間 (×0.1秒)", Min = 1, Max = 10, Default = 5, Increment = 1, ValueName = "×0.1秒", Callback = function(v) holdTime = v * 0.1 end})
Tab:AddSlider({Name = "⬆ 持ち上げ高さ (スタッド)", Min = 5, Max = 100, Default = 10, Increment = 5, ValueName = "studs", Callback = function(v) liftHeight = v end})
Tab:AddLabel("ブロブマンに乗ってからONにしてください")

Tab:AddButton({Name = " キックオール START/STOP", Callback = function()
    if running then
        running = false
        if kickAllCoro then coroutine.close(kickAllCoro); kickAllCoro = nil end
        showMsg("⏹ 停止しました", Color3.fromRGB(255,150,50))
        return
    end
    running = true

    kickAllCoro = coroutine.create(function()
        local blob = findBlobman()
        if not blob then showMsg("no blob"); running = false; return end
        showMsg("✅ 開始します！", Color3.fromRGB(100,255,100))

        local blobScript = blob:WaitForChild("BlobmanSeatAndOwnerScript")
        local grabRemote    = blobScript:WaitForChild("CreatureGrab")
        local releaseRemote = blobScript:WaitForChild("CreatureRelease")
        local dropRemote    = blobScript:WaitForChild("CreatureDrop")
        local lDet  = blob:WaitForChild("LeftDetector")
        local rDet  = blob:WaitForChild("RightDetector")
        local primary = blob:FindFirstChild("Cube.004") or blob.PrimaryPart

        for _, part in ipairs(blob:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    part.CanCollide = false; part.Anchored = false
                    if not part:FindFirstChildOfClass("BodyPosition") then
                        local bp = Instance.new("BodyPosition")
                        bp.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                        bp.P = 50000; bp.D = 500; bp.Position = part.Position; bp.Parent = part
                    end
                    if not part:FindFirstChildOfClass("BodyGyro") then
                        local bg = Instance.new("BodyGyro")
                        bg.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
                        bg.P = 50000; bg.D = 500; bg.CFrame = part.CFrame; bg.Parent = part
                    end
                end)
            end
        end

        local partOffsets = {}
        if primary then
            for _, part in ipairs(blob:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function()
                        partOffsets[part] = primary.CFrame:ToObjectSpace(part.CFrame)
                    end)
                end
            end
        end

        local function setTarget(targetCF)
            for part, offset in pairs(partOffsets) do
                pcall(function()
                    local bp = part:FindFirstChildOfClass("BodyPosition")
                    local bg = part:FindFirstChildOfClass("BodyGyro")
                    local worldCF = targetCF * offset
                    if bp then bp.Position = worldCF.Position end
                    if bg then bg.CFrame = worldCF end
                end)
            end
        end

        local function moveTo(targetPos, maxSec)
            setTarget(CFrame.new(targetPos))
            if not primary then return end
            for i = 1, maxSec * 20 do
                task.wait(0.05)
                if (primary.Position - targetPos).Magnitude < 4 then return end
            end
        end

        local function waitGrabbed()
            for i = 1, 40 do
                task.wait(0.1)
                local rw = rDet:FindFirstChild("RightWeld")
                local lw = lDet:FindFirstChild("LeftWeld")
                if (rw and rw.Part1) or (lw and lw.Part1) then return true end
            end
            return false
        end

        local function doRelease()
            for i = 1, 20 do
                releaseRemote:FireServer()
                dropRemote:FireServer()
                task.wait(0.05)
            end
            task.wait(0.3)
        end

        local idx = 1
        while running do
            local allPlayers = {}
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    table.insert(allPlayers, player)
                end
            end

            if #allPlayers == 0 then task.wait(0.5); continue end
            if idx > #allPlayers then idx = 1 end

            local p1 = allPlayers[idx]
            local p2 = #allPlayers >= 2 and allPlayers[(idx % #allPlayers) + 1] or nil
            idx = idx + 2
            if idx > #allPlayers then idx = 1 end

            pcall(function()
                local hrp1 = p1.Character and p1.Character:FindFirstChild("HumanoidRootPart")
                local hrp2 = p2 and p2.Character and p2.Character:FindFirstChild("HumanoidRootPart")
                if not hrp1 then return end

                -- STEP 1: プレイヤーのところにテレポ → 到着確認
                moveTo(hrp1.Position, 3)

                -- STEP 2: 掴む
                local rw = rDet:FindFirstChild("RightWeld")
                local lw = lDet:FindFirstChild("LeftWeld")
                if rw then grabRemote:FireServer(rDet, hrp1, rw) end
                if hrp2 and lw then grabRemote:FireServer(lDet, hrp2, lw) end

                -- STEP 3: 掴んだのを確認してから次へ
                if not waitGrabbed() then return end

                -- STEP 4: 真上に移動 → 到着確認
                moveTo(hrp1.Position + Vector3.new(0, liftHeight, 0), 3)

                -- STEP 5: 待機
                task.wait(holdTime)

                -- STEP 6: 確実に離す（20回連射＋0.3秒追加待機）
                doRelease()

                -- STEP 7: 離れた後の追加待機してから次へ
                task.wait(0.3)
            end)

            task.wait(0.05)
        end
        running = false
    end)
    coroutine.resume(kickAllCoro)
end})

OrionLib:Init()
