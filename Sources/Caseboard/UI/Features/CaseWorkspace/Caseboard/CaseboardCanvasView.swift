import SwiftUI

public struct CaseboardCanvasView: View {
    public let caseModel: CaseModel
    @ObservedObject var progressStore = ProgressStore.shared

    @State private var selectedNodeId: String?
    @State private var connectingTargetNodeId: String?
    @State private var showConnectionPicker: Bool = false
    @State private var showAddPinSheet: Bool = false
    @State private var discoveredInsight: Contradiction?
    @State private var insightFeedbackMessage: String?
    @State private var showInsightSheet: Bool = false

    private let deductionEngine = DeductionEngine()

    public init(caseModel: CaseModel) {
        self.caseModel = caseModel
    }

    private var caseProgress: CaseProgress {
        progressStore.progress(for: caseModel.caseId)
    }

    private var pinnedNodes: [CaseboardNode] {
        caseProgress.pinnedNodes
    }

    private var nodeMap: [String: CaseboardNode] {
        Dictionary(uniqueKeysWithValues: pinnedNodes.map { ($0.nodeId, $0) })
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Forensic Grid
                ForensicCanvasGrid()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedNodeId = nil
                        connectingTargetNodeId = nil
                    }

                // Render Connection Threads
                ForEach(caseProgress.connections) { connection in
                    if let source = nodeMap[connection.sourceId],
                       let target = nodeMap[connection.targetId] {
                        let start = CGPoint(x: source.x + 76, y: source.y + 2)
                        let end = CGPoint(x: target.x + 76, y: target.y + 2)

                        ConnectionLineShape(start: start, end: end, curvature: 0.12)
                            .stroke(
                                Color(hex: connection.connectionType.threadColorHex),
                                style: StrokeStyle(
                                    lineWidth: connection.evaluation == .critical ? 3.5 : 2.2,
                                    lineCap: .round,
                                    dash: connection.evaluation == .untested ? [6, 4] : []
                                )
                            )
                            .shadow(color: Color(hex: connection.connectionType.threadColorHex).opacity(0.5), radius: 4)

                        // Knot anchor rings on pushpin heads
                        Circle()
                            .fill(Color(hex: connection.connectionType.threadColorHex))
                            .frame(width: 6, height: 6)
                            .position(start)
                        Circle()
                            .fill(Color(hex: connection.connectionType.threadColorHex))
                            .frame(width: 6, height: 6)
                            .position(end)
                    }
                }

