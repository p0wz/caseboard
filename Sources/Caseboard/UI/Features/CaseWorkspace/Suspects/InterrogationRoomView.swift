import SwiftUI

public struct InterrogationRoomView: View {
    public let suspect: Suspect
    public let caseModel: CaseModel
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var progressStore = ProgressStore.shared

    @State private var dialogueHistory: [(speaker: String, text: String, isBreakthrough: Bool)] = []
    @State private var askedTopicIds: Set<String> = []
    @State private var breakthroughsCount: Int = 0
    @State private var isShowingEvidencePicker: Bool = false
    @State private var latestBreakthrough: String? = nil
    @State private var showStampAnimation: Bool = false

    public init(suspect: Suspect, caseModel: CaseModel) {
        self.suspect = suspect
        self.caseModel = caseModel
    }

    private var caseProgress: CaseProgress {
        progressStore.progress(for: caseModel.caseId)
    }

    private var currentStress: Double {
        InterrogationEngine.shared.computeStress(
            baseMotive: suspect.motiveScore,
            alibiStatus: suspect.alibiStatus,
            topicsAskedCount: askedTopicIds.count,
            breakthroughsCount: breakthroughsCount
        )
    }

    private var stressColor: Color {
        if currentStress >= 0.75 {
            return Color.red
        } else if currentStress >= 0.45 {
            return Color.orange
        } else {
            return ForensicTheme.forensicBlue
        }
    }

    public var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                interrogationHeader
                Divider().background(Color.white.opacity(0.12))

                // Scrollable Dialogue Transcript
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            // Initial suspect stance
                            dialogueBubble(
                                speaker: suspect.name.uppercased(),
                                text: suspect.initialAlibi ?? "I have nothing to hide. Ask your questions.",
                                isSuspect: true,
                                isBreakthrough: false
                            )

