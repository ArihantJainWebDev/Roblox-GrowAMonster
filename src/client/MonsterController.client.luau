local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(shared:WaitForChild("MonsterConfig"))
local Evolution = require(shared:WaitForChild("EvolutionConfig"))
local FoodConfig = require(shared:WaitForChild("FoodConfig"))
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local feedRequest = remotes:WaitForChild("FeedMonster")
local selected = FoodConfig.Order[1]
local gui = Instance.new("ScreenGui")
gui.Name = "MonsterHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")
local panel = Instance.new("Frame")
panel.Name = "CompanionPanel"
panel.Size = UDim2.fromOffset(300, 330)
panel.AnchorPoint = Vector2.new(0, 1)
panel.Position = UDim2.new(0, 12, 1, -12)
panel.BackgroundColor3 = Color3.fromRGB(38, 49, 58)
panel.BackgroundTransparency = 0.05
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)
local scale = Instance.new("UIScale", panel)
local function text(name, y, height, size)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Position = UDim2.fromOffset(12, y)
	label.Size = UDim2.new(1, -24, 0, height)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = size
	label.TextColor3 = Color3.fromRGB(224, 239, 228)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.Parent = panel
	return label
end
local title = text("Title", 8, 25, 19)
title.Font = Enum.Font.GothamBold
local progress = text("Progress", 36, 24, 14)
local basket = text("Basket", 62, 23, 13)
local feedback = text("Feedback", 280, 42, 13)
feedback.Text = "Find a fruit bush. Hold E or tap Collect."
local buttons = {}
local refresh
for index, id in FoodConfig.Order do
	local button = Instance.new("TextButton")
	button.Name = id
	button.Position = UDim2.fromOffset(12, 88 + (index - 1) * 44)
	button.Size = UDim2.new(1, -24, 0, 40)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Parent = panel
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
	button.Activated:Connect(function() selected = id; refresh() end)
	buttons[id] = button
end
local feedButton = Instance.new("TextButton")
feedButton.Name = "FeedButton"
feedButton.Size = UDim2.new(1, -24, 0, 46)
feedButton.Position = UDim2.fromOffset(12, 228)
feedButton.Font = Enum.Font.GothamBold
feedButton.TextSize = 16
feedButton.TextColor3 = Color3.fromRGB(25, 45, 30)
feedButton.Parent = panel
Instance.new("UICorner", feedButton).CornerRadius = UDim.new(0, 10)
refresh = function()
	gui.Enabled=player:GetAttribute("MonsterHatched")==true
	local xp = player:GetAttribute("MonsterXP") or 0
	local cap = player:GetAttribute("MonsterGrowthCap") or Evolution.AtXP
	local path = Evolution.Paths[player:GetAttribute("MonsterPath")]
	local stageName = "Baby Sprout"
	for _, stage in Config.GrowthStages do
		if stage.Id == player:GetAttribute("MonsterStage") then stageName = stage.Name end
	end
	title.Text = path and path.Name or stageName
	progress.Text = xp >= cap and (path and "Growth cap reached • Explore Element Grove" or "100 growth! Choose your element") or string.format("%s • %d/%d", path and "Grove unlocked" or "Next: Young Sprout", xp, cap)
	basket.Text = string.format("FOOD BASKET  %d/%d • Select food", player:GetAttribute("FoodCount") or 0, FoodConfig.Capacity)
	for id, button in buttons do
		local food = FoodConfig.Foods[id]
		button.Text = string.format("%s%s  ×%d  •  +%d XP", selected == id and "✓ " or "", food.Name, player:GetAttribute("Food_" .. id) or 0, food.XP)
		button.BackgroundColor3 = selected == id and Color3.fromRGB(61, 118, 87) or Color3.fromRGB(59, 70, 80)
	end
	local count = player:GetAttribute("Food_" .. selected) or 0
	local canFeed = count > 0 and xp < cap
	feedButton.Active, feedButton.AutoButtonColor = canFeed, canFeed
	feedButton.BackgroundColor3 = canFeed and Color3.fromRGB(112, 206, 125) or Color3.fromRGB(144, 159, 148)
	if xp >= cap then feedButton.Text = path and "Prototype growth cap reached" or "Choose evolution to keep growing"
	elseif count == 0 then feedButton.Text = "Collect " .. FoodConfig.Foods[selected].Name
	else feedButton.Text = "Feed " .. FoodConfig.Foods[selected].Name end
