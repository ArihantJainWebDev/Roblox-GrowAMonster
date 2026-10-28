# Phase 3 — Food Inventory and Wild Gathering

**Status:** Implemented; user reports all solo/device checks passed. Multiplayer verification deferred at user request on 2026-10-29; tracked in DEVELOPMENT_PLAN.md. Proceed to Phase 4 without claiming multiplayer validation.

## Goal

Give players an exploration route to food that feeds into companion growth.

## Planned work

- Add a small authored set of gathering points in the starter area.
- Configure node food, availability, and cooldowns on the server.
- Add clear pickup feedback and a compact inventory view.
- Introduce common and one uncommon/rare reward without making rare drops mandatory.

## Verification and exit checks

- Players can find and collect food, understand the result, and use it to feed.
- Node cooldowns and item grants are server-controlled and cannot be duplicated by client requests.
- Respawn timing and map density feel fair in a multiplayer playthrough.

## Current implementation

- Ten authored bushes on the starter island: six apples, three berries, one golden apple.
- Apples give 5 XP and regrow in 12 seconds; berries give 10 XP and regrow in 20 seconds; golden apples give 30 XP and regrow in 45 seconds.
- Each player has separate node cooldowns and a session-only basket capped at 50 items. A player's harvest does not consume another player's fruit.
- Native keyboard/gamepad/touch proximity prompts request collection. The server checks live character, distance, cooldown, capacity, and registered node before granting one item, without yielding during the claim.
- The HUD shows counts and XP by food type, selection, pickup feedback, and feeding. Depleted fruit disappears locally with a countdown, then reappears.
- FoodService owns inventory and consumption. MonsterService spends the selected food through FoodService and grants its configured XP without yielding between spend and reward.
- The Phase 2 free starter fruit has been removed: sessions begin with an empty basket.

## Limits and review

- The Young milestone still caps growth at 100 XP. Feeding at the cap consumes nothing; evolution remains Phase 5.
- Inventory, node cooldowns, and growth reset across sessions. Persistence is not implemented here.
- Bush/fruit visuals are simple gameplay representations; final environment assets remain Phase 7.
- Do not infer a multiplayer pacing or touch-device pass from a successful solo desktop run.

## Evidence from this implementation pass

- Rojo built and synced the source successfully.
- A temporary server-side Play verification script used the live service instances: distant collection, full basket, immediate and delayed duplicates, invalid food IDs and empty consumption were rejected. Valid collection granted exactly one apple; after its configured cooldown the node granted one again. Food and growth snapshots were available from the live services.
- A normal keyboard prompt collected a golden apple. Feeding it changed growth from 5 to 35 XP and its count from 1 to 0; the HUD reported +30 growth.
- iPhone 17 Pro simulation with Sensor orientation and CoreUISafeInsets: inspected landscape and portrait layouts. The basket moves above movement controls on touch; landscape uses a horizontal food row. This verifies simulated layout, not a physical touch playthrough.
- User reports all checks except multiplayer working. Remaining: two-player pacing/availability review, explicitly deferred.
