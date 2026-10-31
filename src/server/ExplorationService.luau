local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Food=require(script.Parent.FoodService)
local Service={}
local shrine
local pending,cooldowns={},{}
local function message(player,text)
 if player.Parent then RS.Remotes.CompanionFeedback:FireClient(player,false,text) end
end
function Service.Cancel(player)
 pending[player]=nil
 local companion=workspace:FindFirstChild("Companion_"..player.UserId)
 if companion then companion:SetAttribute("InteractionGoal",nil) end
 player:SetAttribute("GroveActivity","")
end
local function context(player)
 local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
 local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
 local model=workspace:FindFirstChild("Companion_"..player.UserId)
 local snapshot=require(script.Parent.MonsterService).GetSnapshot(player)
 return root,hum,model,snapshot
end
function Service.Interact(player)
 local root,hum,model,snapshot=context(player)
 if not shrine or not root or not hum or hum.Health<=0 or not model then return false,"Bring Sprout to Element Grove" end
 if not snapshot or not snapshot.Path then return false,"Reach 100 growth and choose an element first" end
 if not require(script.Parent.FarmService).CanChange(player) then return false,"Progress is unavailable while your data reconnects" end
 if (root.Position-shrine.Position).Magnitude>18 then return false,"Find the luminous bloom in Element Grove" end
 if (model.Body.Position-shrine.Position).Magnitude>30 then return false,"Call Sprout closer to the bloom first" end
 if pending[player] then return false,"Sprout is already working with the bloom" end
 if (cooldowns[player] or 0)>os.clock() then return false,"The Grove bloom regrows every 60 seconds" end
 if (model:GetAttribute("HoldUntil") or 0)>os.clock() then return false,"Give Sprout a moment" end
 if (player:GetAttribute("FoodCount") or 0)>48 then return false,"Make room for 2 berries first" end
 local request={Path=snapshot.Path};pending[player]=request
 model:SetAttribute("CommandMode","Follow");player:SetAttribute("CompanionMode","Follow")
 model:SetAttribute("InteractionGoal",shrine.Position)
 player:SetAttribute("GroveActivity","Approaching")
 task.spawn(function()
  local deadline=os.clock()+10
  local ready=false
  while pending[player]==request and os.clock()<deadline do
   local r,h,m,s=context(player)
   if not r or not h or h.Health<=0 or m~=model or not s or s.Path~=request.Path or (r.Position-shrine.Position).Magnitude>22 then break end
   if (model.Body.Position-shrine.Position).Magnitude<6.5 then ready=true;break end
   task.wait(.1)
  end
  if pending[player]~=request then return end
  model:SetAttribute("InteractionGoal",nil)
  if not ready then Service.Cancel(player);message(player,"Stay near the bloom and give Sprout a clear route");return end
  local pos=model.Body.Position;local focus=Vector3.new(shrine.Position.X,pos.Y,shrine.Position.Z)
  if (focus-pos).Magnitude>.01 then model:PivotTo(CFrame.lookAt(pos,focus)) end
  if not require(script.Parent.MonsterService).BeginAction(player,"Ability"..request.Path,2.3,shrine.Position+Vector3.yAxis*1.5) then
   Service.Cancel(player);message(player,"Sprout is busy. Try the bloom again");return
  end
  player:SetAttribute("GroveActivity","Channeling")
  task.wait(2.3)
  if pending[player]~=request then return end
  local r,h,m,s=context(player)
  Service.Cancel(player)
  if not r or not h or h.Health<=0 or m~=model or not s or s.Path~=request.Path or (r.Position-shrine.Position).Magnitude>22 or (model.Body.Position-shrine.Position).Magnitude>8 then
   message(player,"The channel was interrupted. Stay with Sprout near the bloom");return
  end
  if not require(script.Parent.FarmService).CanChange(player) or not Food.TryGrant(player,"Berry",2) then message(player,"Make room for 2 berries and try again");return end
  cooldowns[player]=os.clock()+60
  require(script.Parent.QuestService).Record(player,"Grove")
  RS.Remotes.CompanionFeedback:FireClient(player,true,"Sprout awakened the bloom! +2 berries · regrows in 60 seconds")
 end)
 return true,"Sprout is approaching the bloom. Stay nearby!"
end
function Service.Start()
 local Map=require(RS.Shared.WorldConfig)
 local ground=require(script.Parent.WorldService).SurfaceAt(Map.GroveBloom.X,Map.GroveBloom.Z)
 local model=Instance.new("Model");model.Name="ElementGrove"
 shrine=Instance.new("Part");shrine.Name="GroveBloom";shrine.Size=Vector3.new(3,3,3)
 shrine.Position=Vector3.new(Map.GroveBloom.X,ground+1.5,Map.GroveBloom.Z)
 shrine.Anchored=true;shrine.Transparency=1;shrine.CanCollide=false;shrine.CanQuery=false;shrine.Parent=model
 local prompt=Instance.new("ProximityPrompt");prompt.Name="AwakenBloom"
 prompt.ObjectText="Element Grove · luminous bloom";prompt.ActionText="Ask Sprout to awaken"
 prompt.MaxActivationDistance=10;prompt.HoldDuration=.4;prompt.RequiresLineOfSight=false;prompt.Parent=shrine
 prompt.Triggered:Connect(function(player)
  local ok,text=Service.Interact(player);RS.Remotes.CompanionFeedback:FireClient(player,ok,text)
 end)
 model.Parent=workspace
 Players.PlayerRemoving:Connect(function(player) Service.Cancel(player);cooldowns[player]=nil end)
end
return Service
