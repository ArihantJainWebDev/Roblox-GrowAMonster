local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("FoodConfig"))
local folder = workspace:WaitForChild("FoodNodes")
-- Only presentation is local. The server independently checks every claim.
while folder.Parent do
	local now = workspace:GetServerTimeNow()
	for _, node in folder:GetChildren() do
		local fruit = node:FindFirstChild("Fruit")
		local prompt = fruit and fruit:FindFirstChild("Collect")
		local label = node:FindFirstChild("Label")
		local food = Config.Foods[node:GetAttribute("FoodId")]
		if fruit and prompt and label and label:FindFirstChild("Text") and food then
			local seconds = math.max(0, math.ceil((player:GetAttribute("NodeReady_" .. node.Name) or 0) - now))
			prompt.Enabled = seconds == 0
			fruit.LocalTransparencyModifier = seconds > 0 and 1 or 0
			local stem = node:FindFirstChild("Stem")
			if stem then stem.LocalTransparencyModifier = fruit.LocalTransparencyModifier end
			label.Text.Text = seconds > 0 and string.format("%s\nRegrows in %ds", food.Name, seconds) or food.Name .. "\n" .. food.Rarity
		end
	end
	task.wait(0.25)
end
