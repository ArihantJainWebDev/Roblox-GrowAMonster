# Grow a Monster — Development Plan

**Status:** Phases 1 and 2 complete. Phase 3 solo/device checks passed per user; multiplayer deferred. Phase 4 farming implemented; persistence, multiplayer, and device validation pending.
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
| 7 | Content, social play, and polish | Target devices have legible controls; presentation is cohesive; social boundaries and island behavior are settled. |
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
