local SeedWaitRoll = 7200
local SeedStopRoll = 2700
local _wait = task.wait

repeat _wait() until game:IsLoaded()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game:GetService("Players").LocalPlayer
local logicRoot = player:WaitForChild("PlayerGui"):WaitForChild("LogicHolder")
local modulesDir = logicRoot:WaitForChild("ClientLoader"):WaitForChild("Modules")
local ClientDataHandler = require(modulesDir:WaitForChild("ClientDataHandler"))
local deleteRemote = ReplicatedStorage:WaitForChild("RemoteFunctions"):WaitForChild("DeleteUnit")
local StartRolls = false

local function Roll()
    local args = {
	    "ub_sun",
	    10
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("BuyUnitBox"):InvokeServer(unpack(args))
	task.wait(0.2)
    local args = {
	    "ub_bee",
	    10
    }
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("BuyUnitBox"):InvokeServer(unpack(args))
	-- local args = {
	--     "ub_classic_v9",
	--     10
    -- }
    -- game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("BuyUnitBox"):InvokeServer(unpack(args))
end

local function RemoveUnit()
	local inventory = ClientDataHandler.GetValue("Inventory")
	local toDelete = {}
	local kept = {}

	for uniqueId, unitData in pairs(inventory or {}) do
		local itemId = unitData.ItemData and unitData.ItemData.ID
		local rarity = require(game:GetService("Players").LocalPlayer.PlayerGui.LogicHolder.ClientLoader.SharedConfig.ItemData.Units.Configs:FindFirstChild(itemId))

		if rarity.Rarity == "ra_godly" or unitData.Equipped == true then
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

local function StartRoll()
	while StartRolls do
		local Seeds = tostring(player.leaderstats.Seeds.Value)
		local SeedHave = tonumber(Seeds:match("[kK]") and Seeds:gsub("[kK]", "") * 1000 or Seeds:gsub(",", ""))
		if SeedHave <= SeedStopRoll then
			StartRolls = false
			break
		end
		
		Roll()
		task.spawn(RemoveUnit)
		_wait(0.5)
	end
end

while true do
	local Seeds = tostring(player.leaderstats.Seeds.Value)
	local SeedHave = tonumber(Seeds:match("[kK]") and Seeds:gsub("[kK]", "") * 1000 or Seeds:gsub(",", ""))
	if SeedHave >= SeedWaitRoll then
		StartRolls = true
		StartRoll()
	end
	_wait(5)
end
