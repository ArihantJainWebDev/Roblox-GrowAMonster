# Square frame returning — 30 October 2026

The user clarified that the recurring defect was the square gateway frame replacing/showing through the approved curved arch. The preceding foliage fix addressed a different visible issue and did not resolve this one.

## Cause and fix

GatewayService still generated two eight-stud rectangular pillars, a ten-stud straight lintel and a visible rectangular interaction plane. Scenery.Gateway hid them locally after constructing the curved artwork. During loading or when visibility was reset, the old shape could be visible again; its cached-visual early return skipped repeating the hide operation.

- Removed generation of the old rectangular pillars/lintel. The interaction plane is always invisible on the server.
- GatewayFrame now generates two short supports and 24 curved arch segments as the replicated fallback/collision frame. Its outline matches the curved artwork. Loading can no longer substitute a rectangular frame.
- Gate creation removes legacy pieces/duplicate named anchors for that gateway rather than accumulating another frame.
- Local artwork is W4-gateway-03. Hiding the matching native fallback is reapplied before the cached-visual return, including after late/streamed child visibility changes. If visible, the fallback is itself curved.
- Travel permissions, ownership, destinations, cooldown and grounded threshold remain unchanged.

## Verification

- Home and hub each reported a curved fallback with 26 pieces; visible rectangular GatewayPillar/GatewayLintel count in Workspace was zero. Both rectangular prompt anchors had Transparency=1.
- Simulated native visibility reset was re-hidden by the existing client update: zero native pieces remained visible after one second.
- Temporarily hid the detailed local artwork and forced native fallback visibility. Screenshot confirmed a curved upper frame with no straight top lintel. Test override cleaned itself up.
- Home → Hub → Home travel passed with the new frames. Build/diff checks passed. Actual three-player streaming/device review remains open; nothing published or pushed.
