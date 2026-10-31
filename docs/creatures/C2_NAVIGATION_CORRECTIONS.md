# Companion and spawn corrections — 30 October 2026

User reported invisible platforms at home/hub, detached young-form leaves, failure to climb obstacles, and replaying the player's old route.

## Changes

- HomeSpawn and HubSpawn are invisible navigation/spawn markers, not physical floors. Disabled collision, touch and query on both; updated the existing editor hub marker as well as the source creation code. Terrain remains the walking surface.
- Removed the young form's detached flat add-on mantle panels. The original integrated textured foliage remains. The creature is a wingless woodland drake; those panels were not accepted wings. Longer young anatomy, face and corrected tail are retained.
- Removed historical player breadcrumbs. CompanionMotion now steers toward the current owner or a current navigation waypoint with the existing acceleration/turning limits and stopping radius.
- CompanionNavigation uses Roblox pathfinding for obstacles/gaps, periodically replans toward the latest owner position and invalidates goals more than six studs out of date. Small climbs allow up to 4.5 studs of height change with a brief hop and bounded vertical settling. Taller blocking parts trigger routing instead of direct movement through them.
- Ground checks include collidable workspace geometry, excluding characters and companion visuals. Unsupported movement stops. After four seconds of failed movement with the owner more than twelve studs away, a last-resort recovery resets the follower near the owner; gateway relocation is still handled separately.

## Evidence

- Home and hub spawn markers reported CanCollide=false. Ground probe under the avatar hit Terrain.
- Actual GatewayService Home → Hub travel succeeded; arrival support was Terrain and HubSpawn remained non-colliding.
- Home navigation with multiple direction changes ended near the current owner, at zero speed; no stored breadcrumb queue is used.
- Temporary Play-only staircase had one-, two- and three-stud steps. Companion reached Y=425 from Y=422 and followed across the fixture. Fixture and test scripts were discarded with the Play session.
- Tall-obstacle test and final visual check recorded below after completion.

## Scope and remaining review

This pass fixes the reported behavior; it is not blanket acceptance of arbitrary terrain or future obstacles. User route review, actual three-player pathfinding cost, device performance and detailed foot planting remain open. Existing Studio DataStore restriction/audio warning are unrelated.

Automatic approval review rejected broad replacement of FarmService/WorldService and a world-wide editor refresh because they include persistence/terrain operations. Applied only the specific spawn collision source lines, and used a creature-only review rebuild. No terrain rebuild, saving change, experience publication or Git push was required.

Final checks: an eight-stud wall test recorded zero inside-wall samples, 5.620 studs of lateral detour, and a final owner distance of 4.708 studs. Creature-only Studio rebuild confirmed no YoungLeafMantle add-on exists; rear view retains integrated foliage without detached panels. Rojo build and diff checks passed.
