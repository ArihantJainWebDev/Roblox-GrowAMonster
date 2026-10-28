local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local DSS = game:GetService("DataStoreService")
local Http = game:GetService("HttpService")
local Config = require(RS.Shared.FarmConfig)
local Food = require(script.Parent.FoodService)
local Service = {}
local profiles, islands, slots = {}, {}, {}
local store = DSS:GetDataStore("GrowAMonster_Farms_v1")
local token = game.JobId .. Http:GenerateGUID(false)
local closing = false
local function part(parent, name, size, pos, color)
	local p = Instance.new("Part")
	p.Name, p.Size, p.Position = name, size, pos
	p.Anchored, p.Color, p.Parent = true, color, parent
	p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
	return p
end
local function save(player, release)
	local profile = profiles[player]
	if not profile or not profile.Persistent or profile.Saving then return end
	profile.Saving = true
	local snapshot = { Coins = profile.Coins, Seeds = table.clone(profile.Seeds), Plots = {} }
	for i, plot in profile.Plots do snapshot.Plots[i] = table.clone(plot) end
	local ok, result = pcall(function()
		return store:UpdateAsync(tostring(player.UserId), function(old)
			if not old or old.Lock ~= token then return nil end
			if release then snapshot.Lock = nil else snapshot.Lock = token end
			snapshot.Lease = release and 0 or os.time() + 180
			return snapshot
		end)
	end)
	if ok and result then profile.Lease = os.time() + 180 end
	if ok and not result then profile.Blocked = true end
	profile.Saving = false
	if player.Parent then player:SetAttribute("FarmSaveStatus", ok and result and "Saved" or "Save retry pending") end
end
local function publish(player)
	local p = profiles[player]
	player:SetAttribute("FarmCoins", p.Coins)
	for _, id in Config.Order do player:SetAttribute("Seed_" .. id, p.Seeds[id]) end
	for i, data in p.Plots do
		local plot = islands[player]:FindFirstChild("Plot" .. i)
		plot:SetAttribute("Crop", data.Crop or "")
		plot:SetAttribute("ReadyAt", data.ReadyAt or 0)
	end
end
function Service.Act(player, index, cropId)
	local p, island = profiles[player], islands[player]
	if p and p.Persistent and os.time() >= p.Lease then p.Blocked = true end
	if not p or not island or p.Blocked or typeof(index) ~= "number" or index % 1 ~= 0 or index < 1 or index > 4 then return false, "Farm unavailable" end
	local plot = island:FindFirstChild("Plot" .. index)
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if not root or not hum or hum.Health <= 0 or (root.Position - plot.Position).Magnitude > 12 then return false, "Move closer to your plot" end
	local data = p.Plots[index]
	if data.Crop then
		if os.time() < data.ReadyAt then return false, "Still growing" end
		local crop = Config.Crops[data.Crop]
		if not Food.TryGrant(player, data.Crop, crop.Yield) then return false, "Make room in your basket first" end
		p.Seeds[data.Crop] += 1
		p.Coins += Config.HarvestCoins
		p.Plots[index] = {}
		publish(player)
		return true, "Harvested! Seed returned and +3 coins"
	end
	if typeof(cropId) ~= "string" or not Config.Crops[cropId] then return false, "Choose a seed" end
	if p.Seeds[cropId] < 1 then return false, "Buy a seed at your island sign" end
	p.Seeds[cropId] -= 1
	p.Plots[index] = { Crop = cropId, ReadyAt = os.time() + Config.Crops[cropId].Seconds }
	publish(player)
	return true, "Planted " .. Config.Crops[cropId].Name
