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
-- Replace material only: preserve terrain occupancy, heights and collision.
-- Roblox grows decorative blades on Grass even when a prop covers that surface.
local function clearGrass(center,width,depth)
 local region=Region3.new(center-Vector3.new(width/2,14,depth/2),center+Vector3.new(width/2,14,depth/2)):ExpandToGrid(4)
 Terrain:ReplaceMaterial(region,4,Enum.Material.Grass,Enum.Material.Ground)
end
function Service.ApplyHomeGroundCover(center)
 clearGrass(center+Vector3.new(0,2,-3),30,32) -- four beds and their aisles
 clearGrass(center+Vector3.new(3,2,18),22,16) -- spawn and egg
 clearGrass(center+Vector3.new(-16,2,-15),16,16) -- return gateway
 clearGrass(center+Vector3.new(-15,2,17),14,12) -- propagation bench
end
function Service.ApplyGroundCover()
 clearGrass(Map.Hub,68,70) -- courtyard, fountain, furniture and portico
 clearGrass(Map.HomeGateway,16,16)
 for _,ends in {{Vector3.new(-32,0,-24),Vector3.new(-48,0,-25)},{Vector3.new(32,0,-24),Vector3.new(45,0,-30)},{Vector3.new(32,0,28),Vector3.new(45,0,35)}} do
  local steps=math.ceil((ends[2]-ends[1]).Magnitude/4)
  for i=0,steps do clearGrass(Map.Hub+ends[1]:Lerp(ends[2],i/steps),10,10) end
 end
 for _,route in Map.Routes do for i=1,#route.Points-1 do
  local a,b=route.Points[i],route.Points[i+1]
  local steps=math.max(1,math.ceil((b-a).Magnitude/4))
  for j=0,steps do clearGrass(a:Lerp(b,j/steps),12,12) end
 end;task.wait() end
 local world=workspace:FindFirstChild("WorldFoundation")
 local anchors=world and world:FindFirstChild("LandmarkAnchors")
 if anchors then for _,anchor in anchors:GetChildren() do clearGrass(anchor.Position,12,12) end end
 clearGrass(Map.GroveBloom,32,32)
 clearGrass(Vector3.new(310,Service.SurfaceAt(310,197),197),34,14)
 clearGrass(Vector3.new(356,Service.SurfaceAt(356,-224),-224),18,14)
 for _,point in {Vector2.new(282,194),Vector2.new(337,207),Vector2.new(334,150)} do
  clearGrass(Vector3.new(point.X,Service.SurfaceAt(point.X,point.Y),point.Y),14,14)
 end
 for _,group in Map.TreeGroups do for _,entry in group do
  local y=Service.SurfaceAt(entry[1],entry[2]);if y then clearGrass(Vector3.new(entry[1],y,entry[2]),16,16) end
 end end
end
local function meadowCover(zone)
 local region=Region3.new(Vector3.new(zone.X-zone.RX,zone.Y-32,zone.Z-zone.RZ),Vector3.new(zone.X+zone.RX,zone.Y+64,zone.Z+zone.RZ)):ExpandToGrid(4)
 local materials,occupancy=Terrain:ReadVoxels(region,4)
 local corner=region.CFrame.Position-region.Size/2
 for x=1,materials.Size.X do for z=1,materials.Size.Z do
  local px,pz=corner.X+(x-.5)*4,corner.Z+(z-.5)*4
  local radius=((px-zone.X)/zone.RX)^2+((pz-zone.Z)/zone.RZ)^2
  if radius<.75 and math.noise(px*.035,pz*.035,7)>-.18 then
   for y=1,materials.Size.Y do if materials[x][y][z]==Enum.Material.Grass then materials[x][y][z]=Enum.Material.LeafyGrass end end
  end
 end;if x%8==0 then task.wait() end end
 Terrain:WriteVoxels(region,4,materials,occupancy)
end
function Service.BuildHome(slot)
	local center=Map.HomeCenter(slot)
	buildZone({Id="Home",X=center.X,Z=center.Z,RX=57,RZ=62,Y=420,Depth=75})
	local origin=Vector3.new(center.X,assert(Service.SurfaceAt(center.X,center.Z))-2,center.Z)
	Service.ApplyHomeGroundCover(origin)
	return origin
end
function Service.SurfaceAt(x,z)
	local p=RaycastParams.new();p.FilterType=Enum.RaycastFilterType.Include;p.FilterDescendantsInstances={Terrain}
	local hit=workspace:Raycast(Vector3.new(x,650,z),Vector3.new(0,-500,0),p)
	return hit and hit.Position.Y or nil
