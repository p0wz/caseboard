import SwiftUI

public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var progressStore = ProgressStore.shared
    @ObservedObject var premiumManager = PremiumManager.shared

    @State private var hapticsEnabled: Bool = true
    @State private var soundEnabled: Bool = true
    @State private var reducedMotion: Bool = false
    @State private var appearanceMode: AppearanceMode = .system
    @State private var showResetConfirmation: Bool = false
    @State private var showPaywall: Bool = false

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                // Premium Status
                Section("Intelligence Clearance") {
                    HStack {
                        Image(systemName: progressStore.userProgress.isPremiumUnlocked ? "crown.fill" : "lock.shield.fill")
                            .foregroundColor(progressStore.userProgress.isPremiumUnlocked ? ForensicTheme.forensicGold : .secondary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(progressStore.userProgress.isPremiumUnlocked ? "Full Archive Access" : "Standard Analyst Tier")
                                .font(.headline)
                            Text(progressStore.userProgress.isPremiumUnlocked ? "All 16 cases & unlimited archive unlocked" : "Tutorial + 3 Free Cases + Daily Cold Case")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    if !progressStore.userProgress.isPremiumUnlocked {
                        Button {
                            showPaywall = true
                        } label: {
                            Text("Upgrade to Full Archive...")
                                .fontWeight(.semibold)
                                .foregroundColor(ForensicTheme.forensicBlue)
                        }
                    }

                    Button("Restore Purchases") {
                        Task {
                            await premiumManager.restorePurchases()
                        }
                    }
                    .font(.subheadline)
                }

                // Sensory & Accessibility
                Section("Sensory & Ergonomics") {
                    Toggle("Haptic Feedback", isOn: $hapticsEnabled)
                        .onChange(of: hapticsEnabled) { _, val in
                            HapticsManager.shared.isEnabled = val
                            saveSettings()
                        }

                    Toggle("Tactile Audio Cues", isOn: $soundEnabled)
                        .onChange(of: soundEnabled) { _, val in
                            SoundManager.shared.isEnabled = val
                            saveSettings()
                        }

                    Toggle("Reduced Motion", isOn: $reducedMotion)
                        .onChange(of: reducedMotion) { _, _ in
                            saveSettings()
                        }

                    Picker("Interface Appearance", selection: $appearanceMode) {
                        Text("System Follow").tag(AppearanceMode.system)
                        Text("Forensic Clean (Light)").tag(AppearanceMode.light)
                        Text("Intelligence Dark (Graphite)").tag(AppearanceMode.dark)
                    }
                    .onChange(of: appearanceMode) { _, _ in
                        saveSettings()
                    }
                }

                // Privacy Guarantee
                Section("Offline Privacy Guarantee") {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Zero Tracking & Telemetry", systemImage: "hand.raised.fill")
                            .font(.headline)
                            .foregroundColor(ForensicTheme.verifiedGreen)
                        Text("Caseboard operates 100% offline. No telemetry SDKs, no ads, no web servers, and zero accounts. All notes and deduction graphs are persisted strictly on this hardware.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineSpacing(3)
                    }
                    .padding(.vertical, 4)
                }

                // Danger Zone
                Section("Data Reset") {
                    Button(role: .destructive) {
                        showResetConfirmation = true
                    } label: {
                        Text("Reset All Case Progress & Records")
                    }
                }

                // About & Version
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("2.0.0 (Build 2026.1)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Engine")
                        Spacer()
                        Text("Swift 6 Native Deduction Graph")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Preferences")
            .forensicInlineTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                let s = progressStore.userProgress.settings
                hapticsEnabled = s.hapticsEnabled
                soundEnabled = s.soundEnabled
                reducedMotion = s.reducedMotion
                appearanceMode = s.appearanceMode
            }
            .alert("Confirm Progress Reset", isPresented: $showResetConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Reset Everything", role: .destructive) {
                    progressStore.debugResetAll()
                    dismiss()
                }
            } message: {
                Text("This will permanently clear all discovered evidence, connections, timeline attempts, and final grades.")
            }
            .sheet(isPresented: $showPaywall) {
                PremiumPaywallView()
            }
        }
    }

    private func saveSettings() {
        progressStore.updateSettings(SettingsModel(
            hapticsEnabled: hapticsEnabled,
            soundEnabled: soundEnabled,
            reducedMotion: reducedMotion,
            appearanceMode: appearanceMode
        ))
    }
}
