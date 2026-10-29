# C1 baby implementation — 29 October 2026

Status: first in-engine baby and rig implemented, awaiting user visual review. This is not completion of C1, C2 or G1.

## Asset and construction

Roblox Studio native mesh generation produced source model **71146011257533**, generation 222513a4-52d5-4e3d-a526-ee6a67c81e59. Seven textured mesh segments supply the body, head, four legs and tail. Source mesh/texture IDs, floor-normalized transforms, sizes and colors are reproducible from `src/shared/BabySproutAsset.luau`. Project-authored paw and three-claw meshes are added to each leg. No paid marketplace asset was purchased. The native generator created a model asset; the experience was not published.

The original generated model is preserved in Studio under ServerStorage.CreatureSourceAssets. The manifest and generation prompt are in assets/creatures/baby. Runtime rebuilding uses the manifest rather than depending on the temporary source instance.

BabyRig builds an invisible floor-origin root, seven Motor6D joints and 15 MeshParts. Geometry is noncolliding. CompanionVisuals caches one template per client and renders each replicated companion anchor. Server MonsterService retains ownership, XP, hatch/evolution validation and follows measured terrain/bridge/home surfaces. Basic joint gait, neck idle/feed motion and tail sway demonstrate the rig; they are not the finished C2 animation set.

## Verification and limits

- Rojo build passed. Ordinary client reported BabyRigStatus Ready, a visible companion, 15 mesh parts and seven joints.
- Runtime ground ray found zero gap between the companion anchor and its actual supporting Terrain surface. A foundation-only probe was insufficient on home terrain and was corrected to inspect the actual support.
- Actual mesh inspected in Studio from close and normal player views. Editor preview is floor-aligned and archived during Play.
- Native creek overlay objects removed. Five channel control-point rays hit Terrain Water; cliff waterfall height uses the measured SceneGround outlet.
- Studio persistence is still preview-only because DataStore API access is disabled. Existing audio asset 203785492 type warnings remain unrelated and unresolved.
- Existing feeding flow had reached 5 XP during the Play session. Full new locomotion, slopes/bridge, gateway and feeding animation acceptance plus three-player/device regression remain open; prior multiplayer success does not certify this change.

## Remaining sequence

Review this actual baby before reproducing the family. Egg, young and Fire/Crystal/Nature meshes are not built; existing stages currently reuse and scale the baby mesh. C2 needs finished hatch/walk/turn/feed/growth/evolution animation and foot-contact validation. G1 then implements the documented monster commands, quests and elemental exploration; those features are not part of this change.

### User screenshot review — paw correction
User screenshots exposed the rough paw appearance and uneven ear silhouette. Paw triangle winding was inward; reversed it, closed the soles and added optional vertex-normal smoothing to the geometry helper (other scenery keeps flat shading). Updated Studio sources and rebuilt the review model. The generated head/ear asymmetry is unresolved; do not mark visual acceptance passed. Build and diff checks passed. Movement-specific symptoms require clarification from the user.

Tail correction now implemented: the generated coil is excluded and replaced by an authored rearward sweep. C2 route-following and distance-based gait are implemented; see C2_FOLLOWING.md for evidence and remaining acceptance. Earlier fixed-offset behavior and tail defect entries are historical.
