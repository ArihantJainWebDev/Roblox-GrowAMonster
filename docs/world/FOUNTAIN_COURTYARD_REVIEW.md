# Fountain Courtyard Review Build — 29 October 2026

Status: Courtyard sample implementation and desktop Play verification passed after user enabled Mesh / Image APIs. Awaiting user visual acceptance; full W3/world acceptance and target-device/multiplayer testing remain open.

## Delivered assembly

- Original scalloped fountain, carved pedestal/chalice/crest and perimeter reliefs.
- Eight curved Beam streams with original scrolling water-strip texture; eight impact-spray emitters using an original soft droplet texture; eight expanding/fading ripple meshes driven by the local effects controller.
- Spatial, looping fountain sound: ProSoundEffects Water Fountain 2 (SFX), asset 9120557315, https://create.roblox.com/store/asset/9120557315 . Creator Store returned free on 29 October 2026. Listing credits Pro Sound Effects. Actual preload succeeded; sound length 66.197 seconds, and the Play client reported IsPlaying=true with advancing TimePosition. An audible taste/mix review is not inferred from those properties. No audio file was redistributed.
- Radial stone paving with a clear entry path; two raised beds with folded-leaf planting and modeled flowers; paired original broadleaf trees; four benches and four lanterns with local light sources.
- Original timber hatchery portico, roof, braces and curved stone arch.
- Meadow terrace and rock underside for the sample; separate simple walking support. This is not the production world's full terrain/cloud implementation.

## Source and ownership

Geometry library: tools/art/BuildWorldAssetStudy.luau.
Assembly: tools/art/BuildFountainCourtyard.luau.
Runtime effects: src/client/CourtyardEffects.client.luau.
Rojo maps the two authoring modules to ReplicatedStorage.ArtReview. The local effects script runs only if FountainCourtyard exists; it does not alter player progression or create the production world. The sample stands near X3600/Y120, outside the gameplay area. No production bootstrap relocation or asset upload was performed.

Original generated mesh/image references render in the Edit session but lose content when Studio clones the place into Play. This was reproduced: clients saw SourceType=None and placeholder geometry. Baking via CreateDataModelContentAsync also lost content across the Edit-to-Play clone in this Studio session, so it was not accepted as a fix.

The runtime preview therefore reconstructs the original geometry and images locally, then replaces only that client's review copy. This requires Roblox's Editable Mesh / Image API setting. An ordinary LocalScript probe failed with: 'EditableMesh is not accessible. Go to the Security Tab in Experience Settings to enable this API.' Probe objects/scripts were removed after diagnosis. The user was asked to enable this platform setting. No private/public mesh upload is used as a workaround.

## Evidence and outstanding gate

- Source Rojo build and whitespace checks passed.
- Edit-mode screenshots inspected the actual assembled courtyard.
- Sound loaded and played in Play as noted above.
- Play cloned 8 Beams, 8 emitters and the courtyard's parts, but custom mesh/image content did not transfer. The failed visual test is recorded, not called a pass.
- Runtime rebuild source is installed. It cannot be fully verified until Editable Mesh / Image APIs are enabled; then test generated mesh visibility, moving texture flow, impacts, changing ripple size/transparency, audio falloff, avatar walking/turning and absence of runtime errors.
- User visual acceptance, full target-device performance, production saved mesh ownership/replication and world integration remain open. The isolated courtyard is not a declaration that the fantasy world is finished.

## Runtime verification completed after enablement

The user enabled Mesh / Image APIs. Ordinary client reconstruction then reached the editable-mesh memory limit. Fixed by freezing each completed piece with CreateDataModelContentAsync and destroying its EditableMesh immediately, before creating the next piece. The client now reports Ready, the basin mesh has SourceType=Opaque and the water-strip texture has SourceType=Object/EditableImage.

A successful Play screenshot at avatar height shows actual courtyard geometry, trees, portico, paving and flowing streams rather than placeholder boxes. Two sampled ripple sizes/transparencies differed while EffectsElapsed advanced. The loop was loaded/playing with advancing TimePosition. The first black captures did not establish visual success; a later visible Play capture did. No audible mix judgment is inferred from IsPlaying alone.

Walking-support rays hit the entry landing, both side walkways and the portico foundation. A short actual keyboard movement check was performed; see the implementation report in chat for observed state. User visual review still decides whether the courtyard meets the intended standard. This is not acceptance of full sky/cloud terrain or the complete world.

Also fixed a FarmController loading race: the HUD now checks for the island Grass child before reading its Position, so partial island replication does not stop the farm refresh loop. Startup console no longer showed that error or mesh-budget failure on the successful run. Existing Studio DataStore access warning and template asset-type warnings remain separate known issues.

Reproducibility: Rojo now maps a FountainCourtyard review marker and invisible server support into Workspace. Thus a fresh local build still triggers the client assembly even if the previous Edit-generated visual scene was not saved. Unknown Edit-scene children are preserved. This is a temporary review location outside the gameplay area, not the production hub. Keyboard D moved the avatar from X3600 to X3588.80 while remaining grounded with 100 health.
