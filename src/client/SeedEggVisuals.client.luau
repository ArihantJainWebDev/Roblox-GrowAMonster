local Run=game:GetService("RunService")
local Egg=require(script.Parent.creatures.SeedEgg)
local ok,template=pcall(Egg.Build)
if not ok then warn("Seed egg: "..tostring(template));return end
local rendered={}
local function attach(island)
 if not island:IsA("Model") or not island.Name:match("^Island_") then return end
 local anchor=island:WaitForChild("WelcomeEgg",20)
 if not anchor or not island.Parent or rendered[island] then return end
 local model=template:Clone();model.Parent=island
 local cf=CFrame.new(anchor:GetAttribute("GroundPosition") or anchor.Position-Vector3.yAxis*1.5)
 model:PivotTo(cf)
 local shell=model.Shell;local original={}
 for _,p in shell:GetDescendants() do if p:IsA("BasePart") then original[p]=p.CFrame end end
 rendered[island]={Model=model,Anchor=anchor,Frame=cf,Original=original}
 if anchor:GetAttribute("Hatched") then shell:Destroy() end
end
for _,island in workspace:GetChildren() do task.spawn(attach,island) end
workspace.ChildAdded:Connect(function(island) task.spawn(attach,island) end)
Run.RenderStepped:Connect(function()
 for island,data in rendered do
  if not island.Parent then data.Model:Destroy();rendered[island]=nil;continue end
  local shell=data.Model:FindFirstChild("Shell")
  if not shell then continue end
  if data.Anchor:GetAttribute("Hatched") then
   data.Start=data.Start or os.clock()
   local t=math.clamp((os.clock()-data.Start)/.65,0,1)
   for p,cf in data.Original do
    p.Transparency=t
    local localPosition=data.Frame:PointToObjectSpace(cf.Position)
    p.CFrame=cf+Vector3.new(localPosition.X*t*.3,t*.5,localPosition.Z*t*.3)
   end
   if t>=1 then shell:Destroy() end
  end
 end
end)
