-- Run in Studio Edit mode after syncing sources. This refreshes generated scenery,
-- without starting player services or publishing. Sources remain authoritative.
assert(not game:GetService("RunService"):IsRunning(),"Stop Play before refreshing the editor preview")
local RS=game:GetService("ReplicatedStorage")
local scratch=Instance.new("Folder");scratch.Name="WorldPreviewBuild";scratch.Parent=game.ServerStorage
local function fresh(original,name)
 local copy=original:Clone();copy.Name=name or original.Name;copy.Parent=scratch;return copy
end
local ok,result=pcall(function()
 local config=fresh(RS.Shared.WorldConfig,"Map")
 local builder=fresh(game.ServerScriptService.GameServer.WorldService,"WorldService")
 builder.Source=builder.Source:gsub("game%.ReplicatedStorage%.Shared%.WorldConfig","script.Parent.Map")
 local map=require(config)
 require(builder).Start()
 local geometry=fresh(RS.ArtReview.Geometry,"Geometry")
 fresh(RS.ArtReview.CourtyardDetails,"CourtyardDetails")
 local courtyard=fresh(RS.ArtReview.Courtyard,"Courtyard")
 local old=workspace:FindFirstChild("EditorCourtyardPreview");if old then old:Destroy() end
 local root=require(courtyard).Build(require(geometry),{Integrated=true,Origin=map.Hub})
 root.Name="EditorCourtyardPreview"
 root:SetAttribute("EditorPreview",true)
 workspace.WorldFoundation:SetAttribute("EditorPreviewVersion",map.Version)
 return {TerrainVersion=map.Version,CourtyardBuild=root:GetAttribute("CourtyardBuild")}
end)
scratch:Destroy()
assert(ok,result)
return result
