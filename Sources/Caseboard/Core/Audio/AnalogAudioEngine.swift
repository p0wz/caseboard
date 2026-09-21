import Foundation
import AVFoundation

#if canImport(AudioToolbox)
import AudioToolbox
#endif

@MainActor
public final class AnalogAudioEngine: ObservableObject {
    public static let shared = AnalogAudioEngine()

    public var isEnabled: Bool = true

    private var audioEngine: AVAudioEngine?
    private var playerNode: AVAudioPlayerNode?
    private var audioFormat: AVAudioFormat?

    public init() {
        setupEngine()
    }

    private func setupEngine() {
        let engine = AVAudioEngine()
        let player = AVAudioPlayerNode()
        engine.attach(player)

        let sampleRate: Double = 44100.0
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1) else { return }

        engine.connect(player, to: engine.mainMixerNode, format: format)
        do {
            try engine.start()
            self.audioEngine = engine
            self.playerNode = player
            self.audioFormat = format
        } catch {
            print("[AnalogAudioEngine] Engine start failure: \(error)")
        }
    }

    // MARK: - Procedural Sound Generation

    /// Plays a mechanical camera shutter release (crime scene photography)
    public func playCameraShutter() {
        guard isEnabled, let engine = audioEngine, let player = playerNode, let format = audioFormat else {
            #if canImport(AudioToolbox) && !os(macOS)
            AudioServicesPlaySystemSound(1108) // camera shutter fallback
            #endif
            return
        }

        let sampleRate = Float(format.sampleRate)
        let duration: Float = 0.12
        let frameCount = AVAudioFrameCount(sampleRate * duration)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
        buffer.frameLength = frameCount

        guard let channelData = buffer.floatChannelData?[0] else { return }

        for i in 0..<Int(frameCount) {
            let t = Float(i) / sampleRate
            let noise = Float.random(in: -1.0...1.0)
            // Two sharp mechanical impulse clicks (curtain open and curtain close)
            let impulse1 = exp(-t * 120.0) * noise
            let t2 = max(0.0, t - 0.05)
            let impulse2 = exp(-t2 * 90.0) * noise * 0.7
            channelData[i] = (impulse1 + impulse2) * 0.4
        }

        if !engine.isRunning { try? engine.start() }
        player.play()
        player.scheduleBuffer(buffer, at: nil, options: .interrupts)
    }

    /// Plays an authentic mechanical typewriter strike (case notes & accusations)
    public func playTypewriterKey() {
        guard isEnabled, let engine = audioEngine, let player = playerNode, let format = audioFormat else {
            #if canImport(AudioToolbox) && !os(macOS)
            AudioServicesPlaySystemSound(1104)
            #endif
            return
        }

        let sampleRate = Float(format.sampleRate)
        let duration: Float = 0.09
        let frameCount = AVAudioFrameCount(sampleRate * duration)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
        buffer.frameLength = frameCount

        guard let channelData = buffer.floatChannelData?[0] else { return }

        let strikeFreq: Float = 880.0
        let ringFreq: Float = 1760.0

        for i in 0..<Int(frameCount) {
            let t = Float(i) / sampleRate
            let strike = sin(2.0 * .pi * strikeFreq * t) * exp(-t * 90.0)
            let ring = sin(2.0 * .pi * ringFreq * t) * exp(-t * 40.0) * 0.25
            let noise = Float.random(in: -1.0...1.0) * exp(-t * 150.0) * 0.35
            channelData[i] = (strike + ring + noise) * 0.35
        }

        if !engine.isRunning { try? engine.start() }
        player.play()
        player.scheduleBuffer(buffer, at: nil, options: .interrupts)
    }

    /// Plays a cassette recorder latch engage / tape start click
    public func playCassetteLatch() {
        guard isEnabled, let engine = audioEngine, let player = playerNode, let format = audioFormat else {
            #if canImport(AudioToolbox) && !os(macOS)
            AudioServicesPlaySystemSound(1105)
            #endif
            return
        }

        let sampleRate = Float(format.sampleRate)
        let duration: Float = 0.16
        let frameCount = AVAudioFrameCount(sampleRate * duration)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
        buffer.frameLength = frameCount

        guard let channelData = buffer.floatChannelData?[0] else { return }

        for i in 0..<Int(frameCount) {
            let t = Float(i) / sampleRate
            let click1 = exp(-t * 180.0) * sin(2.0 * .pi * 320.0 * t)
            let t2 = max(0.0, t - 0.04)
            let click2 = exp(-t2 * 140.0) * sin(2.0 * .pi * 210.0 * t2) * 0.85
            let motorHiss = Float.random(in: -0.05...0.05) * (t < 0.12 ? 1.0 : 0.0)
            channelData[i] = (click1 + click2 + motorHiss) * 0.45
        }

        if !engine.isRunning { try? engine.start() }
        player.play()
        player.scheduleBuffer(buffer, at: nil, options: .interrupts)
    }

    /// Plays a manila dossier paper rustle / file open sound
    public func playPaperRustle() {
        guard isEnabled, let engine = audioEngine, let player = playerNode, let format = audioFormat else { return }

        let sampleRate = Float(format.sampleRate)
        let duration: Float = 0.14
        let frameCount = AVAudioFrameCount(sampleRate * duration)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
        buffer.frameLength = frameCount

        guard let channelData = buffer.floatChannelData?[0] else { return }

        for i in 0..<Int(frameCount) {
            let t = Float(i) / sampleRate
            let envelope = sin(Float.pi * (t / duration))
            let noise = Float.random(in: -1.0...1.0)
            channelData[i] = noise * envelope * 0.18
        }

        if !engine.isRunning { try? engine.start() }
        player.play()
        player.scheduleBuffer(buffer, at: nil, options: .interrupts)
    }
}
