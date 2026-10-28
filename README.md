# Grow a Monster

The source project for a cozy Roblox creature-raising and exploration game. The current build target is a small floating starter island; gameplay systems will be added in the phases documented in [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md).

## Project status

- Planning baseline is recorded in `GAME_DESIGN.md` and `ARCHITECTURE.md`.
- Phase 1 is complete: the project builds with the pinned Rojo 7.7.1 CLI, syncs into the intended Studio place, and the floating spawn was inspected in Play mode.
- The folder uses Rojo and Git. Studio's mapped server script was verified against the local source. A one-time Rojo timeout appeared after sync, but the synced project ran successfully.
- No production gameplay loop is implemented yet.

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
