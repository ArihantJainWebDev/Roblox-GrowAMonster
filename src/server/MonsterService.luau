local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("MonsterConfig"))
local Evolution = require(ReplicatedStorage.Shared:WaitForChild("EvolutionConfig"))

local MonsterService = {}
local FoodService = require(script.Parent:WaitForChild("FoodService"))
local FEED_COOLDOWN = 1.5
local commandTimes = {}
local Motion = require(script.Parent.CompanionMotion)
local Navigation = require(script.Parent.CompanionNavigation)
local followers = {}
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
local commandRequest = getOrCreateRemote("CompanionCommand")
local commandFeedback = getOrCreateRemote("CompanionFeedback")
local function action(model,kind,duration,food)
 model:SetAttribute("Action",kind);model:SetAttribute("ActionDuration",duration)
 model:SetAttribute("ActionFood",food or "")
 model:SetAttribute("ActionStarted",workspace:GetServerTimeNow())
 model:SetAttribute("HoldUntil",os.clock()+duration)
end

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
 model.PrimaryPart=body
 local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
 if root then body.CFrame=CFrame.new(root.Position-root.CFrame.LookVector*4) end
 model:SetAttribute("CommandMode","Follow");player:SetAttribute("CompanionMode","Follow")
 model.Parent=workspace
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
 local ratio=stage.Id=="Young" and (1+math.max(0,state.GrowthXP-100)/200*.1) or (1+state.GrowthXP/100*.15)
 model:SetAttribute("VisualScale",ratio)
 model:SetAttribute("Path",state.Path or "")
 if model:FindFirstChild("Nameplate") then model.Nameplate.StudsOffset=Vector3.new(0,(stage.Id=="Young" and 3.15 or 2.5)*ratio+.35,0) end

end

local function createCompanion(player: Player)
	if initialized[player.UserId] then return end
	initialized[player.UserId] = true
 player.CharacterAdded:Connect(function()
  followers[player.UserId]=nil
  local model=workspace:FindFirstChild("Companion_"..player.UserId)
  if model then
   model:SetAttribute("CommandMode","Follow");model:SetAttribute("HoldUntil",0)
   model:SetAttribute("ActionDuration",0);model:SetAttribute("InteractionGoal",nil)
  end
  player:SetAttribute("CompanionMode","Follow")
  require(script.Parent.ExplorationService).Cancel(player)
 end)
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
 local companion=workspace:FindFirstChild("Companion_"..player.UserId)
 if companion and (companion:GetAttribute("HoldUntil") or 0)>now then feedFeedback:FireClient(player,false,0,"Sprout is busy for a moment");return end
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
	local wasYoung=state.GrowthXP>=Evolution.AtXP
	local grantedXP = math.min(cap - state.GrowthXP, foodXP)
	state.GrowthXP += grantedXP
	reactionUntil[player.UserId] = now + 0.55
 if companion then
  companion:SetAttribute("LastReaction",workspace:GetServerTimeNow())
  action(companion,not wasYoung and state.GrowthXP>=Evolution.AtXP and "Grow" or "Feed",not wasYoung and state.GrowthXP>=Evolution.AtXP and 3 or 1.4,foodId)
 end
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
 local model=makeCompanion(player)
 local island=workspace:FindFirstChild("Island_"..player.UserId)
 local egg=island and island:FindFirstChild("WelcomeEgg")
 local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
 if egg and root then
  local position=(egg:GetAttribute("GroundPosition") or egg.Position-Vector3.yAxis*1.5)+Vector3.yAxis*.29
  local delta=Vector3.new(root.Position.X-position.X,0,root.Position.Z-position.Z)
  local forward=delta.Magnitude>.01 and delta.Unit or Vector3.new(0,0,-1)
  model:PivotTo(CFrame.lookAt(position,position+forward))
  followers[player.UserId]=Motion.New(position,forward,root.Position)
  followers[player.UserId].GroundY=position.Y-.29
  egg:SetAttribute("HatchStartedAt",workspace:GetServerTimeNow())
 end
 action(model,"Hatch",2.8)
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
 local companion=workspace:FindFirstChild("Companion_"..player.UserId)
 if companion and (companion:GetAttribute("HoldUntil") or 0)>os.clock() then return false,"Sprout is busy for a moment" end
 state.Path = pathId
 if companion then action(companion,"Evolve",2.8) end
 updateState(player)
	require(script.Parent.QuestService).Record(player,"Evolve")
	reactionUntil[player.UserId] = os.clock() + 0.55
	return true, "Evolved into " .. Evolution.Paths[pathId].Name .. "! Element Grove unlocked."
