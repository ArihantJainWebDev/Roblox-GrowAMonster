# Seed egg and young Sprout — 29 October 2026

Status: implemented and desktop Play verified; user visual review pending. Elemental forms are not included in this pass.

## Assets

SeedEgg is project-authored mesh geometry: eight curved shell panels with fine seams, eight curved green sepals, a botanical crown and layered nest/bowl. The floor-origin model uses the server-measured terrain position of WelcomeEgg. The old visible ball is replaced by an invisible server interaction anchor. An accepted hatch fades/separates the shell panels over .65 seconds and leaves the empty nest. Restored hatched profiles render only the nest. Server ownership, distance, living-character and data-availability checks remain authoritative.

Young Sprout is an assembled anatomical variant of the existing generated family meshes, not a separately generated or fully remodeled creature. Torso is longer and deeper, limbs taller with wider stance, head relatively smaller, neck and tail joints relocated, and the back has an additional authored leaf mantle/crest. It retains the accepted baby face, paws and corrected rearward tail. No new third-party asset was imported or uploaded. Baby bounds are about 1.79 × 2.60 × 3.11 studs; young about 1.85 × 3.24 × 3.95 (including invisible root bounds). Both use seven Motor6D joints.

Client templates cache both forms. At the server's existing 100-XP Young stage, the visual is replaced once and uses a 2.1-stud stride rather than the baby's 1.7. Scaling within stages remains gradual; young is not the baby uniformly scaled by the former stage multiplier. Branch selection still uses the current progression guards and young appearance until branch models are built.

## Verification

- Rojo build and diff checks passed; both client rig statuses reported Ready.
- Native E interaction hatched the egg, created a Baby visual, removed the shell, preserved the nest, and advanced tutorial step 1 to 2.
- Preview-only server setup at 99 XP, then actual FeedMonster request with one apple: XP clamped to 100, apple consumed, stage and visual changed Baby → Young, label became Young Sprout and the young mantle/stride were present.
- Studio comparison display shows egg, baby and young; preview models are archived during Play. Rebuild using tools/PreviewWorldInStudio.luau.
- No new script errors in the console. Existing preview-only DataStore restriction and audio warning remain. Test snapshots/granted food were confined to a Play session and were not saved.

## Remaining

User visual review, actual three-player and mobile regression, save/rejoin, and full emergence/growth cinematics remain open. The shell effect is not a full creature-emergence animation. Growth currently replaces the form at its threshold; smooth anatomical morphing is not implemented. Next: Fire, Crystal and Nature family forms, then remaining C2 animation and G1 monster-led gameplay.
