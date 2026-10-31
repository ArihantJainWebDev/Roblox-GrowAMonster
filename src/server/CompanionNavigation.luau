local Paths=game:GetService("PathfindingService")
local Navigation={}
local function horizontal(v) return Vector3.new(v.X,0,v.Z) end
function Navigation.Target(state,owner,params,now)
 state.Owner=owner
 local distance=horizontal(owner-state.Position).Magnitude
 if distance<4 then state.Waypoints=nil;return owner end
 -- A route is useful only for the owner's current location, not their travel history.
 if state.Goal and horizontal(owner-state.Goal).Magnitude>6 then state.Waypoints=nil end
 local delta=horizontal(owner-state.Position)
 local direction=delta.Magnitude>.1 and delta.Unit or state.Forward
 local wall=workspace:Raycast(state.Position+Vector3.yAxis*1.2,direction*math.min(distance,8),params)
 local ahead=state.Position+direction*math.min(distance,4)
 local support=workspace:Raycast(ahead+Vector3.yAxis*7,-Vector3.yAxis*16,params)
 local blocked=wall~=nil or not support or math.abs(support.Position.Y-(state.GroundY or state.Position.Y))>1.5
 if not blocked then
  -- Prefer the shortest clear route to the owner; discard unnecessary detours.
  if not state.Waypoints then return owner end
 end
 if (blocked or state.Waypoints) and not state.Planning and now-(state.LastPlan or -10)>.8 then
  state.Planning=true;state.LastPlan=now
  local start,goal=state.Position,owner
  task.spawn(function()
   local path=Paths:CreatePath({AgentRadius=1.15,AgentHeight=3.5,AgentCanJump=true,AgentJumpHeight=5,WaypointSpacing=3})
   local ok=pcall(function() path:ComputeAsync(start,goal) end)
   if ok and path.Status==Enum.PathStatus.Success and horizontal(state.Owner-goal).Magnitude<6 then
    state.Waypoints=path:GetWaypoints();state.Waypoint=2;state.Goal=goal
   end
   path:Destroy();state.Planning=false
  end)
 end
 local waypoints=state.Waypoints
 if waypoints then
  while waypoints[state.Waypoint] and horizontal(waypoints[state.Waypoint].Position-state.Position).Magnitude<1.3 do state.Waypoint+=1 end
  local point=waypoints[state.Waypoint]
  if point then
   if point.Action==Enum.PathWaypointAction.Jump and not state.JumpAt and horizontal(point.Position-state.Position).Magnitude<4 then state.JumpAt=now end
   return point.Position
  end
  state.Waypoints=nil
 end
 return owner
end
return Navigation
