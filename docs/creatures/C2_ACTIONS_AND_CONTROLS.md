# Creature actions and controls — 30 October 2026

Status: implemented, desktop Play checks below passed; user visual review explicitly deferred while implementation continued. This is a procedural animation/interaction pass, not final release acceptance or a fully skinned jaw/expression rig.

## Creature presentation

- **Hatch:** the accepted hatch positions Sprout at the measured egg/nest, holds movement for 2.8 seconds, shakes the shell, separates/fades panels, and reveals the baby from a smaller crouched pose. A short sparkle burst marks emergence; the nest remains. Loaded hatched snapshots do not replay hatching.
- **Feed:** the actual selected food travels from the player's hand to the companion's muzzle, shrinks through a timed chew/nod and is cleaned up. The server consumes one item and holds movement while the reaction plays. Cosmetic fruit never grants inventory.
- **Growth:** crossing 100 XP first plays the food reaction on the baby, then crossfades to the young rig with a small reveal and celebration burst. Old visuals are destroyed after .65 seconds. The existing growth threshold/cap are unchanged.
- **Evolution:** the chosen path remains server-authoritative immediately; the visual holds the young form during a brief charge, then reveals the selected branch with a burst/crossfade. Prefetched branch templates remain shared per client.
- **Affection/idle:** Pet adds a head lean, restrained body bounce, quicker tail wag and a rising heart. Idle head motion remains subtle. These use existing Motor6D joints; the mouth is not a separately deforming jaw, and eye texture expressions are not newly animated.

Actions use server-timed Action/ActionStarted/ActionDuration cues. Expired cues do not replay when streamed in. Temporary food, hearts, particles and old rigs are removed. The HUD disables feeding while busy and shows a useful busy response if requests arrive anyway. Feeding cadence now waits for the 1.4-second reaction rather than overlapping repeated actions.

## Controls

Near your own companion, use **F**, the world prompt on touch, or controller **Y** to open the command menu. It offers Follow, Stay, Come Here, Pet and Use Nearby Landmark. **R**, controller D-pad Down, or the visible Recall button recalls a waiting companion. Requests carry only a whitelisted command; they cannot select another player's monster or arbitrary coordinates.

Stay holds the actual current position. Come resumes bounded current-owner navigation. Stay has a 50-stud safety leash; distant travel and respawn resume Follow. Pet requires a live owner within ten studs and grants no XP, food or currency. Commands are rate-limited and blocked during committed actions. Recall/Follow can cancel a landmark approach; channel completion still validates player presence before rewarding.

## Verification

- Ordinary native E hatch created the baby at the egg (1607, 422.29, 18), set the Hatch cue and advanced the tutorial.
- Native F opened the visible command menu. Stay moved zero studs while the player walked away; Recall returned the companion to about 4.7 studs away and hid the Recall button.
- Far Pet did not start an affection action. Near Pet created a heart and kept XP unchanged.
- Actual feeding at 99 XP consumed food, kept Baby during the opening reaction, revealed Young after the delay, and cleaned up the old rig/fruit. XP reached exactly 100.
- Actual Fire evolution held Young during charge, revealed Fire, then cleared UI busy state and old visuals.
- No new console script errors during these checks. Existing DataStore preview restriction/audio warning are unrelated.

Respawn and Nature-context checks are recorded in the session closeout. Three-player and phone/controller-device playthrough remain open; controller bindings and touch buttons are implemented but not certified by physical device testing.

## Next boundaries

This pass supplies the first command layer and first companion-powered Grove bloom action (see docs/gameplay/G1_GROVE_INTERACTION.md). It does not complete the caretaker quest line, new garden destination, discovery journal, richer facial/skinned animation, foot IK, or the release gates. No experience publish or Git push was performed.

Closeout verification: Nature context produced AbilityNature with its leaf/beam effect, awarded exactly two berries and cleaned up the effect. Stay was accepted before a normal character reload; after respawn, mode was Follow. Final build/diff checks passed. All temporary test actors/snapshots were Play-only; no save or publish was performed.
