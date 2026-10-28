local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("MonsterConfig"))

local MonsterService = {}
local FoodService = require(script.Parent:WaitForChild("FoodService"))
local FEED_COOLDOWN = 0.8
local FOLLOW_OFFSET = Vector3.new(3.5, -1.3, 0)
local states: { [number]: { SpeciesId: string, GrowthXP: number, StageId: string } } = {}
local lastFeedAt: { [number]: number } = {}
local reactionUntil: { [number]: number } = {}
local initialized: { [number]: boolean } = {}
local positionInitialized: { [number]: boolean } = {}

local remotes = ReplicatedStorage:FindFirstChild("Remotes")
if not remotes then
	remotes = Instance.new("Folder")
	remotes.Name = "Remotes"
	remotes.Parent = ReplicatedStorage
end

local function getOrCreateRemote(name: string): RemoteEvent
	local remote = remotes:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = remotes
	end
	return remote :: RemoteEvent
end

local feedRequest = getOrCreateRemote("FeedMonster")
local feedFeedback = getOrCreateRemote("FeedFeedback")

local function getStage(xp: number)
	for index = #Config.GrowthStages, 1, -1 do
		if xp >= Config.GrowthStages[index].AtXP then
			return Config.GrowthStages[index]
		end
	end
	return Config.GrowthStages[1]
end

local function addWeldedPart(model: Model, body: BasePart, name: string, size: Vector3, offset: CFrame, color: Color3, shape: Enum.PartType?): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.Shape = shape or Enum.PartType.Block
	part.CFrame = body.CFrame * offset
	part.Color = color
	part.Material = Enum.Material.SmoothPlastic
	part.Anchored = false
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Massless = true
	part.Parent = model
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = body
	weld.Part1 = part
	weld.Parent = body
	return part
end

local function makeCompanion(player: Player)
	local id = player.UserId
	local oldModel = workspace:FindFirstChild("Companion_" .. id)
	if oldModel then oldModel:Destroy() end

	local model = Instance.new("Model")
	model.Name = "Companion_" .. id
	local body = Instance.new("Part")
	body.Name = "Body"
	body.Shape = Enum.PartType.Ball
	body.Size = Vector3.new(3, 3, 3)
	body.CFrame = CFrame.new(0, 68, 0)
	body.Anchored = true
	body.CanCollide = false
	body.CanTouch = false
	body.CanQuery = false
	body.Material = Enum.Material.SmoothPlastic
	body.Color = Color3.fromRGB(116, 218, 133)
	body.Parent = model

	-- A pale belly, clear eyes, smile, little feet, and leaf tuft give Sprout a readable face.
	addWeldedPart(model, body, "Belly", Vector3.new(1.75, 1.85, 0.28), CFrame.new(0, -0.35, -1.35), Color3.fromRGB(190, 241, 156), Enum.PartType.Ball)
	for _, side in { -1, 1 } do
		addWeldedPart(model, body, "EyeWhite", Vector3.new(0.62, 0.72, 0.25), CFrame.new(side * 0.48, 0.42, -1.38), Color3.fromRGB(255, 255, 255), Enum.PartType.Ball)
		addWeldedPart(model, body, "Pupil", Vector3.new(0.25, 0.34, 0.14), CFrame.new(side * 0.48, 0.4, -1.58), Color3.fromRGB(35, 48, 55), Enum.PartType.Ball)
		addWeldedPart(model, body, "Foot", Vector3.new(0.82, 0.48, 0.9), CFrame.new(side * 0.82, -1.35, -0.05), Color3.fromRGB(83, 177, 103), Enum.PartType.Ball)
	end
	addWeldedPart(model, body, "Smile", Vector3.new(0.38, 0.14, 0.12), CFrame.new(0, -0.05, -1.55), Color3.fromRGB(56, 91, 62), Enum.PartType.Ball)
	addWeldedPart(model, body, "Leaf", Vector3.new(0.62, 1.05, 0.3), CFrame.new(0, 1.55, 0) * CFrame.Angles(0, 0, math.rad(-18)), Color3.fromRGB(66, 174, 89), Enum.PartType.Ball)

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "Nameplate"
	billboard.Size = UDim2.fromOffset(180, 48)
	billboard.StudsOffset = Vector3.new(0, 2.7, 0)
	billboard.AlwaysOnTop = true
	billboard.Adornee = body
	billboard.Parent = model
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = "Baby Sprout"
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.3
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.Parent = billboard

	model.PrimaryPart = body
	model.Parent = workspace
	return model
