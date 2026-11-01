# ``SystemSoundsLibrary``

An optional convenience layer over System Sound Services: named constants with availability information.

## Overview

You don't need this package to play system sounds. `AudioToolbox` ships with the SDK, and one
call is enough:

```swift
import AudioToolbox

AudioServicesPlaySystemSound(1003) // SMSReceived
```

The [iOSSystemSoundsLibrary](https://github.com/TUNER88/iOSSystemSoundsLibrary) README lists the
IDs and sound files, with copy-paste snippets for Swift, SwiftUI and Objective-C.

If you'd rather use names than raw IDs, `SystemSoundsLibrary` wraps the same calls. It has a
typed catalog of 418 known sounds, generated from `data/sounds.json`, with `@available`
annotations for sounds added in newer iOS versions:

```swift
import SystemSoundsLibrary

SystemSoundPlayer.play(.smsReceived)          // same as AudioServicesPlaySystemSound(1003)
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
