# Phase 5 — Elemental Evolution and Exploration Unlock

**Status:** Implemented prototype; validation in progress. Save/rejoin, multiplayer, and phone checks are pending.

## Goal

Deliver the defining choice among Fire, Crystal, and Nature and connect growth to a new exploration goal.

## Planned work

- Define the first milestone and show requirements before the choice.
- Implement the three branches with comparable progression value and clear visual identity.
- Persist the chosen path and apply its companion presentation.
- Add one small, non-exclusive exploration interaction per path only if each can be supported fairly.

## Verification and exit checks

- Each path is understandable before selection and is saved across rejoin.
- No branch is required for basic food, farming, or core progression.
- Evolution cannot be granted early or repeated through remote abuse.
- The choice feels exciting and fair in a first-time playthrough.

## Implementation — 2026-10-29

- At 100 growth, a choice panel explains equal progression, previews Fire/Crystal/Nature descriptions, and requires a separate confirmation. Choice is permanent for this monster once saved. Studio preview resets on restart while API access is disabled.
- MonsterService owns branch choice, validates living character, loaded/available farm profile, threshold, allowed path, and no existing choice. No yield occurs through selection. Display attributes are mirrors only.
- Fire becomes Ember Sprout, Crystal becomes Crystal Sprout, Nature becomes Bloom Sprout. Prototype body/crest/belly colors and Crystal crest shape/material distinguish paths. Final forms, detailed textures and animation remain Phase 7.
- All paths continue feeding from 100 to 300 growth with equal food XP. No paid or branch-specific progression bonus. At 300, food is retained until future progression content exists.
- Element Grove is a small shared island beyond the gathering area. Its bloom gives any evolved path two berries per 60-second personal cooldown, with living-character, distance, capacity, and server-owned path checks. Unevolved players can walk there but cannot claim its reward; normal gathering/farming stays available.
- Monster growth and path are serialized into the existing leased farm save, and restored/clamped on profile load. Food inventory is still session-only. A unified profile service and full recovery testing remain needed before release.

## Verification

- Rojo build passed; source applied to the connected GrowAMonster Studio place through MCP.
- Ordinary live server verification passed for all three branches: early/invalid evolution rejection, exact valid selection, repeated/switch requests rejected, equal 300 cap, exploration unlock, matching presentation color, snapshot path, and restore clamping of invalid values/path.
- A client evolution request chose Fire, then feeding an apple moved growth from 100 to 105 and apples from 2 to 1.
- Desktop evolution panel inspected; wording shortened after spotting clipped text. Final phone/touch layout still needs review.
- Save/rejoin testing remains deferred at user request; Studio API access is disabled. Multiplayer/isolation and first-time playthrough acceptance remain pending. This phase is not complete.

- Native E prompt at Element Grove granted exactly two berries to the evolved player. Fresh Play session restored after checks; normal-duration first-time gameplay and cooldown/isolation review remain pending.
