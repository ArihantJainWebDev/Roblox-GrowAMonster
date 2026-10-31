-- Creature-only editor display. Does not start world/player services or publish.
assert(not game:GetService("RunService"):IsRunning(),"Stop Play before rebuilding the evolution display")
local source=game.StarterPlayer.StarterPlayerScripts.GameClient.creatures
local old=workspace:FindFirstChild("EditorEvolutionPreview");if old then old:Destroy() end
local cached=game.ServerStorage:FindFirstChild("EvolutionPreviewBuilders");if cached then cached:Destroy() end
local folder=Instance.new("Folder");folder.Name="EvolutionPreviewBuilders";folder.Parent=game.ServerStorage
local geometry=game.ReplicatedStorage.ArtReview.Geometry:Clone();geometry.Parent=folder
for _,name in {"BabyRig","ElementForms"} do
 local copy=source[name]:Clone()
 copy.Source=copy.Source:gsub("RS%.ArtReview%.Geometry","script.Parent.Geometry"):gsub("game%.ReplicatedStorage%.ArtReview%.Geometry","script.Parent.Geometry")
 copy.Parent=folder
end
local young=require(folder.BabyRig).Build("Young")
local group=Instance.new("Model");group.Name="EditorEvolutionPreview";group:SetAttribute("EditorPreview",true);group.Parent=workspace
local plinth=Instance.new("Part");plinth.Name="ReviewPlinth";plinth.Anchored=true
plinth.Size=Vector3.new(15,.6,5);plinth.Position=Vector3.new(0,423.65,-24)
plinth.Color=Color3.fromRGB(83,87,85);plinth.Material=Enum.Material.Slate;plinth.Parent=group
local out={}
for i,path in {"Fire","Crystal","Nature"} do
 local model=require(folder.ElementForms).Build(young,path);model.Name=path
 model:PivotTo(CFrame.new((i-2)*4,423.95,-24));model.Parent=group
 out[path]=model:GetAttribute("Element");task.wait()
end
young:Destroy()
return out
