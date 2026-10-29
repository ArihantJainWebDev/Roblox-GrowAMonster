# C2 following pass — 29 October 2026

## User acceptance — 29 October 2026

User accepted the corrected tail as decent and acceptable for now, then confirmed the current walking, turning and stopping behavior is decent and good enough. This closes the current desktop baby appearance/following review for this stage. It does not certify multiplayer/device regression, remaining creature forms or the full hatch/feed/growth/evolution animation set. Next production work is the seed egg and young Sprout form.

Implemented after the user identified a tail running through the back and rigid, sliding side-following. This supersedes the fixed side offset and time-only leg cycle. C2 as a whole remains open.

## Changes

- Omit the generated tail segment at build time. Its curled geometry crossed the torso. Replace it with a smooth authored rearward sweep, attached at the rump, with restrained tail motion. Source asset is retained for provenance, not rendered as a second tail.
- CompanionMotion records the owner's travelled route. The companion follows those points rather than a rotating offset beside the avatar. It starts following beyond six studs and settles within roughly four studs; rotating a stationary avatar does not reposition it.
- Speed is bounded at 18 studs/sec, acceleration at 12 studs/sec squared, braking at 22, turning at 3.2 radians/sec. It slows for turns and approaching the owner. Ground probes reject unsupported movement and excessive single-step height changes. Distant owner relocation resets the route for gateway/respawn recovery.
- Client rendering smooths replicated poses. Gait phase advances by actual rendered horizontal distance, with diagonal leg pairs, idle neck motion and tail sway. It does not advance an arbitrary running cycle while stationary.

## Evidence

- Deterministic ten-second route simulation with a corner: max speed 13.077, max acceleration/braking magnitude 22, stopped at 3.651 horizontal studs from the owner.
- Ordinary Play: client mesh loaded Ready; 278 moving samples during two home walks with a corner; max recorded speed 17.241; stopped speed zero.
- Rotated stationary avatar 180 degrees: companion position change zero; heading change below .001 radians.
- Moved test character from home to bridge start to exercise distant relocation, then walked the full sloped Bridge1. Companion followed to the far landing, stopped and had zero measured support gap. Relocation counter changed once for the test transfer, not during the bridge crossing.
- Actual replacement tail inspected in Play, extending behind the rump. Original generated tail mesh is absent from the runtime rig.
- Rojo build and diff checks passed. Existing preview-only DataStore setting and audio asset warning remain unchanged.

## Open acceptance

User walking/running/turning review, real gateway interaction regression, three-player visibility, mobile/performance and uneven-ground foot contact remain open. The procedural leg cycle is a locomotion pass, not a finished skinned animation or foot IK system. Route breadcrumbs do not provide general obstacle navigation for arbitrary future props; blocked ground movement stops rather than travelling across unsupported gaps. Hatch, delight, growth and evolution animation plus the remaining family models remain separate deliverables.

### Tail root correction after user screenshot
The first replacement left a high open base visibly detached from the rump. Lowered and extended the root inside the body, widened its overlap, closed both ends, moved the tail joint to the embedded base and reduced sway to 0.07 radians. Adjusted color toward the body's teal-green. Rebuilt and inspected side/rear Studio views. This fixes the exposed socket; it is still a separately jointed mesh, not a seamless skinned body.
