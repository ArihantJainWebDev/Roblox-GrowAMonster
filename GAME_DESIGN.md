# Grow a Monster — Game Design

**Status:** Planning baseline, 28 October 2026  
**Product:** Roblox multiplayer creature-raising and exploration game  
**Design promise:** Explore a bright fantasy world, grow a little island garden, and watch a monster grow into a creature shaped by your choices.

This document records the agreed direction and the recommended baseline for details that are still adjustable. It is a design guide, not a claim that these systems have been implemented. Numeric balance values remain tunable until playtesting.

## 1. Pillars

1. **A companion that visibly grows:** Players can see their monster change over time and celebrate meaningful growth milestones.
2. **Two ways to find food:** Gather wild food while exploring or grow dependable food on a personal farm.
3. **Choices shape the creature:** At evolution milestones, choose Fire, Crystal, or Nature, with later evolutions extending the chosen branch.
4. **A cozy world worth sharing:** Each player has a personal floating island and can meet others in a shared exploration world.
5. **Fair, welcoming progression:** Core play and evolution are earned through play. Optional spending is cosmetic and clearly priced.

## 2. Audience, platform, and tone

- Build for Roblox players who enjoy creature collecting, cozy farming, exploration, and light social play.
- Design the first release mobile-first, with clear touch targets and short interactions; support mouse and keyboard as well.
- Use colorful, stylized 3D art, readable silhouettes, friendly animation, and low-friction onboarding.
- Keep the tone warm and adventurous. The game should not punish a player for taking a break.

## 3. Player fantasy and core loop

The player hatches a baby monster, makes a home on a floating island, discovers food in the shared world, and grows crops at home. Feeding earns growth progress and brings the companion closer to a visible growth or evolution milestone. The player chooses an elemental path, then uses new abilities and access to explore more of the world.

```text
Hatch companion → explore and gather / plant and harvest → feed
       ↑                                             ↓
 new places and goals ← evolve and unlock ← grow and bond
```

### Session rhythms

- **A quick visit (1–3 minutes):** Check ripe crops, harvest, feed, collect a nearby item, and see growth progress.
- **A regular visit (5–15 minutes):** Explore, complete a simple goal, gather food, return to the island, and care for the farm.
- **A longer visit:** Explore newly opened areas, meet other players, work toward an evolution, and personalize the island.

These are experience targets, not restrictions. A player should be able to make progress without staying online for a long timer.

## 4. World and social layout

### Personal floating island

- Every player receives an individual, persistent home island.
- The first island has four usable planting plots, a clear spawn point, a monster area, and room for cosmetic decoration.
- The island is a calm home base. Visiting another player's island can be added after permissions and privacy behavior are designed.
- Island expansion is earned through milestones or soft-currency goals; it must not gate the core monster loop.

### Shared exploration world

- Players arrive in a shared, friendly hub with obvious signs for gathering, returning home, and finding other areas.
- Exploration regions are unlocked through monster growth and quests rather than paid access.
- Wild foods appear at authored gathering points and return after a server-controlled cooldown. Rare foods are exciting bonuses, not required ingredients for ordinary progress.
- The initial world should be small enough to finish and tune: a hub and one nearby exploration region before additional biomes are built.

### Multiplayer boundaries

- Players can see and socialize with one another in shared areas.
- Personal farm actions and monster ownership are always scoped to the owning player.
- Co-op activities may be added later, but the first release must be fun solo and must not require trading or another player's attendance.

## 5. Companion growth and evolution

### Growth model

- The starter companion hatches as a baby and progresses through clearly named visual stages.
- Feeding food grants growth experience. Food has a simple, inspectable value: for example, common fruit gives a small amount, unusual fruit more, and a rare rainbow fruit a large bonus.
- Growth is continuous in presentation (progress, animation, reactions) and milestone-based in form (stage changes and evolutions).
- No hunger decay, lost levels, or harm for being offline. Passive time may provide a modest, capped growth contribution if playtesting shows it improves the experience; feeding remains the active, reliable path.
- Milestones must explain what is needed and show progress. Avoid hidden requirements.

### Evolution choices

- At the first elemental choice, the player chooses **Fire**, **Crystal**, or **Nature**.
- The choice changes the creature's appearance, effects, and a small set of exploration interactions. It does not make a branch strictly stronger in combat or progression.
- Later forms deepen that branch. Future branches or a reversible cosmetic display may be considered only after the first three are complete and readable.
- Make the consequence clear before confirming. The first elemental choice is meaningful and should not be silently reversible; any reset mechanic would need a fair, earned route and a clear cost before release.

