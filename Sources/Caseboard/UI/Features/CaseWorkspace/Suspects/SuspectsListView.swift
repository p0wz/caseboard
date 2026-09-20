import SwiftUI

public struct SuspectsListView: View {
    public let caseModel: CaseModel
    @ObservedObject var progressStore = ProgressStore.shared
    @State private var selectedSuspect: Suspect?

    private let deductionEngine = DeductionEngine()

    public init(caseModel: CaseModel) {
        self.caseModel = caseModel
    }

    private var caseProgress: CaseProgress {
        progressStore.progress(for: caseModel.caseId)
    }

    private var evaluatedSuspects: [Suspect] {
        let discovered = caseModel.contradictions.filter {
            caseProgress.discoveredContradictions.contains($0.contradictionId)
        }
        return deductionEngine.updateSuspectMetrics(for: caseModel.suspects, discoveredContradictions: discovered)
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach(evaluatedSuspects) { suspect in
                    SuspectCardRow(suspect: suspect) {
                        HapticsManager.shared.lightTap()
                        selectedSuspect = suspect
                    }
                }
            }
            .padding(16)
        }
        .sheet(item: $selectedSuspect) { suspect in
            NavigationStack {
                SuspectDetailView(suspect: suspect, caseModel: caseModel)
            }
        }
    }
}

