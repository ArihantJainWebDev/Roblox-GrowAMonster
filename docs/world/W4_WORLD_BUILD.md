# W4 — Environment rollout

Build: W4-landscape-02 / W4-home-01. Status: Implemented environment pass awaiting visual review; W4 acceptance is not complete. 29 October 2026.

## Multiplayer baseline

The user reports all three players successfully tested the pre-W4 game in the Roblox app. Record this as user-reported multiplayer functionality passing, not automated evidence or a performance benchmark. W4 changes presentation and seed-shop access, so its new crop/bench/gateway presentation needs a three-player regression pass. Saving/rejoin and phone/performance checks are not inferred from the report.

## Delivered spaces and interactions

- Orchard: ten curated broadleaf fruit trees, cloned from the project's original courtyard family with scale/rotation variation and authored lobed apples. Ground planting, root stones and stream-bank boulders frame the route and spring. A small swept-roof garden shelter and resting bench mark the upper spring terrace. Physical trail signs replace distant food name billboards.
- Spring: authored translucent watercourse joins the existing carved Terrain pools, with narrow scrolling flow highlights. Existing cloudward waterfall and mist remain. Close water/terrain contact and source/termination still require visual review.
- Grove: seven cool-toned broadleaf trees, fern planting, three distinct warm/crystal/nature mineral-and-botanical groups, a jointed ancestral stone arch with grounded piers and botanical crest, a trail sign, and the existing authored reward bloom. These are scenery; no new evolution/stat rules are introduced.
- Shared and home gateways: original stone arch mesh, botanical crest and arched translucent veil replace the visible rectangular frame while keeping the same server prompt, destination mapping and validations.
- All four farm plots: framed raised beds, soil material/furrows, and three discrete visible growth stages for both apple saplings and berry bushes. Ripe models show authored fruit. The old single crop spheres and bright ready-state soil colors are removed.
- Home: propagation bench with terracotta pots and sprouts; small two-sided ownership sign replaces the overhead home label. Native Browse seeds prompt opens the existing seed menu; it closes when leaving the bench. Only the owner sees its active shop prompt.
- Wild food: existing invisible server anchors/prompts now carry authored lobed apples or berry clusters, leaf/stalk geometry and low plant foliage. Per-player collection cooldown hides the local fruit presentation. Giant food billboards and sphere bush presentation are hidden.

## Source boundaries

BuildWorldScenery.luau is mapped to ReplicatedStorage.ArtReview.WorldScenery. SceneryController builds the regional scene, decorates streamed personal islands and clones cached growth/fruit models. Crops update only when their crop/stage key changes. Server plot/food attributes remain authoritative; no client grants items, seeds, coins or growth. No balance, inventory capacity, gathering cooldown, harvest yield, evolution or ownership rules changed.

WorldConfig.TreeGroups defines planting locations shared by rendering and server trunk collision/grass clearings. WorldService adds simple hidden trunk and spring-post boundaries and caches shared ground-cover work using W4-cover-03. FarmService keeps the owned seed-bench collider/prompt. Terrain and bridge geometry retain sky-foundation-09.

The editor preview tool rebuilds the W4 regional scene as EditorWorldScenery. It is moved out of Workspace before runtime, alongside the courtyard preview. Runtime home/player objects appear during Play. No publish, asset upload, purchase or Git push performed.

## Verification evidence

- Rojo build and whitespace checks passed.
- Studio Play W4LandscapeStatus Ready and W4CropsStatus Ready; all four beds receive their new presentation. Ground soil material and server trunk/post collision folder present.
- Native E at the seed bench opened the owner's seed panel.
- Normal server FarmService calls successfully planted all four beds (two apple, two berry).
- Both apple beds harvested after the normal 30-second timer, returning seeds and coins through the existing service. Both berry beds harvested after their normal 60-second timer.
- On the final growth review, apple and berry plots both reached stage 3 with CropVisuals present. No timer shortcuts were used.
- Gateway return to hub and relocated collection both succeeded through the actual services. A fresh collection hid the authored local fruit during cooldown; native billboard remained disabled.
- Early reviewed scene contained 342 MeshParts in Workspace including courtyard, clouds, W4 decor and home presentation. This is an observation, not a target-device performance acceptance; final count varies with growth/streaming.
- Initial startup exceeded the default five-second waits for remotes/food, producing wait warnings. Shared ground-cover work is now cached; the subsequent fresh Play had no such warnings. Existing disabled Studio DataStore API and asset 203785492 mismatch warnings remain.

## Required review / open gates

- User normal-camera review of orchard density/scale, spring watercourse/cascades and waterfall contact, Grove mineral composition, all four mature crops, readable signs and portal details. Actual Studio views govern acceptance.
- Full continuous route walkthrough, collision/edge review of new scenery, and touch/gamepad operation of the new seed-bench/menu flow.
- Three-player regression of W4 presentation, ownership prompts, streamed homes/crops and personalized fruit hiding. Prior multiplayer approval remains valid for the pre-W4 baseline only.
- Device frame/load/memory profiling and explicit hardware/capacity targets; save/rejoin evidence; remaining W2 visual gates.
- C1/C2 still own final eggs, creatures, rigs and their animation. U1 still owns unified interface styling. These are distinct requirements, not claims that those prototype assets are finished.

No W4 stage acceptance is recorded until required reviews pass.


## Final review pass

Added the Grove's 17-stud ancestral arch after the first review showed its standalone mineral groups were too sparse. Piers and spring-shelter posts extend to individually measured ground, with matching server collision. Lower LeafyGrass patches across orchard/Grove meadows reduce native blade dominance while preserving taller Grass clumps and island edges; terrain occupancy/height stay unchanged. This is a material distribution change, not a script edit to GrassLength.

The stream now uses an authored translucent watercourse with narrow scrolling highlights rather than a broad white beam. Runtime scenery requests shared-world streaming before ground alignment; landscape construction runs beside home/crop preparation. Regional decor hides beyond 650 studs from the character to avoid rendering detached scenery where distant terrain streams out.

Final fresh Play: landscape Ready, crops Ready, cover W4-cover-03, ruin collision present. Native E opens the owned seed panel. All four mature plot appearances were observed with CropVisuals (Apple:3 on plots 1/2, Berry:3 on 3/4) in the normal-timer review. Returned to Edit with the W4 preview intact. The final spring screenshot request stalled and was cancelled; no additional screenshot acceptance is inferred. No publish performed.
