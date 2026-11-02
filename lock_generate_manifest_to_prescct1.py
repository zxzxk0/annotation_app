from pathlib import Path

p = Path("generate_manifest.py")
if not p.exists():
    raise SystemExit("generate_manifest.py not found")

s = p.read_text(encoding="utf-8", errors="replace")

needle = "slide_id = slide_dir.name"
guard = '''slide_id = slide_dir.name
        if slide_id != "PreSCCT1_HE.ome":
            continue'''

if 'if slide_id != "PreSCCT1_HE.ome":' not in s:
    if needle not in s:
        raise SystemExit("Could not find slide_id assignment")
    s = s.replace(needle, guard, 1)

old = 'cx_dzis = list(cx_dir.glob("*.dzi")) if cx_dir.exists() else []'
new = 'cx_dzis = [p for p in cx_dir.glob("*.dzi") if not p.name.endswith("_registered.dzi")] if cx_dir.exists() else []'
s = s.replace(old, new)

p.write_text(s, encoding="utf-8")
print("generate_manifest.py locked to PreSCCT1_HE.ome")
