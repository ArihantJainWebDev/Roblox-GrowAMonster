local Sample = {}
function Sample.Start()
 if workspace:FindFirstChild("SkyGardenSample") then return end
 local m=Instance.new("Model");m.Name="SkyGardenSample"
 local origin=Vector3.new(0,64,140)
 local cream=Color3.fromRGB(231,213,172)
 local wood=Color3.fromRGB(151,103,57)
 local green=Color3.fromRGB(100,174,104)
 local function p(name,size,pos,color,shape,material)
  local a=Instance.new("Part");a.Name=name;a.Size=size;a.Position=origin+pos;a.Color=color;a.Anchored=true
  a.Shape=shape or Enum.PartType.Block;a.Material=material or Enum.Material.SmoothPlastic
  a.TopSurface=Enum.SurfaceType.Smooth;a.BottomSurface=Enum.SurfaceType.Smooth;a.Parent=m;return a
 end
 local function beam(name,a,b,width,color)
  local q=p(name,Vector3.new(width,width,(b-a).Magnitude),(a+b)/2,color)
  q.CFrame=CFrame.lookAt(origin+(a+b)/2,origin+b);return q
 end
 p("Meadow",Vector3.new(58,4,48),Vector3.new(0,0,0),green,nil,Enum.Material.Grass)
 for i=1,3 do
  local rock=p("FloatingRock",Vector3.new(54-i*9,7,44-i*7),Vector3.new(i%2*2,-3-i*5,0),Color3.fromRGB(119-i*7,116-i*7,105-i*6))
  rock.Orientation=Vector3.new(0,i*12,0)
 end
 -- A walkable preview connection to the shared gathering area.
 p("PreviewBridge",Vector3.new(8,1,80),Vector3.new(0,1.5,-64),wood,nil,Enum.Material.WoodPlanks)
 for z=-100,-28,8 do
  for _,x in {-4.5,4.5} do p("BridgePost",Vector3.new(.5,3,.5),Vector3.new(x,3,z),wood) end
 end
 for _,x in {-4.5,4.5} do beam("Handrail",Vector3.new(x,4,-104),Vector3.new(x,4,-24),.35,wood) end
 for z=-21,9,5 do
  for _,x in {-2.7,2.7} do
   local q=p("Paving",Vector3.new(5,.35,4.6),Vector3.new(x,2.2,z),cream);q.Orientation=Vector3.new(0,(z%3-1)*3,0)
  end
 end
 p("HatcheryFoundation",Vector3.new(19,1,13),Vector3.new(0,2.5,13),cream)
 for _,x in {-8,8} do
  for _,z in {8,18} do p("TimberColumn",Vector3.new(.9,9,.9),Vector3.new(x,7,z),wood,nil,Enum.Material.Wood) end
  beam("RoofRafter",Vector3.new(x,11,6),Vector3.new(x,14,13),.8,wood)
  beam("RoofRafter",Vector3.new(x,14,13),Vector3.new(x,11,20),.8,wood)
 end
 for x=-9,9,1.5 do
  beam("Canopy",Vector3.new(x,11.4,5.5),Vector3.new(x,14.4,13),1.4,Color3.fromRGB(104,139,82))
  beam("Canopy",Vector3.new(x,14.4,13),Vector3.new(x,11.4,20.5),1.4,Color3.fromRGB(104,139,82))
 end
 beam("Ridge",Vector3.new(-10,14.5,13),Vector3.new(10,14.5,13),.7,wood)
 for i=1,12 do
  local angle=i*math.pi/6
  local q=p("NestStone",Vector3.new(2.1,1.1,1.3),Vector3.new(math.cos(angle)*3.5,3.5,13+math.sin(angle)*3.5),cream)
  q.Orientation=Vector3.new(0,-math.deg(angle),0)
 end
 p("Nest",Vector3.new(5.5,.5,5.5),Vector3.new(0,3.2,13),Color3.fromRGB(182,151,85),Enum.PartType.Ball)
 p("DisplayEgg",Vector3.new(3.1,4.1,3.1),Vector3.new(0,5.3,13),Color3.fromRGB(244,235,196),Enum.PartType.Ball)
 for i=1,7 do
  local a=i*2.4
  p("EggLeaf",Vector3.new(.5,.85,.18),Vector3.new(math.sin(a)*1.4,4.3+(i%3)*.65,13+math.cos(a)*1.4),green,Enum.PartType.Ball)
 end
 for _,x in {-6.5,6.5} do
  p("Lantern",Vector3.new(.8,1.3,.8),Vector3.new(x,9,9),Color3.fromRGB(255,210,114),nil,Enum.Material.Neon)
 end
 -- Raised demonstration crop bed.
 p("Soil",Vector3.new(11,.6,9),Vector3.new(15,2.5,-1),Color3.fromRGB(91,63,42))
 for _,x in {9,21} do p("BedBorder",Vector3.new(.7,1.2,10),Vector3.new(x,2.8,-1),wood) end
 for _,z in {-6,4} do p("BedBorder",Vector3.new(12,1.2,.7),Vector3.new(15,2.8,z),wood) end
 for x=11,19,4 do for z=-4,2,3 do
  for i=1,3 do
   local leaf=p("CropLeaf",Vector3.new(.55,2,.6),Vector3.new(x+(i-2)*.4,3.6,z),green,Enum.PartType.Ball)
   leaf.Orientation=Vector3.new(0,0,(i-2)*30)
  end
  p("Fruit",Vector3.new(1,1,1),Vector3.new(x,3.4,z-.5),Color3.fromRGB(233,108,74),Enum.PartType.Ball)
 end end
 -- Flowering tree and a simple original creature maquette.
 beam("Trunk",Vector3.new(-18,2,8),Vector3.new(-17,12,8),2.5,wood)
 for i=1,7 do
  local a=i*2.4;p("BlossomCrown",Vector3.new(7,5,7),Vector3.new(-17+math.sin(a)*4,12+i%3,8+math.cos(a)*4),Color3.fromRGB(237,153+i*5,170+i*4),Enum.PartType.Ball)
 end
 local c=Vector3.new(-7,4,-4)
 local mint=Color3.fromRGB(119,198,147)
 p("BabyBody",Vector3.new(2.6,3,2.2),c,mint,Enum.PartType.Ball)
 p("BabyHead",Vector3.new(3.2,2.6,2.7),c+Vector3.new(0,2,0),mint,Enum.PartType.Ball)
 p("CreamBelly",Vector3.new(1.7,2,.3),c+Vector3.new(0,-.1,-1),Color3.fromRGB(245,229,175),Enum.PartType.Ball)
 p("Muzzle",Vector3.new(1.6,.9,.8),c+Vector3.new(0,1.4,-1.2),Color3.fromRGB(245,229,175),Enum.PartType.Ball)
 for _,side in {-1,1} do
  p("Eye",Vector3.new(.6,.8,.3),c+Vector3.new(side*.8,2.2,-1.2),Color3.fromRGB(28,46,43),Enum.PartType.Ball)
  p("EyeGlint",Vector3.new(.18,.22,.1),c+Vector3.new(side*.8-.1,2.4,-1.36),Color3.new(1,1,1),Enum.PartType.Ball)
  p("Ear",Vector3.new(1.3,.7,.8),c+Vector3.new(side*1.65,2.2,0),mint,Enum.PartType.Ball)
  p("Foot",Vector3.new(1,.7,1.3),c+Vector3.new(side*.8,-1.4,-.2),mint,Enum.PartType.Ball)
  p("Arm",Vector3.new(.7,1.5,.8),c+Vector3.new(side*1.3,0,0),mint,Enum.PartType.Ball)
 end
 for i=-1,1 do
  local leaf=p("HeadLeaf",Vector3.new(.6,1.5,.5),c+Vector3.new(i*.45,3.4,0),Color3.fromRGB(74,149,79),Enum.PartType.Ball)
  leaf.Orientation=Vector3.new(0,0,i*-25)
 end
 local random=Random.new(41)
 for i=1,45 do
  local x,z=random:NextNumber(-26,26),random:NextNumber(-20,20)
  if math.abs(x)>7 and not(x>8 and z>-7 and z<5) then
   p("GroundLeaf",Vector3.new(.6,1,.6),Vector3.new(x,2.5,z),Color3.fromRGB(80,149,87),Enum.PartType.Ball)
   if i%3==0 then p("Flower",Vector3.new(.9,.35,.9),Vector3.new(x,3,z),Color3.fromRGB(255,207,136),Enum.PartType.Ball) end
  end
 end
 m.Parent=workspace
 return m
end
return Sample
