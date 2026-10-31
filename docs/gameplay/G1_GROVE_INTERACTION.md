# G1 first contextual interaction — 30 October 2026

Status: first playable companion-powered landmark implemented in the existing Element Grove. This is a partial G1 deliverable, not the full proposed trial/garden/quest line.

## Player flow

Evolve through the existing 100-growth choice. Bring Sprout to the luminous Grove bloom, then use **Ask Sprout to awaken** or **Use nearby landmark** in the companion menu. Sprout approaches the focus, turns toward it and channels its element for 2.3 seconds. Stay nearby. Successful completion grants the existing two-berry reward and records the existing Grove tutorial fact. The bloom regrows per player after sixty seconds.

Fire channels a warm ember stream; Crystal channels aqua/violet resonance; Nature adds a green restorative stream and authored leaf trail. All branches use the same requirements/reward tier. This replaces the old direct berry-claim prompt with an actual companion action.

## Authority and cancellation

Only this whitelisted landmark can receive the server-generated InteractionGoal. Requests must have a live owner, loaded mutable profile, evolved companion, owner within eighteen studs of the bloom, companion within thirty, two free inventory slots and no pending interaction or cooldown. Approach is bounded to ten seconds; the creature must reach within 6.5 studs before channeling. Completion rechecks owner life/proximity (22 studs), the same companion/path and companion proximity (eight studs), then atomically grants berries and starts cooldown. A duplicate/premature request cannot grant rewards.

Leaving, dying, changing context or failing navigation interrupts the interaction without a reward. A full basket at completion gives no partial grant and no cooldown. Follow/Recall/Stay cancel an approach; committed channel actions finish their short visual but still fail reward validation if the player leaves. Interaction state is session-only. Existing Grove quest facts use the existing saved quest snapshot; no new journal/garden schema or persistence claim is introduced here.

## Evidence

- Fire entered Channeling and produced the AbilityFire visual. Leaving during channel yielded zero berries and cleared activity state.
- Retrying through the native Grove prompt succeeded: two berries granted. An immediate repeat left the count at two.
- After the real sixty-second cooldown, Crystal channeled and raised the berry count from two to four.
- Nature and respawn closeout checks are appended below after completion. Actual save/rejoin, three-player simultaneous claims/navigation and physical-device testing remain pending.

## Still unbuilt in full G1

Caretaker model/dialogue, a complete multi-step elemental trial, the garden destination, distinct discovery objectives and persistent discovery journal. Do not describe this single existing-landmark interaction as those completed features. User visual review of the family and this presentation remains deferred.

Closeout: in a fresh preview session, Nature's actual Interact request produced the restorative visual and exactly two berries, then cleared GroveActivity and destroyed the temporary effect. Fire, Crystal and Nature thus all passed the same reward path. No garden/journal or new saved progression schema is claimed.
