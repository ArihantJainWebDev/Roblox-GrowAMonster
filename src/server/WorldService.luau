local Map=require(game.ReplicatedStorage.Shared.WorldConfig)
local Terrain=workspace.Terrain
local Players=game:GetService("Players")
local Service={}
local function part(parent,name,size,pos,color,material)
	local p=Instance.new("Part");p.Name,p.Size,p.Position=name,size,pos
	p.Anchored,p.Color,p.Material=true,color,material or Enum.Material.SmoothPlastic
	p.TopSurface,p.BottomSurface=Enum.SurfaceType.Smooth,Enum.SurfaceType.Smooth;p.Parent=parent
	return p
end
function Service.PrepareTemplate()
	local archive=game.ServerStorage:FindFirstChild("PrototypeArchive") or Instance.new("Folder")
	archive.Name,archive.Parent="PrototypeArchive",game.ServerStorage
	for _,name in {"Baseplate","SpawnLocation","SkyGardenSample","OriginalAssetStudy","AssetReviewStage","FountainCourtyard","GrowAMonsterWorld","ElementGrove","FoodNodes"} do
		local old=workspace:FindFirstChild(name);if old then old.Parent=archive end
	end
end
local function buildZone(zone)
	local minX=math.floor((zone.X-zone.RX*1.1)/4)*4;local maxX=math.ceil((zone.X+zone.RX*1.1)/4)*4
	local minZ=math.floor((zone.Z-zone.RZ*1.1)/4)*4;local maxZ=math.ceil((zone.Z+zone.RZ*1.1)/4)*4
	local minY=math.floor((zone.Y-zone.Depth-8)/4)*4;local maxY=math.ceil((zone.Y+64)/4)*4
	for x0=minX,maxX-1,32 do
		local x1=math.min(x0+32,maxX)
		local materials,occupancies={},{}
		for ix=1,(x1-x0)/4 do
			materials[ix],occupancies[ix]={},{};local x=x0+(ix-.5)*4
			for iy=1,(maxY-minY)/4 do materials[ix][iy],occupancies[ix][iy]={},{} end
			for iz=1,(maxZ-minZ)/4 do
				local z=minZ+(iz-.5)*4;local top,r,edge=Map.ZoneHeight(zone,x,z)
				local bottom=zone.Y-zone.Depth*math.max(0,1-r/edge)^.55
				for iy=1,(maxY-minY)/4 do
					local y=minY+(iy-.5)*4
					local occupancy=math.clamp(math.min((top-y)/4+.5,(y-bottom)/4+.5,(edge-r)*math.min(zone.RX,zone.RZ)/4+.5),0,1)
					local material=Enum.Material.Air
					if occupancy>0 then
						local depth=top-y
						material=depth<5 and Enum.Material.Grass or depth<12 and Enum.Material.Ground or (math.floor((y+math.noise(x*.03,z*.03)*5)/18)%3==0 and Enum.Material.Slate or Enum.Material.Rock)
					end
					materials[ix][iy][iz]=material;occupancies[ix][iy][iz]=occupancy
				end
			end
		end
		Terrain:WriteVoxels(Region3.new(Vector3.new(x0,minY,minZ),Vector3.new(x1,maxY,maxZ)),4,materials,occupancies)
		task.wait()
	end
end
function Service.BuildHome(slot)
	local center=Map.HomeCenter(slot)
	buildZone({Id="Home",X=center.X,Z=center.Z,RX=57,RZ=62,Y=420,Depth=75})
	return Vector3.new(center.X,assert(Service.SurfaceAt(center.X,center.Z))-2,center.Z)
end
function Service.SurfaceAt(x,z)
	local p=RaycastParams.new();p.FilterType=Enum.RaycastFilterType.Include;p.FilterDescendantsInstances={Terrain}
	local hit=workspace:Raycast(Vector3.new(x,650,z),Vector3.new(0,-500,0),p)
	return hit and hit.Position.Y or nil
end
local function bridge(parent,a,b)
	local direction=b-a;local count=math.ceil(direction.Magnitude/3)
	for i=0,count-1 do
		local p=a:Lerp(b,(i+.5)/count)
		local deck=part(parent,"BridgeDeck",Vector3.new(12,.65,direction.Magnitude/count+.06),p-Vector3.new(0,.325,0),Color3.fromRGB(145,107,71),Enum.Material.WoodPlanks)
		deck.CFrame=CFrame.lookAt(deck.Position,deck.Position+direction)
		if i%3==0 then for _,side in {-1,1} do
			local v=deck.CFrame:PointToWorldSpace(Vector3.new(side*5.8,1.7,0))
			part(parent,"BridgePost",Vector3.new(.55,3.7,.55),v,Color3.fromRGB(104,76,49),Enum.Material.Wood)
		end end
	end
	local right=CFrame.lookAt(a,b).RightVector
	for _,side in {-1,1} do
		local p=(a+b)/2+right*side*5.8+Vector3.new(0,3,0)
		local rail=part(parent,"BridgeRail",Vector3.new(.4,.4,direction.Magnitude),p,Color3.fromRGB(104,76,49),Enum.Material.Wood)
		rail.CFrame=CFrame.lookAt(p,p+direction)
	end
