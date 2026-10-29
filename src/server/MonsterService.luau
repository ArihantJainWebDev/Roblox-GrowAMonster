local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("MonsterConfig"))
local Evolution = require(ReplicatedStorage.Shared:WaitForChild("EvolutionConfig"))

local MonsterService = {}
local FoodService = require(script.Parent:WaitForChild("FoodService"))
local FEED_COOLDOWN = 0.8
local FOLLOW_OFFSET = Vector3.new(3.5, -1.3, 0)
local states = {}
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
local evolveRequest = getOrCreateRemote("EvolveMonster")
local evolveFeedback = getOrCreateRemote("EvolutionFeedback")

local function getStage(xp: number)
	for index = #Config.GrowthStages, 1, -1 do
		if xp >= Config.GrowthStages[index].AtXP then
			return Config.GrowthStages[index]
		end
	end
	return Config.GrowthStages[1]
end

local function makeCompanion(player: Player)
 local old=workspace:FindFirstChild("Companion_"..player.UserId);if old then old:Destroy() end
 local model=Instance.new("Model");model.Name="Companion_"..player.UserId;model:SetAttribute("OwnerUserId",player.UserId)
 local body=Instance.new("Part");body.Name="Body";body.Size=Vector3.new(.2,.2,.2);body.Transparency=1
 body.Anchored,body.CanCollide,body.CanTouch,body.CanQuery=true,false,false,false;body.Parent=model
 local label=Instance.new("BillboardGui");label.Name="Nameplate";label.Size=UDim2.fromOffset(130,24)
 label.StudsOffset=Vector3.new(0,2.9,0);label.MaxDistance=35;label.Adornee=body;label.Parent=model
 local text=Instance.new("TextLabel");text.Size=UDim2.fromScale(1,1);text.BackgroundTransparency=1;text.Text="Baby Sprout"
 text.TextSize=13;text.TextColor3=Color3.fromRGB(235,243,223);text.TextStrokeTransparency=.4;text.Font=Enum.Font.GothamBold;text.Parent=label
 model.PrimaryPart=body;model.Parent=workspace
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
	player:SetAttribute("MonsterHatched",state.Hatched==true)
	player:SetAttribute("MonsterPath", state.Path or "")
	player:SetAttribute("MonsterGrowthCap", state.Path and Evolution.MaxXP or Evolution.AtXP)
	player:SetAttribute("ExplorationUnlocked", state.Path ~= nil)

	local model = workspace:FindFirstChild("Companion_" .. player.UserId)
	if not model then return end
	model:SetAttribute("Stage", state.StageId)
	model:SetAttribute("GrowthXP", state.GrowthXP)
	local label = model:FindFirstChild("Nameplate") and model.Nameplate:FindFirstChildWhichIsA("TextLabel")
	local path = state.Path and Evolution.Paths[state.Path]
	if label then label.Text = path and path.Name or stage.Name end
 local ratio=stage.Scale+(state.GrowthXP/Config.MaxXP)*.15
 model:SetAttribute("VisualScale",ratio)
 model:SetAttribute("Path",state.Path or "")
 if model:FindFirstChild("Nameplate") then model.Nameplate.StudsOffset=Vector3.new(0,2.5*ratio+.35,0) end

end

local function createCompanion(player: Player)
	if initialized[player.UserId] then return end
	initialized[player.UserId] = true
	states[player.UserId] = {
		SpeciesId = "Sprout",
		GrowthXP = 0,
		StageId = Config.GrowthStages[1].Id,
	}
	updateState(player)
end

local function onFeed(player: Player, foodId)
	local state = states[player.UserId]
	if not state then return end
	if not state.Hatched then return end
	if not require(script.Parent.FarmService).CanChange(player) then return end
	local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return end
	local now = os.clock()
	if now - (lastFeedAt[player.UserId] or 0) < FEED_COOLDOWN then return end
	lastFeedAt[player.UserId] = now
	local cap = state.Path and Evolution.MaxXP or Evolution.AtXP
	if state.GrowthXP >= cap then
		feedFeedback:FireClient(player, false, 0)
		return
	end

	local foodXP = FoodService.TryConsume(player, foodId)
	if not foodXP then
		feedFeedback:FireClient(player, false, 0)
		return
	end
	local grantedXP = math.min(cap - state.GrowthXP, foodXP)
	state.GrowthXP += grantedXP
	reactionUntil[player.UserId] = now + 0.55
 local companion=workspace:FindFirstChild("Companion_"..player.UserId);if companion then companion:SetAttribute("LastReaction",workspace:GetServerTimeNow()) end
	updateState(player)
	feedFeedback:FireClient(player, true, grantedXP)
	require(script.Parent.QuestService).Record(player,"Feed")
