-- Original authored mesh studies. Run through Studio's Edit-context tools only.
-- Not a runtime dependency, not uploaded, and not an accepted production kit.
local AssetService = game:GetService("AssetService")
local Study = {}
local stone = Color3.fromRGB(187,181,160)
local lightStone = Color3.fromRGB(216,207,179)
local function meshPart(parent,name,vertices,faces,color,material)
	local clean={}
	for _,t in faces do
		if (vertices[t[2]]-vertices[t[1]]):Cross(vertices[t[3]]-vertices[t[1]]).Magnitude>1e-8 then table.insert(clean,t) end
	end
	faces=clean
	Study.Geometry=Study.Geometry or {}
	table.insert(Study.Geometry,{name=name,vertices=vertices,faces=faces,color=color})
	local mesh=assert(AssetService:CreateEditableMesh(),"Editable mesh budget exhausted")
	local min,max=vertices[1],vertices[1]
	for _,v in vertices do min=min:Min(v);max=max:Max(v) end
	local center=(min+max)/2
	local ids={}
	for i,p in vertices do ids[i]=mesh:AddVertex(p-center) end
	for i,t in faces do
		local face=mesh:AddTriangle(ids[t[1]],ids[t[2]],ids[t[3]])
		local n=(vertices[t[2]]-vertices[t[1]]):Cross(vertices[t[3]]-vertices[t[1]])
		if n.Magnitude>0 then local normal=mesh:AddNormal(n.Unit);mesh:SetFaceNormals(face,{normal,normal,normal}) end
		if i%1500==0 then task.wait() end
	end
	-- Freeze each finished piece before creating the next one. Keeping dozens
	-- of variable-size EditableMeshes alive exhausts the client memory budget.
	local status,content=AssetService:CreateDataModelContentAsync(Content.fromObject(mesh))
	assert(status==Enum.CreateContentResult.Success,"Could not freeze mesh: "..tostring(status))
	local p=AssetService:CreateMeshPartAsync(content)
	mesh:Destroy()
	p.Name,p.Anchored,p.CanCollide,p.CanTouch=name,true,false,false
	p.Color,p.Material,p.DoubleSided=color,material or Enum.Material.Limestone,true
	-- Mesh bounds may not be centered on the authored origin.
	p.CFrame=CFrame.new(center)
	p.Parent=parent
	-- Geometry source remains in Study.Geometry for export/reconstruction.
	return p
end
local function surface(parent,name,profile,segments,color,offset,lobes,amplitude)
	local v,f={},{}
	offset=offset or Vector3.zero
	for j,point in profile do
		for i=0,segments-1 do
			local a=i*math.pi*2/segments
			local r=point[1]*(1+(amplitude or 0)*math.cos(a*(lobes or 1)))
			table.insert(v,offset+Vector3.new(math.cos(a)*r,point[2],math.sin(a)*r))
		end
		if j>1 then for i=0,segments-1 do
			local a=(j-2)*segments+i+1;local b=(j-2)*segments+(i+1)%segments+1
			local c=a+segments;local d=b+segments
			table.insert(f,{a,c,b});table.insert(f,{b,c,d})
		end end
	end
	return meshPart(parent,name,v,f,color)
end
local function leafMesh(parent,name,leaves,color)
	local v,f={},{}
	for _,l in leaves do
		local base,tip,width=l[1],l[2],l[3]
		local dir=tip-base
		local side=dir:Cross(Vector3.new(0,1,0))
		if side.Magnitude<0.01 then side=Vector3.xAxis else side=side.Unit end
		local mid=base+dir*.48
		local n=#v
		table.insert(v,base);table.insert(v,mid+side*width);table.insert(v,mid+Vector3.new(0,.22,0));table.insert(v,mid-side*width);table.insert(v,tip)
		for _,t in {{1,2,3},{1,3,4},{2,5,3},{3,5,4}} do table.insert(f,{n+t[1],n+t[2],n+t[3]}) end
	end
	return meshPart(parent,name,v,f,color,Enum.Material.SmoothPlastic)
