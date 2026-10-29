# Grow a Monster — Development Plan

**Status:** Gameplay prototype baseline accepted for continued development; release checks remain open. Active work is the fantasy world/art production plan in `docs/WORLD_PRODUCTION_PLAN.md`, starting at W1. No production-art stage is accepted.
The order favors a small playable loop early, then reliable progression, content, polish, and release readiness.

## Release shape

- **Prototype:** one end-to-end gather, plant, harvest, feed, and visible growth loop.
- **First playable:** saved player island, shared starter area, onboarding, and first elemental choice.
- **First release candidate:** three elemental paths, representative evolved forms, stable saves, mobile/desktop UX, enough goals for repeat sessions, and cosmetic-only optional monetization if approved by quality review.

## Phases and exit checks

| Phase | Focus | Exit check |
|---|---|---|
| 0 | Project handoff and planning baseline | Existing files and tools reviewed; design and scope recorded; user agrees the baseline is ready for implementation. |
| 1 | Rojo/Git foundation and playable skeleton | Project syncs to the intended Studio place; player can spawn in a readable test area with clean startup/output. |
| 2 | Companion, feeding, and growth | Readable companion feedback and milestone UI; valid feeding changes server-owned growth; invalid requests grant nothing; growth data is persistence-ready. |
| 3 | Food inventory and wild gathering | A small set of server-validated food nodes can be collected and respawn; inventory feedback is clear. |
| 4 | Personal island and four-plot farming | Each player can plant, wait, harvest and feed; ownership is enforced; crop state survives rejoin. |
| 5 | Evolution and first exploration unlock | Fire, Crystal, and Nature choices work and persist; choice feedback is clear; paths are comparable. |
| 6 | Onboarding, quests, and first region | A new player can finish the tutorial loop and find a next goal without assistance; first region feels worth exploring. |
| 7 | Fantasy world and art production | Follow W1–W4, C1–C2, U1 and R1 in docs/WORLD_PRODUCTION_PLAN.md; all quality gates require evidence and user review. |
| 8 | Release readiness and optional cosmetics | Save/rejoin, error recovery, moderation/platform review, performance and purchase handling are checked; core progression is free. |
| 9 | Post-release expansion | Add new regions/crops/forms from player feedback, with backward-compatible data migrations and scoped releases. |

Detailed phase briefs live in `docs/phases/`. A phase is complete only when its exit checks are reviewed in the actual project and its docs/changelog are updated.

## Scope guardrails

### Required for first release

- One starter companion, a few growth stages, and one meaningful choice among Fire, Crystal, and Nature.
- Four-plot personal farm, several crops/foods, one shared hub and one nearby region.
- Basic quests/onboarding, inventory feedback, and reliable persistent progression.
- Companion and island presentation, touch and desktop usability, and safe multiplayer boundaries.

### Candidates for later

- More species, regions, crop families, decoration sets, and branch evolutions.
- Visiting friends' islands and co-op goals after permissions, persistence, and griefing protections are designed.
- Trading, combat, breeding, leaderboards, clans, and seasonal events only after the core loop justifies them. None is a first-release dependency.

## Working cadence

1. Inspect project state and relevant Studio place before each phase.
2. State the intended change in plain terms and keep each implementation slice reviewable.
3. Implement only the agreed phase scope; keep balance values configurable.
4. Verify the relevant user path in Studio and on target input modes; capture issues rather than silently expanding scope.
5. Update the phase brief, `GAME_DESIGN.md` if a design decision changed, `ARCHITECTURE.md` if boundaries changed, and `CHANGELOG.md`.

## Decisions that need later playtest evidence

- Exact growth thresholds, crop times/yields, food values, node density, island expansion pace, and quest rewards.
- Whether a small capped passive growth bonus improves the loop.
- How much customization fits the first island and which cosmetics are desirable.
- Whether island visiting or co-op adds enough value to justify the additional safety and persistence work.

## Ready-to-build checklist

- [x] User has reviewed this design baseline and requested implementation.
- [x] Confirmed the folder is a Rojo/Git project and preserved existing files.
- [x] Confirmed the intended Roblox Studio place before editing/syncing.
- [x] Completed Phase 1's smallest vertical slice and updated `CHANGELOG.md`.

## Deferred verification

- [x] Phase 3 multiplayer functionality: user reports three-player testing works on 2026-10-29. Detailed pacing/performance measurements remain open.
- [x] Phase 4 multiplayer functionality: user reports the three-player game works, including the pre-W4 farm flow.
- [ ] Phase 4 remaining: save/rejoin evidence and phone interaction/layout.

## 2026-10-29 progression update

- User confirmed Phase 4 farming checks work. Save/rejoin and multiplayer testing explicitly deferred at user request; phone farming review remains pending.
- Phase 5 implementation underway: first elemental choice at 100 growth, equal growth cap of 300, Element Grove reward interaction. Save/rejoin remains deferred, not passed.

Phase 5 evolution prototype implemented; live selection guards and post-evolution feeding passed. Pending: Grove playthrough, phone input/layout, multiplayer isolation, and deferred save/rejoin. Final art stays in Phase 7.

## Phase 6 update - 2026-10-29

User confirmed Phase 5 gameplay works. Phase 6 onboarding/region prototype is implemented; live chain checks passed. Pending: first-time user playthrough, phone layout/input, saved-profile recovery and multiplayer. Previously deferred checks remain open; production art stays Phase 7.

