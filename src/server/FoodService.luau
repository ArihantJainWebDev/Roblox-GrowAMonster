local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("FoodConfig"))
local FoodService = {}
local inventories = {}
local readyTimes = {}
local nodes = {}
local lastAttempt = {}
local started = false
local feedback

local function publish(player)
	local inventory = inventories[player]
	local total = 0
	for _, id in Config.Order do
		player:SetAttribute("Food_" .. id, inventory[id])
		total += inventory[id]
	end
	player:SetAttribute("FoodCount", total)
end

function FoodService.InitPlayer(player)
	if inventories[player] then return end
	inventories[player] = {}
	readyTimes[player] = {}
	for _, id in Config.Order do inventories[player][id] = 0 end
	for id in nodes do player:SetAttribute("NodeReady_" .. id, 0) end
	publish(player)
end

function FoodService.GetSnapshot(player)
	return inventories[player] and table.clone(inventories[player]) or nil
end

-- Atomic server-only batch grant: a full basket leaves the crop untouched.
function FoodService.TryGrant(player, foodId, amount)
	local inventory = inventories[player]
	if not inventory or not Config.Foods[foodId] or amount < 1 or amount % 1 ~= 0 then return false end
	local total = 0
	for _, count in inventory do total += count end
	if total + amount > Config.Capacity then return false end
	inventory[foodId] += amount
	publish(player)
	return true
end

-- Server-only consumption; callers must validate the growth action before spending.
-- This function and the caller's grant do not yield.
function FoodService.TryConsume(player, foodId)
	if typeof(foodId) ~= "string" or not Config.Foods[foodId] then return nil end
	local inventory = inventories[player]
	if not inventory or inventory[foodId] < 1 then return nil end
	inventory[foodId] -= 1
	publish(player)
	return Config.Foods[foodId].XP
end

function FoodService.TryCollect(player, nodeId)
	if typeof(nodeId) ~= "string" then return false, "Unavailable" end
	local inventory = inventories[player]
	local node = nodes[nodeId]
	if not inventory or not node or player.Parent ~= Players then return false, "Unavailable" end
	local now = workspace:GetServerTimeNow()
	if now - (lastAttempt[player] or 0) < 0.2 then return false, "Slow down" end
	lastAttempt[player] = now
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not root or not humanoid or humanoid.Health <= 0 then return false, "Unavailable" end
	if (root.Position - node.Fruit.Position).Magnitude > Config.CollectDistance then return false, "Move closer" end
	if now < (readyTimes[player][nodeId] or 0) then return false, "Still regrowing" end
	local total = 0
	for _, count in inventory do total += count end
	if total >= Config.Capacity then return false, "Basket full — feed Sprout first" end
	local foodId = node:GetAttribute("FoodId")
	if node:GetAttribute("RequiresEvolution") and not require(script.Parent.MonsterService).GetSnapshot(player).Path then return false,"Choose an element at 100 growth to gather here" end
	-- Claim before publishing, with no yield: duplicate requests cannot grant twice.
	local readyAt = now + Config.Foods[foodId].Respawn
	readyTimes[player][nodeId] = readyAt
	inventory[foodId] += 1
	player:SetAttribute("NodeReady_" .. nodeId, readyAt)
	publish(player)
	require(script.Parent.QuestService).Record(player,"Gather")
	return true, foodId
end

local function part(parent, name, size, position, color, shape)
	local p = Instance.new("Part")
	p.Name, p.Size, p.Position, p.Color = name, size, position, color
	p.Shape = shape or Enum.PartType.Block
	p.Anchored, p.CanCollide, p.CanTouch = true, false, false
	p.Material = Enum.Material.SmoothPlastic
	p.Parent = parent
	return p
end

local function createNodes()
	local folder = Instance.new("Folder")
	folder.Name = "FoodNodes"
	local layout = require(ReplicatedStorage.Shared.WorldConfig).FoodNodes
	for _, entry in layout do
		local id, foodId, x, z = table.unpack(entry)
		local food = Config.Foods[foodId]
		local model = Instance.new("Model")
		model.Name = id
		model:SetAttribute("FoodId", foodId)
		model:SetAttribute("RequiresEvolution", entry[5] == true)
		local surfaceY=assert(require(script.Parent.WorldService).SurfaceAt(x,z), "Food node outside terrain: "..id)
		local base = Vector3.new(x, surfaceY + 0.65, z)
		model:SetAttribute("GroundPosition",Vector3.new(x,surfaceY,z))
		part(model, "Bush", Vector3.new(3.4, 1.3, 3.4), base, Color3.fromRGB(64, 136, 79), Enum.PartType.Ball)
		local fruit = part(model, "Fruit", Vector3.new(1.3, 1.3, 1.3), base + Vector3.new(0, 1.25, 0), food.Color, Enum.PartType.Ball)
		fruit.Transparency=1
		model.Bush.Transparency=1
		part(model, "Stem", Vector3.new(0.15, 0.4, 0.15), fruit.Position + Vector3.new(0, 0.7, 0), Color3.fromRGB(104, 77, 46))
		model.Stem.Transparency=1
		local prompt = Instance.new("ProximityPrompt")
		prompt.Name = "Collect"
		prompt.ActionText = "Collect"
		prompt.ObjectText = food.Name .. " • +" .. food.XP .. " growth"
		prompt.MaxActivationDistance = Config.CollectDistance
		prompt.HoldDuration = 0.25
		prompt.RequiresLineOfSight = false
		prompt.Parent = fruit
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "Label"
		billboard.Enabled=false -- native collection prompt provides readable nearby food information
		billboard.Size = UDim2.fromOffset(180, 50)
		billboard.StudsOffset = Vector3.new(0, 2, 0)
		billboard.MaxDistance = 65
		billboard.Adornee = fruit
		billboard.Parent = model
		local label = Instance.new("TextLabel")
		label.Name = "Text"
		label.Size = UDim2.fromScale(1, 1)
		label.BackgroundTransparency = 1
		label.Text = food.Name .. "\n" .. food.Rarity
		label.Font = Enum.Font.GothamBold
		label.TextSize = 14
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextStrokeTransparency = 0.4
		label.Parent = billboard
		nodes[id] = model
		model.Parent = folder
		prompt.Triggered:Connect(function(player)
			local accepted, message = FoodService.TryCollect(player, id)
			feedback:FireClient(player, accepted, message)
		end)
	end
	folder.Parent = workspace
end

function FoodService.Start()
	if started then return end
	started = true
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	if not remotes then
		remotes = Instance.new("Folder")
		remotes.Name, remotes.Parent = "Remotes", ReplicatedStorage
	end
	feedback = Instance.new("RemoteEvent")
	feedback.Name, feedback.Parent = "CollectFeedback", remotes
	createNodes()
	Players.PlayerAdded:Connect(FoodService.InitPlayer)
	Players.PlayerRemoving:Connect(function(player)
		inventories[player], readyTimes[player], lastAttempt[player] = nil, nil, nil
	end)
	for _, player in Players:GetPlayers() do FoodService.InitPlayer(player) end
end

return FoodService
