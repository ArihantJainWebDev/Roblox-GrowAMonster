# Grow a Monster — Architecture

**Status:** Technical baseline accepted; implementation is underway, with phases recorded in `DEVELOPMENT_PLAN.md`.
**Stack:** Roblox Studio, Luau, Rojo, Git.

## 1. Guiding rules

- Keep source in a normal Rojo project and use Studio for scene work, asset inspection, and playtesting.
- Keep game rules and progression authoritative on the server. Clients render state and ask to perform actions.
- Put tunable balance in shared configuration modules; keep secret validation and persistence on the server.
- Prefer small services with clear ownership over a large all-purpose script.
- Treat saves and remote requests as untrusted input; validate types, bounds, ownership, rate, and current state.
- Do not begin coding against a guessed folder structure; inspect the supplied project first and preserve any existing work.

## 2. Proposed source tree

```text
GrowAMonster/
├── src/
│   ├── client/
│   │   ├── controllers/       # Input, HUD, inventory, farm and companion presentation
│   │   └── ui/                # Reusable UI components and screens
│   ├── server/
│   │   ├── services/          # Player data, plots, food, growth, quests, world
│   │   └── main.server.luau   # Service startup and dependency wiring
│   └── shared/
│       ├── config/            # Food, crops, growth, evolution, world tuning
│       ├── remotes/           # Remote names/contracts, if project conventions warrant
│       └── types/             # Shared Luau types and constants
├── assets/                    # Source art/audio only when appropriate to the pipeline
├── docs/                      # Design, architecture, roadmap, phase plans and decisions
├── tests/                     # Add only when requested or agreed for a specific phase
├── default.project.json       # Rojo mapping
├── aftman.toml                # Optional pinned tool versions, if Aftman is adopted
├── .gitignore
└── README.md
```

The exact layout and tooling will be reconciled with the provided folder before adding anything. Roblox place files and Studio-managed assets may remain in Studio; document how they map to source rather than duplicating opaque binary assets in Git without a reason.

## 3. Runtime responsibilities

### Current Phase 3 implementation

The source currently uses flat service/controller modules under the mapped folders. FoodService owns per-player inventory and node readiness in server tables, mirrors display attributes, and returns cloned data-only inventory snapshots. MonsterService owns growth and asks FoodService to consume the selected food; the spend and XP grant do not yield. Clients only select food, display counts, and hide/regrow their own fruit visuals. The toolchain uses Rokit via rokit.toml. The proposed source tree is a target layout; some of its modules belong to later phases.

### Server services

- **PlayerDataService:** load, validate, version, save, and release player profiles; handle retry and session locking using a mature, documented persistence approach.
- **IslandService:** allocate and release a player's island, enforce owner access, and restore island state from profile data.
- **FarmService:** validate plot ownership, planting, crop timestamps, harvest readiness, yields, and seed costs.
- **FoodService:** maintain authoritative inventory and validate collection/feed requests.
- **MonsterService:** own growth points, stages, feeding, bond reactions, and companion state replication.
- **EvolutionService:** validate an eligible milestone and chosen branch, then persist the choice and apply configured form.
- **WorldService:** manage authored gathering nodes, cooldowns, region gates, and server-validated rewards.
- **QuestService:** grant only configured rewards for server-confirmed actions.
- **EconomyService:** validate soft-currency awards and spends; avoid client-supplied balances.

Services may start together as a simpler initial implementation if boundaries stay clear. Split or combine modules based on actual complexity, not the diagram alone.

### Client controllers

- **InputController:** map touch and keyboard/mouse input to interaction intents.
- **UIController:** display onboarding, inventory, farm prompts, growth, quests, and evolution confirmation.
- **World/Companion presentation:** animate replicated state and local effects without deciding rewards.
- **IslandController:** display owner farm state and request authorized actions.

## 4. Data model (logical, not a serialization contract)

```text
Profile
  schemaVersion
  coins
  inventory: { foodId -> count, seedId -> count }
  monster: { speciesId, growthXP, stageId, evolutionPath, bondLevel? }
  island: { unlockedDecorations, plotStates[4+] }
  quests: { completedIds, currentProgress }
  settings: { tutorialCompleted, accessibility options? }
```

Plot state stores a crop identifier and planting time, not a live Instance reference. Derived readiness is calculated from server time and crop configuration. Never persist transient world objects, client instances, or unvalidated tables. Version migrations must be explicit and safe; default missing fields and clamp invalid values.

## 5. Network contracts and validation

Clients may request actions such as collect node, plant seed, harvest plot, feed monster, choose evolution, and claim quest. Each request must be checked for:

