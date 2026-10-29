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
	part("Ground",Vector3.new(64,4,64),Vector3.new(0,64,-100),Color3.fromRGB(95,157,131))
	part("Bridge",Vector3.new(8,1,32),Vector3.new(0,65.5,-52),Color3.fromRGB(168,130,86))
	local shrine=part("GroveBloom",Vector3.new(4,5,4),Vector3.new(0,68.5,-100),Color3.fromRGB(177,142,226))
	local function sign(adornee,text)
		local gui=Instance.new("BillboardGui")
		gui.Size,gui.StudsOffset,gui.MaxDistance,gui.AlwaysOnTop=UDim2.fromOffset(240,70),Vector3.new(0,5,0),100,true
		gui.Adornee,gui.Parent=adornee,adornee
		local label=Instance.new("TextLabel")
		label.Size,label.BackgroundTransparency,label.Text=UDim2.fromScale(1,1),0.2,text
		label.BackgroundColor3,label.TextColor3=Color3.fromRGB(38,49,58),Color3.new(1,1,1)
		label.TextSize,label.Font,label.TextWrapped,label.Parent=16,Enum.Font.GothamBold,true,gui
	end
	local entrance=part("GroveSign",Vector3.new(1,4,1),Vector3.new(6,68,-30),Color3.fromRGB(168,130,86))
	sign(entrance,"ELEMENT GROVE →\n100 growth + choose any element")
	sign(shrine,"GROVE BLOOM\nEvolved paths: 2 berries • 60s regrowth")
	local crystals=part("CrystalLookout",Vector3.new(5,8,5),Vector3.new(22,70,-116),Color3.fromRGB(150,125,236))
	crystals.Material=Enum.Material.Glass
	sign(crystals,"CRYSTAL LOOKOUT\nExplore the grove's fruit patches")
	local tree=part("BloomTree",Vector3.new(8,7,8),Vector3.new(19,73,-106),Color3.fromRGB(114,190,130))
	tree.Shape=Enum.PartType.Ball
	part("BloomTrunk",Vector3.new(2,6,2),Vector3.new(19,69,-106),Color3.fromRGB(139,100,67))
	part("EmberStone",Vector3.new(5,3,5),Vector3.new(-22,67.5,-100),Color3.fromRGB(227,130,74))
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
