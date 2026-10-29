# Changelog

Notable project changes are recorded here, newest first. Planning decisions are not evidence of implemented features.

## Unreleased — Grounding corrections and creature/gameplay plan

- Removed floating connector slab geometry, grounded portal feet/thresholds, and attached orchard fruit to real branch sockets.
- Rooted wild food and crop models using server terrain anchors and origin pivots; expanded mature tree/bush foliage, root detail and soil mulch.
- Rebuilt physical sign supports/text layouts. Recorded measured grounding checks in docs/world/W4_CORRECTIONS_01.md.
- Added the C1 creature family concept/brief and explicit G1 monster-led exploration milestone. Models, rigs, animations and G1 gameplay are not claimed implemented.

## Unreleased — W4 environment rollout

- Added orchard/Grove planting, original fruit and rocks, spring canopy/bench/watercourse, trail signs and authored portal frames.
- Dressed all four farm beds and replaced crop spheres with staged apple/berry plants and ripe fruit. Seed buying opens from a physical propagation bench; ownership uses a small sign.
- Kept server-owned gameplay rules and per-player fruit cooldowns; added trunk/post collision and cached shared grass clearings.
- Recorded the user's successful pre-W4 three-player test and W4 desktop planting/harvest/bench/travel/pickup checks. W4 visual approval and presentation regression/device checks remain open; see docs/world/W4_WORLD_BUILD.md.

## Unreleased — Consistent editor preview

- Added tools/PreviewWorldInStudio.luau to refresh the generated shared world/courtyard in Edit mode from current sources.
- Prevented WorldService from starting its player recovery loop during an Edit preview build.
- Resolved the stale sky-foundation-03 Edit scene while retaining sky-foundation-09 sources; no project files were lost and nothing was published.

## Unreleased — Natural stone trails and bridge landings

- Replaced outdoor pale tile markers with continuous Rock terrain trails; retained the courtyard's formal paving.
- Rebuilt bridge spans using measured ground elevations, extended landings, bounded terrain clearance and six stone approach ramps.
- Widened the Grove bloom grass clearing. Three no-jump bridge/landing traversals passed in desktop Play; exact remaining review items are recorded in docs/world/W2_FOUNDATION.md.

## Unreleased — W3 courtyard construction

- Added batched plaza paving, fountain apron/border, garden coping and terrain-aligned trail connections.
- Added pavilion ashlar, recessed windows, arch voussoirs, pilasters and botanical roof ornament; layered tree-bed foliage and flowers, lantern frames and bench armrests.
- Preserved original fountain water/audio and current gameplay anchors. Expanded grass clearings along courtyard connections.
- Desktop Play construction/navigation/effects checks passed; user visual acceptance and remaining collision/device requirements are recorded in docs/world/W3_COURTYARD.md.

## Unreleased — Grass clipping correction, 29 October 2026

- Replace Grass terrain material with Ground beneath the courtyard, farm beds/aisles, spawn/egg, gateways, tree bases, Grove bloom and walking trails. Terrain height and occupancy stay intact; wild landscape keeps its grass.
- Apply shared clearings on startup even when terrain already matches the current version; apply home clearings after each personal island is generated.
- Synced WorldService into Studio and applied the shared clearings in Edit. Fresh Play voxel checks found zero Grass voxels in sampled courtyard/farm/tree-base areas and retained Grass in the sampled wild landscape. Rojo build passed.

## Unreleased — W2 world foundation, 29 October 2026

- Added irregular floating Terrain, rock strata, orchard terraces, three bridges, spring/channel, layered procedural clouds and fall recovery.
- Integrated the original fountain courtyard into the shared hub and added broadleaf/bloom landmarks.
- Moved personal homes to separate terrain and implemented validated same-server gateways, companion relocation and gateway-aware quest guidance.
- Relocated food/Grove anchors; fixed farm/evolution UI startup waiting for remotes.
- Archived obsolete template scenery and removed the isolated courtyard Rojo marker. Nothing uploaded, published or pushed.
- Functional checks and open visual/multiplayer/device/persistence requirements are recorded in docs/world/W2_FOUNDATION.md. W2 is not accepted complete.

## Unreleased — Phase 3 implementation

- Added apples, berries, and uncommon golden apples on ten starter-area gathering nodes.
- Added server-owned typed inventory, capacity and collection checks, per-player cooldowns, local respawn countdowns, and pickup feedback.
- Connected food selection and consumption to monster growth; removed Phase 2's free starter fruit.
- Recorded multiplayer pacing and touch review as outstanding phase exit checks.

## Unreleased — Phase 2 complete

- Added a server-owned Sprout with a readable part-based face, belly, feet, and leaf; it follows its owner and reacts to feeding.
- Added a data-only growth snapshot for later persistence, plus the client HUD and server-validated feeding. Starter food, XP, and stage remain session-only.
- Verified ten feeds consume food and advance Baby-to-Young at 100 XP; an empty-inventory feed request grants no XP. Rojo build and Studio sync succeeded.
- Production art, saved progression, gathering, farming, and evolution remain future work in their planned phases.