end

local function updateState(player: Player)
	local state = states[player.UserId]
	if not state then return end
	local stage = getStage(state.GrowthXP)
	state.StageId = stage.Id
	player:SetAttribute("MonsterName", state.SpeciesId)
	player:SetAttribute("MonsterXP", state.GrowthXP)
	player:SetAttribute("MonsterStage", state.StageId)

	local model = workspace:FindFirstChild("Companion_" .. player.UserId)
	if not model then return end
	model:SetAttribute("Stage", state.StageId)
	model:SetAttribute("GrowthXP", state.GrowthXP)
	local label = model:FindFirstChild("Nameplate") and model.Nameplate:FindFirstChildWhichIsA("TextLabel")
	if label then label.Text = stage.Name end
	local ratio = stage.Scale + (state.GrowthXP / Config.MaxXP) * 0.15
	model:ScaleTo(ratio)
end

local function createCompanion(player: Player)
	if initialized[player.UserId] then return end
	initialized[player.UserId] = true
	states[player.UserId] = {
		SpeciesId = "Sprout",
		GrowthXP = 0,
		StageId = Config.GrowthStages[1].Id,
	}
	makeCompanion(player)
	updateState(player)
end

local function onFeed(player: Player, foodId)
	local state = states[player.UserId]
	if not state then return end
	local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return end
	local now = os.clock()
	if now - (lastFeedAt[player.UserId] or 0) < FEED_COOLDOWN then return end
	lastFeedAt[player.UserId] = now
	if state.GrowthXP >= Config.MaxXP then
		feedFeedback:FireClient(player, false, 0)
		return
	end

	local foodXP = FoodService.TryConsume(player, foodId)
	if not foodXP then
		feedFeedback:FireClient(player, false, 0)
		return
	end
	local grantedXP = math.min(Config.MaxXP - state.GrowthXP, foodXP)
	state.GrowthXP += grantedXP
	reactionUntil[player.UserId] = now + 0.55
	updateState(player)
	feedFeedback:FireClient(player, true, grantedXP)
end

function MonsterService.GetSnapshot(player: Player)
	local state = states[player.UserId]
	if not state then return nil end
	-- Return a plain data-only table suitable for a future profile save layer.
	return {
		SpeciesId = state.SpeciesId,
		GrowthXP = state.GrowthXP,
		StageId = state.StageId,
	}
end

function MonsterService.Start()
	feedRequest.OnServerEvent:Connect(onFeed)
	Players.PlayerAdded:Connect(createCompanion)
	Players.PlayerRemoving:Connect(function(player)
		states[player.UserId] = nil
		initialized[player.UserId] = nil
		positionInitialized[player.UserId] = nil
		lastFeedAt[player.UserId] = nil
		reactionUntil[player.UserId] = nil
		local model = workspace:FindFirstChild("Companion_" .. player.UserId)
		if model then model:Destroy() end
	end)
	for _, player in Players:GetPlayers() do createCompanion(player) end

	RunService.Heartbeat:Connect(function(deltaTime)
		local now = os.clock()
		local alpha = math.clamp(deltaTime * 8, 0, 1)
		for _, player in Players:GetPlayers() do
			local character = player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local model = workspace:FindFirstChild("Companion_" .. player.UserId)
			if root and model and model:IsA("Model") then
				local bob = math.sin(now * 3 + player.UserId % 17) * 0.12
				if now < (reactionUntil[player.UserId] or 0) then
					bob += math.sin((now - (reactionUntil[player.UserId] - 0.55)) * math.pi / 0.55) * 1.2
				end
				local position = root.Position + root.CFrame.RightVector * FOLLOW_OFFSET.X + Vector3.new(0, FOLLOW_OFFSET.Y + bob, 0)
				-- Turn the face slightly toward the owner's over-the-shoulder view.
				local facePoint = root.Position - root.CFrame.LookVector * 2
				local lookAt = Vector3.new(facePoint.X, position.Y, facePoint.Z)
				local target = CFrame.lookAt(position, lookAt)
				if not positionInitialized[player.UserId] then
					model:PivotTo(target)
					positionInitialized[player.UserId] = true
				else
					model:PivotTo(model:GetPivot():Lerp(target, alpha))
				end
			end
		end
	end)
end

return MonsterService
