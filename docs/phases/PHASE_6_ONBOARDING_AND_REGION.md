# Phase 6 — Onboarding, Quests, and First Region

**Status:** Implemented prototype; live integration checks passed. First-time user acceptance, phone, save/rejoin and multiplayer review remain pending.

## Goal

Help a new player learn the systems naturally and give them a clear reason to explore beyond home.

## Planned work

- Guide the player through hatch, gather, plant, harvest, feed, and return home.
- Add a short quest chain with predictable, server-granted rewards.
- Build the first exploration region with a small number of authored landmarks and gathering points.
- Add a clear region unlock goal tied to companion growth, not payment.

## Verification and exit checks

- First-time playtesters can find the next action without verbal coaching.
- Tutorial steps are skippable or recoverable and do not punish interruption.
- Region navigation is clear on touch and desktop; rewards and gates are understandable.

## Implementation - 2026-10-29

- An owned starter egg beside the home spawn hatches Sprout through a server-validated prompt. Companion creation now follows hatching. Existing saved monsters with growth or a path migrate as hatched; no progress is reset to replay onboarding.
- Eight objectives: hatch, gather, plant, harvest, feed, return home, evolve, claim the Grove bloom. Rewards total 23 coins, paid once per completed step. Existing farm harvest rewards are separate.
- QuestService records facts only from validated server actions; there is no client progress/reward remote. Facts completed out of order are remembered and advance the sequence when earlier steps finish. Repeated events cannot pay twice. Invalid actions do not progress quests.
- A collapsible guide shows the current goal, instructions, reward, and distance to a suggested target. A world marker identifies the egg, available fruit, plot, home, or Grove bloom. Hiding the guide never forfeits progress. Respawning preserves the session's quest facts.
- Return-home progress requires a live character at its owned island after a successful feed. Existing saved growth/path recovers feed/evolve facts. Crops can always be replanted to recover an interrupted harvest objective.
- Expanded the existing Element Grove instead of adding another disconnected island: entrance/unlock sign, bloom sign, Crystal Lookout, Bloom Tree, Ember Stone, and three authored food patches. Region food checks evolution on the server; ordinary starter gathering and farming remain open to every path.
- Quest facts/step and hatched state are serialized with the existing leased farm/monster record. Studio API access remains disabled, so persistence is implemented but not verified across rejoin. This is still a session-only preview in the current Studio configuration.
- Primitive world/creature assets remain prototypes. Final models, textures, lighting, animation and cohesive UI styling stay in Phase 7.

## Evidence

- Rojo build passed. Applied workspace sources through Studio MCP to the current GrowAMonster place.
- Native keyboard egg interaction created Sprout, moved the guide to step 2, and awarded exactly 2 coins.
- An ordinary Play server script checked: repeated/unknown quest events give no extra coins; unevolved Grove-node gathering is rejected; valid starter gathering advances the quest; invalid planting and early harvest do not; valid planting/harvest advance correctly; quest snapshots clone fact data. Crop timer was temporarily shortened for this check and restored.
- A normal client feed request advanced feed/home objectives; a server evolution advanced its objective; native Grove interaction finished the chain at step 9. Coins were exactly 38: 12 starter + 3 harvest + 23 quest rewards. Repeated completed facts did not change coins.
- Inspected desktop presentation. Corrected first-frame zero-size initialization so desktop guidance starts expanded; compact windows start collapsed.

## Outstanding checks

- [ ] User completes the journey from a fresh egg without verbal coaching, using normal crop/growth timings.
- [ ] Phone input/layout, including guide toggling with farm/basket/evolution panels.
- [ ] Rejoin recovery and quest reward atomicity under storage failures (deferred with persistence testing).
- [ ] Multiplayer isolation, region pacing and home navigation (deferred).
- [ ] Review saved-profile migration with real data before release.

Completion behavior: the client removes both the guide and its marker when QuestComplete is true or the saved step is beyond the final objective; the completion panel no longer remains on screen.
