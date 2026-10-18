import AudioToolbox
import Foundation

/// A system sound created from an audio file. The underlying `SystemSoundID` is
/// disposed of automatically when the object is deallocated.
///
/// ```swift
/// let sound = try FileSound(.mailReceived)
/// sound.play()
/// ```
public final class FileSound: Sendable {
    /// Errors thrown when a `FileSound` can't be created.
    public enum Error: Swift.Error, Hashable, Sendable {
        /// The ``SystemSound`` has no file.
        case noFile
        /// `AudioServicesCreateSystemSoundID` failed with this status.
        case creationFailed(OSStatus)
    }

    /// The `SystemSoundID` created for the file. Only valid for the lifetime of this object.
    public let soundID: SystemSoundID
    /// The file URL.
    public let url: URL

    /// Creates a sound from an audio file (`.caf`, `.aif` or `.wav`, 30 seconds or less).
    public init(url: URL) throws(FileSound.Error) {
        var id: SystemSoundID = 0
        let status = AudioServicesCreateSystemSoundID(url as CFURL, &id)
        guard status == kAudioServicesNoError else { throw .creationFailed(status) }
        soundID = id
        self.url = url
    }

    /// Creates a sound from the file of a catalog ``SystemSound``.
    public convenience init(_ sound: SystemSound) throws(FileSound.Error) {
        guard let url = sound.fileURL else { throw .noFile }
        try self.init(url: url)
    }

    deinit {
        AudioServicesDisposeSystemSoundID(soundID)
    }

    /// Plays the sound. Keep a reference to the object until it has finished playing.
    public func play() {
        AudioServicesPlaySystemSound(soundID)
    }

    /// Plays the sound and calls `completion` when it has finished. Keeps the object alive until then.
    public func play(completion: @escaping @Sendable () -> Void) {
        AudioServicesPlaySystemSoundWithCompletion(soundID) {
            withExtendedLifetime(self) { completion() }
        }
    }

    /// Plays the sound and waits until it has finished.
    public func playAndWait() async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            play { continuation.resume() }
        }
    }
}
