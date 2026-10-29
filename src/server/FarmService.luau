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
function Service.CanChange(player)
	local profile = profiles[player]
	return profile ~= nil and not profile.Blocked and (not profile.Persistent or os.time() < profile.Lease)
end
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
	snapshot.Monster = require(script.Parent.MonsterService).GetSnapshot(player)
	snapshot.Quests = require(script.Parent.QuestService).GetSnapshot(player)
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
function Service.AddCoins(player,amount)
	if not Service.CanChange(player) or typeof(amount)~="number" or amount<0 or amount%1~=0 then return false end
	profiles[player].Coins=math.min(1000000,profiles[player].Coins+amount)
	player:SetAttribute("FarmCoins",profiles[player].Coins)
	return true
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
		require(script.Parent.QuestService).Record(player,"Harvest")
		return true, "Harvested! Seed returned and +3 coins"
	end
	if typeof(cropId) ~= "string" or not Config.Crops[cropId] then return false, "Choose a seed" end
	if p.Seeds[cropId] < 1 then return false, "Buy a seed at your seed bench" end
	p.Seeds[cropId] -= 1
	p.Plots[index] = { Crop = cropId, ReadyAt = os.time() + Config.Crops[cropId].Seconds }
	publish(player)
	require(script.Parent.QuestService).Record(player,"Plant")
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
	if ok then require(script.Parent.MonsterService).RestoreSnapshot(player, saved.Monster) end
	player:SetAttribute("FarmSaveStatus", ok and "Loaded" or "Studio preview — not saved")
	local slot = 1
	while slots[slot] do slot += 1 end
	slots[slot] = player
	local center = require(script.Parent.WorldService).BuildHome(slot)
	if not player.Parent then return end
	local island = Instance.new("Model")
	island.Name = "Island_" .. player.UserId
	island:SetAttribute("OwnerUserId", player.UserId)
	local anchor=part(island, "Grass", Vector3.new(100, 4, 110), center, Color3.fromRGB(113,190,105))
	anchor.Transparency,anchor.CanCollide,anchor.CanQuery=1,false,false
	local spawn = Instance.new("SpawnLocation")
	spawn.Name, spawn.Size, spawn.Position = "HomeSpawn", Vector3.new(6,1,6), center + Vector3.new(0,2.5,18)
	spawn.Anchored, spawn.Transparency, spawn.Neutral, spawn.Parent = true, 1, true, island
	local homeLabel=Instance.new("BillboardGui")
	homeLabel.Name,homeLabel.Size,homeLabel.StudsOffset,homeLabel.MaxDistance="HomeLabel",UDim2.fromOffset(220,50),Vector3.new(0,7,0),100
	homeLabel.Adornee,homeLabel.Parent=spawn,spawn
	local homeText=Instance.new("TextLabel")
	homeText.Size,homeText.BackgroundTransparency,homeText.Text=UDim2.fromScale(1,1),1,player.DisplayName.."'s home\nGateway → Shared world"
	homeText.TextColor3,homeText.TextSize,homeText.TextStrokeTransparency,homeText.Parent=Color3.new(1,1,1),16,0.3,homeLabel
	player.RespawnLocation = spawn
	player.CharacterAdded:Connect(function() player:SetAttribute("CurrentRegion","Home") end)
	for i = 1, 4 do
		local x, z = ((i-1)%2)*12-6, math.floor((i-1)/2)*12-9
		local plot = part(island, "Plot" .. i, Vector3.new(9,0.6,9), center + Vector3.new(x,2.3,z), Color3.fromRGB(76,52,35))
		plot.Material=Enum.Material.Ground
		local prompt = Instance.new("ProximityPrompt")
		prompt.ActionText, prompt.ObjectText, prompt.MaxActivationDistance, prompt.HoldDuration = "Plant / Harvest", "Farm plot " .. i, 10, 0.3
		prompt.RequiresLineOfSight, prompt.Parent = false, plot
		prompt.Triggered:Connect(function(who)
			if who ~= player then return end
			local success, message = Service.Act(player, i, player:GetAttribute("SelectedSeed") or "Apple")
			RS.Remotes.FarmFeedback:FireClient(player, success, message)
		end)
	end
 local counter=part(island,"SeedCounter",Vector3.new(7,2.4,3),center+Vector3.new(-15,3.2,17),Color3.fromRGB(109,80,52))
 counter.Transparency,counter.CanCollide=1,true
 local shop=Instance.new("ProximityPrompt");shop.Name="ShopPrompt";shop.ObjectText="Seeds & saplings";shop.ActionText="Browse seeds";shop.MaxActivationDistance=10;shop.RequiresLineOfSight=false;shop.Parent=counter
	island.Parent = workspace
	islands[player] = island
	require(script.Parent.GatewayService).RegisterHome(player,island,center)
	publish(player)
	require(script.Parent.QuestService).Init(player,ok and saved.Quests or nil)
	local egg=part(island,"WelcomeEgg",Vector3.new(2,3,2),center+Vector3.new(7,3.5,18),Color3.fromRGB(249,226,159))
	egg.Transparency=1;egg.CanCollide=false
 local ground=require(script.Parent.WorldService).SurfaceAt(egg.Position.X,egg.Position.Z)
 egg:SetAttribute("GroundPosition",Vector3.new(egg.Position.X,ground or egg.Position.Y-1.5,egg.Position.Z))
 egg:SetAttribute("Hatched",false)
	local welcome=Instance.new("ProximityPrompt")
	welcome.ActionText,welcome.ObjectText,welcome.MaxActivationDistance,welcome.HoldDuration="Meet Sprout","Your starter egg",10,0.3
	welcome.RequiresLineOfSight,welcome.Parent=false,egg
	if require(script.Parent.MonsterService).GetSnapshot(player).Hatched then egg:SetAttribute("Hatched",true);welcome.Enabled=false end
	welcome.Triggered:Connect(function(who)
		local root=who.Character and who.Character:FindFirstChild("HumanoidRootPart")
		local hum=who.Character and who.Character:FindFirstChildOfClass("Humanoid")
		if who~=player or not root or not hum or hum.Health<=0 or (root.Position-egg.Position).Magnitude>12 then return end
		if not require(script.Parent.MonsterService).Hatch(player) then return end
		egg:SetAttribute("Hatched",true);welcome.Enabled=false
		require(script.Parent.QuestService).Record(player,"Hatch")
	end)
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