                // Render Pinned Cards
                ForEach(pinnedNodes) { node in
                    let info = getCardInfo(for: node)
                    CaseboardCardNodeView(
                        node: node,
                        title: info.title,
                        subtitle: info.subtitle,
                        iconSymbol: info.icon,
                        badgeText: info.badge,
                        badgeColor: info.badgeColor,
                        isSelected: selectedNodeId == node.nodeId,
                        isConnectionTarget: connectingTargetNodeId == node.nodeId,
                        onSelect: {
                            handleNodeTap(node.nodeId)
                        }
                    )
                    .position(x: node.x + 76, y: node.y + 54)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newX = max(10, min(geometry.size.width - 160, value.location.x - 76))
                                let newY = max(10, min(geometry.size.height - 120, value.location.y - 54))
                                progressStore.updateNodePosition(caseId: caseModel.caseId, nodeId: node.nodeId, x: newX, y: newY)
                            }
                    )
                }

                // Empty State Overlay
                if pinnedNodes.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        Text("Caseboard Canvas is Empty")
                            .font(.headline)
                        Text("Pin evidence records or persons of interest to draw deduction threads.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        Button {
                            showAddPinSheet = true
                        } label: {
                            Label("Pin Clues to Board", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Capsule().fill(ForensicTheme.forensicBlue))
                        }
                    }
                }

                // Floating Action Bar (Top / Bottom)
                VStack {
                    HStack {
                        if selectedNodeId != nil {
                            HStack(spacing: 8) {
                                Image(systemName: "hand.tap.fill")
                                    .foregroundColor(ForensicTheme.forensicBlue)
                                Text("Card selected. Tap second card to connect.")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                Button("Cancel") {
                                    selectedNodeId = nil
                                }
                                .font(.caption)
                                .foregroundColor(.red)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(.ultraThinMaterial, in: Capsule())
                            .overlay(Capsule().strokeBorder(ForensicTheme.forensicBlue.opacity(0.3), lineWidth: 1))
                        }

                        Spacer()

                        // Controls
                        HStack(spacing: 8) {
                            Button {
                                autoArrangeNodes(in: geometry.size)
                            } label: {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .padding(10)
                                    .background(.ultraThinMaterial, in: Circle())
                            }
                            .accessibilityLabel("Auto-arrange cards")

                            Button {
                                showAddPinSheet = true
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Circle().fill(ForensicTheme.forensicBlue))
                            }
                            .accessibilityLabel("Add pin")
                        }
                    }
                    .padding(16)

                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showConnectionPicker) {
            if let idA = selectedNodeId, let idB = connectingTargetNodeId {
                ConnectionClassificationSheet(
                    sourceTitle: getCardInfo(id: idA).title,
                    targetTitle: getCardInfo(id: idB).title,
                    onSelectType: { connType in
                        validateAndCreateConnection(idA: idA, idB: idB, type: connType)
                    }
                )
            }
        }
        .sheet(isPresented: $showAddPinSheet) {
            AddPinSheet(caseModel: caseModel)
        }
        .sheet(isPresented: $showInsightSheet) {
            if let insight = discoveredInsight {
                InsightBreakthroughSheet(contradiction: insight, feedback: insightFeedbackMessage) {
                    showInsightSheet = false
                }
            }
        }
    }

    // MARK: - Node Interactions

    private func handleNodeTap(_ nodeId: String) {
        if selectedNodeId == nil {
            HapticsManager.shared.connectionStart()
            selectedNodeId = nodeId
        } else if selectedNodeId == nodeId {
            selectedNodeId = nil
        } else {
            connectingTargetNodeId = nodeId
            showConnectionPicker = true
        }
    }

    private func validateAndCreateConnection(idA: String, idB: String, type: ConnectionType) {
        showConnectionPicker = false

        let validation = deductionEngine.validateConnection(
            idA: idA,
            idB: idB,
            connectionType: type,
            in: caseModel,
            existingConnections: caseProgress.connections
        )

        var evaluation: ConnectionEvaluation = .untested
        switch validation {
        case .critical(let contradiction, _):
            evaluation = .critical
            HapticsManager.shared.criticalContradiction()
            SoundManager.shared.playDiscoveryChime()
            progressStore.recordDiscoveredContradiction(caseId: caseModel.caseId, contradictionId: contradiction.contradictionId)
            self.discoveredInsight = contradiction
            self.insightFeedbackMessage = contradiction.explanation
            self.showInsightSheet = true

        case .correct(let contradiction, _):
            evaluation = .correct
            HapticsManager.shared.correctConnection()
            SoundManager.shared.playDiscoveryChime()
            progressStore.recordDiscoveredContradiction(caseId: caseModel.caseId, contradictionId: contradiction.contradictionId)
            self.discoveredInsight = contradiction
            self.insightFeedbackMessage = contradiction.explanation
            self.showInsightSheet = true

        case .validRelationship:
            evaluation = .correct
            HapticsManager.shared.correctConnection()
            SoundManager.shared.playTap()

        case .partial:
            evaluation = .partial
            HapticsManager.shared.lightTap()

        case .spuriousLink:
            evaluation = .incorrect
            HapticsManager.shared.wrongConnection()
            SoundManager.shared.playRejection()
            progressStore.recordWrongAttempt(caseId: caseModel.caseId)
        }

        let newConnection = CaseboardConnection(
            sourceId: idA,
            targetId: idB,
            connectionType: type,
            evaluation: evaluation
        )
        progressStore.addConnection(caseId: caseModel.caseId, connection: newConnection)

        selectedNodeId = nil
        connectingTargetNodeId = nil
    }

    private func autoArrangeNodes(in size: CGSize) {
        HapticsManager.shared.lightTap()
        let count = pinnedNodes.count
        guard count > 0 else { return }

        let cols = max(1, Int(size.width / 170))
        for (i, node) in pinnedNodes.enumerated() {
            let row = i / cols
            let col = i % cols
            let x = Double(col * 160 + 20)
            let y = Double(row * 120 + 80)
            progressStore.updateNodePosition(caseId: caseModel.caseId, nodeId: node.nodeId, x: x, y: y)
        }
    }

    private func getCardInfo(for node: CaseboardNode) -> (title: String, subtitle: String, icon: String, badge: String?, badgeColor: Color) {
        getCardInfo(id: node.nodeId)
    }

    private func getCardInfo(id: String) -> (title: String, subtitle: String, icon: String, badge: String?, badgeColor: Color) {
        if let ev = caseModel.evidence.first(where: { $0.evidenceId == id }) {
            return (
                title: ev.title,
                subtitle: ev.type.displayName,
                icon: ev.type.sfSymbol,
                badge: ev.reliability.displayName,
                badgeColor: Color(hex: ev.reliability.colorHex)
            )
        } else if let s = caseModel.suspects.first(where: { $0.suspectId == id }) {
            return (
                title: s.name,
                subtitle: s.role,
                icon: "person.crop.circle.fill",
                badge: s.alibiStatus.displayName,
                badgeColor: Color(hex: s.alibiStatus.colorHex)
            )
        }
        return ("Unknown", "Record", "questionmark", nil, .gray)
    }
}

