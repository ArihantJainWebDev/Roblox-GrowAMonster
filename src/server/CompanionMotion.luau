-- Follow the owner's travelled route, with bounded speed and turning.
local Motion={}
local function flat(v) return Vector3.new(v.X,0,v.Z) end
function Motion.New(position,forward,owner)
 return {Position=position,Forward=flat(forward).Unit,Speed=0,Route={},LastOwner=owner,Walking=false}
end
function Motion.Step(s,owner,dt)
 dt=math.min(dt,.05)
 local moved=flat(owner-s.LastOwner).Magnitude
 if moved>=1.2 then
  table.insert(s.Route,owner);s.LastOwner=owner
  if #s.Route>100 then table.remove(s.Route,1) end
 end
 local distance=flat(owner-s.Position).Magnitude
 if distance>6 then s.Walking=true elseif distance<3.8 then s.Walking=false;s.Route={} end
 while #s.Route>1 and flat(s.Route[1]-s.Position).Magnitude<1.2 do table.remove(s.Route,1) end
 local target=s.Route[1] or owner
 local delta=flat(target-s.Position)
 local desiredSpeed=0
 if s.Walking and delta.Magnitude>.1 then
  local desired=delta.Unit
  local angle=math.atan2(s.Forward:Cross(desired).Y,s.Forward:Dot(desired))
  local turn=math.clamp(angle,-3.2*dt,3.2*dt)
  s.Forward=CFrame.fromAxisAngle(Vector3.yAxis,turn):VectorToWorldSpace(s.Forward)
  local alignment=math.max(0,s.Forward:Dot(desired))
  desiredSpeed=math.min(18,math.sqrt(math.max(0,distance-3.5)*20))*alignment
 end
 local change=math.clamp(desiredSpeed-s.Speed,-22*dt,12*dt)
 s.Speed+=change
 local travel=math.min(s.Speed*dt,math.max(0,distance-3.5),delta.Magnitude)
 return s.Position+s.Forward*travel
end
return Motion
