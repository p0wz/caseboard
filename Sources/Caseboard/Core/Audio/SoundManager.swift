import Foundation
import AVFoundation

#if canImport(AudioToolbox)
import AudioToolbox
#endif

@MainActor
public final class SoundManager: ObservableObject {
    public static let shared = SoundManager()

    public var isEnabled: Bool = true
    private var audioPlayers: [String: AVAudioPlayer] = [:]

    public init() {
        prepareAudioPlayers()
    }

    private func prepareAudioPlayers() {
        let soundFiles = [
            "card_tap",
            "pin_drop",
            "clue_connect",
            "alibi_break",
            "contradiction_fail",
            "folder_close",
            "switch_toggle"
        ]

        let bundle = Bundle.module
        for name in soundFiles {
            if let url = bundle.url(forResource: name, withExtension: "wav", subdirectory: "Audio") ??
                         bundle.url(forResource: name, withExtension: "wav") {
                if let player = try? AVAudioPlayer(contentsOf: url) {
                    player.prepareToPlay()
                    audioPlayers[name] = player
                }
            } else {
                // Fallback direct path in dev
                let currentDir = FileManager.default.currentDirectoryPath
                let directURL = URL(fileURLWithPath: currentDir)
                    .appendingPathComponent("Sources/Caseboard/Resources/Audio/\(name).wav")
                if FileManager.default.fileExists(atPath: directURL.path),
                   let player = try? AVAudioPlayer(contentsOf: directURL) {
                    player.prepareToPlay()
                    audioPlayers[name] = player
                }
            }
        }
    }

    private func playStudioSound(named name: String, fallbackSystemId: SystemSoundID? = nil) {
        guard isEnabled else { return }

        if let player = audioPlayers[name] {
            if player.isPlaying {
                player.currentTime = 0
            }
            player.play()
            return
        }

        #if canImport(AudioToolbox) && !os(macOS)
        if let fallbackId = fallbackSystemId {
            AudioServicesPlaySystemSound(fallbackId)
        }
        #endif
    }

    public func playTap() {
        playStudioSound(named: "card_tap", fallbackSystemId: 1104)
    }

    public func playPin() {
        playStudioSound(named: "pin_drop", fallbackSystemId: 1105)
    }

    public func playDiscoveryChime() {
        playStudioSound(named: "clue_connect", fallbackSystemId: 1025)
    }

    public func playRejection() {
        playStudioSound(named: "contradiction_fail", fallbackSystemId: 1053)
    }

    public func playSolved() {
        playStudioSound(named: "clue_connect", fallbackSystemId: 1026)
    }

    public func playEvidenceAdmitted() {
        playStudioSound(named: "clue_connect", fallbackSystemId: 1025)
    }

    public func playAlibiBroken() {
        playStudioSound(named: "alibi_break", fallbackSystemId: 1025)
    }

    public func playFolderClose() {
        playStudioSound(named: "folder_close", fallbackSystemId: 1104)
    }

    public func playSwitch() {
        playStudioSound(named: "switch_toggle", fallbackSystemId: 1104)
    }

    public func playCameraShutter() {
        guard isEnabled else { return }
        AnalogAudioEngine.shared.playCameraShutter()
    }

    public func playTypewriter() {
        guard isEnabled else { return }
        AnalogAudioEngine.shared.playTypewriterKey()
    }

    public func playCassetteClick() {
        guard isEnabled else { return }
        AnalogAudioEngine.shared.playCassetteLatch()
    }

    public func playPaperRustle() {
        guard isEnabled else { return }
        AnalogAudioEngine.shared.playPaperRustle()
    }
}
