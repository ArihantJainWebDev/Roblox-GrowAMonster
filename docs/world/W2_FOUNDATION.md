# W2 — Sky world foundation

Status: In progress, 29 October 2026. Functional foundation implemented; visual exit gate is not accepted.

## Implemented in this build

- Actual Roblox Terrain replaces the three rectangular prototype platforms: irregular outlines, tapered floating undersides, rock/slate strata, sloped ground, orchard terraces and raised Grove terrain.
- Hub footprint approximately 236 × 220 studs, orchard 300 × 220, Grove 270 × 240; terrain elevations approximately 420 / 452 / 480 before local grading. WorldConfig owns all route and interaction coordinates.
- Three railed bridges form a walkable shared loop. Spring and shallow channel are carved into the orchard; a local water effect falls toward the clouds.
- Original fountain courtyard is integrated at the hub, with its existing water, audio, paving, trees and furnishings. Six additional original broadleaf trees and a custom faceted Grove bloom mark destinations.
- Engine atmosphere/clouds plus two layers of original image-mapped cloud sheets below the islands. Smooth alpha blending is required; opaque mesh defaults produced cutout artifacts and were corrected.
- Personal homes use separately generated terrain in a residential grid. Four columns describe placement only, not server capacity. Existing egg, four plots, profile IDs and ownership checks remain.
- Server-owned Home / Return to Hub gateways validate live characters, proximity, ownership, cooldown and destination readiness. Travel requests streaming before relocation. Companions reset across long moves; quest targets point to the appropriate gateway.
- Falling below Y250 returns a living character to its owned home, or the hub if unavailable.
- Existing template Baseplate and obsolete review/prototype objects are moved to ServerStorage.PrototypeArchive in the actual Edit place. Unrelated terrain is not globally cleared.

## Verification performed

- Rojo place build and whitespace checks passed.
- Desktop Play: fountain reconstruction Ready; cloud creation Ready; no cloud API or farm/evolution startup errors in the final tested pre-documentation session.
- Gateway service checks: Home → Hub, Hub → Home, distant request rejection, rapid request rejection and fall recovery passed in a live server session.
- 309 samples along configured routes all found terrain/bridge support within the expected vertical range.
- Client character navigation crossed the hub/orchard bridge and continued through orchard terraces. The hub/Grove bridge also crossed successfully; health remained 100 in checked travel.
- The first server Humanoid.MoveTo automation did not move the client-owned character. It is not counted as a route failure or a successful walk; client navigation was used afterward.
- Relocated Apple06 collection passed with the actual FoodService in Play. Prior phases' complete gameplay acceptance is not replaced by terrain raycasts.
- Final fresh Play restart: native E prompt returned the player Home → Hub; region Hub, health 100, courtyard Ready, cloud creation Ready. Final source build passed.
- Console still reports the existing asset 203785492 type mismatch, alongside disabled DataStore API access. No new world/client script errors in this final run; asset-warning cleanup remains open.

## Open requirements before W2 acceptance

- Normal-camera continuous walkthrough of the full loop, including the orchard/Grove bridge, every edge approach and waterfall source/termination. Support samples alone do not prove all slopes and seams comfortable.
- User review of cloud depth, horizon, terrain scale and cliff silhouettes. Current broad cloud sheets are an initial implementation; judge actual in-game views, not a generated concept.
- Review spring-to-channel water continuity and waterfall contact at close range. No claim of finished watercourse acceptance.
- Multiplayer home allocation/ownership, simultaneous gateway travel, respawn and streaming under load remain unverified. Capacity and supported device performance targets remain open.
- Save/rejoin remains deferred: Studio DataStore API access is disabled. Mesh/Image API access is enabled and is a separate setting.
- Sparse vegetation, prototype food/crops/egg/companion and interface remain explicitly assigned to W4, C1/C2 and U1. They do not satisfy finished-world gates.

## Source ownership

WorldService builds server terrain, bridges and recovery; GatewayService owns travel. WorldConfig owns placement and grading. WorldVisuals creates non-colliding local clouds/vegetation/bloom/waterfall. CourtyardEffects rebuilds original meshes on each client because transient Edit mesh content does not survive Edit-to-Play cloning reliably. Mesh/Image APIs are required. No assets were uploaded or published.