### Bond and expression

Monster reactions, idle behavior, feeding feedback, and simple emotes provide emotional reward without adding a needy maintenance meter. Cosmetic accessories and visual effects are appropriate long-term goals.

## 6. Food and farming

### Wild food

| Example food | Rarity | Role |
|---|---|---|
| Apple | Common | Reliable small growth reward |
| Berry | Common | Common alternative with a little more value |
| Golden Apple | Uncommon | Noticeable bonus |
| Crystal Fruit | Rare | Exploration reward and larger bonus |
| Rainbow Fruit | Very rare | Celebratory bonus; never mandatory |

Exact experience and spawn rates are balancing data, not promises. Food should be visually distinguishable, easy to collect, and conveyed with a short pickup effect and readable inventory feedback.

The Phase 3 prototype uses per-player node cooldowns, an empty starting basket, and apples/berries/golden apples. Counts, growth rewards, and timers are configured in FoodConfig; these are implementation defaults for review, not final economy balance.

### Personal farm

1. Obtain seeds through early onboarding, play rewards, or a soft-currency shop.
2. Plant a seed in one of four starter plots.
3. Let crops grow, with clear visual stages and a visible ready state.
4. Harvest a predictable quantity, receive feedback, and use the food to feed the monster.

The first crops should be fast enough to teach the system in one session (the earlier proposed examples were a carrot at roughly 30 seconds and a strawberry at roughly 60 seconds). Final times, yield, and seed cost will be tuned in playtests. Timers continue while away, with a sensible cap; no withering or crop loss. Watering may be a satisfying optional interaction, but should not become a mandatory repeated chore.

Farm upgrades can add convenience or decoration after the starter loop works. They should not be required for evolution or make paid players grow substantially faster.

## 7. Goals, rewards, and economy

- The first session uses a short guided quest: hatch, meet the companion, collect food, plant a seed, harvest, feed, and return home.
- Quests teach existing actions and give modest predictable rewards. Avoid daily streak loss or fear-of-missing-out timers.
- Use one simple soft currency (working name: **Coins**) for seeds and select island cosmetics. Earn it from exploration and quests.
- Food is an inventory item, not a premium currency. Keep inventory rules legible and avoid confusing conversion chains.
- Growth, evolution, region unlocks, and essential farm plots are play-earned.
- Save only the minimum data needed for a reliable experience: progression, inventory, planted crops and their timestamps, island choices, and owned cosmetics.

## 8. Monetization

Optional monetization is limited to direct-purchase cosmetics: monster looks/accessories, island decoration themes, and non-competitive visual effects. Show the item and price before purchase. Do not sell randomized eggs, paid evolution, gameplay power, food required to progress, or paid shortcuts that undermine the growth loop. Monetization is a later release phase, after the free experience is complete and reviewed against Roblox platform rules.

## 9. Accessibility, safety, and quality bar

- Important state is conveyed by text/icon as well as color, sound, and animation.
- Use short, skippable onboarding prompts and forgiving interaction ranges.
- Provide readable UI on a small screen, with scalable text and consistent button placement.
- Keep social features within Roblox's built-in safety and moderation model; do not create off-platform contact prompts.
- Protect progression and currency on the server. Client messages are requests, never proof that a pickup, purchase, or reward is valid.
- Avoid manipulative scarcity, punitive absence mechanics, and pay-to-win competition.

## 10. First release scope

The first complete, publishable slice should include one starter monster with a few growth stages, all three first elemental paths with representative evolved looks, one personal island with four plots, a shared hub and one gathering region, a small food and crop set, persistent saves, basic onboarding, and a short quest chain. It should be enjoyable solo, work on touch and desktop, and have no paid progression. More biomes, visitors, trading, combat, breeding, and seasonal events are explicitly later candidates, not launch dependencies.

## 11. Success checks

Use observation and playtests rather than assuming engagement numbers. A new player should understand what to do next, see a complete gather/plant/feed cycle, understand the elemental choice, and retain progress across a session restart. Track only useful aggregate gameplay signals, such as where onboarding stops, how often planting/feeding succeeds, and save failures; respect Roblox privacy and analytics requirements.

## Phase 4 prototype defaults

The first farm slice uses apple saplings (30s/3 apples) and berry bushes (60s/4 berries), sharing existing basket foods. Two seeds each and 12 coins start the loop; seeds cost 2/3 coins, and harvest returns a seed plus 3 coins. These are tunable defaults; proposed carrot/strawberry crops remain later expansion.
