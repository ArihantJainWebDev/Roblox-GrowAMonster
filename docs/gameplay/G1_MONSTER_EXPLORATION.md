# G1 — Monster-led exploration

Status: Partial implementation as of 30 October 2026. Follow/Stay/Come/Pet and one companion-powered interaction at the existing Grove bloom are implemented and desktop tested; see G1_GROVE_INTERACTION.md and ../creatures/C2_ACTIONS_AND_CONTROLS.md. The complete caretaker quest, multi-step trial, new garden and discovery journal below remain the production target, not completed content. User visual review is deferred; multiplayer/device/persistence gates remain open.

## Goal

Make raising a companion unlock actions, discoveries and destinations. The current gather → farm → feed → evolve loop remains the foundation; it is not the complete intended game. A creature model alone does not add gameplay depth.

## First complete slice

Deliver one connected quest line in the existing hub/orchard/Grove, an elemental companion interaction, a small explorable garden beyond the Grove ruin and a persistent discovery journal. Target a coherent first-session journey, not repetitive feeding with a new label. Validate timings through playtests rather than promising a fixed session length.

1. A properly presented caretaker introduces one exploration objective and explains the companion's role. Its model/dialogue are required assets; an invisible trigger or giant debug label is not the finished quest giver.
2. Explore the spring/orchard and record distinct discoveries; gathering/farming supply the growth needed for the existing first evolution at 100 XP.
3. Choose Fire, Crystal or Nature. Each unlocks a contextual companion action at the Grove trial: kindle the focus, resonate the prism, or restore the roots. These are proposed variations of the same progression gate.
4. A short multi-step trial teaches approach → command companion → observe its action → complete the landmark. Show clear requirements and feedback; no unexplained button grants.
5. All three branches can complete the main trial and reach the same initial garden/reward tier. Branch flavor and optional discoveries differ; choosing one branch must not permanently lock a player out of core progression.
6. Discoveries and completed trial rewards persist. Return to the farm with a concrete new quest/unlock, so the loop has a purpose beyond a larger XP number.

## Companion controls

Follow, Stay and contextual Interact are the first controls. Use nearby readable world prompts with touch/gamepad equivalents. Commands must animate the creature and respect navigation/turning. Do not expose coordinate fields or technical state to players.

## Server and multiplayer requirements

Validate owner, hatched/evolved state, proximity of player AND companion, live character, expected objective, cooldown and one-time reward claims. Clients request an action, never grant progression or choose arbitrary destinations. Track per-player discoveries/trial completion; shared scenery does not imply shared inventory or rewards. Simultaneous players must not steal objectives or block the route for each other.

Extend the existing saved profile schema with versioned discovery/ability/trial fields and migration defaults. Inventory persistence is a separately explicit design decision; do not silently assume session-only food becomes saved. Test rejoin, failed saves, repeated commands/reward claims and ownership isolation.

## Implementation gates

- G1.1: approve the quest beats, action requirements/rewards, garden placement and caretaker asset route. No unbuilt destination is presented as finished.
- G1.2: implement one end-to-end branch interaction and the complete destination/reward/save path, with the production companion animation.
- G1.3: add the other two equally viable action variants and discovery presentation.
- G1.4: three-player, phone/gamepad, recovery and persistence playthrough; measure whether exploration gives feeding/farming meaningful purpose.

Combat, trading, breeding, PvP, raids, daily chores and large region expansions are not silently included. They require separate user decisions. Cosmetic monetization remains optional and cannot sell the required ability or main-route access.

## Sequence

W4 reported-defect correction → C1 family/egg models → C2 animation/companion behavior → G1 gameplay slice → U1 interface/onboarding integration → R1 integrated release checks. Environment changes needed for the G1 garden belong to that slice; they must not become an endless general scenery expansion.
