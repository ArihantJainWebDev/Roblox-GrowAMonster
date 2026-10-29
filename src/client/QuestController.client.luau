local player=game.Players.LocalPlayer
local Config=require(game.ReplicatedStorage.Shared:WaitForChild("QuestConfig"))
local gui=Instance.new("ScreenGui")
gui.Name,gui.ResetOnSpawn,gui.DisplayOrder="QuestHUD",false,5
gui.Parent=player:WaitForChild("PlayerGui")
local panel=Instance.new("Frame")
panel.AnchorPoint,panel.Position=Vector2.new(0.5,0),UDim2.new(0.5,0,0,12)
panel.Size,panel.BackgroundColor3,panel.Parent=UDim2.fromOffset(340,160),Color3.fromRGB(38,49,58),gui
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,12)
local toggle=Instance.new("TextButton")
toggle.Name,toggle.Size,toggle.BackgroundTransparency="ToggleGuide",UDim2.new(1,0,0,44),1
toggle.Font,toggle.TextSize,toggle.TextColor3,toggle.Parent=Enum.Font.GothamBold,14,Color3.new(1,1,1),panel
local hint=Instance.new("TextLabel")
hint.Position,hint.Size,hint.BackgroundTransparency=UDim2.fromOffset(12,44),UDim2.new(1,-24,0,76),1
hint.Font,hint.TextSize,hint.TextColor3,hint.TextWrapped,hint.Parent=Enum.Font.Gotham,14,Color3.fromRGB(231,239,229),true,panel
local distance=hint:Clone()
distance.Name,distance.Position,distance.Size,distance.Parent="TargetDistance",UDim2.fromOffset(12,120),UDim2.new(1,-24,0,32),panel
local marker=Instance.new("BillboardGui")
marker.Name,marker.Size,marker.StudsOffset,marker.AlwaysOnTop="QuestTarget",UDim2.fromOffset(160,44),Vector3.new(0,5,0),true
marker.ResetOnSpawn=false
marker.Parent=player.PlayerGui
local caption=Instance.new("TextLabel")
caption.Size,caption.BackgroundTransparency,caption.TextColor3=UDim2.fromScale(1,1),1,Color3.fromRGB(255,229,114)
caption.Font,caption.TextSize,caption.TextStrokeTransparency,caption.TextWrapped=Enum.Font.GothamBold,16,0.3,true
caption.Parent=marker
local expanded=true
local userToggled=false
toggle.Activated:Connect(function() expanded=not expanded;userToggled=true end)
local function targetFor(id)
	local island=workspace:FindFirstChild("Island_"..player.UserId)
	if id=="Hatch" then return island and island:FindFirstChild("WelcomeEgg") end
	if id=="Plant" or id=="Harvest" then
		if not island then return end
		for i=1,4 do
			local plot=island:FindFirstChild("Plot"..i)
			if plot and ((id=="Plant" and (plot:GetAttribute("Crop") or "")=="") or (id=="Harvest" and (plot:GetAttribute("Crop") or "")~="")) then return plot end
		end
		return island:FindFirstChild("Plot1")
	end
	if id=="Home" then return island and island:FindFirstChild("HomeSpawn") end
	if id=="Grove" then return workspace:FindFirstChild("ElementGrove") and workspace.ElementGrove:FindFirstChild("GroveBloom") end
	if id=="Gather" or id=="Evolve" then
		local nodes=workspace:FindFirstChild("FoodNodes")
		local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		local best,score=nil,math.huge
		if nodes and root then
			for _,node in nodes:GetChildren() do
				if node:GetAttribute("RequiresEvolution") or (player:GetAttribute("NodeReady_"..node.Name) or 0)>workspace:GetServerTimeNow() then continue end
				local d=(root.Position-node.Fruit.Position).Magnitude
				if d<score then best,score=node.Fruit,d end
			end
		end
		return best
	end
end
task.spawn(function()
	while gui.Parent do
		local step=player:GetAttribute("QuestStep")
		if player:GetAttribute("QuestComplete")==true or (step and step>#Config) then
			marker:Destroy()
			gui:Destroy()
			break
		end
		if gui.AbsoluteSize.X<1 then task.wait(0.1);continue end
		local narrow=gui.AbsoluteSize.X<1000
		if not userToggled then expanded=not narrow end
		panel.Size=UDim2.fromOffset(math.min(340,gui.AbsoluteSize.X-24),expanded and 160 or 44)
		hint.Visible,distance.Visible=expanded,expanded
		local quest=step and Config[step]
		toggle.Text=quest and string.format("%d/%d • %s %s",step,#Config,quest.Title,expanded and "−" or "+") or (step and "Starter journey complete • Free play" or "Loading your journey…")
		hint.Text=quest and quest.Hint or "Keep gathering, farming and raising your monster. You can hide this guide without losing progress."
		local target=quest and targetFor(quest.Id)
		marker.Adornee,marker.Enabled=target,target~=nil
		caption.Text=quest and quest.Title or ""
		local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		distance.Text=quest and ("Reward: "..quest.Reward.." coins"..(target and root and " • "..math.floor((root.Position-target.Position).Magnitude).." studs" or "")) or "Tap the heading to hide/show the guide."
		task.wait(0.25)
	end
end)
