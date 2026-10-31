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
local function buildTail(parent,young)
 -- An external rearward sweep replaces the generated coil that crossed the torso.
 -- Bury the root inside the rump; the former high, open root exposed a gap.
 local path={Vector3.new(0,.57,.32),Vector3.new(0,.57,.65),Vector3.new(0,.57,.94),Vector3.new(.04,.55,1.25),Vector3.new(.12,.52,1.58),Vector3.new(.25,.56,1.88),Vector3.new(.38,.7,2.1)}
 if young then for i,point in path do path[i]=Vector3.new(point.X*1.2,point.Y+.22,point.Z*1.18+.22) end end
 local radii={.20,.23,.20,.16,.12,.075,.008};local v,f={},{};local n=24
 for j,point in path do
  local direction=(path[math.min(#path,j+1)]-path[math.max(1,j-1)]).Unit
  local right=direction:Cross(Vector3.yAxis).Unit;local up=right:Cross(direction).Unit
  for i=0,n-1 do local a=i*math.pi*2/n;table.insert(v,point+(right*math.cos(a)+up*math.sin(a))*radii[j]) end
  if j>1 then for i=1,n do local a=(j-2)*n+i;local b=(j-2)*n+i%n+1
   table.insert(f,{a,a+n,b});table.insert(f,{b,a+n,b+n})
  end end
 end
 local base=#v+1;table.insert(v,path[1])
 local tip=#v+1;table.insert(v,path[#path])
 for i=1,n do
  table.insert(f,{base,i,i%n+1})
  table.insert(f,{tip,(#path-1)*n+i%n+1,(#path-1)*n+i})
 end
 return Art.MakeMesh(parent,"tail_geom",v,f,Color3.fromRGB(83,157,119),Enum.Material.SmoothPlastic,true)
end
function Rig.Build(stage)
 local young=stage=="Young"
 local model=Instance.new("Model");model.Name="BabySproutRig";model.WorldPivot=CFrame.new()
 local root=Instance.new("Part");root.Name="RigRoot";root.Size=Vector3.new(.2,.2,.2);root.Transparency=1
 root.Anchored,root.CanCollide,root.CanTouch,root.CanQuery=true,false,false,false;root.Parent=model;model.PrimaryPart=root
 local pieces={}
 for _,data in Manifest.Parts do
  if data.Name=="tail_geom" then continue end
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
 if young then
  for name,p in pieces do
   if name=="body_geom" then p.Size*=Vector3.new(1.13,1.12,1.35);p.CFrame=CFrame.new(0,1.4,.12)
   elseif name=="head_geom" then p.Size*=1.03;p.CFrame=CFrame.new(0,2.47,-.69)
   else
    local front=name:match("front")~=nil
    p.Size*=Vector3.new(1.15,1.4,1.13)
    p.CFrame=CFrame.new(p.Position.X*1.3,p.Position.Y*1.4,front and -.78 or .42)
   end
  end
 end
 pieces.tail_geom=buildTail(model,young)
 pieces.tail_geom.Anchored=false;pieces.tail_geom.Massless=true;pieces.tail_geom.CanQuery=false
 local body=assert(pieces.body_geom);joint(root,body,"BodyRoot",Vector3.zero)
 joint(body,assert(pieces.head_geom),"Neck",young and Vector3.new(0,2.07,-.62) or Vector3.new(0,1.65,-.5))
 joint(body,assert(pieces.tail_geom),"TailBase",young and Vector3.new(0,.79,.81) or Vector3.new(0,.57,.50))
 local names={
  {"front left leg_geom","ForeLeft"},{"front right leg_geom","ForeRight"},
  {"rear left leg_geom","HindLeft"},{"rear right leg_geom","HindRight"},
 }
 for _,info in names do
  local leg=assert(pieces[info[1]]);joint(body,leg,info[2],leg.Position+Vector3.new(0,leg.Size.Y*.43,0));paw(model,leg)
 end
 -- Young keeps the integrated textured foliage in the family mesh.
 -- Detached flat add-on mantle panels were removed rather than posing as wings.
 model:SetAttribute("LifeStage",young and "Young" or "Baby")
 model:SetAttribute("StrideLength",young and 2.1 or 1.7)
 local controller=Instance.new("AnimationController");controller.Name="CompanionAnimation";controller.Parent=model
 Instance.new("Animator",controller)
 model:SetAttribute("AssetVersion",Manifest.Version);model:SetAttribute("RigType","Motor6D-quadruped")
 return model
end
function Rig.Pose(model,phase,speed,reaction,time,action)
 local body=model:FindFirstChild("body_geom");if not body then return end
 action=action or {};local kind=action.Kind;local age=action.Age or 100
 local feeding=(kind=="Feed" or kind=="Grow") and age<1.35
 local chew=feeding and math.sin(math.max(0,age-.35)*math.pi*5)^2 or 0
 local pet=kind=="Pet" and age<1.8
 local emerge=kind=="Hatch" and math.clamp((age-1)/1.5,0,1) or 1
 local gait=math.min(speed/3,1)*.55
 for name,offset in {ForeLeft=0,HindRight=0,ForeRight=math.pi,HindLeft=math.pi} do
  local motor=body:FindFirstChild(name)
  if motor then motor.Transform=CFrame.Angles(math.sin(phase+offset)*gait+(feeding and -.035*chew or 0),0,0) end
 end
 local neck=body:FindFirstChild("Neck")
 local happy=pet and math.sin(age*math.pi/1.8) or 0
 local channel=kind and kind:match("^Ability") and math.sin(math.clamp(age/2.3,0,1)*math.pi) or 0
 if neck then
  neck.Transform=CFrame.Angles(math.sin(time*1.5)*.025-chew*.13+(1-emerge)*-.14-channel*.10,(1-channel)*math.sin(time*.8)*.09,math.sin(time*2)*.015+happy*.16)
 end
 local tail=body:FindFirstChild("TailBase")
 if tail then tail.Transform=CFrame.Angles(0,math.sin(time*(pet and 8 or 2.2))*(pet and .18 or .07),0) end
 local bodyRoot=model.RigRoot:FindFirstChild("BodyRoot")
 if bodyRoot then
  local joy=pet and math.abs(math.sin(age*math.pi*2))*.055 or 0
  local charge=kind=="Evolve" and age<1.25 and math.sin(age*math.pi/1.25)*.035 or 0
  bodyRoot.Transform=CFrame.new(0,joy-charge,0)*CFrame.Angles(charge*.8,0,0)
 end
end
return Rig
