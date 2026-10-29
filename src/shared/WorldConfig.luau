-- Authored layout; food and growth balance remain in their own configs.
local Map={
	Version="sky-foundation-03",Hub=Vector3.new(0,422,0),HubArrival=Vector3.new(-28,426,-26),
	HomeGateway=Vector3.new(-48,422,-25),GroveBloom=Vector3.new(310,483,175),RecoveryY=250,
	Zones={
		{Id="Hub",X=0,Z=0,RX=118,RZ=110,Y=420,Depth=125},
		{Id="Orchard",X=260,Z=-170,RX=150,RZ=110,Y=452,Depth=145},
		{Id="Grove",X=315,Z=175,RX=135,RZ=120,Y=480,Depth=155},
	},
	Routes={
		{Id="OrchardTrail",Points={Vector3.new(45,420,-30),Vector3.new(96,423,-59),Vector3.new(170,441,-104),Vector3.new(220,447,-135),Vector3.new(280,458,-170),Vector3.new(335,468,-170)}},
		{Id="GroveTrail",Points={Vector3.new(40,420,35),Vector3.new(84,423,67),Vector3.new(228,471,135),Vector3.new(310,480,175)}},
		{Id="ScenicLoop",Points={Vector3.new(295,455,-90),Vector3.new(302,458,-65),Vector3.new(304,473,68),Vector3.new(315,480,140)}},
	},
	Bridges={
		{A=Vector3.new(96,423,-59),B=Vector3.new(170,441,-104)},
		{A=Vector3.new(84,423,67),B=Vector3.new(228,471,135)},
		{A=Vector3.new(302,458,-65),B=Vector3.new(304,473,68)},
	},
	FoodNodes={
		{"Apple01","Apple",-52,-45},{"Apple02","Apple",55,-40},
		{"Apple03","Apple",195,-142},{"Apple04","Apple",231,-190},
		{"Apple05","Apple",285,-192},{"Apple06","Apple",320,-154},
		{"Berry01","Berry",182,-102},{"Berry02","Berry",268,-130},
		{"Berry03","Berry",335,-196},{"Golden01","GoldenApple",352,-170},
		{"GroveApple01","Apple",268,154,true},{"GroveBerry01","Berry",341,142,true},
		{"GroveGolden01","GoldenApple",349,200,true},
	},
}
function Map.HomeCenter(slot) return Vector3.new(1600+((slot-1)%4)*260,418,math.floor((slot-1)/4)*280) end
function Map.ZoneHeight(zone,x,z)
	local dx,dz=x-zone.X,z-zone.Z
	local r=math.sqrt((dx/zone.RX)^2+(dz/zone.RZ)^2)
	local a=math.atan2(dz,dx)
	local edge=1+.055*math.sin(a*5+.8)+.025*math.cos(a*9)
	local top=zone.Y
	local function smooth(t) t=math.clamp(t,0,1);return t*t*(3-2*t) end
	if zone.Id=="Orchard" then
		top+=-18+18*smooth((dx+65)/40)+18*smooth((dx-5)/45)
		top+=20*math.exp(-((dx-70)^2+(dz+50)^2)/1800)+3*math.noise(x*.025,z*.025)
	elseif zone.Id=="Grove" then
		top+=math.clamp((r-.28)*12,0,9)+24*math.exp(-((dx-60)^2+(dz-10)^2)/1500)+3*math.noise(x*.021,z*.021)
	elseif zone.Id=="Hub" then
		top+=math.max(0,r-.45)*9+16*math.exp(-((dx-65)^2+(dz-40)^2)/1100)+12*math.exp(-((dx+70)^2+(dz+45)^2)/1000)
	elseif zone.Id=="Home" then top+=math.max(0,r-.55)*10 end
	if zone.Id=="Hub" and math.abs(dx)<39 and math.abs(dz)<38 then top=zone.Y end
	for _,route in Map.Routes do for i=1,#route.Points-1 do
		local p,q=route.Points[i],route.Points[i+1];local ab=Vector2.new(q.X-p.X,q.Z-p.Z)
		local t=math.clamp(Vector2.new(x-p.X,z-p.Z):Dot(ab)/ab:Dot(ab),0,1)
		local point=p:Lerp(q,t);local d=Vector2.new(x-point.X,z-point.Z).Magnitude
		if d<14 then top+=(point.Y-top)*math.clamp((14-d)/5,0,1) end
	end end
	return top,r,edge
end
return Map
