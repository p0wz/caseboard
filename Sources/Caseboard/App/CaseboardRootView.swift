import SwiftUI

public struct CaseboardRootView: View {
    @ObservedObject var appState = AppState.shared
    @ObservedObject var progressStore = ProgressStore.shared

    @AppStorage("preview_screenshot_id") private var previewScreenshotId: Int = 0
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
            if previewScreenshotId > 0 {
                AppStoreScreenshotHarnessView()
            } else if !progressStore.userProgress.onboardingCompleted {
                OnboardingView {
                    withAnimation {
                        progressStore.completeOnboarding()
                    }
                }
            } else {
                DashboardView()
            }

            // Cinematic Launch Splash Screen (only when not in screenshot preview mode)
            if isShowingSplash && previewScreenshotId == 0 {
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

// MARK: - AppStore Screenshot Harness
public struct AppStoreScreenshotHarnessView: View {
    @AppStorage("preview_screenshot_id") private var modeId: Int = 0
    @ObservedObject var progressStore = ProgressStore.shared

    public init() {}

    private var bundledCases: [CaseModel] {
        CaseContentLoader.shared.loadAllBundledCases()
    }

    private var primaryCase: CaseModel {
        bundledCases.first { $0.caseId == "locked_gallery" } ?? bundledCases.first!
    }

    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            switch modeId {
            case 1:
                NavigationStack {
                    CaseboardCanvasView(caseModel: primaryCase)
                        .navigationTitle("CRIME SCENE CASEBOARD")
                        .forensicInlineTitle()
                }

            case 2:
                let suspect = primaryCase.suspects.first { $0.id == "suspect_mara" } ?? primaryCase.suspects.first!
                NavigationStack {
                    InterrogationRoomView(suspect: suspect, caseModel: primaryCase)
                }

            case 3:
                let evidence = primaryCase.evidence.first { $0.id == "restoration_solvent_inventory" || $0.id == "coroner_report_vorn" } ?? primaryCase.evidence.first!
                NavigationStack {
                    EvidenceDetailView(item: evidence, caseModel: primaryCase)
                        .navigationTitle("SPECTRAL EXAMINATION")
                        .forensicInlineTitle()
                }

            case 4:
                NavigationStack {
                    CaseArchiveView(onSelectCase: { _ in })
                }

            case 5:
                NavigationStack {
                    FinalReportView(caseModel: primaryCase)
                        .navigationTitle("JUDICIAL ACCUSATION")
                        .forensicInlineTitle()
                }

            case 6:
                SplashScreenView(onFinished: {})

            default:
                EmptyView()
            }
        }
        .onAppear {
            seedHarnessData()
        }
    }

    private func seedHarnessData() {
        PremiumManager.shared.debugSetPremium(true)

        var cp = progressStore.progress(for: primaryCase.caseId)
        cp.status = .inProgress
        cp.bestGrade = .sPlus

        cp.pinnedNodes = [
            CaseboardNode(
                nodeId: "coroner_report_vorn",
                itemType: .evidence,
                x: 40,
                y: 130
            ),
            CaseboardNode(
                nodeId: "weather_log_811",
                itemType: .evidence,
                x: 230,
                y: 150
            ),
            CaseboardNode(
                nodeId: "suspect_mara",
                itemType: .suspect,
                x: 60,
                y: 380
            ),
            CaseboardNode(
                nodeId: "door_sensor_824",
                itemType: .evidence,
                x: 230,
                y: 410
            )
        ]

        cp.connections = [
            CaseboardConnection(
                connectionId: "conn_1",
                sourceId: "coroner_report_vorn",
                targetId: "suspect_mara",
                connectionType: .establishesMeans,
                evaluation: .critical
            ),
            CaseboardConnection(
                connectionId: "conn_2",
                sourceId: "weather_log_811",
                targetId: "door_sensor_824",
                connectionType: .contradicts,
                evaluation: .critical
            ),
            CaseboardConnection(
                connectionId: "conn_3",
                sourceId: "suspect_mara",
                targetId: "door_sensor_824",
                connectionType: .weakensAlibi,
                evaluation: .correct
            )
        ]

        cp.discoveredContradictions = [
            "contradiction_mara_alibi_rain",
            "contradiction_mara_solvents"
        ]

        progressStore.debugSetCaseProgress(caseId: primaryCase.caseId, progress: cp)
        progressStore.debugAddScore(4850)
    }
}
