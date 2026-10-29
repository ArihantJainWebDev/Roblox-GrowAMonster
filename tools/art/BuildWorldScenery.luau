-- Original environment kit. Presentation only; no inventory, rewards or ownership writes.
local Scenery={}
local stone=Color3.fromRGB(133,137,122)
local timber=Color3.fromRGB(109,80,52)
local fruitTemplates={}
local function part(parent,name,size,pos,color,material)
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.Position=pos;p.Color=color;p.Material=material or Enum.Material.Wood
 p.Anchored,p.CanCollide,p.CanTouch,p.CanQuery=true,false,false,false;p.Parent=parent;return p
end
local function move(model,offset) model:PivotTo(model:GetPivot()+offset) end
local function ground(Map,x,z,zone)
 local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Include;params.FilterDescendantsInstances={workspace.Terrain}
 local anchors=game.ReplicatedStorage:FindFirstChild("SceneGround")
 local fixed=anchors and anchors:FindFirstChild(string.format("%.2f:%.2f",x,z))
 if fixed then return fixed.Value end
 local hit=workspace:Raycast(Vector3.new(x,640,z),Vector3.new(0,-400,0),params)
 return Vector3.new(x,hit and hit.Position.Y or Map.ZoneHeight(zone,x,z)+2,z)
end
local function rock(Art,parent,name,center,size,seed,color)
 local rng=Random.new(seed);local v,f={},{};local n=9
 for layer=0,2 do for i=0,n-1 do
  local a=i*math.pi*2/n;local r=(layer==1 and 1 or layer==0 and .8 or .45)*rng:NextNumber(.85,1.15)
  table.insert(v,center+Vector3.new(math.cos(a)*size.X*r,(layer/2-.2)*size.Y+rng:NextNumber(-.12,.12),math.sin(a)*size.Z*r))
 end end
 for layer=0,1 do for i=1,n do local a=layer*n+i;local b=layer*n+i%n+1;table.insert(f,{a,b,a+n});table.insert(f,{b,b+n,a+n}) end end
 local top=#v+1;table.insert(v,center+Vector3.new(0,size.Y*.87,0))
 for i=1,n do table.insert(f,{top,2*n+i,2*n+i%n+1}) end
 return Art.MakeMesh(parent,name,v,f,color or stone,Enum.Material.Rock)
end
local function foliage(Art,parent,name,points,seed,color)
 local rng=Random.new(seed);local leaves={}
 for _,p in points do for i=0,8 do
  local a=i*2.4+rng:NextNumber(-.2,.2);local length=rng:NextNumber(1.4,3.1)
  table.insert(leaves,{p,p+Vector3.new(math.cos(a)*length,rng:NextNumber(.7,1.9),math.sin(a)*length),rng:NextNumber(.3,.65)})
 end end
 if #leaves>0 then Art.MakeLeaves(parent,name,leaves,color) end
end
local function sign(parent,text,pos,yaw)
 local frame=CFrame.new(pos)*CFrame.Angles(0,yaw or 0,0)
 for _,side in {-1,1} do
  part(parent,"TrailSignPost",Vector3.new(.28,2.65,.28),frame:PointToWorldSpace(Vector3.new(side*2.35,1.325,0)),timber)
 end
 local board=part(parent,"TrailSign",Vector3.new(6,1.8,.3),frame:PointToWorldSpace(Vector3.new(0,3.55,0)),Color3.fromRGB(67,90,77))
 board.CFrame=frame*CFrame.new(0,3.55,0)
 for _,face in {Enum.NormalId.Front,Enum.NormalId.Back} do
  local gui=Instance.new("SurfaceGui");gui.Name="Sign"..face.Name;gui.Face=face;gui.CanvasSize=Vector2.new(480,144);gui.LightInfluence=.35;gui.Parent=board
  local label=Instance.new("TextLabel");label.Position=UDim2.fromOffset(12,6);label.Size=UDim2.new(1,-24,1,-12);label.BackgroundTransparency=1;label.Text=text
  label.Font=Enum.Font.GothamMedium;label.TextScaled=true;label.TextColor3=Color3.fromRGB(239,229,197);label.TextWrapped=true;label.Parent=gui
  local limit=Instance.new("UITextSizeConstraint");limit.MaxTextSize=30;limit.MinTextSize=15;limit.Parent=label
 end
 return board
