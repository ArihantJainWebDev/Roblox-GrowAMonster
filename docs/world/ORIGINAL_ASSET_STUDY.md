# Original World Asset Study — 29 October 2026

Status: Actual custom meshes built and viewed in Studio. Awaiting visual review; not production accepted. No gameplay world replaced.

## Concrete output

- Original scalloped six-lobe stone basin with a terraced plinth, separate inner basin, carved/fluted pedestal, upper chalice, botanical crest and perimeter reliefs.
- Eight geometrically modeled water arcs and two water surfaces. These are static shape studies, not animated running water or a completed fountain effect. No sound has been added.
- Two original 24-segment, eight-layer cliff shells with irregular outlines and tapered undersides. These establish an authoring route, not an accepted full terrain kit or a production island.
- Original branching broadleaf tree with modeled tapered trunk/branches and 2,250 individually folded leaf shapes, separated into three canopy colors. No sphere canopy parts or downloaded creature/tree geometry are used.

The neutral inspection surface is a display support, not proposed final terrain. The source includes no imported scripts or external asset dependencies.

## Source and regeneration

Authoring source: tools/art/BuildWorldAssetStudy.luau. OBJ/MTL geometry export: assets/review/original-world-assets.obj and original-world-assets.mtl. Geometry uses Roblox-stud units and original study coordinates, before the Studio display translation. OBJ objects preserve individual mesh names and flat material assignments. No UV texture atlas or rig is claimed.

In Studio Edit mode, the tools connection installed the generator at ServerStorage.OriginalArtTools.BuildWorldAssetStudy and called its Build method. Workspace.OriginalAssetStudy displays the result near X3000/Y90. This does not run from the production bootstrap or require a marketplace upload. The generator asserts Edit mode to avoid accidentally running it as production gameplay.

EditableMesh creation and AssetService.CreateMeshPartAsync were verified in the actual connected Studio instance, not only read in docs. The generator centers vertex coordinates explicitly before creating mesh parts; the first alignment issue was corrected and the rebuilt tree/cliffs/fountain inspected again. Mesh memory is held in the module for object-backed rendering. Such session meshes are not a claim of automatically saved/published content; the durable generator and exported geometry are the source of truth for reconstruction/import.

No asset publishing, paid purchases or place publication was performed. Future production import must establish static saved asset ownership and test replication/rejoin before use in the live world.

## What has and has not passed

Passed: executable authoring path, actual mesh rendering, deterministic rebuild, basic scale/position alignment, original-source provenance, standard geometry export route.

Not passed: user visual acceptance; UV/PBR art; collision and walkability; mature canopy silhouette and foliage density acceptance; final cliff edge/terrain joins; moving water, splash/ripple/audio; target-device performance and storage/replication behavior. Generic low-poly geometry is not accepted merely because it is now a mesh. These exact items must be resolved at the applicable asset/courtyard gates.

Marketplace research from this pass did not produce an accepted replacement. Multiword searches returned unrelated or low-quality matches; candidates were not inserted merely to inflate the shortlist. The original mesh route was pursued instead of quietly choosing a mismatched asset.

Geometry export validation: 15,828 finite vertices, 33 mesh objects, 15,912 non-degenerate triangles with valid indices. Removed 480 zero-area pole faces and added equivalent generator filtering. No target-device performance result is implied by these geometry counts.
