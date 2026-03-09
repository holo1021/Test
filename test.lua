local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Siro-script/FtaP.90hub/refs/heads/main/Orion"))()
local Window = OrionLib:MakeWindow({Name = "生存優先・精密Bring", IntroText = "Anti-Void Precision", HidePremium = false, SaveConfig = false, ConfigFolder = "KickAll"})
local Tab = Window:MakeTab({Name = "⚡ 実行", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")

local running = false
local liftHeight = 30 -- 高めに設定

local function getBlob()
    local char = LP.Character
    if not char then return nil end
    for _, desc in pairs(workspace:GetDescendants()) do
        if desc.Name == "CreatureBlobman" then
            local vs = desc:FindFirstChild("VehicleSeat")
            if vs and vs:FindFirstChild("SeatWeld") and vs.SeatWeld.Part1 and vs.SeatWeld.Part1:IsDescendantOf(char) then
                return desc
            end
        end
    end
    return nil
end

Tab:AddButton({Name = "🚀 修正版ループ 開始", Callback = function()
    if running then running = false return end
    running = true

    task.spawn(function()
        local blob = getBlob()
        if not blob then running = false return end
        
        local bScript = blob:WaitForChild("BlobmanSeatAndOwnerScript")
        local grabRemote = bScript:WaitForChild("CreatureGrab")
        local releaseRemote = bScript:WaitForChild("CreatureRelease")
        local dropRemote = bScript:WaitForChild("CreatureDrop")
        local rDet = blob:WaitForChild("RightDetector")
        local rw = rDet:WaitForChild("RightWeld")

        -- 【改善1】沈没防止：メインパーツの衝突判定は維持する
        for _, p in ipairs(blob:GetDescendants()) do
            if p:IsA("BasePart") then
                -- 手や装飾は消すが、足元やメインパーツは地面に当たるようにする
                if p.Name == "RightDetector" or p.Name == "Handle" then
                    p.CanCollide = false
                end
            end
        end

        while running do
            local allPlayers = Players:GetPlayers()
            for _, target in ipairs(allPlayers) do
                if not running then break end
                if target == LP or not target.Character then continue end
                
                local hrp = target.Character:FindFirstChild("HumanoidRootPart")
                local hum = target.Character:FindFirstChildOfClass("Humanoid")
                
                -- 【改善2】ターゲットが有効か厳重にチェック
                if not hrp or not hum or hum.Health <= 0 then continue end

                pcall(function()
                    -- 右手座標の計算
                    local function getArmTarget()
                        local currentPivot = blob:GetPivot()
                        local armOffset = currentPivot:Inverse() * rDet.CFrame
                        return hrp.CFrame * armOffset:Inverse()
                    end

                    -- 1. 掴むフェーズ（ターゲットが生きている間だけ）
                    local grabAttempt = 0
                    while running and grabAttempt < 10 do
                        if not hrp or not hum or hum.Health <= 0 then break end -- ターゲット消失なら即中止
                        
                        blob:PivotTo(getArmTarget())
                        grabRemote:FireServer(rDet, hrp, rw)
                        
                        local w = rDet:FindFirstChildOfClass("Weld") or rDet:FindFirstChildOfClass("ManualWeld")
                        if w then break end -- 掴めたら次へ
                        
                        grabAttempt = grabAttempt + 1
                        RunService.Heartbeat:Wait()
                    end
                    
                    -- 2. 上昇（掴んだ場合のみ）
                    if rDet:FindFirstChildOfClass("Weld") or rDet:FindFirstChildOfClass("ManualWeld") then
                        blob:PivotTo(blob:GetPivot() * CFrame.new(0, liftHeight, 0))
                        task.wait(0.15)
                        
                        -- 3. 30連打リリース
                        for i = 1, 30 do
                            releaseRemote:FireServer()
                            dropRemote:FireServer()
                            for _, child in ipairs(rDet:GetChildren()) do
                                if child:IsA("Weld") or child:IsA("ManualWeld") then child:Destroy() end
                            end
                            RunService.Heartbeat:Wait()
                        end
                        
                        -- 4. 振り落とし（上昇しすぎて死なない程度に）
                        blob:PivotTo(blob:GetPivot() * CFrame.new(0, 10, 0))
                    end
                    
                    task.wait(0.1)
                end)
            end
            task.wait(0.2)
        end
    end)
end})

OrionLib:Init()
