import SwiftUI

public struct ProceduralDossierCardView: View {
    public let suspect: Suspect
    public let caseTheme: CaseIdentityTheme
    public let size: CGSize
    public let showFullPlacard: Bool

    public init(
        suspect: Suspect,
        caseTheme: CaseIdentityTheme? = nil,
        size: CGSize = CGSize(width: 95, height: 120),
        showFullPlacard: Bool = true
    ) {
        self.suspect = suspect
        self.caseTheme = caseTheme ?? CaseIdentityTheme.theme(for: suspect.caseId)
        self.size = size
        self.showFullPlacard = showFullPlacard
    }

    private var suspectPhoto: PlatformImage? {
        ForensicAssetLoader.image(named: suspect.suspectId) ??
        ForensicAssetLoader.image(named: suspect.suspectId.replacingOccurrences(of: "suspect_", with: ""))
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            if let photo = suspectPhoto {
                // Real Photographic Mugshot
                #if canImport(UIKit)
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                #elseif canImport(AppKit)
                Image(nsImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                #endif
            } else {
                // Procedural Police Forensic Dossier
                proceduralMugshotBackground
            }

            // Police Booking Placard
            if showFullPlacard {
                bookingPlacard
            }
        }
        .frame(width: size.width, height: size.height)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .strokeBorder(caseTheme.primaryAccent.opacity(0.4), lineWidth: 1.5)
        )
    }

    // MARK: - Procedural Booking Background

    private var proceduralMugshotBackground: some View {
        ZStack {
            // Dark forensic backdrop with tint
            Color(hex: caseTheme.paperToneHex)

            // Police height measurement grid
            VStack(spacing: 0) {
                ForEach(0..<10) { i in
                    HStack(spacing: 4) {
                        Text("\(6 - (i / 3))' \((11 - (i * 2 % 12)))\"")
                            .font(.system(size: max(5, size.width * 0.05), weight: .bold, design: .monospaced))
                            .foregroundColor(Color.white.opacity(0.25))
                        Rectangle()
                            .fill(Color.white.opacity(i % 2 == 0 ? 0.2 : 0.1))
                            .frame(height: 1)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)

            // Procedural Silhouette Silhouette Archetype
            suspectArchetypeSilhouette

            // Biometric Thumbprint Corner Stamp
            VStack {
                HStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.black.opacity(0.75))
                            .frame(width: size.width * 0.28, height: size.height * 0.22)
                        Image(systemName: "touchid")
                            .font(.system(size: size.width * 0.16))
                            .foregroundColor(caseTheme.primaryAccent.opacity(0.85))
                    }
                    .padding(3)
                }
                Spacer()
            }
        }
    }

    // MARK: - Suspect Silhouette Archetype

    private var suspectArchetypeSilhouette: some View {
        let hash = abs(suspect.suspectId.hashValue)
        let role = suspect.role.lowercased()

        return GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Shoulders & Chest Silhouette
                Path { p in
                    p.move(to: CGPoint(x: w * 0.1, y: h * 0.95))
                    p.addQuadCurve(
                        to: CGPoint(x: w * 0.35, y: h * 0.58),
                        control: CGPoint(x: w * 0.15, y: h * 0.72)
                    )
                    p.addLine(to: CGPoint(x: w * 0.65, y: h * 0.58))
                    p.addQuadCurve(
                        to: CGPoint(x: w * 0.9, y: h * 0.95),
                        control: CGPoint(x: w * 0.85, y: h * 0.72)
                    )
                    p.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        colors: [
                            Color(white: 0.16),
                            Color(white: 0.08)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                // Head Silhouette
                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(white: 0.24),
                                Color(white: 0.14)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: w * 0.38, height: h * 0.34)
                    .position(x: w * 0.5, y: h * 0.42)

                // Distinct Hair / Feature Silhouette based on hash
                if hash % 4 == 0 {
                    // Styled parted hair
                    Path { p in
                        p.move(to: CGPoint(x: w * 0.3, y: h * 0.42))
                        p.addQuadCurve(to: CGPoint(x: w * 0.7, y: h * 0.42), control: CGPoint(x: w * 0.5, y: h * 0.22))
                        p.addQuadCurve(to: CGPoint(x: w * 0.62, y: h * 0.32), control: CGPoint(x: w * 0.66, y: h * 0.26))
                        p.closeSubpath()
                    }
                    .fill(Color(white: 0.1))
                } else if hash % 4 == 1 {
                    // Full hair contour
                    Circle()
                        .fill(Color(white: 0.12))
                        .frame(width: w * 0.42, height: w * 0.42)
                        .position(x: w * 0.5, y: h * 0.36)
                }

                // Collar / Attire details
                if role.contains("partner") || role.contains("founder") || role.contains("director") {
                    // Corporate Tie & Lapel
                    Path { p in
                        p.move(to: CGPoint(x: w * 0.46, y: h * 0.62))
                        p.addLine(to: CGPoint(x: w * 0.54, y: h * 0.62))
                        p.addLine(to: CGPoint(x: w * 0.52, y: h * 0.85))
                        p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.90))
                        p.addLine(to: CGPoint(x: w * 0.48, y: h * 0.85))
                        p.closeSubpath()
                    }
                    .fill(caseTheme.primaryAccent.opacity(0.8))
                } else if role.contains("chef") {
                    // Chef double collar line
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: w * 0.04, height: h * 0.2)
                        .position(x: w * 0.5, y: h * 0.75)
                }

                // Glasses wireframes for intellectual/analyst suspects
                if hash % 3 == 0 {
                    HStack(spacing: w * 0.04) {
                        Circle()
                            .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
                            .frame(width: w * 0.12, height: w * 0.12)
                        Circle()
                            .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
                            .frame(width: w * 0.12, height: w * 0.12)
                    }
                    .position(x: w * 0.5, y: h * 0.41)
                }
            }
        }
    }

    // MARK: - Booking Placard

    private var bookingPlacard: some View {
        VStack(spacing: 1) {
            Text(caseTheme.jurisdictionCode)
                .font(.system(size: max(4.5, size.width * 0.055), weight: .black, design: .monospaced))
                .foregroundColor(caseTheme.primaryAccent)
                .lineLimit(1)

            Text(suspect.name.uppercased())
                .font(.system(size: max(5.5, size.width * 0.07), weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .lineLimit(1)

            let ageText = suspect.age != nil ? "\(suspect.age!)" : "--"
            Text("ID: \(suspect.suspectId.suffix(6).uppercased()) • AGE: \(ageText)")
                .font(.system(size: max(4, size.width * 0.05), weight: .medium, design: .monospaced))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(1)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 3)
        .frame(maxWidth: .infinity)
        .background(
            Color.black.opacity(0.88),
            in: RoundedRectangle(cornerRadius: 2)
        )
        .padding(2)
    }
}
