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

- [ ] Phase 3: two-player independent node availability, inventory isolation, and pacing. Deferred at user request on 2026-10-29; does not block Phase 4 implementation.
- [ ] Phase 4: two-player farm ownership, save/rejoin with API access enabled, and phone interaction/layout.

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