end
local function init(player)
	local profile = { Coins = Config.StarterCoins, Seeds = { Apple = 2, Berry = 2 }, Plots = { {}, {}, {}, {} } }
	local ok, saved = pcall(function()
		return store:UpdateAsync(tostring(player.UserId), function(old)
			if old and old.Lock and old.Lock ~= token and (old.Lease or 0) > os.time() then return nil end
			local value = old or { Coins = profile.Coins, Seeds = profile.Seeds, Plots = profile.Plots }
			value.Lock, value.Lease = token, os.time() + 180
			return value
		end)
	end)
	if not player.Parent or closing then return end
	if ok and not saved then player:Kick("Your farm is still open in another server. Please rejoin shortly."); return end
	profile.Persistent = ok
	profile.Lease = os.time() + 180
	if ok then
		profile.Coins = math.clamp(tonumber(saved.Coins) or 12, 0, 1000000)
		for _, id in Config.Order do profile.Seeds[id] = math.clamp(math.floor(tonumber(saved.Seeds and saved.Seeds[id]) or 0), 0, 10000) end
		for i = 1, 4 do
			local data = saved.Plots and saved.Plots[i]
			if type(data) == "table" and Config.Crops[data.Crop] and type(data.ReadyAt) == "number" then profile.Plots[i] = { Crop = data.Crop, ReadyAt = math.min(data.ReadyAt, os.time() + 60) } end
		end
	end
	-- On an unavailable store, allow an explicitly labelled Studio preview only.
	if not ok and not game:GetService("RunService"):IsStudio() then player:Kick("Farm data could not load. Please try again."); return end
	profiles[player] = profile
	player:SetAttribute("FarmSaveStatus", ok and "Loaded" or "Studio preview — not saved")
	local slot = 1
	while slots[slot] do slot += 1 end
	slots[slot] = player
	local center = Vector3.new(slot * 110, 64, 0)
	local island = Instance.new("Model")
	island.Name = "Island_" .. player.UserId
	island:SetAttribute("OwnerUserId", player.UserId)
	part(island, "Grass", Vector3.new(64, 4, 64), center, Color3.fromRGB(113,190,105))
	part(island, "Rock", Vector3.new(48,12,48), center - Vector3.new(0,8,0), Color3.fromRGB(105,98,90))
	local spawn = Instance.new("SpawnLocation")
	spawn.Name, spawn.Size, spawn.Position = "HomeSpawn", Vector3.new(6,1,6), center + Vector3.new(0,2.5,18)
	spawn.Anchored, spawn.Transparency, spawn.Neutral, spawn.Parent = true, 1, true, island
	player.RespawnLocation = spawn
	for i = 1, 4 do
		local x, z = ((i-1)%2)*12-6, math.floor((i-1)/2)*12-9
		local plot = part(island, "Plot" .. i, Vector3.new(9,0.6,9), center + Vector3.new(x,2.3,z), Color3.fromRGB(104,69,43))
		local prompt = Instance.new("ProximityPrompt")
		prompt.ActionText, prompt.ObjectText, prompt.MaxActivationDistance, prompt.HoldDuration = "Plant / Harvest", "Farm plot " .. i, 10, 0.3
		prompt.RequiresLineOfSight, prompt.Parent = false, plot
		prompt.Triggered:Connect(function(who)
			if who ~= player then return end
			local success, message = Service.Act(player, i, player:GetAttribute("SelectedSeed") or "Apple")
			RS.Remotes.FarmFeedback:FireClient(player, success, message)
		end)
	end
	-- Stop at the facing island edges. Overlapping grass at the same surface
	-- height causes flickering as the renderer alternates between both faces.
	local sharedEdge, homeEdge = 36, center.X - 32
	part(island, "PathToGathering", Vector3.new(homeEdge-sharedEdge,1,8),
		Vector3.new((sharedEdge+homeEdge)/2,65.5,18), Color3.fromRGB(168,130,86))
	island.Parent = workspace
	islands[player] = island
	publish(player)
	if player.Character then player.Character:PivotTo(CFrame.new(center + Vector3.new(0,7,18))) end
end
function Service.Start()
	local feedback = Instance.new("RemoteEvent")
	feedback.Name, feedback.Parent = "FarmFeedback", RS.Remotes
	local select = Instance.new("RemoteEvent")
	select.Name, select.Parent = "ChooseSeed", RS.Remotes
	select.OnServerEvent:Connect(function(player, id, buy)
		local p = profiles[player]
		if not p or p.Blocked or (p.Persistent and os.time() >= p.Lease) or typeof(id) ~= "string" or not Config.Crops[id] then return end
		if buy == true then
			if p.Coins < Config.Crops[id].Cost or p.Seeds[id] >= 10000 then return end
			p.Coins -= Config.Crops[id].Cost; p.Seeds[id] += 1; publish(player)
		end
		player:SetAttribute("SelectedSeed", id)
	end)
	Players.PlayerAdded:Connect(init)
	Players.PlayerRemoving:Connect(function(player)
		while profiles[player] and profiles[player].Saving do task.wait(0.1) end
		save(player, true)
		if islands[player] then islands[player]:Destroy() end
		for i, owner in slots do if owner == player then slots[i] = nil end end
		profiles[player], islands[player] = nil, nil
	end)
	for _, player in Players:GetPlayers() do task.spawn(init, player) end
	task.spawn(function()
		while not closing do
			task.wait(60)
			for player in profiles do task.spawn(save, player, false) end
		end
	end)
	game:BindToClose(function()
		closing = true
		local pending = 0
		for player in profiles do task.spawn(function()
			pending += 1
			while profiles[player] and profiles[player].Saving do task.wait(0.1) end
			save(player, true)
			pending -= 1
		end) end
		local deadline = os.clock()+25
		repeat task.wait(0.2) until os.clock()>deadline or pending == 0
	end)
end
return Service
