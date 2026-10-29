# Fantasy World Production Plan

Status: Active production specification, 29 October 2026. Environment comes first; creature production follows. No world/art milestone is accepted yet.

## Authority and current baseline

This document supersedes the previous generic Phase 7 polish brief and the small-island visual target. GAME_DESIGN.md remains authoritative for gathering, farming, growth, evolution and cosmetic-only monetization. This plan governs world and art production; QUALITY_GATES.md governs acceptance. New user decisions must be recorded here before changing scope.

Phases 1–6 provide the accepted gameplay prototype baseline. They are not evidence of a finished world or release readiness. Save/rejoin, multiplayer and outstanding device checks remain open. The generated concept boards are references, not deliverable assets or proof of achievable fidelity. Sunlit Sky Gardens is the starting palette/reference, not a fully approved production result. The user requires a substantial, coherent fantasy world rather than flat toy-like platforms.

The current VisualSample and primitive companion are unaccepted studies. More spheres, recolored blocks, a staged screenshot or a generated image cannot satisfy a production-art gate. Basic parts may be used structurally where appropriate; final organic forms need intentionally authored geometry and materials.

## Required player experience

A suspended fantasy archipelago above a convincing cloud layer: sculpted land, visible cliff structure, mature vegetation, water, architecture, connected routes, destinations and rewarding exploration. Warm sunlight, airy distance and restrained magic; detailed enough to feel crafted while legible on a phone. Friendly creatures do not require a childish environment.

The opening view must establish scale, show the fountain/hub landmark and imply reachable destinations. The environment must work from normal player height and while moving, not only from a chosen aerial angle.

## First production-world scope

| Space | Required contents and purpose |
|---|---|
| Central sky-garden hub | Modeled stone fountain and plaza; sculpted planted terraces; hatchery architecture; benches, lamps and coherent wayfinding; readable routes to homes, orchard and Grove. |
| Personal home island | Irregular terrain and cliff underside, a proper hatch nook, exactly four integrated farm beds, storage/seed-shop interaction presentation, Home/Return-to-Hub gateway landings and coherent boundaries. |
| Orchard and gathering landscape | Varied elevation, authored fruit patches, winding paths, canopy and clearings, a small stream/spring, rock formations, at least two optional discoveries with understandable rewards. |
| Element Grove | Distinct crystal, flowering and warm-stone landmarks within one coherent region; evolution requirement communicated before the journey; existing bloom reward and food patches integrated into the landscape. |
| Connections and vistas | Short purposeful bridges, stairs and graded paths, safe readable edges, resting/view points, distant scenery suggesting a larger sky world. Background scenery must not imply playable routes where none exist. |

The world is not limited to the three old flat platforms. Its footprint and elevations will be set in the blueprint at avatar scale. Larger empty land is not a substitute for authored routes and content. All required spaces must be complete for world acceptance; the finished courtyard is the first quality checkpoint, not the final scope.

## Stage W1 — Blueprint and feasibility

Deliver: top-down map, elevation/section sketches, key camera views, measured avatar-scale paths and destination list. Define walkable versus background areas, quest routes, farm locations, interaction positions and multiplayer home allocation. Use the approved Home gateway and separate same-server residential zone; no fixed home docks or home-to-hub bridge ring. Keep the shared exploration world walkable. Server capacity is not fixed at six and must be established by performance testing. Preserve gameplay IDs/state while changing transforms.

Create an asset breakdown for fountain, architecture, cliff kit, bridges, trees, shrubs, flowers, rocks, crops, egg and monsters. Inspect available modeling/import tools and prove one authored or sourced mesh can enter Studio with correct scale, materials and collision. Do not promise asset quality before this proof.

Exit: map and references reviewed by user; asset route established for every critical category; unresolved dependencies explicitly listed. No detailed world construction on an unreviewed layout.

## Stage W2 — Sky, clouds and terrain foundation

Remove or disable unwanted template baseplate geometry and template props in the actual place, not only rely on a runtime visibility toggle. Audit the gray surface reported by the user: distinguish a real Baseplate from Studio's editor grid before selecting a fix. The play camera must never see an unintended ground plane beneath the islands.

