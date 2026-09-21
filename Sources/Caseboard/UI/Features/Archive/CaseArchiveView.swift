import SwiftUI

public enum ArchiveFilter: String, CaseIterable, Identifiable {
    case all = "All Files"
    case newOnly = "Unopened"
    case inProgress = "In Progress"
    case solved = "Cleared"
    case locked = "Restricted"

    public var id: String { rawValue }
}

public enum ArchiveSort: String, CaseIterable, Identifiable {
    case recommended = "Recommended"
    case difficulty = "Difficulty"
    case completion = "Completion"

    public var id: String { rawValue }
}

public struct CaseArchiveView: View {
    public let onSelectCase: (CaseModel) -> Void
    @ObservedObject var progressStore = ProgressStore.shared
    @ObservedObject var premiumManager = PremiumManager.shared

    @State private var filter: ArchiveFilter = .all
    @State private var sort: ArchiveSort = .recommended
    @State private var showPaywall: Bool = false

    public init(onSelectCase: @escaping (CaseModel) -> Void) {
        self.onSelectCase = onSelectCase
    }

    private var allCases: [CaseModel] {
        CaseContentLoader.shared.loadAllBundledCases()
    }

    private var filteredCases: [CaseModel] {
        var cases = allCases.filter { c in
            let st = progressStore.progress(for: c.caseId).status
            let isLocked = c.isPremium && !progressStore.userProgress.isPremiumUnlocked

            switch filter {
            case .all: return true
            case .newOnly: return st == .newCase && !isLocked
            case .inProgress: return st == .inProgress
            case .solved: return st == .solved || st == .perfect
            case .locked: return isLocked
            }
        }

        switch sort {
        case .recommended:
            cases.sort { a, b in
                if a.caseId == "locked_gallery" { return true }
                if b.caseId == "locked_gallery" { return false }
                if a.isPremium != b.isPremium { return !a.isPremium }
                return a.caseId < b.caseId
            }
        case .difficulty:
            cases.sort { $0.difficulty.rawValue < $1.difficulty.rawValue }
        case .completion:
            cases.sort {
                let stA = progressStore.progress(for: $0.caseId).status
                let stB = progressStore.progress(for: $1.caseId).status
                return stA.rawValue > stB.rawValue
            }
        }

        return cases
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Filter Bar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(ArchiveFilter.allCases) { f in
                        FilterChip(title: f.rawValue, isSelected: filter == f) {
                            filter = f
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }

            // Case List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredCases) { caseModel in
                        let isLocked = caseModel.isPremium && !progressStore.userProgress.isPremiumUnlocked
                        let caseProgress = progressStore.progress(for: caseModel.caseId)

                        Button {
                            if isLocked {
                                showPaywall = true
                            } else {
                                onSelectCase(caseModel)
                            }
                        } label: {
                            ForensicCard {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        FrostedBadge(
                                            title: caseModel.difficulty.displayName,
                                            color: Color(hex: caseModel.difficulty.badgeColorHex)
                                        )

                                        Spacer()

                                        if isLocked {
                                            FrostedBadge(
                                                title: "RESTRICTED DOSSIER",
                                                sfSymbol: "lock.fill",
                                                color: .orange
                                            )
                                        } else if let grade = caseProgress.bestGrade {
                                            FrostedBadge(
                                                title: "GRADE \(grade.rawValue)",
                                                sfSymbol: "rosette",
                                                color: Color(hex: grade.colorHex)
                                            )
                                        } else {
                                            FrostedBadge(
                                                title: caseProgress.status.displayName,
                                                sfSymbol: caseProgress.status.sfSymbol,
                                                color: Color(hex: caseProgress.status.colorHex)
                                            )
                                        }
                                    }

                                    Text(caseModel.title)
                                        .font(.headline)
                                        .foregroundColor(.primary)

                                    Text(caseModel.subtitle)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)

                                    Divider()

                                    HStack {
                                        Label("\(caseModel.evidence.count) Clues", systemImage: "doc.text.magnifyingglass")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Label("\(caseModel.estimatedMinutes) Min", systemImage: "clock")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle("Intelligence Archive")
        .sheet(isPresented: $showPaywall) {
            PremiumPaywallView()
        }
    }
}
