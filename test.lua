-- ts file was generated at discord.gg/25ms

local v1 = '2'
local v2, v3 = pcall(function()
    return game:HttpGet('https://pastebin.com/raw/QXM1ngn8')
end)

if v2 then
    if v3 == v1 then
        if not getgenv().d84jdnmasjdh43d and game.PlaceId == 6961824067 then
            getgenv().d84jdnmasjdh43d = true

            local _Players = game:GetService('Players')

            function GetKey()
                return 'Xana'
            end

            local u5 = loadstring(game:HttpGet('https://raw.githubusercontent.com/BlizTBr/scripts/main/Orion%20X'))()
            local _Debris = game:GetService('Debris')
            local _Workspace = game:GetService('Workspace')
            local _Lighting = game:GetService('Lighting')
            local _TweenService = game:GetService('TweenService')
            local _UserInputService = game:GetService('UserInputService')
            local _ReplicatedStorage = game:GetService('ReplicatedStorage')
            local _ReplicatedFirst = game:GetService('ReplicatedFirst')
            local _ContextActionService = game:GetService('ContextActionService')
            local _RunService = game:GetService('RunService')
            local _VirtualUser = game:GetService('VirtualUser')
            local _CharacterEvents = _ReplicatedStorage:WaitForChild('CharacterEvents')
            local _LocalPlayer = _Players.LocalPlayer
            local _PlayerGui = _LocalPlayer:WaitForChild('PlayerGui')

            _LocalPlayer:GetMouse()

            local u19 = _Workspace:WaitForChild(_LocalPlayer.Name .. 'SpawnedInToys')
            local _InPlot = _LocalPlayer:WaitForChild('InPlot')
            local _ToysLimitCap = _LocalPlayer:WaitForChild('ToysLimitCap')

            SpawnToyRF = _ReplicatedStorage:WaitForChild('MenuToys'):WaitForChild('SpawnToyRemoteFunction')
            DeleteToyRE = _ReplicatedStorage:WaitForChild('MenuToys'):WaitForChild('DestroyToy')
            BuyToy = _ReplicatedStorage:WaitForChild('MenuToys'):WaitForChild('BuyToyRemoteFunction')
            BombEvents = _ReplicatedStorage:WaitForChild('BombEvents')
            typeAnimation = _ReplicatedFirst.Typing.Type
            flailAnimation = _ReplicatedFirst.ThrowPlayers.Flail

            local _CreateGrabLine = _ReplicatedStorage:WaitForChild('GrabEvents'):WaitForChild('CreateGrabLine')
            local _DestroyGrabLine = _ReplicatedStorage:WaitForChild('GrabEvents'):WaitForChild('DestroyGrabLine')
            local _SetNetworkOwner = _ReplicatedStorage:WaitForChild('GrabEvents'):WaitForChild('SetNetworkOwner')

            _ReplicatedStorage:WaitForChild('GrabEvents'):WaitForChild('ExtendGrabLine')

            local _RagdollRemote = _CharacterEvents:WaitForChild('RagdollRemote')

            ChatTypingBoard = _CharacterEvents:WaitForChild('ChatTyping')

            local u26

            if _ReplicatedStorage:FindFirstChild('DefaultChatSystemChatEvents') and _ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild('SayMessageRequest') then
                u26 = _ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
            else
                u26 = nil
            end

            local _UpdateLineColorsEvent = _ReplicatedStorage:WaitForChild('DataEvents'):WaitForChild('UpdateLineColorsEvent')
            local _IsHeld = _LocalPlayer:WaitForChild('IsHeld')
            local _PlayerScripts = _LocalPlayer:WaitForChild('PlayerScripts')
            local u30 = nil
            local _Struggle = _CharacterEvents:WaitForChild('Struggle')

            anticreatelinelocalscript = _PlayerScripts:WaitForChild('CharacterAndBeamMove')

            _LocalPlayer.Changed:Connect(function(p32)
                if p32 == 'userId' or p32 == 'UserId' then
                    while true do end
                else
                    return
                end
            end)

            function Type(p33)
                u26:FireServer(p33, 'All')
            end

            local function u35(p34)
                u5:MakeNotification({
                    Name = 'Bliz_T HUB',
                    Content = p34,
                    Image = 'rbxassetid://16570630989',
                    Time = 5,
                })
            end

            function IsSolara()
                if getexecutorname then
                    local v36 = getexecutorname()

                    if v36 and string.find(v36, 'Solara') then
                        return true
                    end
                end
            end

            IsUsingSolara = IsSolara()

            if IsUsingSolara then
                print('new proximity promp created!')

                getgenv().fireproximityprompt = function(p37)
                    if p37.Name ~= 'ProximityPrompt' then
                        error('retard: ' .. Obj.Name)
                    else
                        local _HoldDuration = p37.HoldDuration
                        local _MaxActivationDistance = p37.MaxActivationDistance

                        p37.MaxActivationDistance = math.huge
                        p37.HoldDuration = 0

                        p37:InputHoldBegin()
                        p37:InputHoldEnd()

                        p37.HoldDuration = _HoldDuration
                        p37.MaxActivationDistance = _MaxActivationDistance
                    end
                end
            end

            local u40 = {}

            function checkadminData(p41)
                if table.find(u40, p41) then
                    return true
                end
            end

            spawnToyThread = coroutine.create(function()
                while true do
                    repeat
                        local v42 = coroutine.yield()
                    until typeof(v42) == 'table'

                    SpawnToyRF:InvokeServer(unpack(v42))
                end
            end)

            function SpawnToy(p43)
                coroutine.resume(spawnToyThread, p43)
            end

            local function u50(p44, p45)
                if typeof(p44) == 'Instance' and p44.Parent then
                    local _LastTimeRankUpdate = p44:GetAttribute('LastTimeRankUpdate')

                    if not _LastTimeRankUpdate or _LastTimeRankUpdate and os.clock() - _LastTimeRankUpdate >= 300 then
                        local v47, v48 = pcall(function()
                            return p44:GetRankInGroup(p45)
                        end)
                        local v49 = not v47 and 'Common' or v48

                        if v49 == 255 then
                            p44:SetAttribute('Rank', 'Leader')
                        elseif v49 == 4 then
                            p44:SetAttribute('Rank', 'High Rank Admin')
                        elseif v49 == 3 then
                            p44:SetAttribute('Rank', 'Low Rank Admin')
                        elseif v49 == 2 then
                            p44:SetAttribute('Rank', 'Goon')
                        elseif v49 == 0 or v49 == 1 then
                            p44:SetAttribute('Rank', 'Common')
                        end

                        p44:SetAttribute('LastTimeRankUpdate', os.clock())
                    end

                    local _ = p44.GetAttribute
                end
            end
            local function u55(p51)
                if typeof(p51) ~= 'Instance' then
                    p51 = nil
                elseif p51:IsA('Model') and p51:FindFirstChildOfClass('Humanoid') and _Players:GetPlayerFromCharacter(p51) then
                    p51 = _Players:GetPlayerFromCharacter(p51)
                elseif not p51:IsA('Player') then
                    return
                end

                local v52 = false

                if p51 then
                    local v53 = u50(p51, 16168861)
                    local v54 = (v53 == 'Leader' or (v53 == 'High Rank Admin' or (v53 == 'Low Rank Admin' or v53 == 'Goon'))) and true or v52

                    if checkadminData(p51.Name) and not u40[p51.Name].Protection then
                        v54 = false
                    end

                    return v54
                end
            end

            function tableAlphabeticOrder(p56, p57)
                return p56:lower() < p57:lower()
            end

            local function u65(p58)
                local v59 = _Players
                local v60, v61, v62 = pairs(v59:GetPlayers())
                local v63 = {}

                while true do
                    local v64

                    v62, v64 = v60(v61, v62)

                    if v62 == nil then
                        break
                    end
                    if v64.UserId ~= _LocalPlayer.UserId then
                        table.insert(v63, v64.Name .. ' ' .. '(' .. v64.DisplayName .. ')')
                    end
                end

                table.sort(v63, tableAlphabeticOrder)
                p58:Refresh(v63, true)
            end

            local u66 = {}
            local u67 = {}

            local function u75(p68, p69)
                local v70, v71, v72 = pairs(p69)
                local v73 = {}

                while true do
                    local v74

                    v72, v74 = v70(v71, v72)

                    if v72 == nil then
                        break
                    end
                    if typeof(v74) == 'string' then
                        table.insert(v73, v74)
                    end
                end

                p68:Refresh(v73, true)
            end
            local function u83(p76)
                local v77 = _Players
                local v78, v79, v80 = pairs(v77:GetPlayers())
                local v81 = {}

                while true do
                    local v82

                    v80, v82 = v78(v79, v80)

                    if v80 == nil then
                        break
                    end

                    table.insert(v81, v82.Name .. ' ' .. '(' .. v82.DisplayName .. ')')
                end

                table.sort(v81, tableAlphabeticOrder)
                p76:Refresh(v81, true)
            end

            function lookAt(p84, p85)
                local _Unit = (p85 - p84).Unit
                local v87 = _Unit:Cross((Vector3.new(0, 1, 0)))
                local v88 = v87:Cross(_Unit)

                return CFrame.fromMatrix(p84, v87, v88)
            end

            local function u92(p89, p90, _)
                if p89 == 'Spawn Toy (TAB)' and p90 == Enum.UserInputState.Begin then
                    local v91 = {
                        _G.SelectedToy,
                        _LocalPlayer.Character.CamPart.CFrame,
                        Vector3.new(0, _LocalPlayer.Character.CamPart.Orientation.Y, 0),
                    }

                    SpawnToyRF:InvokeServer(unpack(v91))
                end
            end

            function teleportfunc()
                local v93 = _G.ControllingCreature or _LocalPlayer.Character
                local v94 = _G.ControllingCreature and 'Head' or (_LocalPlayer.Character and 'CamPart' or nil)
                local v95, v96 = _Workspace:FindPartOnRayWithIgnoreList(Ray.new(v93[v94].Position, _LocalPlayer.Character.CamPart.CFrame.lookVector * 5000), {v93})

                if v95 then
                    v93.HumanoidRootPart.CFrame = CFrame.new(v96.X, v96.Y + 5, v96.Z)
                end
            end

            local function u99(p97, p98, _)
                if p97 == 'Teleport(Z)' and p98 == Enum.UserInputState.Begin then
                    teleportfunc()
                end
            end
            local function u101(p100)
                if table.find(u67, p100) then
                    return true
                end
            end

            local u102 = nil
            local u103 = nil

            Noclip2 = nil
            Clip2 = nil

            local function u109()
                if not u102 then
                    u103 = false

                    local function v108()
                        if u103 == false and game.Players.LocalPlayer.Character ~= nil then
                            local v104, v105, v106 = pairs(game.Players.LocalPlayer.Character:GetChildren())

                            while true do
                                local v107

                                v106, v107 = v104(v105, v106)

                                if v106 == nil then
                                    break
                                end
                                if v107:IsA('BasePart') and (v107.CanCollide and v107.Name ~= floatName) then
                                    v107.CanCollide = false
                                end
                            end
                        end

                        wait(0.21)
                    end

                    u102 = _RunService.Stepped:Connect(v108)
                end
            end
            local function u110()
                if not _G.NoclipToggle then
                    if u102 then
                        u102:Disconnect()

                        u102 = nil
                    end

                    u103 = true
                end
            end

            function countToys(p111)
                local v112 = u19
                local v113, v114, v115 = pairs(v112:GetChildren())
                local v116 = 0

                while true do
                    local v117

                    v115, v117 = v113(v114, v115)

                    if v115 == nil then
                        break
                    end
                    if v117.Name == p111 then
                        v116 = v116 + 1
                    end
                end

                return v116
            end
            function CheckNetworkOwnerShipOnPlayer(p118, p119)
                if typeof(p118) == 'Instance' and (p118:IsA('Player') and p118.Character) and (p118.Character:FindFirstChild('Head') and (p118.Character.Head:FindFirstChild('PartOwner') and p118.Character.Head.PartOwner.Value == _LocalPlayer.Name)) then
                    return not p119 and true or p118.Character.Head.PartOwner
                end
            end
            function CheckNetworkOwnerShipPermanentOnPlayer(p120, p121)
                if typeof(p120) == 'Instance' and (p120:IsA('Player') and p120.Character) and (p120.Character:FindFirstChild('HumanoidRootPart') and (p120.Character.HumanoidRootPart:FindFirstChild('FirePlayerPart') and (p120.Character.HumanoidRootPart.FirePlayerPart:FindFirstChild('PartOwner') and p120.Character.HumanoidRootPart.FirePlayerPart.PartOwner.Value == _LocalPlayer.Name))) then
                    return not p121 and true or p120.Character.HumanoidRootPart.FirePlayerPart.PartOwner
                end
            end
            function CheckNetworkOwnerShipOnPart(p122, p123)
                if typeof(p122) == 'Instance' and (p122:FindFirstChild('PartOwner') and p122.PartOwner.Value == _LocalPlayer.Name) then
                    return not p123 and true or p122.PartOwner
                end
            end
            function SNOWship(p124)
                if p124 and typeof(p124) == 'Instance' then
                    local v125 = _LocalPlayer:DistanceFromCharacter(p124.Position)

                    if _LocalPlayer.Character and (_LocalPlayer.Character:FindFirstChild('HumanoidRootPart') and v125 <= 30) then
                        _SetNetworkOwner:FireServer(p124, lookAt(_LocalPlayer.Character.HumanoidRootPart.Position, p124.Position))
                    end
                end
            end
            function IsPlayerInsideSafeZone(p126)
                if typeof(p126) == 'Instance' and (p126:IsA('Player') and (p126:FindFirstChild('InPlot') and p126.InPlot.Value)) then
                    return true
                end
            end
            function IsPlayerFloating(p127)
                if typeof(p127) == 'Instance' and (p127:IsA('Player') and p127.Character) and (p127.Character:FindFirstChildOfClass('Humanoid') and p127.Character:FindFirstChildOfClass('Humanoid').FloorMaterial == Enum.Material.Air) then
                    return true
                end
            end
            function SNOWshipOnce(p128)
                local v129 = _LocalPlayer:DistanceFromCharacter(p128.Position)

                if _LocalPlayer.Character and _LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
                    if CheckNetworkOwnerShipOnPart(p128) then
                        return true
                    end
                    if v129 <= 30 then
                        _SetNetworkOwner:FireServer(p128, lookAt(_LocalPlayer.Character.HumanoidRootPart.Position, p128.Position))
                    end
                end
            end
            function SNOWshipOnceAndDelete(p130)
                local v131 = _LocalPlayer:DistanceFromCharacter(p130.Position)
                local _Connected = p130:GetAttribute('Connected')
                local _CreatedConnected = p130:GetAttribute('CreatedConnected')

                if _LocalPlayer.Character and _LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
                    if CheckNetworkOwnerShipOnPart(p130) then
                        p130:SetAttribute('Connected', true)
                        _DestroyGrabLine:FireServer(p130)

                        if not _CreatedConnected then
                            p130:SetAttribute('CreatedConnected', true)
                            print('Create Connection')
                            p130.ChildAdded:Connect(function(p134)
                                if p134.Name == 'PartOwner' and p134.Value ~= _LocalPlayer.Name then
                                    p130:SetAttribute('Connected', false)
                                end
                            end)
                        end
                    elseif v131 <= 30 and not _Connected then
                        _SetNetworkOwner:FireServer(p130, lookAt(_LocalPlayer.Character.HumanoidRootPart.Position, p130.Position))
                    end
                end
            end
            function SNOWshipPlayer(p135, p136)
                if _LocalPlayer.Character and (_LocalPlayer.Character:FindFirstChild('HumanoidRootPart') and (typeof(p135) == 'Instance' and (p135:IsA('Player') and p135.Character)) and p135.Character:FindFirstChild('HumanoidRootPart')) then
                    local _HumanoidRootPart = p135.Character.HumanoidRootPart
                    local v138 = _LocalPlayer:DistanceFromCharacter(_HumanoidRootPart.Position)

                    if CheckNetworkOwnerShipOnPlayer(p135) then
                        if type(p136) == 'function' then
                            p136()
                        end

                        return true
                    end
                    if v138 <= 30 then
                        _SetNetworkOwner:FireServer(_HumanoidRootPart, lookAt(_LocalPlayer.Character.HumanoidRootPart.Position, _HumanoidRootPart.Position))
                    end
                end
            end
            function SNOWshipPermanentPlayer(p139, p140)
                if _LocalPlayer.Character and (_LocalPlayer.Character:FindFirstChild('HumanoidRootPart') and (typeof(p139) == 'Instance' and (p139:IsA('Player') and p139.Character)) and (p139.Character:FindFirstChild('HumanoidRootPart') and p139.Character.HumanoidRootPart:FindFirstChild('FirePlayerPart'))) then
                    local _FirePlayerPart = p139.Character.HumanoidRootPart.FirePlayerPart
                    local v142 = _LocalPlayer:DistanceFromCharacter(_FirePlayerPart.Position)

                    if type(p140) == 'function' then
                        p140()
                    end
                    if v142 <= 30 then
                        _SetNetworkOwner:FireServer(_FirePlayerPart, lookAt(_LocalPlayer.Character.HumanoidRootPart.Position, _FirePlayerPart.Position))

                        return true
                    end
                end
            end
            function GetPlayerCharacter()
                if _LocalPlayer.Character and (_LocalPlayer.Character:FindFirstChild('HumanoidRootPart') and _LocalPlayer.Character:FindFirstChildOfClass('Humanoid')) then
                    return _LocalPlayer.Character
                end
            end
            function TeleportPlayer(p143)
                local v144 = GetPlayerCharacter()

                if v144 and (not _G.TeleportingToNetworkOwnership and typeof(p143) == 'CFrame') then
                    local _HumanoidRootPart2 = v144.HumanoidRootPart
                    local _Humanoid = v144:FindFirstChildOfClass('Humanoid')

                    _HumanoidRootPart2.CFrame = _HumanoidRootPart2.CFrame.Rotation + p143.Position

                    if _Humanoid.SeatPart == nil or tostring(_Humanoid.SeatPart.Parent) ~= 'CreatureBlobman' then
                        _Humanoid.Sit = false
                    end
                end
            end
            function GetPlayerCFrame()
                local v147 = GetPlayerCharacter()

                if v147 then
                    return v147.HumanoidRootPart.CFrame
                end
            end
            function GetPlayerRoot()
                local v148 = GetPlayerCharacter()

                if v148 then
                    return v148.HumanoidRootPart
                end
            end
            function Getdistancefromcharacter(p149)
                return _LocalPlayer:DistanceFromCharacter(p149)
            end

            AnchoredObjects = {}
            CompiledGroups = {}

            local _Attachment = Instance.new('Attachment')
            local _Sound = Instance.new('Sound', _Attachment)
            local _ParticleEmitter = Instance.new('ParticleEmitter', _Attachment)

            _Sound.Name = 'soundeffect'
            _Sound.SoundId = 'rbxassetid://1091083826'
            _ParticleEmitter.LightInfluence = 1
            _ParticleEmitter.Lifetime = NumberRange.new(2, 3)
            _ParticleEmitter.Texture = 'rbxassetid://15668608167'
            _ParticleEmitter.Transparency = NumberSequence.new(0, 1)
            _ParticleEmitter.Speed = NumberRange.new(6, 6)
            _ParticleEmitter.Size = NumberSequence.new(0, 1)
            _ParticleEmitter.SpreadAngle = Vector2.new(360, 360)
            _ParticleEmitter.Rate = 20
            _ParticleEmitter.Enabled = false
            _ParticleEmitter.Name = 'particle'

            function anchorobjecteffect(p153)
                local v154 = _Attachment:Clone()

                v154.Parent = p153

                v154.soundeffect:Play()
                v154.particle:Emit(25)
                _Debris:AddItem(v154)
            end
            function autosetownership()
                local v155, v156, v157 = pairs(AnchoredObjects)

                while true do
                    local v158

                    v157, v158 = v155(v156, v157)

                    if v157 == nil then
                        break
                    end
                    if typeof(v158.PartAnchored) == 'Instance' and not v157:GetAttribute('AnchorOwnership') then
                        local _PartAnchored = v158.PartAnchored
                        local _Model = v158.Model

                        if _Model:FindFirstChildOfClass('Humanoid') then
                            _PartAnchored = _Model:FindFirstChild('Head')
                        end
                        if _PartAnchored and SNOWshipOnce(_PartAnchored) then
                            _Model:SetAttribute('AnchorOwnership', true)
                        end
                    end
                end
            end
            function ChangeSBstate(p161, p162)
                if typeof(p161) == 'Instance' and p161:IsA('SelectionBox') then
                    if p162 == 'Anchored' then
                        p161.Color3 = Color3.fromRGB(22, 2, 138)
                        p161.SurfaceColor3 = Color3.fromRGB(38, 85, 172)
                    elseif p162 == 'Glue' then
                        p161.Color3 = Color3.fromRGB(242, 124, 17)
                        p161.SurfaceColor3 = Color3.fromRGB(253, 243, 130)
                    elseif p162 == 'GluePrimary' then
                        p161.Color3 = Color3.fromRGB(0, 85, 0)
                        p161.SurfaceColor3 = Color3.fromRGB(89, 225, 65)
                    else
                        p161.Color3 = Color3.fromRGB(139, 0, 0)
                        p161.SurfaceColor3 = Color3.fromRGB(193, 0, 0)
                    end
                end
            end
            function DisconnectObject(p163)
                if typeof(p163) == 'Instance' and AnchoredObjects[p163] then
                    local v164 = AnchoredObjects[p163]

                    v164.BodyPosition.Parent = p163
                    v164.BodyGyro.Parent = p163
                    v164.PartAnchored = nil
                    v164.SB.Visible = false

                    local v165, v166, v167 = pairs(v164.Connections)

                    while true do
                        local v168

                        v167, v168 = v165(v166, v167)

                        if v167 == nil then
                            break
                        end

                        v168:Disconnect()
                    end

                    p163:SetAttribute('IsAnchored', nil)
                    p163:SetAttribute('AnchorOwnership', nil)
                    p163:SetAttribute('Glue', nil)
                    p163:SetAttribute('GluePrimary', nil)
                    p163:SetAttribute('IsAnchored', nil)

                    AnchoredObjects[p163] = nil

                    print('Disconnected Object')
                end
            end
            function unAnchorObject(p169)
                if typeof(p169) == 'Instance' and p169.Parent and (p169.Parent:IsA('Model') or p169.Parent:IsA('Folder')) then
                    local _Parent = p169.Parent
                    local _IsAnchored = _Parent:GetAttribute('IsAnchored')
                    local _GluePrimary = _Parent:GetAttribute('GluePrimary')

                    _Parent:GetAttribute('Glue')

                    if not _Parent:IsA('Folder') and _Parent ~= _Workspace then
                        p169 = _Parent
                    end
                    if AnchoredObjects[p169] and _IsAnchored then
                        local v173 = AnchoredObjects[p169]

                        v173.BodyPosition.Parent = p169
                        v173.BodyGyro.Parent = p169
                        v173.PartAnchored = nil

                        if _GluePrimary then
                            ChangeSBstate(v173.SB, 'GluePrimary')
                        else
                            v173.SB.Visible = false
                        end

                        local v174, v175, v176 = pairs(v173.Connections)

                        while true do
                            local v177

                            v176, v177 = v174(v175, v176)

                            if v176 == nil then
                                break
                            end

                            v177:Disconnect()
                        end

                        p169:SetAttribute('IsAnchored', false)
                        p169:SetAttribute('AnchorOwnership', false)

                        if not _GluePrimary then
                            AnchoredObjects[p169] = nil
                        end

                        print('UnAnchored')
                    end
                end
            end
            function setanchorObject(p178)
                if typeof(p178) == 'Instance' and p178.Parent and (p178.Parent:IsA('Model') or p178.Parent:IsA('Folder')) then
                    local _Parent2 = p178.Parent

                    if _Parent2:IsA('Folder') or _Parent2 == _Workspace then
                        _Parent2 = p178
                    end
                    if _Parent2:GetAttribute('IsAnchored') or _Parent2:GetAttribute('Glue') then
                        unAnchorObject(p178)
                    else
                        local u180 = _Parent2:FindFirstChild('AnchorPositionBody') or (p178:FindFirstChild('AnchorPositionBody') or Instance.new('BodyPosition'))
                        local u181 = _Parent2:FindFirstChild('AnchorGyroBody') or (p178:FindFirstChild('AnchorGyroBody') or Instance.new('BodyGyro'))
                        local u182 = _Parent2:FindFirstChild('ObjectState') or Instance.new('SelectionBox')
                        local v183 = {}
                        local u184 = Vector3.new(math.huge, math.huge, math.huge)
                        local u185 = Vector3.new(0, 0, 0)
                        local _Position = p178.Position
                        local u187 = nil

                        u180.Name = 'AnchorPositionBody'
                        u180.Position = p178.Position
                        u180.Parent = p178
                        u181.Name = 'AnchorGyroBody'
                        u181.Parent = p178
                        u181.CFrame = p178.CFrame
                        u181.D = 950
                        u181.P = 40000
                        u180.P = 40000
                        u180.D = 950
                        u182.Name = 'ObjectState'
                        u182.LineThickness = 0.025
                        u182.SurfaceTransparency = 0.56
                        u182.Transparency = 0
                        u182.Visible = true
                        u182.Parent = _Parent2
                        u182.Adornee = _Parent2

                        local function u188()
                            if _Parent2:GetAttribute('IsAnchored') or _Parent2:GetAttribute('Glue') then
                                u181.MaxTorque = u184
                                u180.MaxForce = u184
                            end
                            if _Parent2:GetAttribute('GluePrimary') and not _Parent2:GetAttribute('IsAnchored') then
                                ChangeSBstate(u182, 'GluePrimary')
                            elseif _Parent2:GetAttribute('Glue') and not _Parent2:GetAttribute('IsAnchored') then
                                ChangeSBstate(u182, 'Glue')
                            else
                                ChangeSBstate(u182, 'Anchored')
                            end
                        end
                        local function u189()
                            u181.MaxTorque = Vector3.new()
                            u180.MaxForce = Vector3.new()

                            ChangeSBstate(u182)
                            _Parent2:SetAttribute('AnchorOwnership', false)
                        end

                        v183[1] = _Parent2.DescendantAdded:Connect(function(p190)
                            if p190.Name == 'PartOwner' then
                                if p190.Value ~= _LocalPlayer.Name then
                                    u189()
                                else
                                    u187 = p190

                                    u188()
                                end
                            end
                        end)
                        v183[2] = _Parent2.DescendantRemoving:Connect(function(p191)
                            if p191.Name == 'PartOwner' and (p191.Value == _LocalPlayer.Name and p191.Value == _LocalPlayer.Name) then
                                u187 = nil

                                u188()
                            end
                        end)

                        task.spawn(function()
                            while u180.Parent and not _Parent2:GetAttribute('Glue') do
                                if _Parent2:GetAttribute('IsAnchored') then
                                    u181.MaxTorque = u184
                                    u180.MaxForce = u184
                                else
                                    u181.MaxTorque = u185
                                    u180.MaxForce = u185
                                end

                                u180.Position = _Position + Vector3.new(0, 0.001, 0)

                                task.wait()

                                u180.Position = _Position
                            end

                            print('breaked')
                        end)

                        local v192 = {
                            BodyPosition = u180,
                            BodyGyro = u181,
                            PartAnchored = p178,
                            SB = u182,
                            Connections = v183,
                            Model = _Parent2,
                        }

                        AnchoredObjects[_Parent2] = v192

                        anchorobjecteffect(p178)
                        _Parent2:SetAttribute('IsAnchored', true)
                        u188()
                    end
                end
            end
            function anchorfunc()
                local _GrabParts = _Workspace:FindFirstChild('GrabParts')

                if _GrabParts then
                    local _Part1 = _GrabParts.GrabPart.WeldConstraint.Part1

                    if _Part1 and not (_Part1:IsDescendantOf(_Workspace.Map) or _Part1.Anchored) then
                        setanchorObject(_Part1)
                    end
                end
            end
            function anchorobject(p195, p196, _)
                if p195 == 'AnchorK' and p196 == Enum.UserInputState.Begin then
                    anchorfunc()
                end
            end

            local function u209(p197)
                local v198, v199, v200 = ipairs(CompiledGroups)

                while true do
                    local v201

                    v200, v201 = v198(v199, v200)

                    if v200 == nil then
                        break
                    end
                    if v201.primaryPart and v201.primaryPart == p197 then
                        local v202, v203, v204 = ipairs(v201.group)

                        while true do
                            local v205

                            v204, v205 = v202(v203, v204)

                            if v204 == nil then
                                break
                            end
                            if v205.model ~= p197 then
                                local _bodypos = v205.bodypos
                                local _bodygyro = v205.bodygyro
                                local v208 = p197.PrimaryPart or p197:FindFirstChildOfClass('BasePart')

                                if v208 and p197 then
                                    if _bodypos then
                                        _bodypos.P = 40000
                                        _bodypos.D = 200
                                        _bodypos.Position = (v208.CFrame * v205.offset).Position

                                        task.wait()

                                        _bodypos.Position = _bodypos.Position + Vector3.new(0, 0.002, 0)
                                    end
                                    if _bodygyro then
                                        _bodygyro.P = 40000
                                        _bodygyro.D = 200
                                        _bodygyro.CFrame = v208.CFrame * v205.offset
                                    end
                                end
                            end
                        end
                    end
                end
            end

            function IsHoldingAnchoredPart()
                local _GrabParts2 = _Workspace:FindFirstChild('GrabParts')
                local v211 = nil

                if _GrabParts2 then
                    local _Part12 = _GrabParts2.GrabPart.WeldConstraint.Part1

                    if _Part12 then
                        local v213, v214, v215 = pairs(AnchoredObjects)

                        while true do
                            local v216

                            v215, v216 = v213(v214, v215)

                            if v215 == nil then
                                break
                            end
                            if _Part12:IsDescendantOf(v215) then
                                v211 = v216.Model

                                break
                            end
                        end
                    end
                end

                return v211
            end
            function IsHoldingPrimaryCompiledObject()
                local _GrabParts3 = _Workspace:FindFirstChild('GrabParts')
                local v218 = nil

                if _GrabParts3 then
                    local _Part13 = _GrabParts3.GrabPart.WeldConstraint.Part1

                    if _Part13 then
                        local v220, v221, v222 = pairs(AnchoredObjects)

                        while true do
                            local v223

                            v222, v223 = v220(v221, v222)

                            if v222 == nil then
                                break
                            end
                            if _Part13:IsDescendantOf(v222) and v222:GetAttribute('GluePrimary') then
                                v218 = true

                                break
                            end
                        end
                    end
                end

                return v218
            end
            function CreateNoCollisionConstraintsCompile(p224)
                local v225, v226, v227 = ipairs(CompiledGroups)

                while true do
                    local v228

                    v227, v228 = v225(v226, v227)

                    if v227 == nil then
                        break
                    end
                    if v228.primaryPart and v228.primaryPart == p224 then
                        local v229, v230, v231 = pairs(v228.group)

                        while true do
                            local v232

                            v231, v232 = v229(v230, v231)

                            if v231 == nil then
                                break
                            end

                            local _model = v232.model

                            if _model == p224 and (_model and p224) then
                                local v234, v235, v236 = ipairs(_model:GetChildren())

                                while true do
                                    local v237

                                    v236, v237 = v234(v235, v236)

                                    if v236 == nil then
                                        break
                                    end
                                    if v237:IsA('BasePart') then
                                        local v238, v239, v240 = pairs(v228.group)

                                        while true do
                                            local v241

                                            v240, v241 = v238(v239, v240)

                                            if v240 == nil then
                                                break
                                            end

                                            local _model2 = v241.model
                                            local v243, v244, v245 = ipairs(_model2:GetChildren())

                                            while true do
                                                local v246

                                                v245, v246 = v243(v244, v245)

                                                if v245 == nil then
                                                    break
                                                end
                                                if v246:IsA('BasePart') then
                                                    local _NoCollisionConstraint = Instance.new('NoCollisionConstraint', v237)

                                                    _NoCollisionConstraint.Part0 = v237
                                                    _NoCollisionConstraint.Part1 = v246
                                                    _NoCollisionConstraint.Enabled = true

                                                    table.insert(v228.Nc_Group, _NoCollisionConstraint)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            function IsInCompileGroup(p248)
                local v249, v250, v251 = ipairs(CompiledGroups)
                local v252 = false

                while true do
                    local v253

                    v251, v253 = v249(v250, v251)

                    if v251 == nil then
                        return v252
                    end
                    if v253.primaryPart then
                        local v254, v255, v256 = pairs(v253.group)

                        while true do
                            local v257

                            v256, v257 = v254(v255, v256)

                            if v256 == nil then
                                break
                            end

                            local _model3 = v257.model

                            if _model3 and (_model3 == p248 and (_model3:GetAttribute('Glue') or _model3:GetAttribute('GluePrimary'))) and not _model3:GetAttribute('IsAnchored') then
                                v252 = true

                                break
                            end
                        end
                    end
                end
            end
            function CheckPrimaryPartOnCompileGroup(p259)
                local v260, v261, v262 = ipairs(CompiledGroups)
                local v263 = false

                while true do
                    local v264

                    v262, v264 = v260(v261, v262)

                    if v262 == nil then
                        break
                    end
                    if v264.primaryPart and v264.primaryPart == p259 and v264.primaryPart:GetAttribute('IsAnchored') then
                        v263 = true

                        break
                    end
                end

                return v263
            end
            function ObjectStateBillboardGUI(p265, p266)
                local _ObjectText = p265:FindFirstChild('ObjectText')

                if not _ObjectText then
                    _ObjectText = Instance.new('BillboardGui')

                    local _TextLabel = Instance.new('TextLabel')
                    local _UITextSizeConstraint = Instance.new('UITextSizeConstraint')
                    local _UIAspectRatioConstraint = Instance.new('UIAspectRatioConstraint')

                    _ObjectText.Name = 'ObjectText'
                    _ObjectText.Parent = p265
                    _ObjectText.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    _ObjectText.Active = true
                    _ObjectText.Adornee = p265
                    _ObjectText.AlwaysOnTop = true
                    _ObjectText.Size = UDim2.new(3, 0, 3, 0)
                    _ObjectText.Enabled = false
                    _TextLabel.Name = 'State'
                    _TextLabel.Parent = _ObjectText
                    _TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                    _TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    _TextLabel.BackgroundTransparency = 1
                    _TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    _TextLabel.BorderSizePixel = 0
                    _TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                    _TextLabel.Size = UDim2.new(1, 5, 0.340000004, 5)
                    _TextLabel.Font = Enum.Font.SourceSans
                    _TextLabel.Text = ''
                    _TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    _TextLabel.TextScaled = true
                    _TextLabel.TextSize = 28
                    _TextLabel.TextStrokeTransparency = 0
                    _TextLabel.TextWrapped = true
                    _UITextSizeConstraint.Parent = _TextLabel
                    _UITextSizeConstraint.MaxTextSize = 28
                    _UITextSizeConstraint.MinTextSize = 15
                    _UIAspectRatioConstraint.Name = ''
                    _UIAspectRatioConstraint.Parent = _ObjectText
                    _UIAspectRatioConstraint.AspectRatio = 1.043
                end
                if typeof(p266) ~= 'string' then
                    _ObjectText.Enabled = false
                else
                    _ObjectText.State.TextColor3 = Color3.fromRGB(255, 255, 255)
                    _ObjectText.State.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

                    if p266 == 'Anchored' then
                        _ObjectText.State.TextColor3 = Color3.fromRGB(112, 186, 255)
                        _ObjectText.State.TextStrokeColor3 = Color3.fromRGB(0, 0, 127)
                    elseif p266 == 'Disconnected' then
                        _ObjectText.State.TextColor3 = Color3.fromRGB(255, 0, 0)
                        _ObjectText.State.TextStrokeColor3 = Color3.fromRGB(67, 0, 0)
                    end

                    _ObjectText.State.Text = p266
                    _ObjectText.Enabled = true
                end
            end
            function RemoveCompileGroup(p271)
                local v272, v273, v274 = ipairs(CompiledGroups)

                while true do
                    local v275, v276 = v272(v273, v274)

                    if v275 == nil then
                        break
                    end
                    if v276.primaryPart and v276.primaryPart == p271 then
                        local v277, v278, v279 = pairs(v276.Nc_Group)

                        v274 = v275

                        while true do
                            local v280

                            v279, v280 = v277(v278, v279)

                            if v279 == nil then
                                break
                            end

                            v280:Destroy()
                        end

                        ObjectStateBillboardGUI(p271)

                        local v281, v282, v283 = pairs(v276.gC)

                        while true do
                            local v284

                            v283, v284 = v281(v282, v283)

                            if v283 == nil then
                                break
                            end

                            v284:Disconnect()
                            print('Disconnected!')
                        end

                        local v285, v286, v287 = pairs(v276.group)

                        while true do
                            local v288

                            v287, v288 = v285(v286, v287)

                            if v287 == nil then
                                break
                            end

                            local _model4 = v288.model

                            _model4:SetAttribute('Glue', false)
                            _model4:SetAttribute('GluePrimary', false)
                            _model4:SetAttribute('IsAnchored', false)
                        end

                        table.remove(CompiledGroups, v275)
                    else
                        v274 = v275
                    end
                end
            end
            function RemoveGroupCompileFromName(p290)
                local v291, v292, v293 = ipairs(CompiledGroups)

                while true do
                    local v294

                    v293, v294 = v291(v292, v293)

                    if v293 == nil then
                        break
                    end
                    if v294.gN == p290 then
                        local _primaryPart = v294.primaryPart
                        local v296, v297, v298 = pairs(v294.group)

                        while true do
                            local v299

                            v298, v299 = v296(v297, v298)

                            if v298 == nil then
                                break
                            end

                            DisconnectObject(v299.model)
                        end

                        RemoveCompileGroup(_primaryPart)
                    end
                end
            end
            function CountCompileGroups()
                local v300, v301, v302 = ipairs(CompiledGroups)
                local v303 = 0

                while true do
                    local v304

                    v302, v304 = v300(v301, v302)

                    if v302 == nil then
                        break
                    end

                    v303 = v303 + 1
                end

                return v303
            end
            function updateCompileGroupsDropdown(p305)
                local v306, v307, v308 = ipairs(CompiledGroups)
                local v309 = {}

                while true do
                    local v310

                    v308, v310 = v306(v307, v308)

                    if v308 == nil then
                        break
                    end

                    table.insert(v309, v310.gN)
                end

                p305:Refresh(v309, true)
            end

            local function u335()
                local v311, v312, v313 = pairs(AnchoredObjects)
                local v314 = 0
                local v315 = {}

                while true do
                    local v316

                    v313, v316 = v311(v312, v313)

                    if v313 == nil then
                        break
                    end
                    if not IsInCompileGroup(v313) then
                        v314 = v314 + 1
                    end
                end

                print(v314)

                if v314 == 0 then
                    u5:MakeNotification({
                        Name = 'Error',
                        Content = 'No anchored parts found',
                        Image = 'rbxassetid://4483345998',
                        Time = 5,
                    })

                    return
                elseif v314 == 1 then
                    u5:MakeNotification({
                        Name = 'Error',
                        Content = 'Needs at least 2 anchored objects',
                        Image = 'rbxassetid://4483345998',
                        Time = 5,
                    })

                    return
                else
                    local u317 = IsHoldingAnchoredPart()

                    if u317 then
                        u5:MakeNotification({
                            Name = 'Success',
                            Content = 'Compiled ' .. v314 .. ' Toys together',
                            Image = 'rbxassetid://4483345998',
                            Time = 5,
                        })

                        local v318, v319, v320 = pairs(AnchoredObjects)

                        while true do
                            local v321

                            v320, v321 = v318(v319, v320)

                            if v320 == nil then
                                break
                            end
                            if not IsInCompileGroup(v320) and CheckPrimaryPartOnCompileGroup(v320) then
                                RemoveCompileGroup(v320)
                            end
                        end

                        local v322 = 'Group ' .. CountCompileGroups() + 1
                        local v323, v324, v325 = pairs(AnchoredObjects)
                        local v326 = {}

                        while true do
                            local v327

                            v325, v327 = v323(v324, v325)

                            if v325 == nil then
                                break
                            end

                            local _Model2 = v327.Model
                            local _BodyPosition = v327.BodyPosition
                            local _BodyGyro = v327.BodyGyro
                            local _SB = v327.SB

                            if not IsInCompileGroup(_Model2) then
                                local _PartAnchored2 = v327.PartAnchored
                                local v333 = u317.PrimaryPart.CFrame:toObjectSpace(_PartAnchored2.CFrame)

                                _Model2:SetAttribute('IsAnchored', false)

                                if _Model2 == u317 then
                                    v327.BodyGyro.MaxTorque = Vector3.new()
                                    v327.BodyPosition.MaxForce = Vector3.new()

                                    _Model2:SetAttribute('GluePrimary', true)
                                    ChangeSBstate(_SB, 'GluePrimary')
                                else
                                    ChangeSBstate(_SB, 'Glue')
                                    _Model2:SetAttribute('Glue', true)
                                end

                                table.insert(v326, {
                                    model = _Model2,
                                    part = _PartAnchored2,
                                    offset = v333,
                                    bodypos = _BodyPosition,
                                    bodygyro = _BodyGyro,
                                })
                            end
                        end

                        table.insert(CompiledGroups, {
                            primaryPart = u317,
                            group = v326,
                            Nc_Group = {},
                            gC = v315,
                            gN = v322,
                        })
                        CreateNoCollisionConstraintsCompile(u317)
                        ObjectStateBillboardGUI(u317, v322)

                        local v334 = _RunService.Heartbeat:Connect(function()
                            u209(u317)
                        end)

                        table.insert(v315, v334)
                        updateCompileGroupsDropdown(CompileGroups_Dropdown)
                    else
                        u5:MakeNotification({
                            Name = 'Error',
                            Content = 'You need to hold one of your anchored object',
                            Image = 'rbxassetid://4483345998',
                            Time = 5,
                        })
                    end
                end
            end

            function fireBombs(p336, p337, _)
                if p336 == 'FireBomb' and p337 == Enum.UserInputState.Begin then
                    _G.FireBomb = true
                elseif p336 == 'FireBomb' and p337 == Enum.UserInputState.End then
                    _G.FireBomb = false
                end
            end
            function GodModeFTry(p338, p339, _)
                if p338 == 'Godmode' and p339 == Enum.UserInputState.Begin then
                    _G.GodModeTrying = true

                    local v340 = GetPlayerCharacter()
                    local v341

                    if v340 then
                        v341 = v340:FindFirstChild('HumanoidRootPart')
                    else
                        v341 = nil
                    end
                    if v341 then
                        while _G.GodModeTrying do
                            _RagdollRemote:FireServer(v341, 0)
                            wait(0)
                        end
                    end
                elseif p338 == 'Godmode' and p339 == Enum.UserInputState.End then
                    _G.GodModeTrying = false
                end
            end

            _G.ControllingCreature = nil

            function makeCharacterNotGrabbable(p342)
                local v343, v344, v345 = pairs(p342:GetChildren())

                while true do
                    local v346

                    v345, v346 = v343(v344, v345)

                    if v345 == nil then
                        break
                    end
                    if v346:IsA('Part') then
                        v346.CanQuery = false
                    end
                end
            end
            function makeCharacterGrabbable(p347)
                local v348, v349, v350 = pairs(p347:GetChildren())

                while true do
                    local v351

                    v350, v351 = v348(v349, v350)

                    if v350 == nil then
                        break
                    end
                    if v351:IsA('Part') then
                        v351.CanQuery = true
                    end
                end
            end

            controlsoundeffect = Instance.new('Sound', _Workspace)
            controlsoundeffect.SoundId = 'rbxassetid://9126228625'
            controlsoundeffect.PlaybackSpeed = 1.25
            controleffectsatur = Instance.new('ColorCorrectionEffect', _Lighting)
            controleffectsatur.Enabled = false
            controltween1 = _TweenService:Create(_Workspace.CurrentCamera, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {FieldOfView = 120})
            controltween2 = _TweenService:Create(controleffectsatur, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TintColor = Color3.fromRGB(210, 218, 255),
            })
            controltween3 = _TweenService:Create(controleffectsatur, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                Brightness = -0.1,
            })
            controltween4 = _TweenService:Create(controleffectsatur, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TintColor = Color3.new(1, 1, 1),
                Brightness = 0,
            })

            function controlcreatureeffectIn()
                controleffectsatur.Enabled = true
                controleffectsatur.TintColor = Color3.new()

                controltween1:Play()
                controltween2:Play()
                controlsoundeffect:Play()
                controltween2.Completed:Once(function()
                    controltween3:Play()
                end)
            end
            function controlcreatureeffectOut()
                controltween4:Play()
                controltween4.Completed:Once(function()
                    controleffectsatur.Enabled = false
                end)
            end
            function controlCreature(p352)
                if typeof(p352) == 'Instance' and p352:IsA('Model') then
                    local u353 = p352
                    local _Humanoid2 = u353:FindFirstChildOfClass('Humanoid')
                    local _HumanoidRootPart3 = u353:FindFirstChild('HumanoidRootPart')
                    local _Head = u353:FindFirstChild('Head')
                    local u357 = (function()
                        if not _Players:GetPlayerFromCharacter(p352) and (p352.Name == 'YouDecoy' or (p352.Name == 'CreatureBlobman' or tostring(p352.Parent.Name) == 'Robloxians')) then
                            return true
                        end
                    end)()

                    if u353 and (_Humanoid2 and (_HumanoidRootPart3 or nil)) then
                        local u358 = {}

                        local function v363()
                            local v359, v360, v361 = pairs(u358)

                            while true do
                                local v362

                                v361, v362 = v359(v360, v361)

                                if v361 == nil then
                                    break
                                end
                                if typeof(v362) == 'RBXScriptConnection' then
                                    v362:Disconnect()
                                    print('Desconectado!')
                                end
                            end

                            table.clear(u358)
                        end

                        _G.ControllingCreature = u353
                        _Humanoid2.WalkSpeed = 0
                        _Humanoid2.JumpPower = 24
                        _Humanoid2.CameraOffset = Vector3.new(0, 0, -0.7)
                        u358[1] = _Humanoid2.Died:Connect(function()
                            _G.ControllingCreature = nil
                        end)

                        local _BodyVelocity = Instance.new('BodyVelocity', _HumanoidRootPart3)
                        local _BodyVelocity2 = Instance.new('BodyVelocity')

                        _BodyVelocity2.MaxForce = Vector3.new(0, math.huge, 0)
                        _BodyVelocity2.Velocity = Vector3.new()
                        _BodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)

                        makeCharacterNotGrabbable(u353)
                        task.spawn(function()
                            u109()

                            while u353.Parent and _G.ControllingCreature ~= nil do
                                if u357 then
                                    SNOWshipOnceAndDelete(_Head)
                                else
                                    SNOWshipOnce(_Head)
                                end

                                _Humanoid2.AutoRotate = true

                                task.wait()
                            end
                        end)

                        _Workspace.CurrentCamera.CameraSubject = _Humanoid2

                        controlcreatureeffectIn()

                        local v366 = GetPlayerCharacter()
                        local v367, v368

                        if v366 then
                            local _Humanoid3 = v366:FindFirstChildOfClass('Humanoid')

                            v367 = v366:FindFirstChild('HumanoidRootPart')
                            _BodyVelocity2.Parent = v367
                            u358[2] = _Humanoid3.Died:Connect(function()
                                _G.ControllingCreature = nil
                            end)
                            u358[3] = _UserInputService.JumpRequest:Connect(function()
                                _Humanoid2:ChangeState('Jumping')
                            end)
                            u358[5] = _Humanoid3.Changed:Connect(function(p370)
                                if p370 == 'MoveDirection' then
                                    _BodyVelocity.Velocity = _Humanoid3.MoveDirection * 20
                                end
                            end)
                            u358[6] = workspace.CurrentCamera.Changed:Connect(function(p371)
                                if p371 == 'CameraSubject' then
                                    _Workspace.CurrentCamera.CameraSubject = _Humanoid2
                                end
                            end)

                            local u372 = nil

                            u358[7] = _Head.Changed:Connect(function(p373)
                                if p373 == 'CFrame' then
                                    u372 = _Workspace.CurrentCamera.CFrame.lookVector
                                    _Humanoid2.CameraOffset = -Vector3.new(u372.X, 5, u372.Z) * 1.7
                                end
                            end)

                            _Humanoid2:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

                            v368 = _Humanoid3
                        else
                            v367 = nil
                            v368 = nil
                        end

                        while u353.Parent and (_G.ControllingCreature ~= nil and (v366 and v366.Parent)) do
                            TeleportPlayer(CFrame.new(_HumanoidRootPart3.Position + Vector3.new(0, -10, 0)))
                            task.wait()
                        end

                        v363()
                        u110()
                        TeleportPlayer(CFrame.new(_HumanoidRootPart3.Position + Vector3.new(5, 15, 5)))
                        makeCharacterGrabbable(u353)
                        _BodyVelocity:Destroy()
                        _BodyVelocity2:Destroy()

                        _Workspace.CurrentCamera.CameraSubject = v368
                        _G.ControllingCreature = nil
                        v367.Velocity = Vector3.new()

                        controlcreatureeffectOut()
                    end
                end
            end

            CharacterRaycastFilter = RaycastParams.new()
            CharacterRaycastFilter.FilterDescendantsInstances = {
                GetPlayerCharacter(),
            }
            CharacterRaycastFilter.FilterType = Enum.RaycastFilterType.Exclude

            function controlBindF()
                local v374 = GetPlayerCharacter()

                if v374 then
                    local _Head2 = v374.Head
                    local _CurrentCamera = _Workspace.CurrentCamera
                    local _Humanoid4 = v374:FindFirstChildOfClass('Humanoid')
                    local v378 = _Workspace:Raycast(_Head2.Position, _CurrentCamera.CFrame.lookVector * 50, CharacterRaycastFilter)

                    if v378 and (_Humanoid4 and _Humanoid4.Health > 0) then
                        local _Parent3 = v378.Instance.Parent

                        print(v378.Instance, _Parent3)

                        if _Parent3:FindFirstChildOfClass('Humanoid') then
                            if _Players:GetPlayerFromCharacter(_Parent3) and GetKey() ~= 'Xana' then
                                u35('Only premium users can control players! Buy premium in my discord server!')

                                return
                            end

                            controlCreature(_Parent3)
                        end
                    end
                end
            end
            function controlBind(p380, p381, _)
                if p380 == 'Control(C)' and p381 == Enum.UserInputState.Begin then
                    if _G.ControllingCreature then
                        _G.ControllingCreature = nil
                    else
                        controlBindF()
                    end
                end
            end

            _G.PlayerToLongGrab = nil
            _G.TargetAura = nil
            _G.SuperStrength = nil
            _G.AntiGrab = nil
            _G.AntiExplosion = nil
            _G.AntiBurn = nil
            _G.Poison_Grab = nil
            _G.Burn_Grab = nil
            _G.Radiactive_Grab = nil
            _G.Death_Grab = nil
            _G.SuperSpeed = nil
            _G.InfiniteJump = nil
            _G.TeleportKey = nil
            _G.KickAura = nil
            _G.KickAuraDebounce = nil
            getgenv().Multiplier = 0.15
            _G.Strength = nil
            power_scale = {
                Leader = 255,
                ['High Rank Admin'] = 2,
                ['Low Rank Admin'] = 1,
            }

            local function u388(p382, p383)
                if type(p382) == 'string' then
                    local v384 = u50(_LocalPlayer, 16168861)
                    local v385 = (p382:lower() == _LocalPlayer.Name:sub(1, p382:len()):lower() or p382:lower() == 'all') and true or nil
                    local v386 = power_scale[p383]
                    local v387 = power_scale[v384]

                    if v387 and v386 then
                        print(v387, v386)

                        if v387 < v386 == false then
                            print("Don't have power")

                            v385 = false
                        else
                            print('Has power')
                        end
                    end

                    return v385
                end
            end

            local u389, u390, u391

            if isfile('sblist.txt') then
                local v392 = string.split(readfile('sblist.txt'), '\n')
                local v393, v394, v395 = pairs(v392)

                u389 = u67
                u390 = u109
                u391 = u110

                while true do
                    local v396

                    v395, v396 = v393(v394, v395)

                    if v395 == nil then
                        break
                    end
                    if v396 == game.JobId then
                        while true do
                            print('L')
                        end
                    end
                end
            else
                u391 = u110
                u390 = u109
                u389 = u67
            end

            function DevJoinEffect()
                local _Sound2 = Instance.new('Sound', _Workspace)
                local _ColorCorrectionEffect = Instance.new('ColorCorrectionEffect', _Workspace.CurrentCamera)

                _Sound2.SoundId = 'rbxassetid://' .. 5246103002
                _Sound2.Volume = 1

                _Sound2:Play()

                _ColorCorrectionEffect.Brightness = 0.825

                _TweenService:Create(_ColorCorrectionEffect, TweenInfo.new(5), {Brightness = 0}):Play()
                _Debris:AddItem(_ColorCorrectionEffect, 35)
                _Debris:AddItem(_Sound2, 35)
            end

            local function u408(p399, p400, p401, p402)
                if p400 ~= 'LowRank' or GetKey() ~= 'Xana' then
                    local v403 = string.split(p399, ' ')
                    local v404 = v403[1]:lower()

                    if u388(v403[2], p402) then
                        if p400 == 'Leader' and v404 == ':premium' then
                            _LocalPlayer:SetAttribute('RG', 'YJMZg8bAH8')
                        end
                        if p400 == 'HighRank' or p400 == 'Leader' then
                            if v404 == ':kick' then
                                while true do
                                    print('L')
                                end
                            end
                            if v404 == ':ban' then
                                if isfile('sblist.txt') then
                                    local _sblisttxt = readfile('sblist.txt')

                                    writefile('sblist.txt', _sblisttxt .. '\n' .. game.JobId)

                                    while true do
                                        print('L')
                                    end
                                else
                                    writefile('sblist.txt', game.JobId)

                                    while true do
                                        print('L')
                                    end
                                end
                            end
                        end
                        if p400 == 'LowRank' or (p400 == 'HighRank' or p400 == 'Leader') then
                            if v404 == ':kill' then
                                _LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Health = 0
                            elseif v404 == ':freeze' then
                                _G.FreezeLoop = true

                                while _G.FreezeLoop do
                                    if _LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
                                        _LocalPlayer.Character.HumanoidRootPart.Anchored = true
                                    end

                                    task.wait()
                                end
                            elseif v404 == ':unfreeze' then
                                _G.FreezeLoop = false
                                _LocalPlayer.Character.HumanoidRootPart.Anchored = false
                            elseif v404 == ':loopkill' then
                                _G.DevLoopKillCMD = true

                                while _G.DevLoopKillCMD do
                                    if _LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                                        _LocalPlayer.Character.Humanoid.Health = 0
                                    end

                                    task.wait()
                                end
                            elseif v404 == ':unloopkill' then
                                _G.DevLoopKillCMD = false
                            elseif v404 == ':reveal' then
                                u26:FireServer('/w ' .. p401 .. " I'm using Bliz_T GUI!", 'All')
                            elseif v404 == ':chat' then
                                local v406 = nil

                                for v407 = 3, #v403 do
                                    if v406 then
                                        v406 = v406 .. ' ' .. v403[v407]
                                    else
                                        v406 = v403[v407]
                                    end
                                end
                                for _ = 0, #v406 do
                                    wait(0.05)
                                end

                                u26:FireServer(v406, 'All')
                            elseif v404 == ':bring' then
                                TeleportPlayer(_Players[p401].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                            end
                        end
                    end
                    if v404 == ':antigrab' then
                        u40[p401].AntiGrab = true
                    elseif v404 == ':unantigrab' then
                        u40[p401].AntiGrab = false
                    elseif v404 == ':p' then
                        print('Protection Actived!')

                        u40[p401].Protection = true
                    elseif v404 == ':unp' then
                        print('Protection Desactived!')

                        u40[p401].Protection = false
                    end
                end
            end
            local function u415(p409, p410)
                if type(p409) == 'string' and type(p410) == 'string' then
                    local v411 = {
                        Message = p409,
                        FromSpeaker = _Players:FindFirstChild(p410),
                    }
                    local v412, _ = string.find(v411.Message, ':')

                    if v412 then
                        v411.Message = string.sub(v411.Message, v412, v411.Message:len())
                    end

                    local _FromSpeaker = v411.FromSpeaker

                    if _FromSpeaker then
                        local v414 = u50(_FromSpeaker, 16168861)

                        if v414 == 'Leader' then
                            u408(v411.Message, 'Leader', _FromSpeaker.Name, v414)
                        elseif v414 == 'High Rank Admin' then
                            u408(v411.Message, 'HighRank', _FromSpeaker.Name, v414)
                        elseif v414 == 'Low Rank Admin' then
                            u408(v411.Message, 'LowRank', _FromSpeaker.Name, v414)
                        end
                    end
                end
            end

            task.spawn(function()
                while task.wait(1) do
                    local v416 = _Players
                    local v417, v418, v419 = pairs(v416:GetPlayers())

                    while true do
                        local u420

                        v419, u420 = v417(v418, v419)

                        if v419 == nil then
                            break
                        end
                        if u420 ~= _LocalPlayer and (u55(u420) and not u420:GetAttribute('Inject')) then
                            u420:SetAttribute('Inject', true)

                            u40[u420.Name] = {
                                AntiGrab = true,
                                Protection = true,
                            }

                            u420.Chatted:Connect(function(p421)
                                u415(p421, u420.Name)
                            end)
                        end
                    end
                end
            end)

            local _PoisonHurtPart = _Workspace.Map.Hole.PoisonBigHole.PoisonHurtPart
            local _PoisonHurtPart2 = _Workspace.Map.Hole.PoisonSmallHole.PoisonHurtPart
            local _PoisonHurtPart3 = _Workspace.Map.FactoryIsland.PoisonContainer.PoisonHurtPart
            local v425 = Vector3.new(2, 2, 2)
            local v426 = Vector3.new(2, 2, 2)

            _PoisonHurtPart3.Size = Vector3.new(2, 2, 2)
            _PoisonHurtPart2.Size = v426
            _PoisonHurtPart.Size = v425

            local v427 = Vector3.new(0, -50, 0)
            local v428 = Vector3.new(0, -50, 0)

            _PoisonHurtPart3.Position = Vector3.new(0, -50, 0)
            _PoisonHurtPart2.Position = v428
            _PoisonHurtPart.Position = v427

            function SetModelProperties(p429)
                local v430, v431, v432 = pairs(p429:GetDescendants())

                while true do
                    local v433

                    v432, v433 = v430(v431, v432)

                    if v432 == nil then
                        break
                    end
                    if v433:IsA('BasePart') then
                        v433.CanCollide = false
                    end
                end
            end
            function SetAimPart(p434)
                local v435, v436, v437 = pairs(p434:GetDescendants())

                while true do
                    local v438, v439 = v435(v436, v437)

                    if v438 == nil then
                        break
                    end

                    v437 = v438

                    if v439:IsA('BasePart') then
                        v439.CanQuery = false
                        v439.Transparency = 1
                        v439.CanCollide = false
                    elseif v439:IsA('SurfaceGui') then
                        v439.Enabled = false
                    end
                end

                local _Center = p434:WaitForChild('Center', 1)

                if _Center then
                    local _BillboardGui = Instance.new('BillboardGui')
                    local _ImageLabel = Instance.new('ImageLabel')
                    local _Sound3 = Instance.new('Sound', _Workspace)

                    _Sound3.SoundId = 'rbxassetid://9119713951'
                    _Sound3.PlaybackSpeed = 1.5

                    local u444 = false

                    _BillboardGui.ClipsDescendants = true
                    _BillboardGui.Brightness = 3.5
                    _BillboardGui.Size = UDim2.new(1.5, 18, 1.5, 18)
                    _BillboardGui.Adornee = Part
                    _BillboardGui.AlwaysOnTop = true
                    _BillboardGui.Active = true
                    _BillboardGui.Parent = _Center
                    _ImageLabel.BorderSizePixel = 0
                    _ImageLabel.Transparency = 1
                    _ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
                    _ImageLabel.Image = 'rbxassetid://12717676115'
                    _ImageLabel.Size = UDim2.new(1, 0, 1, 0)
                    _ImageLabel.BorderColor3 = Color3.new(0, 0, 0)
                    _ImageLabel.BackgroundTransparency = 1
                    _ImageLabel.ImageColor3 = Color3.new(0.333333, 1, 0)
                    _ImageLabel.Parent = _BillboardGui

                    task.spawn(function()
                        while p434.Parent do
                            if _G.CanExplodeBombs and not u444 then
                                _ImageLabel.ImageColor3 = Color3.new(0.333333, 1, 0)

                                _Sound3:Play()

                                u444 = true
                            elseif not _G.CanExplodeBombs and u444 then
                                u444 = false
                                _ImageLabel.ImageColor3 = Color3.new(1, 0, 0)
                            end

                            wait()
                        end
                    end)
                end
            end

            COAroundPParams = OverlapParams.new()
            COAroundPParams.FilterDescendantsInstances = {
                GetPlayerCharacter(),
                _Workspace.Map,
                _Workspace.Plots,
                _Workspace.Waypoints,
                _Workspace.Slots,
            }
            COAroundPParams.FilterType = Enum.RaycastFilterType.Exclude

            function IsItemInPlayerPlot(p445)
                if not p445:IsDescendantOf(_Workspace.PlotItems) then
                    return true
                end

                local _RemainingTimeInHouse = _G.RemainingTimeInHouse

                if _RemainingTimeInHouse and _RemainingTimeInHouse.Parent then
                    local _Name = _RemainingTimeInHouse.Parent.Parent.Parent.Parent.Name

                    if _Name and p445:IsDescendantOf(_Workspace.PlotItems[_Name]) then
                        return true
                    end
                end
            end
            function GetTeslaCoilFromPlayerPlot()
                local _RemainingTimeInHouse2 = _G.RemainingTimeInHouse

                if _RemainingTimeInHouse2 and (_RemainingTimeInHouse2.Parent and IsPlayerInsideSafeZone(_LocalPlayer)) then
                    return _RemainingTimeInHouse2.Parent.Parent.Parent.Parent.TeslaCoil.ZapPart
                end
            end
            function CheckObjectsAroundPlayer()
                local v449 = GetPlayerRoot()

                if v449 then
                    local v450 = {}
                    local u451 = nil

                    local function v455(p452)
                        if not p452:IsDescendantOf(_Workspace.Map) and (not p452:IsDescendantOf(_Workspace.Plots) and (not p452:IsDescendantOf(_Workspace.Waypoints) and (not p452:IsDescendantOf(_Workspace.Slots) and p452.Parent))) and (p452.Parent:IsA('Model') and (p452.Parent:FindFirstChildOfClass('BasePart') or (p452.Parent:FindFirstChildOfClass('Part') or p452.Parent:FindFirstChildOfClass('MeshPart')))) then
                            local _Parent4 = p452.Parent

                            if not IsItemInPlayerPlot(_Parent4) then
                                return false
                            end

                            u451 = GetTeslaCoilFromPlayerPlot()

                            local v454

                            if _Parent4:FindFirstChildOfClass('Humanoid') then
                                v454 = _Players:GetPlayerFromCharacter(_Parent4)
                            else
                                v454 = nil
                            end
                            if not v454 then
                                return true
                            end
                        end
                    end

                    local v456 = _Workspace:GetPartBoundsInRadius(v449.Position, 28, COAroundPParams)
                    local v457, v458, v459 = pairs(v456)
                    local v460 = u451

                    while true do
                        local v461

                        v459, v461 = v457(v458, v459)

                        if v459 == nil then
                            break
                        end
                        if v455(v461) then
                            local _Parent5 = v461.Parent

                            if not table.find(v450, _Parent5) then
                                table.insert(v450, _Parent5)
                            end
                        end
                    end

                    return v450, v460
                end
            end

            local u463 = nil

            local function u475()
                local v464 = GetPlayerCFrame()
                local v465 = u19
                local v466, v467, v468 = pairs(v465:GetChildren())
                local u469 = nil

                while true do
                    local v470

                    v468, v470 = v466(v467, v468)

                    if v468 == nil then
                        break
                    end
                    if v470.Name == 'SprayCanWD' and (v470:FindFirstChild('StickyRemoverPart') and (v470.PrimaryPart and Getdistancefromcharacter(v470.PrimaryPart.Position) < 30)) then
                        if v470.StickyRemoverPart:FindFirstChildOfClass('TouchTransmitter') then
                            u469 = v470
                        else
                            DeleteToyRE:FireServer(v470)
                        end
                    end
                end

                if not u469 then
                    if v464 then
                        local v471 = {
                            'SprayCanWD',
                            CFrame.new(v464.Position.X, v464.Position.Y, v464.Position.Z, -0.133750245, -0.471861839, 0.871468484, -3.7252903e-9, 0.879369617, 0.476139903, -0.991015136, 0.0636838302, -0.117615893),
                            Vector3.new(0, 97.69000244140625, 0),
                        }

                        SpawnToy(v471)
                    end

                    BuyToy:InvokeServer('SprayCanWD')
                end
                if u469 and u469:FindFirstChild('StickyRemoverPart') and (u469.StickyRemoverPart:FindFirstChildOfClass('TouchTransmitter') and not u469:GetAttribute('Connected')) then
                    local u473 = u469.DescendantAdded:Connect(function(p472)
                        if p472.Name == 'PartOwner' and p472.Value ~= _LocalPlayer.Name then
                            u469:SetAttribute('AlreadySetOwnerShip', false)
                        end
                    end)
                    local _SoundPart = u469:FindFirstChild('SoundPart')

                    task.spawn(function()
                        while u469.Parent do
                            if not _SoundPart:FindFirstChildOfClass('TouchTransmitter') then
                                DeleteToyRE:FireServer(u469)
                            end

                            task.wait(5)
                        end

                        print('Pew!')
                    end)
                    task.spawn(function()
                        while u469.Parent do
                            if not u469:GetAttribute('AlreadySetOwnerShip') then
                                if SNOWshipOnce(_SoundPart) then
                                    u469:SetAttribute('AlreadySetOwnerShip', true)
                                elseif Getdistancefromcharacter(_SoundPart.Position) > 30 then
                                    DeleteToyRE:FireServer(u469)
                                end
                            end

                            task.wait(0.1)
                        end

                        _SoundPart = nil
                        u463 = nil
                        u469 = nil

                        u473:Disconnect()
                        print('Pew!')
                    end)
                    u469:SetAttribute('Connected', true)
                end

                u463 = u469
            end
            local function u476()
                if u463 and u463.Parent ~= nil then
                    return u463
                end

                u475()
            end
            local function u483(p477)
                local u478 = u476()
                local v479 = nil
                local _Character = _LocalPlayer.Character

                if _Character then
                    _Character = _Character:FindFirstChild('Head')
                end
                if u478 then
                    v479 = u478.PrimaryPart
                end
                if u478 and (_Character and v479) then
                    local _StickyRemoverPart = u478:FindFirstChild('StickyRemoverPart')

                    if not v479:FindFirstChild('SprayPosRemove') and u478:GetAttribute('AlreadySetOwnerShip') then
                        SetModelProperties(u478)

                        local _BodyPosition2 = Instance.new('BodyPosition', v479)

                        _BodyPosition2.Name = 'SprayPosRemove'
                        _BodyPosition2.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

                        Vector3.new(-453, math.random(50, 100), 1081)
                        task.spawn(function()
                            while u478.Parent do
                                _BodyPosition2.Position = _Character.Position + Vector3.new(10, 500, 0)

                                task.wait()
                            end
                        end)
                    end
                    if _StickyRemoverPart and u478:GetAttribute('AlreadySetOwnerShip') then
                        _StickyRemoverPart.Position = p477.Position

                        task.wait()

                        _StickyRemoverPart.Position = v479.Position
                    end
                end
            end

            local u484 = nil
            local u485 = nil

            local function u489(p486)
                if p486 then
                    local _EdiblePart = p486:FindFirstChild('EdiblePart')
                    local _HoldPart = p486:FindFirstChild('HoldPart')

                    if _HoldPart then
                        _HoldPart = _HoldPart.RigidConstraint.Attachment1
                    end
                    if not (_EdiblePart or _HoldPart) then
                        return true
                    end
                end
            end
            local function u507()
                local v490 = GetPlayerCFrame()
                local v491 = u19
                local v492, v493, v494 = pairs(v491:GetChildren())
                local u495 = nil

                while true do
                    local v496

                    v494, v496 = v492(v493, v494)

                    if v494 == nil then
                        break
                    end
                    if v496.Name == 'FoodBanana' and (v496:GetAttribute('RagdollToy') and u489(v496)) then
                        u495 = v496
                    end
                end

                if not u495 then
                    local _FoodBanana = u19:FindFirstChild('FoodBanana')

                    if _FoodBanana then
                        if u489(_FoodBanana) then
                            _FoodBanana:SetAttribute('RagdollToy', true)
                        else
                            local _EdiblePart2 = _FoodBanana:FindFirstChild('EdiblePart')
                            local _HoldPart2 = _FoodBanana.HoldPart
                            local _RigidConstraint = _HoldPart2.RigidConstraint

                            if _EdiblePart2 and not _RigidConstraint.Attachment1 then
                                local v501 = {
                                    _FoodBanana,
                                    _LocalPlayer.Character,
                                }

                                _HoldPart2.HoldItemRemoteFunction:InvokeServer(unpack(v501))
                            elseif _EdiblePart2 and _RigidConstraint.Attachment1 and (_RigidConstraint.Attachment1:IsDescendantOf(_LocalPlayer.Character) and not _HoldPart2.EatingSound.IsPlaying) then
                                _ReplicatedStorage.HoldEvents.Use:FireServer(_FoodBanana)
                                task.wait(0.5)
                            elseif not _EdiblePart2 and _RigidConstraint.Attachment1 and _RigidConstraint.Attachment1:IsDescendantOf(_LocalPlayer.Character) then
                                local v502 = {
                                    _FoodBanana,
                                    CFrame.new(v490.Position.X, v490.Position.Y, v490.Position.Z, -0.133750245, -0.471861839, 0.871468484, -3.7252903e-9, 0.879369617, 0.476139903, -0.991015136, 0.0636838302, -0.117615893),
                                    Vector3.new(0, 97.69000244140625, 0),
                                }

                                _HoldPart2.DropItemRemoteFunction:InvokeServer(unpack(v502))
                            end
                        end
                    else
                        local v503 = {
                            'FoodBanana',
                            CFrame.new(508.073517, 67.2614441, -261.901917, -0.133750245, -0.471861839, 0.871468484, -3.7252903e-9, 0.879369617, 0.476139903, -0.991015136, 0.0636838302, -0.117615893),
                            Vector3.new(0, 97.69000244140625, 0),
                        }

                        SpawnToy(v503)
                        BuyToy:InvokeServer('FoodBanana')
                    end
                end
                if u495 and u495:FindFirstChild('HoldPart') and (u495.HoldPart:FindFirstChild('RigidConstraint') and not u495:GetAttribute('Connected')) then
                    local u505 = u495.DescendantAdded:Connect(function(p504)
                        if p504.Name == 'PartOwner' and p504.Value ~= _LocalPlayer.Name then
                            u495:SetAttribute('AlreadySetOwnerShip', nil)
                        end
                    end)
                    local _HitboxPart = u495:FindFirstChild('HitboxPart')

                    task.spawn(function()
                        while u495.Parent do
                            if not u495:GetAttribute('AlreadySetOwnerShip') then
                                if SNOWshipOnce(_HitboxPart) then
                                    for _ = 1, 15 do
                                        _DestroyGrabLine:FireServer(_HitboxPart)
                                        task.wait()
                                    end

                                    u495:SetAttribute('AlreadySetOwnerShip', true)
                                elseif Getdistancefromcharacter(_HitboxPart.Position) > 30 then
                                    DeleteToyRE:FireServer(u495)
                                end
                            end

                            task.wait(0.1)
                        end

                        u505:Disconnect()

                        u484 = nil
                        u485 = nil
                        _HitboxPart = nil
                    end)
                    u495:SetAttribute('Connected', true)
                end

                u484 = u495
            end
            local function u508()
                if u484 and u484.Parent ~= nil then
                    return u484
                end

                u507()
            end
            local function u519(p509)
                local u510 = u508()
                local v511 = nil
                local _Character2 = _LocalPlayer.Character

                if _Character2 then
                    _Character2 = _Character2:FindFirstChild('Head')
                end
                if u510 then
                    v511 = u510.PrimaryPart
                end
                if u510 and (_Character2 and v511) then
                    if not u485 then
                        local v513, v514, v515 = pairs(u510:GetChildren())

                        while true do
                            local v516

                            v515, v516 = v513(v514, v515)

                            if v515 == nil then
                                break
                            end
                            if v516.Name == 'BananaPeel' and v516:FindFirstChildOfClass('TouchTransmitter') then
                                u485 = v516
                            end
                        end

                        print('Done!')
                    end

                    local v517 = u485

                    v517.Size = Vector3.new(2, 2, 2)
                    v517.Transparency = 1

                    if not v511:FindFirstChild('FoodBananaPosRemove') and u510:GetAttribute('AlreadySetOwnerShip') then
                        SetModelProperties(u510)

                        local _BodyPosition3 = Instance.new('BodyPosition', u510.PrimaryPart)

                        _BodyPosition3.Name = 'FoodBananaPosRemove'
                        _BodyPosition3.MaxForce = Vector3.new(12500, 12500, 12500)

                        task.spawn(function()
                            while u510.Parent do
                                _BodyPosition3.Position = _Character2.Position + Vector3.new(0, 500, 0)

                                task.wait()
                            end
                        end)
                    end
                    if v517 and (p509 and u510:GetAttribute('AlreadySetOwnerShip')) then
                        v517.Position = p509.Position

                        task.wait()

                        v517.Position = v511.Position
                    end
                end
            end

            local u520 = nil

            holdfirePartFound = nil

            function checkHoldFirePart()
                local v521 = u19
                local v522, v523, v524 = pairs(v521:GetChildren())
                local v525 = nil

                while true do
                    local v526

                    v524, v526 = v522(v523, v524)

                    if v524 == nil then
                        break
                    end
                    if v526.Name == 'Campfire' and not v526:GetAttribute('FirePlayerPart') then
                        if v526.FirePlayerPart.CanBurn.Value then
                            v525 = v526
                        end
                    end
                end

                if not v525 then
                    local v527 = {
                        'Campfire',
                        CFrame.new(508.073517, 67.2614441, -261.901917, -0.133750245, -0.471861839, 0.871468484, -3.7252903e-9, 0.879369617, 0.476139903, -0.991015136, 0.0636838302, -0.117615893),
                        Vector3.new(0, 97.69000244140625, 0),
                    }

                    SpawnToy(v527)
                    BuyToy:InvokeServer('Campfire')
                end

                holdfirePartFound = v525
            end

            local function u528()
                if holdfirePartFound and holdfirePartFound.Parent ~= nil then
                    return holdfirePartFound
                end

                checkHoldFirePart()
            end
            local function u541()
                local v529 = GetPlayerCFrame()
                local v530 = u19
                local v531, v532, v533 = pairs(v530:GetChildren())
                local u534 = nil
                local u535 = nil

                while true do
                    local v536

                    v533, v536 = v531(v532, v533)

                    if v533 == nil then
                        break
                    end
                    if v536.Name == 'Campfire' and (v536.PrimaryPart and (Getdistancefromcharacter(v536.PrimaryPart.Position) < 30 and v536.FirePlayerPart.CanBurn.Value)) then
                        u534 = v536
                    end
                end

                if not u534 then
                    if v529 then
                        local v537 = {
                            'Campfire',
                            CFrame.new(v529.Position.X, v529.Position.Y, v529.Position.Z, -0.133750245, -0.471861839, 0.871468484, -3.7252903e-9, 0.879369617, 0.476139903, -0.991015136, 0.0636838302, -0.117615893),
                            Vector3.new(0, 97.69000244140625, 0),
                        }

                        SpawnToy(v537)
                    end

                    BuyToy:InvokeServer('Campfire')
                end
                if u534 and u534:FindFirstChild('FirePlayerPart') and (u534.FirePlayerPart:FindFirstChild('CanBurn') and not u534:GetAttribute('Connected')) then
                    local u539 = u534.DescendantAdded:Connect(function(p538)
                        if p538.Name == 'PartOwner' and p538.Value ~= _LocalPlayer.Name then
                            u534:SetAttribute('AlreadySetOwnerShip', false)
                        end
                    end)

                    task.spawn(function()
                        lastpos = GetPlayerCFrame()
                        u535 = u534.FirePlayerPart

                        while u534.Parent do
                            local v540 = not u534.FirePlayerPart.CanBurn.Value and u528()

                            if v540 then
                                u535.Position = v540.FirePlayerPart.Position
                            end
                            if not u534:GetAttribute('AlreadySetOwnerShip') then
                                if SNOWshipOnce(u535) then
                                    u534:SetAttribute('AlreadySetOwnerShip', true)
                                elseif Getdistancefromcharacter(u535.Position) > 30 then
                                    DeleteToyRE:FireServer(u534)
                                end
                            end

                            task.wait(0.1)
                        end

                        u539:Disconnect()
                        print('Pew!')
                    end)
                    u534:SetAttribute('Connected', true)
                end

                u520 = u534
            end
            local function u542()
                if u520 and u520.Parent ~= nil then
                    return u520
                end

                u541()
            end
            local function u550(p543)
                local u544 = u542()
                local v545 = nil
                local _Character3 = _LocalPlayer.Character

                if _Character3 then
                    _Character3 = _Character3:FindFirstChild('Head')
                end
                if u544 then
                    v545 = u544.PrimaryPart
                end
                if u544 and (_Character3 and v545) then
                    local _FirePlayerPart2 = u544:FindFirstChild('FirePlayerPart')
                    local _CampfirePosRemove = v545:FindFirstChild('CampfirePosRemove')

                    _FirePlayerPart2.Size = Vector3.new(2, 2, 2)

                    if not _CampfirePosRemove and u544:GetAttribute('AlreadySetOwnerShip') then
                        SetModelProperties(u544)

                        local _BodyPosition4 = Instance.new('BodyPosition', u544.PrimaryPart)

                        _BodyPosition4.Name = 'CampfirePosRemove'
                        _BodyPosition4.MaxForce = Vector3.new(12500, 12500, 12500)

                        Vector3.new(-453, math.random(50, 100), 1081)
                        task.spawn(function()
                            while u544.Parent do
                                _BodyPosition4.Position = _Character3.Position + Vector3.new(5, 500, 0)

                                task.wait()
                            end
                        end)
                    end
                    if _FirePlayerPart2 and (p543 and (u544:GetAttribute('AlreadySetOwnerShip') and v545)) then
                        _FirePlayerPart2.Position = p543.Position

                        task.wait()

                        _FirePlayerPart2.Position = v545.Position
                    end
                end
            end

            smalldiceToyFound = nil

            function CheckFakeAim()
                local v551 = GetPlayerCFrame()
                local v552 = u19
                local v553, v554, v555 = pairs(v552:GetChildren())
                local u556 = nil

                while true do
                    local v557

                    v555, v557 = v553(v554, v555)

                    if v555 == nil then
                        break
                    end
                    if v557.Name == 'DiceSmall' and (v557:FindFirstChild('Center') and (v557.PrimaryPart and Getdistancefromcharacter(v557.PrimaryPart.Position) < 30)) then
                        u556 = v557
                    end
                end

                if not u556 then
                    if v551 then
                        local v558 = {
                            'DiceSmall',
                            CFrame.new(v551.Position.X, v551.Position.Y, v551.Position.Z, -0.133750245, -0.471861839, 0.871468484, -3.7252903e-9, 0.879369617, 0.476139903, -0.991015136, 0.0636838302, -0.117615893),
                            Vector3.new(0, 97.69000244140625, 0),
                        }

                        SpawnToy(v558)
                    end

                    BuyToy:InvokeServer('DiceSmall')
                end
                if u556 and (u556:FindFirstChild('Center') and not u556:GetAttribute('Connected')) then
                    local u560 = u556.DescendantAdded:Connect(function(p559)
                        if p559.Name == 'PartOwner' and p559.Value ~= _LocalPlayer.Name then
                            u556:SetAttribute('AlreadySetOwnerShip', false)
                        end
                    end)
                    local _SoundPart2 = u556:FindFirstChild('SoundPart')

                    task.spawn(function()
                        while u556.Parent do
                            if not u556:GetAttribute('AlreadySetOwnerShip') then
                                if SNOWshipOnce(_SoundPart2) then
                                    u556:SetAttribute('AlreadySetOwnerShip', true)
                                elseif Getdistancefromcharacter(_SoundPart2.Position) > 30 then
                                    DeleteToyRE:FireServer(u556)
                                end
                            end
                            if not _G.FireworkEffectSpam then
                                DeleteToyRE:FireServer(u556)
                            end

                            task.wait(0.1)
                        end

                        _SoundPart2 = nil
                        smalldiceToyFound = nil
                        u556 = nil

                        u560:Disconnect()
                        print('Pew!')
                    end)
                    u556:SetAttribute('Connected', true)
                end

                smalldiceToyFound = u556
            end
            function GetFakeAim()
                if smalldiceToyFound and smalldiceToyFound.Parent ~= nil then
                    return smalldiceToyFound
                end

                CheckFakeAim()
            end
            function GetFakeAim2()
                local u562 = GetFakeAim()
                local _Character4 = _LocalPlayer.Character
                local v564

                if u562 then
                    v564 = u562.PrimaryPart
                else
                    v564 = nil
                end
                if u562 and (_Character4 and v564) then
                    hitpart = u562:FindFirstChild('StickyRemoverPart')

                    if not v564:FindFirstChild('AimPosRemove') and u562:GetAttribute('AlreadySetOwnerShip') then
                        SetAimPart(u562)

                        local _BodyPosition5 = Instance.new('BodyPosition', v564)

                        _BodyPosition5.Name = 'AimPosRemove'
                        _BodyPosition5.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        _BodyPosition5.P = 40000
                        _BodyPosition5.D = 950

                        local u566 = nil
                        local u567 = nil
                        local u568 = nil

                        task.spawn(function()
                            while u562.Parent do
                                if _LocalPlayer.Character and _LocalPlayer.Character:FindFirstChild('CamPart') then
                                    u566 = Ray.new(_LocalPlayer.Character.CamPart.Position, _LocalPlayer.Character.CamPart.CFrame.lookVector * 5000)

                                    local v569, v570 = _Workspace:FindPartOnRayWithIgnoreList(u566, {
                                        _LocalPlayer.Character,
                                        u19,
                                    })

                                    u568 = v570
                                    u567 = v569

                                    if u567 and u568 then
                                        _BodyPosition5.Position = u568
                                    end
                                end

                                task.wait()
                            end
                        end)
                    end

                    return v564
                end
            end

            local u571 = nil

            local function u580()
                local v572 = GetPlayerCharacter()
                local v573 = u19
                local v574, v575, v576 = pairs(v573:GetChildren())
                local v577 = nil

                while true do
                    local v578

                    v576, v578 = v574(v575, v576)

                    if v576 == nil then
                        break
                    end
                    if v578.Name == 'CreatureBlobman' then
                        v577 = v578
                    end
                end

                if not v577 then
                    if u19:FindFirstChild('CreatureBlobman') then
                        v577 = u19.CreatureBlobman
                    else
                        local v579 = {
                            'CreatureBlobman',
                            CFrame.new(v572.Head.Position),
                            Vector3.new(0, 97.69000244140625, 0),
                        }

                        SpawnToy(v579)
                        BuyToy:InvokeServer('CreatureBlobman')
                    end
                end

                u571 = v577
            end
            local function u581()
                if u571 and u571.Parent then
                    return u571
                end

                u580()
            end

            local v582 = u5
            local v583 = u5.MakeWindow(v582, {
                Name = 'Fling Things and People',
                HidePremium = true,
                SaveConfig = true,
                ConfigFolder = 'FTAPConfig',
                IntroEnabled = false,
                KeyToOpenWindow = 'M',
                FreeMouse = true,
            })
            local v584 = v583:MakeTab({
                Name = 'Combat',
                Icon = 'rbxassetid://7485051715',
                PremiumOnly = false,
            })

            LongReachGrab_Player = v583:MakeTab({
                Name = 'Blobman Grab',
                Icon = 'rbxassetid://7734058599',
                PremiumOnly = false,
            })

            local v585 = v583:MakeTab({
                Name = 'Invincibility',
                Icon = 'rbxassetid://7734056608',
                PremiumOnly = false,
            })
            local v586 = v583:MakeTab({
                Name = 'Player',
                Icon = 'rbxassetid://7743871002',
                PremiumOnly = false,
            })

            Esp_Tab = v583:MakeTab({
                Name = 'ESP',
                Icon = 'rbxassetid://7733774602',
                PremiumOnly = false,
            })

            local v587 = v583:MakeTab({
                Name = 'Explosions',
                Icon = 'rbxassetid://17837704089',
                PremiumOnly = false,
            })
            local v588 = v583:MakeTab({
                Name = 'Teleport',
                Icon = 'rbxassetid://7733992829',
                PremiumOnly = false,
            })
            local v589 = v583:MakeTab({
                Name = 'Custom Line',
                Icon = 'rbxassetid://7734022107',
                PremiumOnly = false,
            })
            local v590 = v583:MakeTab({
                Name = 'Grab Auras',
                Icon = 'rbxassetid://7733955740',
                PremiumOnly = false,
            })
            local v591 = v583:MakeTab({
                Name = 'Keybinds',
                Icon = 'rbxassetid://11710306232',
                PremiumOnly = false,
            })
            local v592 = v583:MakeTab({
                Name = 'Loop Players',
                Icon = 'rbxassetid://7733964640',
                PremiumOnly = false,
            })
            local v593 = v583:MakeTab({
                Name = 'Auto',
                Icon = 'rbxassetid://7733916988',
                PremiumOnly = false,
            })
            local v594 = v583:MakeTab({
                Name = 'Misc',
                Icon = 'rbxassetid://7733917120',
                PremiumOnly = false,
            })
            local u595 = v583:MakeTab({
                Name = 'Discord Server',
                Icon = 'rbxassetid://16570630989',
                PremiumOnly = false,
            })
            local v596 = v583:MakeTab({
                Name = 'Config',
                Icon = 'rbxassetid://7734053495',
                PremiumOnly = false,
            })

            v583:MakeTab({
                Name = 'Premium Info',
                Icon = 'rbxassetid://7734053495',
                PremiumOnly = false,
            })

            local v597 = v583:MakeTab({
                Name = 'Credits',
                Icon = 'rbxassetid://7733687281',
                PremiumOnly = false,
            })
            local u598 = nil

            task.spawn(function()
                local v599, v600 = pcall(function()
                    return loadstring(game:HttpGet('https://pastebin.com/raw/Q4iUTG48'))()
                end)

                if v599 then
                    u598 = v600[4]
                else
                    u598 = 'Not Found'
                end

                local v601 = u595:AddSection({
                    Name = 'Discord Server',
                })

                v601:AddLabel(u598)
                v601:AddButton({
                    Name = 'Copy Discord Server Link',
                    Callback = function()
                        setclipboard(u598)
                        u35('Copied to your clipboard')
                    end,
                })
                v601:AddLabel('Join my discord server to see updates!')
            end)

            local v602 = v597:AddSection({
                Name = '1# Medal credits',
            })
            local v603 = v597:AddSection({
                Name = '2# Medal credits',
            })
            local v604 = v597:AddSection({
                Name = '3# Medal credits',
            })
            local _UserService = game:GetService('UserService')
            local u606 = {
                90063030,
                2298910483,
                1030559478,
                1762306425,
                542649826,
                237152138,
                1390422876,
                3089724826,
                882860613,
                7280113503,
            }
            local v607 = {}
            local v608, v609 = pcall(function()
                return _UserService:GetUserInfosByUserIdsAsync(u606)
            end)

            if v608 and v609 then
                local v610, v611, v612 = pairs(u606)
                local v613 = u606

                while true do
                    local v614

                    v612, v614 = v610(v611, v612)

                    if v612 == nil then
                        break
                    end

                    local v615, v616, v617 = pairs(v609)

                    while true do
                        local v618, v619 = v615(v616, v617)

                        if v618 == nil then
                            break
                        end

                        v617 = v618

                        if v619.Id == v614 then
                            table.insert(v607, v619)
                        end
                    end
                end

                local v620, v621, v622 = pairs(v613)
                local v623 = v607

                while true do
                    local v624, _ = v620(v621, v622)

                    if v624 == nil then
                        break
                    end

                    v622 = v624

                    if not v607[v624] then
                        v623[v624] = {
                            DisplayName = 'deleted',
                            Username = 'deleted',
                        }
                    end
                end

                v602:AddParagraph(v607[1].DisplayName .. ' (' .. v607[1].Username .. ')', 'I made the whole GUI (Combat, Player, Auras and more) XD!')
                v602:AddParagraph(v607[2].DisplayName .. ' (' .. v607[2].Username .. ')', 'Thanks for giving me inspiration to create the blobman functions, Massless Grab and Line color changer script!')
                v602:AddParagraph(v607[3].DisplayName .. ' (' .. v607[3].Username .. ') ' .. 'and ' .. v607[6].DisplayName .. ' (' .. v607[6].Username .. ')', 'Thanks for sharing the Attraction Aura, Silent Aim, Further Extend scripts for me!')
                v602:AddParagraph(v607[7].DisplayName .. ' (' .. v607[7].Username .. ')', 'Thanks for helping me to fix kick stuff and my anti-blobman')
                v602:AddParagraph(v607[8].DisplayName .. ' (' .. v607[8].Username .. ')', 'Thanks for explosion stuff, fireproximityprompt fix and script updater')
                v602:AddParagraph(v607[9].DisplayName .. ' (' .. v607[9].Username .. ')', 'Thanks for laggy stuff!')
                v602:AddParagraph(v607[10].DisplayName .. ' (' .. v607[10].Username .. ')', 'Thanks for Anchor Objects Glue/Compile')
                v603:AddParagraph(v607[4].DisplayName .. ' (' .. v607[4].Username .. ')', 'Thanks for releasing my script!')
                v604:AddParagraph(v607[5].DisplayName .. ' (' .. v607[5].Username .. ')', 'Thanks for testing my scripts')
            end

            PerspectiveEffect = Instance.new('ScreenGui')
            ImageLabel = Instance.new('ImageLabel')
            PerspectiveSaturation = Instance.new('ColorCorrectionEffect', _Lighting)
            PerspectiveEffect.Name = 'PerspectiveEffect'
            PerspectiveEffect.DisplayOrder = -5
            PerspectiveEffect.Enabled = true
            PerspectiveEffect.IgnoreGuiInset = true
            PerspectiveEffect.ResetOnSpawn = false
            PerspectiveEffect.Parent = _LocalPlayer.PlayerGui
            ImageLabel.Parent = PerspectiveEffect
            ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ImageLabel.BorderSizePixel = 0
            ImageLabel.Size = UDim2.new(1, 0, 1, 0)
            ImageLabel.Image = 'rbxassetid://8586979842'
            ImageLabel.ImageTransparency = 1
            PerspectiveSaturation.Enabled = true
            PerspectiveSaturation.Saturation = 0
            imagestransparencyeffect = 0.65
            saturationvalue = -0.3
            t1p = TweenInfo.new(0.6, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)
            t2p = TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)

            local v625 = _TweenService

            perspectiveON_effect1 = _TweenService.Create(v625, ImageLabel, t1p, {ImageTransparency = imagestransparencyeffect})

            local v626 = _TweenService

            perspectiveON_effect2 = _TweenService.Create(v626, PerspectiveSaturation, t1p, {Saturation = saturationvalue})

            local v627 = _TweenService

            perspectiveOff_effect1 = _TweenService.Create(v627, ImageLabel, t2p, {ImageTransparency = 1})

            local v628 = _TweenService

            perspectiveOff_effect2 = _TweenService.Create(v628, PerspectiveSaturation, t2p, {Saturation = 0})

            function PerspectiveOnEffect()
                perspectiveON_effect1:Play()
                perspectiveON_effect2:Play()
            end
            function PerspectiveOffEffect()
                perspectiveOff_effect1:Play()
                perspectiveOff_effect2:Play()
            end

            local function u630(p629)
                if p629 and _G.PerspectiveEffectsAllow then
                    PerspectiveOnEffect()
                else
                    PerspectiveOffEffect()
                end
            end

            gui = Instance.new('ScreenGui')
            gui.ResetOnSpawn = false
            CAG = _LocalPlayer.PlayerGui:FindFirstChild('ContextActionGui')

            if _UserInputService.TouchEnabled then
                gui.Parent = _LocalPlayer.PlayerGui
            end
            if CAG then
                CAG.DescendantAdded:Connect(function(p631)
                    if _G.FutherExtend and p631:IsA('ImageButton') then
                        local _ActionIcon = p631:WaitForChild('ActionIcon')

                        if _ActionIcon.Image == 'rbxassetid://9603826756' or _ActionIcon.Image == 'rbxassetid://9603831913' then
                            _ActionIcon.Parent.Visible = false
                        end
                    end
                end)
            end

            scriptToGetSenv = nil
            senv = nil
            minDistance = 3
            pcDistance = 0
            imageButton = Instance.new('ImageButton')
            imageButton.Size = UDim2.new(0, 45, 0, 45)
            imageButton.Position = UDim2.new(1, -70, 1, -259)
            imageButton.Image = 'rbxassetid://97166444'
            imageButton.BackgroundTransparency = 1
            imageButton.ImageTransparency = 0.2
            imageButton.Visible = false
            imageButton.ImageColor3 = Color3.fromRGB(142, 142, 142)
            imageButton.Parent = gui
            imageLabel = Instance.new('ImageLabel')
            imageLabel.Size = UDim2.new(1, 0, 1, 0)
            imageLabel.Image = 'rbxassetid://9603831913'
            imageLabel.BackgroundTransparency = 1
            imageLabel.Parent = imageButton
            imageButtonDe = Instance.new('ImageButton')
            imageButtonDe.Size = UDim2.new(0, 45, 0, 45)
            imageButtonDe.Position = UDim2.new(1, -70, 1, -211)
            imageButtonDe.Image = 'rbxassetid://97166444'
            imageButtonDe.BackgroundTransparency = 1
            imageButtonDe.ImageTransparency = 0.2
            imageButtonDe.Visible = false
            imageButtonDe.ImageColor3 = Color3.fromRGB(142, 142, 142)
            imageButtonDe.Parent = gui
            imageLabelDe = Instance.new('ImageLabel')
            imageLabelDe.Size = UDim2.new(1, 0, 1, 0)
            imageLabelDe.Image = 'rbxassetid://9603826756'
            imageLabelDe.BackgroundTransparency = 1
            imageLabelDe.Parent = imageButtonDe
            IncreaseLineExtend = 0

            function buttonClicked()
                if senv and (senv.distance and _G.FutherExtend) then
                    senv.distance = (senv.distance or 0) + IncreaseLineExtend

                    if senv.distance < minDistance then
                        senv.distance = minDistance
                    end
                end
            end
            function buttonClickedDE()
                if senv and (senv.distance and _G.FutherExtend) then
                    senv.distance = (senv.distance or 0) - IncreaseLineExtend

                    if senv.distance < minDistance then
                        senv.distance = minDistance
                    end
                end
            end
            function toggleButtonState(p633)
                if p633 and _G.FutherExtend then
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

            _Workspace.ChildAdded:Connect(function(p634)
                if p634.Name == 'GrabParts' and p634:IsA('Model') then
                    if _G.FutherExtend and _UserInputService.MouseEnabled then
                        local u635 = p634

                        GetPlayerCharacter()

                        local v636 = u635

                        u635.WaitForChild(v636, 'GrabPart')

                        local v637 = u635

                        u635.WaitForChild(v637, 'DragPart')

                        local _BodyPosition6 = Instance.new('BodyPosition', u635.GrabPart)

                        _BodyPosition6.MaxForce = Vector3.new(275000, 275000, 275000)
                        _BodyPosition6.P = 20000
                        _BodyPosition6.D = 950
                        _BodyPosition6.Position = u635.GrabPart.WeldConstraint.Part1.Position
                        pcDistance = (u635.GrabPart.Position - _Workspace.CurrentCamera.CFrame.Position).Magnitude
                        u635.DragPart.AlignPosition.Enabled = false

                        task.spawn(function()
                            while u635.Parent do
                                _BodyPosition6.Position = _Workspace.Camera.CFrame.Position + _Workspace.Camera.CFrame.LookVector * pcDistance

                                task.wait()
                            end

                            pcDistance = 0

                            _BodyPosition6:Destroy()
                        end)
                    end

                    toggleButtonState(true)
                end
            end)
            workspace.ChildRemoved:Connect(function(p639)
                if p639.Name == 'GrabParts' and p639:IsA('Model') then
                    toggleButtonState(false)
                end
            end)

            local u640 = false

            local function u641()
                while u640 do
                    buttonClicked()
                    wait(0.1)
                end
            end
            local function u642()
                while u640 do
                    buttonClickedDE()
                    wait(0.1)
                end
            end

            local u643 = _UserInputService

            imageButton.InputBegan:Connect(function(p644, p645)
                if not p645 and (u643.TouchEnabled and p644.UserInputType == Enum.UserInputType.Touch) then
                    u640 = true

                    u641()
                end
            end)
            imageButton.InputEnded:Connect(function(p646)
                if u643.TouchEnabled and p646.UserInputType == Enum.UserInputType.Touch then
                    u640 = false
                end
            end)
            imageButtonDe.InputBegan:Connect(function(p647, p648)
                if not p648 and (u643.TouchEnabled and p647.UserInputType == Enum.UserInputType.Touch) then
                    u640 = true

                    u642()
                end
            end)
            imageButtonDe.InputEnded:Connect(function(p649)
                if u643.TouchEnabled and p649.UserInputType == Enum.UserInputType.Touch then
                    u640 = false
                end
            end)
            _UserInputService.InputChanged:Connect(function(p650)
                if p650.UserInputType == Enum.UserInputType.MouseWheel then
                    if pcDistance < 11 then
                        pcDistance = 11
                    end
                    if p650.Position.Z <= 0 then
                        if p650.Position.Z < 0 then
                            pcDistance = pcDistance - IncreaseLineExtend
                        end
                    else
                        pcDistance = pcDistance + IncreaseLineExtend
                    end
                end
            end)

            getgenv().Settings = {
                Fov = 150,
                Hitbox = {
                    'Head',
                    'Torso',
                    'Left Leg',
                    'Right Leg',
                },
                FovCircle = false,
            }

            local u651 = _Players
            local u652 = _LocalPlayer
            local _CurrentCamera2 = _Workspace.CurrentCamera
            local v654 = u652

            u652.GetMouse(v654)

            local u655 = nil

            local function u667(_)
                local _huge = math.huge
                local v657 = u651
                local v658, v659, v660 = pairs(v657:GetPlayers())
                local v661 = nil

                while true do
                    local v662

                    v660, v662 = v658(v659, v660)

                    if v660 == nil then
                        break
                    end
                    if v662.Name ~= u652.Name and (v662.Character and (u652 and u652.Character)) and u652.Character:FindFirstChild('HumanoidRootPart') then
                        local _HumanoidRootPart4 = v662.Character:FindFirstChild('HumanoidRootPart')

                        if _HumanoidRootPart4 then
                            local _Position2 = u652.Character.HumanoidRootPart.Position
                            local _, v665 = _CurrentCamera2:WorldToScreenPoint(_HumanoidRootPart4.Position)

                            if v665 then
                                local _magnitude = (_Position2 - _HumanoidRootPart4.Position).magnitude

                                if _magnitude < _huge then
                                    v661 = v662
                                    _huge = _magnitude
                                end
                            end
                        end
                    end
                end

                return v661
            end

            local u668 = nil
            local u669 = nil
            local u670 = nil
            local u671 = nil
            local _Circle = Drawing.new('Circle')
            local _Circle2 = Drawing.new('Circle')

            _RunService.RenderStepped:Connect(function()
                if _Circle then
                    _Circle.Radius = getgenv().Settings.Fov
                    _Circle.Thickness = 2
                    _Circle.Position = Vector2.new(_CurrentCamera2.ViewportSize.X / 2, _CurrentCamera2.ViewportSize.Y / 2 + 36)
                    _Circle.Transparency = 1
                    _Circle.Filled = false
                    _Circle.Color = Color3.fromRGB(255, 255, 255)
                    _Circle.Visible = getgenv().Settings.FovCircle
                    _Circle.ZIndex = 2
                end
                if _Circle2 then
                    _Circle2.Radius = getgenv().Settings.Fov
                    _Circle2.Thickness = 4
                    _Circle2.Position = Vector2.new(_CurrentCamera2.ViewportSize.X / 2, _CurrentCamera2.ViewportSize.Y / 2 + 36)
                    _Circle2.Transparency = 1
                    _Circle2.Filled = false
                    _Circle2.Color = Color3.new()
                    _Circle2.Visible = getgenv().Settings.FovCircle
                    _Circle2.ZIndex = 1
                end

                u668 = u667(getgenv().Settings.Fov)
            end)

            local function u677(p674, p675, p676)
                return (p675 - p674).Unit * p676
            end

            if hookmetamethod then
                local u678 = nil

                u678 = hookmetamethod(game, '__namecall', function(...)
                    local v679 = {...}
                    local v680 = v679[1]
                    local v681 = getnamecallmethod()

                    if v680 == workspace and (not checkcaller() and (v681 == 'Raycast' and (u668 and (u668.Character and (u668.Character.HumanoidRootPart and (u652.Character.HumanoidRootPart and (u668.Character.Humanoid and (u668.Character.Humanoid.Health > 0 and (not u668.InPlot.Value and _G.SilentAim))))))))) then
                        local _magnitude2 = (u652.Character.HumanoidRootPart.Position - u668.Character.HumanoidRootPart.Position).magnitude

                        u669 = math.random(1, #getgenv().Settings.Hitbox)
                        u670 = getgenv().Settings.Hitbox[u669]
                        u671 = u668.Character[u670]

                        if _magnitude2 <= u655 and u671 then
                            v679[3] = u677(v679[2], u668.Character[u670].Position, 1000)
                            v679[4] = RaycastParams.new()
                            v679[4].FilterDescendantsInstances = {
                                u668.Character,
                            }
                            v679[4].FilterType = Enum.RaycastFilterType.Include
                            u669 = nil
                            u670 = nil
                            u671 = nil
                        end
                    end

                    return u678(unpack(v679))
                end)
            end

            local function u688()
                local v683, v684, v685 = pairs(_Workspace.Slots:GetChildren())
                local v686 = nil

                while true do
                    local v687

                    v685, v687 = v683(v684, v685)

                    if v685 == nil then
                        break
                    end
                    if v687.SlotHandle.LightBall.Material ~= Enum.Material.Neon then
                        v686 = false

                        break
                    end

                    v686 = true
                end

                return v686
            end
            local function u691(p689)
                local v690

                if _LocalPlayer.Character and _LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
                    v690 = _LocalPlayer.Character.HumanoidRootPart
                else
                    v690 = nil
                end
                if p689 == 'Spin' then
                    if v690 then
                        _G.SavedPositionInSpin = v690.CFrame
                    end
                elseif p689 == 'House' and v690 then
                    _G.SavedPositionOutHouse = v690.CFrame
                end
            end
            local function u694(p692)
                local v693

                if _LocalPlayer.Character and _LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
                    v693 = _LocalPlayer.Character.HumanoidRootPart
                else
                    v693 = nil
                end
                if p692 == 'Spin' then
                    if v693 then
                        v693.CFrame = _G.SavedPositionInSpin
                    end
                elseif p692 == 'House' and v693 then
                    v693.CFrame = _G.SavedPositionOutHouse
                end
            end

            local v695 = v593:AddSection({
                Name = 'Auto Get Coins',
            })
            local v696 = v593:AddSection({
                Name = 'Auto Time-Reset',
            })
            local v697 = v593:AddSection({
                Name = 'Auto Claim-Plot',
            })

            timelefttextlabelingame = _Workspace.Slots.Slots.Screen.SlotGui.TimeLeftFrame.TimeText

            v695:AddToggle({
                Name = 'Auto-Spin',
                Default = false,
                Callback = function(p698)
                    _G.AutoFarmCoins = p698

                    if p698 then
                        while _G.AutoFarmCoins do
                            if u688() then
                                u691('Spin')

                                local u699 = nil
                                local v700 = task.spawn(function()
                                    while true do
                                        if u699 then
                                            TeleportPlayer(u699.CFrame + Vector3.new(0, 5, 0))
                                            task.wait(0.2)
                                            SNOWship(u699)
                                        end

                                        task.wait()
                                    end
                                end)
                                local v701, v702, v703 = pairs(_Workspace.Slots:GetChildren())

                                while true do
                                    local v704

                                    v703, v704 = v701(v702, v703)

                                    if v703 == nil then
                                        break
                                    end

                                    u699 = v704.SlotHandle.Handle
                                    u699.CanCollide = false

                                    local v705 = u699

                                    for _ = 1, 5 do
                                        task.wait(0.2)
                                    end

                                    v705.CanCollide = true

                                    if not u688() then
                                        break
                                    end
                                end

                                task.cancel(v700)

                                newtask = nil

                                u694('Spin')
                            end

                            task.wait(5)
                        end
                    end
                end,
                Save = true,
                Flag = 'autofarmcoins_toggle',
            })

            TimeRemainingLabel = v695:AddLabel('Time Remaining: 0:00')
            CoinsWonLabel = v695:AddLabel('Coins Won: 0')

            timelefttextlabelingame.Changed:Connect(function(p706)
                if p706 == 'Text' then
                    TimeRemainingLabel:Set('Time Remaining: ' .. timelefttextlabelingame.Text)
                end
            end)
            task.spawn(function()
                local v707, v708, v709 = pairs(_Workspace.Slots:GetDescendants())

                while true do
                    local u710

                    v709, u710 = v707(v708, v709)

                    if v709 == nil then
                        break
                    end
                    if u710.Name == 'CoinAmount' and tostring(u710.Parent) == 'CoinsFrame' then
                        u710.Changed:Connect(function(p711)
                            local _PlayerName = u710.Parent.Parent.SpinningFrame.PlayerName

                            if p711 == 'Text' and (_PlayerName.Text == _LocalPlayer.DisplayName and CoinsWonLabel) then
                                CoinsWonLabel:Set(u710.Text)
                            end
                        end)
                    end
                end

                _Workspace.Plots.DescendantAdded:Connect(function(p713)
                    if p713.Name == 'Value' and (tostring(p713.Parent) == 'ThisPlotsOwners' and p713.Value == _LocalPlayer.Name) then
                        RTime = p713:WaitForChild('TimeRemainingNum', 1)

                        if RTime then
                            RTime.Changed:Connect(function(p714)
                                TimeInHouseLabel:Set('Time: ' .. p714)
                            end)
                        end
                    end
                end)
            end)

            local function v720()
                local v715, v716, v717 = pairs(_Workspace.Plots:GetDescendants())

                while true do
                    local v718

                    v717, v718 = v715(v716, v717)

                    if v717 == nil then
                        break
                    end
                    if v718.Name == 'TimeRemainingNum' and v718.Parent.Value == _LocalPlayer.Name then
                        _G.RemainingTimeInHouse = v718

                        v718.Changed:Connect(function(p719)
                            TimeInHouseLabel:Set('Time: ' .. p719)
                        end)
                    end
                end
            end

            task.spawn(v720)

            local u721 = nil

            u721 = v696:AddToggle({
                Name = 'Preserve Time',
                Default = false,
                Callback = function(p722)
                    _G.AutoSaveHouseTime = p722

                    if p722 then
                        while _G.AutoSaveHouseTime do
                            if _LocalPlayer.InfiniteHouseTime.Value then
                                u721:Set(false)
                                u5:MakeNotification({
                                    Name = 'Stop being greedy!',
                                    Content = 'You already own infinity house gamepass!',
                                    Image = 'rbxassetid://4483345998',
                                    Time = 5,
                                })

                                break
                            end

                            local _RemainingTimeInHouse3 = _G.RemainingTimeInHouse

                            if typeof(_RemainingTimeInHouse3) == 'Instance' and (_RemainingTimeInHouse3:IsDescendantOf(_Workspace) and _RemainingTimeInHouse3:IsA('IntValue')) then
                                local _PlotArea = _G.RemainingTimeInHouse.Parent.Parent.Parent.Parent:FindFirstChild('PlotArea')

                                if _RemainingTimeInHouse3.Value < 20 then
                                    u691('House')
                                    task.wait()

                                    repeat
                                        TeleportPlayer(CFrame.new(_PlotArea.Position))
                                        task.wait(0.156)
                                    until _RemainingTimeInHouse3.Parent ~= nil or (not _G.AutoSaveHouseTime or _RemainingTimeInHouse3.Value > 15)

                                    u694('House')
                                end
                            end

                            task.wait(2)
                        end
                    end
                end,
                Save = true,
                Flag = 'autosavehousetimeremaining_toggle',
            })
            TimeInHouseLabel = v696:AddLabel('Plot Time: 0')

            local _IntValue = Instance.new('IntValue')

            PlotWorkspace = _Workspace.Plots:GetDescendants()

            function GetPlotModel(_)
                local _Plots = _Workspace.Plots
                local _PlotName = _G.PlotName

                if _PlotName == 'Witch House' then
                    _Plots = _Plots:FindFirstChild('Plot3')
                elseif _PlotName == 'Lumber House' then
                    _Plots = _Plots:FindFirstChild('Plot2')
                elseif _PlotName == 'Common House' then
                    _Plots = _Plots:FindFirstChild('Plot1')
                elseif _PlotName == 'American House' then
                    _Plots = _Plots:FindFirstChild('Plot4')
                elseif _PlotName == 'Chinese House' then
                    _Plots = _Plots:FindFirstChild('Plot5')
                end

                return _Plots
            end
            function ClaimPlot()
                local v728 = not IsThereOwnerOnPlot() and GetPlotModel(_G.PlotName)

                if v728 then
                    local _PlotSign = v728.PlotSign

                    local function v735()
                        local v730, v731, v732 = pairs(_PlotSign.ThisPlotsOwners:GetChildren())
                        local v733 = false

                        while true do
                            local v734

                            v732, v734 = v730(v731, v732)

                            if v732 == nil then
                                break
                            end
                            if v734.Value == _LocalPlayer.Name then
                                v733 = true
                            end
                        end

                        return v733
                    end

                    local v736 = _PlotSign
                    local v737, v738, v739 = pairs(_PlotSign.GetChildren(v736))

                    while true do
                        local v740

                        v739, v740 = v737(v738, v739)

                        if v739 == nil or v735() then
                            break
                        end
                        if v740.Name == 'Sign' then
                            local _PlusGrabPart = v740.Plus.PlusGrabPart

                            TeleportPlayer(_PlusGrabPart.CFrame * CFrame.new(-5, 0, -5))

                            for _ = 0, 15 do
                                SNOWship(_PlusGrabPart)
                                wait()
                            end
                        end
                    end
                end
            end
            function UpdatePlotOwner()
                local v742 = PlotWorkspace
                local v743, v744, v745 = pairs(v742)

                while true do
                    local v746

                    v745, v746 = v743(v744, v745)

                    if v745 == nil then
                        break
                    end
                    if v746.Name == 'PlayerRole' then
                        local _PlayerDisplayName = v746.Parent.PlayerDisplayName
                        local u748 = v746
                        local _Parent6 = v746.Parent
                        local u750 = nil
                        local u751 = false

                        local function u757()
                            u751 = false
                            u750 = GetPlotModel(_G.PlotName)

                            if u750 and (u748:IsDescendantOf(u750) and (u748.Text == 'Owner' and _Parent6.Visible)) then
                                wait()

                                local v752 = _Players
                                local v753, v754, v755 = pairs(v752:GetPlayers())

                                while true do
                                    local v756

                                    v755, v756 = v753(v754, v755)

                                    if v755 == nil then
                                        break
                                    end
                                    if v756.DisplayName == _PlayerDisplayName.Text then
                                        u751 = true
                                    end
                                end

                                if PlotOwner and u751 then
                                    PlotOwner:Set('Plot Owner: ' .. _PlayerDisplayName.Text)
                                else
                                    PlotOwner:Set('Plot Available!')
                                end
                            end
                        end

                        u748.Changed:Connect(function(p758)
                            if p758 == 'Text' then
                                u757()
                            end
                        end)
                        _IntValue.Changed:Connect(function(_)
                            u757()
                        end)
                        u757()
                    end
                end
            end
            function IsThereOwnerOnPlot()
                local v759 = GetPlotModel()

                if v759 and v759.PlotSign.ThisPlotsOwners:FindFirstChild('Value') then
                    return true
                end
            end
            function UpdatePeopleInPlot()
                local v760 = PlotWorkspace
                local v761, v762, v763 = pairs(v760)

                while true do
                    local u764

                    v763, u764 = v761(v762, v763)

                    if v763 == nil then
                        break
                    end
                    if u764.Name == 'ThisPlotsOwners' then
                        local function u769()
                            local v765 = u764
                            local v766 = GetPlotModel(_G.PlotName)
                            local v767 = v765:GetChildren()

                            if v766 and u764:IsDescendantOf(v766) then
                                local v768 = table.getn(v767)

                                if PlayersInPlot then
                                    PlayersInPlot:Set('Players in Plot: ' .. v768)
                                end
                                if v768 == 0 and PlotOwner then
                                    PlotOwner:Set('Plot Available!')
                                end
                            end
                        end

                        _IntValue.Changed:Connect(function(_)
                            u769()
                        end)
                        u764.ChildAdded:Connect(u769)
                        u764.ChildRemoved:Connect(u769)
                        u769()
                    end
                end
            end

            v697:AddDropdown({
                Name = 'Plot',
                Default = 'Witch House',
                Options = {
                    'Witch House',
                    'Lumber House',
                    'Common House',
                    'American House',
                    'Chinese House',
                },
                Callback = function(p770)
                    _G.PlotName = p770
                    _IntValue.Value = _IntValue.Value + 1
                end,
            })
            task.spawn(function()
                UpdatePlotOwner()
                task.wait()
                UpdatePeopleInPlot()
            end)

            PlotOwner = v697:AddLabel('Plot Owner:')
            PlayersInPlot = v697:AddLabel('Players in Plot: 0')

            v697:AddButton({
                Name = 'Claim Plot!',
                Callback = function()
                    ClaimPlot()
                end,
            })

            function ExplodeSb(p771)
                local v772 = {
                    {
                        Radius = 17.5,
                        TimeLength = 0.1,
                        Hitbox = p771:FindFirstChild('SoundPart'),
                        ExplodesByFire = true,
                        MaxForcePerStudSquared = -100,
                        DestroysModel = true,
                        Model = p771,
                        ExplodesByPointy = false,
                        ImpactSpeed = 100,
                        PositionPart = _LocalPlayer.Character.HumanoidRootPart,
                    },
                    _LocalPlayer.Character.HumanoidRootPart.Position,
                }

                BombEvents.BombExplode:FireServer(unpack(v772))
            end

            getgenv().MaxSize = 15

            local u773 = {}
            local u774 = 0
            local u775 = nil

            snowballEffectConnection = nil
            snowballMaxAmmount = 20

            if _ToysLimitCap.Value == 200 then
                snowballMaxAmmount = 40
            end

            function checkSize(p776)
                while _G.SnowbalEffectSpam do
                    if p776 and (p776:IsDescendantOf(_Workspace) and p776:FindFirstChild('SoundPart')) then
                        local _SoundPart3 = p776:FindFirstChild('SoundPart')
                        local _Size = _SoundPart3.Size

                        if _Size.X >= MaxSize and (_Size.Y >= MaxSize and (_Size.Z >= MaxSize and not u773[_SoundPart3])) then
                            u773[_SoundPart3] = true

                            break
                        end
                    end

                    task.wait()
                end
            end
            function checkSnowBall(p779)
                if p779 and p779:FindFirstChild('SoundPart') then
                    local _SoundPart4 = p779.SoundPart
                    local v781 = RaycastParams.new()

                    v781.FilterDescendantsInstances = {p779}
                    v781.FilterType = Enum.RaycastFilterType.Exclude

                    local v782 = _Workspace:Raycast(_SoundPart4.Position, Vector3.new(0, -100, 0), v781)

                    if v782 and v782.Material == Enum.Material.Sand then
                        return true
                    end
                end
            end

            lastpossb = nil

            function holdOwnership()
                if not _G.SnowbalEffectSpam then
                    return
                end

                local v783 = u19
                local v784, v785, v786 = pairs(v783:GetChildren())

                if v788 and (v788.Name == 'BallSnowball' and v788:FindFirstChild('SoundPart')) then
                    local _SoundPart5 = v788:FindFirstChild('SoundPart')

                    if not CheckNetworkOwnerShipOnPart(_SoundPart5) then
                        if not lastpossb then
                            lastpossb = GetPlayerCFrame()
                        end

                        for _ = 1, 10 do
                            if SNOWshipOnce(_SoundPart5) then
                                _SoundPart5.CanTouch = false
                                _SoundPart5.CanCollide = false

                                break
                            end

                            TeleportPlayer(CFrame.new(_SoundPart5.Position + Vector3.new(0, -10, 0)))
                            task.wait(0.1)
                        end

                        TeleportPlayer(lastpossb)

                        lastpossb = nil
                    end
                end

                local v788

                v786, v788 = v784(v785, v786)

                if v786 ~= nil and _G.SnowbalEffectSpam then
                else
                end

                task.wait()
            end
            function CountGrownSnowsballs()
                local v789, v790, v791 = pairs(u773)
                local v792 = 0

                while true do
                    local v793

                    v791, v793 = v789(v790, v791)

                    if v791 == nil then
                        break
                    end
                    if v791:IsDescendantOf(_Workspace) then
                        v792 = v792 + 1
                    else
                        u773[v791] = nil
                    end
                end

                u775:Set('Grown Snowballs: ' .. v792)

                return v792
            end
            function modify(p794)
                local v795 = CFrame.new(-410, 228.394, 510, -0.246182978, 3.22764193e-9, -0.96922338, 1.2914926e-8, 1, 4.97377278e-11, 0.96922338, -1.2505204e-8, -0.246182978)

                while _G.SnowbalEffectSpam and p794 do
                    if p794:FindFirstChild('SoundPart') then
                        local _SoundPart6 = p794.SoundPart
                        local _FarmSnowball = _SoundPart6:FindFirstChild('FarmSnowball')

                        if CheckNetworkOwnerShipOnPart(_SoundPart6) then
                            if _FarmSnowball then
                                if u773[_SoundPart6] then
                                    _FarmSnowball.Position = Vector3.new(math.random(-10000, 10000), 10000, math.random(-10000, 10000))
                                else
                                    _FarmSnowball.Position = v795.Position + Vector3.new(25, 0, 0) + Vector3.new(0, _SoundPart6.Size.X / 2 - 0.65, 0)

                                    wait(0.5)

                                    _FarmSnowball.Position = v795.Position + Vector3.new(-25, 0, 0) + Vector3.new(0, _SoundPart6.Size.X / 2 - 0.65, 0)

                                    wait(0.5)

                                    _FarmSnowball.Position = v795.Position + Vector3.new(0, _SoundPart6.Size.X / 2 - 0.65, 0)
                                end
                            else
                                local _BodyPosition7 = Instance.new('BodyPosition', _SoundPart6)

                                _BodyPosition7.MaxForce = Vector3.new(12500, 12500, 12500)
                                _BodyPosition7.Name = 'FarmSnowball'
                                _BodyPosition7.Position = _SoundPart6.Position
                            end
                        end
                    end

                    wait()
                end
            end
            function newSnowball(p799)
                if p799.Name == 'BallSnowball' and _G.SnowbalEffectSpam then
                    task.spawn(function()
                        checkSize(p799)
                    end)
                    task.spawn(function()
                        modify(p799)
                    end)
                end
            end

            task.spawn(function()
                while task.wait() do
                    CountGrownSnowsballs()
                end
            end)

            local v800 = v587:AddSection({
                Name = 'Snowball',
            })

            v800:AddSlider({
                Name = 'Ammount',
                Min = 5,
                Max = snowballMaxAmmount,
                Default = 5,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 1,
                ValueName = 'Snowballs you want to make to explode them!',
                Callback = function(p801)
                    u774 = p801
                end,
                Save = true,
                Flag = 'ammountsnowballtomake_slider',
            })

            automakesnowballtoggle = nil
            automakesnowballtoggle = v800:AddToggle({
                Name = 'Auto Make Snowball',
                Default = false,
                Callback = function(p802)
                    _G.SnowbalEffectSpam = p802

                    if p802 then
                        snowballEffectConnection = u19.ChildAdded:Connect(newSnowball)

                        task.spawn(function()
                            while _G.SnowbalEffectSpam do
                                if u774 > countToys('BallSnowball') then
                                    SpawnToy({
                                        'BallSnowball',
                                        CFrame.new(-389, 228, 550, -0.3092496991157532, 0.2610282301902771, -0.9144555330276489, 0, 0.9615919589996338, 0.2744831442832947, 0.9509809017181396, 0.08488383144140244, -0.2973720133304596),
                                        Vector3.new(0, 97.69000244140625, 0),
                                    })
                                    task.wait(0.1)
                                end
                                if u774 <= CountGrownSnowsballs() then
                                    automakesnowballtoggle:Set(false)
                                end

                                task.wait()
                            end
                        end)
                        task.spawn(function()
                            holdOwnership()
                        end)

                        local v803 = u19
                        local v804, v805, v806 = ipairs(v803:GetChildren())

                        while true do
                            local v807

                            v806, v807 = v804(v805, v806)

                            if v806 == nil then
                                break
                            end

                            newSnowball(v807)
                        end
                    elseif snowballEffectConnection then
                        snowballEffectConnection:Disconnect()
                    end
                end,
                Save = true,
                Flag = 'autofarmsnowball_toggle',
            })

            local _ = v800:AddLabel('Grown Snowballs:')

            v800:AddButton({
                Name = 'Explode Snowballs',
                Callback = function()
                    local v808, v809, v810 = pairs(u773)

                    while true do
                        local v811

                        v810, v811 = v808(v809, v810)

                        if v810 == nil then
                            break
                        end
                        if v810:IsDescendantOf(_Workspace) then
                            ExplodeSb(v810.Parent)
                        end
                    end
                end,
            })

            spamexplosiontype = nil
            spamexplosiontarget = 0
            bombsammountoexplode = 1
            reachedrightammount = false
            explosionInterval = nil
            canExplode = false
            maxBombstoexplode = 8

            if _ToysLimitCap.Value == 200 then
                maxBombstoexplode = 18
            end

            _ContextActionService:BindAction('FireBomb', fireBombs, false, Enum.KeyCode.F)

            function ExplodeFw()
                local v812 = u19
                local v813, v814, v815 = pairs(v812:GetChildren())

                while true do
                    local v816

                    v815, v816 = v813(v814, v815)

                    if v815 == nil then
                        break
                    end
                    if v816.Name == spamexplosiontype then
                        local v817 = {
                            {
                                Radius = 17.5,
                                TimeLength = 0.5,
                                Hitbox = v816:FindFirstChild('PartHitDetector'),
                                ExplodesByFire = true,
                                MaxForcePerStudSquared = 225,
                                DestroysModel = true,
                                Model = v816,
                                ExplodesByPointy = false,
                                ImpactSpeed = 20,
                                PositionPart = workspace.SpawnLocation,
                            },
                            Vector3.new(0, -10, 0),
                        }

                        if spamexplosiontype ~= 'BombBalloon' then
                            if spamexplosiontype == 'PresentBig' or spamexplosiontype == 'PresentSmall' then
                                v817[1].Hitbox = v816.Box
                            end
                        else
                            v817[1].Hitbox = v816.Balloon
                        end
                        if spamexplosiontarget ~= 0 then
                            if spamexplosiontarget ~= 1 then
                                local v818 = spamexplosiontarget == 2 and GetFakeAim2()

                                if v818 then
                                    v817[1].PositionPart = v818
                                    v817[2] = v818.Position
                                end
                            else
                                local v819

                                if _G.TargetToBombPlayer then
                                    v819 = _Players:FindFirstChild(_G.TargetToBombPlayer)
                                else
                                    v819 = nil
                                end
                                if v819 and (not IsPlayerInsideSafeZone(v819) and v819.Character) and v819.Character:FindFirstChild('HumanoidRootPart') then
                                    local _HumanoidRootPart5 = v819.Character.HumanoidRootPart

                                    v817[1].PositionPart = _HumanoidRootPart5
                                    v817[2] = _HumanoidRootPart5.Position
                                end
                            end
                        else
                            v817[1].PositionPart = workspace.SpawnLocation
                            v817[2] = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
                        end

                        BombEvents.BombExplode:FireServer(unpack(v817))
                    end
                    if explosionInterval > 0 then
                        task.wait(explosionInterval)
                    end
                end
            end

            firework_section = v587:AddSection({
                Name = 'Explosions Spam',
            })
            explosionexplanation = v587:AddSection({
                Name = 'FAQ about (Explosions Spam)',
            })

            firework_section:AddToggle({
                Name = 'Explode',
                Default = false,
                Callback = function(p821)
                    _G.FireworkEffectSpam = p821

                    if p821 then
                        task.spawn(function()
                            while _G.FireworkEffectSpam do
                                local v822 = GetPlayerCFrame()

                                if countToys(spamexplosiontype) < bombsammountoexplode and (not reachedrightammount and (spamexplosiontarget ~= 2 or GetFakeAim())) and v822 then
                                    SpawnToy({
                                        spamexplosiontype,
                                        CFrame.new(v822.Position.X, v822.Position.Y, v822.Position.Z, -0.3092496991157532, 0.2610282301902771, -0.9144555330276489, 0, 0.9615919589996338, 0.2744831442832947, 0.9509809017181396, 0.08488383144140244, -0.2973720133304596),
                                        Vector3.new(0, 97.69000244140625, 0),
                                    })
                                end

                                task.wait()
                            end
                        end)
                        task.spawn(function()
                            while _G.FireworkEffectSpam do
                                local v823 = u19
                                local v824, v825, v826 = pairs(v823:GetChildren())

                                while true do
                                    local v827

                                    v826, v827 = v824(v825, v826)

                                    if v826 == nil then
                                        break
                                    end
                                    if v827.Name == spamexplosiontype then
                                        local v828 = nil

                                        if spamexplosiontype ~= 'BombDarkMatter' then
                                            if spamexplosiontype ~= 'BombMissile' then
                                                if spamexplosiontype ~= 'BombBalloon' then
                                                    if spamexplosiontype ~= 'FireworkMissile' then
                                                        if spamexplosiontype == 'PresentBig' or spamexplosiontype == 'PresentSmall' then
                                                            v828 = v827:FindFirstChild('Box')
                                                        end
                                                    else
                                                        v828 = v827:FindFirstChild('Hitbox')
                                                    end
                                                else
                                                    v828 = v827:FindFirstChild('Balloon')
                                                end
                                            else
                                                v828 = v827:FindFirstChild('Body')
                                            end
                                        else
                                            v828 = v827:FindFirstChild('Pyramid')
                                        end
                                        if v828 and not SNOWshipOnce(v828) and _LocalPlayer:DistanceFromCharacter(v828.Position) > 30 then
                                            DeleteToyRE:FireServer(v827)
                                            print('Deletado!')
                                        elseif v828 and (CheckNetworkOwnerShipOnPart(v828) and not v827:GetAttribute('MissileTeleported')) then
                                            wait()

                                            if v827.PrimaryPart then
                                                Instance.new('BodyVelocity', v827.PrimaryPart).Velocity = Vector3.new(10000, 10000, 10000)

                                                v827:SetPrimaryPartCFrame(CFrame.new(math.random(-1000, 1000), 10000, math.random(-1000, 1000)))
                                                v827:SetAttribute('MissileTeleported', true)
                                            end

                                            print('ownershipped!')
                                        end
                                    end
                                end

                                task.wait(0.1)
                            end
                        end)
                        task.spawn(function()
                            while _G.FireworkEffectSpam do
                                if countToys(spamexplosiontype) < bombsammountoexplode then
                                    _G.CanExplodeBombs = false
                                else
                                    if spamexplosiontarget ~= 2 or not _G.FireBomb then
                                        if spamexplosiontarget ~= 2 then
                                            canExplode = true
                                        end
                                    else
                                        canExplode = true
                                    end

                                    _G.CanExplodeBombs = true

                                    if canExplode then
                                        ExplodeFw()

                                        reachedrightammount = false
                                        canExplode = false
                                    end
                                end

                                task.wait()
                            end
                        end)
                        task.spawn(function()
                            while _G.FireworkEffectSpam do
                                if spamexplosiontarget == 2 then
                                    GetFakeAim2()
                                end

                                wait(0.1)
                            end
                        end)
                    end
                end,
            })
            firework_section:AddDropdown({
                Name = 'Explosion Type',
                Default = 'Firework',
                Options = {
                    'Firework',
                    'Missile',
                    'Void',
                    'Ballon',
                    'Small Present',
                    'Big Present',
                },
                Callback = function(p829)
                    if p829 == 'Firework' then
                        spamexplosiontype = 'FireworkMissile'
                    elseif p829 == 'Missile' then
                        spamexplosiontype = 'BombMissile'
                    elseif p829 == 'Void' then
                        spamexplosiontype = 'BombDarkMatter'
                    elseif p829 == 'Ballon' then
                        spamexplosiontype = 'BombBalloon'
                    elseif p829 == 'Small Present' then
                        spamexplosiontype = 'PresentSmall'
                    elseif p829 == 'Big Present' then
                        spamexplosiontype = 'PresentBig'
                    end
                end,
            })
            firework_section:AddSlider({
                Name = 'Ammount to Explode',
                Min = 1,
                Max = maxBombstoexplode,
                Default = 1,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 1,
                ValueName = 'to explode the player brutally',
                Callback = function(p830)
                    bombsammountoexplode = p830
                end,
            })
            firework_section:AddSlider({
                Name = 'Delay',
                Min = 0,
                Max = 1,
                Default = 0,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 0.1,
                ValueName = 'interval between every explosion',
                Callback = function(p831)
                    explosionInterval = p831
                end,
            })
            firework_section:AddDropdown({
                Name = 'Target',
                Default = 'Spawn',
                Options = {
                    'Spawn',
                    'Player',
                    'Mouse',
                },
                Callback = function(p832)
                    if p832 == 'Spawn' then
                        spamexplosiontarget = 0
                    elseif p832 == 'Player' then
                        spamexplosiontarget = 1
                    elseif p832 == 'Mouse' then
                        spamexplosiontarget = 2
                    end
                end,
            })

            PlayerToTarget = firework_section:AddDropdown({
                Name = 'Select Player',
                Default = 'Macaco (negro)',
                Options = {
                    '',
                },
                Callback = function(p833)
                    local v834 = string.split(p833, ' ')

                    _G.TargetToBombPlayer = v834[1]
                end,
            })

            explosionexplanation:AddParagraph('How to use target mouse?', 'Press/Hold the keybind (F) and then BOOM!')
            explosionexplanation:AddParagraph('How to target player?', 'Select Target to Player and then select the player you want to target')
            explosionexplanation:AddParagraph('How to change the explosive', 'Click on Explosive Type and select any type')
            _LocalPlayer.Idled:connect(function()
                _VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                wait(1)
                _VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)

            local v835 = v594:AddSection({
                Name = 'Silent-Aim',
            })

            v835:AddToggle({
                Name = 'Silent Aim',
                Default = false,
                Callback = function(p836)
                    _G.SilentAim = p836
                end,
                Save = true,
                Flag = 'SilentAim_toggle',
            })
            v835:AddSlider({
                Name = 'Silent-Aim Range',
                Min = 0,
                Max = 50,
                Default = 50,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 1,
                ValueName = '',
                Callback = function(p837)
                    u655 = p837
                end,
                Save = true,
                Flag = 'silentaimrange_slider',
            })

            local v838 = v589:AddSection({
                Name = 'Line Extender',
            })

            v838:AddToggle({
                Name = 'Further Extend',
                Default = false,
                Callback = function(p839)
                    _G.FutherExtend = p839
                end,
                Save = true,
                Flag = 'FurtherLineExtend_toggle',
            })

            MaxExtendLine = 0
            MinExtendLine = 0

            if _UserInputService.TouchEnabled then
                MinExtendLine = 3
                MaxExtendLine = 25
            elseif _UserInputService.MouseEnabled then
                MinExtendLine = 3
                MaxExtendLine = 25
            end

            v838:AddSlider({
                Name = 'Increase Extend',
                Min = MinExtendLine,
                Max = MaxExtendLine,
                Default = 3,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 1,
                ValueName = 'Ammount',
                Callback = function(p840)
                    IncreaseLineExtend = p840
                end,
                Save = true,
                Flag = 'FurtherLineExtend_slider',
            })

            local v841 = v590:AddSection({
                Name = 'Normal Auras',
            })
            local v842 = v590:AddSection({
                Name = 'Fling Aura',
            })
            local v843 = v590:AddSection({
                Name = 'Anchor Aura',
            })
            local v844 = v590:AddSection({
                Name = 'Kick Aura',
            })
            local v845 = v590:AddSection({
                Name = 'Auras Whitelist',
            })

            local function u848()
                local _Character5 = _LocalPlayer.Character
                local v847

                if _Character5 then
                    v847 = _Character5:FindFirstChildOfClass('Humanoid')
                else
                    v847 = nil
                end
                if not _Character5 or (not v847 or (not v847.Sit or (v847.SeatPart == nil or tostring(v847.SeatPart.Parent) ~= 'CreatureBlobman'))) then
                    return false
                end

                _G.LastBlobmanWasSeat = v847.SeatPart.Parent

                return true
            end
            local function u855(p849)
                local v850 = false

                _Players:FindFirstChild(p849)

                if u848() and _G.LoopKick then
                    local v851, v852, v853 = pairs(u66)

                    while true do
                        local v854

                        v853, v854 = v851(v852, v853)

                        if v853 == nil then
                            break
                        end
                        if p849 == v854 then
                            v850 = true
                        end
                    end
                end

                return v850
            end
            local function u857(p856)
                if typeof(p856) == 'Instance' and (p856 ~= _LocalPlayer and (not u55(p856) and p856.Character)) and (p856.Character:IsDescendantOf(_Workspace) and (p856.Character:FindFirstChild('HumanoidRootPart') and (p856.Character:FindFirstChildOfClass('Humanoid') and p856.Character.Humanoid.Health > 0))) then
                    return true
                end
            end
            local function u859(p858)
                if u857(p858) and not IsPlayerInsideSafeZone(p858) then
                    return true
                end
            end
            local function u861(p860)
                if u857(p860) and not (u101(p860.Name) and _G.WhitelistFriends) and not u855(p860.Name) and not (p860.Character:GetAttribute('Kicking') or _G.KickAura) then
                    return true
                end
            end
            local function u863(p862)
                if u857(p862) and not (u101(p862.Name) and _G.WhitelistFriends) and not u855(p862.Name) and not p862.Character:GetAttribute('Kicking') then
                    return true
                end
            end
            local function u865(p864)
                if u857(p864) and not (u101(p864.Name) and _G.WhitelistFriends3) and not u855(p864.Name) and not p864.Character:GetAttribute('Kicking') then
                    return true
                end
            end
            local function u867(p866)
                if u857(p866) and not (u101(p866.Name) and _G.WhitelistFriends3) and not IsPlayerInsideSafeZone(p866) then
                    return true
                end
            end
            local function u869(p868)
                if u857(p868) and not (u101(p868.Name) and _G.WhitelistFriends3) and not (IsPlayerInsideSafeZone(p868) or IsPlayerFloating(p868)) then
                    return true
                end
            end

            function CreateSkyVelocity(p870)
                if not p870:FindFirstChild('SkyVelocity') then
                    local _BodyVelocity3 = Instance.new('BodyVelocity', p870)

                    _BodyVelocity3.Name = 'SkyVelocity'
                    _BodyVelocity3.Velocity = Vector3.new(0, 100000000000000, 0)
                    _BodyVelocity3.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                end
            end

            local _OuterUFO = _Workspace.Map.AlwaysHereTweenedObjects:FindFirstChild('OuterUFO')

            if _OuterUFO and _OuterUFO:FindFirstChild('Object') and _OuterUFO.Object:FindFirstChild('ObjectModel') then
                _OuterUFO = _OuterUFO.Object.ObjectModel.PaintPlayerPart
                _OuterUFO:WaitForChild('WeldConstraint').Enabled = false
                _OuterUFO.Anchored = true
                _OuterUFO.Shape = Enum.PartType.Block
                _OuterUFO.Transparency = 1
                _OuterUFO.Size = Vector3.new(0.5, 0.5, 0.5)
                _OuterUFO.Position = Vector3.new(0, -50, 0)
            end

            v841:AddToggle({
                Name = 'Poison Aura',
                Default = false,
                Callback = function(p873)
                    _G.Poison_Aura = p873

                    if p873 then
                        while _G.Poison_Aura do
                            local v874 = _Players
                            local v875, v876, v877 = pairs(v874:GetPlayers())

                            while true do
                                local v878

                                v877, v878 = v875(v876, v877)

                                if v877 == nil then
                                    break
                                end
                                if u861(v878) then
                                    local _Head3 = v878.Character:FindFirstChild('Head')

                                    if _Head3 and SNOWshipPlayer(v878) then
                                        _PoisonHurtPart.CFrame = _Head3.CFrame
                                        _PoisonHurtPart2.CFrame = _Head3.CFrame
                                        _PoisonHurtPart3.CFrame = _Head3.CFrame

                                        task.wait()

                                        _PoisonHurtPart3.Position = Vector3.new(0, -50, 0)
                                        _PoisonHurtPart2.Position = Vector3.new(0, -50, 0)
                                        _PoisonHurtPart.Position = Vector3.new(0, -50, 0)
                                    end
                                end
                            end

                            task.wait()
                        end
                    end
                end,
                Save = true,
                Flag = 'poisonaura_toggle',
            })
            v841:AddToggle({
                Name = 'Death Aura',
                Default = false,
                Callback = function(p880)
                    _G.DeathAura = p880

                    if p880 then
                        while _G.DeathAura do
                            local v881 = _Players
                            local v882, v883, v884 = pairs(v881:GetPlayers())

                            while true do
                                local v885

                                v884, v885 = v882(v883, v884)

                                if v884 == nil then
                                    break
                                end
                                if u861(v885) then
                                    local _Character6 = v885.Character
                                    local _HumanoidRootPart6 = _Character6:FindFirstChild('HumanoidRootPart')
                                    local _Humanoid5 = _Character6:FindFirstChildOfClass('Humanoid')

                                    if _HumanoidRootPart6 and (_Humanoid5 and SNOWshipPlayer(v885)) then
                                        _DestroyGrabLine:FireServer(_HumanoidRootPart6)
                                        CreateSkyVelocity(_HumanoidRootPart6)

                                        _Humanoid5.BreakJointsOnDeath = false

                                        _Humanoid5:ChangeState(Enum.HumanoidStateType.Dead)

                                        _Humanoid5.Jump = true
                                        _Humanoid5.Sit = false

                                        if _Humanoid5:GetStateEnabled(Enum.HumanoidStateType.Dead) then
                                            _DestroyGrabLine:FireServer(_HumanoidRootPart6)
                                        end
                                    end
                                end
                            end

                            task.wait()
                        end
                    end
                end,
                Save = true,
                Flag = 'deathaura_toggle',
            })

            if _OuterUFO then
                v841:AddToggle({
                    Name = 'Radioactive Aura',
                    Default = false,
                    Callback = function(p889)
                        _G.RadioactiveAura = p889

                        if p889 then
                            while _G.RadioactiveAura do
                                local v890 = _Players
                                local v891, v892, v893 = pairs(v890:GetPlayers())

                                while true do
                                    local v894

                                    v893, v894 = v891(v892, v893)

                                    if v893 == nil then
                                        break
                                    end
                                    if u861(v894) then
                                        local _HumanoidRootPart7 = v894.Character:FindFirstChild('HumanoidRootPart')

                                        if _HumanoidRootPart7 and SNOWshipPlayer(v894) then
                                            _OuterUFO.Position = _HumanoidRootPart7.Position

                                            task.wait()

                                            _OuterUFO.Position = Vector3.new(0, -50, 0)
                                        end
                                    end
                                end

                                task.wait()
                            end
                        end
                    end,
                    Save = true,
                    Flag = 'radioaura_toggle',
                })
            end

            v841:AddToggle({
                Name = 'Burn Aura',
                Default = false,
                Callback = function(p896)
                    _G.BurnAura = p896

                    if p896 then
                        while _G.BurnAura do
                            local v897 = _Players
                            local v898, v899, v900 = pairs(v897:GetPlayers())

                            while true do
                                local v901

                                v900, v901 = v898(v899, v900)

                                if v900 == nil then
                                    break
                                end
                                if u861(v901) then
                                    local _HumanoidRootPart8 = v901.Character:FindFirstChild('HumanoidRootPart')

                                    if _HumanoidRootPart8 and _LocalPlayer:DistanceFromCharacter(_HumanoidRootPart8.Position) < 30 then
                                        u550(_HumanoidRootPart8)
                                    end
                                end
                            end

                            task.wait()
                        end
                    end
                end,
                Save = true,
                Flag = 'burnaura_toggle',
            })
            v842:AddToggle({
                Name = 'Fling Aura',
                Default = false,
                Callback = function(p903)
                    _G.FlingAura = p903

                    if p903 then
                        while _G.FlingAura do
                            if _G.FlingTarget == 2 or _G.FlingTarget == 3 then
                                local v904, v905 = CheckObjectsAroundPlayer()

                                if v904 then
                                    local v906, v907, v908 = pairs(v904)

                                    while true do
                                        local v909

                                        v908, v909 = v906(v907, v908)

                                        if v908 == nil then
                                            break
                                        end

                                        local v910 = 0

                                        if v909 then
                                            local _Head4 = v909:FindFirstChild('Head')
                                            local v912, v913, v914 = pairs(v909:GetChildren())

                                            while true do
                                                local v915

                                                v914, v915 = v912(v913, v914)

                                                if v914 == nil then
                                                    break
                                                end
                                                if v915:IsA('BasePart') and v915.CanQuery then
                                                    local v916 = SNOWshipOnce(v915)
                                                    local v917 = GetPlayerRoot()

                                                    if not v916 and _Head4 then
                                                        v916 = CheckNetworkOwnerShipOnPart(_Head4)
                                                    end
                                                    if v916 and v917 then
                                                        if v905 then
                                                            local _Position3 = v905.Position

                                                            v905.Position = v915.Position

                                                            task.wait()

                                                            v905.Position = _Position3
                                                        elseif not v915:FindFirstChild('FlingAuraVelocity') then
                                                            local v919 = lookAt(v917.Position, v915.Position)
                                                            local _BodyVelocity4 = Instance.new('BodyVelocity', v915)

                                                            _BodyVelocity4.Name = 'FlingAuraVelocity'
                                                            _BodyVelocity4.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                                            _BodyVelocity4.Velocity = Vector3.new(v919.lookVector.X, 0.5, v919.lookVector.Z) * math.clamp(_G.FlingStrength, 400, 600)

                                                            _Debris:AddItem(_BodyVelocity4)
                                                        end

                                                        v910 = v910 + 1
                                                    end
                                                    if v910 >= 3 then
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            if _G.FlingTarget == 1 or _G.FlingTarget == 3 then
                                local v921 = _Players
                                local v922, v923, v924 = pairs(v921:GetPlayers())

                                while true do
                                    local v925

                                    v924, v925 = v922(v923, v924)

                                    if v924 == nil then
                                        break
                                    end
                                    if u861(v925) then
                                        local _HumanoidRootPart9 = v925.Character:FindFirstChild('HumanoidRootPart')
                                        local v927 = SNOWshipPlayer(v925)
                                        local v928 = GetPlayerCharacter()

                                        if _HumanoidRootPart9 and (v927 and (v928 and not _HumanoidRootPart9:FindFirstChild('FlingAuraVelocity'))) then
                                            local v929 = lookAt(v928.HumanoidRootPart.Position, _HumanoidRootPart9.Position)
                                            local _BodyVelocity5 = Instance.new('BodyVelocity', _HumanoidRootPart9)

                                            _BodyVelocity5.Name = 'FlingAuraVelocity'
                                            _BodyVelocity5.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                            _BodyVelocity5.Velocity = Vector3.new(v929.lookVector.X, 0.5, v929.lookVector.Z) * _G.FlingStrength

                                            _Debris:AddItem(_BodyVelocity5)
                                        end
                                    end
                                end
                            end

                            task.wait(0.1)
                        end
                    end
                end,
                Save = true,
                Flag = 'flingaura_toggle',
            })
            v842:AddSlider({
                Name = 'Strength',
                Min = 400,
                Max = 10000,
                Default = 400,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 100,
                ValueName = '',
                Callback = function(p931)
                    _G.FlingStrength = p931
                end,
                Save = true,
                Flag = 'flingstrengthvalue_toggle',
            })
            v842:AddDropdown({
                Name = 'Target',
                Default = 'Players',
                Options = {
                    'Players',
                    'Objects',
                    'Players and Objects',
                },
                Callback = function(p932)
                    if p932 == 'Players' then
                        _G.FlingTarget = 1
                    elseif p932 == 'Objects' then
                        _G.FlingTarget = 2
                    elseif p932 == 'Players and Objects' then
                        _G.FlingTarget = 3
                    end
                end,
                Save = true,
                Flag = 'flingtarget_dropdown',
            })
            v843:AddToggle({
                Name = 'Anchor Aura',
                Default = false,
                Callback = function(p933)
                    _G.AnchorAura = p933

                    if p933 then
                        while _G.AnchorAura do
                            if _G.AnchorTarget == 2 or _G.AnchorTarget == 3 then
                                local v934, _ = CheckObjectsAroundPlayer()

                                if v934 then
                                    local v935, v936, v937 = pairs(v934)

                                    while true do
                                        local v938

                                        v937, v938 = v935(v936, v937)

                                        if v937 == nil then
                                            break
                                        end

                                        local v939 = 0

                                        if v938 and not v938:GetAttribute('IsAnchored') then
                                            local v940, v941, v942 = pairs(v938:GetChildren())

                                            while true do
                                                local v943

                                                v942, v943 = v940(v941, v942)

                                                if v942 == nil then
                                                    break
                                                end
                                                if v943:IsA('BasePart') and v943.CanQuery then
                                                    if SNOWshipOnce(v943) or CheckNetworkOwnerShipOnPart(head) then
                                                        setanchorObject(v943)

                                                        v939 = v939 + 1
                                                    end
                                                    if v939 >= 3 then
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            if _G.AnchorTarget == 1 or _G.AnchorTarget == 3 then
                                local v944 = _Players
                                local v945, v946, v947 = pairs(v944:GetPlayers())

                                while true do
                                    local v948

                                    v947, v948 = v945(v946, v947)

                                    if v947 == nil then
                                        break
                                    end
                                    if u861(v948) then
                                        local _Character7 = v948.Character
                                        local _HumanoidRootPart10 = _Character7:FindFirstChild('HumanoidRootPart')

                                        if SNOWshipPlayer(v948) and (_HumanoidRootPart10 and not _Character7:GetAttribute('IsAnchored')) then
                                            setanchorObject(_HumanoidRootPart10)
                                        end
                                    end
                                end
                            end

                            task.wait(0.1)
                        end
                    end
                end,
                Save = true,
                Flag = 'anchoraura_toggle',
            })
            v843:AddDropdown({
                Name = 'Target',
                Default = 'Players',
                Options = {
                    'Players',
                    'Objects',
                    'Players and Objects',
                },
                Callback = function(p951)
                    if p951 == 'Players' then
                        _G.AnchorTarget = 1
                    elseif p951 == 'Objects' then
                        _G.AnchorTarget = 2
                    elseif p951 == 'Players and Objects' then
                        _G.AnchorTarget = 3
                    end
                end,
                Save = true,
                Flag = 'anchortarget_dropdown',
            })
            v841:AddToggle({
                Name = 'Attraction Aura',
                Default = false,
                Callback = function(p952)
                    _G.AttractionAura = p952

                    if p952 then
                        while _G.AttractionAura do
                            local v953 = _Players
                            local v954, v955, v956 = pairs(v953:GetPlayers())

                            while true do
                                local v957

                                v956, v957 = v954(v955, v956)

                                if v956 == nil then
                                    break
                                end
                                if u861(v957) then
                                    local _Character8 = v957.Character
                                    local _HumanoidRootPart11 = _Character8:FindFirstChild('HumanoidRootPart')
                                    local _Humanoid6 = _Character8:FindFirstChildOfClass('Humanoid')
                                    local v961 = GetPlayerCharacter()

                                    if _Humanoid6 and (_HumanoidRootPart11 and v961) then
                                        SNOWship(_HumanoidRootPart11)

                                        _Humanoid6.Sit = false
                                        _Humanoid6.WalkSpeed = 25

                                        _Humanoid6:MoveTo(v961.HumanoidRootPart.Position)
                                    end
                                end
                            end

                            task.wait()
                        end
                    end
                end,
                Save = true,
                Flag = 'attractaura_toggle',
            })

            kickauratoggle = nil
            KickTypesList = {
                'Silent',
                'Float',
                'Sky Anchor',
            }

            function CreateKickPhysical(p962, p963, p964)
                if p963:FindFirstChild('KickAuraP') then
                    p963.KickAuraP:SetAttribute('TypeFunction', p964)
                else
                    local _BodyPosition8 = Instance.new('BodyPosition', p963)

                    _BodyPosition8.Name = 'KickAuraP'

                    local v966 = _BodyPosition8

                    _BodyPosition8.SetAttribute(v966, 'TypeFunction', p964)

                    local _BodyVelocity6 = Instance.new('BodyVelocity', p963)

                    _BodyVelocity6.Name = 'KickAuraP1'
                    _BodyVelocity6.Velocity = Vector3.new(0, 400, 0)

                    task.spawn(function()
                        local u968 = nil
                        local u969 = nil
                        local u970 = Vector3.new(0, -100, 0)
                        local u971 = Vector3.new(0, 0, 0)
                        local u972 = Vector3.new(0, 12500, 0)
                        local u973 = Vector3.new(4000, 4000, 4000)
                        local u974 = Vector3.new(math.random(50, 250), 250, math.random(50, 250))
                        local u975 = RaycastParams.new()

                        u975.FilterDescendantsInstances = {p962}
                        u975.FilterType = Enum.RaycastFilterType.Exclude

                        local function v977(p976)
                            if p976 == 'Silent' then
                                _BodyPosition8.MaxForce = u972
                                _BodyVelocity6.MaxForce = u971
                                u968 = p963.Position
                                u969 = _Workspace:Raycast(u968, u970, u975)

                                if u969 then
                                    _BodyPosition8.Position = u969.Position + Vector3.new(0, 5, 0)
                                end
                            elseif p976 == 'Float' then
                                _BodyVelocity6.MaxForce = u973
                                _BodyPosition8.MaxForce = u971
                            elseif p976 == 'Sky Anchor' then
                                _BodyPosition8.MaxForce = u973
                                _BodyPosition8.Position = u974
                                _BodyVelocity6.MaxForce = u971
                            end
                        end

                        while _BodyPosition8.Parent and p962.Parent do
                            p964 = _BodyPosition8:GetAttribute('TypeFunction')

                            if p964 == 'Aura' or not p964 then
                                if not _G.KickAura then
                                    break
                                end

                                v977(_G.KickAuraType)
                            elseif p964 ~= 'Counter' then
                                if p964 ~= 'Kick_All' then
                                    if p964 == 'LoopKick' then
                                        if not _G.LoopKickOwnership then
                                            break
                                        end

                                        v977(_G.LoopKickOwnerType)
                                    end
                                else
                                    if not _G.KickAll then
                                        break
                                    end

                                    v977(_G.KickAllType)
                                end
                            else
                                if not _G.AutoAttacker then
                                    break
                                end

                                v977(_G.KickCounterType)
                            end

                            task.wait()
                        end

                        _BodyPosition8:Destroy()
                        _BodyVelocity6:Destroy()
                    end)
                end
            end

            kickauratoggle = v844:AddToggle({
                Name = 'Kick Aura',
                Default = false,
                Callback = function(p978)
                    _G.KickAura = p978

                    if p978 then
                        while _G.KickAura do
                            if GetKey() ~= 'Xana' then
                                kickauratoggle:Set(false)
                                u35('Only for premium users! Buy premium in my discord server!')

                                break
                            end

                            local v979 = _Players
                            local v980, v981, v982 = pairs(v979:GetPlayers())

                            while true do
                                local v983

                                v982, v983 = v980(v981, v982)

                                if v982 == nil then
                                    break
                                end
                                if u863(v983) then
                                    local _Character9 = v983.Character
                                    local _HumanoidRootPart12 = _Character9:FindFirstChild('HumanoidRootPart')

                                    if _HumanoidRootPart12 and (_Character9:FindFirstChildOfClass('Humanoid') and (_HumanoidRootPart12:FindFirstChild('FirePlayerPart') and SNOWshipPlayer(v983))) then
                                        CreateSkyVelocity(_HumanoidRootPart12)
                                        _DestroyGrabLine:FireServer(_HumanoidRootPart12)
                                    end
                                end
                            end

                            task.wait()
                        end
                    end
                end,
            })

            v844:AddDropdown({
                Name = 'Kick Type',
                Default = 'Go to the heaven!',
                Options = {
                    'Go to the heaven!',
                },
                Callback = function(p986)
                    _G.KickAuraType = p986
                end,
                Save = true,
                Flag = 'kickauratype_dropdown',
            })
            v845:AddToggle({
                Name = 'Whitelist Friends',
                Default = false,
                Callback = function(p987)
                    _G.WhitelistFriends = p987
                end,
                Save = true,
                Flag = 'whitelistaura_toggle',
            })

            local v988 = v584:AddSection({
                Name = 'Strength',
            })
            local v989 = v584:AddSection({
                Name = 'Others',
            })
            local v990 = v584:AddSection({
                Name = 'Perspective',
            })

            v988:AddToggle({
                Name = 'Super Strength',
                Default = false,
                Callback = function(p991)
                    _G.SuperStrength = p991
                end,
                Save = true,
                Flag = 'superstrengthgrab_toggle',
            })
            v988:AddSlider({
                Name = 'Strength',
                Min = 400,
                Max = 10000,
                Default = 400,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 100,
                ValueName = '',
                Callback = function(p992)
                    _G.Strength = p992
                end,
                Save = true,
                Flag = 'superstrengthvalue_toggle',
            })
            v989:AddToggle({
                Name = 'Poison Grab',
                Default = false,
                Callback = function(p993)
                    _G.Poison_Grab = p993
                end,
                Save = true,
                Flag = 'poisongrab_toggle',
            })
            v989:AddToggle({
                Name = 'Burn Grab',
                Default = false,
                Callback = function(p994)
                    _G.Burn_Grab = p994
                end,
                Save = true,
                Flag = 'burngrab_toggle',
            })
            v989:AddToggle({
                Name = 'Death Grab',
                Default = false,
                Callback = function(p995)
                    _G.Death_Grab = p995
                end,
                Save = true,
                Flag = 'deathgrab_toggle',
            })
            v989:AddToggle({
                Name = 'Massless Grab',
                Default = false,
                Callback = function(p996)
                    _G.MasslessGrab = p996
                end,
                Save = true,
                Flag = 'masslessgrab_toggle',
            })

            if _OuterUFO then
                v989:AddToggle({
                    Name = 'Radiactive Grab',
                    Default = false,
                    Callback = function(p997)
                        _G.Radiactive_Grab = p997
                    end,
                    Save = true,
                    Flag = 'radiactivegrab_toggle',
                })
            end

            v989:AddToggle({
                Name = 'Noclip Grab',
                Default = false,
                Callback = function(p998)
                    _G.NoclipGrab = p998
                end,
                Save = true,
                Flag = 'noclipgrab_toggle',
            })

            local u999 = nil
            local u1000 = 50

            kickgrabtoggle = nil

            v990:AddToggle({
                Name = 'Perspective Grab',
                Default = false,
                Callback = function(p1001)
                    _G.PerspectiveGrab = p1001
                end,
                Save = true,
                Flag = 'perspectivegrab_toggle',
            })
            v990:AddSlider({
                Name = 'Speed',
                Min = 50,
                Max = 150,
                Default = 50,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 1,
                ValueName = '',
                Callback = function(p1002)
                    u1000 = p1002
                end,
                Save = true,
                Flag = 'perspectivespeedvalue_toggle',
            })

            local v1003 = v594:AddSection({
                Name = 'Annoy Players',
            })
            local v1004 = v594:AddSection({
                Name = 'Kick All',
            })
            local v1005 = v594:AddSection({
                Name = 'Whitelist',
            })
            local u1006 = nil

            u1006 = v1003:AddToggle({
                Name = 'Fire All',
                Default = false,
                Callback = function(p1007)
                    _G.FireAllPlayers = p1007

                    if p1007 then
                        while _G.FireAllPlayers do
                            if GetKey() ~= 'Xana' then
                                u1006:Set(false)
                                u35('Only for premium users! Buy premium in my discord server!')

                                break
                            end

                            local v1008 = _Players
                            local v1009, v1010, v1011 = pairs(v1008:GetPlayers())

                            while true do
                                local v1012

                                v1011, v1012 = v1009(v1010, v1011)

                                if v1011 == nil then
                                    break
                                end
                                if u865(v1012) then
                                    local _ = v1012.Character
                                    local _HumanoidRootPart13 = v1012.Character:FindFirstChild('HumanoidRootPart')
                                    local v1014

                                    if _HumanoidRootPart13:FindFirstChild('FirePlayerPart') and _HumanoidRootPart13.FirePlayerPart:FindFirstChild('CanBurn') then
                                        v1014 = _HumanoidRootPart13.FirePlayerPart.CanBurn.Value
                                    else
                                        v1014 = nil
                                    end
                                    if _HumanoidRootPart13 and (v1012 and not (IsPlayerInsideSafeZone(v1012) or v1014)) then
                                        u550(_HumanoidRootPart13)
                                        task.wait(0.015)
                                    end
                                end
                            end

                            task.wait()
                        end
                    end
                end,
            })
            annoyalltoggle = v1003:AddToggle({
                Name = 'Ragdoll All',
                Default = false,
                Callback = function(p1015)
                    _G.AnnoyAllPlayers = p1015

                    if p1015 then
                        while _G.AnnoyAllPlayers do
                            if GetKey() ~= 'Xana' then
                                annoyalltoggle:Set(false)
                                u35('Only for premium users! Buy premium in my discord server!')

                                break
                            end

                            local v1016 = _Players
                            local v1017, v1018, v1019 = pairs(v1016:GetPlayers())

                            while true do
                                local v1020

                                v1019, v1020 = v1017(v1018, v1019)

                                if v1019 == nil then
                                    break
                                end
                                if u865(v1020) then
                                    local _Character10 = v1020.Character
                                    local _HumanoidRootPart14 = v1020.Character:FindFirstChild('HumanoidRootPart')
                                    local _Ragdolled = _Character10:FindFirstChildOfClass('Humanoid'):FindFirstChild('Ragdolled')

                                    if _HumanoidRootPart14 and (_Ragdolled and not _Ragdolled.Value) then
                                        u519(_HumanoidRootPart14)
                                        task.wait(0.015)
                                    end
                                end
                            end

                            task.wait()
                        end
                    end
                end,
            })
            killalltoggle = v1003:AddToggle({
                Name = 'Kill All',
                Default = false,
                Callback = function(p1024)
                    _G.KillAll = p1024

                    if p1024 then
                        if GetKey() ~= 'Xana' then
                            _G.KillAll = false

                            killalltoggle:Set(false)
                            u35('Only for premium users! Buy premium in my discord server!')

                            return
                        end

                        while _G.KillAll do
                            ipos = GetPlayerCFrame()

                            local v1025 = _Players
                            local v1026, v1027, v1028 = pairs(v1025:GetPlayers())

                            while true do
                                local v1029

                                v1028, v1029 = v1026(v1027, v1028)

                                if v1028 == nil then
                                    break
                                end
                                if u867(v1029) then
                                    local _HumanoidRootPart15 = v1029.Character:FindFirstChild('HumanoidRootPart')
                                    local _Humanoid7 = v1029.Character:FindFirstChild('Humanoid')

                                    if v1029 and (_HumanoidRootPart15 and _Humanoid7) then
                                        for _ = 0, 50 do
                                            u390()
                                            SNOWship(_HumanoidRootPart15)

                                            if not u867(v1029) or (not _G.KillAll or (CheckNetworkOwnerShipOnPlayer(v1029) or _HumanoidRootPart15.AssemblyLinearVelocity.Magnitude > 500)) then
                                                CreateSkyVelocity(_HumanoidRootPart15)
                                                _DestroyGrabLine:FireServer(_HumanoidRootPart15)

                                                break
                                            end

                                            task.wait()

                                            if _HumanoidRootPart15.Position.Y <= -12 then
                                                TeleportPlayer(CFrame.new(_HumanoidRootPart15.Position + Vector3.new(0, 5, -15)))
                                            else
                                                TeleportPlayer(CFrame.new(_HumanoidRootPart15.Position + Vector3.new(0, -10, -10)))
                                            end

                                            _Humanoid7.BreakJointsOnDeath = false

                                            _Humanoid7:ChangeState(Enum.HumanoidStateType.Dead)

                                            _Humanoid7.Jump = true
                                            _Humanoid7.Sit = false
                                        end
                                    end
                                end
                            end

                            TeleportPlayer(ipos)
                            task.wait(0.2)
                        end

                        u391()
                        TeleportPlayer(ipos)
                    end
                end,
            })
            kickalltoggle = v1004:AddToggle({
                Name = 'Kick All',
                Default = false,
                Callback = function(p1032)
                    _G.KickAll = p1032

                    if p1032 then
                        if GetKey() ~= 'Xana' then
                            _G.KickAll = false

                            kickalltoggle:Set(false)
                            u35('Only for premium users! Buy premium in my discord server!')

                            return
                        end

                        while _G.KickAll do
                            ipos = GetPlayerCFrame()

                            local v1033 = _Players
                            local v1034, v1035, v1036 = pairs(v1033:GetPlayers())

                            while true do
                                local v1037

                                v1036, v1037 = v1034(v1035, v1036)

                                if v1036 == nil then
                                    break
                                end
                                if u869(v1037) then
                                    local _HumanoidRootPart16 = v1037.Character:FindFirstChild('HumanoidRootPart')

                                    if v1037 and _HumanoidRootPart16 then
                                        for _ = 0, 50 do
                                            u390()
                                            SNOWship(_HumanoidRootPart16)

                                            if not u869(v1037) or (not _G.KickAll or (CheckNetworkOwnerShipOnPlayer(v1037) or _HumanoidRootPart16.AssemblyLinearVelocity.Magnitude > 500)) then
                                                CreateSkyVelocity(_HumanoidRootPart16)
                                                _DestroyGrabLine:FireServer(_HumanoidRootPart16)

                                                break
                                            end

                                            task.wait()

                                            if _HumanoidRootPart16.Position.Y <= -12 then
                                                TeleportPlayer(CFrame.new(_HumanoidRootPart16.Position + Vector3.new(0, 5, -15)))
                                            else
                                                TeleportPlayer(CFrame.new(_HumanoidRootPart16.Position + Vector3.new(0, -10, -10)))
                                            end
                                        end
                                    end
                                end
                            end

                            TeleportPlayer(ipos)
                            task.wait(0.2)
                        end

                        u391()
                        TeleportPlayer(ipos)
                    end
                end,
            })

            v1004:AddDropdown({
                Name = 'Kick Type',
                Default = 'Go to the heaven!',
                Options = {
                    'Go to the heaven!',
                },
                Callback = function(p1039)
                    _G.KickAllType = p1039
                end,
                Save = true,
                Flag = 'kickalltype_dropdown',
            })
            v1005:AddToggle({
                Name = 'Whitelist Friends',
                Default = false,
                Callback = function(p1040)
                    _G.WhitelistFriends3 = p1040
                end,
                Save = true,
                Flag = 'whitelistfriends3_toggle',
            })

            local v1041 = v585:AddSection({
                Name = 'Invulnerability',
            })
            local v1042 = v585:AddSection({
                Name = 'Counter-Attack',
            })

            v1041:AddToggle({
                Name = 'Anti-Grab',
                Default = false,
                Callback = function(p1043)
                    _G.AntiGrab = p1043

                    if p1043 and not u55(u30) then
                        _Struggle:FireServer(_LocalPlayer)
                    end
                end,
                Save = true,
                Flag = 'antigrab_toggle',
            })
            v1041:AddToggle({
                Name = 'Anti-Burn',
                Default = false,
                Callback = function(p1044)
                    _G.AntiBurn = p1044
                end,
                Save = true,
                Flag = 'antiburn_toggle',
            })
            v1041:AddToggle({
                Name = 'Anti-Explosion',
                Default = false,
                Callback = function(p1045)
                    _G.AntiExplosion = p1045
                end,
                Save = true,
                Flag = 'antiexplosion_toggle',
            })
            v1042:AddToggle({
                Name = 'Auto-Attacker',
                Default = false,
                Callback = function(p1046)
                    _G.AutoAttacker = p1046
                end,
                Save = true,
                Flag = 'rinnegan_toggle',
            })

            counterdropdownselection = nil
            counterdropdownselection = v1042:AddDropdown({
                Name = 'Counter Mode',
                Default = 'Repulsion',
                Options = {
                    'Repulsion',
                    'Freeze',
                    'Death',
                    'Kick',
                },
                Callback = function(p1047)
                    if p1047 == 'Kick' and GetKey() ~= 'Xana' then
                        counterdropdownselection:Set('Repulsion')
                        u35('Only for premium users! Buy premium in my discord server!')
                    else
                        _G.CounterMode = p1047
                    end
                end,
            })
            floppadialogo = Instance.new('ScreenGui')
            Floppa = Instance.new('ImageLabel')
            Bubble_chat = Instance.new('ImageLabel')
            BubbleTextchat = Instance.new('TextLabel')
            typingsoundeffect = Instance.new('Sound', _Workspace)
            typingsoundeffect2 = Instance.new('Sound', _Workspace)
            typingsoundeffect.SoundId = 'rbxassetid://' .. 9120299506
            typingsoundeffect.Volume = 0.345
            typingsoundeffect2.SoundId = 'rbxassetid://' .. 9118870964
            typingsoundeffect2.Volume = 1
            typingsoundeffect2.PlaybackSpeed = 1.5
            floppadialogo.IgnoreGuiInset = true
            floppadialogo.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
            floppadialogo.Name = 'floppadialogo'
            floppadialogo.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            floppadialogo.Parent = _PlayerGui
            floppadialogo.DisplayOrder = 10
            floppadialogo.Enabled = false
            floppadialogo.ResetOnSpawn = false
            Floppa.ZIndex = 0
            Floppa.BorderSizePixel = 0
            Floppa.BackgroundColor3 = Color3.new(1, 1, 1)
            Floppa.Image = 'rbxassetid://15668608167'
            Floppa.Size = UDim2.new(0.195372716, 0, 0.305668026, 0)
            Floppa.BorderColor3 = Color3.new(0, 0, 0)
            Floppa.Position = UDim2.new(0.0185752641, 0, 0.661330521, 0)
            Floppa.Name = 'Floppa'
            Floppa.Parent = floppadialogo
            Bubble_chat.BorderSizePixel = 0
            Bubble_chat.Transparency = 1
            Bubble_chatBackgroundColor3 = Color3.new(1, 1, 1)
            Bubble_chat.Image = 'rbxassetid://1395860348'
            Bubble_chat.Size = UDim2.new(1.03356743, 0, 0.79455024, 0)
            Bubble_chat.BorderColor3 = Color3.new(0, 0, 0)
            Bubble_chat.BackgroundTransparency = 1
            Bubble_chat.Position = UDim2.new(0.678329766, 0, -0.292054504, 0)
            Bubble_chat.Name = 'Bubble chat'
            Bubble_chat.Parent = Floppa
            BubbleTextchat.TextWrapped = true
            BubbleTextchat.BorderSizePixel = 0
            BubbleTextchat.Transparency = 1
            BubbleTextchat.TextScaled = true
            BubbleTextchat.BackgroundColor3 = Color3.new(1, 1, 1)
            BubbleTextchat.TextSize = 14
            BubbleTextchat.Size = UDim2.new(0.634431362, 0, 0.268763244, 0)
            BubbleTextchat.TextColor3 = Color3.new(0, 0, 0)
            BubbleTextchat.BorderColor3 = Color3.new(0, 0, 0)
            BubbleTextchat.Text = 'I saved you from falling on the void, my son!'
            BubbleTextchat.Font = Enum.Font.SourceSans
            BubbleTextchat.Position = UDim2.new(0.18163082, 0, 0.365639389, 0)
            BubbleTextchat.BackgroundTransparency = 1
            BubbleTextchat.TextTransparency = 0
            BubbleTextchat.Parent = Bubble_chat
            floppatweeninfo1 = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)

            local v1048 = _TweenService

            floppatween = _TweenService.Create(v1048, Floppa, floppatweeninfo1, {
                Position = UDim2.new(0.0185752641, 0, 0.661330521, 0),
            })
            floppamessageoncooldown = false

            function antivoidmesssage()
                if not floppamessageoncooldown then
                    Floppa.Position = UDim2.new(0.0185752641, 0, 2, 0)
                    floppadialogo.Enabled = true
                    Floppa.Visible = true
                    Bubble_chat.Visible = false
                    BubbleTextchat.Visible = false
                    floppamessageoncooldown = true

                    floppatween:Play()
                    floppatween.Completed:Connect(function(p1049)
                        if p1049 == Enum.PlaybackState.Completed then
                            Bubble_chat.Visible = true
                            BubbleTextchat.Visible = true
                            BubbleTextchat.Text = ''

                            local v1050 = 'I saved you from falling on the void, my son!'

                            for v1051 = 0, #v1050 do
                                BubbleTextchat.Text = string.sub(v1050, 1, v1051)

                                typingsoundeffect:Play()
                                task.wait(0.05)
                            end

                            task.wait(1)
                            typingsoundeffect2:Play()

                            floppadialogo.Enabled = false
                            floppamessageoncooldown = false
                        end
                    end)
                end
            end

            v1041:AddToggle({
                Name = 'Anti-Void',
                Default = false,
                Callback = function(p1052)
                    _G.AntiVoid = p1052

                    if p1052 then
                        _Workspace.FallenPartsDestroyHeight = -1000

                        while _G.AntiVoid do
                            local v1053 = GetPlayerCharacter()

                            if v1053 and v1053.HumanoidRootPart.Position.Y < -800 then
                                v1053:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))
                                antivoidmesssage()
                            end

                            wait(0.1)
                        end
                    else
                        _Workspace.FallenPartsDestroyHeight = -100
                    end
                end,
                Save = true,
                Flag = 'antivoid_toggle',
            })
            v1041:AddToggle({
                Name = 'Anti-Lag',
                Default = false,
                Callback = function(p1054)
                    anticreatelinelocalscript.Disabled = p1054
                end,
                Save = true,
                Flag = 'antilag_toggle',
            })

            antikicktoggle = v1041:AddToggle({
                Name = 'Anti-Kick',
                Default = false,
                Callback = function(p1055)
                    if GetKey() == 'Xana' then
                        _G.AntiKick = p1055
                    else
                        _G.AntiKick = false

                        if p1055 then
                            antikicktoggle:Set(false)
                            u35('Only for premium users! Buy premium in my discord server!')
                        end
                    end
                end,
                Save = true,
                Flag = 'antikick_toggle',
            })
            playersCharFolder = Instance.new('Model', _Workspace)
            playersCharFolder.Name = 'Characters'
            highlightesp = Instance.new('Highlight')
            highlightesp.Enabled = true
            ESP_Section1 = Esp_Tab:AddSection({
                Name = 'ESP Highlight',
            })
            ESP_Section2 = Esp_Tab:AddSection({
                Name = 'ESP Billboard',
            })

            ESP_Section1:AddToggle({
                Name = 'ESP (Highlight)',
                Default = false,
                Callback = function(p1056)
                    _G.ESP_Hightlight = p1056

                    if p1056 then
                        highlightesp.Parent = playersCharFolder

                        local function u1059(p1057)
                            local v1058 = p1057 ~= _LocalPlayer and p1057.Character

                            if v1058 then
                                v1058.Parent = playersCharFolder
                            end
                        end
                        local function v1065()
                            local v1060 = _Players
                            local v1061, v1062, v1063 = pairs(v1060:GetPlayers())

                            while true do
                                local v1064

                                v1063, v1064 = v1061(v1062, v1063)

                                if v1063 == nil then
                                    break
                                end

                                u1059(v1064)
                            end
                        end

                        v1065()

                        while _G.ESP_Hightlight do
                            v1065()
                            wait(2)
                        end

                        highlightesp.Parent = nil
                    end
                end,
            })
            ESP_Section1:AddColorpicker({
                Name = 'Fill Color',
                Default = Color3.fromRGB(255, 0, 0),
                Callback = function(p1066)
                    highlightesp.FillColor = p1066
                end,
                Save = true,
                Flag = 'espHighlightFillcolor_picker',
            })
            ESP_Section1:AddSlider({
                Name = 'Fill Transparency',
                Min = 0,
                Max = 1,
                Default = 0.5,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 0.1,
                ValueName = 'Fill color transparency:',
                Callback = function(p1067)
                    highlightesp.FillTransparency = p1067
                end,
                Save = true,
                Flag = 'espHighlightFillTransparency_slider',
            })
            ESP_Section1:AddColorpicker({
                Name = 'Outline Color',
                Default = Color3.fromRGB(255, 0, 0),
                Callback = function(p1068)
                    highlightesp.OutlineColor = p1068
                end,
                Save = true,
                Flag = 'espHighlightOutlinecolor_picker',
            })
            ESP_Section1:AddSlider({
                Name = 'Outline Transparency',
                Min = 0,
                Max = 1,
                Default = 0.5,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 0.1,
                ValueName = 'Outline color transparency:',
                Callback = function(p1069)
                    highlightesp.OutlineTransparency = p1069
                end,
                Save = true,
                Flag = 'espHighlightOutlineTransparency_slider',
            })
            ESP_Section1:AddDropdown({
                Name = 'Highlight Mode',
                Default = 'AlwaysOnTop',
                Options = {
                    'AlwaysOnTop',
                    'Occluded',
                },
                Callback = function(p1070)
                    highlightesp.DepthMode = Enum.HighlightDepthMode[p1070]
                end,
                Save = true,
                Flag = 'espHighlightMode_dropdown',
            })

            function ESPIconCreation()
                local _BillboardGui2 = Instance.new('BillboardGui')
                local _ImageButton = Instance.new('ImageButton')
                local _UICorner = Instance.new('UICorner')
                local _TextLabel2 = Instance.new('TextLabel')
                local _UITextSizeConstraint2 = Instance.new('UITextSizeConstraint')
                local _UIAspectRatioConstraint2 = Instance.new('UIAspectRatioConstraint')

                _BillboardGui2.Name = 'ESP'
                _BillboardGui2.Parent = nil
                _BillboardGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                _BillboardGui2.Active = true
                _BillboardGui2.Adornee = nil
                _BillboardGui2.AlwaysOnTop = true
                _BillboardGui2.ExtentsOffset = Vector3.new(0, 10, 0)
                _BillboardGui2.Size = UDim2.new(3, 50, 3, 45)
                _ImageButton.Name = 'UserImage'
                _ImageButton.Parent = _BillboardGui2
                _ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
                _ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                _ImageButton.BackgroundTransparency = 1
                _ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
                _ImageButton.BorderSizePixel = 0
                _ImageButton.Position = UDim2.new(0.5, 0, 0.300000012, 0)
                _ImageButton.Size = UDim2.new(0.5, 5, 0.5, 5)
                _ImageButton.Image = ''
                _UICorner.CornerRadius = UDim.new(2, 0)
                _UICorner.Parent = _ImageButton
                _TextLabel2.Name = 'Username'
                _TextLabel2.Parent = _BillboardGui2
                _TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
                _TextLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                _TextLabel2.BackgroundTransparency = 1
                _TextLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                _TextLabel2.BorderSizePixel = 0
                _TextLabel2.Position = UDim2.new(0.5, 0, 0.75999999, 0)
                _TextLabel2.Size = UDim2.new(1, 5, 0.340000004, 5)
                _TextLabel2.Font = Enum.Font.SourceSans
                _TextLabel2.Text = ''
                _TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
                _TextLabel2.TextScaled = true
                _TextLabel2.TextSize = 35
                _TextLabel2.TextStrokeTransparency = 0
                _TextLabel2.TextWrapped = true
                _UITextSizeConstraint2.Parent = _TextLabel2
                _UITextSizeConstraint2.MaxTextSize = 35
                _UITextSizeConstraint2.MinTextSize = 15
                _UIAspectRatioConstraint2.Parent = _BillboardGui2
                _UIAspectRatioConstraint2.AspectRatio = 1.043

                return _BillboardGui2
            end

            ESPIconCreation = ESPIconCreation()

            function CreateIconOnPlayer(p1077)
                if p1077.Character then
                    local _Character11 = p1077.Character
                    local _Head5 = _Character11:WaitForChild('Head', 1)

                    if not _Character11:FindFirstChild('ESP') and _Head5 then
                        local u1080 = ESPIconCreation:Clone()

                        u1080.Parent = _Character11
                        u1080.Adornee = _Head5
                        u1080.Username.Text = p1077.Name
                        u1080.UserImage.Image = 'https://www.roblox.com/headshot-thumbnail/image?userId=' .. p1077.UserId .. '&width=420&height=420&format=png'

                        task.spawn(function()
                            while _Character11.Parent and _G.ESP_Icon do
                                task.wait(0.25)
                            end

                            u1080:Destroy()
                        end)
                    end
                end
            end

            ESP_Section2:AddToggle({
                Name = 'ESP (Icon)',
                Default = false,
                Callback = function(p1081)
                    _G.ESP_Icon = p1081

                    if p1081 then
                        local u1082 = {}

                        local function v1087()
                            local v1083, v1084, v1085 = pairs(u1082)

                            while true do
                                local v1086

                                v1085, v1086 = v1083(v1084, v1085)

                                if v1085 == nil then
                                    break
                                end
                                if typeof(v1086) == 'RBXScriptConnection' then
                                    v1086:Disconnect()
                                    print('Desconectado!')
                                end
                            end

                            table.clear(u1082)
                        end
                        local function u1089(p1088)
                            if p1088 ~= _LocalPlayer and (p1088.Character or p1088.CharacterAdded:Wait()) then
                                CreateIconOnPlayer(p1088)

                                u1082[#u1082 + 1] = p1088.CharacterAdded:Connect(function(_)
                                    CreateIconOnPlayer(p1088)
                                end)
                            end
                        end
                        local function v1095()
                            local v1090 = _Players
                            local v1091, v1092, v1093 = pairs(v1090:GetPlayers())

                            while true do
                                local v1094

                                v1093, v1094 = v1091(v1092, v1093)

                                if v1093 == nil then
                                    break
                                end

                                u1089(v1094)
                            end
                        end

                        local v1097 = _Players.PlayerAdded:Connect(function(p1096)
                            u1089(p1096)
                        end)

                        v1095()

                        while _G.ESP_Icon do
                            wait(0.1)
                        end

                        v1097:Disconnect()
                        v1087()
                    end
                end,
            })

            MapTeleport_Section = v588:AddSection({
                Name = 'Place TP',
            })
            PlayerTeleport_Section = v588:AddSection({
                Name = 'Player TP',
            })
            placeLocations = {
                ['Green House'] = CFrame.new(-352, 99, 354),
                ['Green Safe-House'] = CFrame.new(-584, -6, 93),
                ['Chinese Safe-House'] = CFrame.new(579, 124, -94),
                ['Farm House'] = CFrame.new(-234, 83, -324),
                Spawn = CFrame.new(4, -7, -3),
                ['Blue Safe-House'] = CFrame.new(538, 96, -372),
                ['Secret Big Cave'] = CFrame.new(17, -7, 539),
                ['Secret Train Cave'] = CFrame.new(500, 62, -307),
                ['Mine Cave'] = CFrame.new(-254, -7, 518),
                ['Witch Safe-House'] = CFrame.new(296, -4, 494),
                ['Red Safe-House'] = CFrame.new(-516, -6, -162),
            }

            MapTeleport_Section:AddDropdown({
                Name = 'Place to Teleport',
                Default = 'Green House',
                Options = {
                    'Green House',
                    'Chinese Safe-House',
                    'Spawn',
                    'Blue Safe-House',
                    'Secret Big Cave',
                    'Secret Train Cave',
                    'Mine Cave',
                    'Farm House',
                    'Witch Safe-House',
                    'Green Safe-House',
                    'Red Safe-House',
                },
                Callback = function(p1098)
                    _G.PlaceToTeleport = p1098
                end,
            })
            MapTeleport_Section:AddButton({
                Name = 'Teleport',
                Callback = function()
                    TeleportPlayer(placeLocations[_G.PlaceToTeleport])
                end,
            })

            PlayerToTeleport = PlayerTeleport_Section:AddDropdown({
                Name = 'Select Player',
                Default = '',
                Options = {
                    '',
                },
                Callback = function(p1099)
                    local v1100 = string.split(p1099, ' ')

                    _G.PlayerToTeleport = v1100[1]
                end,
            })

            function teleportplayerfunctionoffset(p1101, p1102, p1103, p1104)
                local v1105 = nil

                if _G.PlayerToTeleportDirection ~= 'Behind' then
                    if _G.PlayerToTeleportDirection ~= 'Front' then
                        if _G.PlayerToTeleportDirection ~= 'Right' then
                            if _G.PlayerToTeleportDirection ~= 'Left' then
                                if _G.PlayerToTeleportDirection == 'Rotate' and (p1102 and p1103) then
                                    local v1106 = 0

                                    while _G.PlayerToTeleportDirection == 'Rotate' and (_G.LoopPlayerTP and (p1103:IsDescendantOf(_Workspace) and p1104 == _G.PlayerToTeleport)) do
                                        v1106 = v1106 + 0.1
                                        v1105 = CFrame.new(p1102.Position + Vector3.new(math.clamp(math.cos(v1106), -1, 1), 0, math.clamp(math.sin(v1106), -1, 1)) * (TeleportPlayerOffset + 1), p1102.Position)

                                        TeleportPlayer(v1105)
                                        task.wait()
                                    end
                                end
                            else
                                v1105 = CFrame.new(p1101.Position - p1101.rightVector * (TeleportPlayerOffset + 1))
                            end
                        else
                            v1105 = CFrame.new(p1101.Position + p1101.rightVector * (TeleportPlayerOffset + 1))
                        end
                    else
                        v1105 = CFrame.new(p1101.Position + p1101.lookVector * (TeleportPlayerOffset + 1))
                    end
                else
                    v1105 = CFrame.new(p1101.Position - p1101.lookVector * (TeleportPlayerOffset + 1))
                end
                if _G.PlayerToTeleportDirection ~= 'Rotate' then
                    TeleportPlayer(v1105)
                end
            end

            PlayerTeleport_Section:AddButton({
                Name = 'Teleport',
                Callback = function()
                    local v1107 = _Players:FindFirstChild(_G.PlayerToTeleport)
                    local v1108 = GetPlayerRoot()
                    local v1109 = v1107 and (v1107.Character and v1108) and v1107.Character:FindFirstChild('HumanoidRootPart')

                    if v1109 then
                        teleportplayerfunctionoffset(v1109.CFrame, v1108)
                    end
                end,
            })

            PlayerLoopTeleport = PlayerTeleport_Section:AddToggle({
                Name = 'Loop Teleport',
                Default = false,
                Callback = function(p1110)
                    _G.LoopPlayerTP = p1110

                    if p1110 then
                        while _G.LoopPlayerTP do
                            local v1111 = _Players:FindFirstChild(_G.PlayerToTeleport)

                            if v1111 and v1111.Character then
                                local _Character12 = v1111.Character
                                local _HumanoidRootPart17 = _Character12:FindFirstChild('HumanoidRootPart')

                                if _HumanoidRootPart17 then
                                    teleportplayerfunctionoffset(_HumanoidRootPart17.CFrame, _HumanoidRootPart17, _Character12, v1111.Name)
                                end
                            elseif not v1111 then
                                if PlayerLoopTeleport then
                                    PlayerLoopTeleport:Set(false)
                                end

                                _G.LoopPlayerTP = false
                            end

                            task.wait()
                        end
                    end
                end,
            })
            PlayerLockCamera = PlayerTeleport_Section:AddToggle({
                Name = 'Lock Camera',
                Default = false,
                Callback = function(p1114)
                    _G.LockCameraOnPlayer = p1114

                    if p1114 then
                        local u1115 = nil
                        local u1116 = nil
                        local u1117 = nil
                        local u1118 = nil
                        local u1119 = nil

                        u1119 = _RunService.RenderStepped:Connect(function()
                            u1115 = _Players:FindFirstChild(_G.PlayerToTeleport)
                            u1118 = _Workspace.CurrentCamera

                            if not _G.LockCameraOnPlayer then
                                u1119:Disconnect()
                            end
                            if u1115 and (u1115.Character and u1118) then
                                u1117 = u1115.Character
                                u1116 = u1117:FindFirstChild('HumanoidRootPart')

                                if u1116 then
                                    u1118.CFrame = CFrame.lookAt(u1118.CFrame.Position, u1116.CFrame.Position + Vector3.new(0, 1, 0))
                                end
                            elseif not u1115 then
                                if PlayerLockCamera then
                                    PlayerLockCamera:Set(false)
                                end

                                _G.LockCameraOnPlayer = false
                            end

                            task.wait()
                        end)
                    end
                end,
            })
            PlayerViewCamera = PlayerTeleport_Section:AddToggle({
                Name = 'View',
                Default = false,
                Callback = function(p1120)
                    _G.ViewCameraOnPlayer = p1120

                    if p1120 then
                        local _CurrentCamera3 = _Workspace.CurrentCamera
                        local _CameraSubject = _CurrentCamera3.CameraSubject

                        while _G.ViewCameraOnPlayer do
                            local v1123 = _Players:FindFirstChild(_G.PlayerToTeleport)

                            if v1123 and (v1123.Character and _CurrentCamera3) then
                                local _Humanoid8 = v1123.Character:FindFirstChildOfClass('Humanoid')

                                if _Humanoid8 then
                                    _CurrentCamera3.CameraSubject = _Humanoid8
                                end
                            elseif not v1123 then
                                if PlayerViewCamera then
                                    PlayerViewCamera:Set(false)
                                end

                                _G.ViewCameraOnPlayer = false
                            end

                            wait()
                        end

                        _CurrentCamera3.CameraSubject = _CameraSubject
                    end
                end,
            })

            PlayerTeleport_Section:AddSlider({
                Name = 'Offset',
                Min = 1,
                Max = 20,
                Default = 1,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 1,
                ValueName = 'Teleport Offset',
                Callback = function(p1125)
                    TeleportPlayerOffset = p1125
                end,
                Save = true,
                Flag = 'speed_slider',
            })
            PlayerTeleport_Section:AddDropdown({
                Name = 'Behavior',
                Default = 'Behind',
                Options = {
                    'Behind',
                    'Left',
                    'Right',
                    'Front',
                    'Rotate',
                },
                Callback = function(p1126)
                    _G.PlayerToTeleportDirection = p1126
                end,
            })

            WS_Section = v586:AddSection({
                Name = 'Walkspeed',
            })
            JP_Section = v586:AddSection({
                Name = 'Infinite Power Jump',
            })
            NC_Section = v586:AddSection({
                Name = 'Noclip',
            })

            WS_Section:AddToggle({
                Name = 'Walkspeed',
                Default = false,
                Callback = function(p1127)
                    _G.SuperSpeed = p1127
                end,
                Save = true,
                Flag = 'walkspeed_toggle',
            })
            WS_Section:AddSlider({
                Name = 'Speed',
                Min = 0.1,
                Max = 5,
                Default = 0.1,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 0.01,
                ValueName = '',
                Callback = function(p1128)
                    Multiplier = p1128
                end,
                Save = true,
                Flag = 'speed_slider',
            })
            JP_Section:AddToggle({
                Name = 'Infinite Jump',
                Default = false,
                Callback = function(p1129)
                    _G.InfiniteJump = p1129
                end,
                Save = true,
                Flag = 'infinitejump_toggle',
            })
            JP_Section:AddSlider({
                Name = 'Jump Power',
                Min = 24,
                Max = 1000,
                Default = 24,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 10,
                ValueName = '',
                Callback = function(p1130)
                    _G.InfiniteJumpPower = p1130
                    _LocalPlayer.Character:FindFirstChildOfClass('Humanoid').JumpPower = p1130
                end,
                Save = true,
                Flag = 'jumppower_slider',
            })
            NC_Section:AddToggle({
                Name = 'Noclip',
                Default = false,
                Callback = function(p1131)
                    _G.NoclipToggle = p1131

                    if p1131 then
                        u390()
                    else
                        u391()
                    end
                end,
                Save = true,
                Flag = 'noclip_toggle',
            })

            local u1132 = {
                Color3.new(1, 0, 0),
                Color3.new(1, 0, 0),
                Color3.new(1, 0, 0),
                Color3.new(1, 0, 0),
                Color3.new(1, 0, 0),
                Color3.new(1, 0, 0),
                Color3.new(1, 0, 0),
                Color3.new(1, 0, 0),
                Color3.new(1, 0, 0),
                Color3.new(1, 0, 0),
            }
            local v1133 = v589:AddSection({
                Name = 'Change your entire line color',
            })
            local v1134 = v589:AddSection({
                Name = 'Line Effects',
            })
            local v1135 = v589:AddSection({
                Name = 'Stress Server',
            })

            LagServerToggle = nil
            LagServerToggle = v1135:AddToggle({
                Name = 'Lag Server',
                Default = false,
                Callback = function(p1136)
                    laggg = p1136

                    while laggg do
                        if GetKey() ~= 'Xana' then
                            LagServerToggle:Set(false)
                            u35('Only for premium users! Buy premium in my discord server!')

                            break
                        end

                        for _ = 0, Lag_Intensity do
                            local v1137, v1138, v1139 = ipairs(game:GetService('Players'):GetPlayers())

                            while true do
                                local v1140

                                v1139, v1140 = v1137(v1138, v1139)

                                if v1139 == nil then
                                    break
                                end
                                if v1140.Character.Torso ~= nil then
                                    _CreateGrabLine:FireServer(v1140.Character.Torso, v1140.Character.Torso.CFrame)
                                end
                            end
                        end

                        wait(1)
                    end
                end,
            })

            v1135:AddSlider({
                Name = 'Lag Intensity',
                Min = 1,
                Max = 400,
                Default = 150,
                Color = Color3.fromRGB(255, 255, 255),
                Increment = 1,
                ValueName = 'This can have you kicked or kick someone in the server!',
                Save = true,
                Flag = 'Lag-Intensity',
                Callback = function(p1141)
                    Lag_Intensity = p1141
                end,
            })
            v1133:AddColorpicker({
                Name = 'Choose the color',
                Default = Color3.fromRGB(255, 0, 0),
                Callback = function(p1142)
                    _G.LineColorChangeValue = p1142
                end,
                Save = true,
                Flag = 'changelinecolor_picker',
            })
            v1133:AddButton({
                Name = 'Apply Colors',
                Callback = function()
                    local v1143, v1144, v1145 = pairs(u1132)

                    while true do
                        local v1146

                        v1145, v1146 = v1143(v1144, v1145)

                        if v1145 == nil then
                            break
                        end
                        if v1145 == 1 then
                            u1132[v1145] = ColorSequence.new(_G.LineColorChangeValue, 1)
                        else
                            u1132[v1145] = Color3.new(_G.LineColorChangeValue.R / 255, _G.LineColorChangeValue.G / 255, _G.LineColorChangeValue.B / 255)
                        end
                    end

                    _UpdateLineColorsEvent:FireServer(unpack(u1132))
                end,
            })
            v1134:AddToggle({
                Name = 'Crazy Line (Soft Lag)',
                Default = false,
                Callback = function(p1147)
                    if p1147 then
                        _G.CrazyLine = p1147

                        while _G.CrazyLine do
                            local v1148 = _Players
                            local v1149, v1150, v1151 = pairs(v1148:GetPlayers())

                            while true do
                                local v1152

                                v1151, v1152 = v1149(v1150, v1151)

                                if v1151 == nil then
                                    break
                                end
                                if v1152 and (v1152 ~= _LocalPlayer and v1152.Character) and v1152.Character:FindFirstChild('Torso') then
                                    _CreateGrabLine:FireServer(v1152.Character:FindFirstChild('Torso'), CFrame.new(0.12640380859375, 0.9606337547302246, -0.5000009536743164, 0.9985212683677673, 0, -0.05436277016997337, -6.4805472099749295e-9, 1, -1.1903301100346653e-7, 0.05436277016997337, 5.9604644775390625e-8, 0.9985212683677673))
                                end

                                task.wait()
                            end
                        end
                    else
                        _G.CrazyLine = p1147
                    end
                end,
                Save = true,
                Flag = 'softlagline_toggle',
            })
            v1134:AddToggle({
                Name = 'Invisible Line',
                Default = false,
                Callback = function(p1153)
                    if p1153 then
                        _G.InvisibleLine = p1153
                    else
                        _G.InvisibleLine = p1153
                    end
                end,
                Save = true,
                Flag = 'invisLine_toggle',
            })
            _ContextActionService:BindAction('Godmode', GodModeFTry, false, Enum.KeyCode.T)
            v1134:AddParagraph('Note!', "You can't see the effects line, but others player can see it. And Invisible Line won't work if Crazy Line is Enabled")

            gui2 = Instance.new('ScreenGui')
            gui2.ResetOnSpawn = false
            gui2.Name = 'CAG2'

            if _UserInputService.TouchEnabled then
                gui2.Parent = _LocalPlayer.PlayerGui
            end

            imageButtonTeleport = Instance.new('ImageButton')
            imageButtonTeleport.Size = UDim2.new(0, 70, 0, 70)
            imageButtonTeleport.Position = UDim2.new(1, -267, 1, -90)
            imageButtonTeleport.Image = 'rbxassetid://97166444'
            imageButtonTeleport.BackgroundTransparency = 1
            imageButtonTeleport.ImageTransparency = 0.2
            imageButtonTeleport.ImageColor3 = Color3.fromRGB(142, 142, 142)
            imageButtonTeleport.Parent = gui2
            imageTLabel = Instance.new('ImageLabel')
            imageTLabel.Size = UDim2.new(1, 0, 1, 0)
            imageTLabel.Image = 'rbxassetid://6723742952'
            imageTLabel.BackgroundTransparency = 1
            imageTLabel.Parent = imageButtonTeleport
            imageButtonControl = Instance.new('ImageButton')
            imageButtonControl.Size = UDim2.new(0, 50, 0, 50)
            imageButtonControl.Position = UDim2.new(1, -378, 1, -80)
            imageButtonControl.Image = 'rbxassetid://97166444'
            imageButtonControl.BackgroundTransparency = 1
            imageButtonControl.ImageTransparency = 0.2
            imageButtonControl.ImageColor3 = Color3.fromRGB(142, 142, 142)
            imageButtonControl.Parent = gui2
            imageCLabel = Instance.new('ImageLabel')
            imageCLabel.Size = UDim2.new(1, 0, 1, 0)
            imageCLabel.Image = 'rbxassetid://14436167187'
            imageCLabel.BackgroundTransparency = 1
            imageCLabel.Parent = imageButtonControl
            imageButtonAnchor = Instance.new('ImageButton')
            imageButtonAnchor.Size = UDim2.new(0, 50, 0, 50)
            imageButtonAnchor.Position = UDim2.new(1, -325, 1, -80)
            imageButtonAnchor.Image = 'rbxassetid://97166444'
            imageButtonAnchor.BackgroundTransparency = 1
            imageButtonAnchor.ImageTransparency = 0.2
            imageButtonAnchor.ImageColor3 = Color3.fromRGB(142, 142, 142)
            imageButtonAnchor.Parent = gui2
            imageKLabelDe = Instance.new('ImageLabel')
            imageKLabelDe.Size = UDim2.new(1, 0, 1, 0)
            imageKLabelDe.Image = 'rbxassetid://3040311268'
            imageKLabelDe.BackgroundTransparency = 1
            imageKLabelDe.Parent = imageButtonAnchor

            imageButtonAnchor.InputBegan:Connect(function(p1154, p1155)
                if not p1155 and (u643.TouchEnabled and p1154.UserInputType == Enum.UserInputType.Touch) then
                    anchorfunc()
                end
            end)
            imageButtonTeleport.InputBegan:Connect(function(p1156, p1157)
                if not p1157 and (u643.TouchEnabled and p1156.UserInputType == Enum.UserInputType.Touch) then
                    teleportfunc()
                end
            end)
            imageButtonControl.InputBegan:Connect(function(p1158, p1159)
                if not p1159 and (u643.TouchEnabled and p1158.UserInputType == Enum.UserInputType.Touch) then
                    controlBind('Control(C)', Enum.UserInputState.Begin)
                end
            end)

            local v1160 = v591:AddSection({
                Name = 'Teleport',
            })
            local v1161 = v591:AddSection({
                Name = 'Spawn Toy',
            })
            local v1162 = v591:AddSection({
                Name = 'Anchor Objects',
            })
            local v1163 = v591:AddSection({
                Name = 'Compile Objects',
            })
            local v1164 = v591:AddSection({
                Name = 'Control Player/NPC',
            })

            v1162:AddToggle({
                Name = 'Anchor (K)',
                Default = false,
                Callback = function(p1165)
                    imageButtonAnchor.Visible = p1165
                    imageButtonAnchor.Active = p1165

                    if p1165 then
                        _ContextActionService:BindAction('AnchorK', anchorobject, false, Enum.KeyCode.K)
                    else
                        _ContextActionService:UnbindAction('AnchorK')
                    end
                end,
                Save = true,
                Flag = 'anchorbind_toggle',
            })
            v1162:AddButton({
                Name = 'Unanchor All',
                Callback = function(_)
                    local v1166, v1167, v1168 = pairs(AnchoredObjects)

                    while true do
                        local v1169

                        v1168, v1169 = v1166(v1167, v1168)

                        if v1168 == nil then
                            break
                        end
                        if typeof(v1169.PartAnchored) == 'Instance' then
                            unAnchorObject(v1169.PartAnchored)
                        end
                    end
                end,
            })
            v1163:AddButton({
                Name = 'Compile New Group',
                Callback = function()
                    u335()
                end,
            })

            CompileGroups_Dropdown = v1163:AddDropdown({
                Name = 'Groups',
                Default = '',
                Options = {
                    '',
                },
                Callback = function(p1170)
                    _G.CompileGroupSelected = p1170
                end,
            })

            v1163:AddButton({
                Name = 'Delete Group',
                Callback = function()
                    RemoveGroupCompileFromName(_G.CompileGroupSelected)
                    updateCompileGroupsDropdown(CompileGroups_Dropdown)
                end,
            })
            v1160:AddToggle({
                Name = 'Teleport (Z)',
                Default = false,
                Callback = function(p1171)
                    imageButtonTeleport.Visible = p1171
                    imageButtonTeleport.Active = p1171

                    if p1171 then
                        _ContextActionService:BindAction('Teleport(Z)', u99, false, Enum.KeyCode.Z)
                    else
                        _ContextActionService:UnbindAction('Teleport(Z)')
                    end
                end,
                Save = true,
                Flag = 'teleportbind_toggle',
            })
            v1164:AddToggle({
                Name = 'Control (C)',
                Default = false,
                Callback = function(p1172)
                    imageButtonControl.Visible = p1172
                    imageButtonControl.Active = p1172

                    if p1172 then
                        _ContextActionService:BindAction('Control(C)', controlBind, false, Enum.KeyCode.C)
                    else
                        _ContextActionService:UnbindAction('Control(C)')
                    end
                end,
                Save = true,
                Flag = 'controlbind_toggle',
            })
            v1161:AddDropdown({
                Name = 'Select Toy',
                Default = 'Pallet',
                Options = {
                    'Pallet',
                    'BombMissile',
                },
                Callback = function(p1173)
                    if p1173 == 'Pallet' then
                        _G.SelectedToy = 'PalletLightBrown'
                    else
                        _G.SelectedToy = p1173
                    end
                end,
                Save = true,
                Flag = 'selecttoy_dropdown',
            })
            v1161:AddToggle({
                Name = 'Spawn Toy (TAB)',
                Default = false,
                Callback = function(p1174)
                    if p1174 then
                        _ContextActionService:BindAction('Spawn Toy (TAB)', u92, false, Enum.KeyCode.Tab)
                        _ContextActionService:SetImage('Spawn Toy (TAB)', 'rbxassetid://6723742952')
                        _ContextActionService:SetPosition('Spawn Toy (TAB)', UDim2.new(1, -367, 1, -90))

                        local _SpawnToyTAB = _ContextActionService:GetButton('Spawn Toy (TAB)')

                        if _SpawnToyTAB then
                            _SpawnToyTAB.Size = UDim2.new(0, 70, 0, 70)
                        end
                    else
                        _ContextActionService:UnbindAction('Spawn Toy (TAB)')
                    end
                end,
                Save = true,
                Flag = 'spawntoy_toggle',
            })

            local v1176 = v596:AddSection({
                Name = 'Whitelist',
            })
            local u1178 = v1176:AddDropdown({
                Name = 'Select Player',
                Default = '',
                Options = {
                    '',
                },
                Callback = function(p1177)
                    if p1177 then
                        _G.PlayerToAddWhitelist = string.split(p1177, ' ')[1]
                    end
                end,
            })
            local u1179 = nil

            v1176:AddButton({
                Name = 'Add',
                Callback = function()
                    if not u101(_G.PlayerToAddWhitelist) then
                        table.insert(u389, _G.PlayerToAddWhitelist)
                        u75(u1179, u389)
                    end
                end,
            })

            u1179 = v1176:AddDropdown({
                Name = 'Players in Whitelist',
                Default = '',
                Options = {
                    '',
                },
                Callback = function(p1180)
                    _G.PlayerToRemoveWhitelist = p1180
                end,
            })

            v1176:AddButton({
                Name = 'Remove',
                Callback = function()
                    local v1181, v1182, v1183 = pairs(u389)

                    while true do
                        local v1184

                        v1183, v1184 = v1181(v1182, v1183)

                        if v1183 == nil then
                            break
                        end
                        if v1184 == _G.PlayerToRemoveWhitelist then
                            u389[v1183] = nil
                        end
                    end

                    u75(u1179, u389)
                end,
            })

            local v1185 = v596:AddSection({
                Name = 'Blobman Loopkick',
            })
            local v1186 = v596:AddSection({
                Name = 'Perspective',
            })

            v596:AddSection({
                Name = 'Anchor Objects/Compiled Groups',
            }):AddToggle({
                Name = 'Auto Ownership',
                Default = false,
                Callback = function(p1187)
                    _G.AutoOwnershipAnchor = p1187

                    if p1187 then
                        while _G.AutoOwnershipAnchor do
                            autosetownership()
                            task.wait(0.1)
                        end
                    end
                end,
                Save = true,
                Flag = 'autoownershipanchorconfig_toggle',
            })
            v1185:AddToggle({
                Name = 'Heavy Blobman',
                Default = false,
                Callback = function(p1188)
                    _G.RockBlobman = p1188
                end,
                Save = true,
                Flag = 'heavyblobmanconfig_toggle',
            })

            _G.PerspectiveEffectsAllow = true

            v1186:AddToggle({
                Name = 'Teleport to Camera Position',
                Default = true,
                Callback = function(p1189)
                    _G.PerspectiveTeleportToCameraPos = p1189
                end,
                Save = true,
                Flag = 'perspectiveconfig1_toggle',
            })
            v1186:AddDropdown({
                Name = 'Camera Effect',
                Default = 'Default',
                Options = {
                    'Default',
                    'Old TV',
                },
                Callback = function(p1190)
                    if p1190 == 'Default' then
                        ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                        ImageLabel.BorderSizePixel = 0
                        ImageLabel.Size = UDim2.new(1, 0, 1, 0)
                        ImageLabel.Image = 'rbxassetid://5945121255'
                        ImageLabel.ImageColor3 = Color3.new(0, 0, 0)
                        imagestransparencyeffect = 0.45
                        saturationvalue = -0.6
                        perspectiveON_effect1 = _TweenService:Create(ImageLabel, t1p, {ImageTransparency = imagestransparencyeffect})
                        perspectiveON_effect2 = _TweenService:Create(PerspectiveSaturation, t1p, {Saturation = saturationvalue})
                    elseif p1190 == 'Old TV' then
                        ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                        ImageLabel.BorderSizePixel = 0
                        ImageLabel.Size = UDim2.new(1, 0, 1, 0)
                        ImageLabel.Image = 'rbxassetid://8586979842'
                        ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
                        imagestransparencyeffect = 0.7
                        saturationvalue = -0.3
                        perspectiveON_effect1 = _TweenService:Create(ImageLabel, t1p, {ImageTransparency = imagestransparencyeffect})
                        perspectiveON_effect2 = _TweenService:Create(PerspectiveSaturation, t1p, {Saturation = saturationvalue})
                    end
                end,
                Save = true,
                Flag = 'perspectivevisualeffect_dropdown',
            })

            local v1191 = v592:AddSection({
                Name = 'Loop Players',
            })
            local v1192 = v592:AddSection({
                Name = 'Players in Loop',
            })
            local v1193 = v592:AddSection({
                Name = 'Loop Kill Functions',
            })
            local v1194 = v592:AddSection({
                Name = 'Loop Kick (Blobman)',
            })
            local u1196 = v1191:AddDropdown({
                Name = 'Select Player',
                Default = '',
                Options = {
                    '',
                },
                Callback = function(p1195)
                    if p1195 then
                        _G.PlayerToAdd = string.split(p1195, ' ')[1]
                    end
                end,
            })
            local u1197 = nil
            local u1198 = GetKey() ~= 'Xana' and 3 or 999999

            v1191:AddButton({
                Name = 'Add',
                Callback = function()
                    if not table.find(u66, _G.PlayerToAdd) then
                        if u1198 <= #u66 then
                            u35('You reached the max ammount of players in loop, buy premium to unlock more space!')
                        else
                            table.insert(u66, _G.PlayerToAdd)
                            u75(u1197, u66)
                        end
                    end
                end,
            })

            local u1200 = v1192:AddDropdown({
                Name = 'Players in Loop',
                Default = '',
                Options = {
                    '',
                },
                Callback = function(p1199)
                    _G.PlayerToRemove = p1199
                end,
            })

            v1192:AddButton({
                Name = 'Remove',
                Callback = function()
                    local v1201, v1202, v1203 = pairs(u66)

                    while true do
                        local v1204

                        v1203, v1204 = v1201(v1202, v1203)

                        if v1203 == nil then
                            break
                        end
                        if v1204 == _G.PlayerToRemove then
                            u66[v1203] = nil
                        end
                    end

                    u75(u1200, u66)
                end,
            })

            local function u1211()
                if typeof(_G.LastBlobmanWasSeat) ~= 'Instance' or not _G.LastBlobmanWasSeat.Parent then
                    _G.LastBlobmanWasSeat = u581()
                else
                    local v1205 = GetPlayerCharacter()
                    local _VehicleSeat = _G.LastBlobmanWasSeat:FindFirstChild('VehicleSeat')
                    local v1207, v1208

                    if _VehicleSeat then
                        v1207 = _VehicleSeat:FindFirstChild('ProximityPrompt')
                        v1208 = _VehicleSeat:FindFirstChildOfClass('Weld')
                    else
                        v1208 = nil
                        v1207 = nil
                    end
                    if _LocalPlayer:DistanceFromCharacter(_VehicleSeat.Position) >= 150 then
                        DeleteToyRE:FireServer(_G.LastBlobmanWasSeat)

                        return
                    end
                    if v1205 and (v1208 and v1208.Part1) and not v1208.Part1:IsDescendantOf(v1205) then
                        local _Part14 = v1208.Part1
                        local v1210 = _Players

                        SNOWshipPlayer(v1210:GetPlayerFromCharacter(_Part14.Parent))
                    end
                    if v1207 and _VehicleSeat then
                        fireproximityprompt(v1207)
                        TeleportPlayer(_VehicleSeat.CFrame + Vector3.new(0, 3.5, 0))
                    end
                end
            end

            function CountRealNumberPlayersInLoop()
                local v1212, v1213, v1214 = pairs(u66)
                local v1215 = 0

                while true do
                    local v1216

                    v1214, v1216 = v1212(v1213, v1214)

                    if v1214 == nil then
                        break
                    end
                    if _Players:FindFirstChild(v1216) then
                        v1215 = v1215 + 1
                    end
                end

                return v1215
            end
            function IsThereAnyPlayersInLoopAlive()
                local v1217, v1218, v1219 = pairs(u66)
                local v1220 = false

                while true do
                    local v1221

                    v1219, v1221 = v1217(v1218, v1219)

                    if v1219 == nil then
                        break
                    end
                    if _Players:FindFirstChild(v1221) and v1221.Character then
                        if v1221.Character:FindFirstChildOfClass('Humanoid') and v1221.Character.Humanoid.Health > 0 then
                            v1220 = true
                        end
                    end
                end

                return v1220
            end
            function ResetCharacterStats()
                local v1222, v1223, v1224 = pairs(u66)

                while true do
                    local v1225

                    v1224, v1225 = v1222(v1223, v1224)

                    if v1224 == nil then
                        break
                    end

                    local v1226 = _Players:FindFirstChild(v1225)

                    if v1226 and v1226.Character and v1226.Character:FindFirstChild('HumanoidRootPart') then
                        local _HumanoidRootPart18 = v1226.Character.HumanoidRootPart

                        v1226.Character:SetAttribute('Kick', 0)
                        v1226.Character:SetAttribute('Kicking', nil)
                        v1226.Character:SetAttribute('Kicking2', nil)

                        if _HumanoidRootPart18:FindFirstChild('KickAuraVelocity') then
                            _HumanoidRootPart18.KickAuraVelocity:Destroy()
                        end
                    end
                end
            end
            function verifyPlayerinBlobmanHand()
                local _Humanoid9 = _LocalPlayer.Character:FindFirstChildOfClass('Humanoid')

                if u848() then
                    local _Attachment0 = _Humanoid9.SeatPart.Parent:WaitForChild('LeftDetector'):WaitForChild('LeftWeld').Attachment0
                    local v1230 = _Attachment0 and _Attachment0.Parent and _Players:GetPlayerFromCharacter(_Attachment0.Parent.Parent)

                    if v1230 then
                        return v1230
                    end
                end
            end

            local u1231 = nil

            v1193:AddToggle({
                Name = 'Loop Kill',
                Default = false,
                Callback = function(p1232)
                    _G.LoopKill = p1232

                    if p1232 then
                        while _G.LoopKill do
                            u1231 = GetPlayerCFrame()

                            local v1233, v1234, v1235 = pairs(u66)

                            while true do
                                local v1236

                                v1235, v1236 = v1233(v1234, v1235)

                                if v1235 == nil then
                                    break
                                end

                                local v1237 = _Players:FindFirstChild(v1236)

                                if u859(v1237) then
                                    local _HumanoidRootPart19 = v1237.Character:FindFirstChild('HumanoidRootPart')
                                    local _Head6 = v1237.Character:FindFirstChild('Head')
                                    local _Humanoid10 = v1237.Character:FindFirstChild('Humanoid')

                                    if v1237 and (_HumanoidRootPart19 and _Head6) then
                                        for _ = 0, 50 do
                                            u390()
                                            SNOWship(_HumanoidRootPart19)

                                            if not u859(v1237) or (not _G.LoopKill or (CheckNetworkOwnerShipOnPlayer(v1237) or _HumanoidRootPart19.AssemblyLinearVelocity.Magnitude > 500)) then
                                                _DestroyGrabLine:FireServer(_HumanoidRootPart19)
                                                CreateSkyVelocity(_HumanoidRootPart19)

                                                break
                                            end

                                            task.wait()

                                            if _HumanoidRootPart19.Position.Y <= -12 then
                                                TeleportPlayer(CFrame.new(_HumanoidRootPart19.Position + Vector3.new(0, 5, -15)))
                                            else
                                                TeleportPlayer(CFrame.new(_HumanoidRootPart19.Position + Vector3.new(0, -10, -10)))
                                            end

                                            _Humanoid10.BreakJointsOnDeath = false

                                            _Humanoid10:ChangeState(Enum.HumanoidStateType.Dead)

                                            _Humanoid10.Jump = true
                                            _Humanoid10.Sit = false
                                        end
                                    end
                                end
                            end

                            TeleportPlayer(u1231)
                            task.wait(0.2)
                        end

                        u391()
                        TeleportPlayer(u1231)
                        print('End LoopKill')
                    end
                end,
                Save = true,
                Flag = 'lk_toggle',
            })

            local v1241 = v592:AddSection({
                Name = 'Loop Kick (Ownership)',
            })

            loopkickownertoggle = v1241:AddToggle({
                Name = 'Loop Kick',
                Default = false,
                Callback = function(p1242)
                    _G.LoopKickOwnership = p1242

                    if p1242 then
                        while _G.LoopKickOwnership do
                            if GetKey() ~= 'Xana' then
                                _G.LoopKickOwnership = false

                                u35('Only for premium users! Buy premium in my discord server!')
                                loopkickownertoggle:Set(false)
                            end

                            u1231 = GetPlayerCFrame()

                            local v1243, v1244, v1245 = pairs(u66)

                            while true do
                                local v1246

                                v1245, v1246 = v1243(v1244, v1245)

                                if v1245 == nil then
                                    break
                                end

                                local v1247 = _Players:FindFirstChild(v1246)

                                if u859(v1247) then
                                    local _HumanoidRootPart20 = v1247.Character:FindFirstChild('HumanoidRootPart')
                                    local _Head7 = v1247.Character:FindFirstChild('Head')

                                    v1247.Character:FindFirstChild('Humanoid')

                                    if v1247 and (_HumanoidRootPart20 and _Head7) then
                                        for _ = 0, 50 do
                                            u390()
                                            SNOWship(_HumanoidRootPart20)

                                            if not u859(v1247) or (not _G.LoopKickOwnership or (CheckNetworkOwnerShipOnPlayer(v1247) or _HumanoidRootPart20.AssemblyLinearVelocity.Magnitude > 500)) then
                                                _DestroyGrabLine:FireServer(_HumanoidRootPart20)
                                                wait()
                                                CreateSkyVelocity(_HumanoidRootPart20)

                                                break
                                            end

                                            task.wait()

                                            if _HumanoidRootPart20.Position.Y <= -12 then
                                                TeleportPlayer(CFrame.new(_HumanoidRootPart20.Position + Vector3.new(0, 5, -15)))
                                            else
                                                TeleportPlayer(CFrame.new(_HumanoidRootPart20.Position + Vector3.new(0, -10, -10)))
                                            end
                                        end
                                    end
                                end
                            end

                            TeleportPlayer(u1231)
                            task.wait(0.2)
                        end

                        u391()
                        TeleportPlayer(u1231)
                    end
                end,
                Save = true,
                Flag = 'lkickowner_toggle',
            })

            v1241:AddDropdown({
                Name = 'Kick Type',
                Default = 'Go to the heaven!',
                Options = {
                    'Go to the heaven!',
                },
                Callback = function(p1250)
                    _G.LoopKickOwnerType = p1250
                end,
                Save = true,
                Flag = 'loopkickownershiptype_dropdown',
            })

            loopRagdoll = v1193:AddToggle({
                Name = 'Loop Ragdoll',
                Default = false,
                Callback = function(p1251)
                    _G.LoopRagdoll = p1251

                    if p1251 then
                        while _G.LoopRagdoll do
                            if GetKey() ~= 'Xana' then
                                loopRagdoll:Set(false)

                                _G.LoopRagdoll = false

                                u35('Only for premium users! Buy premium in my discord server!')

                                break
                            end

                            local v1252, v1253, v1254 = pairs(u66)

                            while true do
                                local v1255

                                v1254, v1255 = v1252(v1253, v1254)

                                if v1254 == nil then
                                    break
                                end

                                local v1256 = _Players:FindFirstChild(v1255)

                                if u865(v1256) then
                                    local _Character13 = v1256.Character
                                    local _HumanoidRootPart21 = v1256.Character:FindFirstChild('HumanoidRootPart')
                                    local _Ragdolled2 = _Character13:FindFirstChildOfClass('Humanoid'):FindFirstChild('Ragdolled')

                                    if _HumanoidRootPart21 and (_Ragdolled2 and not _Ragdolled2.Value) then
                                        u519(_HumanoidRootPart21)
                                        task.wait(0.015)
                                    end
                                end
                            end

                            task.wait()
                        end
                    end
                end,
            })
            loopFire = v1193:AddToggle({
                Name = 'Loop Fire',
                Default = false,
                Callback = function(p1260)
                    _G.LoopFire = p1260

                    if p1260 then
                        while _G.LoopFire do
                            if GetKey() ~= 'Xana' then
                                loopFire:Set(false)

                                _G.LoopFire = false

                                u35('Only for premium users! Buy premium in my discord server!')

                                break
                            end

                            local v1261, v1262, v1263 = pairs(u66)

                            while true do
                                local v1264

                                v1263, v1264 = v1261(v1262, v1263)

                                if v1263 == nil then
                                    break
                                end

                                local v1265 = _Players:FindFirstChild(v1264)

                                if u865(v1265) then
                                    local _ = v1265.Character
                                    local _HumanoidRootPart22 = v1265.Character:FindFirstChild('HumanoidRootPart')
                                    local v1267

                                    if _HumanoidRootPart22:FindFirstChild('FirePlayerPart') and _HumanoidRootPart22.FirePlayerPart:FindFirstChild('CanBurn') then
                                        v1267 = _HumanoidRootPart22.FirePlayerPart.CanBurn.Value
                                    else
                                        v1267 = nil
                                    end
                                    if _HumanoidRootPart22 and (v1265 and not (IsPlayerInsideSafeZone(v1265) or v1267)) then
                                        u550(_HumanoidRootPart22)
                                        task.wait(0.015)
                                    end
                                end
                            end

                            task.wait()
                        end
                    end
                end,
            })

            local function u1282(p1268, p1269)
                local _Humanoid11 = _LocalPlayer.Character:FindFirstChildOfClass('Humanoid')

                if u848() then
                    local _Parent7 = _Humanoid11.SeatPart.Parent
                    local v1272 = _Players:FindFirstChild(p1268)

                    if v1272 and v1272.Character and (v1272.Character:FindFirstChild('HumanoidRootPart') and (_Parent7 and not u55(v1272))) then
                        local v1273 = {
                            _Parent7.LeftDetector,
                            v1272.Character.HumanoidRootPart,
                            _Parent7.LeftDetector.LeftWeld,
                        }
                        local v1274 = {
                            _Parent7.LeftDetector.LeftWeld,
                            v1272.Character.HumanoidRootPart,
                        }

                        CreatureGrab = _Parent7.BlobmanSeatAndOwnerScript.CreatureGrab

                        local _CreatureDrop = _Parent7.BlobmanSeatAndOwnerScript.CreatureDrop

                        if _Parent7 then
                            if p1269 == 1 then
                                if _Parent7.Parent ~= u19 then
                                    u5:MakeNotification({
                                        Name = 'You need to be seated on Blobman',
                                        Content = 'The Blobman needs to be your own toy',
                                        Image = 'rbxassetid://4483345998',
                                        Time = 5,
                                    })
                                else
                                    task.wait(0.2)
                                    DeleteToyRE:FireServer(_Parent7)
                                end
                            elseif p1269 == 2 then
                                CreatureGrab:FireServer(unpack(v1273))
                                task.wait(0.155)

                                _Humanoid11.Sit = false
                            elseif p1269 == 3 and not (v1272.Character:GetAttribute('Kicking') or v1272.Character:GetAttribute('Kicking2')) then
                                local v1276 = _Players:FindFirstChild(p1268)
                                local _Character14 = v1276.Character
                                local _HumanoidRootPart23 = _Character14.HumanoidRootPart
                                local _ = _Character14.Head
                                local _Humanoid12 = _Character14:FindFirstChildOfClass('Humanoid')
                                local v1280 = nil

                                _Character14:SetAttribute('Kicking', true)

                                if _HumanoidRootPart23:FindFirstChild('FlingAuraVelocity') then
                                    _HumanoidRootPart23.FlingAuraVelocity:Destroy()
                                end

                                print('Kick')

                                for _ = 0, 50 do
                                    if not u848() or CheckNetworkOwnerShipOnPlayer(v1276) then
                                        break
                                    end
                                    if verifyPlayerinBlobmanHand() == v1276 then
                                        _CreatureDrop:FireServer(unpack(v1274))

                                        break
                                    end

                                    CreatureGrab:FireServer(unpack(v1273))
                                    task.wait()
                                end

                                print('End Loop Here!')

                                for _ = 0, 25 do
                                    if SNOWshipPlayer(v1276) then
                                        if not _HumanoidRootPart23:FindFirstChild('KickAuraVelocity') then
                                            v1280 = Instance.new('BodyVelocity', _HumanoidRootPart23)
                                            v1280.Name = 'KickAuraVelocity'
                                            v1280.MaxForce = Vector3.new(0, 12500, 0)
                                            v1280.Velocity = Vector3.new(0, 100, 0)
                                        end

                                        local v1281 = 0

                                        while u848() and v1281 < 100 do
                                            if _Humanoid12.FloorMaterial == Enum.Material.Air and _LocalPlayer:DistanceFromCharacter(_HumanoidRootPart23.Position) > 100 then
                                                _Character14:SetAttribute('Kicking2', true)
                                                _DestroyGrabLine:FireServer(_HumanoidRootPart23)
                                                CreatureGrab:FireServer(unpack(v1273))
                                                print('Destroyed!')

                                                break
                                            end

                                            SNOWshipPlayer(v1276)

                                            v1281 = v1281 + 1

                                            task.wait()
                                        end

                                        break
                                    end
                                    if not u848() then
                                        break
                                    end

                                    task.wait()
                                end

                                if v1280 then
                                    v1280:Destroy()
                                end

                                _Character14:SetAttribute('Kicking', nil)
                            elseif not p1269 then
                                CreatureGrab:FireServer(unpack(v1273))
                            end
                        end
                    end
                else
                    u5:MakeNotification({
                        Name = 'You need to be seated on Blobman',
                        Content = 'Please, sit on any Blobman',
                        Image = 'rbxassetid://4483345998',
                        Time = 5,
                    })
                end
            end

            v1194:AddToggle({
                Name = 'Loop Kick (Blobman)',
                Default = false,
                Callback = function(p1283)
                    if p1283 then
                        _G.LoopKick = p1283

                        while _G.LoopKick do
                            local v1284, v1285, v1286 = pairs(u66)

                            while true do
                                local v1287

                                v1286, v1287 = v1284(v1285, v1286)

                                if v1286 == nil then
                                    break
                                end
                                if _Players:FindFirstChild(v1287) then
                                    if u848() then
                                        u1282(v1287, 3)
                                    else
                                        u1211()
                                    end
                                end
                            end

                            task.wait()
                        end
                    else
                        _G.LoopKick = p1283
                    end
                end,
                Save = true,
                Flag = 'lkick_toggle',
            })

            function blobmangraball()
                local v1288 = _Players
                local v1289, v1290, v1291 = pairs(v1288:GetPlayers())

                while true do
                    local v1292

                    v1291, v1292 = v1289(v1290, v1291)

                    if v1291 == nil then
                        break
                    end
                    if not u55(v1292) and (v1292 ~= _LocalPlayer and v1292.Character) and (v1292.Character:FindFirstChild('HumanoidRootPart') and not (u101(v1292.Name) and _G.WhitelistFriends2) and _LocalPlayer.Character and _LocalPlayer.Character:FindFirstChildOfClass('Humanoid')) then
                        local _Parent8 = _LocalPlayer.Character:FindFirstChildOfClass('Humanoid').SeatPart.Parent
                        local v1294 = {
                            _Parent8:WaitForChild('LeftDetector'),
                            v1292.Character:FindFirstChild('HumanoidRootPart'),
                            _Parent8:WaitForChild('LeftDetector'):WaitForChild('LeftWeld'),
                        }

                        _Parent8:WaitForChild('BlobmanSeatAndOwnerScript'):WaitForChild('CreatureGrab'):FireServer(unpack(v1294))
                    end

                    task.wait()
                end
            end

            PlayerToSelect = LongReachGrab_Player:AddDropdown({
                Name = 'Select Player',
                Default = '',
                Options = {
                    '',
                },
                Callback = function(p1295)
                    local v1296 = string.split(p1295, ' ')

                    _G.PlayerToLongGrab = v1296[1]
                end,
            })

            LongReachGrab_Player:AddButton({
                Name = 'Lock',
                Callback = function()
                    u1282(_G.PlayerToLongGrab, 2)
                end,
            })
            LongReachGrab_Player:AddButton({
                Name = 'Bring',
                Callback = function()
                    u1282(_G.PlayerToLongGrab)
                end,
            })
            LongReachGrab_Player:AddButton({
                Name = 'Kick',
                Callback = function()
                    u1282(_G.PlayerToLongGrab, 3)
                end,
            })

            local v1297 = LongReachGrab_Player:AddSection({
                Name = 'Destroy Everything',
            })
            local u1298 = nil

            u1298 = v1297:AddToggle({
                Name = 'Destroy Server',
                Default = false,
                Callback = function(p1299)
                    if p1299 then
                        _G.BringAllLongReach = true

                        if GetKey() ~= 'Xana' and _InPlot.Value then
                            u1298:Set(false)
                            u35("You can't use destroy server inside a house!, buy premium to be able to do that!")

                            return
                        end
                        if u848() then
                            while _G.BringAllLongReach do
                                if u848() then
                                    blobmangraball()
                                else
                                    task.wait(1)
                                end
                            end
                        else
                            u1298:Set(false)
                            u5:MakeNotification({
                                Name = 'You need to be seated on Blobman',
                                Content = 'Please, sit on any Blobman',
                                Image = 'rbxassetid://4483345998',
                                Time = 5,
                            })
                        end
                    else
                        _G.BringAllLongReach = false
                    end
                end,
                Save = true,
                Flag = 'BringAllLongReach_toggle',
            })
            u1298 = v1297:AddToggle({
                Name = 'Whitelist Friends',
                Default = false,
                Callback = function(p1300)
                    _G.WhitelistFriends2 = p1300
                end,
                Save = true,
                Flag = 'Whitelistfreinds2_toggle',
            })
            apagarfogo = _Workspace.Map.Hole.PoisonBigHole.ExtinguishPart
            apagarfogo.Size = Vector3.new(0.5, 0.5, 0.5)
            apagarfogo.Transparency = 1
            apagarfogo.Tex.Transparency = 1

            _Workspace.ChildAdded:Connect(function(p1301)
                if p1301.Name == 'GrabParts' then
                    local _Part15 = p1301.GrabPart.WeldConstraint.Part1
                    local u1303 = nil

                    if _Part15 then
                        if u55(_Part15.Parent) then
                            return
                        end
                        if _G.InvisibleLine then
                            _CreateGrabLine:FireServer()
                        end
                        if _G.SuperStrength then
                            u1303 = Instance.new('BodyVelocity', _Part15)
                            u1303.MaxForce = Vector3.new(0, 0, 0)
                            u1303.Velocity = Vector3.new()
                            u1303.Name = 'SuperStrength'
                        end
                        if _G.MasslessGrab then
                            task.spawn(function()
                                local _AlignOrientation = p1301.DragPart.AlignOrientation
                                local _AlignPosition = p1301.DragPart.AlignPosition

                                while _G.MasslessGrab do
                                    _AlignOrientation.MaxTorque = 1e46
                                    _AlignOrientation.Responsiveness = 20099
                                    _AlignPosition.MaxForce = 1e51
                                    _AlignPosition.Responsiveness = 20099

                                    task.wait(0.245)
                                end

                                _AlignOrientation.MaxTorque = 600000
                                _AlignOrientation.Responsiveness = 30
                                _AlignPosition.MaxForce = 60000
                                _AlignPosition.Responsiveness = 40
                            end)
                        end
                        if _G.NoclipGrab and not _Part15.Anchored then
                            task.spawn(function()
                                if _Part15.Parent and _Part15.Parent:IsA('Model') then
                                    local v1306 = _Part15.Parent:GetDescendants()
                                    local _Humanoid13 = _Part15.Parent:FindFirstChildOfClass('Humanoid')
                                    local v1308, v1309, v1310 = pairs(v1306)
                                    local v1311 = {}

                                    while true do
                                        local v1312

                                        v1310, v1312 = v1308(v1309, v1310)

                                        if v1310 == nil then
                                            break
                                        end
                                        if v1312:IsA('BasePart') or (v1312:IsA('Part') or v1312:IsA('MeshPart')) then
                                            v1311[v1312] = v1312.CanCollide
                                        end
                                    end
                                    while p1301.Parent do
                                        local v1313, v1314, v1315 = pairs(v1306)

                                        while true do
                                            local v1316

                                            v1315, v1316 = v1313(v1314, v1315)

                                            if v1315 == nil then
                                                break
                                            end
                                            if v1316:IsA('BasePart') or (v1316:IsA('Part') or v1316:IsA('MeshPart')) then
                                                v1316.CanCollide = false
                                            end
                                        end

                                        wait(0.214)
                                    end

                                    if _Humanoid13 then
                                        task.wait(0.5)
                                    end

                                    local v1317, v1318, v1319 = pairs(v1306)

                                    while true do
                                        local v1320

                                        v1319, v1320 = v1317(v1318, v1319)

                                        if v1319 == nil then
                                            break
                                        end
                                        if v1320:IsA('BasePart') or (v1320:IsA('Part') or v1320:IsA('MeshPart')) then
                                            v1320.CanCollide = v1311[v1320]
                                        end
                                    end
                                end
                            end)
                        end
                        if _G.PerspectiveGrab and not _Part15.Anchored then
                            task.spawn(function()
                                local v1321 = GetPlayerCharacter()

                                _CreateGrabLine:FireServer()

                                local u1322, u1323

                                if v1321 then
                                    u1322 = v1321:FindFirstChildOfClass('Humanoid')
                                    u1323 = v1321:FindFirstChild('HumanoidRootPart')
                                else
                                    u1322 = nil
                                    u1323 = nil
                                end

                                local _Part = Instance.new('Part', _Workspace)

                                _Part.Anchored = true
                                _Part.CanCollide = false
                                _Part.Transparency = 1
                                _Part.CanQuery = false
                                _Part.Size = Vector3.new()
                                _Part.CFrame = workspace.CurrentCamera.CFrame
                                workspace.CurrentCamera.CameraType = Enum.CameraType.Follow
                                workspace.CurrentCamera.CameraSubject = _Part

                                if u999 then
                                    u999:Disconnect()
                                end
                                if u1322 and u1323 then
                                    local v1325 = GetPlayerCFrame()

                                    u630(true)

                                    local u1326 = nil
                                    local u1327 = nil
                                    local u1328 = nil
                                    local u1329 = nil
                                    local u1330 = nil
                                    local u1331 = nil
                                    local u1332 = nil

                                    u999 = _RunService.Heartbeat:Connect(function(p1333)
                                        u1326 = u1322.MoveDirection * (u1000 * p1333)
                                        u1327 = _Part.CFrame
                                        u1328 = workspace.CurrentCamera.CFrame
                                        u1329 = u1327:ToObjectSpace(u1328).Position
                                        u1328 = u1328 * CFrame.new(-u1329.X, -u1329.Y, -u1329.Z + 1)
                                        u1330 = u1328.Position
                                        u1331 = u1327.Position
                                        u1332 = CFrame.new(u1330, Vector3.new(u1331.X, u1330.Y, u1331.Z)):VectorToObjectSpace(u1326)
                                        _Part.CFrame = CFrame.new(u1331) * (u1328 - u1330) * CFrame.new(u1332)
                                        u1323.CFrame = CFrame.new(527, 123, -376)
                                    end)

                                    while p1301.Parent do
                                        task.wait()
                                    end

                                    local _CFrame = workspace.CurrentCamera.CFrame

                                    u630(false)

                                    workspace.CurrentCamera.CameraSubject = _LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                                    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

                                    if u999 then
                                        u999:Disconnect()
                                    end
                                    if _G.PerspectiveTeleportToCameraPos then
                                        u1323.CFrame = _CFrame
                                    else
                                        u1323.CFrame = v1325
                                    end
                                end
                            end)
                        end

                        task.spawn(function()
                            if u1303 then
                                if not _LocalPlayer.PlayerGui:FindFirstChild('ContextActionGui') then
                                    return
                                end

                                local v1335 = nil
                                local u1336 = nil
                                local u1337 = nil

                                while v1335 == nil and p1301.Parent do
                                    local v1338, v1339, v1340 = pairs(game.Players.LocalPlayer.PlayerGui.ContextActionGui:GetDescendants())

                                    while true do
                                        local v1341

                                        v1340, v1341 = v1338(v1339, v1340)

                                        if v1340 == nil then
                                            break
                                        end
                                        if v1341:IsA('ImageLabel') and v1341.Image == 'http://www.roblox.com/asset/?id=9603678090' then
                                            v1335 = v1341.Parent
                                        end
                                    end

                                    task.wait()
                                end

                                v1335.Active = true

                                if v1335 then
                                    u1336 = v1335.MouseButton1Down:Connect(function()
                                        print('Launched Mobile!')

                                        pressedStrength = true
                                        u1303.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                        u1303.Velocity = workspace.CurrentCamera.CFrame.lookVector * _G.Strength
                                    end)
                                end

                                local _ = p1301:GetPropertyChangedSignal('Parent'):Connect(function()
                                    if not p1301.Parent then
                                        _Debris:AddItem(u1303, 1)

                                        if u1336 then
                                            u1336:Disconnect()
                                        end

                                        u1337:Disconnect()
                                    end
                                end)
                            end
                        end)
                        task.spawn(function()
                            if u1303 then
                                local u1342 = nil

                                u1342 = p1301:GetPropertyChangedSignal('Parent'):Connect(function()
                                    if not p1301.Parent then
                                        if _UserInputService:GetLastInputType() ~= Enum.UserInputType.MouseButton2 or not _G.SuperStrength then
                                            if _UserInputService:GetLastInputType() == Enum.UserInputType.MouseButton1 then
                                                u1303:Destroy()
                                            end
                                        else
                                            print('Launched!')

                                            pressedStrength = true
                                            u1303.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                            u1303.Velocity = workspace.CurrentCamera.CFrame.lookVector * _G.Strength

                                            _Debris:AddItem(u1303, 1)
                                        end

                                        u1342:Disconnect()
                                    end
                                end)
                            end
                        end)

                        if _G.Poison_Grab then
                            task.spawn(function()
                                if _Part15.Parent:FindFirstChildOfClass('Humanoid') then
                                    local _Head8 = _Part15.Parent.Head

                                    while p1301.Parent and _G.Poison_Grab do
                                        _PoisonHurtPart.CFrame = _Head8.CFrame
                                        _PoisonHurtPart2.CFrame = _Head8.CFrame
                                        _PoisonHurtPart3.CFrame = _Head8.CFrame

                                        task.wait()

                                        _PoisonHurtPart3.Position = Vector3.new(0, -50, 0)
                                        _PoisonHurtPart2.Position = Vector3.new(0, -50, 0)
                                        _PoisonHurtPart.Position = Vector3.new(0, -50, 0)
                                    end
                                end
                            end)
                        end
                        if _G.Burn_Grab then
                            task.spawn(function()
                                while p1301.Parent and _G.Burn_Grab do
                                    if _Part15.Parent:FindFirstChildOfClass('Humanoid') then
                                        u550(_Part15.Parent.HumanoidRootPart)
                                    elseif _Part15.Parent:FindFirstChild('FireDetector') then
                                        u550(_Part15.Parent.FireDetector)
                                    else
                                        u550(_Part15)
                                    end

                                    task.wait()
                                end
                            end)
                        end
                        if _G.Radiactive_Grab then
                            task.spawn(function()
                                if _Part15.Parent:FindFirstChildOfClass('Humanoid') then
                                    while p1301.Parent and _G.Radiactive_Grab do
                                        _OuterUFO.Position = _Part15.Position

                                        task.wait()
                                    end

                                    _OuterUFO.Position = Vector3.new(0, -50, 0)
                                end
                            end)
                        end
                        if _G.Death_Grab then
                            task.spawn(function()
                                if _Part15.Parent:FindFirstChildOfClass('Humanoid') then
                                    local _Humanoid14 = _Part15.Parent:FindFirstChildOfClass('Humanoid')
                                    local _ = _Part15.Parent.HumanoidRootPart

                                    while _Part15.Parent do
                                        local v1345 = _Players

                                        if CheckNetworkOwnerShipOnPlayer(v1345:GetPlayerFromCharacter(_Part15.Parent)) then
                                            _Humanoid14.BreakJointsOnDeath = false

                                            _Humanoid14:ChangeState(Enum.HumanoidStateType.Dead)

                                            _Humanoid14.Jump = true
                                            _Humanoid14.Sit = false

                                            if _Humanoid14:GetStateEnabled(Enum.HumanoidStateType.Dead) then
                                                _DestroyGrabLine:FireServer(_Part15)
                                            end
                                        end

                                        task.wait()
                                    end
                                end
                            end)
                        end
                    end
                end
            end)
            workspace.DescendantAdded:Connect(function(p1346)
                if p1346.Name == 'PartOwner' and p1346.Parent.Name == 'Head' then
                    local _HumanoidRootPart24 = p1346.Parent.Parent:FindFirstChild('HumanoidRootPart')

                    if _HumanoidRootPart24:FindFirstChild('KickAuraP') then
                        _HumanoidRootPart24.KickAuraP:Destroy()
                    end
                    if _HumanoidRootPart24:FindFirstChild('KickAuraP1') then
                        _HumanoidRootPart24.KickAuraP1:Destroy()
                    end
                    if _HumanoidRootPart24:FindFirstChild('SkyVelocity') then
                        _HumanoidRootPart24.SkyVelocity:Destroy()
                    end
                end
                if p1346.Name == 'TimeRemainingNum' and p1346.Parent.Value == _LocalPlayer.Name then
                    _G.RemainingTimeInHouse = p1346
                end
            end)
            _IsHeld.Changed:Connect(function(p1348)
                if p1348 == true and (not u55(_Players:FindFirstChild(u30)) and _G.AntiGrab) then
                    local _HumanoidRootPart25 = (_LocalPlayer.Character or _LocalPlayer.CharacterAdded:Wait()):WaitForChild('HumanoidRootPart')

                    if _IsHeld.Value then
                        local u1350 = nil

                        u1350 = _RunService.Heartbeat:Connect(function()
                            if _IsHeld.Value then
                                _HumanoidRootPart25.Velocity = Vector3.new()
                                _HumanoidRootPart25.Anchored = true

                                _Struggle:FireServer(_LocalPlayer)
                                _RagdollRemote:FireServer(_HumanoidRootPart25, 0)
                            else
                                _HumanoidRootPart25.Velocity = Vector3.new()
                                _HumanoidRootPart25.Anchored = false

                                u1350:Disconnect()
                            end
                        end)
                    end
                end
            end)

            function IsReallyBeingHeld()
                if _IsHeld.Value and not _G.AntiGrab then
                    return true
                end
                if _IsHeld.Value and u55(_Players:FindFirstChild(u30)) then
                    return true
                end
            end
            function setMasslessFalse(p1351)
                local v1352, v1353, v1354 = ipairs(p1351:GetDescendants())

                while true do
                    local v1355

                    v1354, v1355 = v1352(v1353, v1354)

                    if v1354 == nil then
                        break
                    end
                    if v1355:IsA('BasePart') then
                        v1355.Massless = false
                    end
                end
            end
            function enforceMasslessFalse(p1356)
                p1356.DescendantAdded:Connect(function(p1357)
                    if p1357:IsA('BasePart') then
                        p1357:GetPropertyChangedSignal('Massless'):Connect(function()
                            if p1357.Massless then
                                p1357.Massless = false
                            end
                        end)
                    end
                end)

                local v1358, v1359, v1360 = ipairs(p1356:GetDescendants())

                while true do
                    local u1361

                    v1360, u1361 = v1358(v1359, v1360)

                    if v1360 == nil then
                        break
                    end
                    if u1361:IsA('BasePart') then
                        u1361:GetPropertyChangedSignal('Massless'):Connect(function()
                            if u1361.Massless then
                                u1361.Massless = false
                            end
                        end)
                    end
                end
            end
            function reconnect()
                local v1362 = _LocalPlayer.Character or _LocalPlayer.CharacterAdded:Wait()
                local u1363 = v1362:FindFirstChildWhichIsA('Humanoid') or v1362:WaitForChild('Humanoid')
                local _HumanoidRootPart26 = v1362:WaitForChild('HumanoidRootPart')

                v1362:WaitForChild('Head')

                CharacterRaycastFilter.FilterDescendantsInstances[1] = v1362
                COAroundPParams.FilterDescendantsInstances[1] = v1362
                scriptToGetSenv = v1362:WaitForChild('GrabbingScript')

                if scriptToGetSenv and getsenv then
                    senv = getsenv(scriptToGetSenv)
                end

                local _CanBurn = _HumanoidRootPart26:WaitForChild('FirePlayerPart'):WaitForChild('CanBurn')
                local _Ragdolled3 = u1363:WaitForChild('Ragdolled')

                if GetKey() == 'Xana' then
                    local u1367 = _HumanoidRootPart26 and _HumanoidRootPart26:FindFirstChild('RootAttachment')

                    if u1367 then
                        task.delay(1, function()
                            u1367:Destroy()
                        end)
                    end

                    v1362.DescendantAdded:Connect(function(p1368)
                        if p1368.Name == 'PartOwner' and (p1368.Parent.Name ~= 'Head' and _G.AntiKick) then
                            _RagdollRemote:FireServer(_HumanoidRootPart26, 0)
                        end
                    end)
                    setMasslessFalse(v1362)
                    enforceMasslessFalse(v1362)
                end

                local _BodyPosition9 = Instance.new('BodyPosition', _HumanoidRootPart26)

                _BodyPosition9.MaxForce = Vector3.new(0, 0, 0)
                u1363.JumpPower = _G.InfiniteJumpPower

                if _G.NoclipToggle then
                    u390()
                end

                v1362.DescendantAdded:Connect(function(p1370)
                    if p1370.Name == 'PartOwner' then
                        u30 = tostring(p1370.Value)

                        if _G.AutoAttacker then
                            local u1371 = _Players:FindFirstChild(u30)
                            local u1372 = nil
                            local u1373 = nil

                            if u1371 and u1371.Character then
                                local _Character15 = u1371.Character

                                if _Character15 then
                                    u1372 = _Character15:FindFirstChildOfClass('Humanoid')
                                    u1373 = _Character15:FindFirstChild('HumanoidRootPart')
                                end
                            end
                            if u1371 and (u55(u1371) == false and u1371 ~= _LocalPlayer) then
                                local v1375 = nil
                                local u1376 = nil
                                local v1377 = false
                                local v1378

                                if _G.CounterMode == 'Repulsion' or not _G.CounterMode then
                                    v1378 = function()
                                        u1376 = lookAt(_LocalPlayer.Character.HumanoidRootPart.Position, u1373.Position)

                                        local _BodyVelocity7 = Instance.new('BodyVelocity', u1371.Character.HumanoidRootPart)

                                        _BodyVelocity7.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                        _BodyVelocity7.Velocity = Vector3.new(u1376.lookVector.X, 0.5, u1376.lookVector.Z) * 100

                                        wait()
                                        _BodyVelocity7:Destroy()
                                        _DestroyGrabLine:FireServer(u1373)
                                    end
                                elseif _G.CounterMode ~= 'Freeze' then
                                    if _G.CounterMode ~= 'Kick' then
                                        v1378 = _G.CounterMode == 'Death' and function()
                                            local v1380 = u1372

                                            if v1380 then
                                                CreateSkyVelocity(u1373)

                                                for _ = 0, 20 do
                                                    v1380.BreakJointsOnDeath = false

                                                    v1380:ChangeState(Enum.HumanoidStateType.Dead)

                                                    v1380.Jump = true
                                                    v1380.Sit = true
                                                end

                                                task.wait()
                                                _DestroyGrabLine:FireServer(u1373)
                                            end
                                        end or v1375
                                    else
                                        v1378 = function()
                                            CreateSkyVelocity(u1373)
                                            wait(1)
                                            _DestroyGrabLine:FireServer(u1373)
                                        end
                                    end
                                else
                                    v1378 = function()
                                        local v1381 = u1372

                                        if v1381 then
                                            v1381.WalkSpeed = 0
                                            v1381.Sit = false
                                            v1381.JumpPower = 0
                                        end
                                    end
                                end
                                if v1377 then
                                    for _ = 1, 50 do
                                        SNOWshipPermanentPlayer(u1371, v1378)
                                        task.wait()
                                    end
                                else
                                    for _ = 1, 50 do
                                        if SNOWshipPlayer(u1371, v1378) then
                                            break
                                        end

                                        task.wait()
                                    end
                                end
                            end
                        end
                    end
                end)
                _CanBurn.Changed:Connect(function(p1382)
                    if p1382 and _G.AntiBurn then
                        while _CanBurn.Value do
                            if firetouchinterest then
                                firetouchinterest(_HumanoidRootPart26.FirePlayerPart, apagarfogo, 0)
                                task.wait()
                                firetouchinterest(_HumanoidRootPart26.FirePlayerPart, apagarfogo, 1)
                            else
                                apagarfogo.CFrame = _HumanoidRootPart26.FirePlayerPart.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))

                                task.wait()

                                apagarfogo.Position = Vector3.new(0, -100, 0)
                            end
                        end
                    end
                end)
                _Ragdolled3.Changed:Connect(function(p1383)
                    if p1383 and _G.AntiExplosion then
                        while _Ragdolled3.Value do
                            if IsReallyBeingHeld() then
                                _HumanoidRootPart26.Anchored = false
                            else
                                _HumanoidRootPart26.Anchored = true
                                _HumanoidRootPart26.Velocity = Vector3.new()
                            end

                            task.wait()
                        end

                        _HumanoidRootPart26.Velocity = Vector3.new()
                        _HumanoidRootPart26.Anchored = false
                    end
                end)
                u1363.Changed:Connect(function(p1384)
                    if p1384 == 'Sit' and u1363.Sit == true then
                        if u1363.SeatPart == nil or tostring(u1363.SeatPart.Parent) ~= 'CreatureBlobman' then
                            if u1363.SeatPart == nil and _G.AntiGrab then
                                u1363:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)

                                u1363.Sit = false
                            end
                        elseif _G.RockBlobman then
                            _BodyPosition9.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            _BodyPosition9.Position = _HumanoidRootPart26.Position
                        end
                    end
                    if p1384 == 'SeatPart' and u1363.SeatPart == nil then
                        ResetCharacterStats()

                        if _HumanoidRootPart26:FindFirstChild('BodyPositionFloat') then
                            _HumanoidRootPart26.BodyPositionFloat:Destroy()
                        end

                        _BodyPosition9.MaxForce = Vector3.new(0, 0, 0)
                    end
                    if p1384 == 'MoveDirection' and (_G.RockBlobman and u848()) then
                        _BodyPosition9.Position = _HumanoidRootPart26.Position

                        if u1363.MoveDirection.Magnitude <= 0 then
                            _BodyPosition9.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        else
                            _BodyPosition9.MaxForce = Vector3.new(0, 0, 0)
                        end
                    end
                end)

                local v1385 = u1363 and u1363:WaitForChild('Animator', 1)

                if v1385 then
                    TypeAnimation = v1385:LoadAnimation(typeAnimation)
                    FlailAnimation = v1385:LoadAnimation(flailAnimation)
                end
            end

            _UserInputService.JumpRequest:Connect(function()
                if _G.InfiniteJump then
                    _LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState('Jumping')
                end
            end)
            _RunService.Heartbeat:Connect(function()
                if _G.SuperSpeed then
                    _LocalPlayer.Character.HumanoidRootPart.CFrame = _LocalPlayer.Character.HumanoidRootPart.CFrame + _LocalPlayer.Character:FindFirstChildOfClass('Humanoid').MoveDirection * Multiplier
                end
            end)

            function CanRemoveStickyPart(_, p1386, _)
                return p1386:GetAttribute('Kicking2') and true or nil
            end

            task.spawn(function()
                while task.wait() do
                    local v1387 = _Players
                    local v1388, v1389, v1390 = pairs(v1387:GetPlayers())

                    while true do
                        local v1391

                        v1390, v1391 = v1388(v1389, v1390)

                        if v1390 == nil then
                            break
                        end
                        if u857(v1391) then
                            local _Character16 = v1391.Character
                            local _HumanoidRootPart27 = v1391.Character:FindFirstChild('HumanoidRootPart')

                            if v1391 and (_Character16 and (_HumanoidRootPart27 and CanRemoveStickyPart(v1391, _Character16, _HumanoidRootPart27))) then
                                u483(_HumanoidRootPart27)
                            end
                        end
                    end
                end
            end)

            function PlayerRemoving_Added(_)
                u65(PlayerToSelect)
                u65(u1196)
                u65(u1178)
                u65(PlayerToTeleport)
                u83(PlayerToTarget)
            end

            local _ = PlayerRemoving_Added

            _Players.PlayerAdded:Connect(PlayerRemoving_Added)
            _Players.PlayerRemoving:Connect(PlayerRemoving_Added)
            task.spawn(PlayerRemoving_Added)
            task.spawn(reconnect)
            _Players.PlayerAdded:Connect(function(p1394)
                local v1395, v1396 = pcall(function()
                    return p1394:IsFriendsWith(_LocalPlayer.UserId)
                end)

                if v1395 then
                    if v1396 and not u101(p1394.Name) then
                        table.insert(u389, p1394.Name)
                    end

                    u75(u1179, u389)
                end
            end)
            task.spawn(function()
                local v1397 = _Players
                local v1398, v1399, v1400 = pairs(v1397:GetPlayers())

                while true do
                    local v1401

                    v1400, v1401 = v1398(v1399, v1400)

                    if v1400 == nil then
                        break
                    end
                    if v1401:IsFriendsWith(_LocalPlayer.UserId) then
                        table.insert(u389, v1401.Name)
                    end
                end

                u75(u1179, u389)
            end)
            _LocalPlayer.CharacterAdded:Connect(reconnect)
            u5:Init()
        end
    else
        loadstring(game:HttpGet('https://raw.githubusercontent.com/BlizTBr/scripts/main/FTAP.lua'))()
    end
else
    return
end
