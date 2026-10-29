local RS=game:GetService("ReplicatedStorage")
local AssetService=game:GetService("AssetService")
local Manifest=require(RS.Shared.BabySproutAsset)
local Art=require(RS.ArtReview.Geometry)
local Rig={}
local function joint(parent,child,name,position)
 local bind=CFrame.new(position)
 local motor=Instance.new("Motor6D");motor.Name=name;motor.Part0=parent;motor.Part1=child
 motor.C0=parent.CFrame:ToObjectSpace(bind);motor.C1=child.CFrame:ToObjectSpace(bind);motor.Parent=parent
 return motor
end
local function weld(parent,child)
 local constraint=Instance.new("WeldConstraint");constraint.Part0=parent;constraint.Part1=child;constraint.Parent=parent
 child.Anchored=false;child.Massless=true
end
local function paw(parent,leg)
 local center=Vector3.new(leg.Position.X,0,leg.Position.Z-.1)
 local vertices,faces={},{};local segments=24
 for layer,profile in {{.75,.02},{1,.12},{.75,.23},{.25,.27}} do
  for i=0,segments-1 do local a=i*math.pi*2/segments
   table.insert(vertices,center+Vector3.new(math.cos(a)*.25*profile[1],profile[2],math.sin(a)*.32*profile[1]))
  end
  if layer>1 then for i=1,segments do local a=(layer-2)*segments+i;local b=(layer-2)*segments+i%segments+1
   table.insert(faces,{a,b,a+segments});table.insert(faces,{b,b+segments,a+segments})
  end end
 end
 local cap=#vertices+1;table.insert(vertices,center+Vector3.new(0,.27,0))
 for i=1,segments do table.insert(faces,{cap,3*segments+i,3*segments+i%segments+1}) end
 -- Ring order winds inward; reverse before shading, then close the sole.
 for _,face in faces do face[2],face[3]=face[3],face[2] end
 local sole=#vertices+1;table.insert(vertices,center+Vector3.new(0,.02,0))
 for i=1,segments do table.insert(faces,{sole,i,i%segments+1}) end
 local foot=Art.MakeMesh(parent,"AuthoredPaw",vertices,faces,Color3.fromRGB(105,157,63),Enum.Material.SmoothPlastic,true);weld(leg,foot)
 local v,f={},{}
 for toe=-1,1 do
  local p=center+Vector3.new(toe*.13,.11,-.21);local n=#v
  for _,point in {p+Vector3.new(-.055,0,0),p+Vector3.new(.055,0,0),p+Vector3.new(0,.065,0),p+Vector3.new(0,-.04,-.16)} do table.insert(v,point) end
  for _,face in {{1,3,4},{3,2,4},{2,1,4},{1,2,3}} do table.insert(f,{n+face[1],n+face[2],n+face[3]}) end
 end
 local claws=Art.MakeMesh(parent,"ThreeToeClaws",v,f,Color3.fromRGB(192,181,142),Enum.Material.SmoothPlastic);weld(leg,claws)
end
function Rig.Build()
 local model=Instance.new("Model");model.Name="BabySproutRig";model.WorldPivot=CFrame.new()
 local root=Instance.new("Part");root.Name="RigRoot";root.Size=Vector3.new(.2,.2,.2);root.Transparency=1
 root.Anchored,root.CanCollide,root.CanTouch,root.CanQuery=true,false,false,false;root.Parent=model;model.PrimaryPart=root
 local pieces={}
 for _,data in Manifest.Parts do
  local p=AssetService:CreateMeshPartAsync(Content.fromUri(data.MeshId),{CollisionFidelity=Enum.CollisionFidelity.Box,RenderFidelity=Enum.RenderFidelity.Automatic})
  p.Name=data.Name;p.Size=Vector3.new(table.unpack(data.Size));p.CFrame=CFrame.new(table.unpack(data.CFrame))
  p.TextureID=data.TextureID;p.Color=Color3.new(table.unpack(data.Color));p.Material=Enum.Material[data.Material]
  p.Anchored,p.CanCollide,p.CanTouch,p.CanQuery,p.Massless=false,false,false,false,true
  if data.Surface then
   local s=Instance.new("SurfaceAppearance");for k,value in data.Surface do if k~="AlphaMode" then s[k]=value end end
   s.AlphaMode=Enum.AlphaMode[data.Surface.AlphaMode];s.Parent=p
  end
  p.Parent=model;pieces[data.Name]=p
 end
 local body=assert(pieces.body_geom);joint(root,body,"BodyRoot",Vector3.zero)
 joint(body,assert(pieces.head_geom),"Neck",Vector3.new(0,1.65,-.5))
 joint(body,assert(pieces.tail_geom),"TailBase",Vector3.new(0,.8,.68))
 local names={
  {"front left leg_geom","ForeLeft"},{"front right leg_geom","ForeRight"},
  {"rear left leg_geom","HindLeft"},{"rear right leg_geom","HindRight"},
 }
 for _,info in names do
  local leg=assert(pieces[info[1]]);joint(body,leg,info[2],leg.Position+Vector3.new(0,leg.Size.Y*.43,0));paw(model,leg)
 end
 local controller=Instance.new("AnimationController");controller.Name="CompanionAnimation";controller.Parent=model
 Instance.new("Animator",controller)
 model:SetAttribute("AssetVersion",Manifest.Version);model:SetAttribute("RigType","Motor6D-quadruped")
 return model
end
function Rig.Pose(model,time,speed,reaction)
 local body=model:FindFirstChild("body_geom");if not body then return end
 local gait=math.min(speed/10,1)*.14
 local phase=time*8
 for name,offset in {ForeLeft=0,HindRight=0,ForeRight=math.pi,HindLeft=math.pi} do
  local motor=body:FindFirstChild(name);if motor then motor.Transform=CFrame.Angles(math.sin(phase+offset)*gait,0,0) end
 end
 local neck=body:FindFirstChild("Neck");if neck then neck.Transform=CFrame.Angles(math.sin(time*1.5)*.025+reaction*.12,math.sin(time*.8)*.04,0) end
 local tail=body:FindFirstChild("TailBase");if tail then tail.Transform=CFrame.Angles(0,math.sin(time*2.2)*.12,0) end
end
return Rig