1. Correct types and known identifiers.
2. Player owns or can reach the target and it is in the expected state.
3. Cooldown, quantity, distance, and rate limits.
4. Sufficient inventory/currency, with spend and reward applied atomically on the server.
5. Idempotency where duplicate requests could otherwise double-grant.

Replicate compact snapshots or changed fields; don't send the full profile for every action. Show responsive local feedback only when it can reconcile with the authoritative result.

## 6. World representation

- Author the starter hub and first region as Studio content, with stable named folders/instances for interaction points.
- Give gather nodes stable IDs and configuration-driven food/cooldown values. A node becomes available based on server state.
- Allocate personal islands from a bounded template or controlled layout. Do not trust client-provided island positions or ownership.
- Keep initial visual assets low-complexity and readable on mobile. Add streaming/optimization decisions when the first map is measured, not preemptively.

## 7. Persistence and operational safety

- Use Roblox-supported server persistence APIs through a profile/session pattern appropriate to current platform guidance.
- Save on meaningful state changes with coalescing, plus periodic and shutdown saves; handle throttling and retries without claiming a save succeeded when it did not.
- Protect against two servers editing the same player profile concurrently. Surface load failure and avoid overwriting unknown data with defaults.
- Do not log private profile contents or secrets. Never store payment credentials or personal contact information.
- Treat monetization receipts as server-verified and implement purchase grants only in the later monetization phase.

## 8. Development and validation workflow

1. Git tracks source and docs; commits are small and phase-focused.
2. Rojo sync maps source to Studio. Validate the mapping before syncing and keep generated/editor data out of source control.
3. Use Roblox Studio MCP when connected to inspect the right place, run controlled play sessions, and check output. Confirm the target Studio place before modifying it.
4. Perform phase-appropriate manual playthroughs on touch and desktop. Do not add automated tests unless requested or explicitly agreed for a particular phase.
5. Record decisions and material changes in `docs/DECISIONS.md` and `CHANGELOG.md`.

## 9. Known technical risks

| Risk | Planned response |
|---|---|
| Data loss or duplicate profiles | Use session-aware profile ownership, versioned migrations, retry handling, and restart playthroughs before release. |
| Exploited remotes create items or currency | Server owns reward calculations and validates state, ownership, distance, and rate. |
| Island allocation grows costly | Start with a small template and bounded player layout; measure instance count before expanding. |
| Too many systems before the fun is proven | Build and review one vertical slice before adding secondary systems. |
| Unclear tradeoff between offline growth and active play | Keep absence non-punitive; test passive progress as a small capped bonus only if needed. |
| Platform/API changes | Check official Roblox documentation when implementation reaches the affected API. |

## Phase 4 farming slice

FarmService owns per-player islands, four plot states, seed/coin balances and farm-only persistence. FarmConfig supplies prototype crop rules. FarmController presents seed choices, shop requests and derived crop visuals. FoodService.TryGrant atomically admits a whole harvest or leaves it unclaimed. Farm saves use GrowAMonster_Farms_v1 with an expiring session token; complete shared profile persistence remains future work. Studio without API access is explicitly preview-only.

## Phase 5 progression

EvolutionConfig defines branches and thresholds. MonsterService owns TryEvolve and validates RestoreSnapshot; client attributes only mirror private state. FarmService serializes MonsterService snapshots alongside farm data under the same lease. EvolutionController offers preview/confirmation; ExplorationService checks server snapshots before granting an Element Grove reward. Food inventory remains session-only.

## Phase 6 onboarding

QuestService owns objective facts and ordered one-time rewards. Validated actions call Record from server services; clients cannot claim progress. Coin reward and step advancement do not yield. QuestController derives guidance from replicated step state. FarmService saves quest snapshots; MonsterService persists Hatched and migrates legacy grown/evolved monsters. Rejoin/storage-failure checks remain pending.

## World/art production boundary — 29 October 2026

Follow docs/WORLD_PRODUCTION_PLAN.md. Separate authored environment/asset data from gameplay services; migrate gameplay anchors and transforms without losing validation or state IDs. Verify Rojo/Studio ownership for meshes, terrain and imported models before replacing runtime-generated scenery. Preserve source assets and import metadata. VisualSample is an unaccepted preview, not production world architecture. A visible template plane and above-cloud rendering must be audited in the actual place.

## Approved home travel architecture — 29 October 2026

Gateway travel stays within the same server. Server-owned player-to-island mapping resolves destinations; do not trust client coordinates or ownership claims. Validate access, live character, destination readiness, request rate and safe landing. Coordinate companion/spawn/quest anchors after travel. Home slots may change across sessions without changing account-owned data. Streaming or distance offers no security boundary. Implementation remains pending.

## W2 implemented boundaries — 29 October 2026

