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
local visuals={}
local function attach(anchor)
 if visuals[anchor] or not anchor:IsA("Model") or not anchor.Name:match("^Companion_") then return end
 -- Children can replicate after the model itself on another player's client.
 local body=anchor:FindFirstChild("Body") or anchor:WaitForChild("Body",10)
 if not body or not anchor.Parent or visuals[anchor] then return end
 local model=template:Clone();model.Name="SproutVisual";model.Parent=anchor
 local scale=anchor:GetAttribute("VisualScale") or 1;model:ScaleTo(scale);model:PivotTo(anchor:GetPivot())
 visuals[anchor]={Model=model,Scale=scale,Position=anchor:GetPivot().Position,Speed=0}
end
for _,anchor in workspace:GetChildren() do task.spawn(attach,anchor) end
workspace.ChildAdded:Connect(function(anchor) task.defer(attach,anchor) end)
Run.PreSimulation:Connect(function(dt)
 local now=workspace:GetServerTimeNow()
 for anchor,data in visuals do
  if not anchor.Parent then data.Model:Destroy();visuals[anchor]=nil;continue end
  local scale=anchor:GetAttribute("VisualScale") or 1
  if scale~=data.Scale then data.Model:ScaleTo(scale);data.Scale=scale end
  local cf=anchor.Body.CFrame
  local speed=(cf.Position-data.Position).Magnitude/math.max(dt,.001)
  data.Position=cf.Position;data.Speed+=(math.min(speed,18)-data.Speed)*math.min(1,dt*8)
  data.Model:PivotTo(cf)
  local reaction=math.max(0,1-(now-(anchor:GetAttribute("LastReaction") or -100))/.6)
  Rig.Pose(data.Model,now,data.Speed,reaction)
 end
end)
