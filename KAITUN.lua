local _wait = task.wait
repeat
    _wait()
until game:IsLoaded()
repeat _wait() until game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("GameGui")
repeat _wait() until game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.Stats.Items.Frame.ScrollingFrame:WaitForChild("GamesWon")
repeat _wait() until game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.Stats.Items.Frame.ScrollingFrame.GamesWon.Items.Items.Val
repeat _wait() until game:GetService("Players").LocalPlayer.PlayerGui.LogicHolder.ClientLoader.Modules.ClientDataHandler
repeat _wait() until game:GetService("Players").LocalPlayer.PlayerGui.LogicHolder.ClientLoader.Modules.SharedItemData
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
GuiService.AutoSelectGuiEnabled = true
task.wait(5)
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local function AutoSkip()
    while true do
        local SkipGui = game:GetService("Players").LocalPlayer.PlayerGui.GameGuiNoInset.Screen.Top.WaveControls.AutoSkip
        if SkipGui.Title.Text ~= "Auto Skip: On" then
            GuiService.SelectedObject = SkipGui
            task.wait()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        end
        task.wait(2)
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
        if itemId == "unit_pineapple" or itemId == "unit_tomato_plant" then
            table.insert(unithave, itemId)
        end
    end
    if table.find(unithave, "unit_pineapple") and table.find(unithave, "unit_tomato_plant") then
        return true
    else
        return false
    end
end

