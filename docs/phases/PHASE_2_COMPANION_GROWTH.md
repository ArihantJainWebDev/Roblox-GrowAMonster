# Phase 2 — Companion, Feeding, and Growth

**Status:** Planned; depends on Phase 1.

## Goal

Make the companion the emotional center of a small playable slice: players can see it, feed it, and understand its growth.

## Planned work

- Add a temporary starter companion representation with readable reactions and stage changes.
- Define configurable food values and growth milestones.
- Add server-owned feeding and growth state; display inventory and progress clearly.
- Explain growth without hunger decay, offline punishment, or hidden requirements.

## Verification and exit checks

- A player can feed valid food and observe the correct growth change and feedback.
- Invalid, duplicate, or impossible requests cannot create growth or items.
- Growth state is ready to persist through the data layer before the feature is considered complete.
- A new player can tell what the next milestone is.
