# Phase 2 — Companion, Feeding, and Growth

**Status:** COMPLETE — the starter companion follows its owner, reacts to feeding, and grows through a visible milestone using server-owned state.

## Goal

Make the companion the emotional center of a small playable slice: players can see it, feed it, and understand its growth.

## Implemented

- `MonsterService` creates a readable part-based Sprout with a face, belly, feet, and leaf. The server keeps it near its owner with a gentle idle bob.
- The player starts with 10 test fruit. Each accepted feed spends one fruit and grants 10 XP; requests are rate-limited and rejected when there is no food or growth is capped.
- Sprout reacts to a successful feed, scales with XP, and changes from Baby to Young at 100 XP.
- `MonsterController` displays stage, growth progress, remaining fruit, and a touch-friendly Feed button with feedback.
- `MonsterConfig` holds shared balance values. `MonsterService.GetSnapshot` returns data-only growth state for later persistence.

## Verification

- Rojo build and Studio sync completed for the Phase 2 source.
- Ten spaced feed requests consumed 10 fruit and advanced Sprout to Young at 100 XP; the model scaled and the nameplate updated.
- Confirmed Sprout follows within roughly four studs of its owner and presents its face in the normal over-the-shoulder view.
- A further request with zero fruit left did not change food or XP.
- Studio Output showed only the existing template asset type warnings for `rbxassetid://203785492`; no Phase 2 script errors appeared.

## Deliberate limits

Phase 3 supersedes the free starter fruit described in this phase's historical verification. Current sessions start with an empty typed food basket; FoodService owns inventory and MonsterService owns growth.

- Starter fruit, growth, and stage are session-only; saved progression belongs to the planned data phase.
- The part-based Sprout is prototype art. Production visuals and animation are planned for Phase 7.
- Wild food gathering begins in Phase 3; farming in Phase 4; evolution in Phase 5.
