#!/usr/bin/env python3
"""Generate the README sections derived from data/.

The generated block sits between the BEGIN/END markers below and is inserted
right after the "List of all system audio files in iOS 7.0.2" section the
first time. Everything outside the markers is never touched.

Usage:
  python3 scripts/generate_readme.py          # update README.md in place
  python3 scripts/generate_readme.py --check  # exit 1 if README.md is out of date
"""
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
README = ROOT / "README.md"
BEGIN = "<!-- BEGIN GENERATED: scripts/generate_readme.py from data/. Do not edit by hand. -->"
END = "<!-- END GENERATED -->"
ANCHOR_SECTION = "## List of all system audio files in iOS 7.0.2"
TOC_AFTER = "  - [List of all system audio files in iOS 7.0.2](#list-of-all-system-audio-files-in-ios-702)\n"
TOC_AFTER_FALLBACK = "- [List of all system audio files in iOS 7.0.2](#list-of-all-system-audio-files-in-ios-702)\n"
TOC_LINES = [
    "- [SystemSoundIDs added after iOS 7](#systemsoundids-added-after-ios-7)\n",
    "- [List of all system audio files in iOS 26](#list-of-all-system-audio-files-in-ios-26)\n",
    "- [List of all system audio files in iOS 27](#list-of-all-system-audio-files-in-ios-27)\n",
    "- [Changes since iOS 7](#changes-since-ios-7)\n",
]
P9 = "[p-x9](https://github.com/p-x9/swift-system-sound/blob/e3f44c2d5766b0a7c3cdaacd4d61b5e1c8804794/SystemSoundTable.md)"
BASE = "/System/Library/Audio/UISounds/"


def cell(v):
    return "-" if v in (None, "") else str(v).replace("|", "\\|").replace("~", "\\~")


def files(version):
    return (ROOT / f"data/uisounds/ios-{version}.txt").read_text().split()


def build():
    data = json.loads((ROOT / "data/sounds.json").read_text())
    sounds = data["sounds"]
    out = [BEGIN, ""]

    new = [s for s in sounds if s["ios7"] is None]
    out += [
        "## SystemSoundIDs added after iOS 7",
        "",
        f"{len(new)} IDs that aren't in the iOS 7 table above. Mappings and minimum versions come from {P9} (MIT, iOS 16–26.0). Files were checked against the iOS 26 file list. "
        "Like everything here, they are unofficial, so test on a device. \"≤ 16\" means the ID existed in iOS 16 or earlier. The source data is in [`data/sounds.json`](data/sounds.json).",
        "",
        "| SystemSoundID | File name | Folder | Category | Min iOS | Confidence |",
        "| --- | --- | --- | --- | --- | --- |",
    ]
    for s in new:
        folder = "(root)" if s["folder"] == "" else s["folder"]
        out.append(f"| {s['id']} | {cell(s['file'])} | {cell(folder)} | {cell(s['category'])} | {s['minIOS'] or '≤ 16'} | {s['confidence']} |")
    out.append("")

    for v, note in (("26", "September 2025"), ("27", "September 2026; SystemSoundIDs for iOS 27 are not mapped yet")):
        lst = files(v)
        out += [
            f"## List of all system audio files in iOS {v}",
            "",
            f"{len(lst)} files, from a filesystem dump of iOS {v} ({note}). Source: <https://3.onj.me/phonetones/unzipped/Apple/iOS-{v}/System/Library/Audio/UISounds/>, also in [`data/uisounds/ios-{v}.txt`](data/uisounds/ios-{v}.txt).",
            "",
            "```text",
            *lst,
            "```",
            "",
        ]

    out += [
        "## Changes since iOS 7",
        "",
        f"Differences between the original iOS 7 data above (left unchanged) and recent iOS versions. Sources: {P9} and the iOS 17–27 file lists in [`data/uisounds/`](data/uisounds/).",
        "",
        "### File mapping differs",
        "",
        "| SystemSoundID | iOS 7 file | Current file | Note |",
        "| --- | --- | --- | --- |",
    ]
    for s in sounds:
        if s["ios7"] and s["status"] == "changed-since-ios7" and s["ios7"]["file"] != s["file"]:
            gone = s["ios7"]["file"] and not any(p.endswith("/" + s["ios7"]["file"]) for p in files("26"))
            out.append(f"| {s['id']} | {cell(s['ios7']['file'])} | {cell(s['path'])} | {'iOS 7 file no longer exists' if gone else 'both files exist; verify on device'} |")
    out += ["", "### Category differs", "", "| SystemSoundID | File name | iOS 7 category | Current category |", "| --- | --- | --- | --- |"]
    for s in sounds:
        if s["ios7"] and s["ios7"]["file"] == s["file"] and s["ios7"]["category"] != s["category"]:
            out.append(f"| {s['id']} | {cell(s['file'])} | {cell(s['ios7']['category'])} | {cell(s['category'])} |")
    out += ["", "### IDs no longer listed", "", "| SystemSoundID | iOS 7 file | iOS 7 category | Note |", "| --- | --- | --- | --- |"]
    for s in sounds:
        if s["status"] == "removed":
            out.append(f"| {s['id']} | {cell(s['ios7']['file'])} | {cell(s['ios7']['category'])} | not listed by p-x9, file not in the iOS 17–27 file lists |")

    old = files("7.0.2")
    recent = set().union(*(files(v) for v in ("17", "18", "18.1", "26", "27")))
    by_name = {}
    for p in sorted(recent):
        by_name.setdefault(p.rsplit("/", 1)[1], []).append(p)
    moved = [(p, by_name[p.rsplit("/", 1)[1]]) for p in old if p not in recent and p.rsplit("/", 1)[1] in by_name]
    removed = [p for p in old if p not in recent and p.rsplit("/", 1)[1] not in by_name]
    out += ["", "### Files moved", "", f"{len(moved)} files from the iOS 7.0.2 list now live in a different folder (matched by file name).", "", "| iOS 7.0.2 path | Path on iOS 17–27 |", "| --- | --- |"]
    out += [f"| {cell(p)} | {cell(', '.join(n))} |" for p, n in moved]
    out += ["", "### Files removed", "", f"{len(removed)} files from the iOS 7.0.2 list are not in any of the iOS 17–27 file lists.", "", "```text", *removed, "```", "", END]
    return "\n".join(out) + "\n"


def render(readme, block):
    if BEGIN in readme:
        start = readme.index(BEGIN)
        end = readme.index(END, start) + len(END) + 1
        return readme[:start] + block + readme[end:]
    i = readme.index(ANCHOR_SECTION)
    j = readme.index("\n## ", i + len(ANCHOR_SECTION)) + 1
    readme = readme[:j] + block + "\n" + readme[j:]
    after = TOC_AFTER if TOC_AFTER in readme else TOC_AFTER_FALLBACK
    k = readme.index(after) + len(after)
    return readme[:k] + "".join(TOC_LINES) + readme[k:]


def main():
    current = README.read_text()
    updated = render(current, build())
    if "--check" in sys.argv:
        if updated != current:
            print("README.md is out of date: run python3 scripts/generate_readme.py")
            sys.exit(1)
        print("README.md generated sections are up to date")
        return
    README.write_text(updated)


if __name__ == "__main__":
    main()
