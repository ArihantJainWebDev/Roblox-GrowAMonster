# Grow a Monster

The source project for a cozy Roblox creature-raising and exploration game. The current build target is a small floating starter island; gameplay systems will be added in the phases documented in [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md).

## Project status

- Planning baseline is recorded in `GAME_DESIGN.md` and `ARCHITECTURE.md`.
- Phases 1 and 2 are complete: the server-validated feeding and growth loop, recognizable following Sprout, and persistence-ready growth snapshot are in place. Production art and saved progression remain future work.
- The folder uses Rojo and Git. Studio's mapped server script was verified against the local source. A one-time Rojo timeout appeared after sync, but the synced project ran successfully.
- Phase 3 adds food bushes, individual respawn timers, a food basket, and selected-food feeding. Multiplayer pacing and touch review remain.
- Farming, evolution, persistence, and production-ready art are not implemented yet. Current sessions begin with an empty basket; collect fruit before feeding.

## Prerequisites

- Roblox Studio
- Git
- Rokit, which installs the project-pinned Rojo CLI
- The Rojo 7 Studio plugin, using the same major version as the CLI

## Project layout

```text
src/
  server/   Server-owned world bootstrap and game services
  shared/   Shared configuration and types
  client/   Client presentation and input controllers
docs/
  phases/   Phase goals and exit checks
```

`default.project.json` maps these source folders into Roblox services. The server bootstrap creates a temporary, simple floating island at runtime so the initial place has a clear spawn area.

## Local workflow

1. Open this folder as a Rojo project.
2. Start the Rojo server.
3. Open the intended Studio place, connect the Rojo plugin to the local server, and sync project content.
4. Use Studio Play to inspect the result and check Output before implementing the next phase.

See `docs/phases/PHASE_1_PROJECT_FOUNDATION.md` for the current scope and exit checks. Keep the project design and changelog current as implementation decisions are made.

Phase 4 farming is available: select a seed in your home panel and use a plot to plant/harvest. Apple saplings take 30 seconds; berries take 60. Studio currently has API access disabled, so farms show a session-only preview. Phase 4 save/rejoin, multiplayer and phone review remain pending.

Phase 5 prototype: reach 100 growth, preview and confirm Fire/Crystal/Nature, then feed to 300. Element Grove lies beyond the shared gathering island and offers evolved players 2 berries every 60 seconds. Final art stays in Phase 7. Save/rejoin and multiplayer verification are deferred.