local function RemoveUnit()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local deleteRemote = ReplicatedStorage:WaitForChild("RemoteFunctions"):WaitForChild("DeleteUnit")
    local ClientDataHandler = require(game:GetService("Players").LocalPlayer.PlayerGui.LogicHolder.ClientLoader.Modules.ClientDataHandler)
	local inventory = ClientDataHandler.GetValue("Inventory")
	local toDelete = {}
	local kept = {}

	for uniqueId, unitData in pairs(inventory or {}) do
		local itemId = unitData.ItemData and unitData.ItemData.ID
		local rarity = require(game:GetService("Players").LocalPlayer.PlayerGui.LogicHolder.ClientLoader.SharedConfig.ItemData.Units.Configs:FindFirstChild(itemId))

		if rarity.Rarity == "ra_godly" or itemId == "unit_tomato_plant" or itemId == "unit_pineapple" then
			kept[itemId] = true
			continue
		end
		if not kept[itemId] then
			kept[itemId] = true
		else
			table.insert(toDelete, uniqueId)
		end
	end
	if #toDelete > 0 then
		print("🗑️ Deleting", #toDelete, "units...")
		pcall(function()
			deleteRemote:InvokeServer(toDelete)
		end)
	else
		print("✅ Không có unit nào cần xoá.")
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
        RemoveUnit()
        if itemId == "unit_pineapple" or itemId == "unit_tomato_plant" then
            local args = {
                tostring(uniqueId),
                true
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("SetUnitEquipped"):InvokeServer(
                unpack(args)
            )
            table.insert(unithave, itemId)
        elseif unitData.Equipped == true then
            local args = {
                tostring(uniqueId),
                false
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("SetUnitEquipped"):InvokeServer(unpack(args))
        end
    end
    if table.find(unithave, "unit_pineapple") and table.find(unithave, "unit_tomato_plant") then
        return true
    else
        return false
    end
end

local function UpgradeU()
    for i,v in pairs(workspace.Map.Entities:GetChildren()) do
        if v.name == "unit_pineapple" or v.name == "unit_tomato_plant" then
            if string.format("%.2f",v.OwnedIndicator.Size.X) ~= "0.30" then
                if (v.OwnedIndicator) then
                    local args = {
	                    tonumber(v:GetAttribute("ID"))
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("UpgradeUnit"):InvokeServer(unpack(args))
                    task.wait(0.3)
                end
            end
            task.wait()
        end
    end
end

local function PlayLose()
    if game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.DifficultyVote.Visible then
        local args = {
            "dif_impossible"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("PlaceDifficultyVote"):InvokeServer(unpack(args))
    end
    local args = {
        2
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("ChangeTickSpeed"):InvokeServer(unpack(args))
    if game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.GameEnd.Visible then
        task.wait(2)
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("RestartGame"):InvokeServer()
    end
    game.Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-0.15313172340393066 + math.random(1,5), 0, 15.22225284576416 + math.random(1,5)))
    if not workspace.Map.Entities:FindFirstChild("unit_pineapple") then
        local args = {
	        "unit_pineapple",
	        {
		        Valid = true,
		        Rotation = 180, 
		        CF = CFrame.new(-0.15313172340393066, 0, 15.22225284576416 , -1, 0, -8.742277657347586e-08, 0, 1, 0, 8.742277657347586e-08, 0, -1),
		        Position = vector.create(-0.15313172340393066, 0, 15.22225284576416)
	        }
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("PlaceUnit"):InvokeServer(unpack(args))
        task.wait(1)
    end
    if not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Pineapple Cannon") and not workspace.Map.Entities:FindFirstChild("unit_tomato_plant") then
        local args = {
	        "unit_tomato_plant",
	        {
		        Valid = true,
		        Rotation = 180,
		        CF = CFrame.new(-0.15313172340393066, 0, 15.22225284576416 , -1, 0, -8.742277657347586e-08, 0, 1, 0, 8.742277657347586e-08, 0, -1),
		        Position = vector.create(-0.15313172340393066, 0, 15.22225284576416)
	        }
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("PlaceUnit"):InvokeServer(unpack(args))
        task.wait(1)
    end
    if game:GetService("Players").LocalPlayer:GetAttribute("Cash") > 500 then
        UpgradeU()
    end
end
local function RedeemCode()
    local codes = {"PLAZA", "MYSTERY", "SLIME", "WASTE"}
    for _, code in ipairs(codes) do
        local args = { code }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("RedeemCode"):InvokeServer(unpack(args))
    end
end
local function PlayWin()
    if game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.DifficultyVote.Visible then
        local args = {
            "dif_easy"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("PlaceDifficultyVote"):InvokeServer(unpack(args))
    end
    if game:GetService("Players").LocalPlayer.PlayerGui.GameGuiNoInset.Screen.Top.WaveControls.TickSpeed.Items["2"].ImageColor3 ~= Color3.fromRGB(115, 230, 0) then
        local args = {
            2
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("ChangeTickSpeed"):InvokeServer(unpack(args))
    end
    if game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.GameEnd.Visible then
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("RestartGame"):InvokeServer()
    end
    local radishCount = 0
    for _, child in ipairs(workspace.Map.Entities:GetChildren()) do
        if child.Name == "unit_pineapple" then
            radishCount = radishCount + 1
        end
    end
    game.Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-331.64239501953125 + math.random(-10, 10), 62.522750854492188, -133.88951110839844 + math.random(-10, 10)))
    if radishCount < 7 then
        game.Players.LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(-331.64239501953125 + math.random(-10, 10), 62.703956604003906, -133.88951110839844 + math.random(-10, 10)))
        local PosList = {
            Vector3.new(-331.9243469238281, 62.845054626464844, -134.27297973632812),
            Vector3.new(-329.5567626953125, 62.845054626464844, -134.15237426757812),
            Vector3.new(-332.0066833496094, 62.845054626464844, -130.7923583984375),
            Vector3.new(-325.93145751953125, 62.845054626464844, -133.91928100585938),
            Vector3.new(-332.1609802246094, 62.845054626464844, -128.2115936279297),
            Vector3.new(-329.1172790527344, 62.845054626464844, -131.216552734375),
            Vector3.new(-327.5411376953125, 62.845054626464844, -145.2104034423828),
            Vector3.new(-324.3938903808594, 62.845054626464844, -146.91738891601562),
            Vector3.new(-321.1422119140625, 62.845054626464844, -147.17340087890625),
        }
        local pos = PosList[math.random(1, #PosList)]
        print('LAY')
        if game:GetService("Players").LocalPlayer:GetAttribute("Cash") > 300 then
            local args = {
                "unit_pineapple",
                {
                    Valid = true,
                    Rotation = 180,
                    CF = CFrame.new(pos),
                    Position = pos
                }
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("PlaceUnit"):InvokeServer(unpack(args))
        end
    else
        if game:GetService("Players").LocalPlayer:GetAttribute("Cash") > 500 then
            UpgradeU()
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
local function LowCpu()
    for _, v in pairs(workspace.Map:GetChildren()) do
        if v.Name ~= "LobbiesFarm" and v.Name ~= "RadioactiveSewer" and v.Name ~= "Model" and v.Name ~= "SurvivalLobby" then
            v:Destroy()
        end
    end
    if workspace.Map:FindFirstChild("Model") then
        for _, v in pairs(workspace.Map.Model:GetChildren()) do
            if v.Name ~= "Floor" then
                v:Destroy()
            end
        end
    else
        warn("Model not found in workspace.Map")
    end
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name ~= game.Players.LocalPlayer.Name and v:IsA("Model") then
            v:Destroy()
        end
    end
end

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
    if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Pineapple Cannon") and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Tomato") then
        return true
    else
        return false
    end
end
task.spawn(function()
    while true do
        if game.PlaceId == 108533757090220 then
            local Have = CheckHave()
            local Seeds = tostring(game:GetService("Players").LocalPlayer.leaderstats.Seeds.Value)
            local SeedHave = Seeds:find("[Kk]") and Seeds:gsub("[Kk]", "") * 1000 or Seeds:gsub(",", "")
            if (not Have and tonumber(SeedHave) > 2000) then
                print('Nothinh')
            else
                task.wait(300)
                hopServer()
            end
        else
            break
        end
        task.wait(1)
    end
end)

task.spawn(function()
    local player = game:GetService("Players").LocalPlayer
    local gui = player.PlayerGui.GameGui.Screen.Middle.GameEnd
    local startTime = nil

    while true do
        if gui.Visible then
            if not startTime then
                startTime = os.clock()
            elseif os.clock() - startTime > 60 then
                print("GameEnd GUI has been visible for more than 20 seconds! Kicking player...")
                if game:GetService("ReplicatedStorage"):FindFirstChild("RemoteFunctions") then
                    game:GetService("ReplicatedStorage").RemoteFunctions.BackToMainLobby:InvokeServer()
                else
                    game:shutdown()
                end
                startTime = os.clock()
            end
        else
            startTime = nil -- Reset timer when GUI is not visible
        end
        task.wait() -- Yield to avoid freezing
    end
end)
task.spawn(function()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local lastSeedValue, timeSinceLastChange = nil, 0
    local timedelay = 0
    if workspace:GetAttribute("MapId") == "map_farm" then
        timedelay = 500
    else
        timedelay = 200
    end
    while true do
        local Seeds = tostring(game:GetService("Players").LocalPlayer.leaderstats.Seeds.Value)
        local SeedHave = Seeds:find("[Kk]") and Seeds:gsub("[Kk]", "") * 1000 or Seeds:gsub(",", "")
        SeedHave = tonumber(SeedHave)

        if lastSeedValue and SeedHave ~= lastSeedValue then
            timeSinceLastChange = 0
            lastSeedValue = SeedHave
        elseif lastSeedValue then
            timeSinceLastChange = timeSinceLastChange + 1
            if timeSinceLastChange >= timedelay + 30 then
                game:shutdown()
            end
            if timeSinceLastChange >= timedelay then
                print("No change in SeedHave for 3 minutes: " .. SeedHave)
                if ReplicatedStorage:FindFirstChild("RemoteFunctions") then
                    game:GetService("ReplicatedStorage").RemoteFunctions.BackToMainLobby:InvokeServer()
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
local function CheckAnotherPlayer()
    local Players = game:GetService("Players")
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            return true -- Có người chơi khác trong game
        end
    end
    return false -- Không có người chơi khác
end
local function isAnyPlayerNearby(maxDistance, cframe)
    local targetCFrame = cframe
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local character = player.Character
            if character and character.PrimaryPart then
                local distance = (character.PrimaryPart.Position - targetCFrame.Position).Magnitude
                if distance <= maxDistance then
                    return false -- Có người chơi gần đó
                end
            end
        end
    end
    return true -- Không có người chơi nào gần đó
end
local StartRolls = false
local function Roll()
    while StartRolls do
        local Have = CheckHave()
        local Seeds = tostring(game:GetService("Players").LocalPlayer.leaderstats.Seeds.Value)
        local SeedHave = Seeds:find("[Kk]") and Seeds:gsub("[Kk]", "") * 1000 or Seeds:gsub(",", "")
        if (tonumber(SeedHave) <= 399) or Have then
            StartRolls = false
            break
        end
        local args = {
            "ub_classic_v4",
            1
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("BuyUnitBox"):InvokeServer(unpack(args))

        local args = {
	        "ub_classic_v5",
	        1
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("BuyUnitBox"):InvokeServer(unpack(args))
        RemoveUnit()
        task.wait(0.5)
    end
end
task.spawn(function()
    while true do
        if game:GetService("CoreGui").RobloxPromptGui.promptOverlay.Active then
            game:shutdown()
        end
        setfpscap(8)
        task.wait(10)
    end
end)
local function ClearUnity()
    task.spawn(
        function()
            while true do
                local entities = workspace.Map.Entities
                for _, model in pairs(entities:GetChildren()) do
                    if model:IsA("Model") and string.match(model.Name, "^enemy") then
                        model:Destroy()
                    end
                end
                task.wait(0.5)
            end
        end
    )
end
task.spawn(ClearUnity)
-- task.spawn(function()
--     while true do
--         task.wait(7200)
--         if ame:GetService("ReplicatedStorage"):FindFirstChild("RemoteFunctions") then
--             game:GetService("ReplicatedStorage").RemoteFunctions.BackToMainLobby:InvokeServer()
--         else
--             game:shutdown()
--         end
--     end
-- end)
local Wins = game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.Stats.Items.Frame.ScrollingFrame.GamesWon.Items.Items.Val
local function main()
    if game.PlaceId == 108533757090220 then
        LowCpu()
        if game:GetService("ReplicatedStorage").RemoteFunctions:FindFirstChild("ClientSetFlag") then
            game:GetService("ReplicatedStorage").RemoteFunctions.ClientSetFlag:Destroy() 
        end
        while true do
            game:GetService("RunService"):Set3dRenderingEnabled(true)
            RedeemCode()
            setfpscap(8)
            local Have = CheckHave()
            local Seeds = tostring(game:GetService("Players").LocalPlayer.leaderstats.Seeds.Value)
            local SeedHave = Seeds:find("[Kk]") and Seeds:gsub("[Kk]", "") * 1000 or Seeds:gsub(",", "")
            local maxDistance = 7 -- Khoảng cách tối đa (studs)
            if (not Have and tonumber(SeedHave) > 400) then
                StartRolls = true
                Roll()
            elseif Have and not CheckBackPack() then
                ReturnForLobby()
            elseif Have or tonumber(SeedHave) < 400 then
                local args = {
                    "unique_1",
                    true
                }
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("SetUnitEquipped"):InvokeServer(unpack(args))
                if tonumber(Wins.Text) < 25 and Have and CheckBackPack() then
                    local parttouch = workspace.Map.LobbiesFarm
                    for map,world in pairs(parttouch:GetChildren()) do
                        if world:GetAttribute("MaxPlayers") == 1 then
                            if isAnyPlayerNearby(maxDistance, world.Cage.Part.CFrame) then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = world.Cage.Part.CFrame
                                local args = {
	                                "map_farm"
                                }
                                for i = 6, 9 do
                                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("LobbySetMap_" .. i):InvokeServer(unpack(args))
                                    local args2 = {
	                                    1
                                    }
                                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("LobbySetMaxPlayers_" .. i):InvokeServer(unpack(args2))

                                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("StartLobby_" .. i):InvokeServer()
                                    task.wait()
                                end
                                -- game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("StartLobby_1"):InvokeServer()
                            else
                                hopServer()
                            end
                        end
                    end
                else
                    local parttouch = workspace.Map.SurvivalLobby
                    for map,world in pairs(parttouch:GetChildren()) do
                        if world:GetAttribute("MaxPlayers") == 4 then
                            if isAnyPlayerNearby(maxDistance, world.Cage.Part.CFrame) then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = world.Cage.Part.CFrame
                                for i = 15, 18 do
                                    local args2 = {
	                                    1
                                    }
                                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("LobbySetMaxPlayers_" .. i):InvokeServer(unpack(args2))

                                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("StartLobby_" .. i):InvokeServer()
                                    task.wait()
                                end
                                -- game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("StartLobby_1"):InvokeServer()
                            else
                                hopServer()
                            end
                        end
                    end
                end
                task.wait(2)
            end
            task.wait()
        end
    else
        game:GetService("RunService"):Set3dRenderingEnabled(true)
        task.spawn(AutoSkip)
        task.spawn(AntiLag)
        AntiAfk2()
        while true do
            if CheckAnotherPlayer() then
                print('Have another player')
                game:shutdown()
            end
            Wins = game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Screen.Middle.Stats.Items.Frame.ScrollingFrame.GamesWon.Items.Items.Val
            local SeedValue = game:GetService("Players").LocalPlayer.leaderstats.Seeds.Value
            local Seed = SeedValue:find("[Kk]") and SeedValue:gsub("[Kk]", "") * 1000 or SeedValue:gsub(",", "")
            if tonumber(Wins.Text) >= 25 then
                if workspace:GetAttribute("MapId") == "map_farm" then
                    game:shutdown()
                elseif workspace:GetAttribute("MapId") == "map_dungeon_islands" and CheckBackPack() then
                    PlayLose()
                    setfpscap(8)
                elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Tomato") then
                    PlayLose()
                end
            else
                if workspace:GetAttribute("MapId") == "map_farm" and CheckBackPack() and tonumber(Wins.Text) < 25 then
                    print('PlayWin')
                    setfpscap(15)
                    PlayWin()
                elseif tonumber(Seed) < 2000 and not CheckBackPack() then
                    print('PlayLose')
                    setfpscap(8)
                    PlayLose()
                elseif tonumber(Seed) >= 2000 and not CheckBackPack() then
                    game:shutdown()
                elseif tonumber(Wins.Text) >= 25 then
                    game:shutdown()
                end
            end
            task.wait(0.4)
        end
    end
end

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
        task.wait()
    end
end

-- Chạy script
runScript()