Establish sky, lighting, atmosphere, cloud horizon and layered depth first. Evaluate Roblox Terrain clouds/atmosphere and cloud meshes/particles for the required above-cloud appearance; choose the combination by viewing it at island height. A default sky alone is insufficient. Avoid excessive fog that hides unfinished land. Falling should trigger reliable recovery before exposing template ground or an endless drop.

Use Roblox Terrain where it serves sculpted ground, water and organic slopes; use authored mesh cliff sections/rock shells where floating undersides, overhangs and clear silhouettes require them. Avoid unsupported claims that one terrain tool alone will create the concept. Build irregular island outlines, vertical strata, slopes, terraces, cliff shoulders and tapered undersides. Place spring/waterfall sources and their cloudward termination deliberately.

Exit: route/collision and edge tests pass; no coplanar flicker, cracks, flat block undersides or unintended ground visible from routes, overlooks and falling recovery; clouds/sky read convincingly above and below the world.

## Stage W3 — Finished fountain courtyard

Build one complete representative area: custom/sourced fountain, paving with readable edges, terrace/cliff treatment, one finished tree family, layered shrubs and flowers, hatchery facade/structure, lamps and furnishing. Fountain requires a basin, believable source and water path, ripple/splash effects and positional sound. No neon block as a fountain substitute.

Use proper meshes, UVs and consistent materials. Lighting, sky and clouds are included in the review. Check silhouettes, texture density, contact with the ground, normal player scale and night/dark pockets if applicable. Verify live play at several angles, including close view. Capture real Studio screenshots/video and compare to the reference.

Exit: user approves the actual result as the world-quality benchmark. If it falls short, identify the specific asset/workflow limitation and replace or rework it here. Do not extend a rejected kit across the map.

## Stage W4 — Complete the world

Extend the approved material/asset kit across the hub, home, orchard, Grove and all connections. Include foreground, midground and distant compositions, natural variation and purposeful open spaces. Add water, waterfalls, landmarks, lights, audio zones, vegetation and optional discoveries. Connect all gathering/farming/quest interactions to the finished scenery and check every objective target after relocation.

Finish all four farm plots and crop growth/harvest appearances, not a single example bed. Show ownership clearly. Replace presentation of the temporary seed shop and giant labels with designed environmental interactions. Preserve server validation and private inventory boundaries.

Exit: all required spaces meet the courtyard benchmark during a continuous normal-camera walkthrough. No temporary props, unexplained empty pads, unfinished transition zones or repeated oversized labels remain in the reviewed route.

## Stage C1 — Creature and egg production

After environment acceptance, approve model sheets with front/side/back views and scale beside an avatar: egg, baby, young form, Fire, Crystal and Nature. Define consistent anatomy, recognizable family identity and distinct evolution silhouettes. Author or source custom meshes, topology, UVs, textures and a rig; use a verified import pipeline. A static assembly of spheres is not a finished creature.

Finish one baby model in Studio with face, eyes, mouth, limbs, tail and silhouette matching its approved sheet before producing the remaining forms. Then build the full family and eggs. Give growth a controlled visual progression without distorting rigs/collision. Confirm the user may use/modify every external asset.

Exit: every required form is reviewed in the engine from several angles and at gameplay scale; materials/rig deformation pass; asset provenance is recorded.

## Stage C2 — Animation, effects and sound

Finish hatch, idle, locomotion/follow, feeding, delight, growth and evolution sequences. Align effects and sound with animation events. Test turning, slopes, stairs, bridges and crowded areas; prevent floating feet, clipping, teleporting and oversized camera obstruction. Make fountain water, foliage movement and ambient audio support the scene without drowning out gameplay.

Exit: all required actions play correctly for every supported form in the production environment. Animation is part of creature acceptance, not a vague future promise.

## Stage U1 — Unified interface and gameplay presentation

Replace temporary basket/farm/evolution/tutorial panels with a cohesive visual system: typography, spacing, icons, colors, feedback and hierarchy. Include keyboard/gamepad/touch prompts, selected-food/seed feedback, understandable growth and evolution requirements, inventory limits and clear save/error states. Tutorial disappears on completion. Check panel conflicts, camera visibility, input sizes and portrait/landscape behavior.

