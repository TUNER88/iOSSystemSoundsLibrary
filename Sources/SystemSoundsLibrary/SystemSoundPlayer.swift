import AudioToolbox

/// Plays ``SystemSound`` values with System Sound Services.
///
/// Completion handlers run on an arbitrary thread, so they are `@Sendable`. Hop to the
/// main actor yourself (for example with `Task { @MainActor in … }`) if you touch UI state.
public enum SystemSoundPlayer {
    /// `kSystemSoundID_Vibrate` (4095).
    public static let vibrateID: SystemSoundID = 0x0000_0FFF

    /// Plays a system sound. Returns immediately.
    public static func play(_ sound: SystemSound) {
        AudioServicesPlaySystemSound(sound.id)
    }

    /// Plays a system sound and calls `completion` when it has finished.
    public static func play(_ sound: SystemSound, completion: @escaping @Sendable () -> Void) {
        AudioServicesPlaySystemSoundWithCompletion(sound.id, completion)
    }

    /// Plays a system sound and waits until it has finished.
    public static func playAndWait(_ sound: SystemSound) async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            AudioServicesPlaySystemSoundWithCompletion(sound.id) {
                continuation.resume()
            }
        }
    }

    /// Plays a system sound as an alert (may also vibrate, depending on the device and settings).
    public static func playAlert(_ sound: SystemSound) {
        AudioServicesPlayAlertSound(sound.id)
    }

    /// Plays a system sound as an alert and calls `completion` when it has finished.
    public static func playAlert(_ sound: SystemSound, completion: @escaping @Sendable () -> Void) {
        AudioServicesPlayAlertSoundWithCompletion(sound.id, completion)
    }

    /// Plays a system sound as an alert and waits until it has finished.
    public static func playAlertAndWait(_ sound: SystemSound) async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            AudioServicesPlayAlertSoundWithCompletion(sound.id) {
                continuation.resume()
            }
        }
    }

    /// Triggers a short vibration on devices that support it. Does nothing elsewhere.
    ///
    /// For UI feedback, prefer `UIFeedbackGenerator`, Core Haptics or SwiftUI's `.sensoryFeedback`.
    public static func vibrate() {
        AudioServicesPlayAlertSound(vibrateID)
    }
}