## Unreleased — Planning baseline (initial state)

- Recorded the agreed game direction: personal floating islands and shared exploration, continuous visible companion growth, Fire/Crystal/Nature evolution paths, wild food plus four-plot farming, colorful stylized 3D, and optional cosmetic monetization.
- Added proposed Rojo/Git/Luau architecture and phased first-release roadmap.
- At that initial planning point, no gameplay code or Studio place changes had been made.

## Unreleased — Phase 1 complete

- Added a minimal Rojo project mapping, project README, and Git ignore rules.
- Pinned Rojo 7.7.1 in the project tool manifest.
- Added a server bootstrap that creates a temporary floating-island spawn area.
- Initialized a local Git repository for the project files.
- Updated the starter island to float above the default template floor and disable its default spawn during play.
- Installed Rokit, Rojo 7.7.1, and the matching Studio plugin; the project builds successfully to a temporary place file.
- Confirmed the open Studio target is `GrowAMonster` (place ID `126867787734164`).
- Connected the Rojo 7.7.1 Studio plugin to the project server and accepted the source sync into the intended `GrowAMonster` place.
- Verified the mapped `GameServer.main` and `GameClient` nodes in Explorer; confirmed the Studio server script source matches `src/server/main.server.luau`.
- Inspected Play mode after sync: the floating island appeared, the player spawned at the expected height, and the template floor/spawn were disabled. No bootstrap or Rojo errors appeared; Studio reported asset-type mismatch warnings for the template asset `rbxassetid://203785492`.
- No place publish or Git push was performed.

## Unreleased — Phase 4 farming slice

- Added personal islands, four plots, selected seeds, seed shop, timestamped crop growth and atomic harvest rewards.
- Added farm-only save/load with lease checks and labelled Studio preview when API access is unavailable. Save/rejoin remains unverified.
- Recorded user-reported Phase 3 solo checks and explicitly deferred multiplayer testing.

- Fixed Phase 4 bridge/grass surface overlap: bridge now spans only the gap between island edges, removing coplanar flicker. Applied geometry correction to the active Play session as well.

## Unreleased — Phase 5 evolution prototype

- Added confirmed Fire/Crystal/Nature selection at 100 growth, equal progression to 300, prototype branch appearances, and Element Grove reward interaction.
- Added growth/path serialization to the leased farm save; persistence verification remains deferred.
- Recorded Phase 4 farming user checks passed and deferred save/rejoin testing.

## Unreleased - Phase 6 onboarding prototype

- Added owned egg hatching, eight server-tracked objectives with one-time coin rewards, collapsible guidance and target markers.
- Added Grove landmarks/signs and three evolution-validated food patches. Quest/hatch state joins the existing save record.
- Live quest-chain integration passed. User acceptance, phone, deferred save/rejoin and multiplayer review remain pending.

- Tutorial completion now removes the guide and target marker automatically, including when loading an already completed journey.

- Added a Sunlit Sky Gardens visual study: hatchery canopy, egg nest, raised crop bed, flowering tree, paving and static baby creature maquette. This is a review sample, not final production art.

## 29 October 2026 — World/art production replan

- Established ordered fantasy-world production stages, concrete required world spaces and evidence-based quality gates.
- Added asset register and custom/free-asset fallback policy; no external assets selected yet.
- Recorded visible-ground/cloud/terrain and primitive-art defects as unresolved. Current VisualSample is unaccepted.
- Replaced stale top-level status and generic Phase 7 brief. Gameplay prototype acceptance does not close deferred release checks.

- Added W1 archipelago blueprint, proposed dimensions/elevations/routes and source shortlist. Inspected and rejected two free imports containing unrelated scripts despite no-script listing claims; removed both from isolated storage. W1 is not accepted.

- Recorded user approval of layout 02: gateway-based same-server homes, compact hub and walkable shared exploration. Superseded physical home docks/six-slot proposal. Updated blueprint, ownership/travel requirements and W1 acceptance tracking; no gameplay implementation changed.

- Inspected nine free Creator Store candidates in isolated storage and actual Studio views. Added durable candidate manifest and asset inspection report; kept gameplay unchanged. No production asset approved.

- Established an original EditableMesh authoring route and built fountain, cliff-shell and folded-leaf tree studies in Studio. Added deterministic generator and standard OBJ/MTL export, with explicit unresolved production requirements. No gameplay startup or world replacement changed.

- Assembled the original fountain courtyard with portico, paving, planting, benches, lanterns, procedural water textures, Beams, splashes/ripples and a loaded spatial fountain loop. Found Edit-to-Play mesh-content loss; prepared a local reconstruction path, blocked pending Roblox Editable Mesh / Image API enablement. W3 not marked complete.

- Verified courtyard runtime rendering after user enabled mesh/image APIs. Fixed editable-mesh memory exhaustion by freezing/releasing each mesh; observed working water textures, changing ripples, audio playback and player-height geometry. Guarded farm HUD against partially replicated islands. Courtyard awaits visual acceptance; whole-world gates remain open.
