-- Non-colliding atmosphere and vegetation; the server terrain owns navigation.
local RS=game:GetService("ReplicatedStorage")
local Run=game:GetService("RunService")
local world=workspace:WaitForChild("WorldFoundation",90)
if not world then return end
local Map=require(RS.Shared.WorldConfig)
local Art=require(RS.ArtReview.Geometry)
local root=Instance.new("Model");root.Name="SkyWorldVisuals";root.Parent=workspace
local image
local ok,err=pcall(function()
	local n=256;image=assert(game:GetService("AssetService"):CreateEditableImage({Size=Vector2.new(n,n)}))
	local pixels=buffer.create(n*n*4)
	for y=0,n-1 do
		for x=0,n-1 do
			local noise=math.noise(x*.024,y*.024,4)*.55+math.noise(x*.055,y*.055,9)*.22+math.noise(x*.12,y*.12,1)*.08
			local edge=math.clamp(math.min(x,y,n-1-x,n-1-y)/24,0,1)
			local alpha=math.clamp((noise+.24)*2.3,.05,.94)*edge
			local at=(y*n+x)*4;local shade=math.floor(235+math.clamp(noise*35,-18,18))
			buffer.writeu8(pixels,at,shade);buffer.writeu8(pixels,at+1,shade);buffer.writeu8(pixels,at+2,math.min(255,shade+3));buffer.writeu8(pixels,at+3,math.floor(alpha*255))
		end
		task.wait()
	end
	image:WritePixelsBuffer(Vector2.zero,Vector2.new(n,n),pixels)
	local centers={}
	for _,x in {-1000,700,2400} do for _,z in {-1700,0,1700} do table.insert(centers,Vector3.new(x,210,z)) end end
	for i,center in centers do
		local extent=900
		local verts={center+Vector3.new(-extent,0,-extent),center+Vector3.new(extent,0,-extent),center+Vector3.new(extent,0,extent),center+Vector3.new(-extent,0,extent)}
		-- A tiny dedicated image-mapped mesh keeps cloud rendering separate from terrain.
		local service=game:GetService("AssetService");local mesh=assert(service:CreateEditableMesh())
		local ids={};for j,v in verts do ids[j]=mesh:AddVertex(v-center) end
		local uv={mesh:AddUV(Vector2.new(0,0)),mesh:AddUV(Vector2.new(1,0)),mesh:AddUV(Vector2.new(1,1)),mesh:AddUV(Vector2.new(0,1))}
		local f1=mesh:AddTriangle(ids[1],ids[3],ids[2]);mesh:SetFaceUVs(f1,{uv[1],uv[3],uv[2]})
		local f2=mesh:AddTriangle(ids[1],ids[4],ids[3]);mesh:SetFaceUVs(f2,{uv[1],uv[4],uv[3]})
		local status,content=service:CreateDataModelContentAsync(Content.fromObject(mesh));assert(status==Enum.CreateContentResult.Success)
		local plane=service:CreateMeshPartAsync(content);mesh:Destroy()
		plane.Name="CloudLayer"..i;plane.Anchored,plane.CanCollide,plane.CanTouch,plane.CanQuery=true,false,false,false
		plane.Transparency=.02 -- enable smooth alpha blending instead of cutout rendering
        plane.DoubleSided,plane.CastShadow=true,false;plane.CFrame=CFrame.new(center);plane.Color=Color3.new(1,1,1)
		local surface=service:CreateSurfaceAppearanceAsync({ColorMap=Content.fromObject(image)});surface.AlphaMode=Enum.AlphaMode.Transparency;surface.Parent=plane
		plane.Parent=root
        local lower=plane:Clone();lower.Name="CloudDepth"..i;lower.CFrame=plane.CFrame+Vector3.new(240,-35,280);lower.Parent=root
	end
end)
if not ok then warn("Cloud layer could not render: "..tostring(err)) end
local courtyard=workspace:WaitForChild("FountainHubVisuals",90)
if not courtyard then return end
while courtyard.Parent and not courtyard:GetAttribute("AssemblyReady") do task.wait(.2) end
-- Regional trees and planting are authored by SceneryController.
local water=courtyard:FindFirstChild("WaterEffectAnchor")
if water then
	local top=Instance.new("Part");top.Name="WaterfallAnchor";top.Size=Vector3.one;top.Anchored,top.CanCollide,top.Transparency=true,false,1
	local outlet=RS:WaitForChild("SceneGround"):WaitForChild("150.00:-240.00")
	top.Position=outlet.Value-Vector3.new(0,.05,0);top.Parent=root
	local a=Instance.new("Attachment");a.Parent=top
	local b=Instance.new("Attachment");b.Position=Vector3.new(0,215-top.Position.Y,0);b.Parent=top
	local beam=Instance.new("Beam");beam.Name="OrchardWaterfall";beam.Attachment0,beam.Attachment1=a,b
	beam.Width0,beam.Width1,beam.Segments,beam.FaceCamera=5,9,12,true
	beam.TextureContent=water.FlowingWater0.TextureContent;beam.TextureLength,beam.TextureSpeed=9,2
	beam.Color=ColorSequence.new(Color3.fromRGB(193,224,226));beam.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.15),NumberSequenceKeypoint.new(.85,.25),NumberSequenceKeypoint.new(1,1)})
	beam.Parent=top
	local mist=water.StreamImpact0.ImpactSpray:Clone();mist.Name="WaterfallMist";mist.Rate=20;mist.Size=NumberSequence.new(5);mist.Speed=NumberRange.new(1,3);mist.Parent=b
end
game.Players.LocalPlayer:SetAttribute("SkyWorldVisualsReady",ok)

-- Authored faceted bloom: swept petals around a crystal seed, aligned to its server prompt.
local bloom=workspace:WaitForChild("ElementGrove"):WaitForChild("GroveBloom")
local origin=bloom.Position-Vector3.new(0,1.5,0)
for layer=1,2 do
 local vertices,faces={},{}
 for petal=0,7 do
  local angle=petal*math.pi/4+layer*.22
  local forward=Vector3.new(math.cos(angle),0,math.sin(angle))
  local side=Vector3.new(-forward.Z,0,forward.X)
  local start=#vertices
  for step=0,5 do
   local t=step/5;local width=math.sin(t*math.pi)*1.65
   local point=origin+forward*(.5+t*(layer==1 and 5.2 or 3.6))+Vector3.new(0,.3+math.sin(t*math.pi)*1.1+t*t*(layer==1 and .7 or 2.7),0)
   table.insert(vertices,point-side*width);table.insert(vertices,point+side*width)
  end
  for step=0,4 do local a=start+step*2+1;table.insert(faces,{a,a+1,a+2});table.insert(faces,{a+1,a+3,a+2}) end
 end
 local mesh=Art.MakeMesh(root,"GroveBloomPetals"..layer,vertices,faces,layer==1 and Color3.fromRGB(88,153,135) or Color3.fromRGB(192,153,225),Enum.Material.SmoothPlastic)
 mesh.DoubleSided=true
end
local vertices={origin+Vector3.new(0,5.8,0),origin+Vector3.new(0,.7,0)}
for i=0,5 do table.insert(vertices,origin+Vector3.new(math.cos(i*math.pi/3)*1.2,2.3,math.sin(i*math.pi/3)*1.2)) end
local faces={};for i=0,5 do local a=3+i;local b=3+(i+1)%6;table.insert(faces,{1,a,b});table.insert(faces,{2,b,a}) end
Art.MakeMesh(root,"GroveBloomSeed",vertices,faces,Color3.fromRGB(219,190,255),Enum.Material.Neon)
