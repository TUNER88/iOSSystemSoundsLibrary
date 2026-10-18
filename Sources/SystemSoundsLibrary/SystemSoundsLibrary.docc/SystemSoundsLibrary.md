# ``SystemSoundsLibrary``

Play iOS system sounds by name, with availability information and Swift 6 concurrency safety.

## Overview

`SystemSoundsLibrary` wraps System Sound Services (`AudioToolbox`) with a typed catalog of 418 known
system sounds. The catalog is generated from `data/sounds.json` in the
[iOSSystemSoundsLibrary](https://github.com/TUNER88/iOSSystemSoundsLibrary) repository.

```swift
import SystemSoundsLibrary

SystemSoundPlayer.play(.smsReceived)          // 1003
await SystemSoundPlayer.playAndWait(.mailSentMailSent)

if #available(iOS 17.0, *) {
    SystemSoundPlayer.play(.airDropInvitation) // added in iOS 17
}
```

> Important: Apple doesn't document these IDs and file names. They can differ between iOS
> versions, so check ``SystemSound/confidence`` and test on a device. The iOS Simulator doesn't
> play system sounds.

## Topics

### Essentials

- <doc:GettingStarted>
- ``SystemSound``
- ``SystemSoundPlayer``

### Playing sound files

- ``FileSound``

### Guidance

- <doc:SoundsOrHaptics>
- <doc:AppReview>
