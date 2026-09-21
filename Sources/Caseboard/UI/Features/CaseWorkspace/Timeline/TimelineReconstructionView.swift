import SwiftUI

public struct TimelineReconstructionView: View {
    public let caseModel: CaseModel
    @ObservedObject var progressStore = ProgressStore.shared
    @State private var orderedEventIds: [String] = []
    @State private var validationResult: TimelineValidationResult?
    @State private var showConflictModal: Bool = false

    private let timelineEngine = TimelineEngine()

    public init(caseModel: CaseModel) {
        self.caseModel = caseModel
    }

    private var caseProgress: CaseProgress {
        progressStore.progress(for: caseModel.caseId)
    }

    private var eventsMap: [String: TimelineEvent] {
        Dictionary(uniqueKeysWithValues: caseModel.timeline.map { ($0.eventId, $0) })
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Header stats banner
            ForensicCard {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("CHRONOLOGICAL RECONSTRUCTION")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.secondary)
                        Text("Order events into true sequence")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                    Button {
                        validateTimeline()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Verify")
                        }
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(ForensicTheme.forensicBlue))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            // Timeline Sequence List
            List {
                ForEach(Array(orderedEventIds.enumerated()), id: \.element) { index, eventId in
                    if let event = eventsMap[eventId] {
                        TimelineEventRow(
                            index: index + 1,
                            event: event,
                            hasConflict: validationResult?.conflicts.contains { $0.eventId == eventId } ?? false,
                            onMoveUp: index > 0 ? { moveEvent(from: index, to: index - 1) } : nil,
                            onMoveDown: index < orderedEventIds.count - 1 ? { moveEvent(from: index, to: index + 1) } : nil
                        )
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    }
                }
                .onMove { indices, newOffset in
                    orderedEventIds.move(fromOffsets: indices, toOffset: newOffset)
                    HapticsManager.shared.lightTap()
                }
            }
            .listStyle(.plain)
        }
        .onAppear {
            initializeTimeline()
        }
        .sheet(isPresented: $showConflictModal) {
            if let result = validationResult {
                TimelineConflictSummarySheet(result: result) {
                    showConflictModal = false
                }
            }
        }
    }

    private func initializeTimeline() {
        if !caseProgress.timelineOrder.isEmpty {
            self.orderedEventIds = caseProgress.timelineOrder
        } else {
            // Default to randomized/canonical mixed order for puzzle
            self.orderedEventIds = caseModel.timeline.map { $0.eventId }.shuffled()
        }
    }

    private func moveEvent(from: Int, to: Int) {
        HapticsManager.shared.lightTap()
        SoundManager.shared.playTap()
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            let item = orderedEventIds.remove(at: from)
            orderedEventIds.insert(item, at: to)
        }
    }

    private func validateTimeline() {
        let result = timelineEngine.validateTimeline(
            orderedEventIds: orderedEventIds,
            against: caseModel.timeline
        )
        self.validationResult = result

        if result.isValid {
            HapticsManager.shared.correctConnection()
            SoundManager.shared.playDiscoveryChime()
            progressStore.unlockAchievement(.timelineMaster)
        } else {
            HapticsManager.shared.wrongConnection()
            SoundManager.shared.playRejection()
        }
        showConflictModal = true
    }
}

struct TimelineEventRow: View {
    let index: Int
    let event: TimelineEvent
    let hasConflict: Bool
    let onMoveUp: (() -> Void)?
    let onMoveDown: (() -> Void)?

    var body: some View {
        ForensicCard {
            HStack(spacing: 12) {
                // Step badge
                ZStack {
                    Circle()
                        .fill(hasConflict ? ForensicTheme.criticalRed.opacity(0.18) : ForensicTheme.forensicBlue.opacity(0.15))
                        .frame(width: 32, height: 32)
                    Text("\(index)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(hasConflict ? ForensicTheme.criticalRed : ForensicTheme.forensicBlue)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(event.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        FrostedBadge(
                            title: event.timeWindow,
                            sfSymbol: "clock.fill",
                            color: .secondary
                        )
                    }

                    Text(event.eventDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    if hasConflict {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(ForensicTheme.criticalRed)
                            Text("Chronological conflict detected")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(ForensicTheme.criticalRed)
                        }
                        .padding(.top, 2)
                    }
                }

                // Up / Down controls
                VStack(spacing: 6) {
                    if let up = onMoveUp {
                        Button(action: up) {
                            Image(systemName: "chevron.up")
                                .font(.system(size: 12, weight: .bold))
                                .padding(6)
                                .background(Color.secondary.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    if let down = onMoveDown {
                        Button(action: down) {
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .bold))
                                .padding(6)
                                .background(Color.secondary.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                }
            }
        }
    }
}

struct TimelineConflictSummarySheet: View {
    let result: TimelineValidationResult
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 12)

            ZStack {
                Circle()
                    .fill((result.isValid ? ForensicTheme.verifiedGreen : ForensicTheme.criticalRed).opacity(0.18))
                    .frame(width: 72, height: 72)
                Image(systemName: result.isValid ? "checkmark.seal.fill" : "clock.badge.exclamationmark.fill")
                    .font(.system(size: 36))
                    .foregroundColor(result.isValid ? ForensicTheme.verifiedGreen : ForensicTheme.criticalRed)
            }

            VStack(spacing: 4) {
                Text(result.isValid ? "TIMELINE VERIFIED" : "CHRONOLOGY CONFLICT DETECTED")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(result.isValid ? ForensicTheme.verifiedGreen : ForensicTheme.criticalRed)
                Text("Chronological Accuracy: \(result.accuracyPercentage)%")
                    .font(.title3)
                    .fontWeight(.bold)
            }

            if !result.conflicts.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(result.conflicts) { conflict in
                            ForensicCard {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(conflict.eventTitle)
                                        .font(.headline)
                                    Text(conflict.conflictReason)
                                        .font(.subheadline)
                                        .foregroundColor(ForensicTheme.criticalRed)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            } else {
                ForensicCard {
                    Text("All timeline events align with physical sensor telemetry and witness timestamps without contradiction.")
                        .font(.body)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 20)
            }

            Spacer()

            Button(action: onDismiss) {
                Text("Return to Timeline")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(ForensicTheme.forensicBlue))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .presentationDetents([.medium, .large])
    }
}
