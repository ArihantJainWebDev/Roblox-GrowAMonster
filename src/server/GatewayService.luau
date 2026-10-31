local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Map=require(RS.Shared.WorldConfig)
local Service={}
local homes,lastTravel,travelling={},{},{}
local function feedback(player,text)
	local event=RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("CollectFeedback")
	if event then event:FireClient(player,false,text) end
end
function Service.Travel(player,destination,gate)
	if destination~="Home" and destination~="Hub" then return false,"Invalid destination" end
	local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if not root or not hum or hum.Health<=0 then return false,"Respawn first" end
	if not gate or not gate:IsDescendantOf(workspace) or (root.Position-gate.Position).Magnitude>12 then return false,"Move closer to the gateway" end
	local home=homes[player]
	if destination=="Home" and gate.Name~="HomeGateway" then return false,"Invalid gateway" end
	if destination=="Hub" and (not home or gate~=home.Gate) then return false,"This is not your gateway" end
	if travelling[player] or os.clock()-(lastTravel[player] or -10)<3 then return false,"Gateway recharging" end
	if not home or not home.Spawn.Parent then return false,"Your home is still loading" end
	lastTravel[player]=os.clock()
	local target=destination=="Home" and home.Spawn.Position+Vector3.new(0,4,0) or Map.HubArrival
	travelling[player]=true
	pcall(function() player:RequestStreamAroundAsync(target,3) end)
	travelling[player]=nil
	if not root.Parent or hum.Health<=0 then return false,"Respawn first" end
	root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero
	player.Character:PivotTo(CFrame.new(target))
	player:SetAttribute("CurrentRegion",destination)
	feedback(player,destination=="Home" and "Welcome home" or "Welcome to the Sky Gardens • Orchard and Grove trails ahead")
	return true
end
local function makeGate(parent,name,position,label,destination,owner)
	local surface=require(script.Parent.WorldService).SurfaceAt
	local y=assert(surface(position.X,position.Z))
	position=Vector3.new(position.X,y,position.Z)
 -- Replace only this gateway's legacy frame/threshold if it already exists in the place.
 for _,old in parent:GetChildren() do
  if old:IsA("BasePart") and (old.Name==name or ((old.Name=="GatewayPillar" or old.Name=="GatewayLintel" or old.Name=="GatewayThreshold") and (old.Position-position).Magnitude<14)) then old:Destroy() end
 end
 local p=Instance.new("Part");p.Name,p.Size,p.Position=name,Vector3.new(7,7,1),position+Vector3.new(0,3.5,0)
	p.Anchored,p.CanCollide,p.Transparency,p.Material,p.Color=true,false,1,Enum.Material.Neon,Color3.fromRGB(111,204,197);p.Parent=parent
	local left=surface(position.X-4.4,position.Z) or y
	local right=surface(position.X+4.4,position.Z) or y
	p:SetAttribute("LeftFootY",left);p:SetAttribute("RightFootY",right)
	local bottom=math.min(y,left,right)-.6
	local threshold=Instance.new("Part");threshold.Name="GatewayThreshold";threshold.Size=Vector3.new(9.8,y+.08-bottom,3.4)
	threshold.Position=Vector3.new(position.X,(y+.08+bottom)/2,position.Z);threshold.Anchored=true
	threshold.Material=Enum.Material.Limestone;threshold.Color=Color3.fromRGB(155,153,132);threshold.Parent=parent
 require(script.Parent.GatewayFrame).Build(p,position,left,right)
	local prompt=Instance.new("ProximityPrompt");prompt.ActionText,prompt.ObjectText,prompt.HoldDuration,prompt.MaxActivationDistance="Travel",label,.35,10
	prompt.RequiresLineOfSight=false;prompt.Parent=p
	prompt.Triggered:Connect(function(player)
		if owner and owner~=player then feedback(player,"This gateway belongs to another player");return end
		local ok,message=Service.Travel(player,destination,p);if not ok then feedback(player,message) end
	end)
	return p
end
function Service.RegisterHome(player,island,center)
	local gate=makeGate(island,"ReturnGateway",center+Vector3.new(-16,2,-15),"Return to Hub","Hub",player)
	homes[player]={Gate=gate,Spawn=island.HomeSpawn}
	player:SetAttribute("CurrentRegion","Home")
end
function Service.Start()
	local point=Map.HomeGateway
	local y=assert(require(script.Parent.WorldService).SurfaceAt(point.X,point.Z))
	makeGate(workspace.WorldFoundation,"HomeGateway",Vector3.new(point.X,y,point.Z),"Your Home","Home")
	Players.PlayerRemoving:Connect(function(p) homes[p],lastTravel[p],travelling[p]=nil,nil,nil end)
end
return Service
