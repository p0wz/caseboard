import SwiftUI

public struct BallisticComparatorView: View {
    public let caliber: String
    public let recoveredSpecimenId: String
    public let suspectWeaponModel: String

    @State private var splitRatio: CGFloat = 0.5
    @State private var isAligned: Bool = false
    @State private var microOffset: CGFloat = 0.0

    public init(caliber: String = "9x19mm Parabellum",
                recoveredSpecimenId: String = "SPECIMEN-CR-882",
                suspectWeaponModel: String = "Walther PPK / Serial #4401") {
        self.caliber = caliber
        self.recoveredSpecimenId = recoveredSpecimenId
        self.suspectWeaponModel = suspectWeaponModel
    }

    public var body: some View {
        VStack(spacing: 14) {
            // Microscope Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("COMPARISON MICROSCOPE • 40X OPTICAL")
                        .font(.system(size: 9, weight: .black, design: .monospaced))
                        .foregroundColor(.secondary)
                    Text("BALLISTIC STRIATION ANALYSIS")
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(.primary)
                }
                Spacer()
                Text(caliber.uppercased())
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.primary.opacity(0.06), in: Capsule())
            }

            // Split Optical Aperture
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                let dividerX = width * splitRatio

                ZStack {
                    // Dark specimen chamber
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(red: 20/255, green: 22/255, blue: 28/255))

                    // Left View: Recovered Specimen
                    HStack(spacing: 0) {
                        StriationPatternView(isLeft: true, offset: microOffset)
                            .frame(width: dividerX)
                            .clipped()
                        Spacer(minLength: 0)
                    }

                    // Right View: Reference Casing
                    HStack(spacing: 0) {
                        Spacer(minLength: 0)
                        StriationPatternView(isLeft: false, offset: 0)
                            .frame(width: width - dividerX)
                            .clipped()
                    }

                    // Circular Lens Glass Vignette Overlay
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.white.opacity(0.2), Color.black.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )

                    // Microscope Crosshair Ring
                    Circle()
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        .frame(width: min(width, height) * 0.75)

                    // Draggable Split Divider Bar
                    Rectangle()
                        .fill(isAligned ? Color.green : Color.yellow)
                        .frame(width: 3)
                        .shadow(color: isAligned ? Color.green : Color.yellow, radius: 4)
                        .position(x: dividerX, y: height / 2)
                        .gesture(
                            DragGesture()
                                .onChanged { val in
                                    let newRatio = min(max(val.location.x / width, 0.15), 0.85)
                                    splitRatio = newRatio
                                    checkAlignment()
                                }
                        )

                    // Labels on chambers
                    HStack {
                        VStack(alignment: .leading) {
                            Text("RECOVERED")
                                .font(.system(size: 8, weight: .black, design: .monospaced))
                                .foregroundColor(.white.opacity(0.75))
                            Text(recoveredSpecimenId)
                                .font(.system(size: 7, weight: .bold, design: .monospaced))
                                .foregroundColor(.white.opacity(0.5))
                            Spacer()
                        }
                        .padding(10)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("ARCHIVE REFERENCE")
                                .font(.system(size: 8, weight: .black, design: .monospaced))
                                .foregroundColor(.white.opacity(0.75))
                            Text(suspectWeaponModel)
                                .font(.system(size: 7, weight: .bold, design: .monospaced))
                                .foregroundColor(.white.opacity(0.5))
                            Spacer()
                        }
                        .padding(10)
                    }
                }
            }
            .frame(height: 180)

            // Alignment adjustment knob / slider
            HStack(spacing: 12) {
                Text("MICRO-ALIGNMENT:")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)

                Slider(value: $microOffset, in: -15...15, step: 0.5)
                    .onChange(of: microOffset) { _, _ in
                        checkAlignment()
                    }

                if isAligned {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("LANDS & GROOVES MATCH")
                            .font(.system(size: 9, weight: .black, design: .monospaced))
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }

    private func checkAlignment() {
        if abs(microOffset) <= 1.5 && abs(splitRatio - 0.5) <= 0.15 {
            withAnimation(.spring(response: 0.3)) {
                isAligned = true
            }
        } else {
            withAnimation(.spring(response: 0.3)) {
                isAligned = false
            }
        }
    }
}

// Procedural Bullet Striations View
struct StriationPatternView: View {
    let isLeft: Bool
    let offset: CGFloat

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Metallic brass casing gradient
                LinearGradient(
                    colors: [
                        Color(red: 180/255, green: 140/255, blue: 90/255),
                        Color(red: 220/255, green: 180/255, blue: 120/255),
                        Color(red: 140/255, green: 100/255, blue: 60/255)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                // Vertical striation micro-scratches
                Path { path in
                    let baseSpacing: [CGFloat] = [12, 18, 24, 38, 52, 60, 78, 92, 110, 126, 140, 158, 172, 190, 208, 224]
                    for xBase in baseSpacing {
                        let x = xBase + (isLeft ? offset : 0)
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x + (isLeft ? 2 : -2), y: geo.size.height))
                    }
                }
                .stroke(Color.black.opacity(0.45), lineWidth: 1.5)

                // High-pressure breach face scratches
                Path { path in
                    for y in stride(from: 10, to: geo.size.height, by: 16) {
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geo.size.width, y: y + 2))
                    }
                }
                .stroke(Color.white.opacity(0.18), lineWidth: 0.8)
            }
        }
    }
}
