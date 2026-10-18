# Data

Machine-readable catalog of iOS system sounds. It backs the README tables and the Swift package.

| File | Contents |
| --- | --- |
| `sounds.json` | 418 SystemSoundIDs: file, folder, category, minimum iOS, status, confidence, source |
| `sounds.schema.json` | JSON Schema (draft 2020-12) for `sounds.json` |
| `uisounds/ios-7.0.2.txt` | Files in `/System/Library/Audio/UISounds` on iOS 7.0.2 (the original README list) |
| `uisounds/ios-{17,18,18.1,26,27}.txt` | Files in `/System/Library/Audio/UISounds` on later iOS versions |

Run `python3 scripts/validate_data.py` (needs `jsonschema`) to check the data. CI runs it on every pull request.

## `sounds.json` fields

| Field | Type | Meaning |
| --- | --- | --- |
| `id` | integer | SystemSoundID for `AudioServicesPlaySystemSound` |
| `name` | string | Stable lowerCamelCase identifier, used for generated Swift constants |
| `file` | string or null | Sound file name. `null` = no file (vibration/haptic-only or unknown) |
| `folder` | string or null | Sub-folder of `/System/Library/Audio/UISounds`: `""` (root), `New`, `Modern`, `nano` |
| `path` | string or null | Full file path on recent iOS (checked against the iOS 26 file list) |
| `category` | string or null | Internal category name |
| `minIOS` | string or null | First iOS version with this ID (`"17.0"`). `null` = available before iOS 16 or unknown |
| `status` | enum | `current`, `changed-since-ios7` (file or category differs from the iOS 7 table), `removed` |
| `confidence` | enum | `high`: iOS 7 table and p-x9 agree and the file exists. `medium`: one community source, file exists. `low`: sources conflict or the file is gone |
| `source` | array | Which sources list it: `readme-ios7`, `p-x9`, `onj-dump` |
| `ios7` | object or null | `{file, category}` exactly as in the original README table, if listed there |
| `notes` | string or null | Free-text caveats |

None of this is documented by Apple. IDs and files can change between iOS versions, so test on a device.

## Sources and attribution

- **Original iOS 7 table and file list**: this repository's README (collected on iOS 7 / 7.0.2).
- **p-x9/swift-system-sound**: the SystemSoundID → file/category mapping and the minimum iOS versions (up to iOS 26.0) come from [SystemSoundTable.md](https://github.com/p-x9/swift-system-sound/blob/e3f44c2d5766b0a7c3cdaacd4d61b5e1c8804794/SystemSoundTable.md) at commit `e3f44c2`, used under the MIT License:

```text
MIT License

Copyright (c) 2023 p-x9

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

- **File lists for iOS 17–27**: directory listings of the filesystem dumps at <https://3.onj.me/phonetones/unzipped/Apple/> (`iOS-17`, `iOS-18`, `iOS-18.1`, `iOS-26`, `iOS-27`), retrieved 2026-10-18. Only file names were recorded; no audio files are redistributed.