Phase 7 visual study started with the recommended Sunlit Sky Gardens direction. Review the actual Studio sample before extending the style. Detailed custom meshes, creature rigging/animation and final materials remain outstanding.

## Active plan precedence — 29 October 2026

The detailed world/art production plan and quality gates supersede the generic polish approach and the small visual study. Historical prototype implementation entries are not visual approval or release acceptance. Deferred checks remain open; the current primitive sample is unaccepted. See docs/ASSET_REGISTER.md for required asset sourcing.

W1 proposal 01: docs/world/WORLD_BLUEPRINT_V1.png and W1_BLUEPRINT.md created. Asset shortlist recorded; two inspected imports rejected and removed due to unrelated scripts. Layout awaits review; critical asset feasibility remains open. No detailed production world construction begun.

## Layout approval — 29 October 2026

User approved layout 02 with Home/Return-to-Hub gateways and a separate same-server residential zone. Fixed home docks and the six-player proposal are superseded. Shared exploration remains walkable. W1 asset feasibility and tested capacity/device targets remain open; see docs/world/WORLD_BLUEPRINT_V2.png. This decision supersedes the earlier proposal-01 awaiting-review entry.

W1 asset comparison pass 02: nine actual imports inspected and viewed; architecture/secondary-rock candidates retained for review, no production assets accepted. See docs/world/ASSET_INSPECTION_PASS_02.md. Distant Edit review shelf is not part of the approved production layout.

W1 feasibility: original mesh generation works in Studio. Authored fountain/cliff/tree studies and source geometry export prepared; see docs/world/ORIGINAL_ASSET_STUDY.md. Original asset visual review remains open. This is an authoring proof, not W2 terrain implementation or accepted world art.

Courtyard review build assembled; see docs/world/FOUNTAIN_COURTYARD_REVIEW.md. Runtime visual acceptance is blocked by disabled Editable Mesh / Image APIs, confirmed by an ordinary LocalScript probe. Audio playback passed. User notified of the required setting; no asset upload performed.

Courtyard runtime blocker resolved: user enabled Mesh / Image APIs; per-piece mesh freezing fixed memory limits. Desktop Play sample renders correctly with moving effects/audio. Await user visual acceptance; full world, device/performance and multiplayer/persistence checks remain open.

## W2 implementation — 29 October 2026

W2 foundation is in progress: real floating terrain, orchard/Grove routes, integrated fountain hub, layered clouds and separate gateway homes are implemented. Functional gateway/recovery and route support checks passed; W2 visual acceptance, full-loop walkthrough, multiplayer, persistence and device/performance checks remain open. See docs/world/W2_FOUNDATION.md for exact evidence and defects. Historical prototype completion does not mean this production stage is complete.

## W3 courtyard construction — 29 October 2026

W3-garden-01 adds expanded paving, pavilion masonry/ornament and layered planting to the actual shared fountain hub. Construction pass awaits user visual review and device checks; it is not an accepted completed stage. See docs/world/W3_COURTYARD.md. W2 and R1 open requirements remain tracked.


User route review — 29 October 2026: screenshots exposed bridge/terrain joins and trail-marker defects. Corrected under W2 build sky-foundation-09 with rock trails and measured landings; three no-jump crossings passed. Close visual review remains open, then W3 courtyard approval precedes W4 rollout. See docs/world/W2_FOUNDATION.md.


## W4 environment rollout — 29 October 2026

User reports three-player multiplayer working and authorizes W4. Environment pass implemented across orchard, Grove, gateways, wild food and all four personal farm beds. Seed shop now opens at a bench; crop spheres are replaced by three-stage plant models. See docs/world/W4_WORLD_BUILD.md for exact checks and remaining visual/device/W4 multiplayer regression gates. This is not accepted stage completion.

## Authorized next sequence — 29 October 2026

User approves correcting reported W4 defects, then proper creatures and deeper gameplay. Active order: W4 grounding/sign/crop correction → C1 baby mesh pipeline and full family → C2 animation/behavior → G1 monster-led exploration → U1 → R1. See docs/creatures/C1_CREATURE_BRIEF.md and docs/gameplay/G1_MONSTER_EXPLORATION.md. Do not substitute ongoing scenery additions for starting C1. G1 is a dedicated milestone; its detailed trial/garden proposal is not implemented content.

## C1 baby implementation — 29 October 2026
Native creek correction and first textured baby/rig are implemented. See docs/creatures/C1_BABY_IMPLEMENTATION.md for evidence and limits. C1 remains open for actual-model review, egg, young and three elemental meshes; C2 finished animation, G1 expanded gameplay and R1 regression remain outstanding. Existing stages temporarily reuse the baby mesh.

## C2 following implementation

User review update: corrected baby/tail appearance and current walking/turning/stopping are accepted as good enough for this stage. Next: seed egg and young Sprout, then elemental family forms. Full animation, multiplayer/device and persistence gates remain tracked separately; historical awaiting-review statements below are superseded for this desktop pass.
Tail intersection correction and first natural-following pass implemented. Home walks/corner/stop, stationary rotation and sloped bridge checks passed; see docs/creatures/C2_FOLLOWING.md. User review, multiplayer/device regression and finished C2 animation remain open.

## Seed egg and young form implementation
Seed egg mesh/nest, hatch shell effect and distinct young anatomical variant implemented. Native hatch and feed-at-99 transition passed. See docs/creatures/C1_EGG_YOUNG.md. User visual review remains open; next production work is Fire/Crystal/Nature forms, then remaining C2 and G1. Earlier egg/young-unbuilt entries are historical.
