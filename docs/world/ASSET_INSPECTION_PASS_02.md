# Asset Inspection Pass 02 — 29 October 2026

Status: Nine imports inspected in Edit mode. No production asset approved. This completes this sourcing comparison pass, not W1 acceptance.

## Repeatable findings

Full source IDs, listing creators, observed free price and instance counts are in assets/review/candidate-manifest.json. These are source references, not local copies of third-party mesh files. Search used the Creator Store free and verified-creator filters; those filters do not establish suitability or ownership of every embedded mesh.

All imports were first placed in ServerStorage.AssetReview, not the gameplay world. Actual descendant inspection found no scripts in eight models. The village kit contained one script consisting only of a 20-byte author comment; it was disabled. This is distinct from the unrelated runtime-overlay scripts in the two previously rejected imports. No candidate scripts were executed.

A distant Workspace.AssetReviewStage shows sanitized, anchored, noncolliding display clones. Clone source scripts were removed before parenting. The floor is a neutral inspection surface, not production terrain. Positions near X2500 intentionally separate the shelf from the game. No gameplay bootstrap or production world was changed. Rejected plain fountain, conifer and toy-like nature pack displays were removed; original review models remain in isolated storage for comparison.

## Actual visual judgments

- Fountain 11423259371: rejects the intended hub style. Its plain cylindrical tiers do not meet the required fantasy landmark quality.
- Oak 11672970103: working PBR mesh/material import; 3 parts/3 mesh objects and 2 SurfaceAppearances. Dense realistic leaf appearance may conflict with the intended art direction. Secondary candidate, not accepted foliage.
- Rocks 139056934028989: 49 script-free mesh objects; useful secondary rock candidates. A complete cliff shell/underside solution is still missing.
- Village set 13280911060: 6,028 parts, 12 unions, no mesh objects. Repeated buildings around 493 parts each. Not selected as a world-wide kit on this evidence.
- Fountain 1666042982: more appropriate lobed stone basin, but contains a Humanoid and Tool as well as 111 parts/60 mesh objects/7 unions. No emitters or sound. Not production ready and not approved as a statue/character asset; provenance and adaptation must be settled.
- Fountain 2665331839: traditional stone basin/column, but ruined/broken geometry and loose rubble do not match the main hub requirement. 306 parts, 26 meshes, 8 unions, 3 emitters and no sound. Reference/candidate only.
- House 5138428088: timber/plaster frame and individually tiled roof is a closer architecture reference. 645 parts, 49 unions, no scripts. Interior/collision, render cost and provenance still need review; no approval claimed.
- Fantasy tree 1578635803: two script-free mesh objects, but narrow angular conifer does not solve the primary tree requirement.
- Nature kit 109637424937405: 70 script-free mesh objects imported; visual inspection rejected its rounded toy-like style for this project. Merely being a mesh is not sufficient quality.

## Import and material evidence

Model insertion, scaling and placement work through Studio tools. ContentProvider preload for the first display set completed with no reported failures after an initial capture was visibly unloaded. Later displays were also preloaded before viewing. Working rendering does not establish stable FPS, correct gameplay collision or final texture quality.

Review originals are currently in the open Studio Edit place. Studio-only content must be saved by the project's normal place-save workflow to survive closing Studio; Rojo's present project mapping does not serialize these models. No publish/save-to-cloud action was performed. The manifest permits reimport by ID, but cannot guarantee third-party content stays unchanged. A checked local model/source-asset archive and explicit Rojo/Studio ownership remain required before production adoption.

## Remaining concrete work before W1 closes

1. Find or author a suitable main fountain with sound/water plan and adequate rights/provenance, rather than silently accepting these compromises.
2. Establish coherent broadleaf foliage/shrubs/flowers and a full cliff/underside kit; current rocks are only secondary candidates.
3. Review the timber architecture candidate in player-scale collision/interior and performance tests; settle asset provenance and any required attribution.
4. Establish durable asset storage/import ownership, then supported device/capacity targets. No detailed production terrain starts under an assumed asset-quality pass.