struct SuspectCardRow: View {
    let suspect: Suspect
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            ForensicCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color(hex: suspect.suspicionLevel.colorHex).opacity(0.18))
                            .frame(width: 48, height: 48)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(Color(hex: suspect.suspicionLevel.colorHex))
                            )

                        VStack(alignment: .leading, spacing: 3) {
                            Text(suspect.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text(suspect.role)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            FrostedBadge(
                                title: suspect.alibiStatus.displayName,
                                sfSymbol: suspect.alibiStatus.sfSymbol,
                                color: Color(hex: suspect.alibiStatus.colorHex)
                            )
                            FrostedBadge(
                                title: suspect.suspicionLevel.displayName,
                                sfSymbol: "exclamationmark.shield",
                                color: Color(hex: suspect.suspicionLevel.colorHex)
                            )
                        }
                    }

                    Divider()

                    // Dynamic Motive, Means, Opportunity Mini-meters
                    HStack(spacing: 12) {
                        MMOMiniMeter(label: "Motive", value: suspect.motiveScore, color: .purple)
                        MMOMiniMeter(label: "Means", value: suspect.meansScore, color: .indigo)
                        MMOMiniMeter(label: "Opportunity", value: suspect.opportunityScore, color: ForensicTheme.forensicBlue)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct MMOMiniMeter: View {
    let label: String
    let value: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(color)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.secondary.opacity(0.15))
                        .frame(height: 6)
                    Capsule()
                        .fill(color)
                        .frame(width: max(4, geo.size.width * CGFloat(value)), height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

public struct SuspectDetailView: View {
    public let suspect: Suspect
    public let caseModel: CaseModel
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var progressStore = ProgressStore.shared

    private var caseProgress: CaseProgress {
        progressStore.progress(for: caseModel.caseId)
    }

    private var relatedEvidence: [EvidenceItem] {
        caseModel.evidence.filter { $0.relatedSuspectIds.contains(suspect.suspectId) }
    }

    private var affectingContradictions: [Contradiction] {
        caseModel.contradictions.filter { $0.affectedSuspectId == suspect.suspectId }
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Profile header card with police booking mugshot
                ForensicCard {
                    VStack(alignment: .leading, spacing: 14) {
                        ZStack(alignment: .topTrailing) {
                            HStack(spacing: 16) {
                                // Police Booking Mugshot
                                ZStack {
                                    // Height chart background
                                    VStack(spacing: 6) {
                                        ForEach([ "6'2\"", "6'0\"", "5'10\"", "5'8\"", "5'6\""], id: \.self) { ht in
                                            HStack(spacing: 2) {
                                                Text(ht)
                                                    .font(.system(size: 6, weight: .bold, design: .monospaced))
                                                    .foregroundColor(.secondary.opacity(0.6))
                                                Rectangle()
                                                    .fill(Color.primary.opacity(0.12))
                                                    .frame(height: 0.8)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 4)

                                    // Silhouette / Avatar
                                    Image(systemName: "person.crop.rectangle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 75)
                                        .foregroundColor(Color(hex: suspect.suspicionLevel.colorHex).opacity(0.75))

                                    // Booking placard at chest level
                                    VStack(spacing: 1) {
                                        Text("METRO POLICE // FORENSIC DIV")
                                            .font(.system(size: 5, weight: .black, design: .monospaced))
                                            .foregroundColor(.white)
                                        Text("ID: \(suspect.suspectId.prefix(8).uppercased())")
                                            .font(.system(size: 6, weight: .bold, design: .monospaced))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(Color.black.opacity(0.85), in: RoundedRectangle(cornerRadius: 2))
                                    .offset(y: 30)
                                }
                                .frame(width: 85, height: 95)
                                .background(Color(UIColor.tertiarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .strokeBorder(Color.primary.opacity(0.15), lineWidth: 1)
                                )

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(suspect.name)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text(suspect.role)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)

                                    HStack(spacing: 6) {
                                        FrostedBadge(
                                            title: suspect.alibiStatus.displayName,
                                            sfSymbol: suspect.alibiStatus.sfSymbol,
                                            color: Color(hex: suspect.alibiStatus.colorHex)
                                        )
                                        FrostedBadge(
                                            title: suspect.suspicionLevel.displayName,
                                            sfSymbol: "exclamationmark.shield",
                                            color: Color(hex: suspect.suspicionLevel.colorHex)
                                        )
                                    }
                                    .padding(.top, 4)
                                }
                            }

                            // Dynamic Rubber Stamp Overlay if alibi broken
                            if suspect.alibiStatus == .broken || suspect.alibiStatus == .weak {
                                RubberStampView(kind: .alibiCompromised, isSlammed: true)
                                    .offset(x: 10, y: -5)
                            }
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 6) {
                            Text("RELATIONSHIP TO VICTIM")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                            Text(suspect.relationshipToVictim)
                                .font(.subheadline)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("FORENSIC DOSSIER PROFILE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                            Text(suspect.profile)
                                .font(.body)
                                .lineSpacing(3)
                        }
                    }
                }

                // Motive, Means, Opportunity Deep Inspection
                VStack(alignment: .leading, spacing: 8) {
                    Label("MOTIVE, MEANS & OPPORTUNITY METRICS", systemImage: "chart.bar.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)

                    ForensicCard {
                        VStack(spacing: 14) {
                            MMOBarDetail(
                                title: "Motive Substantive Index",
                                score: suspect.motiveScore,
                                color: .purple,
                                description: "Financial gain, career preservation, or grievance motivation."
                            )
                            Divider()
                            MMOBarDetail(
                                title: "Instrumental Means Capability",
                                score: suspect.meansScore,
                                color: .indigo,
                                description: "Physical possession of instruments, chemicals, or override tools."
                            )
                            Divider()
                            MMOBarDetail(
                                title: "Scene Opportunity Window",
                                score: suspect.opportunityScore,
                                color: ForensicTheme.forensicBlue,
                                description: "Vulnerability of alibi during the estimated incident window."
                            )
                        }
                    }
                }

                // Initial Claimed Alibi
                if let alibi = suspect.initialAlibi {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("CLAIMED ALIBI", systemImage: "shield.lefthalf.filled")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)

                        ForensicCard {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    FrostedBadge(
                                        title: suspect.alibiStatus.displayName,
                                        sfSymbol: suspect.alibiStatus.sfSymbol,
                                        color: Color(hex: suspect.alibiStatus.colorHex)
                                    )
                                    Spacer()
                                }
                                Text(alibi)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                // Cross-Referenced Evidence
                VStack(alignment: .leading, spacing: 8) {
                    Label("CROSS-REFERENCED EVIDENCE", systemImage: "doc.on.doc.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)

                    ForEach(relatedEvidence) { ev in
                        ForensicCard {
                            HStack {
                                Image(systemName: ev.type.sfSymbol)
                                    .foregroundColor(ForensicTheme.forensicBlue)
                                Text(ev.title)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                FrostedBadge(title: ev.type.displayName, color: .secondary)
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .navigationTitle(suspect.name)
        .forensicInlineTitle()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Done") { dismiss() }
            }
        }
    }
}

struct MMOBarDetail: View {
    let title: String
    let score: Double
    let color: Color
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(Int(score * 100))%")
                    .font(.headline)
                    .foregroundColor(color)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.secondary.opacity(0.15))
                        .frame(height: 8)
                    Capsule()
                        .fill(color)
                        .frame(width: max(6, geo.size.width * CGFloat(score)), height: 8)
                }
            }
            .frame(height: 8)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
