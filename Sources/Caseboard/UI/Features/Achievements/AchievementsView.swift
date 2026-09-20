import SwiftUI

public struct AchievementsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var progressStore = ProgressStore.shared

    public init() {}

    private var unlockedCount: Int {
        progressStore.userProgress.unlockedAchievementIds.count
    }

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Deduction Accolades")
                                .font(.headline)
                            Spacer()
                            Text("\(unlockedCount) / \(AchievementID.allCases.count)")
                                .fontWeight(.bold)
                                .foregroundColor(ForensicTheme.forensicGold)
                        }

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.secondary.opacity(0.15))
                                    .frame(height: 8)
                                Capsule()
                                    .fill(ForensicTheme.forensicGold)
                                    .frame(width: max(8, geo.size.width * CGFloat(Double(unlockedCount) / Double(AchievementID.allCases.count))), height: 8)
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding(.vertical, 4)
                }

                ForEach(AchievementID.allCases, id: \.self) { ach in
                    let isUnlocked = progressStore.userProgress.unlockedAchievementIds.contains(ach.rawValue)
                    HStack(spacing: 14) {
                        Circle()
                            .fill((isUnlocked ? ForensicTheme.forensicGold : Color.secondary).opacity(0.18))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: ach.sfSymbol)
                                    .foregroundColor(isUnlocked ? ForensicTheme.forensicGold : .secondary)
                            )

                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text(ach.title)
                                    .font(.headline)
                                    .foregroundColor(isUnlocked ? .primary : .secondary)
                                Spacer()
                                FrostedBadge(title: ach.category, color: isUnlocked ? ForensicTheme.forensicGold : .secondary)
                            }
                            Text(ach.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Analyst Accolades")
            .forensicInlineTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

public struct AchievementToastView: View {
    public let achievement: AchievementID
    public let onDismiss: () -> Void

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: achievement.sfSymbol)
                .font(.system(size: 24))
                .foregroundColor(ForensicTheme.forensicGold)

            VStack(alignment: .leading, spacing: 2) {
                Text("ACCOLADE UNLOCKED")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(ForensicTheme.forensicGold)
                Text(achievement.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(red: 24/255, green: 28/255, blue: 34/255).opacity(0.95))
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(ForensicTheme.forensicGold.opacity(0.4), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 16)
        .onTapGesture {
            onDismiss()
        }
    }
}
