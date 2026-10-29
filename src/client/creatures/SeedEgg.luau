local Art=require(game.ReplicatedStorage.ArtReview.Geometry)
local Egg={}
function Egg.Build()
 local model=Instance.new("Model");model.Name="SeedEgg";model.WorldPivot=CFrame.new()
 local shell=Instance.new("Model");shell.Name="Shell";shell.WorldPivot=CFrame.new();shell.Parent=model
 local profile={{.08,.28},{.66,.40},{1,.80},{1.12,1.35},{1.08,1.90},{.90,2.45},{.59,2.95},{.12,3.30},{.025,3.34}}
 for panel=0,7 do
  local v,f={},{};local n=10
  for row,p in profile do
   for i=0,n do
    local a=(panel+(i/n)*.97+.015)*math.pi/4
    local r=p[1]*(1+.018*math.sin(i/n*math.pi))
    table.insert(v,Vector3.new(math.cos(a)*r,p[2],math.sin(a)*r))
   end
   if row>1 then for i=1,n do
    local a=(row-2)*(n+1)+i;local b=a+1
    table.insert(f,{a,a+n+1,b});table.insert(f,{b,a+n+1,b+n+1})
   end end
  end
  Art.MakeMesh(shell,"SeedShellPanel"..panel,v,f,panel%2==0 and Color3.fromRGB(231,211,161) or Color3.fromRGB(216,195,142),Enum.Material.SmoothPlastic,true)
 end
 -- Curved sepals follow the outside of the shell instead of cutting through it.
 for i=0,7 do
  local v,f={},{};local angle=i*math.pi/4
  for row,p in {{.50,.83,.08},{.80,1.03,.23},{1.15,1.16,.22},{1.52,1.18,.12},{1.83,1.13,.005}} do
   for side=-1,1 do local a=angle+side*p[3]
    local radius=p[2]+(side==0 and .055 or 0)
    table.insert(v,Vector3.new(math.cos(a)*radius,p[1],math.sin(a)*radius))
   end
   if row>1 then for k=1,2 do local a=(row-2)*3+k
    table.insert(f,{a,a+3,a+1});table.insert(f,{a+1,a+3,a+4})
   end end
  end
  Art.MakeMesh(shell,"CurvedSeedSepal"..i,v,f,i%2==0 and Color3.fromRGB(91,135,70) or Color3.fromRGB(113,150,76),Enum.Material.SmoothPlastic,true)
 end
 local crown={}
 for i=0,2 do local a=i*math.pi*2/3
  table.insert(crown,{Vector3.new(0,3.22,0),Vector3.new(math.cos(a)*.28,3.70,math.sin(a)*.28),.14})
 end
 Art.MakeLeaves(shell,"SeedCrown",crown,Color3.fromRGB(117,156,79))
 local nest=Instance.new("Model");nest.Name="Nest";nest.WorldPivot=CFrame.new();nest.Parent=model
 Art.MakeSurface(nest,"NestBowl",{{.01,.04},{1.05,.04},{1.26,.15},{1.14,.29},{.01,.29}},48,Color3.fromRGB(112,83,51))
 for i=0,2 do
  Art.MakeSurface(nest,"WovenNestRing"..i,{{1.05+i*.11,.05+i*.09},{1.25+i*.11,.08+i*.09},{1.28+i*.11,.15+i*.09},{1.07+i*.11,.18+i*.09}},48,Color3.fromRGB(117+i*7,87+i*6,53+i*4))
 end
 return model
end
return Egg