// Subtle grid canvas pattern
struct ForensicCanvasGrid: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Canvas { context, size in
            let step: CGFloat = 30
            var path = Path()

            for x in stride(from: 0, to: size.width, by: step) {
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
            }
            for y in stride(from: 0, to: size.height, by: step) {
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
            }

            let strokeColor = colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.04)
            context.stroke(path, with: .color(strokeColor), lineWidth: 1)
        }
        .background(ForensicTheme.backgroundColor(for: colorScheme))
    }
}

// Connection Type Selection Sheet
struct ConnectionClassificationSheet: View {
    let sourceTitle: String
    let targetTitle: String
    let onSelectType: (ConnectionType) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("ESTABLISH FORENSIC LINK")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                    Text("\(sourceTitle)  ↔  \(targetTitle)")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 16)

                List {
                    ForEach(ConnectionType.allCases, id: \.self) { type in
                        Button {
                            onSelectType(type)
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: type.sfSymbol)
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(hex: type.threadColorHex))
                                    .frame(width: 30)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(type.displayName)
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
                .forensicInsetGrouped()
            }
            .navigationTitle("Connection Classification")
            .forensicInlineTitle()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

// Add Pin Quick-Sheet
struct AddPinSheet: View {
    let caseModel: CaseModel
    @ObservedObject var progressStore = ProgressStore.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Persons of Interest") {
                    ForEach(caseModel.suspects) { suspect in
                        let isPinned = progressStore.progress(for: caseModel.caseId).pinnedNodes.contains { $0.nodeId == suspect.suspectId }
                        HStack {
                            Label(suspect.name, systemImage: "person.fill")
                            Spacer()
                            Button(isPinned ? "Unpin" : "Pin") {
                                progressStore.togglePinNode(caseId: caseModel.caseId, nodeId: suspect.suspectId, itemType: .suspect)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }

                Section("Discovered Evidence") {
                    ForEach(caseModel.evidence.filter { $0.discoveredInitially }) { ev in
                        let isPinned = progressStore.progress(for: caseModel.caseId).pinnedNodes.contains { $0.nodeId == ev.evidenceId }
                        HStack {
                            Label(ev.title, systemImage: ev.type.sfSymbol)
                            Spacer()
                            Button(isPinned ? "Unpin" : "Pin") {
                                progressStore.togglePinNode(caseId: caseModel.caseId, nodeId: ev.evidenceId, itemType: .evidence)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
            .navigationTitle("Pin Clues to Canvas")
            .forensicInlineTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// Insight Found Sheet
struct InsightBreakthroughSheet: View {
    let contradiction: Contradiction
    let feedback: String?
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 12)

            ZStack {
                Circle()
                    .fill(ForensicTheme.forensicGold.opacity(0.18))
                    .frame(width: 72, height: 72)
                Image(systemName: "sparkles")
                    .font(.system(size: 36))
                    .foregroundColor(ForensicTheme.forensicGold)
            }

            VStack(spacing: 6) {
                Text("INSIGHT UNLOCKED")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(ForensicTheme.forensicGold)

                Text(contradiction.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            ForensicCard {
                VStack(alignment: .leading, spacing: 10) {
                    Label("FORENSIC DISCREPANCY", systemImage: "bolt.horizontal.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)

                    Text(contradiction.explanation)
                        .font(.body)
                        .lineSpacing(4)
                }
            }
            .padding(.horizontal, 20)

            if let unlocks = contradiction.unlocks, !unlocks.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "lock.open.fill")
                        .foregroundColor(ForensicTheme.verifiedGreen)
                    Text("New Evidence Unlocked into File Archive!")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(ForensicTheme.verifiedGreen)
                }
            }

            Spacer()

            Button(action: onDismiss) {
                Text("Continue Investigation")
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
