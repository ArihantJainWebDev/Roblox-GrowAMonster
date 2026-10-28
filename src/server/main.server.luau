-- Phase 1: create a readable temporary spawn area while the project is scaffolded.
-- Gameplay services will replace this bootstrap as their phases are implemented.

local WORLD_NAME = "GrowAMonsterWorld"

if workspace:FindFirstChild(WORLD_NAME) then
	return
end

local world = Instance.new("Model")
world.Name = WORLD_NAME

local function makePart(name: string, size: Vector3, position: Vector3, color: Color3, material: Enum.Material): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.Position = position
	part.Color = color
	part.Material = material
	part.Anchored = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = world
	return part
end

-- A broad grassy top and tapered-looking rock tiers make a simple floating-island silhouette.
makePart("IslandTop", Vector3.new(72, 4, 72), Vector3.new(0, 0, 0), Color3.fromRGB(113, 190, 105), Enum.Material.Grass)
makePart("IslandRockUpper", Vector3.new(58, 8, 58), Vector3.new(0, -6, 0), Color3.fromRGB(112, 105, 97), Enum.Material.Slate)
makePart("IslandRockLower", Vector3.new(40, 10, 40), Vector3.new(0, -15, 0), Color3.fromRGB(91, 84, 81), Enum.Material.Slate)

local spawn = Instance.new("SpawnLocation")
spawn.Name = "StarterSpawn"
spawn.Size = Vector3.new(8, 1, 8)
spawn.Position = Vector3.new(0, 2.5, 0)
spawn.Transparency = 1
spawn.Anchored = true
spawn.CanCollide = false
spawn.Neutral = true
spawn.Duration = 0
spawn.Parent = world

world.Parent = workspace
