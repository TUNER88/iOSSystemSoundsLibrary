# Choosing between system sounds and haptics

Use the right API for feedback, alerts and notifications.

## Overview

System sounds are short, fire-and-forget audio cues. For many use cases, Apple offers a
better-suited API:

- **Tactile feedback**: use `UIFeedbackGenerator` subclasses, Core Haptics, or SwiftUI's
  `.sensoryFeedback(_:trigger:)` (iOS 17+) instead of ``SystemSoundPlayer/vibrate()``.
- **Keyboard clicks**: use `UIDevice.playInputClick()` in a view that adopts
  `UIInputViewAudioFeedback`.
- **Notifications**: `UNNotificationSound` only plays files from your app bundle or your app
  container's `Library/Sounds` directory, so you can't use these IDs there.
- **Media-volume playback**: system sounds follow the ringer/alert volume. Use `AVAudioPlayer`
  if your sound must follow the media volume.
- **watchOS**: System Sound Services isn't available. Use `WKInterfaceDevice.play(_:)`.
