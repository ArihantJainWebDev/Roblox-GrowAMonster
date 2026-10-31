# Fire, Crystal and Nature forms — 30 October 2026

Status: implemented and desktop Play verified. User visual acceptance and multiplayer/device regression remain open. This completes the first implemented appearance set, not final acceptance of C1 or the remaining C2 animations.

## Appearance and source

All branches preserve the existing young Sprout anatomy, corrected tail, integrated foliage, seven-joint skeleton and ground-following behavior. ElementForms builds original branch geometry welded to the head or tail; decorations follow the joint rather than floating beside the body.

- **Fire / Ember Sprout:** rust/copper skin palette, three curved ember crests, warm inner crest accents and copper tail plates with ember seams.
- **Crystal Sprout:** violet skin palette, six-sided crown prisms with aqua insets and a graduated tail crystal ridge.
- **Nature / Bloom Sprout:** green skin palette, two branching botanical antlers, peach/pink crown blossoms, pollen centers and a small rooted tail flower.

These are authored variants on the shared family meshes, not three independently generated creature bodies. No additional paid/external asset, model upload or experience publication was performed. Existing source mesh/texture references remain in BabySproutAsset and assets/creatures/baby. New branch geometry and palette transforms are reproducible from src/client/creatures/ElementForms.luau.

Color variants derive from the existing generated textures, retaining cream belly/muzzle, eye highlights and baked shading. Source maps are sampled once at 256 × 256; branch results are cached/shared per client. Eighteen branch EditableImages use about 4.5 MiB of RGBA pixel storage, excluding engine overhead, source-buffer cache and other game assets. This is an implementation estimate, not a device memory benchmark. See [Roblox EditableImage documentation](https://create.roblox.com/docs/reference/engine/classes/EditableImage) for the runtime image API dependency already enabled for this game.

## Selection and loading

CompanionVisuals prefetches one template for each branch after loading baby/young. Each branch exposes its client RigStatus; failures are reported instead of claiming successful model loading. While a selected branch is still loading, the young appearance remains visible, then is replaced once the branch template is ready. Every companion's own replicated Path selects its appearance. XP, choice validation, ownership, growth cap and equal branch rewards remain server-controlled and unchanged.

The creature-only editor tool tools/PreviewEvolutionsInStudio.luau creates a labelled-by-model-name review row. Its EditorEvolutionPreview container is archived by WorldService during Play; these display creatures and the review plinth do not appear in the actual runtime world. Editable preview content must be rebuilt after restarting Studio; source scripts rebuild actual gameplay visuals at runtime.

## Verification

- All three client RigStatus values reported Ready in ordinary Play.
- With preview-only 100-XP setup, actual EvolveMonster requests selected each correct authoritative Path, visual Element and nameplate.
- Fire: 29 MeshParts, seven Motor6Ds, zero anchored visible pieces. Crystal: 25, seven, zero. Nature: 30, seven, zero.
- Attempting Fire after selecting Nature kept Nature on both server and visual. A 99-XP evolution attempt returned false.
- Restoring a Crystal snapshot at 140 XP selected the Crystal visual and 1.02 scale. This checks restoration logic, not DataStore save/rejoin.
- Walking with Nature and Crystal retained branch appearance and the 2.1-stud stride. New decoration constraints attach to their intended moving head/tail parts.
- Build/diff checks passed. Existing preview-only DataStore restriction and audio warning remain unchanged. Temporary test snapshots/branch resets were confined to Play; no player data was saved.

## Remaining work

User close visual review, three-player appearance isolation/performance, phone memory/loading and actual save/rejoin. Bespoke evolution cinematics, richer expression/feeding/hatch animation and detailed foot planting are still C2 work. G1 commands/quests/elemental exploration are not implemented by this appearance pass. Earlier documents calling elemental meshes unbuilt or all paths visually identical are historical and superseded by this implementation record.
