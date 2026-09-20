import SwiftUI

public struct CaseboardRootView: View {
    @ObservedObject var appState = AppState.shared
    @ObservedObject var progressStore = ProgressStore.shared

    @State private var isShowingSplash: Bool = true

    public init() {}

    private var colorSchemeOverride: ColorScheme? {
        switch progressStore.userProgress.settings.appearanceMode {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }

    public var body: some View {
        ZStack(alignment: .top) {
            if !progressStore.userProgress.onboardingCompleted {
                OnboardingView {
                    withAnimation {
                        progressStore.completeOnboarding()
                    }
                }
            } else {
                DashboardView()
            }

            // Cinematic Launch Splash Screen
            if isShowingSplash {
                SplashScreenView {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isShowingSplash = false
                    }
                }
                .transition(.opacity)
                .zIndex(200)
            }

            // Achievement Toast HUD
            if let toast = appState.activeAchievementToast {
                AchievementToastView(achievement: toast) {
                    withAnimation {
                        appState.activeAchievementToast = nil
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(100)
                .padding(.top, 10)
            }
        }
        .preferredColorScheme(colorSchemeOverride)
    }
}
