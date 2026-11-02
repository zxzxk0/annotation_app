import csv
import json
from pathlib import Path
from collections import OrderedDict

CELL_CSV = Path(r"C:\Users\zxzxk\Downloads\cell_polygons(in).csv")
GENE_CSV = Path(r"C:\Users\zxzxk\Downloads\GeneExpression.csv")

OUT_DIR = Path(r"C:\Users\zxzxk\Downloads\annotation_app\docs\data\gene_expression\PreSCCT1_HE.ome")
OUT_DIR.mkdir(parents=True, exist_ok=True)

POLY_OUT = OUT_DIR / "cell_polygons.json"
EXPR_OUT = OUT_DIR / "gene_expression.json"

# ------------------------------------------------------------
# 1) Read corrected polygon CSV
# ------------------------------------------------------------
cells = OrderedDict()
cell_types = []
type_to_idx = {}

rows = 0
xmin = ymin = float("inf")
xmax = ymax = float("-inf")

with CELL_CSV.open("r", encoding="utf-8-sig", newline="") as f:
    reader = csv.DictReader(f)

    required = {"cell", "x_he_px", "y_he_px", "cell_type"}
    missing = required - set(reader.fieldnames or [])
    if missing:
        raise RuntimeError(f"Missing columns in cell CSV: {missing}")

    for row in reader:
        rows += 1

        cid = str(row["cell"])
        ctype = str(row["cell_type"])
        x = round(float(row["x_he_px"]), 2)
        y = round(float(row["y_he_px"]), 2)

        if ctype not in type_to_idx:
            type_to_idx[ctype] = len(cell_types)
            cell_types.append(ctype)

        if cid not in cells:
            cells[cid] = [type_to_idx[ctype], []]

        cells[cid][1].extend([x, y])

        xmin = min(xmin, x)
        xmax = max(xmax, x)
        ymin = min(ymin, y)
        ymax = max(ymax, y)

print("Rows:", rows)
print("Unique cells:", len(cells))
print("Cell types:", len(cell_types))
print("X range:", xmin, xmax)
print("Y range:", ymin, ymax)

assert len(cells) == 191704, f"Expected 191704 cells, got {len(cells)}"
assert len(cell_types) == 101, f"Expected 101 types, got {len(cell_types)}"

poly = {
    "version": 3,
    "slide_id": "PreSCCT1_HE.ome",
    "coordinate_space": "he_level0_px",
    "types": cell_types,
    "cells": [[cid, t_idx, coords] for cid, (t_idx, coords) in cells.items()],
    "meta": {
        "rows": rows,
        "unique_cells": len(cells),
        "cell_types": len(cell_types),
        "x_min": xmin,
        "x_max": xmax,
        "y_min": ymin,
        "y_max": ymax
    }
}

with POLY_OUT.open("w", encoding="utf-8") as f:
    json.dump(poly, f, separators=(",", ":"))

print("Saved:", POLY_OUT)

# ------------------------------------------------------------
# 2) Read gene expression CSV and align to polygon type order
# ------------------------------------------------------------
with GENE_CSV.open("r", encoding="utf-8-sig", newline="") as f:
    reader = csv.DictReader(f)
    fields = reader.fieldnames or []

    if len(fields) < 2:
        raise RuntimeError("GeneExpression.csv has too few columns")

    gene_col = fields[0]

    missing_types = [t for t in cell_types if t not in fields]
    if missing_types:
        raise RuntimeError(
            f"{len(missing_types)} polygon cell types missing from GeneExpression.csv: "
            f"{missing_types[:10]}"
        )

    genes = {}

    for row in reader:
        gene = str(row[gene_col])
        vals = []

        for t in cell_types:
            raw = row[t]
            try:
                vals.append(float(raw))
            except (TypeError, ValueError):
                vals.append(None)

        genes[gene] = vals

expr = {
    "version": 3,
    "slide_id": "PreSCCT1_HE.ome",
    "types": cell_types,
    "genes": genes
}

with EXPR_OUT.open("w", encoding="utf-8") as f:
    json.dump(expr, f, separators=(",", ":"))

print("Genes:", len(genes))
assert len(genes) == 6175, f"Expected 6175 genes, got {len(genes)}"

print("Saved:", EXPR_OUT)

# ------------------------------------------------------------
# 3) Final sanity checks
# ------------------------------------------------------------
assert xmin >= 0 and xmax <= 37482
assert ymin >= 0 and ymax <= 82972

print()
print("ALL CHECKS PASSED")
print("191,704 cells / 101 types / 6,175 genes")
