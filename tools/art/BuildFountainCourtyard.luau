-- Edit-mode courtyard assembly; author-owned geometry, no game-state mutation.
local Courtyard={}
function Courtyard.Build(Art,options)
	options=options or {}
	assert(not game:GetService("RunService"):IsRunning() or options.RuntimePreview,"Runtime use is limited to the isolated review preview")
	local name=options.RuntimePreview and "FountainCourtyardVisuals" or "FountainCourtyard"
	local old=workspace:FindFirstChild(name);if old then old:Destroy() end
	local root=Instance.new("Model");root.Name=name;root.Parent=workspace
	root:SetAttribute("ReviewStage","Courtyard visual acceptance pending")
	local cream=Color3.fromRGB(204,195,168)
	local dark=Color3.fromRGB(119,111,91)
	local wood=Color3.fromRGB(112,79,47)
	local green=Color3.fromRGB(87,124,65)
	local function part(name,size,pos,color,material,collide)
		local p=Instance.new("Part");p.Name,p.Size,p.Position=name,size,pos
		p.Anchored,p.CanCollide,p.Color,p.Material=true,collide~=false,color,material or Enum.Material.SmoothPlastic
		p.TopSurface,p.BottomSurface=Enum.SurfaceType.Smooth,Enum.SurfaceType.Smooth;p.Parent=root
		return p
	end
	local function timber(name,a,b,width,depth)
		local p=part(name,Vector3.new(width,depth or width,(b-a).Magnitude),(a+b)/2,wood,Enum.Material.Wood)
		p.CFrame=CFrame.lookAt((a+b)/2,b);return p
	end
	local function wedgeStone(name,center,angle,r0,r1,height,arc,color)
		local v,f={},{}
		for _,y in {-.1,height} do
			for _,r in {r0,r1} do
				for _,a in {angle-arc/2,angle+arc/2} do table.insert(v,center+Vector3.new(math.cos(a)*r,y,math.sin(a)*r)) end
			end
		end
		for _,t in {{1,3,2},{2,3,4},{5,6,7},{6,8,7},{1,2,5},{2,6,5},{3,7,4},{4,7,8},{1,5,3},{3,5,7},{2,4,6},{4,8,6}} do table.insert(f,t) end
		local p=Art.MakeMesh(root,name,v,f,color);p.CanCollide=true;return p
	end
	-- A coherent raised garden terrace with a rock underside, not a review plane.
	local cliff=Art.MakeCliff(root,"CourtyardCliff",Vector3.zero,132)
	cliff.Size=Vector3.new(cliff.Size.X*3.25,cliff.Size.Y*1.15,cliff.Size.Z*3.6)
	cliff.Position=Vector3.new(0,-16.8,0)
	Art.MakeSurface(root,"MeadowEdge",{{0,-.3},{35,-.3},{36,-.1},{35.8,.18},{0,.18}},96,Color3.fromRGB(92,134,70),nil,5,.045)
	-- Collision is intentionally simple and independent from the decorative shell.
	local floor=part("WalkableFoundation",Vector3.new(62,.4,58),Vector3.new(0,-.15,0),cream,Enum.Material.Limestone)
	floor.Transparency=1
	for row=0,2 do
		for i=0,31 do wedgeStone("CourtyardPaver",Vector3.zero,(i+row*.5)*math.pi/16,11+row*3,13.92+row*3,.24,math.pi/16-.009,(i+row)%4==0 and dark or cream) end
	end
	for z=-33,-21,4 do
		for _,x in {-2.3,2.3} do part("EntryPaver",Vector3.new(4.4,.3,3.8),Vector3.new(x,.15,z),cream,Enum.Material.Limestone) end
	end
	local fountain=Art.MakeFountain(root)
	for _,v in fountain:GetChildren() do if v.Name:match("^WaterArc") then v:Destroy() end end
	local barrier=part("BasinCollision",Vector3.new(18,2,18),Vector3.new(0,1,0),cream)
	barrier.Transparency=1
	-- Original images: a soft droplet and scrolling water streaks.
	local imageService=game:GetService("AssetService")
	local function texture(kind)
		local n=64;local image=assert(imageService:CreateEditableImage({Size=Vector2.new(n,n)}))
		local pixels=buffer.create(n*n*4)
		for y=0,n-1 do for x=0,n-1 do
			local alpha
			if kind=="droplet" then
				local r=((x-31.5)/28)^2+((y-31.5)/28)^2;alpha=math.clamp((1-r)*2,0,1)
			else
				local edge=math.sin(math.pi*(y+.5)/n)^2
				alpha=edge*(.35+.65*(.5+.5*math.sin(x*.42+math.sin(y*.3))))
			end
			local at=(y*n+x)*4
			buffer.writeu8(pixels,at,220);buffer.writeu8(pixels,at+1,245);buffer.writeu8(pixels,at+2,250);buffer.writeu8(pixels,at+3,math.floor(alpha*255))
		end end
		image:WritePixelsBuffer(Vector2.zero,Vector2.new(n,n),pixels)
		Courtyard.Images=Courtyard.Images or {};table.insert(Courtyard.Images,image)
		return Content.fromObject(image)
	end
	local droplet,flow=texture("droplet"),texture("flow")
	local anchor=part("WaterEffectAnchor",Vector3.one,Vector3.zero,cream,nil,false);anchor.Transparency=1
	for i=0,7 do
		local a=i*math.pi/4;local dir=Vector3.new(math.cos(a),0,math.sin(a))
		local start=dir*3.3+Vector3.new(0,7.4,0)
		local finish=dir*7+Vector3.new(0,1.99,0)
		local a0=Instance.new("Attachment");a0.Name="StreamStart"..i;a0.Position=start;a0.Axis=(dir*1.2+Vector3.yAxis*.75).Unit;a0.Parent=anchor
		local a1=Instance.new("Attachment");a1.Name="StreamImpact"..i;a1.Position=finish;a1.Axis=(dir*1.2-Vector3.yAxis*3).Unit;a1.Parent=anchor
		local beam=Instance.new("Beam")
		beam.Name="FlowingWater"..i;beam.Attachment0,beam.Attachment1=a0,a1
		beam.CurveSize0,beam.CurveSize1,beam.Segments=2.4,3.2,24
		beam.Width0,beam.Width1,beam.FaceCamera=.2,.3,true
		beam.TextureContent,beam.TextureLength,beam.TextureSpeed=flow,1.5,1.4
		beam.Color=ColorSequence.new(Color3.fromRGB(173,224,222));beam.Transparency=NumberSequence.new(.12)
		beam.LightInfluence,beam.Parent=.7,anchor
		local splash=Instance.new("ParticleEmitter")
		splash.Name="ImpactSpray";splash.TextureContent=droplet
		splash.Rate,splash.Lifetime,splash.Speed=14,NumberRange.new(.25,.55),NumberRange.new(1.5,3)
		splash.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,.13),NumberSequenceKeypoint.new(1,0)})
		splash.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.15),NumberSequenceKeypoint.new(1,1)})
		splash.Color=ColorSequence.new(Color3.fromRGB(204,234,231));splash.Acceleration=Vector3.new(0,-10,0)
		splash.SpreadAngle,splash.EmissionDirection=Vector2.new(35,35),Enum.NormalId.Top
		splash.Parent=a1
		local ring=Art.MakeSurface(root,"Ripple"..i,{{.42,0},{.49,0}},32,Color3.fromRGB(177,218,210),finish+Vector3.new(0,.035,0))
		ring.Material=Enum.Material.SmoothPlastic;ring:SetAttribute("RipplePhase",i/8);ring:SetAttribute("OriginalSize",ring.Size)
	end
	local sound=Instance.new("Sound")
	sound.Name="FountainWaterLoop";sound.SoundId="rbxassetid://9120557315"
	sound.Looped,sound.Volume,sound.RollOffMinDistance,sound.RollOffMaxDistance=true,.28,8,65
	sound.RollOffMode=Enum.RollOffMode.InverseTapered;sound.Parent=anchor
	-- Paired planted terraces and mature tree silhouettes.
	local tree=Art.MakeTree(root,Vector3.new(-25,.2,9),61)
	local other=tree:Clone();other.Name="Broadleaf_Right";other:PivotTo(other:GetPivot()+Vector3.new(50,0,1));other.Parent=root
	for _,x in {-25,25} do
		part("TerraceSoil",Vector3.new(15,.5,20),Vector3.new(x,.35,9),Color3.fromRGB(81,68,46),Enum.Material.Ground)
		for _,side in {-1,1} do part("PlanterCoping",Vector3.new(.8,1,20.8),Vector3.new(x+side*7.8,.65,9),cream,Enum.Material.Limestone) end
		for _,z in {-1,19} do part("PlanterCoping",Vector3.new(16.4,1,.8),Vector3.new(x,.65,z),cream,Enum.Material.Limestone) end
		local leaves={};local flowers={};local rng=Random.new(x+100)
		for k=1,85 do
			local p=Vector3.new(x+rng:NextNumber(-6.8,6.8),.7,rng:NextNumber(0,18))
			for j=0,4 do
				local a=j*math.pi*.4
				table.insert(leaves,{p,p+Vector3.new(math.cos(a)*1.2,rng:NextNumber(.5,1.7),math.sin(a)*1.2),.3})
			end
			if k%3==0 then
				local center=p+Vector3.new(0,1.3,0)
				for j=0,4 do local a=j*math.pi*.4;table.insert(flowers,{center,center+Vector3.new(math.cos(a)*.55,.12,math.sin(a)*.55),.2}) end
			end
		end
		Art.MakeLeaves(root,"TerraceUnderplanting",leaves,green)
		Art.MakeLeaves(root,"TerraceFlowers",flowers,Color3.fromRGB(230,177,143))
	end
	-- Timber hatchery portico; authored structural pieces rather than an imported house.
	part("PorticoFoundation",Vector3.new(27,.6,12),Vector3.new(0,.3,27),cream,Enum.Material.Limestone)
	for _,x in {-11,11} do
		for _,z in {23,31} do
			part("ColumnFoot",Vector3.new(2,1,2),Vector3.new(x,1,z),dark,Enum.Material.Limestone)
			part("TimberColumn",Vector3.new(.9,8.5,.9),Vector3.new(x,5,z),wood,Enum.Material.Wood)
			timber("KneeBrace",Vector3.new(x,6.5,z),Vector3.new(x-math.sign(x)*2,9,z),.45)
		end
		timber("GableRafter",Vector3.new(x,9.5,21.5),Vector3.new(x,13.7,27),.7)
		timber("GableRafter",Vector3.new(x,13.7,27),Vector3.new(x,9.5,32.5),.7)
	end
	for _,z in {23,31} do timber("PorticoBeam",Vector3.new(-12,9,z),Vector3.new(12,9,z),.9) end
	for x=-12,12,1.5 do
		for _,side in {-1,1} do
			local a=Vector3.new(x,13.9,27);local b=Vector3.new(x,9.5,27+side*6.5)
			local roof=timber("RoofShingleRun",a,b,1.42,.25);roof.Material=Enum.Material.Slate;roof.Color=Color3.fromRGB(74,106,89)
		end
	end
	timber("RoofRidge",Vector3.new(-13,14,27),Vector3.new(13,14,27),.6)
	-- Bespoke curved stone arch behind the portico.
	local v,f={},{}
	for j=0,24 do
		local angle=j*math.pi/24
		for _,z in {31.5,32.3} do for _,r in {5.8,6.6} do table.insert(v,Vector3.new(math.cos(angle)*r,2+math.sin(angle)*r,z)) end end
		if j>0 then
			local o=(j-1)*4
			for _,q in {{1,2,5},{2,6,5},{3,7,4},{4,7,8},{2,4,6},{4,8,6},{1,5,3},{3,5,7}} do table.insert(f,{o+q[1],o+q[2],o+q[3]}) end
		end
	end
	Art.MakeMesh(root,"CarvedHatcheryArch",v,f,cream)
	for _,x in {-12,12} do
		for _,z in {-20,18} do
			part("LanternPlinth",Vector3.new(1.8,.5,1.8),Vector3.new(x,.5,z),dark,Enum.Material.Limestone)
			part("LanternPost",Vector3.new(.35,5,.35),Vector3.new(x,3,z),wood,Enum.Material.Wood)
			local glass=part("LanternGlass",Vector3.new(.8,1.15,.8),Vector3.new(x,5.7,z),Color3.fromRGB(255,214,144),Enum.Material.Neon,false)
			local light=Instance.new("PointLight");light.Color=glass.Color;light.Brightness=.45;light.Range=12;light.Parent=glass
			for _,y in {5,6.4} do part("LanternCap",Vector3.new(1.1,.15,1.1),Vector3.new(x,y,z),dark,Enum.Material.Metal) end
		end
	end
	for _,x in {-13.5,13.5} do
		for _,z in {-12,11} do
			for _,leg in {-2,2} do part("BenchLeg",Vector3.new(.6,1.5,.7),Vector3.new(x,.95,z+leg),dark,Enum.Material.Metal) end
			for _,dx in {-.4,.4} do part("BenchSeat",Vector3.new(.7,.25,5.4),Vector3.new(x+dx,1.8,z),wood,Enum.Material.WoodPlanks) end
			part("BenchBack",Vector3.new(.25,1.1,5.4),Vector3.new(x+math.sign(x)*.8,2.5,z),wood,Enum.Material.WoodPlanks)
		end
	end
	local landing=part("ReviewLanding",Vector3.new(8,.3,6),Vector3.new(0,.15,-30),cream,Enum.Material.Limestone)
	root:SetAttribute("LocalLanding",Vector3.new(0,4,-30))
	root:PivotTo(root:GetPivot()+Vector3.new(3600,120,0))
	root:SetAttribute("ReviewLanding",landing.Position+Vector3.new(0,4,0))
	root:SetAttribute("AssemblyReady",true)
	return root
end
return Courtyard
