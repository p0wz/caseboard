import SwiftUI

public struct EvidenceListView: View {
    public let caseModel: CaseModel
    @ObservedObject var progressStore = ProgressStore.shared
    @State private var selectedType: EvidenceType?
    @State private var selectedEvidence: EvidenceItem?
    @State private var searchQuery: String = ""

    public init(caseModel: CaseModel) {
        self.caseModel = caseModel
    }

    private var caseProgress: CaseProgress {
        progressStore.progress(for: caseModel.caseId)
    }

    private var discoveredEvidence: [EvidenceItem] {
        caseModel.evidence.filter { item in
            if item.discoveredInitially { return true }
            if let condition = item.unlockCondition {
                return caseProgress.discoveredContradictions.contains(condition)
            }
            return false
        }
    }

    private var filteredEvidence: [EvidenceItem] {
        discoveredEvidence.filter { item in
            let matchesType = (selectedType == nil || item.type == selectedType)
            let matchesSearch = searchQuery.isEmpty ||
                item.title.localizedCaseInsensitiveContains(searchQuery) ||
                item.summary.localizedCaseInsensitiveContains(searchQuery) ||
                item.tags.contains { $0.localizedCaseInsensitiveContains(searchQuery) }
            return matchesType && matchesSearch
        }
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Search Bar & Filter Chips
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search evidence, tags, or sources...", text: $searchQuery)
                        .textFieldStyle(.plain)
                    if !searchQuery.isEmpty {
                        Button {
                            searchQuery = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.secondary.opacity(0.1))
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(title: "All", isSelected: selectedType == nil) {
                            selectedType = nil
                        }
                        ForEach(EvidenceType.allCases, id: \.self) { type in
                            FilterChip(title: type.displayName, isSelected: selectedType == type, sfSymbol: type.sfSymbol) {
                                selectedType = type
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            // Evidence Cards List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredEvidence) { item in
                        EvidenceRowCard(
                            item: item,
                            isRead: caseProgress.readEvidenceIds.contains(item.evidenceId),
                            isPinned: caseProgress.pinnedNodes.contains { $0.nodeId == item.evidenceId },
                            onPinToggle: {
                                HapticsManager.shared.evidencePin()
                                SoundManager.shared.playPin()
                                progressStore.togglePinNode(caseId: caseModel.caseId, nodeId: item.evidenceId, itemType: .evidence)
                            },
                            onSelect: {
                                HapticsManager.shared.lightTap()
                                progressStore.markEvidenceRead(caseId: caseModel.caseId, evidenceId: item.evidenceId)
                                selectedEvidence = item
                            }
                        )
                    }
                }
                .padding(16)
            }
        }
        .sheet(item: $selectedEvidence) { item in
            NavigationStack {
                EvidenceDetailView(item: item, caseModel: caseModel)
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var sfSymbol: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let sf = sfSymbol {
                    Image(systemName: sf)
                        .font(.system(size: 10))
                }
                Text(title)
                    .font(.system(size: 12, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .foregroundColor(isSelected ? .white : .primary)
            .background(
                Capsule()
                    .fill(isSelected ? ForensicTheme.forensicBlue : Color.secondary.opacity(0.12))
            )
        }
    }
}

struct EvidenceRowCard: View {
    let item: EvidenceItem
    let isRead: Bool
    let isPinned: Bool
    let onPinToggle: () -> Void
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            ForensicCard {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .top) {
                        Image(systemName: item.type.sfSymbol)
                            .font(.system(size: 18))
                            .foregroundColor(ForensicTheme.forensicBlue)
                            .frame(width: 32, height: 32)
                            .background(ForensicTheme.forensicBlue.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text(item.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                if !isRead {
                                    Circle()
                                        .fill(ForensicTheme.forensicBlue)
                                        .frame(width: 7, height: 7)
                                }
                            }

                            Text(item.source)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Button(action: onPinToggle) {
                            Image(systemName: isPinned ? "pin.fill" : "pin")
                                .font(.system(size: 14))
                                .foregroundColor(isPinned ? ForensicTheme.forensicGold : .secondary)
                                .padding(8)
                                .background(isPinned ? ForensicTheme.forensicGold.opacity(0.15) : Color.clear)
                                .clipShape(Circle())
                        }
                    }

                    Text(item.summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    HStack {
                        FrostedBadge(
                            title: item.reliability.displayName,
                            sfSymbol: "checkmark.shield",
                            color: Color(hex: item.reliability.colorHex)
                        )

                        if let timestamp = item.timestamp {
                            FrostedBadge(
                                title: timestamp,
                                sfSymbol: "clock",
                                color: .secondary
                            )
                        }

                        Spacer()

                        if item.isKeyEvidence {
                            FrostedBadge(
                                title: "KEY EVIDENCE",
                                sfSymbol: "star.fill",
                                color: ForensicTheme.forensicGold
                            )
                        }
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}
