killalltoggle = annoyPlayersSection:AddToggle({
    Name = "Kill All",
    Default = false,
    Callback = function(killAllEnabled)
        _G.KillAll = killAllEnabled
        if killAllEnabled then
            if GetKey() ~= "Xana" then
                _G.KillAll = false
                killalltoggle:Set(false)
                showNotification("Only for premium users! Buy premium in my discord server!")
                return
            end
            while _G.KillAll do
                ipos = GetPlayerCFrame()
                local playersService = playersService
                local playerIterator, playerIterator3, playerIndex = pairs(playersService:GetPlayers())
                while true do
                    local player
                    playerIndex, player = playerIterator(playerIterator3, playerIndex)
                    if playerIndex == nil then
                        break
                    end
                    if CheckPlayerKill(player) then
                        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        local humanoid = player.Character:FindFirstChild("Humanoid")
                        if player and (humanoidRootPart and humanoid) then
                            for _ = 0, 50 do
                                dialogueFunction2()
                                SNOWship(humanoidRootPart)
                                if not CheckPlayerKill(player) or (not _G.KillAll or (CheckNetworkOwnerShipOnPlayer(player) or humanoidRootPart.AssemblyLinearVelocity.Magnitude > 500)) then
                                    CreateSkyVelocity(humanoidRootPart)
                                    destroyGrabLineEvent:FireServer(humanoidRootPart)
                                    break
                                end
                                task.wait()
                                if humanoidRootPart.Position.Y <= -12 then
                                    TeleportPlayer(CFrame.new(humanoidRootPart.Position + Vector3.new(0, 5, -15)))
                                else
                                    TeleportPlayer(CFrame.new(humanoidRootPart.Position + Vector3.new(0, -10, -10)))
                                end
                                humanoid.BreakJointsOnDeath = false
                                humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                                humanoid.Jump = true
                                humanoid.Sit = false
                            end
                        end
                    end
                end
                TeleportPlayer(ipos)
                task.wait(0.2)
            end
            dialogueFunction1()
            TeleportPlayer(ipos)
        end
    end
})
