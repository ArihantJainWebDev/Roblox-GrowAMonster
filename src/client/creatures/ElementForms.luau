-- Authored evolution geometry on the shared Sprout skeleton; no gameplay authority.
local Assets=game:GetService("AssetService")
local Art=require(game.ReplicatedStorage.ArtReview.Geometry)
local Forms={}
local palettes={
 Fire={Hue=.055,Body=Color3.fromRGB(174,87,49),Armor=Color3.fromRGB(133,57,39),Accent=Color3.fromRGB(255,184,66)},
 Crystal={Hue=.72,Body=Color3.fromRGB(139,112,193),Armor=Color3.fromRGB(144,115,205),Accent=Color3.fromRGB(129,224,233)},
 Nature={Hue=.33,Body=Color3.fromRGB(67,137,87),Armor=Color3.fromRGB(70,119,68),Accent=Color3.fromRGB(248,171,166)},
}
local pixelsCache,textureCache={},{}
local function texture(uri,path)
 textureCache[path]=textureCache[path] or {}
 if textureCache[path][uri] then return textureCache[path][uri] end
 local source=pixelsCache[uri]
 if not source then
  local full=Assets:CreateEditableImageAsync(Content.fromUri(uri))
  local small=assert(Assets:CreateEditableImage({Size=Vector2.new(256,256)}),"Evolution image budget exhausted")
  small:DrawImageTransformed(Vector2.new(128,128),Vector2.new(256/full.Size.X,256/full.Size.Y),0,full)
  source=small:ReadPixelsBuffer(Vector2.zero,small.Size);pixelsCache[uri]=source
  full:Destroy();small:Destroy()
 end
 local output=buffer.create(buffer.len(source));buffer.copy(output,0,source)
 local hue=palettes[path].Hue
 for offset=0,buffer.len(output)-4,4 do
  local color=Color3.fromRGB(buffer.readu8(source,offset),buffer.readu8(source,offset+1),buffer.readu8(source,offset+2))
  local h,s,v=color:ToHSV()
  -- Preserve cream belly/muzzle, brown horns, eye highlights and baked shading.
  if h>.19 and h<.49 and s>.18 then
   color=Color3.fromHSV((hue+(h-.34)*.30)%1,math.clamp(s*(path=="Nature" and 1 or .85),.2,.9),v)
   buffer.writeu8(output,offset,math.floor(color.R*255+.5))
   buffer.writeu8(output,offset+1,math.floor(color.G*255+.5))
   buffer.writeu8(output,offset+2,math.floor(color.B*255+.5))
  end
 end
 local image=assert(Assets:CreateEditableImage({Size=Vector2.new(256,256)}),"Evolution image budget exhausted")
 image:WritePixelsBuffer(Vector2.zero,image.Size,output)
 textureCache[path][uri]=image -- keep content alive and share it across every player clone
 return image
end
local function weld(part,anchor)
 part.Anchored=false;part.Massless=true;part.CanCollide=false;part.CanTouch=false;part.CanQuery=false
 local w=Instance.new("WeldConstraint");w.Part0=anchor;w.Part1=part;w.Parent=part
end
local function mesh(model,anchor,name,v,f,color,smooth,material)
 local p=Art.MakeMesh(model,name,v,f,color,material or Enum.Material.SmoothPlastic,smooth)
 weld(p,anchor);return p
