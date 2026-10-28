local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("MonsterConfig"))
local feedRequest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FeedMonster")
local feedFeedback = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FeedFeedback")
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.Name = "MonsterHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Name = "CompanionPanel"
panel.Size = UDim2.fromOffset(270, 160)
panel.Position = UDim2.new(0, 20, 1, -180)
panel.BackgroundColor3 = Color3.fromRGB(38, 49, 58)
panel.BackgroundTransparency = 0.08
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -20, 0, 32)
title.Position = UDim2.fromOffset(10, 8)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local progress = Instance.new("TextLabel")
progress.Name = "Progress"
progress.Size = UDim2.new(1, -20, 0, 26)
progress.Position = UDim2.fromOffset(10, 42)
progress.BackgroundTransparency = 1
progress.Font = Enum.Font.Gotham
progress.TextColor3 = Color3.fromRGB(205, 225, 210)
progress.TextSize = 15
progress.TextXAlignment = Enum.TextXAlignment.Left
progress.Parent = panel

local button = Instance.new("TextButton")
button.Name = "FeedButton"
button.Size = UDim2.new(1, -20, 0, 48)
button.Position = UDim2.fromOffset(10, 98)
button.BackgroundColor3 = Color3.fromRGB(100, 194, 112)
button.TextColor3 = Color3.fromRGB(25, 45, 30)
button.Font = Enum.Font.GothamBold
button.TextSize = 17
button.Parent = panel
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

local feedback = Instance.new("TextLabel")
feedback.Name = "Feedback"
feedback.Size = UDim2.new(1, -20, 0, 22)
feedback.Position = UDim2.fromOffset(10, 72)
feedback.BackgroundTransparency = 1
feedback.Font = Enum.Font.GothamBold
feedback.TextColor3 = Color3.fromRGB(174, 255, 174)
feedback.TextSize = 14
feedback.TextXAlignment = Enum.TextXAlignment.Left
feedback.Text = ""
feedback.Parent = panel

local function refresh()
	local xp = player:GetAttribute("MonsterXP") or 0
	local food = player:GetAttribute("FoodCount") or 0
	local stageId = player:GetAttribute("MonsterStage") or "Baby"
	local stage = Config.GrowthStages[stageId == "Young" and 2 or 1]
	title.Text = player:GetAttribute("MonsterName") or "Your Monster"
	progress.Text = string.format("%s • Growth %d/%d", stage.Name, xp, Config.MaxXP)
	if xp >= Config.MaxXP then
		button.Text = "Growth milestone reached"
	elseif food > 0 then
		button.Text = string.format("Feed  •  %d fruit", food)
	else
		button.Text = "No fruit left"
	end
	button.Active = food > 0 and xp < Config.MaxXP
	button.AutoButtonColor = button.Active
end

for _, attribute in { "MonsterName", "MonsterXP", "MonsterStage", "FoodCount" } do
	player:GetAttributeChangedSignal(attribute):Connect(refresh)
end
button.Activated:Connect(function() feedRequest:FireServer() end)
feedFeedback.OnClientEvent:Connect(function(accepted: boolean, amount: number)
	if accepted then
		feedback.TextColor3 = Color3.fromRGB(174, 255, 174)
		feedback.Text = string.format("Sprout is happy! +%d growth", amount)
		local model = workspace:FindFirstChild("Companion_" .. player.UserId)
		local body = model and model:FindFirstChild("Body")
		if body and body:IsA("BasePart") then
			local original = body.Size
			local pop = TweenService:Create(body, TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = original * 1.08 })
			pop:Play()
			pop.Completed:Once(function()
				if body.Parent then TweenService:Create(body, TweenInfo.new(0.18), { Size = original }):Play() end
			end)
		end
	else
		feedback.TextColor3 = Color3.fromRGB(255, 211, 139)
		if (player:GetAttribute("MonsterXP") or 0) >= Config.MaxXP then
			feedback.Text = "Sprout reached this growth milestone!"
		else
			feedback.Text = "No fruit left—find something to feed Sprout."
		end
	end
	task.delay(2.2, function()
		if feedback.Parent then feedback.Text = "" end
	end)
end)
refresh()
