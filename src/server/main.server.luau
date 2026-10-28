-- Phase 1: create a readable temporary spawn area while the project is scaffolded.
-- Gameplay services will replace this bootstrap as their phases are implemented.

local WORLD_NAME = "GrowAMonsterWorld"
local ISLAND_HEIGHT = 64

if workspace:FindFirstChild(WORLD_NAME) then
	return
end

-- The default Studio template includes a floor and spawn pad. Hide those in the
-- running game so players see and use the floating island instead.
local defaultBaseplate = workspace:FindFirstChild("Baseplate")
if defaultBaseplate and defaultBaseplate:IsA("BasePart") then
	defaultBaseplate.Transparency = 1
	defaultBaseplate.CanCollide = false
	defaultBaseplate.CanTouch = false
	defaultBaseplate.CanQuery = false
end

local defaultSpawn = workspace:FindFirstChild("SpawnLocation")
if defaultSpawn and defaultSpawn:IsA("SpawnLocation") then
	defaultSpawn.Enabled = false
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
makePart("IslandTop", Vector3.new(72, 4, 72), Vector3.new(0, ISLAND_HEIGHT, 0), Color3.fromRGB(113, 190, 105), Enum.Material.Grass)
makePart("IslandRockUpper", Vector3.new(58, 8, 58), Vector3.new(0, ISLAND_HEIGHT - 6, 0), Color3.fromRGB(112, 105, 97), Enum.Material.Slate)
makePart("IslandRockLower", Vector3.new(40, 10, 40), Vector3.new(0, ISLAND_HEIGHT - 15, 0), Color3.fromRGB(91, 84, 81), Enum.Material.Slate)

local spawn = Instance.new("SpawnLocation")
spawn.Name = "StarterSpawn"
spawn.Size = Vector3.new(8, 1, 8)
spawn.Position = Vector3.new(0, ISLAND_HEIGHT + 2.5, 0)
spawn.Transparency = 1
spawn.Anchored = true
spawn.Neutral = true
spawn.Duration = 0
spawn.Parent = world

world.Parent = workspace
