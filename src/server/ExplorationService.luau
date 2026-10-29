local Food = require(script.Parent.FoodService)
local Service = {}
function Service.Start()
	local model = Instance.new("Model")
	model.Name = "ElementGrove"
	local function part(name,size,pos,color)
		local p=Instance.new("Part")
		p.Name,p.Size,p.Position,p.Color=name,size,pos,color
		p.Anchored,p.TopSurface,p.BottomSurface=true,Enum.SurfaceType.Smooth,Enum.SurfaceType.Smooth
		p.Parent=model
		return p
	end
	local Map=require(game.ReplicatedStorage.Shared.WorldConfig)
	local surface=require(script.Parent.WorldService).SurfaceAt(Map.GroveBloom.X,Map.GroveBloom.Z)
	local shrine=part("GroveBloom",Vector3.new(3,3,3),Vector3.new(Map.GroveBloom.X,surface+1.5,Map.GroveBloom.Z),Color3.fromRGB(177,142,226))
	shrine.Transparency=1;shrine.CanCollide=false
	local prompt=Instance.new("ProximityPrompt")
	prompt.ObjectText,prompt.ActionText="Element Grove • evolve to claim","Gather 2 berries"
	prompt.MaxActivationDistance,prompt.HoldDuration,prompt.RequiresLineOfSight=10,0.3,false
	prompt.Parent=shrine
	local cooldown={}
	prompt.Triggered:Connect(function(player)
		local snapshot=require(script.Parent.MonsterService).GetSnapshot(player)
		local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		local feedback=game.ReplicatedStorage.Remotes.CollectFeedback
		if not snapshot or not snapshot.Path then feedback:FireClient(player,false,"Reach 100 growth and choose an element first"); return end
		if not root or not hum or hum.Health<=0 or (root.Position-shrine.Position).Magnitude>12 then return end
		if (cooldown[player] or 0)>os.clock() then feedback:FireClient(player,false,"Grove bloom regrows every 60 seconds"); return end
		if not Food.TryGrant(player,"Berry",2) then feedback:FireClient(player,false,"Make room for 2 berries"); return end
		cooldown[player]=os.clock()+60
		require(script.Parent.QuestService).Record(player,"Grove")
		feedback:FireClient(player,false,"Element Grove: +2 berries! Returns in 60 seconds.")
	end)
	game.Players.PlayerRemoving:Connect(function(p) cooldown[p]=nil end)
	model.Parent=workspace
end
return Service
