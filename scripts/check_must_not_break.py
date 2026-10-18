#!/usr/bin/env python3
"""Fail if anything that external sites link to or quote disappears.

Stack Overflow answers, blog posts and code comments link to this repository's README
anchors, quote the demo app, and use raw file URLs. This check keeps them working.
Run: python3 scripts/check_must_not_break.py [--online]
  --online also checks the screenshot URLs on the `readme` branch.
"""
import hashlib
import re
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# README heading anchors that must keep existing (GitHub slugs).
ANCHORS = [
    "iossystemsoundslibrary",
    "contents",
    "usage",
    "swift",
    "swiftui",
    "objective-c",
    "list-of-systemsoundids",  # also linked externally (?tab=readme-ov-file#list-of-systemsoundids)
    "list-of-all-system-audio-files-in-ios-702",
    "faq",
    "why-dont-the-sounds-follow-the-volume-buttons--media-volume",
    "why-cant-i-hear-anything-in-the-simulator-what-is-the-mgisdeviceoneoftype-is-not-supported-on-this-platform-log",
    "can-i-use-the-systemsoundid-returned-by-audioservicescreatesystemsoundid",
    "related-projects",
    "screenshot",
    "license",
]

# Files that must keep existing at these paths (raw/blob links, quoted code, Xcode project).
PATHS = [
    "README.md",
    "LICENSE",
    "SystemSoundLibrary.xcodeproj/project.pbxproj",
    "SystemSoundLibrary.xcodeproj/project.xcworkspace/contents.xcworkspacedata",
    "SystemSoundLibrary/AppDelegate.h",
    "SystemSoundLibrary/AppDelegate.m",
    "SystemSoundLibrary/Base.lproj/Main_iPad.storyboard",
    "SystemSoundLibrary/Base.lproj/Main_iPhone.storyboard",
    "SystemSoundLibrary/Images.xcassets/AppIcon.appiconset/Contents.json",
    "SystemSoundLibrary/Images.xcassets/LaunchImage.launchimage/Contents.json",
    "SystemSoundLibrary/SoundListViewController.h",
    "SystemSoundLibrary/SoundListViewController.m",
    "SystemSoundLibrary/SystemSoundLibrary-Info.plist",
    "SystemSoundLibrary/SystemSoundLibrary-Prefix.pch",
    "SystemSoundLibrary/en.lproj/InfoPlist.strings",
    "SystemSoundLibrary/main.m",
    "SystemSoundLibraryTests/SystemSoundLibraryTests-Info.plist",
    "SystemSoundLibraryTests/SystemSoundLibraryTests.m",
    "SystemSoundLibraryTests/en.lproj/InfoPlist.strings",
]

# Exact content that must stay byte-identical (sha256 of the extracted block).
README_TABLE_SHA256 = "78059fb8b6f03effa80d9dbe5a65cb7dcf045535c4a46b3350a72fe47edc28cf"
README_IOS7_LIST_SHA256 = "d250f47b0b12dd04ac51a32ac8f7d309cd16523eb263edd701798be72394bf77"
DEMO_SHA256 = {
    "SystemSoundLibrary/SoundListViewController.m": "6d2c50fb0af2df0f02f68636eaafdc318bb38440e5f1f71c8c6a819d45ebccf4",  # quoted on Stack Overflow
}

SCREENSHOT_URLS = [
    "https://raw.githubusercontent.com/TUNER88/iOSSystemSoundsLibrary/readme/img/screenshot.png",
    "https://raw.github.com/TUNER88/iOSSystemSoundsLibrary/readme/img/screenshot.png",
]


def slug(heading):
    return re.sub(r"[^\w\- ]", "", heading.strip().lower()).replace(" ", "-")


def readme_anchors(text):
    text = re.sub(r"```.*?```", "", text, flags=re.S)
    return {slug(h) for h in re.findall(r"^#{1,6} (.+)$", text, re.M)}


def readme_table(text):
    start = text.index("| SystemSoundID | File name | Category |")
    return text[start : text.index("\n\n", start)]


def readme_ios7_list(text):
    start = text.index("## List of all system audio files in iOS 7.0.2")
    fence = text.index("```", start)
    return text[start : text.index("\n```\n", fence + 3) + 5]


def sha(s):
    return hashlib.sha256(s.encode() if isinstance(s, str) else s).hexdigest()


def main():
    errors = []
    for p in PATHS:
        if not (ROOT / p).is_file():
            errors.append(f"missing file: {p}")

    readme = (ROOT / "README.md").read_text()
    have = readme_anchors(readme)
    errors += [f"missing README anchor: #{a}" for a in ANCHORS if a not in have]

    try:
        table = readme_table(readme)
        if sha(table) != README_TABLE_SHA256:
            errors.append("README 'List of SystemSoundIDs' table changed (must stay byte-identical)")
        if len(re.findall(r"^\| \d", table, re.M)) != 125:
            errors.append("README ID table no longer has 125 rows")
    except ValueError:
        errors.append("README ID table not found")
    try:
        if sha(readme_ios7_list(readme)) != README_IOS7_LIST_SHA256:
            errors.append("README iOS 7.0.2 file list changed (must stay byte-identical)")
    except ValueError:
        errors.append("README iOS 7.0.2 file list not found")

    for p, digest in DEMO_SHA256.items():
        f = ROOT / p
        if f.is_file() and sha(f.read_bytes()) != digest:
            errors.append(f"{p} changed (quoted externally, must stay byte-identical)")

    pbxproj = ROOT / "SystemSoundLibrary.xcodeproj/project.pbxproj"
    if pbxproj.is_file() and "name = SystemSoundLibrary;" not in pbxproj.read_text():
        errors.append("Xcode target 'SystemSoundLibrary' not found in project.pbxproj")

    if "--online" in sys.argv:
        for url in SCREENSHOT_URLS:
            try:
                req = urllib.request.Request(url, method="HEAD", headers={"User-Agent": "must-not-break-check"})
                with urllib.request.urlopen(req, timeout=30) as resp:
                    if resp.status != 200:
                        errors.append(f"{url} returned {resp.status}")
            except Exception as exc:  # noqa: BLE001
                errors.append(f"{url} failed: {exc}")

    if errors:
        print("Must-not-break check failed:")
        print("\n".join(f"  - {e}" for e in errors))
        sys.exit(1)
    print(f"OK: {len(ANCHORS)} anchors, {len(PATHS)} paths, README table/list and demo source unchanged")


if __name__ == "__main__":
    main()
