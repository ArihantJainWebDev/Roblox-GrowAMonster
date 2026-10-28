# Grow a Monster — Architecture

**Status:** Technical baseline accepted; implementation is underway, with phases recorded in `DEVELOPMENT_PLAN.md`.
**Stack:** Roblox Studio, Luau, Rojo, Git.

## 1. Guiding rules

- Keep source in a normal Rojo project and use Studio for scene work, asset inspection, and playtesting.
- Keep game rules and progression authoritative on the server. Clients render state and ask to perform actions.
- Put tunable balance in shared configuration modules; keep secret validation and persistence on the server.
- Prefer small services with clear ownership over a large all-purpose script.
- Treat saves and remote requests as untrusted input; validate types, bounds, ownership, rate, and current state.
- Do not begin coding against a guessed folder structure; inspect the supplied project first and preserve any existing work.

## 2. Proposed source tree

```text
GrowAMonster/
├── src/
│   ├── client/
│   │   ├── controllers/       # Input, HUD, inventory, farm and companion presentation
│   │   └── ui/                # Reusable UI components and screens
│   ├── server/
│   │   ├── services/          # Player data, plots, food, growth, quests, world
│   │   └── main.server.luau   # Service startup and dependency wiring
│   └── shared/
│       ├── config/            # Food, crops, growth, evolution, world tuning
│       ├── remotes/           # Remote names/contracts, if project conventions warrant
│       └── types/             # Shared Luau types and constants
├── assets/                    # Source art/audio only when appropriate to the pipeline
├── docs/                      # Design, architecture, roadmap, phase plans and decisions
├── tests/                     # Add only when requested or agreed for a specific phase
├── default.project.json       # Rojo mapping
├── aftman.toml                # Optional pinned tool versions, if Aftman is adopted
├── .gitignore
└── README.md
```

The exact layout and tooling will be reconciled with the provided folder before adding anything. Roblox place files and Studio-managed assets may remain in Studio; document how they map to source rather than duplicating opaque binary assets in Git without a reason.

## 3. Runtime responsibilities

### Server services

- **PlayerDataService:** load, validate, version, save, and release player profiles; handle retry and session locking using a mature, documented persistence approach.
- **IslandService:** allocate and release a player's island, enforce owner access, and restore island state from profile data.
- **FarmService:** validate plot ownership, planting, crop timestamps, harvest readiness, yields, and seed costs.
- **FoodService:** maintain authoritative inventory and validate collection/feed requests.
- **MonsterService:** own growth points, stages, feeding, bond reactions, and companion state replication.
- **EvolutionService:** validate an eligible milestone and chosen branch, then persist the choice and apply configured form.
- **WorldService:** manage authored gathering nodes, cooldowns, region gates, and server-validated rewards.
- **QuestService:** grant only configured rewards for server-confirmed actions.
- **EconomyService:** validate soft-currency awards and spends; avoid client-supplied balances.

Services may start together as a simpler initial implementation if boundaries stay clear. Split or combine modules based on actual complexity, not the diagram alone.

### Client controllers

- **InputController:** map touch and keyboard/mouse input to interaction intents.
- **UIController:** display onboarding, inventory, farm prompts, growth, quests, and evolution confirmation.
- **World/Companion presentation:** animate replicated state and local effects without deciding rewards.
- **IslandController:** display owner farm state and request authorized actions.

## 4. Data model (logical, not a serialization contract)

```text
Profile
  schemaVersion
  coins
  inventory: { foodId -> count, seedId -> count }
  monster: { speciesId, growthXP, stageId, evolutionPath, bondLevel? }
  island: { unlockedDecorations, plotStates[4+] }
  quests: { completedIds, currentProgress }
  settings: { tutorialCompleted, accessibility options? }
```

Plot state stores a crop identifier and planting time, not a live Instance reference. Derived readiness is calculated from server time and crop configuration. Never persist transient world objects, client instances, or unvalidated tables. Version migrations must be explicit and safe; default missing fields and clamp invalid values.

## 5. Network contracts and validation

Clients may request actions such as collect node, plant seed, harvest plot, feed monster, choose evolution, and claim quest. Each request must be checked for:

1. Correct types and known identifiers.
2. Player owns or can reach the target and it is in the expected state.
3. Cooldown, quantity, distance, and rate limits.
4. Sufficient inventory/currency, with spend and reward applied atomically on the server.
5. Idempotency where duplicate requests could otherwise double-grant.

Replicate compact snapshots or changed fields; don't send the full profile for every action. Show responsive local feedback only when it can reconcile with the authoritative result.

## 6. World representation

- Author the starter hub and first region as Studio content, with stable named folders/instances for interaction points.
- Give gather nodes stable IDs and configuration-driven food/cooldown values. A node becomes available based on server state.
- Allocate personal islands from a bounded template or controlled layout. Do not trust client-provided island positions or ownership.
- Keep initial visual assets low-complexity and readable on mobile. Add streaming/optimization decisions when the first map is measured, not preemptively.

## 7. Persistence and operational safety

- Use Roblox-supported server persistence APIs through a profile/session pattern appropriate to current platform guidance.
- Save on meaningful state changes with coalescing, plus periodic and shutdown saves; handle throttling and retries without claiming a save succeeded when it did not.
- Protect against two servers editing the same player profile concurrently. Surface load failure and avoid overwriting unknown data with defaults.
- Do not log private profile contents or secrets. Never store payment credentials or personal contact information.
- Treat monetization receipts as server-verified and implement purchase grants only in the later monetization phase.

## 8. Development and validation workflow

1. Git tracks source and docs; commits are small and phase-focused.
2. Rojo sync maps source to Studio. Validate the mapping before syncing and keep generated/editor data out of source control.
3. Use Roblox Studio MCP when connected to inspect the right place, run controlled play sessions, and check output. Confirm the target Studio place before modifying it.
4. Perform phase-appropriate manual playthroughs on touch and desktop. Do not add automated tests unless requested or explicitly agreed for a particular phase.
5. Record decisions and material changes in `docs/DECISIONS.md` and `CHANGELOG.md`.

## 9. Known technical risks

| Risk | Planned response |
|---|---|
| Data loss or duplicate profiles | Use session-aware profile ownership, versioned migrations, retry handling, and restart playthroughs before release. |
| Exploited remotes create items or currency | Server owns reward calculations and validates state, ownership, distance, and rate. |
| Island allocation grows costly | Start with a small template and bounded player layout; measure instance count before expanding. |
| Too many systems before the fun is proven | Build and review one vertical slice before adding secondary systems. |
| Unclear tradeoff between offline growth and active play | Keep absence non-punitive; test passive progress as a small capped bonus only if needed. |
| Platform/API changes | Check official Roblox documentation when implementation reaches the affected API. |