end
function Scenery.Fruit(Art,parent,kind)
 if fruitTemplates[kind] then local copy=fruitTemplates[kind]:Clone();copy.Parent=parent;return copy end
 local model=Instance.new("Model");model.Name="AuthoredFruit";model.WorldPivot=CFrame.new();model.Parent=parent
 local color=kind=="Berry" and Color3.fromRGB(126,84,168) or kind=="GoldenApple" and Color3.fromRGB(218,174,66) or Color3.fromRGB(191,72,54)
 if kind=="Berry" then
  for i=0,4 do local a=i*2.4;Art.MakeSurface(model,"BerryDrupe"..i,{{0,-.3},{.22,-.26},{.3,0},{.22,.25},{0,.3}},12,color,Vector3.new(math.cos(a)*.24,(i%2)*.28,math.sin(a)*.24),5,.08) end
 else
  Art.MakeSurface(model,"LobedApple",{{0,-.45},{.3,-.4},{.53,-.13},{.55,.15},{.4,.4},{.12,.42},{0,.32}},20,color,nil,5,.09)
 end
 part(model,"FruitStalk",Vector3.new(.08,.32,.08),Vector3.new(.04,.5,0),timber)
 Art.MakeLeaves(model,"FruitLeaf",{{Vector3.new(.04,.48,0),Vector3.new(.65,.68,.08),.18}},Color3.fromRGB(75,124,68))
 fruitTemplates[kind]=model:Clone()
 return model