end
local function tube(v,f,points,radii,segments)
	local start=#v
	for j,point in points do
		local dir=(points[math.min(j+1,#points)]-points[math.max(j-1,1)]).Unit
		local a=dir:Cross(Vector3.zAxis)
		if a.Magnitude<.01 then a=dir:Cross(Vector3.xAxis) end
		a=a.Unit;local b=dir:Cross(a).Unit
		for i=0,segments-1 do local angle=i*math.pi*2/segments;table.insert(v,point+(a*math.cos(angle)+b*math.sin(angle))*radii[j]) end
		if j>1 then for i=0,segments-1 do
			local p=start+(j-2)*segments+i+1;local q=start+(j-2)*segments+(i+1)%segments+1
			table.insert(f,{p,q,p+segments});table.insert(f,{q,q+segments,p+segments})
		end end
	end
end
local function fountain(parent)
	local m=Instance.new("Model");m.Name="Original_Fountain";m.Parent=parent
	surface(m,"TerracedPlinth",{{0,0},{10.8,0},{10.8,.35},{10.4,.55},{9.8,.55},{9.8,.85},{0,.85}},64,stone)
	surface(m,"ScallopedBasin",{{8.8,.85},{9.2,1.1},{9.3,1.9},{9.65,2.05},{9.65,2.4},{9.35,2.6},{8.9,2.6},{8.75,2.25},{8.65,1.25},{0,1.25}},96,lightStone,nil,6,.07)
	surface(m,"BasinWater",{{0,1.95},{8.7,1.95}},96,Color3.fromRGB(75,150,151),nil,6,.07).Material=Enum.Material.Glass
	surface(m,"CarvedPedestal",{{0,1.3},{2.2,1.3},{2.2,1.7},{1.6,2},{1.05,2.8},{.9,5.6},{1.5,6.1},{0,6.1}},48,stone,nil,8,.08)
	surface(m,"UpperChalice",{{.4,5.8},{1.4,6},{2.7,6.7},{3.6,7.25},{3.8,7.45},{3.8,7.8},{3.45,7.8},{3.2,7.4},{2.4,6.95},{.3,6.7}},64,lightStone,nil,8,.045)
	surface(m,"UpperWater",{{0,7.25},{3.25,7.25}},64,Color3.fromRGB(75,150,151)).Material=Enum.Material.Glass
	-- Curved carved botanical crest, modeled as tapered mesh leaves.
	local leaves={}
	for i=0,5 do local a=i*math.pi/3;table.insert(leaves,{Vector3.new(0,7.1,0),Vector3.new(math.cos(a)*1.5,10.8,math.sin(a)*1.5),.65}) end
	leafMesh(m,"BotanicalCrest",leaves,lightStone)
	for i=0,7 do
		local a=i*math.pi/4
		local v,f={},{}
		local points,radii={},{}
		for j=0,14 do
			local t=j/14;local r=3.3+t*3.7
			table.insert(points,Vector3.new(math.cos(a)*r,7.4+2.2*t-7.6*t*t,math.sin(a)*r));table.insert(radii,.065)
		end
		tube(v,f,points,radii,5)
		local stream=meshPart(m,"WaterArc"..i,v,f,Color3.fromRGB(144,208,206),Enum.Material.Glass);stream.Transparency=.3
	end
	-- Small carved perimeter reliefs, rather than copied character statues.
	for i=0,11 do
		local a=i*math.pi/6;local base=Vector3.new(math.cos(a)*9.1,1.5,math.sin(a)*9.1)
		leafMesh(m,"RimRelief"..i,{{base,base+Vector3.new(0,.85,0),.23}},stone)
	end
	return m
end
local function cliff(parent,name,offset,seed)
	local rng=Random.new(seed);local v,f={},{}
	local segments=24
	local layers={{1,0},{1.08,-2},{.93,-6},{.85,-10},{.7,-14},{.48,-20},{.2,-26},{.02,-29}}
	local noise={};for i=1,segments do noise[i]=rng:NextNumber(.8,1.18) end
	for j,layer in layers do
		for i=1,segments do local a=(i-1)*math.pi*2/segments;local radius=12*layer[1]*noise[i];table.insert(v,offset+Vector3.new(math.cos(a)*radius,layer[2]+rng:NextNumber(-.5,.5),math.sin(a)*radius*.8)) end
		if j>1 then for i=1,segments do
			local p=(j-2)*segments+i;local q=(j-2)*segments+i%segments+1
			table.insert(f,{p,q,p+segments});table.insert(f,{q,q+segments,p+segments})
		end end
	end
	local center=#v+1;table.insert(v,offset)
	for i=1,segments do table.insert(f,{center,i%segments+1,i}) end
	return meshPart(parent,name,v,f,Color3.fromRGB(133,133,117),Enum.Material.Rock)
end
local function tree(parent,offset,seed)
	local m=Instance.new("Model");m.Name="Original_Broadleaf";m.Parent=parent
	local rng=Random.new(seed);local v,f={},{};local groups={{},{},{}};local sockets={}
	tube(v,f,{offset,offset+Vector3.new(.3,7,0),offset+Vector3.new(-.3,14,.4),offset+Vector3.new(.5,21,0)},{1.2,.85,.55,.12},10)
	for i=0,9 do
		local a=i*2.4;local y=10+(i%4)*2.7
		local start=offset+Vector3.new(0,y,0)
		local endpoint=offset+Vector3.new(math.cos(a)*(6+i%3),y+4,math.sin(a)*(6+i%3))
		table.insert(sockets,endpoint)
		tube(v,f,{start,start:Lerp(endpoint,.5)+Vector3.new(0,1,0),endpoint},{.45,.25,.05},7)
		for j=1,5 do
			local angle=a+(j-3)*.48
			local tip=endpoint+Vector3.new(math.cos(angle)*2.5,rng:NextNumber(-.5,2),math.sin(angle)*2.5)
			tube(v,f,{start:Lerp(endpoint,.7),tip},{.12,.025},5)
			for k=1,45 do
				local p=tip+Vector3.new(rng:NextNumber(-2.2,2.2),rng:NextNumber(-1.4,1.4),rng:NextNumber(-2.2,2.2))
				local direction=Vector3.new(math.cos(angle+rng:NextNumber(-2,2)),rng:NextNumber(-.3,.8),math.sin(angle+rng:NextNumber(-2,2))).Unit
				table.insert(groups[k%3+1],{p,p+direction*rng:NextNumber(2.1,3),rng:NextNumber(.5,.8)})
			end
		end
	end
	local trunk=meshPart(m,"BranchingTrunk",v,f,Color3.fromRGB(112,86,58),Enum.Material.Wood)
	for i,point in sockets do local socket=Instance.new("Attachment");socket.Name="FruitSocket"..i;socket.Position=trunk.CFrame:PointToObjectSpace(point);socket.Parent=trunk end
	for i,color in {Color3.fromRGB(73,116,67),Color3.fromRGB(103,143,74),Color3.fromRGB(135,162,88)} do leafMesh(m,"LeafSprays"..i,groups[i],color) end
	return m
end
function Study.Build()
	assert(not game:GetService("RunService"):IsRunning(),"Run in Edit mode")
	local old=workspace:FindFirstChild("OriginalAssetStudy");if old then old:Destroy() end
	if Study.Meshes then for _,mesh in Study.Meshes do mesh:Destroy() end end
	Study.Meshes={};Study.Geometry={}
	local m=Instance.new("Model");m.Name="OriginalAssetStudy";m.Parent=workspace
	fountain(m);task.wait()
	cliff(m,"CliffShell_A",Vector3.new(30,0,0),81);task.wait()
	cliff(m,"CliffShell_B",Vector3.new(53,2,0),26);task.wait()
	tree(m,Vector3.new(-24,0,4),61)
	local ground=Instance.new("Part");ground.Name="InspectionSurface";ground.Size=Vector3.new(85,.3,38);ground.Anchored=true;ground.Position=Vector3.new(12,-.3,0);ground.Material=Enum.Material.Slate;ground.Color=Color3.fromRGB(91,104,98);ground.Parent=m
	m:PivotTo(m:GetPivot()+Vector3.new(3000,90,0))
	return m
end
function Study.ExportOBJ()
	local obj={"# GrowAMonster original asset studies. Units: Roblox studs.","mtllib original-world-assets.mtl"}
	local mtl={"# Original flat-color study materials; no external textures."}
	local offset=0
	for i,g in Study.Geometry or {} do
		table.insert(obj,"o "..g.name)
		table.insert(obj,"usemtl material_"..i)
		table.insert(mtl,"newmtl material_"..i)
		table.insert(mtl,string.format("Kd %.5f %.5f %.5f",g.color.R,g.color.G,g.color.B))
		table.insert(mtl,"Ks 0.05 0.05 0.05\nNs 12")
		for _,v in g.vertices do table.insert(obj,string.format("v %.5f %.5f %.5f",v.X,v.Y,v.Z)) end
		for _,f in g.faces do table.insert(obj,string.format("f %d %d %d",offset+f[1],offset+f[2],offset+f[3])) end
		offset+=#g.vertices
	end
	return {obj=table.concat(obj,"\n").."\n",mtl=table.concat(mtl,"\n").."\n",vertices=offset,objects=#(Study.Geometry or {})}
end
Study.MakeFountain=fountain
Study.MakeTree=tree
Study.MakeCliff=cliff
Study.MakeMesh=meshPart
Study.MakeLeaves=leafMesh
Study.MakeSurface=surface
return Study