Exit: a fresh player can complete the intended journey without coaching; controls and text work on supported devices; all UI appears to belong to the same game.

## Stage R1 — Final integrated acceptance

Complete the deferred persistence, recovery, multiplayer isolation, ownership, region pacing and phone checks. Test a clean spawn through hatch, gathering, farming, feeding, evolution and exploration with normal timings. Define supported hardware and measurable frame/load/memory targets at W1; profile the completed courtyard and whole world against them. Keep collision simple, avoid unnecessary scripts/particles and use appropriate distance/detail controls. Do not remove essential visuals silently to pass performance.

Exit: evidence checklist complete, no known blocking defects, user accepts the actual playable world. No publication, purchases or paid assets without explicit authorization.

## Asset sourcing and tool limits

Custom modeling and free Roblox Creator Store/Marketplace or other properly licensed assets are valid routes. Free price alone does not establish usable rights, quality, security or style fit. Prefer a coherent kit over unrelated packs. Search when implementation reaches sourcing; no particular asset is promised until inspected.

For each candidate, record source URL/asset ID, creator, license/usage conditions, price at inspection, intended use, modifications, textures/rig dependencies and inspection status in ASSET_REGISTER.md. Inspect imported scripts and dependencies before use; remove unnecessary executable content and verify the required functionality still works. Keep originals separate from adapted assets. Never spend money or upload third-party work as ours without authorization.

When custom output fails the quality target: identify the deficient item, inspect available tools, find suitable free candidates or explain the specific external-modeling dependency. Show the real asset/result before acceptance. Do not silently substitute primitives, label a weak result finished, or promise an exact match to generated artwork.

## Delivery and review rules

Use one stage at a time. Maintain stage status as Planned / In progress / Awaiting review / Accepted / Blocked. Accepted requires the stated evidence and user review; agent praise or successful code execution is not acceptance. Keep functional checks separate from visual acceptance. Record known defects and dependencies, not blanket “refine later” notes. A change to scope or standard requires a written decision.

Current next action: finish W1 asset/import feasibility and device/capacity targets. User approved layout 02 with gateway-based homes on 29 October 2026; full W1 and world-art gates remain open, and the existing VisualSample must not become the production template by default.

## Approved layout amendment — 29 October 2026

Use docs/world/WORLD_BLUEPRINT_V2.png and W1_BLUEPRINT.md. The fountain hub stays compact. A Home gateway serves owned homes in a separate residential area of the same server; each home returns to the hub by gateway. Visits use a permission-aware destination menu. Visit policy remains a separate decision. Fixed physical home docks and the earlier six-slot proposal are superseded. Shared hub/orchard/Grove routes remain walkable. Layout approval does not approve final assets, precise dimensions/elevations or untested performance.


## Current implementation status — 29 October 2026

User requested construction after the courtyard study. W2 functional foundation is implemented and in progress; see world/W2_FOUNDATION.md. Layout 02 is respected. W1 capacity/device targets remain open, and W2/W3 visual acceptance is not inferred from this implementation. Next required work is the W2 continuous route/edge/watercourse and cloud-horizon review, followed by the stated courtyard/world gates. This supersedes the earlier current-next-action paragraph without marking its unresolved targets passed.

## W4 current status — 29 October 2026

User reports pre-W4 multiplayer working with three people and requests W4 implementation. Environment rollout pass W4-landscape-02 / W4-home-01 is implemented in Studio and local sources. See world/W4_WORLD_BUILD.md. User visual review, new presentation/bench-flow multiplayer regression and device/performance/persistence evidence remain open; no full W4 acceptance is claimed.

## Creature and gameplay commitment — 29 October 2026

After the reported W4 grounding/sign/crop correction pass, proceed to C1/C2. Add G1 Monster-led exploration after C2 and before final U1/R1 integration; see gameplay/G1_MONSTER_EXPLORATION.md. The current prototype loop is not the final intended gameplay. The approved direction is exploration enabled by raising/evolving the companion; specific quest beats and ability trials remain proposed until their gate is reviewed. See creatures/C1_CREATURE_BRIEF.md for the baby-first modeling pipeline.
