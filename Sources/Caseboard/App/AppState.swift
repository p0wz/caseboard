import SwiftUI
import Combine

@MainActor
public final class AppState: ObservableObject {
    public static let shared = AppState()

    @Published public var activeAchievementToast: AchievementID?
    private var cancellables = Set<AnyCancellable>()

    public init() {
        ProgressStore.shared.$recentlyUnlockedAchievement
            .compactMap { $0 }
            .sink { [weak self] ach in
                self?.presentAchievementToast(ach)
            }
            .store(in: &cancellables)
    }

    public func presentAchievementToast(_ achievement: AchievementID) {
        withAnimation(.spring()) {
            self.activeAchievementToast = achievement
        }
        HapticsManager.shared.achievementUnlock()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { [weak self] in
            if self?.activeAchievementToast == achievement {
                withAnimation(.easeOut) {
                    self?.activeAchievementToast = nil
                }
            }
        }
    }
}
