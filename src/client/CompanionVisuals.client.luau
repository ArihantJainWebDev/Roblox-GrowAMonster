local Players=game:GetService("Players")
local Run=game:GetService("RunService")
local Rig=require(script.Parent.creatures.BabyRig)
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
local visuals={}
local function attach(anchor)
 if visuals[anchor] or not anchor:IsA("Model") or not anchor.Name:match("^Companion_") then return end
 -- Children can replicate after the model itself on another player's client.
 local body=anchor:FindFirstChild("Body") or anchor:WaitForChild("Body",10)
 if not body or not anchor.Parent or visuals[anchor] then return end
 local stage=anchor:GetAttribute("Stage") or "Baby"
 local model=(templates[stage] or template):Clone();model.Name="SproutVisual";model.Parent=anchor
 local scale=anchor:GetAttribute("VisualScale") or 1;model:ScaleTo(scale);model:PivotTo(anchor:GetPivot())
 visuals[anchor]={Model=model,Scale=scale,Position=anchor:GetPivot().Position,Speed=0,Phase=0,Frame=anchor:GetPivot(),Relocation=anchor:GetAttribute("Relocation"),Stage=stage}
end
for _,anchor in workspace:GetChildren() do task.spawn(attach,anchor) end
workspace.ChildAdded:Connect(function(anchor) task.defer(attach,anchor) end)
Run.PreSimulation:Connect(function(dt)
 local now=workspace:GetServerTimeNow()
 for anchor,data in visuals do
  if not anchor.Parent then data.Model:Destroy();visuals[anchor]=nil;continue end
  local stage=anchor:GetAttribute("Stage") or "Baby"
  if stage~=data.Stage and templates[stage] then
   local replacement=templates[stage]:Clone();replacement.Name="SproutVisual"
   replacement:PivotTo(data.Frame);replacement.Parent=anchor
   data.Model:Destroy();data.Model=replacement;data.Stage=stage;data.Scale=0
  end
  local scale=anchor:GetAttribute("VisualScale") or 1
  if scale~=data.Scale then data.Model:ScaleTo(scale);data.Scale=scale end
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
  Rig.Pose(data.Model,data.Phase,data.Speed,reaction,now)
 end
end)
