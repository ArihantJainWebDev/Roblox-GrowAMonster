# Phase 1 — Project Foundation and Playable Skeleton

**Status:** Local scaffold and Git repository prepared; Studio sync and play inspection are pending confirmation of the target place and Rojo setup.

## Goal

Establish a safe, repeatable Studio-to-source workflow and a clean playable skeleton in the confirmed Roblox place.

## Planned work

- Inspect the supplied folder, Git state, existing Rojo mapping, and Studio place; preserve existing work. **Done:** folder was empty except for planning docs; Git has been initialized locally.
- Adopt or complete a minimal Rojo mapping and Luau startup structure only after inspection. **Prepared locally:** `default.project.json` and a server bootstrap.
- Define shared configuration/types and service startup conventions at the smallest useful scale.
- Create a simple readable test spawn and establish how Studio content and source content are mapped. **Source prepared:** a temporary floating-island spawn area is created by the server bootstrap.
- Record tool versions and setup steps in the project README.

## Verification and exit checks

- Rojo project mapping can be validated and synced to the intended place.
- The player can enter the test area; startup has no unresolved errors.
- The folder structure is documented and Git ignores generated/local-only files.
- The target Studio place has been confirmed before any mutation.

## Current blocker

Rokit and Rojo are not installed; Rojo 7.7.1 is pinned in `rokit.toml`. The connected Studio instance is named `Place1`. Before the Studio place is changed, confirm that `Place1` is the intended project place. After that, set up Rokit, sync the project, and inspect the spawn area in Play mode.

## Out of scope

Full farm, economy, creature evolution, production world art, monetization, and data schemas beyond what Phase 1 needs.
