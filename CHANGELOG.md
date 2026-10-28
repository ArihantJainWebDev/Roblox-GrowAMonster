# Changelog

Notable project changes are recorded here, newest first. Planning decisions are not evidence of implemented features.

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