end
-- Cut only the deck corridor: preserve the island underside and neighbouring slopes.
local function gradeBridge(a,b)
 local ab=Vector2.new(b.X-a.X,b.Z-a.Z)
 local lo=Vector3.new(math.min(a.X,b.X)-16,math.min(a.Y,b.Y)-12,math.min(a.Z,b.Z)-16)
 local hi=Vector3.new(math.max(a.X,b.X)+16,650,math.max(a.Z,b.Z)+16)
 local region=Region3.new(lo,hi):ExpandToGrid(4)
 local m,o=Terrain:ReadVoxels(region,4)
 local corner=region.CFrame.Position-region.Size/2
 for x=1,m.Size.X do
  for z=1,m.Size.Z do
   local px,pz=corner.X+(x-.5)*4,corner.Z+(z-.5)*4
   local raw=Vector2.new(px-a.X,pz-a.Z):Dot(ab)/ab:Dot(ab)
   local t=math.clamp(raw,0,1);local p=a:Lerp(b,t)
   if raw>=-8/ab.Magnitude and raw<=1+8/ab.Magnitude and Vector2.new(px-p.X,pz-p.Z).Magnitude<12 then
    for y=1,m.Size.Y do
     local py=corner.Y+(y-.5)*4
     o[x][y][z]=math.min(o[x][y][z],math.clamp((p.Y-4.2-py)/4+.5,0,1))
     if o[x][y][z]==0 then m[x][y][z]=Enum.Material.Air
     elseif m[x][y][z]==Enum.Material.Grass then m[x][y][z]=Enum.Material.Ground end
    end
   end
  end
  if x%8==0 then task.wait() end
 end
 Terrain:WriteVoxels(region,4,m,o)
end
local function buildStoneTrails()
 for _,ends in {{Vector3.new(-32,0,-24),Vector3.new(-48,0,-25)},{Vector3.new(32,0,-24),Vector3.new(45,0,-30)},{Vector3.new(32,0,28),Vector3.new(45,0,35)}} do
  local count=math.ceil((ends[2]-ends[1]).Magnitude/3)
  for j=0,count do
   local p=Map.Hub+ends[1]:Lerp(ends[2],j/count)
   Terrain:ReplaceMaterial(Region3.new(p-Vector3.new(4,12,4),p+Vector3.new(4,18,4)):ExpandToGrid(4),4,Enum.Material.Ground,Enum.Material.Rock)
  end
 end
 for _,route in Map.Routes do for i=1,#route.Points-1 do
  local a,b=route.Points[i],route.Points[i+1]
  local steps=math.ceil((b-a).Magnitude/3)
  for j=0,steps do
   local p=a:Lerp(b,j/steps)
   local region=Region3.new(p-Vector3.new(4,10,4),p+Vector3.new(4,14,4)):ExpandToGrid(4)
   Terrain:ReplaceMaterial(region,4,Enum.Material.Ground,Enum.Material.Rock)
  end
  task.wait()
 end end
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
	-- Short stone approach ramps bridge the voxel-smoothed edge of each landing.
	local along=Vector3.new(direction.X,0,direction.Z).Unit
	for _,endInfo in {{a,-along},{b,along}} do
		local endpoint,outward=endInfo[1],endInfo[2]
		local outside=endpoint+outward*8
		local ground=Service.SurfaceAt(outside.X,outside.Z)
		if ground then
			outside=Vector3.new(outside.X,ground+.08,outside.Z)
			local inner=endpoint-Vector3.new(0,.08,0)
			gradeBridge(outside,inner)
			local frame=CFrame.lookAt((inner+outside)/2,outside)
			local ramp=part(parent,"StoneLandingRamp",Vector3.new(12,3,(outside-inner).Magnitude+.15),frame.Position-frame.UpVector*1.5,Color3.fromRGB(131,132,119),Enum.Material.Rock)
			ramp.CFrame=frame-frame.UpVector*1.5
		end
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
	Terrain:SetMaterialColor(Enum.Material.LeafyGrass,Color3.fromRGB(92,126,78))
	Terrain:SetMaterialColor(Enum.Material.Rock,Color3.fromRGB(123,123,111))
	Terrain:SetMaterialColor(Enum.Material.Slate,Color3.fromRGB(102,109,113))
