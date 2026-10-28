# Phase 4 — Personal Island and Four-Plot Farming

**Status:** Planned; depends on Phase 2 and the player-data foundation.

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