end
function Scenery.Build(Art,parent,treeTemplate,courtyard,Map)
 local root=Instance.new("Model");root.Name="W4Landscape";root.Parent=parent
 -- Curated positions keep routes, bridge mouths, water and reward anchors open.
 local orchard,grove=Map.TreeGroups[1],Map.TreeGroups[2]
 local shrubs,ferns={},{ }
 local index=0
 for region,points in {orchard,grove} do for _,entry in points do
  index+=1;local zone=Map.Zones[region+1];local p=ground(Map,entry[1],entry[2],zone)
  local tree=treeTemplate:Clone();tree.Name=region==1 and "OrchardBroadleaf" or "GroveBroadleaf";tree:ScaleTo(entry[3])
  local cf,size=tree:GetBoundingBox();move(tree,p+Vector3.new(0,size.Y/2-.8,0)-cf.Position)
  tree:PivotTo(tree:GetPivot()*CFrame.Angles(0,index*1.7,0));tree.Parent=root
  if region==2 then for _,leaf in tree:GetChildren() do if leaf.Name:match("LeafSprays") then leaf.Color=leaf.Color:Lerp(Color3.fromRGB(91,143,133),.5) end end end
  if region==1 then
   for _,i in {1,3,6,8} do
    local socket=tree.BranchingTrunk:FindFirstChild("FruitSocket"..i)
    if socket then
     local apple=Scenery.Fruit(Art,tree,"Apple");apple:ScaleTo(.85)
     local target=socket.WorldPosition-Vector3.new(.04,.66,0)*.85
     apple:PivotTo(CFrame.new(target));apple:SetAttribute("BranchSocket",socket.Name)
    end
   end
  end
  for j=1,3 do local a=j*2.4+index;table.insert(region==1 and shrubs or ferns,p+Vector3.new(math.cos(a)*5,-.2,math.sin(a)*5)) end
  if index%3==0 then rock(Art,root,"RootShoulderStone",p+Vector3.new(5,-.5,3),Vector3.new(2,2.4,1.5),index) end
  task.wait()
 end end
 foliage(Art,root,"OrchardGroundPlants",shrubs,112,Color3.fromRGB(74,113,65))
 foliage(Art,root,"GroveFerns",ferns,215,Color3.fromRGB(52,119,105))
 -- Spring bank stones follow the actual carved channel; leave the water uncovered.
 for i,p in {Vector2.new(346,-204),Vector2.new(333,-216),Vector2.new(316,-214),Vector2.new(297,-229),Vector2.new(274,-224),Vector2.new(253,-240),Vector2.new(224,-231),Vector2.new(197,-247),Vector2.new(172,-235)} do
  local at=ground(Map,p.X,p.Y,Map.Zones[2]);rock(Art,root,"SpringBankBoulder",at-Vector3.new(0,.7,0),Vector3.new(2.5+i%2,2.4,2.2),190+i)
 end
 -- Creek water is actual Terrain Water; no independently elevated ribbon or flow beams.
 -- A spring garden and a resting place on the upper orchard terrace.
 local rest=ground(Map,356,-224,Map.Zones[2])
 for _,x in {-2,2} do part(root,"RestBenchFoot",Vector3.new(.6,1.5,.8),rest+Vector3.new(x,.75,0),stone,Enum.Material.Rock) end
 part(root,"RestBenchSeat",Vector3.new(6,.35,1.6),rest+Vector3.new(0,1.7,0),timber)
 part(root,"RestBenchBack",Vector3.new(6,1.5,.3),rest+Vector3.new(0,2.3,.75),timber)
 for _,x in {-3.8,3.8} do for _,z in {-2.5,2.5} do
  local foot=ground(Map,rest.X+x,rest.Z+z,Map.Zones[2]);local height=math.max(1,rest.Y+6.8-foot.Y)
  part(root,"SpringPergolaPost",Vector3.new(.5,height,.5),foot+Vector3.new(0,height/2,0),timber)
 end end
 for _,z in {-2.5,2.5} do part(root,"SpringPergolaBeam",Vector3.new(9,.5,.45),rest+Vector3.new(0,6.6,z),timber) end
 local rv,rf={},{}
 for row,z in {-3.5,0,3.5} do for j=0,12 do
  local x=-5+j*10/12
  table.insert(rv,rest+Vector3.new(x,8.3-math.abs(z)*.45+.35*(x/5)^4,z))
  if row>1 and j>0 then local a=(row-2)*13+j;table.insert(rf,{a,a+1,a+13});table.insert(rf,{a+1,a+14,a+13}) end
 end end
 Art.MakeMesh(root,"SpringGardenCanopy",rv,rf,Color3.fromRGB(76,112,97),Enum.Material.Slate)
 sign(root,"SPRING GARDEN\nOrchard trail",ground(Map,329,-182,Map.Zones[2]),-.8)
 sign(root,"ORCHARD\nSpring ↑  •  Grove →",ground(Map,199,-124,Map.Zones[2]),-.6)
 sign(root,"ELEMENT GROVE\nBloom ahead",ground(Map,259,161,Map.Zones[3]),-1)
 -- The Grove's ancestral arch is a destination silhouette, built from jointed voussoirs.
 local ruin=ground(Map,310,197,Map.Zones[3])
 local archV,archF={},{}
 for i=0,17 do
  local first=#archV
  for _,angle in {i*math.pi/18+.006,(i+1)*math.pi/18-.006} do
   for _,z in {-1,1} do for _,r in {11,12.4} do
    table.insert(archV,ruin+Vector3.new(math.cos(angle)*r,5+math.sin(angle)*r,z))
   end end
  end
  for _,face in {{1,2,3},{2,4,3},{5,7,6},{6,7,8},{1,5,2},{2,5,6},{3,4,7},{4,8,7},{2,6,4},{4,6,8},{1,3,5},{3,7,5}} do
   table.insert(archF,{first+face[1],first+face[2],first+face[3]})
  end
 end
 Art.MakeMesh(root,"AncestralGroveArch",archV,archF,Color3.fromRGB(157,165,145),Enum.Material.Limestone)
 for _,side in {-1,1} do
  local foot=ground(Map,ruin.X+side*11.7,ruin.Z,Map.Zones[3]);local height=math.max(1,ruin.Y+5-foot.Y)
  part(root,"GroveRuinPier",Vector3.new(2.7,height,2.7),foot+Vector3.new(0,height/2,0),stone,Enum.Material.Limestone)
  part(root,"GroveRuinFoot",Vector3.new(4,.9,4),foot+Vector3.new(0,.45,0),stone,Enum.Material.Rock)
  foliage(Art,root,"RuinRootFerns"..side,{foot+Vector3.new(side*1.3,.3,-2)},415+side,Color3.fromRGB(68,123,95))
 end
 local crest={}
 for i=-2,2 do local p=ruin+Vector3.new(0,17.3,0);table.insert(crest,{p,p+Vector3.new(i*.7,2.8-math.abs(i)*.5,.15),.4}) end
 Art.MakeLeaves(root,"GroveArchBotanicalCrest",crest,Color3.fromRGB(170,176,129))
 -- Three distinct botanical/mineral groups around the bloom; no new evolution mechanics.
 for i,spec in {{282,194,Color3.fromRGB(206,136,83)},{337,207,Color3.fromRGB(146,166,210)},{334,150,Color3.fromRGB(92,157,116)}} do
  local base=ground(Map,spec[1],spec[2],Map.Zones[3])
  for j=0,3 do
   local p=base+Vector3.new(math.cos(j*2.4)*2.5,-.3,math.sin(j*2.4)*2.5)
   local vertices={p+Vector3.new(0,4+j*.8,0),p-Vector3.new(0,.6,0)}
   for k=0,5 do table.insert(vertices,p+Vector3.new(math.cos(k*math.pi/3),1,math.sin(k*math.pi/3))) end
   local faces={};for k=0,5 do local a,b=3+k,3+(k+1)%6;table.insert(faces,{1,a,b});table.insert(faces,{2,b,a}) end
   Art.MakeMesh(root,"GroveMineralCluster"..i,vertices,faces,spec[3],Enum.Material.Slate)
  end
  foliage(Art,root,"GroveClusterLeaves"..i,{base+Vector3.new(-4,0,0),base+Vector3.new(3,0,4)},300+i,spec[3]:Lerp(Color3.fromRGB(51,105,80),.6))
 end
 root:SetAttribute("Build","W4-landscape-02")
 return root
