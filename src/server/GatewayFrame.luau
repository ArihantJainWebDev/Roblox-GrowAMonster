-- The replicated fallback and collision frame share the same curved outline as the artwork.
local Frame={}
function Frame.Build(gate,base,left,right)
 local model=Instance.new("Model");model.Name="CurvedGatewayFrame"
 model:SetAttribute("Build","gateway-curve-01")
 local function stone(name,size,cf)
  local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=cf;p.Anchored=true
  p.Material=Enum.Material.Limestone;p.Color=Color3.fromRGB(181,176,151);p.Parent=model
 end
 for side,foot in {[-1]=left,[1]=right} do
  local height=math.max(.7,base.Y+4-foot)
  stone("ArchSupport",Vector3.new(1.1,height,1.6),CFrame.new(base+Vector3.new(side*4.4,foot+height/2-base.Y,0)))
 end
 local segments=24;local span=math.pi/segments;local radius=4.4
 for i=0,segments-1 do
  local a=(i+.5)*span
  local center=base+Vector3.new(math.cos(a)*radius,4+math.sin(a)*radius,0)
  stone("ArchSegment",Vector3.new(2*radius*math.sin(span/2)+.045,1,1.55),CFrame.new(center)*CFrame.Angles(0,0,a+math.pi/2))
 end
 model.Parent=gate
 return model
end
return Frame
