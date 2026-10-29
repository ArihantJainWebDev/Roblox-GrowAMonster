-- Project-authored masonry, botanical ornament and layered courtyard planting.
local Details={}
function Details.Build(Art,root,options)
 local cream=Color3.fromRGB(199,190,164)
 local trim=Color3.fromRGB(155,150,126)
 local groups={}
 local triangles={{1,3,2},{2,3,4},{5,6,7},{6,8,7},{1,2,5},{2,6,5},{3,7,4},{4,7,8},{1,5,3},{3,5,7},{2,4,6},{4,8,6}}
 local function box(name,center,size,color,material,cf)
  local key=name..tostring(color)
  local g=groups[key] or {Name=name,V={},F={},Color=color,Material=material or Enum.Material.Limestone};groups[key]=g
  local first=#g.V;cf=cf or CFrame.new(center)
  for _,y in {-1,1} do for _,x in {-1,1} do for _,z in {-1,1} do
   table.insert(g.V,cf:PointToWorldSpace(Vector3.new(x*size.X/2,y*size.Y/2,z*size.Z/2)))
  end end end
  for _,t in triangles do table.insert(g.F,{first+t[1],first+t[2],first+t[3]}) end
 end
 -- Broad, jointed outer plaza; leave the circular fountain mosaic and planted beds exposed.
 local rng=Random.new(4301)
 for row=0,16 do for col=0,16 do
  local x,z=-32+col*4,-32+row*4
  local planted=math.abs(x)>16 and z>-3 and z<21
  local pavilion=math.abs(x)<14 and z>20
  local radius=Vector2.new(x,z).Magnitude
  if radius>23 and not planted and not pavilion then
   local shade=rng:NextInteger(0,3)
   box("GardenPlazaPavers",Vector3.new(x,.12,z),Vector3.new(3.88,.24,3.88),cream:Lerp(trim,shade*.065))
  end
 end end
 -- Inner apron closes the bare gap around the basin without hiding its carved foot.
 local v,f={},{}
 for ring=0,1 do
  local r=9.6+ring*1.45
  for i=0,95 do local a=i*math.pi/48;table.insert(v,Vector3.new(math.cos(a)*r,.18,math.sin(a)*r)) end
 end
 for i=1,96 do local j=i%96+1;table.insert(f,{i,j,i+96});table.insert(f,{j,j+96,i+96}) end
 Art.MakeMesh(root,"BasinStoneApron",v,f,trim,Enum.Material.Limestone)
 local rim,rf={},{}
 for _,r in {19.95,23.2} do for i=0,95 do local a=i*math.pi/48;table.insert(rim,Vector3.new(math.cos(a)*r,.11,math.sin(a)*r)) end end
 for i=1,96 do local j=i%96+1;table.insert(rf,{i,j,i+96});table.insert(rf,{j,j+96,i+96}) end
 Art.MakeMesh(root,"OuterMosaicBorder",rim,rf,trim,Enum.Material.Limestone)
 if options and options.Integrated then
  local ray=RaycastParams.new();ray.FilterType=Enum.RaycastFilterType.Include;ray.FilterDescendantsInstances={workspace.Terrain}
  local origin=options.Origin
  for _,ends in {{Vector3.new(-32,0,-24),Vector3.new(-46,0,-25)},{Vector3.new(32,0,-24),Vector3.new(45,0,-30)},{Vector3.new(32,0,28),Vector3.new(45,0,35)}} do
   local a,b=ends[1],ends[2];local direction=(b-a).Unit;local right=Vector3.new(-direction.Z,0,direction.X)
   local steps=math.ceil((b-a).Magnitude/3)
   for j=0,steps do for _,side in {-1,1} do
    local p=a:Lerp(b,j/steps)+right*side*1.6
    local hit=workspace:Raycast(origin+p+Vector3.new(0,40,0),Vector3.new(0,-80,0),ray)
    if hit then
     p=Vector3.new(p.X,hit.Position.Y-origin.Y+.12,p.Z)
     box("CourtTrailConnections",p,Vector3.new(3.05,.24,(b-a).Magnitude/steps-.08),cream,Enum.Material.Limestone,CFrame.lookAt(p,p+direction))
    end
   end end
  end
 end
 -- Low perimeter edging leaves the cardinal entrances open.
 for _,side in {-1,1} do
  for z=-31,31,4 do
   if z>-21 and z<21 then
    box("GardenBoundaryCoping",Vector3.new(side*34,.45,z),Vector3.new(.7,.9,3.98),trim)
   end
  end
  for x=-30,30,4 do
   if math.abs(x)>8 then box("GardenBoundaryCoping",Vector3.new(x,.35,side*34),Vector3.new(3.98,.7,.7),trim) end
  end
 end
 -- A masonry garden pavilion: detailed piers, an open central arch, and recessed side panels.
 for _,side in {-1,1} do
  local x=side*9.9
  for course=0,5 do
   box("PavilionAshlar",Vector3.new(x,.75+course*1.13,32),Vector3.new(6.7,1.07,1.2),cream:Lerp(trim,(course%3)*.045))
  end
  for _,edge in {-1,1} do
   local px=x+edge*3.35
   box("PavilionPilaster",Vector3.new(px,3.9,31.1),Vector3.new(.65,7.2,.6),trim)
   box("PavilionCapital",Vector3.new(px,7.6,31),Vector3.new(1.2,.35,.9),cream)
  end
  box("PavilionRecess",Vector3.new(x,4.3,31.33),Vector3.new(4.8,3.2,.12),Color3.fromRGB(80,111,103),Enum.Material.Slate)
  for i=-1,1 do box("WindowMullion",Vector3.new(x+i*1.3,4.3,31.15),Vector3.new(.13,3.35,.16),trim) end
  box("WindowTransom",Vector3.new(x,4.3,31.1),Vector3.new(4.9,.15,.2),trim)
  box("WindowSill",Vector3.new(x,2.5,30.9),Vector3.new(5.4,.4,.9),cream)
 end
 -- Individual voussoirs follow the existing arch; narrow joints make its construction readable.
 for i=0,12 do
  local a=(i+.5)*math.pi/13
  local center=Vector3.new(math.cos(a)*6.2,2+math.sin(a)*6.2,31.38)
  box("ArchVoussoirs",center,Vector3.new(1.43,.65,.36),i==6 and trim or cream,Enum.Material.Limestone,CFrame.new(center)*CFrame.Angles(0,0,a+math.pi/2))
 end
 for _,x in {-6.15,6.15} do
  box("ArchSpringer",Vector3.new(x,1.2,31.5),Vector3.new(.85,2.4,1.1),cream)
 end
 -- Botanical roof crest and small copper ridge ornaments share the fountain's leaf motif.
 local ornament={}
 for _,x in {-13,0,13} do
  for i=-1,1 do
   local base=Vector3.new(x,14,27)
   table.insert(ornament,{base,base+Vector3.new(i*.85,1.8-math.abs(i)*.35,0),.28})
  end
 end
 Art.MakeLeaves(root,"CopperRoofBotanicalCrests",ornament,Color3.fromRGB(151,131,81))
 -- Distinct height layers: dark broad leaves, sage stems, peach and lavender flowers.
 local foliage,spikes,peach,lavender={},{},{},{}
 for _,side in {-1,1} do
  for k=1,52 do
   local x,z=side*rng:NextNumber(19,31),rng:NextNumber(-1,18)
   local base=Vector3.new(x,.65,z)
   local height=rng:NextNumber(1.2,2.6)
   for i=0,5 do
    local a=i*math.pi/3+k*.3
    table.insert(foliage,{base,base+Vector3.new(math.cos(a)*1.4,height*.65,math.sin(a)*1.4),.55})
   end
   if k%2==0 then
    local tip=base+Vector3.new(.2,height+.8,0)
    table.insert(spikes,{base,tip,.16})
    for j=0,3 do
     local p=tip-Vector3.new(0,j*.25,0)
     table.insert(lavender,{p,p+Vector3.new(.35,.18,.12),.22})
     table.insert(lavender,{p,p+Vector3.new(-.3,.17,-.1),.22})
    end
   else
    local p=base+Vector3.new(0,height,0)
    for i=0,5 do local a=i*math.pi/3;table.insert(peach,{p,p+Vector3.new(math.cos(a)*.6,.1,math.sin(a)*.6),.24}) end
   end
  end
 end
 Art.MakeLeaves(root,"GardenBroadleafUnderstory",foliage,Color3.fromRGB(53,98,77))
 Art.MakeLeaves(root,"GardenSageStems",spikes,Color3.fromRGB(100,139,105))
 Art.MakeLeaves(root,"GardenPeachFlowers",peach,Color3.fromRGB(231,174,136))
 Art.MakeLeaves(root,"GardenLavenderSpires",lavender,Color3.fromRGB(151,135,192))
 -- Furnishing details: lantern frames and bench ironwork, kept out of the walking aisle.
 for _,x in {-12,12} do for _,z in {-20,18} do
  for _,dx in {-.43,.43} do for _,dz in {-.43,.43} do
   box("LanternIronFrames",Vector3.new(x+dx,5.7,z+dz),Vector3.new(.09,1.25,.09),Color3.fromRGB(72,79,72),Enum.Material.Metal)
  end end
 end end
 for _,x in {-13.5,13.5} do for _,z in {-12,11} do
  for _,endZ in {-2.3,2.3} do
   box("BenchArmrests",Vector3.new(x,2.55,z+endZ),Vector3.new(1.8,.16,.18),Color3.fromRGB(72,79,72),Enum.Material.Metal)
  end
 end end
 for _,g in groups do Art.MakeMesh(root,g.Name,g.V,g.F,g.Color,g.Material);task.wait() end
 root:SetAttribute("CourtyardBuild","W3-garden-01")
end
return Details