end
function Scenery.Home(Art,island)
 local existing=island:FindFirstChild("HomeGarden");if existing then return existing end
 local root=Instance.new("Model");root.Name="HomeGarden";root.Parent=island
 local center=island.Grass.Position
 local mulchV,mulchF={},{};local soilRng=Random.new(771)
 for i=1,4 do local plot=island:FindFirstChild("Plot"..i);if plot then
  local p=plot.Position
  for _,side in {-1,1} do
   part(root,"RaisedBedEdge",Vector3.new(9.8,.8,.45),p+Vector3.new(0,.15,side*4.7),timber)
   part(root,"RaisedBedEdge",Vector3.new(.45,.8,9.8),p+Vector3.new(side*4.7,.15,0),timber)
  end
  for furrow=-3,3,1.5 do part(root,"SoilFurrow",Vector3.new(.14,.08,8),p+Vector3.new(furrow,.32,0),Color3.fromRGB(69,48,33),Enum.Material.Ground) end
  for j=1,45 do
   local at=p+Vector3.new(soilRng:NextNumber(-4,4),.315,soilRng:NextNumber(-4,4))
   local a=soilRng:NextNumber(0,math.pi*2);local along=Vector3.new(math.cos(a),0,math.sin(a))*soilRng:NextNumber(.12,.3)
   local across=Vector3.new(-along.Z,0,along.X)*.4;local n=#mulchV
   for _,v in {at-along,at+across+Vector3.new(0,.04,0),at+along,at-across} do table.insert(mulchV,v) end
   table.insert(mulchF,{n+1,n+2,n+3});table.insert(mulchF,{n+1,n+3,n+4})
  end
 end end
 Art.MakeMesh(root,"BedMulchAndSoilClods",mulchV,mulchF,Color3.fromRGB(94,65,40),Enum.Material.Ground)
 local own=island:GetAttribute("OwnerUserId");local player=game.Players:GetPlayerByUserId(own)
 sign(root,(player and player.DisplayName or "Player").."'s garden",center+Vector3.new(16,2,17),-.5)
 local old=island.HomeSpawn:FindFirstChild("HomeLabel");if old then old.Enabled=false end
 -- Decorative propagation bench surrounds the server-owned SeedCounter interaction.
 local at=center+Vector3.new(-15,2,17)
 part(root,"SeedBenchTop",Vector3.new(7,.4,3),at+Vector3.new(0,2.4,0),timber)
 for _,x in {-2.7,2.7} do part(root,"SeedBenchLeg",Vector3.new(.55,2.5,2.5),at+Vector3.new(x,1.1,0),timber) end
 for j=-1,1 do
  Art.MakeSurface(root,"TerracottaSeedPot",{{0,0},{.5,0},{.65,1},{.75,1.1},{.75,1.3},{.6,1.3},{.5,.9}},16,Color3.fromRGB(163,108,75),at+Vector3.new(j*1.8,2.6,0))
 end
 foliage(Art,root,"SeedBenchSprouts",{at+Vector3.new(-1.8,3.5,0),at+Vector3.new(0,3.5,0),at+Vector3.new(1.8,3.5,0)},321,Color3.fromRGB(89,137,72))
 sign(root,"SEEDS & SAPLINGS",at+Vector3.new(0,0,2),math.pi)
 root:SetAttribute("Build","W4-home-01")
 return root
