local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Config = require(RS.Shared:WaitForChild("FarmConfig"))
local Foods = require(RS.Shared:WaitForChild("FoodConfig"))
local gui = Instance.new("ScreenGui")
gui.Name, gui.ResetOnSpawn, gui.Parent = "FarmHUD", false, player:WaitForChild("PlayerGui")
local panel = Instance.new("Frame")
panel.Name, panel.Size, panel.Position = "SeedPanel", UDim2.fromOffset(250,190), UDim2.new(1,-262,0,12)
panel.BackgroundColor3, panel.Parent = Color3.fromRGB(38,49,58), gui
Instance.new("UICorner",panel).CornerRadius = UDim.new(0,12)
local function label(y, height)
	local t = Instance.new("TextLabel")
	t.Size, t.Position = UDim2.new(1,-16,0,height), UDim2.fromOffset(8,y)
	t.BackgroundTransparency, t.TextColor3, t.TextSize, t.TextWrapped = 1, Color3.new(1,1,1), 13, true
	t.Parent = panel
	return t
end
local status, message = label(4,38), label(140,46)
message.Text = "Choose a seed, then use one of your four plots."
local buttons = {}
for i,id in Config.Order do
	local button = Instance.new("TextButton")
	button.Size, button.Position = UDim2.fromOffset(164,44), UDim2.fromOffset(8,42+(i-1)*48)
	button.TextSize, button.Parent = 13,panel
	button.Activated:Connect(function() RS.Remotes.ChooseSeed:FireServer(id,false) end)
	buttons[id] = button
	local buy = Instance.new("TextButton")
	buy.Size, buy.Position = UDim2.fromOffset(62,44), UDim2.fromOffset(180,42+(i-1)*48)
	buy.Text, buy.TextSize, buy.Parent = "Buy " .. Config.Crops[id].Cost .. "c",12,panel
	buy.Activated:Connect(function() RS.Remotes.ChooseSeed:FireServer(id,true) end)
end
RS.Remotes:WaitForChild("FarmFeedback").OnClientEvent:Connect(function(_,text) message.Text=text end)
local function refresh()
	status.Text = string.format("FARM • %d coins\n%s", player:GetAttribute("FarmCoins") or 0,player:GetAttribute("FarmSaveStatus") or "Loading farm…")
	for id,button in buttons do
		button.Text = ((player:GetAttribute("SelectedSeed") or "Apple")==id and "✓ " or "") .. Config.Crops[id].Name .. " ×" .. (player:GetAttribute("Seed_"..id) or 0)
	end
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	local island = workspace:FindFirstChild("Island_"..player.UserId)
	panel.Visible = island ~= nil and root ~= nil and (root.Position-island.Grass.Position).Magnitude < 40
	if island then
		for i=1,4 do
			local plot = island:FindFirstChild("Plot"..i)
			if not plot then continue end
			local cropId = plot:GetAttribute("Crop")
			local crop = Config.Crops[cropId]
			local seconds = math.max(0,(plot:GetAttribute("ReadyAt") or 0)-os.time())
			local prompt = plot:FindFirstChildOfClass("ProximityPrompt")
			local visual = plot:FindFirstChild("LocalCrop")
			if crop and not visual then
				visual = Instance.new("Part")
				visual.Name, visual.Shape = "LocalCrop", Enum.PartType.Ball
				visual.Anchored, visual.CanCollide, visual.CanTouch = true, false, false
				visual.TopSurface, visual.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
				visual.Parent = plot
			end
			if visual then
				if crop then
					local growth = math.clamp(1-seconds/crop.Seconds,0,1)
					visual.Size = Vector3.one * (0.7+growth*2)
					visual.Position = plot.Position+Vector3.new(0,0.3+visual.Size.Y/2,0)
					visual.Color = seconds>0 and Color3.fromRGB(74,166,73) or Foods.Foods[cropId].Color
				else visual:Destroy() end
			end
			prompt.ObjectText = crop and (crop.Name .. (seconds>0 and " • "..seconds.."s" or " • Ready!")) or "Empty plot"
			prompt.ActionText = crop and "Harvest" or "Plant selected seed"
			plot.Color = crop and (seconds>0 and Color3.fromRGB(101,135,65) or Color3.fromRGB(213,180,64)) or Color3.fromRGB(104,69,43)
		end
	end
end
task.spawn(function() while gui.Parent do refresh(); task.wait(0.5) end end)
