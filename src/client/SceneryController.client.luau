local RS=game:GetService("ReplicatedStorage")
local player=game.Players.LocalPlayer
local assets=RS:WaitForChild("ArtReview")
local Art=require(assets:WaitForChild("Geometry"))
local Scenery=require(assets:WaitForChild("WorldScenery"))
local Map=require(RS.Shared.WorldConfig)
local Farm=require(RS.Shared.FarmConfig)
local root=workspace:WaitForChild("FountainHubVisuals",90)
if not root then return end
while root.Parent and not root:GetAttribute("AssemblyReady") do task.wait(.2) end
local landscape
task.spawn(function()
local ok,err=pcall(function()
 player:RequestStreamAroundAsync(Map.Hub,5)
 local template=root:FindFirstChild("Original_Broadleaf")
 assert(template,"Courtyard tree kit is missing")
 landscape=Scenery.Build(Art,workspace.SkyWorldVisuals or workspace,template,root,Map)
end)
player:SetAttribute("W4LandscapeStatus",ok and "Ready" or tostring(err))
if not ok then warn("W4 landscape: "..tostring(err)) end
end)
local templates=Instance.new("Folder") -- unparented source models; cloned for each rendered plot
local crops={}
for _,id in Farm.Order do crops[id]={};for stage=1,3 do crops[id][stage]=Scenery.Crop(Art,templates,id,stage);task.wait() end end
local nodes=workspace:WaitForChild("FoodNodes")
local function update()
 local characterRoot=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
 if characterRoot and landscape then
  for _,piece in landscape:GetDescendants() do
   if piece:IsA("BasePart") then piece.LocalTransparencyModifier=(piece.Position-characterRoot.Position).Magnitude>650 and 1 or 0 end
   if piece:IsA("Beam") then piece.Enabled=(piece.Attachment0.WorldPosition-characterRoot.Position).Magnitude<=650 end
  end
 end
 for _,node in nodes:GetChildren() do
  local fruit=node:FindFirstChild("Fruit")
  if fruit and not node:FindFirstChild("LocalFoodVisuals") then
   local visual=Scenery.Fruit(Art,node,node:GetAttribute("FoodId"));visual.Name="LocalFoodVisuals"
   local base=node:GetAttribute("GroundPosition")
   if not base then visual:Destroy();continue end
   local berry=node:GetAttribute("FoodId")=="Berry"
   visual:PivotTo(CFrame.new(base+Vector3.new(0,berry and 1.25 or .45,0)))
   Scenery.WildPlant(Art,node,base,berry)
  end
 end
 for _,island in workspace:GetChildren() do
  if island:IsA("Model") and island.Name:match("^Island_") and island:FindFirstChild("Grass") and island:FindFirstChild("HomeSpawn") and island:FindFirstChild("Plot4") and island:FindFirstChild("SeedCounter") then
   Scenery.Home(Art,island)
   local counter=island.SeedCounter:FindFirstChild("ShopPrompt")
   if counter then counter.Enabled=island:GetAttribute("OwnerUserId")==player.UserId end
   local gate=island:FindFirstChild("ReturnGateway");if gate then Scenery.Gateway(Art,gate) end
   for i=1,4 do
    local plot=island:FindFirstChild("Plot"..i);if not plot then continue end
    local id=plot:GetAttribute("Crop");local config=Farm.Crops[id]
    local seconds=math.max(0,(plot:GetAttribute("ReadyAt") or 0)-os.time())
    local stage=config and (seconds==0 and 3 or seconds<config.Seconds*.5 and 2 or 1) or 0
    local key=tostring(id)..":"..stage
    if plot:GetAttribute("LocalAppearance")~=key then
     local old=plot:FindFirstChild("CropVisuals");if old then old:Destroy() end
     if config then
      local visual=crops[id][stage]:Clone();visual.Name="CropVisuals";visual.Parent=plot
      visual:PivotTo(CFrame.new(plot.Position+Vector3.new(0,.3,0)))
     end
     plot:SetAttribute("LocalAppearance",key)
    end
   end
  end
 end
 local publicGate=workspace.WorldFoundation:FindFirstChild("HomeGateway")
 if publicGate then Scenery.Gateway(Art,publicGate) end
end
player:SetAttribute("W4CropsStatus","Ready")
while script.Parent do
 local success,message=pcall(update)
 if not success then warn("W4 farm presentation: "..tostring(message));player:SetAttribute("W4CropsStatus",tostring(message));break end
 task.wait(.75)
end
