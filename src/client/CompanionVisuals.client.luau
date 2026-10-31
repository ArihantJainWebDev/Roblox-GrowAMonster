local Players=game:GetService("Players")
local Run=game:GetService("RunService")
local Rig=require(script.Parent.creatures.BabyRig)
local Forms=require(script.Parent.creatures.ElementForms)
local Effects=require(script.Parent.creatures.CompanionEffects)
local player=Players.LocalPlayer
player:SetAttribute("BabyRigStatus","Loading")
local ok,template=pcall(Rig.Build)
if not ok then
 player:SetAttribute("BabyRigStatus",tostring(template));warn("Baby Sprout rig could not load: "..tostring(template));return
end
player:SetAttribute("BabyRigStatus","Ready")
local templates={Baby=template}
local youngOK,young=pcall(Rig.Build,"Young")
if youngOK then templates.Young=young;player:SetAttribute("YoungRigStatus","Ready")
else player:SetAttribute("YoungRigStatus",tostring(young));warn("Young Sprout rig: "..tostring(young)) end
local function appearance(anchor)
 local path=anchor:GetAttribute("Path")
 if path=="Fire" or path=="Crystal" or path=="Nature" then return path end
 return anchor:GetAttribute("Stage") or "Baby"
end
-- Prefetch after the starter rigs are available; one shared template per branch/client.
if youngOK then task.spawn(function()
 for _,path in {"Fire","Crystal","Nature"} do
  player:SetAttribute(path.."RigStatus","Loading")
  local success,result=pcall(Forms.Build,young,path)
  if success then templates[path]=result;player:SetAttribute(path.."RigStatus","Ready")
  else player:SetAttribute(path.."RigStatus",tostring(result));warn(path.." Sprout: "..tostring(result)) end
  task.wait()
 end
end) end
local visuals={}
local function attach(anchor)
 if visuals[anchor] or not anchor:IsA("Model") or not anchor.Name:match("^Companion_") then return end
 -- Children can replicate after the model itself on another player's client.
 local body=anchor:FindFirstChild("Body") or anchor:WaitForChild("Body",10)
 if not body or not anchor.Parent or visuals[anchor] then return end
 local stage=appearance(anchor)
 local selected=templates[stage] or templates[anchor:GetAttribute("Stage")] or template
 if not templates[stage] then stage=anchor:GetAttribute("Stage") or "Baby" end
 local model=selected:Clone();model.Name="SproutVisual";model.Parent=anchor
 local scale=anchor:GetAttribute("VisualScale") or 1;model:ScaleTo(scale);model:PivotTo(anchor:GetPivot())
 visuals[anchor]={Model=model,Scale=scale,Position=anchor:GetPivot().Position,Speed=0,Phase=0,Frame=anchor:GetPivot(),Relocation=anchor:GetAttribute("Relocation"),Stage=stage}
end
for _,anchor in workspace:GetChildren() do task.spawn(attach,anchor) end
workspace.ChildAdded:Connect(function(anchor) task.defer(attach,anchor) end)
Run.PreSimulation:Connect(function(dt)
 local now=workspace:GetServerTimeNow()
 for anchor,data in visuals do
  if not anchor.Parent then data.Model:Destroy();if data.Transition then data.Transition.Old:Destroy() end;visuals[anchor]=nil;continue end
  local kind=anchor:GetAttribute("Action")
  local started=anchor:GetAttribute("ActionStarted") or -100
  local age=now-started
  local duration=anchor:GetAttribute("ActionDuration") or 0
  if age>=duration then kind=nil end
  if started~=data.LastAction then
   data.LastAction=started;data.CueScale=data.Scale
   if kind=="Feed" or kind=="Grow" then Effects.Food(anchor,data.Model,anchor:GetAttribute("ActionFood"),started)
   elseif kind=="Pet" then Effects.Heart(anchor,started)
   elseif kind and kind:match("^Ability") then Effects.Ability(anchor,kind,started)
   elseif kind=="Hatch" then data.HatchBurst=false end
  end
  if kind=="Hatch" and age>=1 and not data.HatchBurst then Effects.Burst(anchor,18);data.HatchBurst=true end
  local stage=appearance(anchor)
  if (kind=="Grow" and age<1.1) or (kind=="Evolve" and age<1.2) then stage=data.Stage end
  if stage~=data.Stage and templates[stage] then
   local replacement=templates[stage]:Clone();replacement.Name="SproutVisual"
   replacement:PivotTo(data.Frame);replacement.Parent=anchor
   if data.Transition then data.Transition.Old:Destroy() end
   data.Model.Name="PreviousSproutVisual"
   data.Transition={Old=data.Model,Started=now}
   data.Model=replacement;data.Stage=stage;data.Scale=0
   Effects.Burst(anchor,26)
  end
  local scale=anchor:GetAttribute("VisualScale") or 1
  if kind=="Grow" and age<1.1 then scale=data.CueScale or scale end
  if anchor:GetAttribute("OwnerUserId")==player.UserId and player:GetAttribute("CompanionAction")~=(kind or "") then player:SetAttribute("CompanionAction",kind or "") end
  local reveal=kind=="Hatch" and math.clamp((age-.95)/1.05,0,1) or 1
  local alpha=1
  if data.Transition then alpha=math.clamp((now-data.Transition.Started)/.65,0,1) end
  local visualScale=scale*(.65+.35*reveal)*(.85+.15*alpha)
  if math.abs(visualScale-data.Scale)>.0001 then data.Model:ScaleTo(visualScale);data.Scale=visualScale end
  for _,p in data.Model:GetDescendants() do if p:IsA("BasePart") and p.Name~="RigRoot" then p.Transparency=1-reveal*alpha end end
  local target=anchor.Body.CFrame
  local relocation=anchor:GetAttribute("Relocation")
  local snap=relocation~=data.Relocation or (target.Position-data.Frame.Position).Magnitude>50
  data.Relocation=relocation
  local cf=snap and target or data.Frame:Lerp(target,1-math.exp(-dt*18))
  local distance=(Vector3.new(cf.X,0,cf.Z)-Vector3.new(data.Frame.X,0,data.Frame.Z)).Magnitude
  data.Frame=cf
  local speed=snap and 0 or distance/math.max(dt,.001)
  data.Speed+=(speed-data.Speed)*math.min(1,dt*12)
  data.Phase+=snap and 0 or distance*math.pi*2/(data.Model:GetAttribute("StrideLength") or 1.7)
  data.Model:PivotTo(cf)
  local reaction=math.max(0,1-(now-(anchor:GetAttribute("LastReaction") or -100))/.6)
  local cue={Kind=kind,Age=age}
  Rig.Pose(data.Model,data.Phase,data.Speed,reaction,now,cue)
  if data.Transition then
   local old=data.Transition.Old;old:PivotTo(cf)
   Rig.Pose(old,data.Phase,data.Speed,reaction,now,cue)
   for _,p in old:GetDescendants() do if p:IsA("BasePart") and p.Name~="RigRoot" then p.Transparency=alpha end end
   if alpha>=1 then old:Destroy();data.Transition=nil end
  end
 end
end)
