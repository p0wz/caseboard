import SwiftUI

public struct SplashScreenView: View {
    public let onFinished: () -> Void

    @State private var progress: Double = 0.0
    @State private var currentStepIndex: Int = 0
    @State private var logoScale: CGFloat = 0.82
    @State private var logoOpacity: Double = 0.0
    @State private var textOpacity: Double = 0.0
    @State private var glowPulse: Bool = false
    @State private var isDismissed: Bool = false

    private let bootSteps = [
        "INITIALIZING OFFLINE SYSTEM...",
        "DECRYPTING DISTRICT COLD CASES...",
        "CALIBRATING 365nm MULTISPECTRAL LOUPE...",
        "SYNCHRONIZING BIOMETRIC DOSSIERS...",
        "OFFLINE VAULT READY • WELCOME ANALYST"
    ]

    public init(onFinished: @escaping () -> Void) {
        self.onFinished = onFinished
    }

    public var body: some View {
        ZStack {
            // Cinematic Deep Noir Background
            Color(red: 10/255, green: 12/255, blue: 16/255)
                .ignoresSafeArea()

            // Dynamic Dual Neon Rim Glow
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(Color(red: 225/255, green: 29/255, blue: 72/255).opacity(glowPulse ? 0.35 : 0.20))
                        .frame(width: geo.size.width * 0.9)
                        .blur(radius: 60)
                        .offset(x: geo.size.width * 0.25, y: geo.size.height * 0.1)

                    Circle()
                        .fill(Color(red: 6/255, green: 182/255, blue: 212/255).opacity(glowPulse ? 0.28 : 0.15))
                        .frame(width: geo.size.width * 0.9)
                        .blur(radius: 60)
                        .offset(x: -geo.size.width * 0.25, y: -geo.size.height * 0.1)
                }
            }
            .ignoresSafeArea()

            // Subtle Background Forensic Grid
            ForensicGridPattern()
                .stroke(Color.white.opacity(0.04), lineWidth: 0.8)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                // Hero Detective App Emblem
                ZStack {
                    // Outer neon border ring
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(red: 6/255, green: 182/255, blue: 212/255),
                                    Color(red: 225/255, green: 29/255, blue: 72/255)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2.5
                        )
                        .frame(width: 172, height: 172)
                        .shadow(color: Color(red: 225/255, green: 29/255, blue: 72/255).opacity(0.4), radius: 16)

                    // Detective Image
                    if let image = ForensicAssetLoader.image(named: "app_logo") {
                        #if canImport(UIKit)
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 166, height: 166)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        #elseif canImport(AppKit)
                        Image(nsImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 166, height: 166)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        #endif
                    } else {
                        // High-tech fallback emblem
                        ZStack {
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(Color(red: 18/255, green: 22/255, blue: 30/255))
                                .frame(width: 166, height: 166)

                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 64, weight: .bold))
                                .foregroundColor(Color(red: 225/255, green: 29/255, blue: 72/255))
                        }
                    }
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                // Title Branding
                VStack(spacing: 6) {
                    Text("CASEBOARD")
                        .font(.system(size: 28, weight: .black, design: .monospaced))
                        .tracking(6)
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.8), radius: 4)

                    Text("OFFLINE DETECTIVE FILES")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .tracking(3)
                        .foregroundColor(Color(red: 6/255, green: 182/255, blue: 212/255))
                }
                .opacity(textOpacity)

                Spacer()

                // Progress Bar & Real-time Diagnostic Telemetry
                VStack(spacing: 12) {
                    // Terminal Diagnostic Status
                    HStack(spacing: 6) {
                        Image(systemName: "terminal.fill")
                            .font(.system(size: 9))
                            .foregroundColor(Color(red: 225/255, green: 29/255, blue: 72/255))

                        Text(bootSteps[min(currentStepIndex, bootSteps.count - 1)])
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundColor(.white.opacity(0.85))
                            .lineLimit(1)

                        Spacer()

                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 9, weight: .black, design: .monospaced))
                            .foregroundColor(Color(red: 6/255, green: 182/255, blue: 212/255))
                    }
                    .padding(.horizontal, 28)

                    // Cyber Bar
                    GeometryReader { barGeo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 5)

                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 6/255, green: 182/255, blue: 212/255),
                                            Color(red: 225/255, green: 29/255, blue: 72/255)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: max(8, barGeo.size.width * CGFloat(progress)), height: 5)
                                .shadow(color: Color(red: 225/255, green: 29/255, blue: 72/255).opacity(0.8), radius: 6)
                        }
                    }
                    .frame(height: 5)
                    .padding(.horizontal, 28)

                    // Skip Hint
                    Text("TAP ANYWHERE TO ENTER")
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                        .tracking(2)
                        .foregroundColor(.white.opacity(0.35))
                        .padding(.top, 8)
                }
                .padding(.bottom, 36)
                .opacity(textOpacity)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            dismissSplash()
        }
        .onAppear {
            runLaunchSequence()
        }
    }

    // MARK: - Animation Sequence

    private func runLaunchSequence() {
        withAnimation(.easeOut(duration: 0.7)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }

        withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
            glowPulse = true
        }

        withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
            textOpacity = 1.0
        }

        // Stepped diagnostic timer
        for (idx, _) in bootSteps.enumerated() {
            let delay = Double(idx) * 0.35 + 0.25
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                guard !isDismissed else { return }
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentStepIndex = idx
                    progress = Double(idx + 1) / Double(bootSteps.count)
                }
                HapticsManager.shared.lightTap()
                SoundManager.shared.playTap()
            }
        }

        // Auto dismiss after sequence
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            dismissSplash()
        }
    }

    private func dismissSplash() {
        guard !isDismissed else { return }
        isDismissed = true
        HapticsManager.shared.correctConnection()
        SoundManager.shared.playSwitch()
        withAnimation(.easeInOut(duration: 0.45)) {
            onFinished()
        }
    }
}
