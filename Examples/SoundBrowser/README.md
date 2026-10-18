# SoundBrowser

A small SwiftUI app that uses the `SystemSoundsLibrary` Swift package from this repository.

- Search by name, ID, file name or category
- Sounds grouped by folder (`UISounds`, `UISounds/New`, `UISounds/Modern`, `UISounds/nano`)
- Tap a row to play the sound; the info button shows ID, path, category, availability and confidence
- Share or save the sound file from the details screen

Open `SoundBrowser.xcodeproj` in Xcode 16 or later and run it on a device with iOS 17 or later.
The iOS Simulator doesn't play system sounds, and the sound files can't be read there, so
sharing is only available on a device.

The app reads files from `/System/Library/Audio/UISounds` to share them. That's fine for a
developer tool, but don't ship it in an App Store app (App Review Guideline 2.5.2).

The original Objective-C demo app is still at the repository root (`SystemSoundLibrary.xcodeproj`).