end
function Service.Start()
	if game:GetService("RunService"):IsRunning() then
		for _,name in {"EditorCourtyardPreview","EditorWorldScenery"} do
			local preview=workspace:FindFirstChild(name)
			if preview then preview.Parent=game.ServerStorage end
		end
	end
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
		for index,route in Map.Bridges do
   -- Land twelve studs inside each island; use measured ground instead of a guessed +2 offset.
   local along=Vector3.new(route.B.X-route.A.X,0,route.B.Z-route.A.Z).Unit
   local start,finish=route.A-along*12,route.B+along*12
   local a=Vector3.new(start.X,assert(Service.SurfaceAt(start.X,start.Z))+.05,start.Z)
   local b=Vector3.new(finish.X,assert(Service.SurfaceAt(finish.X,finish.Z))+.05,finish.Z)
   gradeBridge(a,b)
   local span=Instance.new("Model");span.Name="Bridge"..index;span:SetAttribute("Start",a);span:SetAttribute("Finish",b);span.Parent=connections
   bridge(span,a,b)
  end
		local spawn=Instance.new("SpawnLocation");spawn.Name="HubSpawn";spawn.Anchored=true
		spawn.Size,spawn.Position,spawn.Transparency=Vector3.new(8,1,8),Map.HubArrival-Vector3.new(0,3,0),1
		spawn.Neutral,spawn.Duration,spawn.Parent=true,0,world
		world:SetAttribute("Version",Map.Version);world:SetAttribute("Ready",true)
	end
 if workspace.WorldFoundation:GetAttribute("GroundCoverVersion")~="W4-cover-04" then
  Service.ApplyGroundCover()
  buildStoneTrails()
  meadowCover(Map.Zones[2]);meadowCover(Map.Zones[3])
  workspace.WorldFoundation:SetAttribute("GroundCoverVersion","W4-cover-04")
 end
	-- Client-authored masonry has simple server-owned boundaries at the same placement.
	local world=workspace.WorldFoundation
	local anchors=game.ReplicatedStorage:FindFirstChild("SceneGround") or Instance.new("Folder")
	anchors.Name="SceneGround";anchors.Parent=game.ReplicatedStorage
	local function anchor(x,z)
		local name=string.format("%.2f:%.2f",x,z)
		local value=anchors:FindFirstChild(name) or Instance.new("Vector3Value")
		value.Name=name;value.Value=Vector3.new(x,assert(Service.SurfaceAt(x,z)),z);value.Parent=anchors
	end
	for _,group in Map.TreeGroups do for _,entry in group do anchor(entry[1],entry[2]) end end
	for _,point in {Vector2.new(356,-224),Vector2.new(329,-182),Vector2.new(199,-124),Vector2.new(259,161),Vector2.new(310,197),Vector2.new(282,194),Vector2.new(337,207),Vector2.new(334,150),Vector2.new(346,-204),Vector2.new(333,-216),Vector2.new(316,-214),Vector2.new(297,-229),Vector2.new(274,-224),Vector2.new(253,-240),Vector2.new(224,-231),Vector2.new(197,-247),Vector2.new(172,-235)} do anchor(point.X,point.Y) end
	for _,x in {-3.8,3.8} do for _,z in {-2.5,2.5} do anchor(356+x,-224+z) end end
	for _,side in {-1,1} do anchor(310+side*11.7,197) end
	if not world:FindFirstChild("GroveRuinBoundaries") then
		local bounds=Instance.new("Folder");bounds.Name="GroveRuinBoundaries";bounds.Parent=world
		local y=Service.SurfaceAt(310,197)
		for _,side in {-1,1} do
			local foot=Service.SurfaceAt(310+side*11.7,197);local height=math.max(1,y+5-foot)
			local pier=part(bounds,"GroveRuinPier",Vector3.new(2.7,height,2.7),Vector3.new(310+side*11.7,foot+height/2,197),Color3.new(1,1,1))
			pier.Transparency,pier.CanQuery=1,false
		end
	end
	if not world:FindFirstChild("W4TreeBoundaries") then
		local trunks=Instance.new("Folder");trunks.Name="W4TreeBoundaries";trunks.Parent=world
		for _,group in Map.TreeGroups do for _,entry in group do
			local y=Service.SurfaceAt(entry[1],entry[2]);if y then
				local height=10*entry[3]
				local trunk=part(trunks,"TreeTrunkCollision",Vector3.new(1.6,height,1.6),Vector3.new(entry[1],y+height/2,entry[2]),Color3.new(1,1,1))
				trunk.Transparency,trunk.CanQuery=1,false
			end
		end end
		local y=Service.SurfaceAt(356,-224)
		for _,x in {-3.8,3.8} do for _,z in {-2.5,2.5} do
			local foot=Service.SurfaceAt(356+x,-224+z);local height=math.max(1,y+6.8-foot)
			local post=part(trunks,"SpringPergolaCollision",Vector3.new(.5,height,.5),Vector3.new(356+x,foot+height/2,-224+z),Color3.new(1,1,1))
			post.Transparency,post.CanQuery=1,false
		end end
	end
	if not world:FindFirstChild("CourtyardBoundaries") then
		local bounds=Instance.new("Folder");bounds.Name="CourtyardBoundaries";bounds.Parent=world
		for _,side in {-1,1} do
			local wall=part(bounds,"PavilionSideWall",Vector3.new(6.7,7.6,1.2),Map.Hub+Vector3.new(side*9.9,3.8,32),Color3.new(1,1,1))
			wall.Transparency=1
		end
	end
	atmosphere()
	if not game:GetService("RunService"):IsRunning() then return end
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
