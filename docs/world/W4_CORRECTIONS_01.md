# W4 correction pass 01

29 October 2026. User-reported defects: floating portal/connector slabs, orchard fruit detached from branches, floating wild food plants, obscured signs, and undersized/floating farm plants. Corrected implementation is ready for user visual regression; no blanket W4 acceptance is implied.

## Root causes and changes

- Outdoor courtyard connectors sampled only each slab's center and left their edges hanging above sloped terrain. Removed CourtTrailConnections geometry entirely. The three connections now use terrain Rock material, consistent with outdoor paths. Cover version W4-cover-04 applies the change to existing terrain.
- Portal supports used one center height across uneven ground. GatewayService now samples its actual base and left/right feet and creates a solid stone threshold down to the measured low point. The local arch feet/columns use the server foot heights. Existing ownership, distance/cooldown and native travel prompt remain.
- Orchard apples used independent guessed radial positions. Original broadleaf geometry now includes ten FruitSocket attachments at actual branch endpoints; decorative apples attach their stalk tips to those sockets after tree scale/rotation.
- Scaled fruit/crops used default model-center pivots. Fruit and crop templates now have explicit origin pivots, with crop origin at the root plane. Clones place that plane at the actual plot top.
- Wild nodes publish GroundPosition from server Terrain. Fallen apples touch that ground; berries connect to a rooted bearing stem. Low leaves begin at the ground. Server interaction anchors/cooldowns are unchanged.
- Sign center posts extended through the text faces. Two side legs now end at the board bottom. Both faces have separate padded labels, text scaling and size limits, on a solid board.
- Farm apple plants now have root flares, branching trunks, fuller crowns and attached ripe fruit. Berry plots use multiple rooted stems and denser bushes. Added batched mulch/clods and darker soil beneath the existing framed beds.
- Shared scenery reads server-published SceneGround positions instead of relying on a streamed-out terrain approximation where coordinates are known.

## Checked evidence

- Fresh Studio Play: W4 landscape/crops Ready, no new script error. Existing Studio DataStore access and asset 203785492 warnings remain.
- All 40 decorative orchard fruit stalk tips matched their branch sockets; maximum measured distance approximately 0.000031 studs.
- Zero CourtTrailConnections objects remained.
- All four crop root planes matched plot tops within approximately 0.000013 studs. Mature apples measured about 6.3 studs tall and berries about 2.2 before the last canopy-density increase; the final trees retain rooted scaling and have denser foliage.
- Home portal feet extend 0.1 stud into the server-sampled terrain instead of floating. Normal E travel returned the player to Hub with health 100.
- Actual farm view inspected. A follow-up density pass filled out crowns/bushes and increased soil contrast after that view showed the first correction was still too sparse.
- Rojo place build and source checks recorded with final review; updated shared scenery is also rebuilt in Edit mode.

## Remaining review

User should recheck both portal sides and approach from normal height, fruit branch contact, wild plants, both sign faces and each crop stage. W4 multiplayer presentation and device checks remain open. Creature/egg production and new gameplay belong to C1/C2/G1 and are not represented as already built.


Final-source review: all 27 Rojo-mapped source files matched the current local files after newline normalization. On the final dense-canopy build, mature apple crops measured about 6.73 studs high / 6.75 wide; berry bushes about 2.39 high / 6.62 wide, with root-plane gaps still below 0.000013 studs. A fallen wild apple's bounding-box bottom matched server GroundPosition within 0.000009 studs. Both native E gateway directions passed; health 100. Returned the test character home and restored the ordinary camera. No publish or Git push performed.


## Creek overlay correction — 29 October 2026

User screenshot exposed the authored SpringWatercourse mesh as an elevated cyan strip. Removed that independent mesh and all SpringCascadeFlow overlay beams instead of tuning another guessed height. The channel now renders actual carved Terrain Water, with Grass converted to Ground immediately along its banks. The cliff waterfall source reads the server-measured outlet water height. World terrain rebuild version is sky-foundation-10.

Edit verification: no SpringWatercourse/SpringCascadeFlow objects remain; all five channel control-point raycasts hit native Water. Sample elevations were approximately 488.22, 477.64, 450.86, 432.84 and 433.85 studs. This verifies native water presence, not a claim of a hydraulic fluid simulation. Play/close visual checks are recorded separately.

Creek continuity verification: carve every channel sample before filling water, preventing later air cuts from erasing earlier water. All 69 centreline ray samples now hit native Terrain Water. Source and Studio terrain updated together.
