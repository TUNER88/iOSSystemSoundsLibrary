import SwiftUI
import SystemSoundsLibrary

/// Shows everything known about a sound and lets you share or save its file.
struct SoundDetailView: View {
    let sound: SystemSound
    @State private var exportURL: URL?

    var body: some View {
        Form {
            Section {
                Button("Play", systemImage: "play.fill") {
                    SystemSoundPlayer.play(sound)
                }
                Button("Play as alert", systemImage: "bell.fill") {
                    SystemSoundPlayer.playAlert(sound)
                }
                if let exportURL {
                    ShareLink(item: exportURL) {
                        Label("Share or save file", systemImage: "square.and.arrow.up")
                    }
                }
            } footer: {
                if sound.fileURL != nil && exportURL == nil {
                    Text("The sound file can't be read here (for example in the Simulator).")
                }
            }

            Section("Details") {
                LabeledContent("ID", value: String(sound.id))
                LabeledContent("Name", value: sound.name)
                LabeledContent("Path") {
                    Text(sound.path ?? "—")
                        .font(.caption.monospaced())
                        .textSelection(.enabled)
                }
                LabeledContent("Category", value: sound.category ?? "—")
                LabeledContent(
                    "Available since",
                    value: sound.minimumIOSVersion.map { "iOS \($0)" } ?? "Before iOS 16 or unknown"
                )
                LabeledContent("Status", value: sound.status.label)
                LabeledContent("Confidence", value: sound.confidence.rawValue)
            }
        }
        .navigationTitle(sound.name)
        .navigationBarTitleDisplayMode(.inline)
        .task(id: sound) {
            exportURL = Self.exportCopy(of: sound)
        }
    }

    /// Copies the sound file into the temporary directory so it can be shared.
    private static func exportCopy(of sound: SystemSound) -> URL? {
        guard let source = sound.fileURL, let fileName = sound.fileName,
              FileManager.default.isReadableFile(atPath: source.path) else { return nil }
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent("Export", isDirectory: true)
        let destination = directory.appendingPathComponent(fileName)
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            if FileManager.default.fileExists(atPath: destination.path) {
                try FileManager.default.removeItem(at: destination)
            }
            try FileManager.default.copyItem(at: source, to: destination)
            return destination
        } catch {
            return nil
        }
    }
}

extension SystemSound.Status {
    var label: String {
        switch self {
        case .current: "Current"
        case .changedSinceIOS7: "Changed since iOS 7"
        case .removed: "Removed"
        }
    }
}

#Preview {
    NavigationStack {
        SoundDetailView(sound: .mailReceived)
    }
}
