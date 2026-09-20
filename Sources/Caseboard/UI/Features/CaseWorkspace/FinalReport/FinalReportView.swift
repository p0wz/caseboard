import SwiftUI

public struct FinalReportView: View {
    public let caseModel: CaseModel
    @ObservedObject var progressStore = ProgressStore.shared

    @State private var selectedCulpritId: String = ""
    @State private var selectedMotiveId: String = ""
    @State private var selectedMeansId: String = ""
    @State private var selectedOpportunityId: String = ""
    @State private var selectedContradictionId: String = ""
    @State private var selectedTimelineId: String = ""
    @State private var hypothesisText: String = ""

    @State private var submissionResult: AccusationResult?
    @State private var showResolutionSheet: Bool = false
    @State private var startTime: Date = Date()

    private let finalReportEngine = FinalReportEngine()

    public init(caseModel: CaseModel) {
        self.caseModel = caseModel
    }

    private var caseProgress: CaseProgress {
        progressStore.progress(for: caseModel.caseId)
    }

    private var availableEvidence: [EvidenceItem] {
        caseModel.evidence.filter { item in
            if item.discoveredInitially { return true }
            if let condition = item.unlockCondition {
                return caseProgress.discoveredContradictions.contains(condition)
            }
            return false
        }
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header card
                ForensicCard {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            FrostedBadge(
                                title: "FINAL ACCUSATION DOSSIER",
                                sfSymbol: "lock.shield.fill",
                                color: ForensicTheme.forensicBlue
                            )
                            Spacer()
                            if let grade = caseProgress.bestGrade {
                                FrostedBadge(
                                    title: "SOLVED: GRADE \(grade.rawValue)",
                                    sfSymbol: "checkmark.seal.fill",
                                    color: Color(hex: grade.colorHex)
                                )
                            }
                        }

                        Text("Submit Case Accusation")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Assemble the forensic chain of evidence. Accusation must establish prime culpability, motive, instrumental means, and broken alibi opportunity.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                // 1. Prime Culprit Selector
                VStack(alignment: .leading, spacing: 8) {
                    Label("1. PRIME SUSPECT ACCUSED", systemImage: "person.crop.circle.badge.exclamationmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)

                    ForensicCard {
                        Picker("Select Accused", selection: $selectedCulpritId) {
                            Text("Select Prime Suspect...").tag("")
                            ForEach(caseModel.suspects) { suspect in
                                Text("\(suspect.name) — \(suspect.role)").tag(suspect.suspectId)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }

                // 2. Motive Evidence
                VStack(alignment: .leading, spacing: 8) {
                    Label("2. SUBSTANTIATING MOTIVE", systemImage: "flame.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)

                    ForensicCard {
                        Picker("Select Motive Evidence", selection: $selectedMotiveId) {
                            Text("Select Motive Evidence...").tag("")
                            ForEach(availableEvidence) { ev in
                                Text("\(ev.title) (\(ev.type.displayName))").tag(ev.evidenceId)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }

                // 3. Means Evidence
                VStack(alignment: .leading, spacing: 8) {
                    Label("3. PHYSICAL MEANS & INSTRUMENT", systemImage: "wrench.and.screwdriver.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)

                    ForensicCard {
                        Picker("Select Means Evidence", selection: $selectedMeansId) {
                            Text("Select Instrumental Means...").tag("")
                            ForEach(availableEvidence) { ev in
                                Text("\(ev.title) (\(ev.type.displayName))").tag(ev.evidenceId)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }

                // 4. Opportunity Evidence
                VStack(alignment: .leading, spacing: 8) {
                    Label("4. SCENE OPPORTUNITY & TIMING", systemImage: "door.left.hand.open")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)

                    ForensicCard {
                        Picker("Select Opportunity Evidence", selection: $selectedOpportunityId) {
                            Text("Select Opportunity Telemetry...").tag("")
                            ForEach(availableEvidence) { ev in
                                Text("\(ev.title) (\(ev.type.displayName))").tag(ev.evidenceId)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }

                // 5. Key Contradiction
                VStack(alignment: .leading, spacing: 8) {
                    Label("5. KEY CONTRADICTION / BROKEN ALIBI", systemImage: "bolt.horizontal.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)

                    ForensicCard {
                        Picker("Select Contradiction", selection: $selectedContradictionId) {
                            Text("Select Discovered Contradiction...").tag("")
                            ForEach(caseModel.contradictions) { c in
                                Text(c.title).tag(c.contradictionId)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }

                // Submit Accusation Button
                Button {
                    submitFinalReport()
                } label: {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                        Text("Submit Accusation to District Analyst")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(canSubmit ? ForensicTheme.forensicBlue : Color.secondary.opacity(0.3))
                    )
                }
                .disabled(!canSubmit)
                .padding(.top, 10)
            }
            .padding(16)
        }
        .sheet(isPresented: $showResolutionSheet) {
            if let result = submissionResult {
                CaseResolutionView(result: result, caseModel: caseModel) {
                    showResolutionSheet = false
                }
            }
        }
    }

    private var canSubmit: Bool {
        !selectedCulpritId.isEmpty && !selectedMotiveId.isEmpty && !selectedMeansId.isEmpty && !selectedOpportunityId.isEmpty
    }

    private func submitFinalReport() {
        let submission = AccusationSubmission(
            caseId: caseModel.caseId,
            culpritId: selectedCulpritId,
            motiveEvidenceIds: [selectedMotiveId],
            meansEvidenceIds: [selectedMeansId],
            opportunityEvidenceIds: [selectedOpportunityId],
            keyContradictionId: selectedContradictionId,
            timelineEventIds: selectedTimelineId.isEmpty ? [] : [selectedTimelineId],
            playerHypothesis: hypothesisText.isEmpty ? nil : hypothesisText
        )

        let elapsed = Int(Date().timeIntervalSince(startTime)) + caseProgress.elapsedSeconds
        let result = finalReportEngine.evaluateAccusation(
            submission: submission,
            in: caseModel,
            hintsUsedCount: caseProgress.hintsUsed.count,
            previousWrongAttempts: caseProgress.wrongAttemptsCount,
            elapsedSeconds: elapsed
        )

        self.submissionResult = result

        if result.isSuccess {
            if result.isPerfectSolve {
                HapticsManager.shared.perfectSolve()
            } else {
                HapticsManager.shared.caseSolved()
            }
            SoundManager.shared.playSolved()
            progressStore.recordCaseSolved(caseId: caseModel.caseId, result: result, elapsedSeconds: elapsed)
        } else {
            HapticsManager.shared.wrongConnection()
            SoundManager.shared.playRejection()
            progressStore.recordWrongAttempt(caseId: caseModel.caseId)
        }

        showResolutionSheet = true
    }
}

public struct CaseResolutionView: View {
    public let result: AccusationResult
    public let caseModel: CaseModel
    public let onDismiss: () -> Void

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Capsule()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)

                if result.isSuccess {
                    // Success View
                    ZStack {
                        Circle()
                            .fill(Color(hex: result.grade?.colorHex ?? "#FFD700").opacity(0.2))
                            .frame(width: 90, height: 90)
                        Text(result.grade?.rawValue ?? "A")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundColor(Color(hex: result.grade?.colorHex ?? "#FFD700"))
                    }

                    VStack(spacing: 4) {
                        Text(result.isPerfectSolve ? "FLAWLESS DEDUCTION" : "CASE SOLVED")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(ForensicTheme.forensicGold)

                        Text(result.grade?.title ?? "Case Analyst")
                            .font(.title2)
                            .fontWeight(.bold)
                    }

                    // Slammed S+ Rubber Stamp
                    RubberStampView(kind: result.isPerfectSolve ? .caseClosedSPlus : .matchConfirmed, isSlammed: true)
                        .padding(.vertical, 4)

                    ForensicCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("OFFICIAL DISTRICT DISCLOSURE")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.secondary)
                            Text(result.resolutionSummary)
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .padding(.horizontal, 16)

                    // Performance Metrics Grid
                    ForensicCard {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Score Awarded")
                                Spacer()
                                Text("+\(result.finalScore) PTS")
                                    .fontWeight(.bold)
                                    .foregroundColor(ForensicTheme.forensicBlue)
                            }
                            Divider()
                            HStack {
                                Text("Hints Requested")
                                Spacer()
                                Text("\(result.hintsUsedCount)")
                                    .fontWeight(.semibold)
                            }
                            Divider()
                            HStack {
                                Text("False Hypotheses")
                                Spacer()
                                Text("\(result.wrongAttemptsCount)")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                } else {
                    // Rejection View
                    ZStack {
                        Circle()
                            .fill(ForensicTheme.criticalRed.opacity(0.18))
                            .frame(width: 80, height: 80)
                        Image(systemName: "xmark.shield.fill")
                            .font(.system(size: 40))
                            .foregroundColor(ForensicTheme.criticalRed)
                    }

                    VStack(spacing: 4) {
                        Text("ACCUSATION REJECTED")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(ForensicTheme.criticalRed)
                        Text("Dossier Incomplete or Inconsistent")
                            .font(.title3)
                            .fontWeight(.bold)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("DISTRICT ANALYST FEEDBACK:")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)

                        ForEach(result.analyticalFeedback, id: \.self) { feedback in
                            ForensicCard {
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: "arrow.triangle.pull")
                                        .foregroundColor(ForensicTheme.criticalRed)
                                    Text(feedback)
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                Spacer()

                Button(action: onDismiss) {
                    Text(result.isSuccess ? "Return to Archive" : "Re-examine Case Clues")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(ForensicTheme.forensicBlue))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
}
