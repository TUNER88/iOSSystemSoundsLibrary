import Foundation
import Testing
@testable import SystemSoundsLibrary

private struct SoundsFile: Decodable {
    struct Entry: Decodable {
        let id: UInt32
        let name: String
        let file: String?
        let folder: String?
        let path: String?
        let minIOS: String?
        let status: String
        let confidence: String
    }

    let sounds: [Entry]
}

private func loadSoundsFile() throws -> SoundsFile {
    let url = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        .appendingPathComponent("data/sounds.json")
    return try JSONDecoder().decode(SoundsFile.self, from: Data(contentsOf: url))
}

@Suite("Catalog")
struct CatalogTests {
    @Test func idsAndNamesAreUnique() {
        let all = SystemSound.all
        #expect(all.count == 418)
        #expect(Set(all.map(\.id)).count == all.count)
        #expect(Set(all.map(\.name)).count == all.count)
        #expect(all.map(\.id) == all.map(\.id).sorted())
    }

    @Test func catalogMatchesSoundsJSON() throws {
        let entries = try loadSoundsFile().sounds
        #expect(entries.count == SystemSound.all.count)
        for (entry, sound) in zip(entries, SystemSound.all) {
            #expect(entry.id == sound.id)
            #expect(entry.name == sound.name)
            #expect(entry.file == sound.fileName)
            #expect(entry.folder == sound.folder)
            #expect(entry.path == sound.path)
            #expect(entry.minIOS == sound.minimumIOSVersion)
            #expect(entry.status == sound.status.rawValue)
            #expect(entry.confidence == sound.confidence.rawValue)
        }
    }

    @Test func namedConstants() {
        #expect(SystemSound.mailReceived.id == 1000)
        #expect(SystemSound.mailReceived.fileName == "new-mail.caf")
        #expect(SystemSound.mailReceived.path == "/System/Library/Audio/UISounds/new-mail.caf")
        #expect(SystemSound.smsReceived.id == 1003)
        #expect(SystemSound.vibrate.id == SystemSoundPlayer.vibrateID)
        #expect(SystemSound.voicemailReceived.path == "/System/Library/Audio/UISounds/nano/sms-received1.caf")
        #expect(SystemSound.voicemailReceived.confidence == .low)
    }

    @Test func lookup() {
        #expect(SystemSound.sound(withID: 1157)?.fileName == "wheels_of_time.caf")
        #expect(SystemSound.sound(withID: 1) == nil)
        #expect(SystemSound.custom(1234).id == 1234)
    }

    @Test func removedSound() {
        let sound = SystemSound.sound(withID: 1101)
        #expect(sound?.status == .removed)
        #expect(sound?.confidence == .low)
    }

    @Test func confidenceOrdering() {
        #expect(SystemSound.Confidence.low < .medium)
        #expect(SystemSound.Confidence.medium < .high)
    }
}

@Suite("FileSound")
struct FileSoundTests {
    @Test func soundWithoutFileThrows() {
        #expect(throws: FileSound.Error.noFile) {
            try FileSound(SystemSound.vibrate)
        }
    }
}
