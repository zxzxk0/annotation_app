Files:
- make_gene_json.py: rebuilds cell_polygons.json + gene_expression.json locally
- docs/viewer.js: cached Path2D renderer, H&E-frame static overlay
- docs/slides.json: PreSCCT1_HE.ome only
- apply_to_annotation_app.bat: applies files and rebuilds JSON

Expected checks:
- 191,704 cells
- 101 cell types
- 6,175 genes
- all polygon coordinates within 37482 x 82972 H&E bounds
