# W3 — Fountain garden courtyard

Build: W3-garden-01, 29 October 2026. Status: Awaiting visual review of this construction pass; W3 is not accepted complete.

## Changes

Original fountain retained with its carved basin/chalice, eight animated streams, impact sprays, ripples and positional water loop. The hub now has an extended jointed stone plaza, inner basin apron, outer mosaic border, open-entry coping and terrain-aligned connections toward Home, orchard and Grove routes.

The timber pavilion now has ashlar side walls, recessed green panels, window mullions/sills, pilasters/capitals, individual arch stones and botanical copper-colored roof crests. This is garden architecture; the actual starter egg remains at the owned home. No new hatchery gameplay is implied.

Tree planters have a distinct broadleaf understory, sage stems, lavender spires and peach flowers. Lantern iron frames and bench armrests complete existing furnishings. New details use project-authored mesh data, deterministic planting and native material appearances; no marketplace imports or uploads.

Geometry is batched by name/color/material rather than creating a separate mesh per paver. CourtyardDetails is a new Rojo-mapped module invoked before the completed courtyard is placed at its world origin. Shared grass clearings extend along its three short connections.

## Evidence

- Rojo build and whitespace checks passed.
- Actual Studio Play build reports CourtyardPreviewStatus Ready and CourtyardBuild W3-garden-01. The first reviewed build contained 69 MeshParts across the entire courtyard, including the existing fountain and trees; this count is not a device-performance guarantee.
- Real Studio overview inspected: plaza, original fountain, planted beds and pavilion facade render. This is evidence of implementation, not user acceptance.
- Client navigation passed entry → east fountain aisle → rear terrace → pavilion center. Health 100 at checked destination.
- Fountain sound IsLoaded=true and IsPlaying=true; EffectsElapsed advanced beyond 160 seconds. Existing eight streams and ripple animation remain active.
- A connector tile overlap found in review was corrected in source by deriving tile length from actual segment spacing; final fresh Play restart passed with the corrected source.
- Existing disabled DataStore API and asset 203785492 mismatch warnings remain; no new courtyard script error appeared during the reviewed session.

## Acceptance still required

User review at normal player height from the entry, fountain aisle, tree planters and pavilion. Check material detail, vegetation silhouette, visible joints, edge transitions and roof/arch close-ups. Grounded movement and visibility must also be reviewed on supported phones and with several players; load/frame/memory targets remain undefined. New masonry details use non-colliding visual meshes and two matching server-owned side-wall collision boxes. Server raycasts verified side walls block and the central arch passage stays open. W3 cannot be accepted until required device checks and user visual approval are complete.

W2 cloud/cliff/watercourse review and deferred storage/multiplayer checks remain open. Do not expand an unapproved courtyard kit across the world as finished art.

## Sync note

Rojo plugin was disconnected during construction. Local files were kept as source of truth and matching sources were sent directly through the connected Studio MCP interface. Rojo serve was restarted on localhost:34872. The plugin must reconnect in Edit mode to restore automatic ongoing sync.
