# Home foliage and gateway correction — 30 October 2026

The screenshot was initially interpreted as camera foliage and a weak portal surface. The user subsequently clarified that the reported recurring issue was the square gateway frame, tracked separately in W4_CURVED_GATEWAY_REGRESSION.md. This record describes the separate foliage/surface corrections made during that initial interpretation, using camera position (1585.75, 427.31, 17.46) looking toward (1582.42, 426.47, 5.44).

## Root causes and changes

The largest foreground blades were the seed bench's potted leaf mesh, not terrain grass. The noncolliding decorative mesh could surround the camera lens. Art.MakeLeaves now marks decorative foliage; CameraFoliage fades marked parts based on camera distance to their local bounds. Foliage disappears when the camera enters it and restores its prior local visibility after leaving. This is camera-local; it neither deletes plants nor changes collision/gameplay.

Separate home clearings also left grass strips around walking/camera space. GroundCover provides an elliptical low green LeafyGrass garden area with connected ground paths and a wider gateway clearing. Tall Grass remains on the outer meadow. Clearing handles both Grass and LeafyGrass. Home generation reapplies it on every home build. Changes replace materials only, never terrain occupancy or height. This uses the engine distinction documented in [Roblox terrain materials](https://create.roblox.com/docs/parts/terrain): animated blades render on Grass.

The thin Glass gateway membrane was replaced with a restrained two-sided Neon surface at .48 transparency. The gateway visual has a build version so stale local visuals can be rebuilt. Native prompts, collision, travel authorization and cooldowns are unchanged.

## Verification

- Fully loaded home screenshot at the reported camera angle no longer showed foreground plant blades; the custom gateway arch and cyan membrane remained visible.
- Camera inside SeedBenchSprouts: LocalTransparencyModifier=1. Camera moved away: restored to 0.
- Material counts in gateway footprint: Ground/Rock only; no Grass. Camera-side patch likewise had no Grass. Outer sample retained Grass.
- Reapplying garden cover changed zero occupancy cells across the tested home area.
- Home → Hub → Home gateway travel passed; local gateway build was W4-gateway-02 with Neon membrane.
- Rojo build/diff checks passed. Physical-device/multiplayer appearance review remains open. No experience publish or Git push.