end
local function atmosphere()
	local light=game:GetService("Lighting");light.ClockTime,light.Brightness=14.5,2.6
	light.Ambient=Color3.fromRGB(94,112,128);light.OutdoorAmbient=Color3.fromRGB(140,151,160)
	light.FogStart,light.FogEnd=1800,4500
	local air=light:FindFirstChild("SkyWorldAtmosphere") or Instance.new("Atmosphere")
	air.Name,air.Density,air.Offset,air.Haze,air.Glare="SkyWorldAtmosphere",.22,.12,1.5,.15
	air.Color,air.Decay=Color3.fromRGB(193,216,230),Color3.fromRGB(117,143,159);air.Parent=light
	local clouds=Terrain:FindFirstChildOfClass("Clouds") or Instance.new("Clouds")
	clouds.Cover,clouds.Density,clouds.Color=.55,.55,Color3.fromRGB(241,243,242);clouds.Parent=Terrain
	Terrain:SetMaterialColor(Enum.Material.Grass,Color3.fromRGB(102,143,77))
	Terrain:SetMaterialColor(Enum.Material.Rock,Color3.fromRGB(123,123,111))
	Terrain:SetMaterialColor(Enum.Material.Slate,Color3.fromRGB(102,109,113))
end
function Service.Start()
	local existing=workspace:FindFirstChild("WorldFoundation")
	if not existing or existing:GetAttribute("Version")~=Map.Version then
		if existing then existing:Destroy() end
		Service.PrepareTemplate()
		local world=Instance.new("Model");world.Name="WorldFoundation";world.Parent=workspace
		for _,zone in Map.Zones do buildZone(zone) end
		-- Carved spring and continuous shallow water channel on the orchard's north terrace.
		local orchard=Map.Zones[2]
		local springY=Map.ZoneHeight(orchard,340,-210)
		Terrain:FillBall(Vector3.new(340,springY-2,-210),11,Enum.Material.Air)
		Terrain:FillBall(Vector3.new(340,springY-5,-210),8,Enum.Material.Water)
		local stream={Vector2.new(340,-210),Vector2.new(300,-222),Vector2.new(250,-232),Vector2.new(200,-239),Vector2.new(150,-240)}
		for i=1,#stream-1 do
			local a,b=stream[i],stream[i+1];local steps=math.ceil((b-a).Magnitude/3)
			for j=0,steps do
				local p=a:Lerp(b,j/steps);local y=Map.ZoneHeight(orchard,p.X,p.Y)
				Terrain:FillBall(Vector3.new(p.X,y-1,p.Y),5,Enum.Material.Air)
				Terrain:FillBall(Vector3.new(p.X,y-3,p.Y),3.5,Enum.Material.Water)
			end
			task.wait()
		end
		local anchors=Instance.new("Folder");anchors.Name="LandmarkAnchors";anchors.Parent=world
		for i,point in {Vector2.new(190,-160),Vector2.new(245,-210),Vector2.new(310,-122),Vector2.new(365,-185),Vector2.new(260,200),Vector2.new(340,220)} do
			local y=Service.SurfaceAt(point.X,point.Y)
			local anchor=part(anchors,"Tree"..i,Vector3.one,Vector3.new(point.X,y,point.Y),Color3.new(1,1,1));anchor.Transparency,anchor.CanCollide,anchor.CanQuery=1,false,false
		end
		local connections=Instance.new("Folder");connections.Name="Bridges";connections.Parent=world
		for _,route in Map.Bridges do bridge(connections,route.A+Vector3.new(0,2,0),route.B+Vector3.new(0,2,0)) end
		for _,route in Map.Routes do for i=1,#route.Points-1 do
			local a,b=route.Points[i],route.Points[i+1];local count=math.max(1,math.floor((b-a).Magnitude/14))
			for j=0,count do
				local p=a:Lerp(b,j/count);local y=Service.SurfaceAt(p.X,p.Z)
				if y and math.abs(y-p.Y)<5 then
					local stone=part(world,"TrailStone",Vector3.new(5,.25,4),Vector3.new(p.X,y+.1,p.Z),Color3.fromRGB(192,184,157),Enum.Material.Limestone)
					stone.CanCollide=false
				end
			end
		end end
		local spawn=Instance.new("SpawnLocation");spawn.Name="HubSpawn";spawn.Anchored=true
		spawn.Size,spawn.Position,spawn.Transparency=Vector3.new(8,1,8),Map.HubArrival-Vector3.new(0,3,0),1
		spawn.Neutral,spawn.Duration,spawn.Parent=true,0,world
		world:SetAttribute("Version",Map.Version);world:SetAttribute("Ready",true)
	end
	atmosphere()
	task.spawn(function()
		while true do task.wait(.3)
			for _,player in Players:GetPlayers() do
				local character=player.Character;local root=character and character:FindFirstChild("HumanoidRootPart")
				local hum=character and character:FindFirstChildOfClass("Humanoid")
				if root and hum and hum.Health>0 and root.Position.Y<Map.RecoveryY then
					root.AssemblyLinearVelocity=Vector3.zero
					local home=workspace:FindFirstChild("Island_"..player.UserId)
					local destination=home and home:FindFirstChild("HomeSpawn")
					character:PivotTo(CFrame.new(destination and destination.Position+Vector3.new(0,4,0) or Map.HubArrival))
					player:SetAttribute("CurrentRegion",destination and "Home" or "Hub")
				end
			end
		end
	end)
end
return Service
