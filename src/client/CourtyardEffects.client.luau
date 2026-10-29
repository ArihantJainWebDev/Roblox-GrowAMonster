-- Reconstruct the authored hub courtyard and its local water effects.
local RunService=game:GetService("RunService")
local world=workspace:WaitForChild("WorldFoundation",90)
if not world then return end
local Map=require(game.ReplicatedStorage.Shared.WorldConfig)
local player=game.Players.LocalPlayer
local artFolder=game.ReplicatedStorage:WaitForChild("ArtReview")
local ok,result=pcall(function()
	local art=require(artFolder:WaitForChild("Geometry"))
	local courtyard=require(artFolder:WaitForChild("Courtyard"))
	return courtyard.Build(art,{RuntimePreview=true,Integrated=true,Origin=Map.Hub})
end)
if not ok then
	player:SetAttribute("CourtyardPreviewStatus","Build failed: "..tostring(result))
	local partial=workspace:FindFirstChild("FountainHubVisuals")
	if partial then partial:Destroy() end
	warn("Courtyard preview could not create its mesh content: "..tostring(result))
	return
end
-- Terrain and server interactions remain authoritative.
local root=result
player:SetAttribute("CourtyardPreviewStatus","Ready")
local rings={}
for _,part in root:GetChildren() do
	if part:IsA("MeshPart") and part:GetAttribute("RipplePhase") then table.insert(rings,part) end
end
local sound=root:WaitForChild("WaterEffectAnchor"):WaitForChild("FountainWaterLoop")
sound:Play()
local elapsed=0
local connection
connection=RunService.RenderStepped:Connect(function(dt)
	if not root.Parent then sound:Stop();connection:Disconnect();return end
	elapsed+=dt
	for _,ring in rings do
		local t=(elapsed*.65+ring:GetAttribute("RipplePhase"))%1
		local size=ring:GetAttribute("OriginalSize")
		ring.Size=Vector3.new(size.X*(.5+t*3.8),math.max(size.Y,.005),size.Z*(.5+t*3.8))
		ring.Transparency=.35+.65*t
	end
	root:SetAttribute("EffectsElapsed",elapsed)
end)
