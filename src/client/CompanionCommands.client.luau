local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Input=game:GetService("UserInputService")
local player=Players.LocalPlayer
local remote=RS:WaitForChild("Remotes"):WaitForChild("CompanionCommand")
local feedback=RS.Remotes:WaitForChild("CompanionFeedback")
local gui=Instance.new("ScreenGui");gui.Name="CompanionCommands";gui.ResetOnSpawn=false;gui.DisplayOrder=12;gui.Parent=player.PlayerGui
local panel=Instance.new("Frame");panel.Name="Menu";panel.AnchorPoint=Vector2.new(.5,.5);panel.Position=UDim2.fromScale(.5,.63)
panel.Size=UDim2.fromOffset(310,232);panel.BackgroundColor3=Color3.fromRGB(31,48,45);panel.Visible=false;panel.Parent=gui
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,14)
local scale=Instance.new("UIScale");scale.Parent=panel
local function label(y,height,text)
 local l=Instance.new("TextLabel");l.BackgroundTransparency=1;l.Position=UDim2.fromOffset(14,y);l.Size=UDim2.new(1,-28,0,height)
 l.Text=text;l.Font=Enum.Font.Gotham;l.TextSize=13;l.TextColor3=Color3.fromRGB(228,240,220);l.TextWrapped=true;l.Parent=panel;return l
end
local title=label(9,25,"SPROUT • COMPANION");title.Font=Enum.Font.GothamBold
local status=label(182,39,"Stay nearby, give a command, or pet your companion.")
local buttons={}
for i,command in {"Follow","Stay","Come","Pet"} do
 local b=Instance.new("TextButton");b.Name=command;b.Size=UDim2.fromOffset(132,39)
 b.Position=UDim2.fromOffset(16+((i-1)%2)*146,43+math.floor((i-1)/2)*46)
 b.Text=command=="Come" and "Come here" or command;b.Font=Enum.Font.GothamBold;b.TextSize=14
 b.TextColor3=Color3.fromRGB(235,242,228);b.BackgroundColor3=Color3.fromRGB(65,101,76);b.Parent=panel
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
 b.Activated:Connect(function() remote:FireServer(command) end);buttons[command]=b
end
local interact=Instance.new("TextButton");interact.Name="Interact";interact.Position=UDim2.fromOffset(16,137);interact.Size=UDim2.fromOffset(278,37)
interact.Text="Use nearby landmark";interact.TextSize=14;interact.Font=Enum.Font.GothamBold;interact.BackgroundColor3=Color3.fromRGB(78,91,111);interact.TextColor3=Color3.fromRGB(235,242,228);interact.Parent=panel
Instance.new("UICorner",interact).CornerRadius=UDim.new(0,8)
interact.Activated:Connect(function() remote:FireServer("Interact") end)
local close=Instance.new("TextButton");close.Name="Close";close.Size=UDim2.fromOffset(26,26);close.Position=UDim2.new(1,-31,0,6)
close.Text="×";close.TextSize=22;close.BackgroundTransparency=1;close.TextColor3=Color3.new(1,1,1);close.Parent=panel
close.Activated:Connect(function() panel.Visible=false end)
local recall=Instance.new("TextButton");recall.Name="Recall";recall.AnchorPoint=Vector2.new(1,0);recall.Position=UDim2.new(1,-14,0,150)
recall.Size=UDim2.fromOffset(155,40);recall.Text="Call Sprout · R";recall.Font=Enum.Font.GothamBold;recall.TextSize=13
recall.BackgroundColor3=Color3.fromRGB(51,86,64);recall.TextColor3=Color3.fromRGB(238,241,222);recall.Visible=false;recall.Parent=gui
Instance.new("UICorner",recall).CornerRadius=UDim.new(0,10)
recall.Activated:Connect(function() remote:FireServer("Come") end)
local toast=Instance.new("TextLabel");toast.AnchorPoint=Vector2.new(.5,1);toast.Position=UDim2.new(.5,0,1,-24)
toast.Size=UDim2.new(.7,0,0,42);toast.BackgroundColor3=Color3.fromRGB(31,48,45);toast.BackgroundTransparency=.1
toast.TextColor3=Color3.fromRGB(234,242,222);toast.TextSize=14;toast.Font=Enum.Font.Gotham;toast.TextWrapped=true;toast.Visible=false;toast.Parent=gui
Instance.new("UICorner",toast).CornerRadius=UDim.new(0,10)
local version=0
feedback.OnClientEvent:Connect(function(ok,message)
 status.Text=message;version+=1;local mine=version
 toast.Text=message;toast.Visible=true;if ok then panel.Visible=false end
 task.delay(3,function() if mine==version then toast.Visible=false end end)
end)
local function attach(anchor)
 if not anchor:IsA("Model") or anchor.Name~="Companion_"..player.UserId then return end
 local body=anchor:WaitForChild("Body",10);if not body then return end
 local point=Instance.new("Attachment");point.Position=Vector3.new(0,1.7,0);point.Parent=body
 local prompt=Instance.new("ProximityPrompt");prompt.Name="CompanionControls";prompt.ActionText="Commands / Pet";prompt.ObjectText="Sprout"
 prompt.KeyboardKeyCode=Enum.KeyCode.F;prompt.GamepadKeyCode=Enum.KeyCode.ButtonY;prompt.MaxActivationDistance=12;prompt.RequiresLineOfSight=false;prompt.Parent=point
 prompt.Triggered:Connect(function() panel.Visible=not panel.Visible end)
end
for _,anchor in workspace:GetChildren() do task.spawn(attach,anchor) end
workspace.ChildAdded:Connect(function(anchor) task.spawn(attach,anchor) end)
Input.InputBegan:Connect(function(key,processed)
 if processed or Input:GetFocusedTextBox() then return end
 if (key.KeyCode==Enum.KeyCode.R or key.KeyCode==Enum.KeyCode.DPadDown) and player:GetAttribute("MonsterHatched") then remote:FireServer("Come") end
end)
local function refresh()
 recall.Visible=player:GetAttribute("MonsterHatched")==true and player:GetAttribute("CompanionMode")=="Stay"
 local camera=workspace.CurrentCamera
 if camera then scale.Scale=math.min(1,(camera.ViewportSize.X-24)/310,(camera.ViewportSize.Y-50)/232) end
end
player:GetAttributeChangedSignal("CompanionMode"):Connect(refresh)
player:GetAttributeChangedSignal("MonsterHatched"):Connect(refresh)
gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(refresh)
refresh()
