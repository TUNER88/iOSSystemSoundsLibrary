#!/usr/bin/env python3
"""Validate data/sounds.json against its schema and basic invariants."""
import json
import re
import sys
from pathlib import Path

import jsonschema

ROOT = Path(__file__).resolve().parent.parent
data = json.loads((ROOT / "data/sounds.json").read_text())
schema = json.loads((ROOT / "data/sounds.schema.json").read_text())
jsonschema.validate(data, schema)

errors = []
sounds = data["sounds"]
ids = [s["id"] for s in sounds]
names = [s["name"] for s in sounds]
if len(ids) != len(set(ids)):
    errors.append("duplicate ids")
if len(names) != len(set(names)):
    errors.append("duplicate names")
if ids != sorted(ids):
    errors.append("sounds are not sorted by id")

latest = set((ROOT / "data/uisounds/ios-26.txt").read_text().split())
for s in sounds:
    if s["path"] and s["status"] != "removed" and s["path"] not in latest:
        errors.append(f"{s['id']}: path {s['path']} not in data/uisounds/ios-26.txt")
    if s["file"] and s["path"] and not s["path"].endswith("/" + s["file"]):
        errors.append(f"{s['id']}: path does not end with file name")

# Every row of the original README table must be represented with its iOS 7 mapping.
readme = (ROOT / "README.md").read_text()
table = readme[readme.index("| SystemSoundID | File name | Category |"):]
table = table[: table.index("\n\n")]
by_id = {s["id"]: s for s in sounds}
rows = re.findall(r"^\| (\d+) \| (.+?) \| (.+?) \|$", table, re.M)
for sid, f, cat in rows:
    s = by_id.get(int(sid))
    unesc = lambda v: None if v == "-" else v.replace("\\~", "~")
    if not s or s["ios7"] != {"file": unesc(f), "category": unesc(cat)}:
        errors.append(f"README row {sid} not represented correctly")
if len(rows) != 125:
    errors.append(f"expected 125 README rows, found {len(rows)}")

if errors:
    print("\n".join(errors))
    sys.exit(1)
print(f"OK: {len(sounds)} sounds, {len(rows)} README rows covered")
