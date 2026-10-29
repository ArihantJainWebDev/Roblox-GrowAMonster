# W1 Blueprint and Feasibility — Approved Layout 02

Status: User approved the layout and gateway-based home access on 29 October 2026. Asset pipeline proof and device/capacity targets remain incomplete; W1 as a whole is not closed.

See WORLD_BLUEPRINT_V2.png. WORLD_BLUEPRINT_V1.png is superseded and retained only as history. It is a route/zone diagram, not finished concept art or a precise terrain footprint. No existing gameplay terrain was replaced.

## Layout

A compact shared fountain hub anchors the walkable orchard/Grove exploration loop. One Home gateway routes each player to their owned floating island in a separate residential zone within the same server. Each home has a Return to Hub gateway. Home count is not tied to physical entrances on the hub. No fixed six-player limit is approved; capacity is determined by representative multiplayer performance tests.

Residential slots may be reassigned between sessions. Account-owned state, not the physical slot, identifies a player's home. No cross-server teleport or separate private server is required for this approved layout. The residential zone is spatially separate; distance or streaming is not a security boundary. Server ownership checks remain mandatory.

Visitors use a destination menu when visits are allowed. The open-versus-owner-controlled visit policy is not yet approved; default implementation must not silently assume unrestricted access. Visitors cannot plant, harvest, spend, hatch or alter another owner's data. Client requests never supply an unchecked destination coordinate. The server resolves the authenticated player's home or an allowed visit, validates a live character and destination availability, throttles travel and places avatar/companion safely. Returning always reaches a designated hub landing clear of the gateway trigger.

Home relocation must move spawn, egg, plots, markers and distance-check anchors together. Gateway arrival needs a safe landing, a short retrigger guard, clear input feedback and recovery if the home is unavailable. Companion placement and quest guidance must update after travel. Personal collection cooldowns/inventory remain independent; shared orchard and Grove stay walkable and social.

| Zone | Proposed footprint | Ground/elevation intent | Contents |
|---|---|---|---|
| Hub | Approximately 220 x 220 studs | Main reference level, proposed Y420 | Fountain courtyard, terraces, hatchery pavilion, orchard and home wayfinding |
| Each home | Approximately 100 x 110 | Near hub level, varied by 0–20 studs | Four farm beds, egg nook, seed interaction, gateway landing, planted edges |
| Orchard | Approximately 300 x 220 | Rise 20–60 above hub | Three terraces, fruit clearings, spring/stream, waterfall, canopy route |
| Grove | Approximately 240 x 220 | Rise 50–90 above hub | Bloom, crystal lookout, flowering landmark, evolution-aware food patches |

These dimensions are design proposals. They must be tested at avatar scale before acceptance; they are not hard-coded implementation values. Main paths 12–16 studs, secondary paths 8–10, bridges 10–12. Prefer graded paths and short stairs; no required precision jumps. Measure actual walking times in a blockout: aim for a useful interaction within 15 seconds of arrival and clear landmark-to-landmark routes of roughly 20–45 seconds. Distances must serve content rather than inflate the world.

## Opening view and journey

Open at the player's egg nook with a clearly marked Return to Hub gateway; arrival in the shared hub frames the fountain and orchard route. After hatching, the route guides the player through hub to orchard fruit, back to the four-plot home garden, then feeding/evolution and the Grove. Fountain, orchard canopy and crystal lookout are distinct navigation silhouettes. Two optional discoveries: a spring-side food cache and an overlook bloom; exact rewards require a server-side implementation brief, not paid access.

The first fully finished area is a roughly 70 x 70 fountain courtyard: fountain basin/source/water effects/audio, coherent paving, two planted terraces, a finished tree family, seating, lanterns and a hatchery architectural frontage. Review it from normal player height and close views before expanding its asset kit.

## Vertical section, sky and terrain

Proposed hub Y420 creates room for floating cliff undersides. Irregular rock shells descend beneath walkable terrain. Exact cloud height is a visual test, not an assumed engine setting: evaluate Terrain Clouds, atmosphere, horizon and distance meshes from hub, highest lookout, below-island view and fall recovery. No ground plane may be visible in the production playthrough. Distinguish Studio grid rendering from real geometry when auditing the current gray background. This task does not claim that defect is fixed.

Spring water must have a believable source and terminate convincingly into cloud cover. Final island edges, overhangs, accessible routes and fall recovery must be tested together. Never use fog to mask unfinished terrain.

## Tool and asset findings

- Roblox Studio supports Creator Store search and asset insertion through the connected tools. Two free candidates imported into ServerStorage.AssetReview successfully, proving insertion access, but both failed content inspection and were removed. This is not a usable production-asset proof.
- Blender was not found on PATH or in the standard C:/Program Files/Blender Foundation location. Other locations were not exhaustively searched. No working custom modeling/export pipeline is established yet.
- No final fountain, cliff, architecture, vegetation or creature asset is selected.
- Roblox candidate listings and script/mesh counts are recorded in ASSET_SHORTLIST.md. Do not confuse listing claims with inspected contents.
- Kenney Nature Kit is listed CC0 on its official page; useful as a licensing/import reference, but its simple style is not automatically suitable for this project's required visual standard. https://kenney.nl/assets/nature-kit
- Poly Haven's official license states its assets are CC0; photogrammetry assets may require style adaptation and optimization. No individual asset is approved. https://polyhaven.com/license

## Performance and acceptance proposals

Proposed baseline: 30 FPS minimum on an agreed midrange phone, 60 FPS target on the development PC, at a player count established by load testing; avoid sustained memory growth across a 15-minute route test. Real device models, loading/memory budgets and scene-density limits must be recorded after a representative asset benchmark. These are proposed targets, not measured results.

Layout review passed. Before W1 can close: final supported device targets; at least one visually suitable, inspected fountain/architecture/foliage/rock route; a repeatable mesh import or Creator Store asset workflow with provenance and material/collision review. Critical asset feasibility remains open. Do not start detailed construction with the rejected kits.
