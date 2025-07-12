local _wait = task.wait
repeat
    _wait()
until game:IsLoaded()
repeat _wait() until game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("GameGui")
repeat _wait() until game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.Stats.Items.Frame.ScrollingFrame:WaitForChild("GamesWon")
repeat _wait() until game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.Stats.Items.Frame.ScrollingFrame.GamesWon.Items.Items.Val
repeat _wait() until game:GetService("Players").LocalPlayer.PlayerGui.LogicHolder.ClientLoader.Modules.ClientDataHandler
repeat _wait() until game:GetService("Players").LocalPlayer.PlayerGui.LogicHolder.ClientLoader.Modules.SharedItemData
task.wait(5)
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local function AutoSkip()
    while true do
        local args = {
            "y"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("SkipWave"):InvokeServer(
            unpack(args)
        )
        task.wait(0.3)
    end
end
local function CheckHave()
    local ClientDataHandler = require(game:GetService("Players").LocalPlayer.PlayerGui.LogicHolder.ClientLoader.Modules.ClientDataHandler)
    local inventory = ClientDataHandler.GetValue("Inventory")
    local Share = require(game:GetService("Players").LocalPlayer.PlayerGui.LogicHolder.ClientLoader.Modules.SharedItemData)
    local unithave = {}
    for uniqueId, unitData in pairs(inventory or {}) do
        local itemId = unitData.ItemData and unitData.ItemData.ID
        local rarity = Share.GetItem(itemId).Rarity
        if itemId == "unit_laser_plant" or itemId == "unit_farmer_npc" or itemId == "unit_tomato_plant" then
            table.insert(unithave, itemId)
        end
    end
    if table.find(unithave, "unit_laser_plant") and table.find(unithave, "unit_farmer_npc") and table.find(unithave, "unit_tomato_plant") then
        return true
    else
        return false
    end
end
local function ReturnForLobby()
    local ClientDataHandler = require(game:GetService("Players").LocalPlayer.PlayerGui.LogicHolder.ClientLoader.Modules.ClientDataHandler)
    local inventory = ClientDataHandler.GetValue("Inventory")
    local Share = require(game:GetService("Players").LocalPlayer.PlayerGui.LogicHolder.ClientLoader.Modules.SharedItemData)
    local unithave = {}
    for uniqueId, unitData in pairs(inventory or {}) do
        local itemId = unitData.ItemData and unitData.ItemData.ID
        local rarity = require(game:GetService("Players").LocalPlayer.PlayerGui.LogicHolder.ClientLoader.SharedConfig.ItemData.Units.Configs:FindFirstChild(itemId))
        print(uniqueId, itemId)
        if itemId == "unit_laser_plant" or itemId == "unit_farmer_npc" or itemId == "unit_tomato_plant" then
            local args = {
                tostring(uniqueId),
                true
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("SetUnitEquipped"):InvokeServer(
                unpack(args)
            )
            table.insert(unithave, itemId)
        elseif rarity.Rarity ~= "ra_godly" then
            local args = {
	            {
		            tostring(uniqueId),
	            }
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("DeleteUnit"):InvokeServer(unpack(args))
        end
    end
    if table.find(unithave, "unit_laser_plant") and table.find(unithave, "unit_farmer_npc") and table.find(unithave, "unit_tomato_plant") then
        return true
    else
        return false
    end
end
local function PlayLose()
    local args = {
        "dif_impossible"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("PlaceDifficultyVote"):InvokeServer(
        unpack(args)
    )
    local args = {
        2
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("ChangeTickSpeed"):InvokeServer(
        unpack(args)
    )
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("RestartGame"):InvokeServer()
    if not workspace.Map.Entities:FindFirstChild("unit_tomato_plant") then
        local args = {
            "unit_tomato_plant",
            {
                Valid = true,
                Rotation = 180,
                CF = CFrame.new(-335.3413391113281, 62.845054626464844, -124.63864135742188),
                Position = vector.create(-335.3413391113281, 62.845054626464844, -124.63864135742188)
            }
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("PlaceUnit"):InvokeServer(
            unpack(args)
        )
        task.wait(1)
    end
end
local function PlayWin()
    local args = {
        "dif_easy"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("PlaceDifficultyVote"):InvokeServer(
        unpack(args)
    )
    local args = {
        2
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("ChangeTickSpeed"):InvokeServer(
        unpack(args)
    )
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("RestartGame"):InvokeServer()
    if not workspace.Map.Entities:FindFirstChild("unit_farmer_npc") then
        local args = {
	        "unit_farmer_npc",
	        {
		        Valid = true,
		        Rotation = 180,
		        CF = CFrame.new(-331.5242614746094, 63.38456726074219, -133.7012939453125, -1, 0, -8.742277657347586e-08, 0, 1, 0, 8.742277657347586e-08, 0, -1),
		        Position = vector.create(-331.5242614746094, 63.38456726074219, -133.7012939453125)
	        }
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("PlaceUnit"):InvokeServer(unpack(args))
    end
    if not workspace.Map.Entities:FindFirstChild("unit_laser_plant") then
        local args = {
	        "unit_laser_plant",
	        {
		        Valid = true,
		        Rotation = 180,
		        CF = CFrame.new(-322.96856689453125, 63.34716033935547, -144.98504638671875, -1, 0, -8.742277657347586e-08, 0, 1, 0, 8.742277657347586e-08, 0, -1),
		        Position = vector.create(-322.96856689453125, 63.34716033935547, -144.98504638671875)
	        } 
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("PlaceUnit"):InvokeServer(unpack(args))
    end
    for i,v in pairs(workspace.Map.Entities:GetChildren()) do
        if v.name == "unit_farmer_npc" or v.name == "unit_laser_plant" then
            local args = {
	            tonumber(v:GetAttribute("ID"))
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("UpgradeUnit"):InvokeServer(unpack(args))
        end
    end
end
local function AntiLag()
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    local Lighting = game:GetService("Lighting")
    local RunService = game:GetService("RunService")
    local Settings = settings()

    -- Tối ưu Terrain (nước)
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0

    -- Tối ưu Lighting (ánh sáng)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9

    -- Giảm chất lượng đồ họa
    Settings.Rendering.QualityLevel = 1

    -- Tối ưu toàn bộ vật thể trong game
    for _, v in pairs(game:GetDescendants()) do
        if
            v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or
                v:IsA("TrussPart")
         then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        end
    end

    -- Tắt hiệu ứng hậu kỳ trong Lighting
    for _, v in pairs(Lighting:GetDescendants()) do
        if
            v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or
                v:IsA("DepthOfFieldEffect")
         then
            v.Enabled = false
        end
    end

    -- Tự động xóa các hiệu ứng khi xuất hiện mới
    workspace.DescendantAdded:Connect(
        function(child)
            task.spawn(
                function()
                    if child:IsA("ForceField") or child:IsA("Sparkles") or child:IsA("Smoke") or child:IsA("Fire") then
                        RunService.Heartbeat:Wait()
                        child:Destroy()
                    end
                end
            )
        end
    )
end
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local PlaceId = game.PlaceId
local JobId = game.JobId
local ApiURL = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=20"
local function hopServer()
    local servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
    local body = HttpService:JSONDecode(req)

    if body and body.data then
        for i, v in next, body.data do
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
                table.insert(servers, 1, v.id)
            end
        end
    end

    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
    else
        return notify("Serverhop", "Couldn't find a server.")
    end
end
local function AntiAfk2()
    task.spawn(
        function()
            while true do
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                task.wait(5)
            end
        end
    )
end
local function CheckBackPack()
    if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Laser Plant") and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Tomato") and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Farmer") then
        return true
    else
        return false
    end
end
task.spanw(function()
    while true do
        if game.PlaceId == 108533757090220 then
            local Have = CheckHave()
            local Seeds = tostring(game:GetService("Players").LocalPlayer.leaderstats.Seeds.Value)
            local SeedHave = Seeds:find("[Kk]") and Seeds:gsub("[Kk]", "") * 1000 or Seeds:gsub(",", "")
            if (not Have and tonumber(SeedHave) > 5000) then
                print('Nothinh')
            else
                task.wait(60)
                hopServer()
            end
        end
    end
end)
task.spawn(function()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local lastSeedValue, timeSinceLastChange = nil, 0
    while true do
        local Seeds = tostring(Players.LocalPlayer.leaderstats.Seeds:FindFirstChild("Value39")) or game:GetService("Players").LocalPlayer.leaderstats.Seeds.Value
        local SeedHave = Seeds:find("[Kk]") and Seeds:gsub("[Kk]", "") * 1000 or Seeds:gsub(",", "")
        SeedHave = tonumber(SeedHave)

        if lastSeedValue and SeedHave ~= lastSeedValue then
            timeSinceLastChange = 0
            lastSeedValue = SeedHave
        elseif lastSeedValue then
            timeSinceLastChange = timeSinceLastChange + 1
            if timeSinceLastChange >= 180 then
                print("No change in SeedHave for 3 minutes: " .. SeedHave)
                if ReplicatedStorage:FindFirstChild("RemoteFunctions") then
                    ReplicatedStorage.RemoteFunctions.BackToMainLobby:InvokeServer()
                else
                    game:shutdown()
                end
                timeSinceLastChange = 0
            end
        else
            lastSeedValue = SeedHave
        end
        task.wait(1)
    end
end)


local function isAnyPlayerNearby(maxDistance, cframe)
    local targetCFrame = cframe
    for _, player in pairs(game.Players:GetPlayers()) do
        local character = player.Character
        if character and character.PrimaryPart then
            local distance = (character.PrimaryPart.Position - targetCFrame.Position).Magnitude
            if distance <= maxDistance then
                return false -- Có người chơi gần đó
            end
        end
    end
    return true -- Không có người chơi nào gần đó
end

local Wins = game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.Stats.Items.Frame.ScrollingFrame.GamesWon.Items.Items.Val
local function main()
    if game.PlaceId == 108533757090220 then
        while true do
            setfpscap(15)
            local Have = CheckHave()
            local Seeds = tostring(game:GetService("Players").LocalPlayer.leaderstats.Seeds.Value)
            local SeedHave = Seeds:find("[Kk]") and Seeds:gsub("[Kk]", "") * 1000 or Seeds:gsub(",", "")
            local maxDistance = 7 -- Khoảng cách tối đa (studs)
            if (not Have and tonumber(SeedHave) > 5000) then
                local args = {
                    "ub_classic_v8",
                    10
                }
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("BuyUnitBox"):InvokeServer(
                    unpack(args)
                )
                local args = {
                    "ub_classic_v4",
                    10
                }
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("BuyUnitBox"):InvokeServer(
                    unpack(args)
                )
            elseif Have and not CheckBackPack() then
                ReturnForLobby()
            elseif Have or tonumber(SeedHave) < 5000 then
                local args = {
                    "unique_1",
                    true
                }
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("SetUnitEquipped"):InvokeServer(
                    unpack(args)
                )
                if tonumber(Wins.Text) < 25 and Have and CheckBackPack() then
                    if isAnyPlayerNearby(maxDistance, CFrame.new(85.2458649, 70.9051361, 808.613525)) then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                            CFrame.new(85.2458649, 70.9051361, 808.613525
                        )
                        -- game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("StartLobby_1"):InvokeServer()
                    else
                        hopServer()
                    end
                else
                    if isAnyPlayerNearby(maxDistance, CFrame.new(139.886551, 70.6783218, 815.733337)) then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                            CFrame.new(139.886551, 70.6783218, 815.733337)
                        -- game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("StartLobby_12"):InvokeServer()
                    else
                        hopServer()
                    end
                end
                task.wait(2)
            end
            task.wait()
        end
    else
        game:GetService("RunService"):Set3dRenderingEnabled(false)
        task.spawn(AutoSkip)
        task.spawn(AntiLag)
        AntiAfk2()
        setfpscap(10)
        while true do
            Wins = game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.Stats.Items.Frame.ScrollingFrame.GamesWon.Items.Items.Val
            local SeedValue = game:GetService("Players").LocalPlayer.leaderstats.Seeds.Value
            local Seed = SeedValue:find("[Kk]") and SeedValue:gsub("[Kk]", "") * 1000 or SeedValue:gsub(",", "")
            if tonumber(Wins.Text) >= 25 then
                if workspace.Map.BaseHP.CFrame == CFrame.new(-335.381012, 68.4682846, -252.007782, 0, 0, 1, 0, 1, -0, -1, 0, 0) then
                    game:shutdown()
                elseif workspace.Map.BaseHP.CFrame == CFrame.new(-335.381012, 68.4682846, -272.472839, 0, 0, 1, 0, 1, -0, -1, 0, 0) and CheckBackPack() then
                    PlayLose()
                end
            else
                if workspace.Map.BaseHP.CFrame == CFrame.new(-335.381012, 68.4682846, -252.007782, 0, 0, 1, 0, 1, -0, -1, 0, 0) and CheckBackPack() and tonumber(Wins.Text) < 25 then
                    print('PlayWin')
                    PlayWin()
                elseif tonumber(Seed) < 15000 and not CheckBackPack() then
                    print('PlayLose')
                    PlayLose()
                elseif tonumber(Seed) >= 15000 and not CheckBackPack() then
                    game:shutdown()
                elseif tonumber(Wins.Text) >= 25 then
                    game:shutdown()
                end
            end
            task.wait()
        end
    end
end

-- Hàm chạy script với xử lý lỗi
local function runScript()
    local errorCount = 0
    while true do
        local success, errorMessage = pcall(main)
        if not success then
            errorCount = errorCount + 1
            print("Error occurred: " .. tostring(errorMessage))
            if errorCount >= 5 then
                print("Script has errored 5 times consecutively!")
                game:GetService("ReplicatedStorage").RemoteFunctions.BackToMainLobby:InvokeServer()
            end
            print("Restarting script in 5 seconds...")
            task.wait(5)
        else
            errorCount = 0 -- Reset error count on success
            break
        end
    end
end

-- Chạy script
runScript()

game:GetService("Players").LocalPlayer.PlayerGui.LogicHolder.ClientLoader.Modules.SharedHelper:FireRemoteEvent("CashFloat")
