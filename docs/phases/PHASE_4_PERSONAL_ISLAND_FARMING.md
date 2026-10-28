# Phase 4 — Personal Island and Four-Plot Farming

**Status:** Farming slice implemented; validation in progress. Saving is implemented but unverified because Studio API access is disabled.

## Goal

Make the personal floating island a persistent home and dependable food source.

## Planned work

- Allocate an island to each player and enforce ownership.
- Provide four starter plots, seed acquisition, planting, crop stages, harvest, and yields.
- Store crop IDs and server timestamps; derive crop readiness safely after rejoin.
- Add the smallest seed/currency rules needed to teach the loop.

## Verification and exit checks

- Two players cannot alter one another's plot or claim another player's crops.
- Planting spends the correct seed once; harvest requires a ready crop and grants the configured yield once.
- Crops remain legible and recover correctly after leaving and rejoining.
- The farm is a forgiving alternative to exploration, not a required timer chore.

## Current implementation — 2026-10-29

- Allocates one separate floating home island per player, four plots, a personal respawn, and a walking route to the shared gathering area. Island positions are assigned per server, not saved coordinates.
- Prototype crops: apple sapling (30 seconds, 3 apples) and berry bush (60 seconds, 4 berries). These reuse existing food types; carrot/strawberry remain candidates for later crop expansion, not implemented content.
- Starts with two seeds of each type and 12 coins. Seeds cost 2/3 coins. Harvest returns the planted seed and 3 coins so farming remains repeatable without a shop grind.
- Choose a seed in the farm panel and use a plot prompt. The server validates the player-owned plot, living character, distance, seed, and timestamp. Early/duplicate harvests grant nothing. Full baskets retain the crop for later harvest.
- Simple local crop spheres grow with the timer; ripe plots change color. This is gameplay presentation, with final art in Phase 7.
- Farm-only DataStore stores coins, seeds, four crop IDs/readiness timestamps and a leased session token. Autosave every 60 seconds, on leave, and shutdown. Server timestamps let crops mature while away. Save failures are shown; expired leases block farm changes. Failed live loads stop entry rather than overwrite existing farm data. Studio API failure uses clearly labelled session-only preview.
- Food inventory and monster growth are still session-only; this farm store is not a complete player-profile persistence system. Consolidation remains necessary before release.

## Verification

- Rojo build passed. Rojo live connection was inactive; workspace sources were applied via Studio MCP for verification.
- Ordinary Play server verification passed: invalid plot/seed, distance guard, exact seed spend, early-harvest rejection, configured harvest yield, returned seed, and duplicate-harvest rejection. The verification temporarily shortened one crop timer, then restored it.
- Desktop screenshot inspected: four plot home, seed selection/shop, and explicit save status visible.
- Studio returned StudioAccessToApisNotAllowed. Save/rejoin and failure-recovery verification remains pending; no persistence pass is claimed.
- Pending: normal-duration hands-on farming/feeding loop, full-basket harvest retention, shop behavior, multiplayer ownership/bridges, and phone layout/input review. Phase 4 is not complete.

User confirmed farming checks working. Save/rejoin testing explicitly deferred at user request; proceed to Phase 5 without claiming persistence verified.
