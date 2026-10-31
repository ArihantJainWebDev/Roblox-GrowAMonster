-- Material-only garden maintenance. Never changes terrain occupancy or collision.
local Terrain=workspace.Terrain
local Cover={Version="home-cover-02"}
local function region(center,width,depth)
 return Region3.new(center-Vector3.new(width/2,20,depth/2),center+Vector3.new(width/2,20,depth/2)):ExpandToGrid(4)
end
function Cover.Clear(center,width,depth)
 local area=region(center,width,depth)
 Terrain:ReplaceMaterial(area,4,Enum.Material.Grass,Enum.Material.Ground)
 Terrain:ReplaceMaterial(area,4,Enum.Material.LeafyGrass,Enum.Material.Ground)
end
local function path(center,a,b,width)
 local steps=math.max(1,math.ceil((a-b).Magnitude/4))
 for i=0,steps do Cover.Clear(center+a:Lerp(b,i/steps),width,width) end
end
function Cover.Home(center)
 -- Animated blades belong on the outer meadow, outside the working garden and camera orbit.
 -- Elliptical strips retain a natural green border rather than a rectangular brown clearing.
 for z=-42,42,4 do
  local half=40*math.sqrt(math.max(0,1-(z/46)^2))
  Terrain:ReplaceMaterial(region(center+Vector3.new(0,2,z),half*2,4),4,Enum.Material.Grass,Enum.Material.LeafyGrass)
 end
 Cover.Clear(center+Vector3.new(0,2,-3),30,32)
 Cover.Clear(center+Vector3.new(3,2,18),24,18)
 Cover.Clear(center+Vector3.new(-16,2,-15),24,32)
 Cover.Clear(center+Vector3.new(-15,2,17),16,16)
 path(center,Vector3.new(0,2,18),Vector3.new(-16,2,-15),10)
 path(center,Vector3.new(0,2,18),Vector3.new(-15,2,17),10)
end
return Cover