end
for _, attribute in { "MonsterXP", "MonsterStage", "MonsterPath", "MonsterGrowthCap", "MonsterHatched", "FoodCount" } do
	player:GetAttributeChangedSignal(attribute):Connect(refresh)
end
for _, id in FoodConfig.Order do player:GetAttributeChangedSignal("Food_" .. id):Connect(refresh) end
feedButton.Activated:Connect(function()
	if (player:GetAttribute("Food_" .. selected) or 0) > 0 and (player:GetAttribute("MonsterXP") or 0) < (player:GetAttribute("MonsterGrowthCap") or Evolution.AtXP) then
		feedRequest:FireServer(selected)
	end
end)
local feedbackVersion = 0
local function showFeedback(message)
	feedbackVersion += 1
	local version = feedbackVersion
	feedback.Text = message
	task.delay(4, function()
		if feedbackVersion == version and feedback.Parent then
			feedback.Text = "Fruit regrows for you. Others get their own harvest."
		end
	end)
end
remotes:WaitForChild("FeedFeedback").OnClientEvent:Connect(function(accepted, amount)
	if accepted then showFeedback(string.format("Sprout is happy! +%d growth", amount))
	elseif (player:GetAttribute("MonsterXP") or 0) >= (player:GetAttribute("MonsterGrowthCap") or Evolution.AtXP) then showFeedback("Choose your evolution at 100 growth, or explore if already evolved.")
	else showFeedback("You don't have that food. Try collecting some.") end
end)
remotes:WaitForChild("CollectFeedback").OnClientEvent:Connect(function(accepted, message)
	if accepted and FoodConfig.Foods[message] then
		if (player:GetAttribute("Food_" .. selected) or 0) == 0 then selected = message end
		showFeedback("+1 " .. FoodConfig.Foods[message].Name .. " added to your basket!")
		refresh()
	else showFeedback(message) end
end)
refresh()
local function resize()
	local camera = workspace.CurrentCamera
	if not camera then return end
	local size = camera.ViewportSize
	local touch = game:GetService("UserInputService").TouchEnabled
	local compact = size.X > size.Y and size.Y < 500
	panel.AnchorPoint = Vector2.new(0, (touch or compact) and 0 or 1)
	panel.Position = (touch or compact) and UDim2.fromOffset(12, 12) or UDim2.new(0, 12, 1, -12)
	if compact then
		local width = math.min(570, gui.AbsoluteSize.X - 24)
		panel.Size = UDim2.fromOffset(width, 210)
		scale.Scale = 1
		for index, id in FoodConfig.Order do
			buttons[id].Position = UDim2.fromOffset(12 + (index - 1) * (width - 24) / 3, 88)
			buttons[id].Size = UDim2.fromOffset((width - 24) / 3 - 4, 44)
			buttons[id].TextWrapped = true
			buttons[id].TextSize = 12
		end
		feedButton.Position = UDim2.fromOffset(12, 134)
		feedback.Position = UDim2.fromOffset(12, 184)
		feedback.Size = UDim2.new(1, -24, 0, 22)
		feedback.TextSize = 12
	else
		panel.Size = UDim2.fromOffset(300, 330)
		scale.Scale = math.min(1, (gui.AbsoluteSize.X - 24) / 300)
		for index, id in FoodConfig.Order do
			buttons[id].Position = UDim2.fromOffset(12, 88 + (index - 1) * 46)
			buttons[id].Size = UDim2.new(1, -24, 0, 44)
			buttons[id].TextWrapped = false
			buttons[id].TextSize = 14
		end
		feedButton.Position = UDim2.fromOffset(12, 228)
		feedback.Position = UDim2.fromOffset(12, 280)
		feedback.Size = UDim2.new(1, -24, 0, 42)
		feedback.TextSize = 13
	end
end
if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end
gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize)
resize()
