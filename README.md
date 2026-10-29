# Grow a Monster

The source project for a cozy Roblox creature-raising and exploration game. The active target is a crafted fantasy archipelago above clouds; the gameplay prototype is the foundation for the production plan.

## Project status

Gameplay prototype systems include hatching, gathering, four-plot farming, feeding, growth, three evolution paths and an eight-step quest chain. User playthrough checks are recorded in phase briefs; save/rejoin, multiplayer and outstanding device checks are not yet passed.

Active work: a substantial fantasy archipelago above clouds, following [World Production Plan](docs/WORLD_PRODUCTION_PLAN.md) and [Quality Gates](docs/QUALITY_GATES.md). Current world/creature art and VisualSample are unaccepted prototype studies. Custom models and inspected free assets are valid production routes; no external production assets have been selected yet.

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

Phase 6 prototype: hatch Sprout at your home egg and follow the quest guide. Tap its heading to show/hide instructions. Markers suggest the next target. The eight-step journey ends at Element Grove. Save/rejoin checks remain deferred while Studio API access is disabled.
