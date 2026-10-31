local Players=game:GetService("Players")
local Run=game:GetService("RunService")
local Debris=game:GetService("Debris")
local RS=game:GetService("ReplicatedStorage")
local Art=require(RS.ArtReview.Geometry)
local Scenery=require(RS.ArtReview.WorldScenery)
local Evolution=require(RS.Shared.EvolutionConfig)
local Effects={}
local root=Instance.new("Folder");root.Name="LocalCompanionEffects";root.Parent=workspace
local foodTemplates,active={},{}
local function color(anchor)
 local path=Evolution.Paths[anchor:GetAttribute("Path")]
 return path and path.Accent or Color3.fromRGB(164,227,148)
end
function Effects.Burst(anchor,amount)
 local part=Instance.new("Part");part.Name="Celebration";part.Size=Vector3.one*.1
 part.Anchored=true;part.CanCollide=false;part.CanTouch=false;part.CanQuery=false;part.Transparency=1
 part.CFrame=anchor.Body.CFrame+Vector3.yAxis*1.4;part.Parent=root
 local emitter=Instance.new("ParticleEmitter")
 emitter.Texture="rbxasset://textures/particles/sparkles_main.dds"
 emitter.Color=ColorSequence.new(color(anchor));emitter.LightEmission=.6
 emitter.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,.15),NumberSequenceKeypoint.new(1,0)})
 emitter.Lifetime=NumberRange.new(.45,.85);emitter.Speed=NumberRange.new(2,5)
 emitter.SpreadAngle=Vector2.new(180,180);emitter.Drag=4;emitter.Rate=0;emitter.Parent=part
 emitter:Emit(amount or 16);Debris:AddItem(part,2)
end
function Effects.Food(anchor,model,id,started)
 if not require(RS.Shared.FoodConfig).Foods[id] then return end
 if not foodTemplates[id] then
  local ok,result=pcall(Scenery.Fruit,Art,nil,id)
  if not ok then warn("Feeding visual: "..tostring(result));return end
  foodTemplates[id]=result
 end
 local prop=foodTemplates[id]:Clone();prop.Name="FeedingFruit";prop.Parent=root
 local owner=Players:GetPlayerByUserId(anchor:GetAttribute("OwnerUserId") or 0)
 local hand=owner and owner.Character and (owner.Character:FindFirstChild("RightHand") or owner.Character:FindFirstChild("Right Arm"))
 local from=hand and hand.Position or anchor.Body.Position+Vector3.new(1,1,-1)
 table.insert(active,{Kind="Food",Model=prop,Anchor=anchor,From=from,Young=model:GetAttribute("LifeStage")=="Young",Started=started})
end
function Effects.Heart(anchor,started)
 local p=Instance.new("Part");p.Name="Affection";p.Size=Vector3.one*.1;p.Transparency=1
 p.Anchored=true;p.CanCollide=false;p.CanQuery=false;p.CanTouch=false;p.Parent=root
 local gui=Instance.new("BillboardGui");gui.Size=UDim2.fromOffset(48,48);gui.AlwaysOnTop=false;gui.Parent=p
 local label=Instance.new("TextLabel");label.Size=UDim2.fromScale(1,1);label.BackgroundTransparency=1
 label.Text="♥";label.TextSize=31;label.TextColor3=Color3.fromRGB(246,151,159);label.Font=Enum.Font.GothamBold;label.Parent=gui
 table.insert(active,{Kind="Heart",Model=p,Anchor=anchor,Label=label,Started=started})
end
function Effects.Ability(anchor,kind,started)
 local target=anchor:GetAttribute("ActionTarget");if typeof(target)~="Vector3" then return end
 local part=Instance.new("Part");part.Name=kind;part.Size=Vector3.one*.1;part.Transparency=1
 part.Anchored=true;part.CanCollide=false;part.CanQuery=false;part.CanTouch=false
 part.CFrame=anchor.Body.CFrame;part.Parent=root
 local from=Instance.new("Attachment");from.Position=Vector3.new(0,2.16,-1.05)*(anchor:GetAttribute("VisualScale") or 1);from.Parent=part
 local focus=Instance.new("Attachment");focus.Position=part.CFrame:PointToObjectSpace(target);focus.Parent=part
 local beam=Instance.new("Beam");beam.Name="ElementChannel";beam.Attachment0=from;beam.Attachment1=focus
 beam.Color=ColorSequence.new(color(anchor));beam.LightEmission=.8;beam.FaceCamera=true
 beam.Width0=kind=="AbilityFire" and .35 or .12;beam.Width1=kind=="AbilityFire" and .65 or .30
 beam.Transparency=NumberSequence.new(.15);beam.Segments=16;beam.CurveSize0=kind=="AbilityNature" and .6 or .1;beam.CurveSize1=-.2;beam.Parent=part
 local emitter=Instance.new("ParticleEmitter");emitter.Texture="rbxasset://textures/particles/sparkles_main.dds"
 emitter.Color=ColorSequence.new(color(anchor));emitter.Lifetime=NumberRange.new(.3,.6);emitter.Rate=18
 emitter.Speed=NumberRange.new(.5,2);emitter.Size=NumberSequence.new(.12);emitter.LightEmission=.7;emitter.Parent=focus
 if kind=="AbilityNature" then
  local start=part.CFrame:PointToWorldSpace(from.Position);local delta=target-start
  local side=delta:Cross(Vector3.yAxis);side=side.Magnitude>.01 and side.Unit or Vector3.xAxis
  local leaves={}
  for i=1,6 do for sign=-1,1,2 do
   local point=start:Lerp(target,i/7);table.insert(leaves,{point,point+side*sign*.27+Vector3.yAxis*.15,.10})
  end end
  Art.MakeLeaves(part,"RestoringLeaves",leaves,Color3.fromRGB(105,186,97))
 end
 table.insert(active,{Kind="Ability",Model=part,Anchor=anchor,Beam=beam,Started=started})
end
Run.RenderStepped:Connect(function()
 local now=workspace:GetServerTimeNow()
 for i=#active,1,-1 do
  local item=active[i];local t=now-item.Started
  if not item.Anchor.Parent or t>(item.Kind=="Ability" and 2.3 or 1.5) then item.Model:Destroy();table.remove(active,i);continue end
  local cf=item.Anchor.Body.CFrame
  if item.Kind=="Ability" then
   item.Beam.Transparency=NumberSequence.new(math.clamp(.2+(t>1.8 and (t-1.8)*1.5 or 0),.1,1))
   item.Beam.Width1=.35+math.sin(t*12)*.09
  elseif item.Kind=="Food" then
   local scale=item.Anchor:GetAttribute("VisualScale") or 1
   local mouth=cf:PointToWorldSpace(Vector3.new(0,item.Young and 2.16 or 1.78,-1.08)*scale)
   local progress=math.clamp(t/.48,0,1)
   local pos=item.From:Lerp(mouth,progress)+Vector3.yAxis*(math.sin(progress*math.pi)*.8)
   local shrink=1-math.clamp((t-.65)/.5,0,1)
   item.Model:ScaleTo(math.max(.01,.48*shrink));item.Model:PivotTo(CFrame.new(pos)*CFrame.Angles(0,t*4,0))
  else
   item.Model.CFrame=cf+Vector3.yAxis*(3.2+t*.65)
   item.Label.TextTransparency=math.clamp((t-.5),0,1)
  end
 end
end)
return Effects
