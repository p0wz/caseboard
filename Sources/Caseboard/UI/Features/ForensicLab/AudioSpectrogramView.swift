import SwiftUI

public struct AudioSpectrogramView: View {
    public let tapeTitle: String
    public let durationSeconds: Double
    public let transcriptSnippet: String

    @State private var isPlaying: Bool = false
    @State private var currentTime: Double = 0.0
    @State private var isFilterActive: Bool = true
    @State private var timerSubscription: Timer? = nil

    public init(tapeTitle: String = "WIRE-INTERCEPT #09-B",
                durationSeconds: Double = 24.0,
                transcriptSnippet: String = "\"Meet me at Mercer dock before the midnight ferry arrives...\"") {
        self.tapeTitle = tapeTitle
        self.durationSeconds = durationSeconds
        self.transcriptSnippet = transcriptSnippet
    }

    public var body: some View {
        VStack(spacing: 14) {
            // Header
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "waveform.badge.magnifyingglass")
                        .foregroundColor(.blue)
                    Text("AUDIO FORENSICS SPECTROGRAM")
                        .font(.system(size: 9, weight: .black, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(tapeTitle)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.blue.opacity(0.12), in: Capsule())
            }

            // Spectrogram Display Chamber
            VStack(spacing: 8) {
                // Waveform visualization
                HStack(alignment: .center, spacing: 2.5) {
                    ForEach(0..<36, id: \.self) { barIdx in
                        let heightFactor = waveformHeight(for: barIdx)
                        RoundedRectangle(cornerRadius: 1.5)
                            .fill(
                                LinearGradient(
                                    colors: isFilterActive ?
                                        [Color.cyan, Color.blue] :
                                        [Color.orange.opacity(0.8), Color.red.opacity(0.8)],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(width: 4, height: heightFactor * 60)
                    }
                }
                .frame(height: 70)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color(red: 14/255, green: 18/255, blue: 26/255))
                )

                // Playback Scrubber & Timecode
                HStack {
                    Text(formatTime(currentTime))
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(.primary)

                    ProgressView(value: currentTime, total: durationSeconds)
                        .tint(.blue)

                    Text(formatTime(durationSeconds))
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(.secondary)
                }
            }

            // Transcript Box with karaoke highlight
            VStack(alignment: .leading, spacing: 4) {
                Text("AUDIO TRANSCRIPT (VOICE ENHANCED)")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                Text(transcriptSnippet)
                    .font(.system(size: 12, weight: .medium, design: .serif))
                    .italic()
                    .foregroundColor(.primary)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.primary.opacity(0.04))
            )

            // Controls
            HStack {
                Button(action: {
                    toggleFilter()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isFilterActive ? "waveform.badge.checkmark" : "waveform.badge.exclamationmark")
                        Text(isFilterActive ? "DENOISER: ON" : "DENOISER: RAW")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(isFilterActive ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
                    )
                    .foregroundColor(isFilterActive ? .green : .orange)
                }

                Spacer()

                Button(action: {
                    togglePlay()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        Text(isPlaying ? "PAUSE INTERCEPT" : "PLAY INTERCEPT")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue, in: Capsule())
                    .foregroundColor(.white)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }

    private func waveformHeight(for index: Int) -> CGFloat {
        let base = sin(Double(index) * 0.45 + currentTime * 2.0)
        let noise = isFilterActive ? 0.2 : sin(Double(index) * 2.1) * 0.4
        let combined = max(0.15, abs(base) * 0.8 + noise)
        return CGFloat(min(combined, 1.0))
    }

    private func formatTime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }

    private func togglePlay() {
        isPlaying.toggle()
        if isPlaying {
            startTimer()
        } else {
            stopTimer()
        }
    }

    private func toggleFilter() {
        withAnimation(.spring(response: 0.25)) {
            isFilterActive.toggle()
        }
    }

    private func startTimer() {
        timerSubscription?.invalidate()
        timerSubscription = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if currentTime < durationSeconds {
                currentTime += 0.1
            } else {
                currentTime = 0.0
                isPlaying = false
                stopTimer()
            }
        }
    }

    private func stopTimer() {
        timerSubscription?.invalidate()
        timerSubscription = nil
    }
}