## Grass clipping correction — 29 October 2026

User reports the full gameplay flow works, with terrain grass clipping through placed scenery. WorldService now changes only Grass material to Ground in bounded occupied areas: courtyard, farm/aisles, spawn/egg, gateways, trails, tree roots and Grove bloom. No terrain is excavated; global grass decoration remains enabled. Shared clearings reapply on startup regardless of world version, and home clearings follow home terrain creation. Existing shared Edit terrain was updated as well. Fresh Play samples: courtyard Grass=0, farm Grass=0, tree base Grass=0; wild-landscape Grass=20 occupied voxels. Build passed. User walkthrough feedback does not close deferred multiplayer/persistence/device checks.


## Route defects reported by user — 29 October 2026

User screenshots identify disconnected/raised bridge ends, terrain piercing decks, pale tile markers overlapping timber, and crowded Grove grass. These are defects, not accepted visual details. Natural rock trails are now the approved outdoor direction; the fountain plaza keeps formal masonry.

World build sky-foundation-09 removes the TrailStone markers and replaces the cleared trail's Ground material with a continuous Rock surface. Bridges extend twelve studs into their islands; endpoints derive from actual Terrain raycasts. A bounded voxel pass caps terrain inside each deck corridor without clearing the island underside. Six stone landing ramps connect the timber ends to the measured ground eight studs beyond. Grove bloom clearing expands to 32 × 32 studs.

Desktop Play: all three bridge crossings and far landing exits passed client navigation with JumpPower and JumpHeight set to zero; checked health 100. Each bridge has two landing ramps. Terrain probes at 41 longitudinal positions × three lateral offsets per span found maximum terrain height relative to the design deck line: Bridge1 -0.355, Bridge2 -0.306, Bridge3 +0.096 studs (small residual at a landing/smoothing boundary, still requiring close visual review). No TrailStone tiles remain. Build/whitespace checks passed. User screenshots revealed defects missed by the earlier route-support-only checks; those earlier checks must not be treated as visual/landing acceptance.

Open: user review of stone texture, bridge abutments/rail endings, remaining small terrain seam and grass density away from cleared approaches. W2 is not accepted complete. Outdoor trail preference does not approve W3 courtyard or W4 scenery.

Final landing pass: close visual review exposed terrain poking through one stone approach. The same bounded clearance is now applied under each approach and abutments have three-stud structural depth. Final build 09 supersedes the initial crossing evidence; user visual review remains required.

The final grading corridor includes a voxel-smoothing margin beyond each landing and beside each deck. Earlier numeric probes describe the intermediate build, not final visual acceptance.
`nFinal build 09 landing probes (three lateral offsets, five positions per ramp) found maximum terrain-to-landing differences of -1.464 / -1.099 / -1.390 studs on bridges 1 / 2 / 3: no terrain intrusion in those samples. Final orchard/Grove crossing and far exit passed with jumping disabled; normal jump controls restored afterward. Rojo build passed.


## Edit/Play preview mismatch — 29 October 2026

User reported recent work missing after reconnecting Rojo. Audit found current source sky-foundation-09 and the W3 detail module present in Studio, while the Edit workspace still held generated sky-foundation-03. Runtime terrain/courtyard changes reverted on stopping Play; the local source files were intact.

Added tools/PreviewWorldInStudio.luau to rebuild the shared terrain and courtyard in Edit from freshly cloned modules (avoids stale require caches). WorldService exits before starting its recovery loop when used in Edit. Ran the preview: Edit terrain now sky-foundation-09, courtyard W3-garden-01. Checked all 25 mapped source files against local content, allowing newline normalization; the only initial discrepancy was an extra trailing blank line in WorldService and was normalized. A fresh Play restart reports current terrain/courtyard again. No publish performed. Client cloud sheets, private home/player services and other gameplay visuals still initialize during Play.
Editor preview has its own EditorCourtyardPreview name and is removed from Workspace at runtime, preventing a race with client courtyard reconstruction. Final fresh Play: terrain sky-foundation-09, courtyard W3-garden-01, Ready, clouds true. Returned to Edit after verification; no publish performed.
