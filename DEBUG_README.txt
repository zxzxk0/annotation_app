Chunked debug renderer

Why:
- The previous renderer aggregated 191,704 polygons into 101 giant Path2D objects.
- With millions of vertices, browser canvas/path implementations can silently
  truncate or behave unpredictably.
- This renderer draws each cell polygon directly in batches of 1,500.

What to look for in Chrome console:
1. [Gene Expression DEBUG] render start
2. progress messages
3. [Gene Expression DEBUG] render complete
4. console.table with Y bands (0-10k, 10-20k, ..., 80k+)
5. "cells drawn below Y=40,000"
6. "ALL polygon cells were rasterized."

Manual console helpers:
  geneRenderDebugReport()
  geneCanvasDebug()

Expected:
- totalCells = 191704
- drawn = 191704
- badGeometry = 0
- unmappedType = 0
- substantial counts in Y bands below 40,000
- canvas approximately 4096 x 9066

Interpretation:
- If all 191704 are drawn and lower Y bands have cells, but lower tissue is
  still absent visually, the problem is OSD/canvas placement or browser canvas
  sizing/compositing rather than the polygon data.
