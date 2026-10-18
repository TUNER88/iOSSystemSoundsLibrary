import SwiftUI
import SystemSoundsLibrary

/// Lists all catalog sounds, grouped by folder. Tap a row to play it.
struct ContentView: View {
    @State private var query = ""
    @State private var hideRemoved = false
    @State private var selected: SystemSound?
    @State private var playCount = 0

    var body: some View {
        NavigationStack {
            List {
                ForEach(sections) { section in
                    Section {
                        ForEach(section.sounds) { sound in
                            SoundRow(sound: sound) {
                                SystemSoundPlayer.play(sound)
                                playCount += 1
                            } showDetails: {
                                selected = sound
                            }
                        }
                    } header: {
                        Text(verbatim: "\(section.id) (\(section.sounds.count))")
                    }
                }
            }
            .overlay {
                if sections.isEmpty {
                    ContentUnavailableView.search(text: query)
                }
            }
            .searchable(text: $query, prompt: "Name, ID, file or category")
            .navigationTitle("System Sounds")
            .navigationDestination(item: $selected) { sound in
                SoundDetailView(sound: sound)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                        Toggle("Hide removed sounds", isOn: $hideRemoved)
                    }
                }
            }
            .sensoryFeedback(.selection, trigger: playCount)
        }
    }

    private var sections: [SoundSection] {
        let needle = query.trimmingCharacters(in: .whitespaces).lowercased()
        let filtered = SystemSound.all.filter { sound in
            if hideRemoved && sound.status == .removed { return false }
            guard !needle.isEmpty else { return true }
            return [sound.name, String(sound.id), sound.fileName ?? "", sound.category ?? ""]
                .contains { $0.lowercased().contains(needle) }
        }
        let grouped = Dictionary(grouping: filtered) { $0.groupTitle }
        return grouped.keys.sorted().map { SoundSection(id: $0, sounds: grouped[$0] ?? []) }
    }
}

struct SoundSection: Identifiable {
    let id: String
    let sounds: [SystemSound]
}

struct SoundRow: View {
    let sound: SystemSound
    let play: () -> Void
    let showDetails: () -> Void

    var body: some View {
        HStack {
            Button(action: play) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(sound.name)
                        if sound.status == .removed {
                            Text("removed")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Text(verbatim: "\(sound.id) · \(sound.path ?? "no file")")
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityHint("Plays the sound")

            Button("Details", systemImage: "info.circle", action: showDetails)
                .labelStyle(.iconOnly)
                .buttonStyle(.borderless)
        }
    }
}

extension SystemSound {
    var groupTitle: String {
        switch folder {
        case nil: "No file"
        case ""?: "UISounds"
        case let folder?: "UISounds/\(folder)"
        }
    }
}

#Preview {
    ContentView()
}
