local RS = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local remotes=RS:WaitForChild("Remotes")
local Config = require(RS.Shared:WaitForChild("EvolutionConfig"))
local remote = remotes:WaitForChild("EvolveMonster")
local gui = Instance.new("ScreenGui")
gui.Name, gui.ResetOnSpawn, gui.DisplayOrder = "EvolutionHUD", false, 10
gui.Parent = player:WaitForChild("PlayerGui")
local panel = Instance.new("Frame")
panel.AnchorPoint, panel.Position = Vector2.new(0.5,0.5), UDim2.fromScale(0.5,0.5)
panel.Size, panel.BackgroundColor3, panel.Parent = UDim2.fromOffset(340,350), Color3.fromRGB(38,49,58), gui
Instance.new("UICorner",panel).CornerRadius = UDim.new(0,14)
local scale = Instance.new("UIScale",panel)
local function label(y,h,text)
	local t = Instance.new("TextLabel")
	t.Position,t.Size = UDim2.fromOffset(12,y),UDim2.new(1,-24,0,h)
	t.BackgroundTransparency,t.TextColor3,t.TextSize,t.TextWrapped = 1,Color3.new(1,1,1),14,true
	t.Text,t.Parent = text,panel
	return t
end
label(8,30,"CHOOSE YOUR ELEMENT")
local description = label(42,62,"All paths grow equally. Pick a path, then confirm. This choice is permanent for this monster.")
local selected
local confirm = Instance.new("TextButton")
confirm.Position,confirm.Size = UDim2.fromOffset(12,270),UDim2.new(1,-24,0,44)
confirm.Text,confirm.Parent = "Select a path above",panel
confirm.TextSize, confirm.Font = 14, Enum.Font.GothamBold
for i,id in Config.Order do
	local path = Config.Paths[id]
	local b = Instance.new("TextButton")
	b.Name,b.Text,b.BackgroundColor3 = id,id .. " • " .. path.Name,path.Color
	b.TextSize,b.Font = 14,Enum.Font.GothamBold
	b.Position,b.Size,b.Parent = UDim2.fromOffset(12,112+(i-1)*50),UDim2.new(1,-24,0,44),panel
	b.Activated:Connect(function()
		selected=id
		description.Text=path.Description
		confirm.Text="Confirm "..id
	end)
end
confirm.Activated:Connect(function() if selected then remote:FireServer(selected) end end)
local status=label(316,28,"Your next adventure: Element Grove")
remotes:WaitForChild("EvolutionFeedback").OnClientEvent:Connect(function(_,message) status.Text=message end)
local function refresh()
	panel.Visible=(player:GetAttribute("MonsterXP") or 0)>=Config.AtXP and (player:GetAttribute("MonsterPath") or "")=="" and (player:GetAttribute("CompanionAction") or "")~="Grow"
	scale.Scale=math.min(1,(gui.AbsoluteSize.X-24)/340,(gui.AbsoluteSize.Y-24)/350)
end
player.AttributeChanged:Connect(refresh)
gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(refresh)
refresh()
