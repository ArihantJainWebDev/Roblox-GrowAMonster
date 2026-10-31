-- Approach the current owner/active navigation waypoint; never replay player history.
local Motion={}
local function flat(v) return Vector3.new(v.X,0,v.Z) end
function Motion.New(position,forward,owner)
 return {Position=position,Forward=flat(forward).Unit,Speed=0,LastOwner=owner,Walking=false}
end
function Motion.Step(s,owner,dt,target)
 dt=math.min(dt,.05)
 s.LastOwner=owner
 local distance=flat(owner-s.Position).Magnitude
 if distance>6 then s.Walking=true elseif distance<3.8 then s.Walking=false end
 local delta=flat((target or owner)-s.Position)
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