end
function Scenery.WildPlant(Art,node,base,berry)
 local leaves={}
 for j=0,9 do local a=j*2.4
  table.insert(leaves,{base-Vector3.new(0,.04,0),base+Vector3.new(math.cos(a)*1.3,.65+(j%3)*.2,math.sin(a)*1.3),.35})
 end
 Art.MakeLeaves(node,"LocalPlant",leaves,Color3.fromRGB(64,112,73))
 if berry then
  local top=base+Vector3.new(.04,1.91,0)
  local stem=part(node,"BerryBearingStem",Vector3.new(.08,.08,(top-base).Magnitude),(top+base)/2,timber)
  stem.CFrame=CFrame.lookAt(stem.Position,top)
 end
end
function Scenery.Gateway(Art,gate)
 if gate:FindFirstChild("GardenGateway") then return end
 local root=Instance.new("Model");root.Name="GardenGateway";root.Parent=gate
 local base=gate.Position-Vector3.new(0,3.5,0)
 local ray=RaycastParams.new();ray.FilterType=Enum.RaycastFilterType.Include;ray.FilterDescendantsInstances={workspace.Terrain}
 local vertices,faces={},{}
 for j=0,24 do local a=j*math.pi/24
  for _,z in {-.8,.8} do for _,r in {3.9,4.9} do table.insert(vertices,base+Vector3.new(math.cos(a)*r,4+math.sin(a)*r,z)) end end
  if j>0 then local o=(j-1)*4;for _,t in {{1,2,5},{2,6,5},{3,7,4},{4,7,8},{2,4,6},{4,8,6},{1,5,3},{3,5,7}} do table.insert(faces,{o+t[1],o+t[2],o+t[3]}) end end
 end
 Art.MakeMesh(root,"GatewayStoneArch",vertices,faces,Color3.fromRGB(181,176,151),Enum.Material.Limestone)
 for _,side in {-1,1} do
  local x=base.X+side*4.4
  local hit=workspace:Raycast(Vector3.new(x,base.Y+20,base.Z),Vector3.new(0,-60,0),ray)
  local y=gate:GetAttribute(side<0 and "LeftFootY" or "RightFootY") or (hit and hit.Position.Y or base.Y)
  local height=math.max(.7,base.Y+4-y)
  part(root,"GatewayButtress",Vector3.new(1.1,height,1.6),Vector3.new(x,y+height/2,base.Z),stone,Enum.Material.Rock)
  part(root,"GatewayFoot",Vector3.new(2,.7,2.4),Vector3.new(x,y+.25,base.Z),stone,Enum.Material.Rock)
 end
 local leaves={};for i=-1,1 do local p=base+Vector3.new(0,8.8,0);table.insert(leaves,{p,p+Vector3.new(i*.8,1.4-math.abs(i)*.4,0),.28}) end
 Art.MakeLeaves(root,"GatewayBotanicalCrest",leaves,Color3.fromRGB(132,159,117))
 gate.LocalTransparencyModifier=1
 for _,p in gate.Parent:GetChildren() do
  if p:IsA("BasePart") and (p.Name=="GatewayPillar" or p.Name=="GatewayLintel") and (p.Position-base).Magnitude<12 then p.LocalTransparencyModifier=1 end
 end
 local v={base+Vector3.new(-3.5,.1,0),base+Vector3.new(3.5,.1,0)}
 for j=0,24 do local a=j*math.pi/24;table.insert(v,base+Vector3.new(math.cos(a)*3.5,4+math.sin(a)*3.5,0)) end
 local center=#v+1;table.insert(v,base+Vector3.new(0,3,0));local f={}
 for j=1,center-1 do table.insert(f,{center,j,j%(center-1)+1}) end
 local membrane=Art.MakeMesh(root,"GatewayVeil",v,f,Color3.fromRGB(126,206,195),Enum.Material.Glass);membrane.Transparency=.4
