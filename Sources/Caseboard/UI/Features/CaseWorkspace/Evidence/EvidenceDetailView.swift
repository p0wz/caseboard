import SwiftUI

public struct EvidenceDetailView: View {
    public let item: EvidenceItem
    public let caseModel: CaseModel
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var progressStore = ProgressStore.shared
    @State private var notesText: String = ""

    public init(item: EvidenceItem, caseModel: CaseModel) {
        self.item = item
        self.caseModel = caseModel
    }

    private var isPinned: Bool {
        progressStore.progress(for: caseModel.caseId).pinnedNodes.contains { $0.nodeId == item.evidenceId }
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                // Header card
                ForensicCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            FrostedBadge(
                                title: item.type.displayName,
                                sfSymbol: item.type.sfSymbol,
                                color: ForensicTheme.forensicBlue
                            )
                            Spacer()
                            FrostedBadge(
                                title: item.reliability.displayName,
                                sfSymbol: "shield.fill",
                                color: Color(hex: item.reliability.colorHex)
                            )
                        }

                        Text(item.title)
                            .font(.title2)
                            .fontWeight(.bold)

                        HStack {
                            MetricPill(label: "Source", value: item.source, sfSymbol: "building.2")
                            if let ts = item.timestamp {
                                MetricPill(label: "Telemetry Timestamp", value: ts, sfSymbol: "clock")
                            }
                        }
                    }
                }

                // Full Forensic Transcript
                VStack(alignment: .leading, spacing: 8) {
                    Label("FORENSIC RECORD / TRANSCRIPT", systemImage: "doc.text.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)

                    ForensicCard {
                        Text(item.fullText)
                            .font(.system(.body, design: .monospaced))
                            .lineSpacing(5)
                            .foregroundColor(.primary)
                    }
                }

                // Metadata EXIF / Telemetry drawer
                if let meta = item.metadata, !meta.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("TELEMETRY & EXIF METADATA", systemImage: "slider.horizontal.3")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)

                        ForensicCard {
                            VStack(spacing: 8) {
                                ForEach(meta, id: \.label) { entry in
                                    HStack {
                                        Text(entry.label)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Text(entry.value)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                    }
                                    if entry.label != meta.last?.label {
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                }

                // Related Suspects
                if !item.relatedSuspectIds.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("CROSS-REFERENCED PERSONS OF INTEREST", systemImage: "person.2.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)

                        ForEach(item.relatedSuspectIds, id: \.self) { suspectId in
                            if let suspect = caseModel.suspects.first(where: { $0.suspectId == suspectId }) {
                                ForensicCard {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
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
                }

                // Pin / Unpin Action
                Button {
                    HapticsManager.shared.evidencePin()
                    SoundManager.shared.playPin()
                    progressStore.togglePinNode(caseId: caseModel.caseId, nodeId: item.evidenceId, itemType: .evidence)
                } label: {
                    HStack {
                        Image(systemName: isPinned ? "pin.slash.fill" : "pin.fill")
                        Text(isPinned ? "Unpin from Caseboard Canvas" : "Pin to Caseboard Canvas")
                    }
                    .font(.headline)
                    .foregroundColor(isPinned ? .red : .white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(isPinned ? Color.red.opacity(0.15) : ForensicTheme.forensicBlue)
                    )
                }
            }
            .padding(16)
        }
        .navigationTitle("Evidence File")
        .forensicInlineTitle()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}