                            ForEach(0..<dialogueHistory.count, id: \.self) { idx in
                                let entry = dialogueHistory[idx]
                                dialogueBubble(
                                    speaker: entry.speaker,
                                    text: entry.text,
                                    isSuspect: entry.speaker != "DETECTIVE",
                                    isBreakthrough: entry.isBreakthrough
                                )
                                .id(idx)
                            }
                        }
                        .padding(16)
                    }
                    .onChange(of: dialogueHistory.count) { _ in
                        withAnimation {
                            proxy.scrollTo(dialogueHistory.count - 1, anchor: .bottom)
                        }
                    }
                }

                Divider().background(Color.white.opacity(0.12))

                // Inquiry Controls
                inquiryControlPanel
            }

            // Slamming Rubber Stamp Overlay on Breakthrough
            if showStampAnimation {
                RubberStampView(kind: .alibiCompromised, customAngle: -10, isSlammed: true)
                    .transition(.scale(scale: 2.0).combined(with: .opacity))
                    .zIndex(100)
                    .allowsHitTesting(false)
            }
        }
        .sheet(isPresented: $isShowingEvidencePicker) {
            evidencePickerSheet
        }
        .navigationTitle("Interrogation Room")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Exit") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
        .onAppear {
            SoundManager.shared.playCassetteClick()
        }
    }

    // MARK: - Header & Stress Meter

    private var interrogationHeader: some View {
        HStack(spacing: 14) {
            // Suspect Mugshot Thumbnail
            ZStack {
                ProceduralDossierCardView(
                    suspect: suspect,
                    size: CGSize(width: 58, height: 72),
                    showFullPlacard: false
                )
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(stressColor, lineWidth: 2)
                )
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(suspect.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text(suspect.alibiStatus.displayName.uppercased())
                        .font(.system(size: 8, weight: .black, design: .monospaced))
                        .foregroundColor(Color(hex: suspect.alibiStatus.colorHex))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(hex: suspect.alibiStatus.colorHex).opacity(0.18), in: Capsule())
                }

                Text(suspect.role)
                    .font(.caption)
                    .foregroundColor(.secondary)

                // Stress Level Bar
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("PSYCHOLOGICAL STRESS")
                            .font(.system(size: 7, weight: .bold, design: .monospaced))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(currentStress * 100))%")
                            .font(.system(size: 8, weight: .bold, design: .monospaced))
                            .foregroundColor(stressColor)
                    }

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.white.opacity(0.1)).frame(height: 5)
                            Capsule().fill(stressColor).frame(width: max(4, geo.size.width * CGFloat(currentStress)), height: 5)
                        }
                    }
                    .frame(height: 5)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(red: 18/255, green: 20/255, blue: 24/255))
    }

    // MARK: - Dialogue Bubble

    private func dialogueBubble(speaker: String, text: String, isSuspect: Bool, isBreakthrough: Bool) -> some View {
        let bubbleFill: Color = isBreakthrough ? Color.red.opacity(0.25) : (isSuspect ? Color.white.opacity(0.08) : ForensicTheme.forensicBlue.opacity(0.2))
        let bubbleStroke: Color = isBreakthrough ? Color.red.opacity(0.6) : (isSuspect ? Color.white.opacity(0.12) : ForensicTheme.forensicBlue.opacity(0.4))
        let speakerColor: Color = isBreakthrough ? .red : (isSuspect ? ForensicTheme.forensicGold : ForensicTheme.forensicBlue)

        return HStack {
            if !isSuspect { Spacer(minLength: 40) }

            VStack(alignment: isSuspect ? .leading : .trailing, spacing: 4) {
                Text(speaker)
                    .font(.system(size: 9, weight: .black, design: .monospaced))
                    .foregroundColor(speakerColor)

                Text(text)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(bubbleFill)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(bubbleStroke, lineWidth: 1)
                            )
                    )
            }

            if isSuspect { Spacer(minLength: 40) }
        }
    }

    // MARK: - Inquiry Controls

    private var inquiryControlPanel: some View {
        VStack(spacing: 12) {
            // Topic Buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(availableTopics) { topic in
                        let isAsked = askedTopicIds.contains(topic.topicId)
                        Button {
                            askTopic(topic)
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: isAsked ? "checkmark.circle" : "questionmark.circle.fill")
                                Text(topic.questionText)
                            }
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(isAsked ? .secondary : .white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(isAsked ? Color.white.opacity(0.06) : ForensicTheme.forensicBlue.opacity(0.25))
                                    .overlay(
                                        Capsule().stroke(isAsked ? Color.white.opacity(0.1) : ForensicTheme.forensicBlue, lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
            }

            // Confront with Evidence Button
            Button {
                HapticsManager.shared.mediumTap()
                isShowingEvidencePicker = true
            } label: {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("CONFRONT WITH PHYSICAL EVIDENCE")
                }
                .font(.system(size: 13, weight: .black, design: .monospaced))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(ForensicTheme.forensicGold)
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .padding(.vertical, 10)
        .background(Color(red: 18/255, green: 20/255, blue: 24/255))
    }

    private var availableTopics: [InterrogationTopic] {
        if !suspect.interrogationTopics.isEmpty {
            return suspect.interrogationTopics
        }
        // Fallback procedural topics
        return [
            InterrogationTopic(
                topicId: "inquiry_alibi",
                questionText: "Verify Alibi Timeline",
                initialResponse: suspect.initialAlibi ?? "I already gave my schedule to dispatch."
            ),
            InterrogationTopic(
                topicId: "inquiry_victim",
                questionText: "Relationship to Elias",
                initialResponse: "We had our professional differences, but nothing that warrants this inquiry."
            ),
            InterrogationTopic(
                topicId: "inquiry_access",
                questionText: "Vault & Keycard Access",
                initialResponse: "Access logs speak for themselves. Check the electronic audit records."
            )
        ]
    }

    private func askTopic(_ topic: InterrogationTopic) {
        guard !askedTopicIds.contains(topic.topicId) else { return }
        HapticsManager.shared.lightTap()
        SoundManager.shared.playTypewriter()
        askedTopicIds.insert(topic.topicId)

        dialogueHistory.append((speaker: "DETECTIVE", text: topic.questionText, isBreakthrough: false))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            dialogueHistory.append((speaker: suspect.name.uppercased(), text: topic.initialResponse, isBreakthrough: false))
        }
    }

    // MARK: - Evidence Confrontation Sheet

    private var evidencePickerSheet: some View {
        NavigationStack {
            List {
                Section {
                    Text("Presenting physical or forensic evidence directly challenges the suspect's testimony. Irrelevant evidence will give the suspect defensive leverage.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Section("DISCOVERED EVIDENCE") {
                    ForEach(caseModel.evidence) { item in
                        Button {
                            isShowingEvidencePicker = false
                            confrontWith(evidence: item)
                        } label: {
                            HStack {
                                Image(systemName: item.type.sfSymbol)
                                    .foregroundColor(ForensicTheme.forensicBlue)
                                    .frame(width: 24)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.title)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    Text(item.source)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Confront with Evidence")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isShowingEvidencePicker = false
                    }
                }
            }
        }
    }

    private func confrontWith(evidence: EvidenceItem) {
        dialogueHistory.append((
            speaker: "DETECTIVE",
            text: "Take a look at this record: \(evidence.title). Care to explain?",
            isBreakthrough: false
        ))

        let outcome = InterrogationEngine.shared.evaluateConfrontation(
            suspect: suspect,
            evidenceId: evidence.evidenceId,
            caseModel: caseModel
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if outcome.isBreakthrough {
                breakthroughsCount += 1
                HapticsManager.shared.alibiBroken()
                SoundManager.shared.playAlibiBroken()

                withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                    showStampAnimation = true
                }

                // Auto dismiss stamp after 1.8s
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    withAnimation {
                        showStampAnimation = false
                    }
                }

                if let contraId = outcome.unlockedContradictionId {
                    progressStore.recordDiscoveredContradiction(caseId: caseModel.caseId, contradictionId: contraId)
                }

                dialogueHistory.append((
                    speaker: suspect.name.uppercased(),
                    text: outcome.responseText,
                    isBreakthrough: true
                ))
            } else {
                HapticsManager.shared.lightTap()
                dialogueHistory.append((
                    speaker: suspect.name.uppercased(),
                    text: outcome.responseText,
                    isBreakthrough: false
                ))
            }
        }
    }
}
