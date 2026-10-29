local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Config=require(RS.Shared.QuestConfig)
local Service={}
local profiles={}
local known={}
for _,quest in Config do known[quest.Id]=true end
local function advance(player)
	local profile=profiles[player]
	if not profile then return end
	while profile.Step<=#Config do
		local quest=Config[profile.Step]
		if not profile.Facts[quest.Id] then break end
		-- Award and advance synchronously; duplicate events cannot pay twice.
		if not require(script.Parent.FarmService).AddCoins(player,quest.Reward) then break end
		profile.Step+=1
	end
	player:SetAttribute("QuestStep",profile.Step)
	player:SetAttribute("QuestComplete",profile.Step>#Config)
end
function Service.Init(player,saved)
	if profiles[player] then return end
	local data={Step=1,Facts={}}
	if type(saved)=="table" then
		local step=tonumber(saved.Step) or 1
		if step==step and math.abs(step)<math.huge then data.Step=math.clamp(math.floor(step),1,#Config+1) end
		if type(saved.Facts)=="table" then
			for id,value in saved.Facts do if known[id] and value==true then data.Facts[id]=true end end
		end
	end
	local monster=require(script.Parent.MonsterService).GetSnapshot(player)
	if monster and monster.Hatched then data.Facts.Hatch=true end
	if monster and monster.GrowthXP>0 then data.Facts.Feed=true end
	if monster and monster.Path then data.Facts.Evolve=true end
	profiles[player]=data
	advance(player)
end
function Service.Record(player,id)
	local profile=profiles[player]
	if not profile or not known[id] or not require(script.Parent.FarmService).CanChange(player) then return end
	profile.Facts[id]=true
	advance(player)
end
function Service.GetSnapshot(player)
	local p=profiles[player]
	return p and {Step=p.Step,Facts=table.clone(p.Facts)} or nil
end
function Service.Start()
	Players.PlayerRemoving:Connect(function(player)
		-- FarmService captures the snapshot before this cleanup can run.
		task.delay(30,function() profiles[player]=nil end)
	end)
	task.spawn(function()
		while true do
			task.wait(0.5)
			for player,p in profiles do
				if not player.Parent or not p.Facts.Feed or p.Facts.Home then continue end
				local island=workspace:FindFirstChild("Island_"..player.UserId)
				local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
				if island and root and hum and hum.Health>0 and (root.Position-island.Grass.Position).Magnitude<28 then Service.Record(player,"Home") end
			end
		end
	end)
end
return Service
