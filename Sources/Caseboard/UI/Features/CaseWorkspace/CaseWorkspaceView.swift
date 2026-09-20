import SwiftUI

public enum WorkspaceTab: String, CaseIterable, Identifiable {
    case briefing = "Briefing"
    case evidence = "Evidence"
    case forensicLab = "Forensic Lab"
    case caseboard = "Caseboard"
    case timeline = "Timeline"
    case suspects = "Suspects"
    case finalReport = "Final Report"

    public var id: String { rawValue }

    public var sfSymbol: String {
        switch self {
        case .briefing: return "doc.plaintext.fill"
        case .evidence: return "magnifyingglass"
        case .forensicLab: return "waveform.path.ecg"
        case .caseboard: return "square.grid.2x2.fill"
        case .timeline: return "clock.arrow.circlepath"
        case .suspects: return "person.3.fill"
        case .finalReport: return "checkmark.seal.fill"
        }
    }
}

public struct CaseWorkspaceView: View {
    public let caseModel: CaseModel
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var progressStore = ProgressStore.shared

    @State private var activeTab: WorkspaceTab = .briefing
    @State private var showHintSheet: Bool = false
    @State private var showNotesSheet: Bool = false
    @State private var playerNotes: String = ""

    public init(caseModel: CaseModel) {
        self.caseModel = caseModel
    }

    private var caseProgress: CaseProgress {
        progressStore.progress(for: caseModel.caseId)
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Sleek Forensic Segmented Navigation Bar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(WorkspaceTab.allCases) { tab in
                        Button {
                            HapticsManager.shared.lightTap()
                            withAnimation(.easeInOut(duration: 0.2)) {
                                activeTab = tab
                            }
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: tab.sfSymbol)
                                    .font(.system(size: 11, weight: .semibold))
                                Text(tab.rawValue)
                                    .font(.system(size: 13, weight: .medium))

                                // Badges
                                if tab == .evidence {
                                    Text("\(caseModel.evidence.filter { $0.discoveredInitially }.count)")
                                        .font(.system(size: 10, weight: .bold))
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 1)
                                        .background(Capsule().fill(Color.secondary.opacity(0.2)))
                                } else if tab == .caseboard && !caseProgress.pinnedNodes.isEmpty {
                                    Text("\(caseProgress.pinnedNodes.count)")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(ForensicTheme.forensicGold)
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 1)
                                        .background(Capsule().fill(ForensicTheme.forensicGold.opacity(0.2)))
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .foregroundColor(activeTab == tab ? .white : .primary)
                            .background(
                                Capsule()
                                    .fill(activeTab == tab ? ForensicTheme.forensicBlue : Color.clear)
                            )
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
            }
            .background(.ultraThinMaterial)
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color.secondary.opacity(0.2)),
                alignment: .bottom
            )

            // Tab Content
            Group {
                switch activeTab {
                case .briefing:
                    BriefingView(caseModel: caseModel)
                case .evidence:
                    EvidenceListView(caseModel: caseModel)
                case .forensicLab:
                    ForensicLabWorkbenchView(caseModel: caseModel)
                case .caseboard:
                    CaseboardCanvasView(caseModel: caseModel)
                case .timeline:
                    TimelineReconstructionView(caseModel: caseModel)
                case .suspects:
                    SuspectsListView(caseModel: caseModel)
                case .finalReport:
                    FinalReportView(caseModel: caseModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle(caseModel.title)
        .forensicInlineTitle()
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    showNotesSheet = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                .accessibilityLabel("Case Notes")

                if let hints = caseModel.hints, !hints.isEmpty {
                    Button {
                        showHintSheet = true
                    } label: {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(ForensicTheme.forensicGold)
                    }
                    .accessibilityLabel("Forensic Nudges")
                }
            }
        }
        .sheet(isPresented: $showHintSheet) {
            CaseHintSheet(caseModel: caseModel)
        }
        .sheet(isPresented: $showNotesSheet) {
            CaseNotesSheet(caseId: caseModel.caseId)
        }
    }
}

// Hint Sheet
struct CaseHintSheet: View {
    let caseModel: CaseModel
    @ObservedObject var progressStore = ProgressStore.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Forensic Assistance (No Payment Required)") {
                    Text("Requesting assistance clarifies obscure connections but slightly reduces final analyst score.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                if let hints = caseModel.hints {
                    ForEach(hints) { hint in
                        let isUsed = progressStore.progress(for: caseModel.caseId).hintsUsed.contains(hint.id)
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                FrostedBadge(title: hint.tier.title, color: ForensicTheme.forensicGold)
                                Spacer()
                                if !isUsed {
                                    Button("Reveal (- \(hint.tier.scorePenaltyPercent)%)") {
                                        HapticsManager.shared.lightTap()
                                        progressStore.recordHintUsed(caseId: caseModel.caseId, hintTier: hint.id)
                                    }
                                    .font(.caption)
                                    .buttonStyle(.bordered)
                                }
                            }

                            if isUsed {
                                Text(hint.text)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .padding(.top, 4)
                            } else {
                                Text("Tap Reveal to inspect this forensic advisory.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Investigative Nudges")
            .forensicInlineTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

// Player Notes Sheet
struct CaseNotesSheet: View {
    let caseId: String
    @ObservedObject var progressStore = ProgressStore.shared
    @State private var notesText: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $notesText)
                    .font(.body)
                    .padding()
            }
            .navigationTitle("Analyst Case Notes")
            .forensicInlineTitle()
            .onAppear {
                notesText = progressStore.userProgress.playerNotes[caseId] ?? ""
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        progressStore.saveNotes(caseId: caseId, notes: notesText)
                        dismiss()
                    }
                }
            }
        }
    }
}
