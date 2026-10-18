import AudioToolbox
import Foundation

/// An iOS system sound, identified by its `SystemSoundID`.
///
/// The named constants (for example ``SystemSound/mailReceived``) are generated from
/// `data/sounds.json`. Apple doesn't document these IDs and file names. They can differ
/// between iOS versions, so check ``confidence`` and test on a device.
public struct SystemSound: Hashable, Sendable, Identifiable, CustomStringConvertible {
    /// How the sound relates to the original iOS 7 table.
    public enum Status: String, Hashable, Sendable {
        /// Listed by current sources with the same mapping as before.
        case current
        /// Still listed, but the file or category differs from the iOS 7 table.
        case changedSinceIOS7 = "changed-since-ios7"
        /// Only in the iOS 7 table; the file no longer exists on recent iOS.
        case removed
    }

    /// How reliable the mapping is.
    public enum Confidence: String, Hashable, Sendable, Comparable {
        /// Sources conflict or the file is gone.
        case low
        /// One community source; the file exists.
        case medium
        /// The iOS 7 table and current sources agree and the file exists.
        case high

        private var rank: Int {
            switch self {
            case .low: 0
            case .medium: 1
            case .high: 2
            }
        }

        public static func < (lhs: Confidence, rhs: Confidence) -> Bool { lhs.rank < rhs.rank }
    }

    /// The directory that contains the system sound files on iOS.
    public static let directory = "/System/Library/Audio/UISounds"

    /// The `SystemSoundID` to pass to `AudioServicesPlaySystemSound`.
    public let id: SystemSoundID
    /// A stable lowerCamelCase name, matching the static constant.
    public let name: String
    /// The sound file name, or `nil` for IDs without a file (for example vibration only).
    public let fileName: String?
    /// The subfolder of ``directory`` (`""` for the root, `"New"`, `"Modern"`, `"nano"`), or `nil`.
    public let folder: String?
    /// The internal category name, if known.
    public let category: String?
    /// The first iOS version with this ID (for example `"17.0"`), or `nil` if available before iOS 16 or unknown.
    public let minimumIOSVersion: String?
    /// How the sound relates to the original iOS 7 table.
    public let status: Status
    /// How reliable the mapping is.
    public let confidence: Confidence

    public init(
        id: SystemSoundID,
        name: String,
        fileName: String? = nil,
        folder: String? = nil,
        category: String? = nil,
        minimumIOSVersion: String? = nil,
        status: Status = .current,
        confidence: Confidence = .low
    ) {
        self.id = id
        self.name = name
        self.fileName = fileName
        self.folder = folder
        self.category = category
        self.minimumIOSVersion = minimumIOSVersion
        self.status = status
        self.confidence = confidence
    }

    /// A sound for an arbitrary ID that isn't in the catalog.
    public static func custom(_ id: SystemSoundID) -> SystemSound {
        SystemSound(id: id, name: "sound\(id)")
    }

    /// Looks up a catalog sound by its ID.
    public static func sound(withID id: SystemSoundID) -> SystemSound? {
        byID[id]
    }

    private static let byID: [SystemSoundID: SystemSound] = Dictionary(
        all.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first }
    )

    /// The full path of the sound file on recent iOS, if the sound has a file.
    public var path: String? {
        guard let fileName, let folder else { return nil }
        return folder.isEmpty ? "\(Self.directory)/\(fileName)" : "\(Self.directory)/\(folder)/\(fileName)"
    }

    /// The file URL of the sound file, if the sound has a file.
    public var fileURL: URL? {
        path.map { URL(fileURLWithPath: $0) }
    }

    public var description: String {
        "\(name) (\(id)\(fileName.map { ", \($0)" } ?? ""))"
    }
}