WorldConfig defines shared terrain zones, graded routes, bridge endpoints, food anchors and home placement. WorldService writes bounded terrain regions and owns shared supports/fall recovery. FarmService creates personal terrain and keeps its existing invisible Grass compatibility anchor for quest/UI distances. GatewayService resolves owned homes on the server, validates prompt access/cooldown and requests destination streaming before travel. Client CourtyardEffects/WorldVisuals reconstruct original non-colliding meshes and effects; gameplay interactions remain server-owned. Mesh/Image APIs are required. See docs/world/W2_FOUNDATION.md. The previous architecture entry saying travel implementation is pending is superseded; visiting policy remains pending.

## Courtyard detail module

ReplicatedStorage.ArtReview.CourtyardDetails maps tools/art/BuildCourtyardDetails.luau. Courtyard.Build invokes it before applying the world-origin translation. It batches project-authored visual masonry and furniture by material/color, constructs layered botanical meshes, and raycasts only Terrain to align short trail connections. The local visuals do not own player progress or grant rewards.

## W4 scene and farm presentation

ArtReview.WorldScenery owns original regional/home/crop/fruit geometry. SceneryController clones cached models and derives growth appearance from server Crop/ReadyAt attributes for streamed homes. GatheringController applies the existing personal cooldown to the new local fruit meshes. FarmController opens its existing seed menu through the owned SeedCounter prompt; server FarmService retains all purchasing, planting, harvesting and ownership authority. WorldConfig.TreeGroups shares tree positions with WorldService clearings and simple trunk collisions. EditorWorldScenery is separate from runtime presentation.


## Grounding correction

WorldService publishes SceneGround Vector3Values for curated decoration positions. FoodService publishes each node GroundPosition; GatewayService publishes LeftFootY/RightFootY. Client scenery aligns to these server measurements, explicit root pivots and actual tree branch attachments. Terrain-owned connector paths replace thin decorative slabs. Gameplay authority is unchanged. See docs/world/W4_CORRECTIONS_01.md.

## Mesh companion rendering
BabySproutAsset supplies immutable mesh references/transforms; BabyRig constructs a seven-joint client rig with authored paws. CompanionVisuals renders replicated server companion anchors. MonsterService owns growth/validation/ground following; visuals have no collision or authority. EditorCreaturePreview is archived in Play. See docs/creatures/C1_BABY_IMPLEMENTATION.md.

CompanionMotion now owns breadcrumb route state and bounded movement on the server. CompanionVisuals smooths replicated anchors and derives gait phase from horizontal distance. BabyRig replaces the intersecting generated tail with an authored rearward sweep. See docs/creatures/C2_FOLLOWING.md for limits.

SeedEgg authors a floor-origin shell/nest; SeedEggVisuals follows server WelcomeEgg GroundPosition and Hatched attributes. Server still validates the hatch. BabyRig.Build(stage) assembles baby/young variants; CompanionVisuals switches cached templates on authoritative Stage and uses per-rig stride. See docs/creatures/C1_EGG_YOUNG.md.

CompanionNavigation supersedes historical player breadcrumbs: current-owner goals, short-lived PathfindingService waypoints and obstacle/ground checks feed bounded CompanionMotion steering. SpawnLocation markers have no collision. Details and recovery limits: docs/creatures/C2_NAVIGATION_CORRECTIONS.md.

ElementForms builds young-rig variants with welded head/tail ornaments and cached 256-pixel palette textures. CompanionVisuals prefetches per-client templates and switches by each anchor's Path. Image/template work is shared across players; branch balance and persisted Path remain server-authoritative. EditorEvolutionPreview is archived during Play. See docs/creatures/C1_ELEMENTAL_FORMS.md.

## Server-timed creature actions and context commands
MonsterService owns whitelisted owner commands, busy/cooldown/distance checks, short action holds and server-timed Action cues. CompanionVisuals performs timed template crossfades; BabyRig poses existing joints; CompanionEffects owns transient food/hearts/element channels and cleanup. SeedEggVisuals synchronizes shell shaking/opening with the hatch cue. ExplorationService supplies only the whitelisted Grove target, validates approach/channel/completion and grants the existing reward once per cooldown. Commands/interaction activity are session-only; persisted monster/quest schemas are unchanged. Details: docs/creatures/C2_ACTIONS_AND_CONTROLS.md and docs/gameplay/G1_GROVE_INTERACTION.md.

GroundCover is a material-only server helper for home lawns/clearings. Art.MakeLeaves marks camera foliage; CameraFoliage applies temporary local visibility changes near the lens. Gateway visuals use W4-gateway-02 and rebuild stale local versions. See docs/world/W4_CAMERA_FOLIAGE_FIX.md.
