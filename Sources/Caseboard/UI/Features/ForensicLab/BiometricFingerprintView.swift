import SwiftUI

public struct BiometricFingerprintView: View {
    public let evidenceTitle: String
    public let matchConfidence: Double
    public let suspectName: String?

    @State private var scanLineOffset: CGFloat = 0.0
    @State private var isScanning: Bool = true
    @State private var lockedPoints: Set<Int> = []
    @State private var progress: Double = 0.0

    public init(evidenceTitle: String = "Latent Print #402",
                matchConfidence: Double = 99.4,
                suspectName: String? = "Elias Vorn") {
        self.evidenceTitle = evidenceTitle
        self.matchConfidence = matchConfidence
        self.suspectName = suspectName
    }

    public var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("AFIS BIOMETRIC COMPARATOR")
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .foregroundColor(.secondary)
                    Text(evidenceTitle.uppercased())
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.primary)
                }
                Spacer()
                HStack(spacing: 6) {
                    Circle()
                        .fill(progress >= 1.0 ? Color.green : Color.orange)
                        .frame(width: 8, height: 8)
                    Text(progress >= 1.0 ? "MATCH CONFIRMED" : "SCANNING...")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(progress >= 1.0 ? .green : .orange)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule().fill(Color.primary.opacity(0.06))
                )
            }

            // Fingerprint Scan Canvas
            ZStack {
                // Background dark forensic chamber
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(red: 15/255, green: 20/255, blue: 28/255))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(Color.cyan.opacity(0.3), lineWidth: 1)
                    )

                // Coordinate grid lines
                GeometryReader { geo in
                    Path { path in
                        for x in stride(from: 20, to: geo.size.width, by: 25) {
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: geo.size.height))
                        }
                        for y in stride(from: 20, to: geo.size.height, by: 25) {
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: geo.size.width, y: y))
                        }
                    }
                    .stroke(Color.cyan.opacity(0.08), lineWidth: 0.5)
                }

                // Procedural Fingerprint Whorls
                FingerprintWhorlsShape()
                    .stroke(Color.cyan.opacity(0.7), style: StrokeStyle(lineWidth: 1.8, lineCap: .round))
                    .frame(width: 140, height: 180)

                // Minutiae Target Reticles
                GeometryReader { geo in
                    let centerX = geo.size.width / 2
                    let centerY = geo.size.height / 2

                    let points: [CGPoint] = [
                        CGPoint(x: centerX - 35, y: centerY - 45),
                        CGPoint(x: centerX + 28, y: centerY - 30),
                        CGPoint(x: centerX - 18, y: centerY + 10),
                        CGPoint(x: centerX + 32, y: centerY + 38),
                        CGPoint(x: centerX - 40, y: centerY + 45),
                        CGPoint(x: centerX + 5, y: centerY - 15)
                    ]

                    ForEach(0..<points.count, id: \.self) { idx in
                        let pt = points[idx]
                        let isLocked = lockedPoints.contains(idx)

                        ZStack {
                            Circle()
                                .stroke(isLocked ? Color.green : Color.red, lineWidth: 1.2)
                                .frame(width: 16, height: 16)
                            Circle()
                                .fill(isLocked ? Color.green : Color.red)
                                .frame(width: 4, height: 4)
                            if isLocked {
                                Text("M\(idx + 1)")
                                    .font(.system(size: 7, weight: .bold, design: .monospaced))
                                    .foregroundColor(.green)
                                    .offset(x: 14, y: -6)
                            }
                        }
                        .position(pt)
                    }
                }

                // Moving Laser Scan Line
                GeometryReader { geo in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.clear, Color.cyan.opacity(0.8), Color.white, Color.cyan.opacity(0.8), Color.clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 2.5)
                        .shadow(color: Color.cyan, radius: 6, x: 0, y: 0)
                        .offset(y: scanLineOffset)
                }
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .frame(height: 220)

            // Analysis Metrics Footer
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("MINUTIAE POINTS")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(.secondary)
                    Text("\(lockedPoints.count) / 6 IDENTIFIED")
                        .font(.system(size: 12, weight: .black, design: .monospaced))
                        .foregroundColor(.primary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("CONFIDENCE SCORE")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(.secondary)
                    Text(String(format: "%.1f%% MATCH", min(progress * matchConfidence, matchConfidence)))
                        .font(.system(size: 13, weight: .black, design: .monospaced))
                        .foregroundColor(progress >= 1.0 ? .green : .cyan)
                }
            }
            .padding(.horizontal, 4)

            if let suspect = suspectName, progress >= 1.0 {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundColor(.green)
                    Text("MATCH IDENTITY: \(suspect.uppercased())")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(.green)
                }
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(Color.green.opacity(0.12))
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .onAppear {
            startScanAnimation()
        }
    }

    private func startScanAnimation() {
        withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
            scanLineOffset = 215.0
        }

        // Incrementally lock minutiae points
        for i in 0..<6 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35 * Double(i + 1)) {
                withAnimation(.spring(response: 0.25)) {
                    _ = lockedPoints.insert(i)
                    progress = Double(lockedPoints.count) / 6.0
                }
            }
        }
    }
}

// Procedural Fingerprint Vector Paths
struct FingerprintWhorlsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)

        // Multiple concentric elliptical ridge lines with breaks
        let radii: [(CGFloat, CGFloat)] = [
            (12, 18), (22, 32), (32, 48), (42, 64), (52, 80), (62, 96), (72, 112)
        ]

        for (rx, ry) in radii {
            let ovalRect = CGRect(x: center.x - rx, y: center.y - ry, width: rx * 2, height: ry * 2)
            path.addEllipse(in: ovalRect)
        }

        return path
    }
}