end
local function tube(model,anchor,name,points,radii,color)
 local v,f={},{};local segments=12
 for j,point in points do
  local tangent=(points[math.min(j+1,#points)]-points[math.max(1,j-1)]).Unit
  local right=tangent:Cross(Vector3.zAxis);if right.Magnitude<.01 then right=tangent:Cross(Vector3.xAxis) end
  right=right.Unit;local up=right:Cross(tangent).Unit
  for i=0,segments-1 do local a=i*math.pi*2/segments;table.insert(v,point+(right*math.cos(a)+up*math.sin(a))*radii[j]) end
  if j>1 then for i=1,segments do local a=(j-2)*segments+i;local b=(j-2)*segments+i%segments+1
   table.insert(f,{a,a+segments,b});table.insert(f,{b,a+segments,b+segments})
  end end
 end
 local first=#v+1;table.insert(v,points[1]);local last=#v+1;table.insert(v,points[#points])
 for i=1,segments do table.insert(f,{first,i,i%segments+1});table.insert(f,{last,(#points-1)*segments+i%segments+1,(#points-1)*segments+i}) end
 return mesh(model,anchor,name,v,f,color,true)
end
local function crystal(model,anchor,name,base,height,radius,color,lean)
 local v,f={},{};local axis=Vector3.new(lean or 0,height,0);local sides=6
 for row,t in {0,.65} do for i=0,sides-1 do local a=i*math.pi*2/sides
  table.insert(v,base+axis*t+Vector3.new(math.cos(a)*radius,0,math.sin(a)*radius))
 end end
 local tip=#v+1;table.insert(v,base+axis)
 local bottom=#v+1;table.insert(v,base)
 for i=1,sides do local b=i%sides+1
  table.insert(f,{i,i+sides,b});table.insert(f,{b,i+sides,b+sides})
  table.insert(f,{tip,b+sides,i+sides});table.insert(f,{bottom,i,b})
 end
 return mesh(model,anchor,name,v,f,color,false)
end
local function flame(model,anchor,name,base,height,width,color,lean)
 local v,f={},{};local n=16
 for row,p in {{.65,0},{1,.24},{.72,.58},{.30,.85},{.01,1}} do
  for i=0,n-1 do local a=i*math.pi*2/n
   table.insert(v,base+Vector3.new(math.cos(a)*width*p[1]+(lean or 0)*p[2]^2,height*p[2],math.sin(a)*width*.5*p[1]))
  end
  if row>1 then for i=1,n do local a=(row-2)*n+i;local b=(row-2)*n+i%n+1
   table.insert(f,{a,a+n,b});table.insert(f,{b,a+n,b+n})
  end end
 end
 return mesh(model,anchor,name,v,f,color,true)
end
local function flower(model,anchor,name,center,radius,color)
 local v,f={},{}
 for petal=0,4 do
  local a=petal*math.pi*2/5;local forward=Vector3.new(math.cos(a),0,math.sin(a));local side=Vector3.new(-forward.Z,0,forward.X)
  local start=#v
  for _,point in {center,center+forward*radius*.5+side*radius*.38+Vector3.yAxis*.06,center+forward*radius+Vector3.yAxis*.02,center+forward*radius*.5-side*radius*.38+Vector3.yAxis*.06,center+forward*radius*.48+Vector3.yAxis*.13} do table.insert(v,point) end
  for _,t in {{1,2,5},{2,3,5},{3,4,5},{4,1,5}} do table.insert(f,{start+t[1],start+t[2],start+t[3]}) end
 end
 mesh(model,anchor,name,v,f,color,true)
 crystal(model,anchor,name.."Pollen",center,.10,radius*.16,Color3.fromRGB(244,209,105))
end
function Forms.Build(young,path)
 local palette=assert(palettes[path],"Unknown evolution path")
 local model=young:Clone();model.Name=path.."SproutRig"
 local ok,err=pcall(function()
  for _,p in model:GetDescendants() do if p:IsA("MeshPart") then
   if p.TextureID~="" then
    p.TextureContent=Content.fromObject(texture(p.TextureID,path))
   elseif p.Name=="tail_geom" or p.Name=="AuthoredPaw" then p.Color=palette.Body end
  end end
 end)
 if not ok then model:Destroy();error("Evolution texture could not build: "..tostring(err)) end
 local head=model.head_geom;local tail=model.tail_geom
 local crown=head.Position+Vector3.new(0,.30,0)
 if path=="Fire" then
  for i=-1,1 do
   flame(model,head,"EmberCrest"..i,crown+Vector3.new(i*.21,0,0),i==0 and .85 or .59,.15,palette.Armor,i*.17)
   flame(model,head,"CrestGlow"..i,crown+Vector3.new(i*.21,.05,-.075),i==0 and .60 or .41,.075,palette.Accent,i*.12)
  end
  for i=0,3 do
   local base=Vector3.new(.05+i*.065,.82,1.15+i*.31)
   flame(model,tail,"CopperTailPlate"..i,base,.36-i*.035,.16,palette.Armor,.05)
   flame(model,tail,"EmberTailSeam"..i,base+Vector3.new(0,.03,-.06),.23-i*.02,.06,palette.Accent,.04)
  end
 elseif path=="Crystal" then
  for i=-1,1 do
   crystal(model,head,"CrystalCrown"..i,crown+Vector3.new(i*.22,0,0),i==0 and .91 or .64,.14,palette.Armor,i*.18)
   crystal(model,head,"CrownPrism"..i,crown+Vector3.new(i*.22,.02,-.09),.32,.075,palette.Accent,i*.06)
  end
  for i=0,3 do crystal(model,tail,"TailPrism"..i,Vector3.new(.05+i*.07,.82,1.15+i*.32),.42-i*.045,.13,i%2==0 and palette.Armor or palette.Accent,.04) end
 else
  for side=-1,1,2 do
   local base=crown+Vector3.new(side*.23,-.06,.02)
   local mid=base+Vector3.new(side*.13,.35,.05)
   local tip=base+Vector3.new(side*.29,.73,.10)
   tube(model,head,"BloomAntler"..side,{base,mid,tip},{.09,.065,.018},Color3.fromRGB(125,107,65))
   local fork=mid+Vector3.new(side*.28,.14,-.07)
   tube(model,head,"AntlerFork"..side,{mid,fork},{.05,.015},Color3.fromRGB(125,107,65))
   flower(model,head,"CrownBlossom"..side,tip,.25,palette.Accent)
   flower(model,head,"ForkBlossom"..side,fork,.18,Color3.fromRGB(250,215,181))
  end
  local stem={Vector3.new(.26,.78,2.20),Vector3.new(.31,1.03,2.33),Vector3.new(.37,1.13,2.43)}
  tube(model,tail,"TailFlowerStem",stem,{.055,.04,.015},palette.Armor)
  flower(model,tail,"TailBloom",stem[3],.29,palette.Accent)
 end
 model:SetAttribute("Element",path);model:SetAttribute("AssetVersion","C1-elements-01")
 return model
end
return Forms
