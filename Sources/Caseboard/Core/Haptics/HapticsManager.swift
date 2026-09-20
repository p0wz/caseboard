import Foundation

#if canImport(CoreHaptics)
import CoreHaptics
#endif

#if canImport(UIKit)
import UIKit
#endif

@MainActor
public final class HapticsManager: ObservableObject {
    public static let shared = HapticsManager()

    #if canImport(CoreHaptics)
    private var engine: CHHapticEngine?
    #endif

    public var isEnabled: Bool = true

    public init() {
        #if canImport(CoreHaptics) && !os(macOS)
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            engine?.resetHandler = { [weak self] in
                do {
                    try self?.engine?.start()
                } catch {
                    print("[HapticsManager] Failed to restart engine: \(error)")
                }
            }
        } catch {
            print("[HapticsManager] CoreHaptics init error: \(error)")
        }
        #endif
    }

    public func lightTap() {
        guard isEnabled else { return }
        #if canImport(UIKit) && !os(macOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }

    public func evidencePin() {
        guard isEnabled else { return }
        #if canImport(UIKit) && !os(macOS)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred(intensity: 0.8)
        #endif
    }

    public func connectionStart() {
        guard isEnabled else { return }
        #if canImport(UIKit) && !os(macOS)
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
        #endif
    }

    public func correctConnection() {
        guard isEnabled else { return }
        #if canImport(UIKit) && !os(macOS)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        #endif
    }

    public func criticalContradiction() {
        guard isEnabled else { return }
        #if canImport(CoreHaptics) && !os(macOS)
        if let engine = engine {
            playCriticalContradictionChord(on: engine)
            return
        }
        #endif

        #if canImport(UIKit) && !os(macOS)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        #endif
    }

    public func wrongConnection() {
        guard isEnabled else { return }
        #if canImport(UIKit) && !os(macOS)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
        #endif
    }

    public func caseSolved() {
        guard isEnabled else { return }
        #if canImport(UIKit) && !os(macOS)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        #endif
    }

    public func perfectSolve() {
        guard isEnabled else { return }
        #if canImport(UIKit) && !os(macOS)
        let g1 = UINotificationFeedbackGenerator()
        g1.notificationOccurred(.success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            let g2 = UIImpactFeedbackGenerator(style: .heavy)
            g2.impactOccurred(intensity: 1.0)
        }
        #endif
    }

    public func achievementUnlock() {
        guard isEnabled else { return }
        #if canImport(UIKit) && !os(macOS)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        #endif
    }

    #if canImport(CoreHaptics) && !os(macOS)
    private func playCriticalContradictionChord(on engine: CHHapticEngine) {
        do {
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.9)
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)

            let event1 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
            let event2 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0.08, duration: 0.18)
            let event3 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.28)

            let pattern = try CHHapticPattern(events: [event1, event2, event3], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("[HapticsManager] Critical chord failed: \(error)")
        }
    }
    #endif
}
