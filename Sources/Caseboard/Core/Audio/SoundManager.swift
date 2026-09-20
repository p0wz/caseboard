import Foundation
import AVFoundation

#if canImport(AudioToolbox)
import AudioToolbox
#endif

@MainActor
public final class SoundManager: ObservableObject {
    public static let shared = SoundManager()

    public var isEnabled: Bool = true

    public init() {}

    public func playTap() {
        guard isEnabled else { return }
        #if canImport(AudioToolbox) && !os(macOS)
        AudioServicesPlaySystemSound(1104) // subtle click
        #endif
    }

    public func playPin() {
        guard isEnabled else { return }
        #if canImport(AudioToolbox) && !os(macOS)
        AudioServicesPlaySystemSound(1105)
        #endif
    }

    public func playDiscoveryChime() {
        guard isEnabled else { return }
        #if canImport(AudioToolbox) && !os(macOS)
        AudioServicesPlaySystemSound(1025) // fanfare chime
        #endif
    }

    public func playRejection() {
        guard isEnabled else { return }
        #if canImport(AudioToolbox) && !os(macOS)
        AudioServicesPlaySystemSound(1053)
        #endif
    }

    public func playSolved() {
        guard isEnabled else { return }
        #if canImport(AudioToolbox) && !os(macOS)
        AudioServicesPlaySystemSound(1026)
        #endif
    }
}
