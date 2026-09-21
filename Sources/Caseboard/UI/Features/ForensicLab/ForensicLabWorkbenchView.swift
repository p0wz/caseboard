import SwiftUI

public enum ForensicWorkbenchTool: String, CaseIterable, Identifiable, Sendable {
    case biometric = "Biometrics"
    case ballistics = "Ballistics"
    case audio = "Audio Lab"
    case declassify = "Classified Dossier"

    public var id: String { rawValue }

    public var sfSymbol: String {
        switch self {
        case .biometric: return "waveform.path.ecg"
        case .ballistics: return "scope"
        case .audio: return "waveform.badge.magnifyingglass"
        case .declassify: return "doc.text.magnifyingglass"
        }
    }

    public var subtitle: String {
        switch self {
        case .biometric: return "AFIS Latent Ridge Examination"
        case .ballistics: return "Striation Comparison Microscope"
        case .audio: return "Spectral Frequency Denoising"
        case .declassify: return "Cryptographic Redaction Scrub"
        }
    }
}

public struct ForensicLabWorkbenchView: View {
    public let caseModel: CaseModel
    @State private var selectedTool: ForensicWorkbenchTool = .biometric
    @ObservedObject var progressStore = ProgressStore.shared

    public init(caseModel: CaseModel) {
        self.caseModel = caseModel
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header Station Selector
                stationSelector

                // Active Tool Workbench
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("ACTIVE FORENSIC STATION")
                                .font(.system(size: 9, weight: .black, design: .monospaced))
                                .foregroundColor(.secondary)
                            Text(selectedTool.subtitle.uppercased())
                                .font(.system(size: 13, weight: .bold, design: .monospaced))
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        FrostedBadge(
                            title: "LAB VERIFIED",
                            sfSymbol: "checkmark.seal.fill",
                            color: ForensicTheme.forensicGreen
                        )
                    }

                    workbenchChamber
                }

                // Case Telemetry & Sample Selector
                samplesDrawer
            }
            .padding(16)
        }
        .background(Color(red: 14/255, green: 16/255, blue: 20/255).edgesIgnoringSafeArea(.all))
    }

    // MARK: - Station Selector Bar

    private var stationSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ForensicWorkbenchTool.allCases) { tool in
                    let isSelected = selectedTool == tool
                    Button {
                        HapticsManager.shared.lightTap()
                        withAnimation(.spring(response: 0.25)) {
                            selectedTool = tool
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: tool.sfSymbol)
                                .font(.system(size: 12))
                            Text(tool.rawValue)
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .foregroundColor(isSelected ? .white : .secondary)
                        .background(
                            Capsule()
                                .fill(isSelected ? ForensicTheme.forensicBlue : Color.white.opacity(0.06))
                                .overlay(
                                    Capsule().stroke(isSelected ? ForensicTheme.forensicBlue : Color.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                    }
                }
            }
        }
    }

    // MARK: - Active Workbench Chamber

    @ViewBuilder
    private var workbenchChamber: some View {
        switch selectedTool {
        case .biometric:
            BiometricFingerprintView(
                evidenceTitle: "\(caseModel.title) Latent Print #402",
                matchConfidence: 99.4,
                suspectName: caseModel.suspects.first?.name
            )
        case .ballistics:
            BallisticComparatorView()
        case .audio:
            AudioSpectrogramView(
                tapeTitle: "DISPATCH INTERCEPT // \(caseModel.caseId.uppercased())",
                durationSeconds: 28.5,
                transcriptSnippet: "\"Subject verified at service exit corridor at 20:31 hours...\""
            )
        case .declassify:
            RedactedDocumentView(
                classificationLevel: "TOP SECRET // FORENSIC ARCHIVE",
                documentTitle: "FACILITY INCIDENT DOSSIER // \(caseModel.title.uppercased())",
                dateStamped: caseModel.briefing.date
            )
        }
    }

    // MARK: - Sample Drawer

    private var samplesDrawer: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("EVIDENCE SAMPLES READY FOR ANALYSIS", systemImage: "tray.full.fill")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.secondary)

            ForEach(caseModel.evidence.prefix(3)) { item in
                ForensicCard {
                    HStack {
                        Image(systemName: item.type.sfSymbol)
                            .foregroundColor(ForensicTheme.forensicBlue)
                            .frame(width: 24)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text(item.source)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Button {
                            HapticsManager.shared.lightTap()
                            SoundManager.shared.playEvidenceAdmitted()
                        } label: {
                            Text("LOAD SAMPLE")
                                .font(.system(size: 9, weight: .black, design: .monospaced))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.white.opacity(0.12), in: Capsule())
                        }
                    }
                }
            }
        }
    }
}
