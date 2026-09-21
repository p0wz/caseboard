import SwiftUI

public struct DebugDashboardView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var progressStore = ProgressStore.shared
    @ObservedObject var premiumManager = PremiumManager.shared

    @State private var validationIssues: [ValidationIssue] = []
    @State private var hasRunValidation: Bool = false

    public init() {}

    private let validator = CaseValidator()

    public var body: some View {
        NavigationStack {
            List {
                Section("Entitlements & State") {
                    Toggle("Force Premium Unlocked", isOn: Binding(
                        get: { progressStore.userProgress.isPremiumUnlocked },
                        set: { premiumManager.debugSetPremium($0) }
                    ))

                    Button("Reset All Progress Data") {
                        progressStore.debugResetAll()
                    }
                    .foregroundColor(.red)
                }

                Section("Content Integrity Diagnostic") {
                    Button("Run Case Validator on All Bundled Cases") {
                        runValidation()
                    }

                    if hasRunValidation {
                        if validationIssues.isEmpty {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(ForensicTheme.verifiedGreen)
                                Text("All 16 Bundled Cases Valid & Solvable (0 Errors)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                        } else {
                            ForEach(validationIssues) { issue in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("[\(issue.severity.rawValue)] \(issue.caseId)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(issue.severity == .error ? .red : .orange)
                                    Text(issue.message)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }

                Section("Quick Solves & Accolades") {
                    Button("Unlock All Accolades") {
                        for ach in AchievementID.allCases {
                            progressStore.unlockAchievement(ach)
                        }
                    }

                    Button("Grant 10,000 Forensic Points") {
                        progressStore.debugAddScore(10000)
                    }
                }
            }
            .navigationTitle("Developer Diagnostics")
            .forensicInlineTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func runValidation() {
        let cases = CaseContentLoader.shared.loadAllBundledCases()
        var issues: [ValidationIssue] = []
        for c in cases {
            issues.append(contentsOf: validator.validate(caseModel: c))
        }
        self.validationIssues = issues
        self.hasRunValidation = true
    }
}
