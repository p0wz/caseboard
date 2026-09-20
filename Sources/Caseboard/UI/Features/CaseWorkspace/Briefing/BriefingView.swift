import SwiftUI

public struct BriefingView: View {
    public let caseModel: CaseModel
    @ObservedObject var progressStore = ProgressStore.shared

    public init(caseModel: CaseModel) {
        self.caseModel = caseModel
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Banner
                // Confidential Case File Folder Header
                ZStack(alignment: .topTrailing) {
                    ForensicCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                FrostedBadge(
                                    title: caseModel.difficulty.displayName,
                                    sfSymbol: "gauge.with.needle.fill",
                                    color: Color(hex: caseModel.difficulty.badgeColorHex)
                                )
                                Spacer()
                                FrostedBadge(
                                    title: "\(caseModel.estimatedMinutes) MIN EST.",
                                    sfSymbol: "clock.fill",
                                    color: ForensicTheme.forensicBlue
                                )
                            }

                            Text(caseModel.title)
                                .font(.system(size: 26, weight: .bold, design: .default))

                            Text(caseModel.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Divider().padding(.vertical, 4)

                            HStack(spacing: 20) {
                                MetricPill(label: "Location", value: caseModel.briefing.location, sfSymbol: "mappin.and.ellipse")
                                MetricPill(label: "Incident Date", value: caseModel.briefing.date, sfSymbol: "calendar")
                            }
                        }
                    }

                    // Official Top Secret Stamp Overlay
                    RubberStampView(kind: .topSecret, customAngle: -6.0)
                        .offset(x: -8, y: -10)
                }

                // Executive Incident Narrative
                VStack(alignment: .leading, spacing: 10) {
                    Label("INCIDENT SUMMARY", systemImage: "doc.plaintext.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.secondary)

                    ForensicCard {
                        VStack(alignment: .leading, spacing: 12) {
                            if let victim = caseModel.briefing.victimOrSubject {
                                HStack {
                                    Text("Victim / Subject:")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(victim)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                Divider()
                            }

                            Text(caseModel.briefing.summary)
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                }

                // Primary Investigative Objective
                VStack(alignment: .leading, spacing: 10) {
                    Label("ANALYST OBJECTIVE", systemImage: "target")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.secondary)

                    ForensicCard {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "shield.lefthalf.filled")
                                .font(.system(size: 24))
                                .foregroundColor(ForensicTheme.forensicBlue)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Primary Directive")
                                    .font(.headline)
                                Text(caseModel.briefing.objective)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                // Initial Suspects overview
                VStack(alignment: .leading, spacing: 10) {
                    Label("PERSONS OF INTEREST", systemImage: "person.3.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.secondary)

                    ForEach(caseModel.suspects) { suspect in
                        ForensicCard {
                            HStack(spacing: 14) {
                                Circle()
                                    .fill(Color(hex: suspect.suspicionLevel.colorHex).opacity(0.2))
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .foregroundColor(Color(hex: suspect.suspicionLevel.colorHex))
                                    )

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(suspect.name)
                                        .font(.headline)
                                    Text(suspect.role)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                FrostedBadge(
                                    title: suspect.alibiStatus.displayName,
                                    sfSymbol: suspect.alibiStatus.sfSymbol,
                                    color: Color(hex: suspect.alibiStatus.colorHex)
                                )
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
    }
}

// Color hex extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
