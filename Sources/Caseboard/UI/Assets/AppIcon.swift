import SwiftUI

/// Forensic App Icon Design Concept (1024x1024 vector render)
public struct CaseboardAppIconView: View {
    public init() {}

    public var body: some View {
        ZStack {
            // Graphite forensic backdrop
            LinearGradient(
                colors: [
                    Color(red: 24/255, green: 28/255, blue: 34/255),
                    Color(red: 12/255, green: 14/255, blue: 18/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Forensic Grid
            Canvas { context, size in
                let step: CGFloat = 64
                var path = Path()
                for x in stride(from: 0, to: size.width, by: step) {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: size.height))
                }
                for y in stride(from: 0, to: size.height, by: step) {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                }
                context.stroke(path, with: .color(Color.white.opacity(0.06)), lineWidth: 1.5)
            }

            // Connection thread lines
            ConnectionLineShape(
                start: CGPoint(x: 240, y: 320),
                end: CGPoint(x: 780, y: 440),
                curvature: 0.18
            )
            .stroke(ForensicTheme.forensicGold, style: StrokeStyle(lineWidth: 8, lineCap: .round))
            .shadow(color: ForensicTheme.forensicGold.opacity(0.6), radius: 12)

            ConnectionLineShape(
                start: CGPoint(x: 240, y: 320),
                end: CGPoint(x: 512, y: 760),
                curvature: -0.15
            )
            .stroke(ForensicTheme.criticalRed, style: StrokeStyle(lineWidth: 8, lineCap: .round))
            .shadow(color: ForensicTheme.criticalRed.opacity(0.6), radius: 12)

            // Center Pin / Node Emblem
            Circle()
                .fill(
                    LinearGradient(
                        colors: [ForensicTheme.forensicBlue, Color(red: 0/255, green: 90/255, blue: 220/255)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 220, height: 220)
                .overlay(
                    Circle().strokeBorder(Color.white.opacity(0.3), lineWidth: 4)
                )
                .shadow(color: ForensicTheme.forensicBlue.opacity(0.5), radius: 30)

            Image(systemName: "magnifyingglass")
                .font(.system(size: 96, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 1024, height: 1024)
    }
}
