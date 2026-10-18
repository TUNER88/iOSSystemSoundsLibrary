# Getting started

Add the package and play your first system sound.

## Add the package

In Xcode, choose **File > Add Package Dependencies…** and enter
`https://github.com/TUNER88/iOSSystemSoundsLibrary`. Or add it to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/TUNER88/iOSSystemSoundsLibrary", branch: "master"),
],
targets: [
    .target(name: "MyApp", dependencies: [
        .product(name: "SystemSoundsLibrary", package: "iOSSystemSoundsLibrary"),
    ]),
]
```

## Play a sound

Use a named constant or look a sound up by its ID:

```swift
import SystemSoundsLibrary

SystemSoundPlayer.play(.smsReceived)

if let sound = SystemSound.sound(withID: 1157) {
    SystemSoundPlayer.play(sound)   // wheels_of_time.caf
}
```

``SystemSoundPlayer/playAndWait(_:)`` suspends until the sound has finished. The completion
handlers of ``SystemSoundPlayer/play(_:completion:)`` are `@Sendable` because AudioToolbox
calls them on an arbitrary thread. Hop to the main actor before you touch UI state:

```swift
SystemSoundPlayer.play(.mailReceived) {
    Task { @MainActor in
        model.isPlaying = false
    }
}
```

## Newer and removed sounds

Constants for sounds introduced in iOS 16 or later carry `@available` annotations, so the
compiler asks for an `if #available` check. Sounds whose file no longer exists are marked
deprecated. ``SystemSound/confidence`` tells you how reliable a mapping is:

- term ``SystemSound/Confidence/high``: The iOS 7 table and current sources agree, and the file exists.
- term ``SystemSound/Confidence/medium``: One community source, and the file exists.
- term ``SystemSound/Confidence/low``: Sources conflict, or the file is gone.

## Play a file

``FileSound`` creates a `SystemSoundID` from an audio file and disposes of it automatically:

```swift
let sound = try FileSound(.mailReceived)
await sound.playAndWait()
```