end
function Scenery.Crop(Art,parent,id,stage)
 local root=Instance.new("Model");root.Name="CropTemplate";root.WorldPivot=CFrame.new();root.Parent=parent
 local rng=Random.new(441)
 local leaves={};local sockets={}
 if id=="Apple" then
  Art.MakeSurface(root,"RootedSaplingTrunk",{{0,-.08},{.65,-.08},{.43,.2},{.24,1.2},{.18,3.8},{.07,6.2},{0,6.6}},14,timber,nil,5,.15)
  for j=0,5 do
   local a=j*2.4;local start=Vector3.new(0,2+j*.42,0)
   local tip=Vector3.new(math.cos(a)*1.8,4.5+j*.26,math.sin(a)*1.8)
   local branch=part(root,"SaplingBranch",Vector3.new(.16,.16,(tip-start).Magnitude),(tip+start)/2,timber)
   branch.CFrame=CFrame.lookAt(branch.Position,tip)
   table.insert(sockets,tip)
   for k=0,23 do
    local angle=k*2.4;local base=tip+Vector3.new(rng:NextNumber(-.4,.4),rng:NextNumber(.1,.7),rng:NextNumber(-.4,.4))
    table.insert(leaves,{base,base+Vector3.new(math.cos(angle)*rng:NextNumber(1.2,2.1),rng:NextNumber(.2,1.1),math.sin(angle)*rng:NextNumber(1.2,2.1)),rng:NextNumber(.65,.85)})
   end
  end
  for j=0,5 do local a=j*math.pi/3;local tip=Vector3.new(math.cos(a)*1.2,-.05,math.sin(a)*1.2)
   local rootBranch=part(root,"ExposedRoot",Vector3.new(.16,.1,tip.Magnitude),tip/2,timber);rootBranch.CFrame=CFrame.lookAt(tip/2,tip)
  end
 else
  for _,base in {Vector3.new(-1.7,0,-1.3),Vector3.new(1.7,0,-.9),Vector3.new(0,0,1.7)} do
   for j=0,3 do local a=j*2.4;local tip=base+Vector3.new(math.cos(a)*.85,1.5+(j%2)*.45,math.sin(a)*.85)
    local stem=part(root,"RootedBerryStem",Vector3.new(.08,.08,(tip-base).Magnitude),(tip+base)/2,timber);stem.CFrame=CFrame.lookAt(stem.Position,tip)
    table.insert(sockets,tip)
    for k=0,14 do local angle=k*2.4;table.insert(leaves,{tip*.8+base*.2,tip+Vector3.new(math.cos(angle)*1.25,rng:NextNumber(.1,.7),math.sin(angle)*1.25),.6}) end
   end
  end
 end
 Art.MakeLeaves(root,"CropCanopy",leaves,id=="Apple" and Color3.fromRGB(96,141,70) or Color3.fromRGB(62,112,79))
 if stage==3 then for i,point in sockets do if i%2==0 then
  local fruit=Scenery.Fruit(Art,root,id);fruit:ScaleTo(.65);fruit:PivotTo(CFrame.new(point-Vector3.new(.04,.66,0)*.65))
 end end end
 root:ScaleTo(stage==1 and .26 or stage==2 and .6 or .9)
 return root
end
return Scenery
