import SwiftUI

public struct DashboardView: View {
    @ObservedObject var progressStore = ProgressStore.shared
    @ObservedObject var premiumManager = PremiumManager.shared

    @State private var selectedCase: CaseModel?
    @State private var showArchive: Bool = false
    @State private var showSettings: Bool = false
    @State private var showPaywall: Bool = false
    @State private var showAchievements: Bool = false
    @State private var showDebugTools: Bool = false

    public init() {}

    private var allCases: [CaseModel] {
        CaseContentLoader.shared.loadAllBundledCases()
    }

    private var activeCase: CaseModel? {
        // Find most recently touched in-progress case, or default to tutorial
        for c in allCases {
            let st = progressStore.progress(for: c.caseId).status
            if st == .inProgress {
                return c
            }
        }
        return allCases.first { $0.caseId == "locked_gallery" } ?? allCases.first
    }

    private var todayDailyCase: CaseModel {
        DailyCaseGenerator().generateDailyCase(for: Date())
    }

    private var solvedCount: Int {
        progressStore.userProgress.caseProgress.values.filter { $0.status == .solved || $0.status == .perfect }.count
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Bar with Rank & Score
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("DISTRICT INTELLIGENCE ARCHIVE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                            Text(progressStore.userProgress.analystRank.displayName)
                                .font(.title2)
                                .fontWeight(.bold)
                        }

                        Spacer()

                        FrostedBadge(
                            title: "\(progressStore.userProgress.totalScore) PTS",
                            sfSymbol: "rosette",
                            color: ForensicTheme.forensicGold
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    // Hero: Continue Active Investigation Card
                    if let current = activeCase {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("ACTIVE INVESTIGATION", systemImage: "bolt.fill")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(ForensicTheme.forensicBlue)
                                .padding(.horizontal, 16)

                            Button {
                                HapticsManager.shared.lightTap()
                                selectedCase = current
                            } label: {
                                ForensicCard {
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            FrostedBadge(
                                                title: current.difficulty.displayName,
                                                color: Color(hex: current.difficulty.badgeColorHex)
                                            )
                                            Spacer()
                                            FrostedBadge(
                                                title: progressStore.progress(for: current.caseId).status.displayName,
                                                sfSymbol: progressStore.progress(for: current.caseId).status.sfSymbol,
                                                color: Color(hex: progressStore.progress(for: current.caseId).status.colorHex)
                                            )
                                        }

                                        Text(current.title)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary)

                                        Text(current.subtitle)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(2)

                                        Divider()

                                        HStack {
                                            Label("\(current.estimatedMinutes) min solve", systemImage: "clock")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Spacer()
                                            HStack(spacing: 4) {
                                                Text("Open Workspace")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                Image(systemName: "arrow.right.circle.fill")
                                            }
                                            .foregroundColor(ForensicTheme.forensicBlue)
                                        }
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 16)
                        }
                    }

                    // Daily Cold Case Card
                    VStack(alignment: .leading, spacing: 8) {
                        Label("DAILY COLD CASE", systemImage: "calendar.badge.clock")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.purple)
                            .padding(.horizontal, 16)

                        Button {
                            HapticsManager.shared.lightTap()
                            selectedCase = todayDailyCase
                        } label: {
                            ForensicCard {
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.purple.opacity(0.18))
                                            .frame(width: 52, height: 52)
                                        Image(systemName: "calendar")
                                            .font(.system(size: 24))
                                            .foregroundColor(.purple)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(todayDailyCase.title)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            Spacer()
                                            if progressStore.userProgress.dailyStreak > 0 {
                                                FrostedBadge(
                                                    title: "\(progressStore.userProgress.dailyStreak) DAY STREAK",
                                                    sfSymbol: "flame.fill",
                                                    color: .orange
                                                )
                                            }
                                        }

                                        Text(todayDailyCase.briefing.summary)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .lineLimit(2)
                                    }
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 16)
                    }

                    // Archive Quick Progress Card
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Label("CASE ARCHIVE PROGRESS", systemImage: "archivebox.fill")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.secondary)
                            Spacer()
                            Button("View All") {
                                showArchive = true
                            }
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(ForensicTheme.forensicBlue)
                        }
                        .padding(.horizontal, 16)

                        ForensicCard {
                            VStack(spacing: 12) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("\(solvedCount) of \(allCases.count) Cleared")
                                            .font(.headline)
                                        Text("Comprehensive forensic database")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text("\(allCases.isEmpty ? 0 : Int((Double(solvedCount) / Double(allCases.count)) * 100))%")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(ForensicTheme.forensicBlue)
                                }

                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(Color.secondary.opacity(0.15))
                                            .frame(height: 8)
                                        Capsule()
                                            .fill(ForensicTheme.forensicBlue)
                                            .frame(
                                                width: allCases.isEmpty ? 0 : max(8, geo.size.width * CGFloat(Double(solvedCount) / Double(allCases.count))),
                                                height: 8
                                            )
                                    }
                                }
                                .frame(height: 8)
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    // Premium Unlock Banner (if free)
                    if !progressStore.userProgress.isPremiumUnlocked {
                        VStack(alignment: .leading, spacing: 8) {
                            Button {
                                showPaywall = true
                            } label: {
                                ForensicCard {
                                    HStack(spacing: 14) {
                                        Image(systemName: "crown.fill")
                                            .font(.system(size: 26))
                                            .foregroundColor(ForensicTheme.forensicGold)

                                        VStack(alignment: .leading, spacing: 3) {
                                            Text("Unlock 12 Premier Case Files")
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            Text("One-time unlock. Zero ads, zero subscriptions.")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 16)
                        }
                    }

                    // Quick Utilities (Achievements & Settings)
                    HStack(spacing: 12) {
                        Button {
                            showAchievements = true
                        } label: {
                            ForensicCard {
                                HStack {
                                    Image(systemName: "trophy.fill")
                                        .foregroundColor(ForensicTheme.forensicGold)
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text("Achievements")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        Text("\(progressStore.userProgress.unlockedAchievementIds.count) / 13")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .buttonStyle(.plain)

                        Button {
                            showSettings = true
                        } label: {
                            ForensicCard {
                                HStack {
                                    Image(systemName: "gearshape.fill")
                                        .foregroundColor(ForensicTheme.forensicBlue)
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text("Settings")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        Text("Preferences")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 24)
            }
            .navigationTitle("Caseboard")
            .forensicInlineTitle()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    #if DEBUG
                    Button {
                        showDebugTools = true
                    } label: {
                        Image(systemName: "ladybug.fill")
                            .foregroundColor(.orange)
                    }
                    .accessibilityLabel("Developer Diagnostics")
                    #endif
                }
            }
            .navigationDestination(isPresented: $showArchive) {
                CaseArchiveView(onSelectCase: { caseModel in
                    showArchive = false
                    selectedCase = caseModel
                })
            }
            .navigationDestination(item: $selectedCase) { c in
                CaseWorkspaceView(caseModel: c)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showPaywall) {
                PremiumPaywallView()
            }
            .sheet(isPresented: $showAchievements) {
                AchievementsView()
            }
            .sheet(isPresented: $showDebugTools) {
                DebugDashboardView()
            }
        }
    }
}
