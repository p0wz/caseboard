import SwiftUI

public struct OnboardingView: View {
    @ObservedObject var progressStore = ProgressStore.shared
    @State private var currentStep: Int = 0
    public let onComplete: () -> Void

    public init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }

    private let steps = [
        (
            title: "Caseboard: Offline Detective Files",
            subtitle: "Deduce the truth from an elegant forensic intelligence archive.",
            icon: "folder.fill.badge.person.crop",
            bullets: [
                "Unravel complex homicides, corporate sabotage, and cold cases.",
                "Zero backend. Zero accounts. Zero energy timers.",
                "100% offline, local-first intelligence files."
            ]
        ),
        (
            title: "How It Works: 4 Steps",
            subtitle: "Aha moments instead of multiple-choice trivia.",
            icon: "brain.head.profile",
            bullets: [
                "1. Read Evidence: Spot discrepancies in transcripts & telemetry.",
                "2. Pin Clues: Drag cards onto your interactive caseboard.",
                "3. Connect Contradictions: Link facts to break fabricated alibis.",
                "4. Submit Accusation: Establish motive, means, and opportunity."
            ]
        ),
        (
            title: "Offline Premium Promise",
            subtitle: "Pure logic deduction built for iOS with Apple-grade polish.",
            icon: "lock.shield.fill",
            bullets: [
                "No ads. No energy meters. No waiting.",
                "No personal data collection or analytics tracking.",
                "Full local persistence across app relaunch.",
                "One-time unlock for premier intelligence case files."
            ]
        )
    ]

    public var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(ForensicTheme.forensicBlue.opacity(0.15))
                    .frame(width: 90, height: 90)
                Image(systemName: steps[currentStep].icon)
                    .font(.system(size: 44))
                    .foregroundColor(ForensicTheme.forensicBlue)
            }

            // Title & Subtitle
            VStack(spacing: 8) {
                Text(steps[currentStep].title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(steps[currentStep].subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            // Bullets
            ForensicCard {
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(steps[currentStep].bullets, id: \.self) { bullet in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(ForensicTheme.forensicBlue)
                                .font(.system(size: 15))
                            Text(bullet)
                                .font(.subheadline)
                                .lineSpacing(3)
                        }
                    }
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            // Step Indicator Dots
            HStack(spacing: 8) {
                ForEach(0..<steps.count, id: \.self) { index in
                    Capsule()
                        .fill(currentStep == index ? ForensicTheme.forensicBlue : Color.secondary.opacity(0.3))
                        .frame(width: currentStep == index ? 24 : 8, height: 8)
                }
            }

            // Primary Action Button
            Button {
                HapticsManager.shared.lightTap()
                if currentStep < steps.count - 1 {
                    withAnimation { currentStep += 1 }
                } else {
                    progressStore.completeOnboarding()
                    onComplete()
                }
            } label: {
                Text(currentStep < steps.count - 1 ? "Next Step" : "Begin Tutorial: The Locked Gallery")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(ForensicTheme.forensicBlue))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }
}
