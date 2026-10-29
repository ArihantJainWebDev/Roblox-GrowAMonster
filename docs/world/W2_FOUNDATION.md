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