end

function MonsterService.GetSnapshot(player: Player)
	local state = states[player.UserId]
	if not state then return nil end
	-- Return a plain data-only table suitable for a future profile save layer.
	return {
		SpeciesId = state.SpeciesId,
		GrowthXP = state.GrowthXP,
		StageId = state.StageId,
		Path = state.Path,
		Hatched = state.Hatched == true,
	}
end

function MonsterService.RestoreSnapshot(player, snapshot)
	local state = states[player.UserId]
	if not state or type(snapshot) ~= "table" then return end
	state.Path = typeof(snapshot.Path) == "string" and Evolution.Paths[snapshot.Path] and snapshot.Path or nil
	local xp = tonumber(snapshot.GrowthXP) or 0
	if xp ~= xp or math.abs(xp) == math.huge then xp = 0 end
	state.GrowthXP = math.clamp(math.floor(xp), state.Path and Evolution.AtXP or 0, state.Path and Evolution.MaxXP or Evolution.AtXP)
	state.Hatched = snapshot.Hatched == true or state.GrowthXP > 0 or state.Path ~= nil
	local model=workspace:FindFirstChild("Companion_"..player.UserId)
	if state.Hatched and not model then makeCompanion(player) end
	if not state.Hatched and model then model:Destroy() end
	updateState(player)
end

function MonsterService.Hatch(player)
	local state=states[player.UserId]
	if not state or not require(script.Parent.FarmService).CanChange(player) then return false end
	if state.Hatched then return true end
	state.Hatched=true
	makeCompanion(player)
	updateState(player)
	return true
end

function MonsterService.TryEvolve(player, pathId)
	local state = states[player.UserId]
	if not state or typeof(pathId) ~= "string" or not Evolution.Paths[pathId] then return false, "Choose a valid path" end
	if not require(script.Parent.FarmService).CanChange(player) then return false, "Progress is unavailable while your data loads or reconnects" end
	local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return false, "Respawn first" end
	if state.Path then return false, "Your path is already chosen" end
	if not state.Hatched then return false,"Hatch your starter egg first" end
	if state.GrowthXP < Evolution.AtXP then return false, "Reach 100 growth first" end
	state.Path = pathId
	updateState(player)
	require(script.Parent.QuestService).Record(player,"Evolve")
	reactionUntil[player.UserId] = os.clock() + 0.55
	return true, "Evolved into " .. Evolution.Paths[pathId].Name .. "! Element Grove unlocked."
end

function MonsterService.Start()
	evolveRequest.OnServerEvent:Connect(function(player, pathId)
		local ok, message = MonsterService.TryEvolve(player, pathId)
		evolveFeedback:FireClient(player, ok, message)
	end)
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
  local alpha=1-math.exp(-math.min(deltaTime,.1)*8)
  for _,player in Players:GetPlayers() do
   local character=player.Character;local root=character and character:FindFirstChild("HumanoidRootPart")
   local model=workspace:FindFirstChild("Companion_"..player.UserId)
   if root and model then
    local desired=root.Position+root.CFrame.RightVector*3.8-root.CFrame.LookVector*.5
    local current=model:GetPivot().Position
    local snap=not positionInitialized[player.UserId] or (current-root.Position).Magnitude>40
    local pos=snap and desired or current:Lerp(desired,alpha)
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Include
    local surfaces={workspace.Terrain,workspace:FindFirstChild("WorldFoundation"),workspace:FindFirstChild("Island_"..player.UserId)}
    params.FilterDescendantsInstances=surfaces;params.IgnoreWater=true
    local hit=workspace:Raycast(Vector3.new(pos.X,root.Position.Y+12,pos.Z),Vector3.new(0,-50,0),params)
    if hit then
     pos=Vector3.new(pos.X,hit.Position.Y,pos.Z)
     local motion=Vector3.new(desired.X-current.X,0,desired.Z-current.Z)
     local forward=motion.Magnitude>.3 and motion.Unit or Vector3.new(root.CFrame.LookVector.X,0,root.CFrame.LookVector.Z)
     local up=hit.Normal.Y>.75 and hit.Normal or Vector3.yAxis
     forward=(forward-up*forward:Dot(up)).Unit
     local target=CFrame.lookAt(pos,pos+forward,up)
     model:PivotTo(target);positionInitialized[player.UserId]=true
    end
   end
  end
 end)
end

return MonsterService
