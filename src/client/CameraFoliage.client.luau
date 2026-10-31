-- Decorative plants do not collide with the camera. Fade them before the lens enters them.
local Run=game:GetService("RunService")
local foliage={}
local function register(part)
 if part:IsA("BasePart") and part:GetAttribute("CameraFoliage")==true and not foliage[part] then
  foliage[part]={Base=part.LocalTransparencyModifier,Active=false}
 end
end
for _,part in workspace:GetDescendants() do register(part) end
workspace.DescendantAdded:Connect(function(part)
 if part:IsA("BasePart") then task.defer(register,part) end
end)
Run:BindToRenderStep("GardenFoliageFade",Enum.RenderPriority.Camera.Value+1,function()
 local camera=workspace.CurrentCamera;if not camera then return end
 local position=camera.CFrame.Position
 for part,state in foliage do
  if not part:IsDescendantOf(workspace) then foliage[part]=nil;continue end
  local localPosition=part.CFrame:PointToObjectSpace(position)
  local half=part.Size/2
  local closest=Vector3.new(math.clamp(localPosition.X,-half.X,half.X),math.clamp(localPosition.Y,-half.Y,half.Y),math.clamp(localPosition.Z,-half.Z,half.Z))
  local distance=(localPosition-closest).Magnitude
  local fade=math.clamp((2.5-distance)/1.5,0,1)
  if fade>0 then
   if not state.Active then state.Base=part.LocalTransparencyModifier;state.Active=true end
   part.LocalTransparencyModifier=math.max(state.Base,fade)
  elseif state.Active then
   part.LocalTransparencyModifier=state.Base;state.Active=false
  end
 end
end)