end

function MonsterService.BeginAction(player,kind,duration,target)
 local model=workspace:FindFirstChild("Companion_"..player.UserId)
 if not model or (model:GetAttribute("HoldUntil") or 0)>os.clock() then return false end
 model:SetAttribute("ActionTarget",target)
 local follower=followers[player.UserId]
 if follower and typeof(target)=="Vector3" then
  local delta=Vector3.new(target.X-model.Body.Position.X,0,target.Z-model.Body.Position.Z)
  if delta.Magnitude>.01 then follower.Forward=delta.Unit end
 end
 action(model,kind,duration);return true
end

function MonsterService.Command(player,command)
 if typeof(command)~="string" or not ({Follow=true,Stay=true,Come=true,Pet=true,Interact=true})[command] then return false,"Choose a companion command" end
 local state=states[player.UserId]
 local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
 local humanoid=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
 local model=workspace:FindFirstChild("Companion_"..player.UserId)
 if not state or not state.Hatched or not model or not root or not humanoid or humanoid.Health<=0 then return false,"Hatch Sprout and respawn first" end
 local now=os.clock()
 if now-(commandTimes[player.UserId] or -10)<.35 then return false,"Give Sprout a moment" end
 commandTimes[player.UserId]=now
 if (model:GetAttribute("HoldUntil") or 0)>now then return false,"Sprout is busy for a moment" end
 local distance=(model.Body.Position-root.Position).Magnitude
 if command=="Interact" then return require(script.Parent.ExplorationService).Interact(player) end
 if model:GetAttribute("InteractionGoal") then
  if command=="Pet" then return false,"Sprout is approaching the bloom" end
  require(script.Parent.ExplorationService).Cancel(player)
 end
 if command=="Pet" then
  if distance>10 then return false,"Come closer to pet Sprout" end
  action(model,"Pet",1.8);return true,"Sprout loves the attention!"
 end
 if command=="Stay" and distance>15 then return false,"Come closer before asking Sprout to stay" end
 local mode=command=="Stay" and "Stay" or "Follow"
 model:SetAttribute("CommandMode",mode);player:SetAttribute("CompanionMode",mode)
 local follower=followers[player.UserId]
 if follower then follower.Waypoints=nil;follower.Speed=0;follower.Walking=false end
 return true,command=="Stay" and "Sprout will wait here. Call with R or the Recall button." or "Sprout is following you"
end

