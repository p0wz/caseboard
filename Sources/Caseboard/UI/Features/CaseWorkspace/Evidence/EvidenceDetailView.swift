import SwiftUI

public struct EvidenceDetailView: View {
    public let item: EvidenceItem
    public let caseModel: CaseModel
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var progressStore = ProgressStore.shared
    @State private var notesText: String = ""
    @State private var selectedSpectralFilter: MultispectralFilter = .visible

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

                // Crime Scene Macro Photography & Loupe Inspection
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("FORENSIC EVIDENCE VISUAL DOSSIER", systemImage: "camera.viewfinder")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("DRAG TO INSPECT (2.5X LOUPE)")
                            .font(.system(size: 8, weight: .bold, design: .monospaced))
                            .foregroundColor(ForensicTheme.forensicBlue)
                    }

                    // Multispectral Filter Selector Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(MultispectralFilter.allCases) { filter in
                                Button {
                                    HapticsManager.shared.lightTap()
                                    SoundManager.shared.playCameraShutter()
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedSpectralFilter = filter
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: filter.sfSymbol)
                                            .font(.system(size: 9))
                                        Text(filter.rawValue)
                                            .font(.system(size: 9, weight: .semibold, design: .monospaced))
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 5)
                                    .background(
                                        Capsule()
                                            .fill(selectedSpectralFilter == filter ? ForensicTheme.forensicBlue.opacity(0.3) : Color.white.opacity(0.06))
                                    )
                                    .overlay(
                                        Capsule()
                                            .stroke(selectedSpectralFilter == filter ? ForensicTheme.forensicBlue : Color.white.opacity(0.12), lineWidth: 1)
                                    )
                                    .foregroundColor(selectedSpectralFilter == filter ? .white : .secondary)
                                }
                            }
                        }
                    }

                    CaseSpecificEvidenceView(
                        evidence: item,
                        spectralFilter: selectedSpectralFilter,
                        height: 220
                    )
                }

                // Interactive Forensic Lab Workbench (Biometric, Spectrogram, Ballistics, Redacted)
                if isLabWorkbenchItem(item) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("INTERACTIVE FORENSIC BENCH", systemImage: "waveform.path.ecg")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)

                        labWorkbenchView(for: item)
                    }
                }
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

    // MARK: - Forensic Visual Matching

    private func matchingImageAsset(for item: EvidenceItem) -> String? {
        if item.evidenceId == "coroner_report_vorn" || item.evidenceId == "restoration_solvent_inventory" {
            return "evidence_solvent_bottle"
        }
        if item.evidenceId == "door_sensor_824" || item.evidenceId == "service_door_override_log" {
            return "evidence_vault_crime_scene"
        }
        if item.evidenceId == "coroner_chen" || item.evidenceId == "connecting_balcony_lock" {
            return "coroner_chen"
        }
        if item.evidenceId == "elevator_maintenance_log" {
            return "elevator_maintenance_log"
        }
        if ForensicAssetLoader.image(named: item.evidenceId) != nil {
            return item.evidenceId
        }
        return nil
    }

    private func isLabWorkbenchItem(_ item: EvidenceItem) -> Bool {
        let id = item.evidenceId.lowercased()
        let tags = item.tags.map { $0.lowercased() }
        let typeStr = item.type.rawValue.lowercased()
        return typeStr.contains("audio") || tags.contains("audio") ||
               typeStr.contains("biometric") || tags.contains("fingerprint") || tags.contains("biometric") ||
               typeStr.contains("ballistic") || tags.contains("ballistics") ||
               tags.contains("classified") || tags.contains("redacted") || id.contains("override")
    }

    @ViewBuilder
    private func labWorkbenchView(for item: EvidenceItem) -> some View {
        let id = item.evidenceId.lowercased()
        let tags = item.tags.map { $0.lowercased() }
        let typeStr = item.type.rawValue.lowercased()

        if typeStr.contains("audio") || tags.contains("audio") {
            AudioSpectrogramView(tapeTitle: item.title, durationSeconds: 18.4)
        } else if typeStr.contains("biometric") || tags.contains("fingerprint") || tags.contains("biometric") {
            BiometricFingerprintView(evidenceTitle: item.title, matchConfidence: 96.0)
        } else if typeStr.contains("ballistic") || tags.contains("ballistics") {
            BallisticComparatorView()
        } else if tags.contains("classified") || tags.contains("redacted") || id.contains("override") {
            RedactedDocumentView(documentTitle: item.title)
        } else {
            EmptyView()
        }
    }
}
