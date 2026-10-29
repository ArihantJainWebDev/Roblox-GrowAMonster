# Design and Technical Decisions

Use this log for choices that materially affect gameplay, player expectations, saved data, or technical boundaries. New decisions should include date, choice, rationale, and any follow-up.

## 2026-10-28 — Planning baseline

- **World:** personal floating islands plus a shared exploration world.
- **Companion:** visible continuous growth with milestone-based form changes.
- **Evolution:** first choice among Fire, Crystal, and Nature; later forms extend the selected path.
- **Food loop:** both wild-food gathering and personal farming; four plots at the start.
- **Art:** colorful, stylized 3D.
- **Monetization:** optional cosmetics; no paid power or paid evolution.
- **Production approach:** Rojo + Git + Luau, with Roblox Studio MCP for inspection and playtesting when available.
- **Project documents:** maintain `GAME_DESIGN.md`, `ARCHITECTURE.md`, `DEVELOPMENT_PLAN.md`, `CHANGELOG.md`, and phase briefs.
- **Implementation boundary:** plan first; do not change gameplay files until the user requests building.

## 2026-10-29 — Phase 2 starter growth loop

- **Choice:** Give each new session 10 starter fruit, grant 10 growth XP per accepted feed, and use 100 XP for the first visible Baby-to-Young stage change.
- **Rationale:** This lets the Phase 2 slice demonstrate continuous growth and one clear milestone before gathering, farming, and persistence are implemented.
- **Follow-up:** Replace test starter food with the real inventory and saved progression in their planned phases; tune the values after playtesting.

## 2026-10-29 — Phase 3 prototype defaults

- Use per-player node cooldowns to avoid emptying the starter route for other players.
- Start sessions with an empty basket; collection replaces Phase 2's free test fruit.
- Prototype values: apple 5 XP/12s, berry 10 XP/20s, golden apple 30 XP/45s; a 50-item total basket cap. These are tunable, not final balance.
- Keep the existing 100-XP Young milestone cap until evolution work. Feeding at the cap must preserve inventory.

## Open design questions

The roadmap records current recommendations for these, but playtests can revise them: exact growth and economy values; passive growth behavior; island expansion; how island visits work; first-release quest length; and whether later systems such as trading or co-op are worth their complexity.

## 2026-10-29 - Phase 5 prototype

- First path at 100 growth; Fire/Crystal/Nature share the 300 cap and Grove rewards. No branch blocks basic gathering/farming.
- Confirmation makes the path permanent for that monster; save/rejoin verification stays deferred at user request.
- Extend the current leased farm record with monster XP/path rather than creating a second competing save. Consolidate persistence before release.
- Production models/textures/animation remain Phase 7.

## 2026-10-29 - Phase 6 onboarding

- Real egg hatching preserves legacy grown/evolved companions.
- Eight objectives grant 23 one-time coins; valid out-of-order actions are remembered.
- Expand Element Grove as the first region. No path blocks ordinary food/farming.
- Deferred persistence/multiplayer checks remain open; production art stays Phase 7.

## 29 October 2026 — Production quality requirement

User requires a proper fantasy world: sculpted terrain, fountain, clouds/sky, architecture, foliage and then custom characters. No flat empty platform world or primitive-sphere substitutes as final art. Inspect free assets when appropriate; verify rights, scripts, scale and style before use. No unverified quality claims or blanket promises to refine later. Use docs/WORLD_PRODUCTION_PLAN.md and docs/QUALITY_GATES.md; user review of real Studio results determines acceptance.