function MonsterService.Start()
 commandRequest.OnServerEvent:Connect(function(player,command)
  local ok,message=MonsterService.Command(player,command);commandFeedback:FireClient(player,ok,message)
 end)
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
        followers[player.UserId] = nil
        commandTimes[player.UserId] = nil
		lastFeedAt[player.UserId] = nil
		reactionUntil[player.UserId] = nil
		local model = workspace:FindFirstChild("Companion_" .. player.UserId)
		if model then model:Destroy() end
	end)
	for _, player in Players:GetPlayers() do createCompanion(player) end

 RunService.Heartbeat:Connect(function(deltaTime)
  for _,player in Players:GetPlayers() do
   local character=player.Character;local root=character and character:FindFirstChild("HumanoidRootPart")
   local model=workspace:FindFirstChild("Companion_"..player.UserId)
   local hum=character and character:FindFirstChildOfClass("Humanoid")
   if root and model and hum and hum.Health>0 then
    local state=followers[player.UserId]
    local relocated=not state or (root.Position-state.LastOwner).Magnitude>65
    if relocated then
     local initial=root.Position-root.CFrame.LookVector*4
     state=Motion.New(initial,root.CFrame.LookVector,root.Position);followers[player.UserId]=state
     model:SetAttribute("Relocation",(model:GetAttribute("Relocation") or 0)+1)
    end
    if relocated then model:SetAttribute("CommandMode","Follow");player:SetAttribute("CompanionMode","Follow") end
    local stay=model:GetAttribute("CommandMode")=="Stay"
    if stay and (root.Position-state.Position).Magnitude>50 then
     model:SetAttribute("CommandMode","Follow");player:SetAttribute("CompanionMode","Follow");stay=false
    end
    if (model:GetAttribute("HoldUntil") or 0)>os.clock() or stay then
     state.LastOwner=root.Position;state.Speed=0;model:SetAttribute("MoveSpeed",0);continue
    end
    local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
    local excluded={model}
    for _,other in Players:GetPlayers() do
     if other.Character then table.insert(excluded,other.Character) end
     local companion=workspace:FindFirstChild("Companion_"..other.UserId);if companion then table.insert(excluded,companion) end
    end
    params.FilterDescendantsInstances=excluded;params.IgnoreWater=true;params.RespectCanCollide=true
    local now=os.clock()
    local destination=model:GetAttribute("InteractionGoal") or root.Position
    local target=Navigation.Target(state,destination,params,now)
    local pos=Motion.Step(state,destination,deltaTime,target)
    local hit=workspace:Raycast(Vector3.new(pos.X,math.max(root.Position.Y+12,state.Position.Y+8),pos.Z),Vector3.new(0,-70,0),params)
    local previousGround=state.GroundY or (relocated and hit and hit.Position.Y) or state.Position.Y
    local step=hit and hit.Position.Y-previousGround
    local advance=Vector3.new(pos.X-state.Position.X,0,pos.Z-state.Position.Z)
    local barrier=false
    if advance.Magnitude>.001 then
     local wall=workspace:Raycast(state.Position+Vector3.yAxis*1.2,advance.Unit*(advance.Magnitude+.7),params)
     if wall then
      local top=workspace:Raycast(wall.Position+advance.Unit*.25+Vector3.yAxis*6,-Vector3.yAxis*12,params)
      local rise=top and top.Position.Y-previousGround
      barrier=not rise or rise>4.5
      if wall.Instance:IsA("BasePart") then
       local obstacle=wall.Instance;local frame,size=obstacle.CFrame,obstacle.Size
       local topY=obstacle.Position.Y+(math.abs(frame.RightVector.Y)*size.X+math.abs(frame.UpVector.Y)*size.Y+math.abs(frame.LookVector.Y)*size.Z)/2
       if topY-previousGround>4.5 then barrier=true end
      end
      if not barrier and rise>1.25 and not state.JumpAt then state.JumpAt=now end
     end
    end
    if hit and not barrier and (relocated or (step<4.5 and step> -5)) then
     if step>1.25 and not state.JumpAt then state.JumpAt=now end
     state.GroundY=hit.Position.Y
     local height=relocated and hit.Position.Y or state.Position.Y
     height+=math.clamp(hit.Position.Y-height,-16*deltaTime,12*deltaTime)
     local lift=0
     if state.JumpAt then
      local t=(now-state.JumpAt)/.5
      if t>=1 then state.JumpAt=nil else lift=math.sin(t*math.pi)*1.2 end
     end
     pos=Vector3.new(pos.X,height,pos.Z)
     local up=hit.Normal.Y>.85 and hit.Normal or Vector3.yAxis
     local forward=(state.Forward-up*state.Forward:Dot(up)).Unit
     model:PivotTo(CFrame.lookAt(pos+Vector3.yAxis*lift,pos+Vector3.yAxis*lift+forward,up));state.Position=pos
     state.BlockedSince=nil
    else
     state.Speed=0;state.BlockedSince=state.BlockedSince or now
     if now-state.BlockedSince>4 and (root.Position-state.Position).Magnitude>12 then
      -- Last-resort recovery only after failed navigation; never replay a stale route.
      followers[player.UserId]=nil
     end
    end
    model:SetAttribute("MoveSpeed",state.Speed)
   end
  end
 end)
end

return MonsterService
