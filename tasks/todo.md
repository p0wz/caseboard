# Tasks: Caseboard Visual Overhaul

- [x] Task 1: Forensic Visual Foundations & Texture Engine
  - Create `ForensicVisualAssets.swift` with procedural paper grain, tape strips, pushpins, rubber stamps, and magnifying loupe modifier.
  - Verify build succeeds.
  - Files: `Sources/Caseboard/UI/Theme/ForensicVisualAssets.swift`

- [x] Task 2: Procedural Forensic Mini-Lab Tools
  - Implement `BiometricFingerprintView.swift` (animating laser sweep, minutiae locking).
  - Implement `BallisticComparatorView.swift` (split-screen microscope comparison slider).
  - Implement `AudioSpectrogramView.swift` (waveform scrubber for audio recordings).
  - Implement `RedactedDocumentView.swift` (classified dossiers with tap-to-reveal redactions).
  - Files: `Sources/Caseboard/UI/Features/ForensicLab/`

- [x] Task 3: Tactile Caseboard & Node Evolution
  - Upgrade `CaseboardCardNodeView.swift` to Polaroid photo / evidence card styling with tape, pushpin, barcode tags, and photo thumbnails.
  - Upgrade `CaseboardCanvasView.swift` with braided threads, metallic pins, pulse animations on contradiction discovery.
  - Files: `CaseboardCardNodeView.swift`, `CaseboardCanvasView.swift`

- [x] Task 4: Suspect Booking Dossier & Briefing Polish
  - Upgrade `SuspectDetailView.swift` with booking mugshot layout, height chart, and animated MMO ring gauges.
  - Upgrade `BriefingView.swift` with manila confidential folder style.
  - Add photorealistic bespoke portraits for Mara Voss, Theo Grant, Lin Park.
  - Files: `SuspectDetailView.swift`, `BriefingView.swift`

- [x] Task 5: Final Accusation & Resolution Polish
  - Add mechanical rubber stamp slam animation to `FinalReportView.swift`.
  - Add celebratory particle effects for S+ completion.
  - Files: `FinalReportView.swift`

- [x] Task 6: Headless Simulator & Automated Test Suite Verification
  - Run `xcodebuild test` on iPhone 17 Pro (18/18 tests passed in 0.083s).
  - Verified macro evidence photography (chemical solvent flask, sealed vault door) with 2.5x Loupe inspection.
  - Capture simulator screenshots of new visual caseboard and forensic lab tools.

## Phase 2: Revolutionary Expansion & App Store Preflight

- [x] Task 7: Interactive Interrogation & Cross-Examination System
  - Define `InterrogationDialogue`, questions, answers, and confrontation pair models in `Suspect.swift`.
  - Implement `InterrogationEngine.swift` (evaluating stress levels, dialogue state, and contradiction triggers).
  - Build `InterrogationRoomView.swift` (ambient interrogation room UI, suspect reactions, "Confront with Evidence" sheet).
  - Verify build succeeds.

- [x] Task 8: Dedicated Forensic Lab Workbench in Workspace
  - Create `ForensicLabWorkbenchView.swift` unifying Biometric, Ballistics, Spectrogram, and Declassifier tools with case progress unlock signals.
  - Add "Forensic Lab" as a dedicated segment in `CaseWorkspaceView.swift`.
  - Verify build succeeds.

- [x] Task 9: Case Content & Dialogue Tree Expansion
  - Update `locked_gallery.json` and `room_312.json` with comprehensive interrogation dialogues and evidence confrontation triggers.
  - Verify case content loader and validity tests pass.

- [x] Task 10: App Store Preflight Compliance (`app-store-preflight-skills`)
  - Create `Sources/Caseboard/Resources/PrivacyInfo.xcprivacy` with Apple-required privacy declaration (Zero tracking, Zero collected data, UserDefaults reason CA92.1).
  - Add in-app Terms of Service (EULA) and Privacy Policy modals in `PremiumPaywallView.swift` and `SettingsView.swift`.
  - Create `APP_STORE_PREFLIGHT.md` documenting 6-part Review Notes, Guideline 2.1, 2.3, 3.1.2, 4.2, 5.1 compliance.
  - Re-generate `Caseboard.xcodeproj` with new files.

- [x] Task 11: Multi-Axis Code Review (`/review`) & Automated Test Suite
  - Write unit tests in `Tests/CaseboardTests/InterrogationTests.swift`.
  - Perform 5-axis code review (Correctness, Readability, Architecture, Security, Performance).
  - Run headless `xcodebuild test` on iPhone 17 Pro Simulator and `swift test` on macOS (23/23 passed).

## Phase 3: Massive Asset & Sensory Leap Forward

- [x] Task 12: High-Resolution Character Mugshot & Crime Scene Asset Suite
  - Generate & add portraits for Andre Dupuis, Victor Reyes, Maria Santos (Room 312).
  - Generate & add crime scene & evidence photos for Room 312 (Hotel suite 312, service elevator panel).
  - Generate & add portraits for Elena Ward, David Cross, Julian Blackwood (Rain at Mercer Street).
  - Copy to `Sources/Caseboard/Resources/Assets/`.

- [x] Task 13: Multispectral Forensic Evidence Inspection Engine
  - Upgrade `ForensicVisualAssets.swift` with `MultispectralFilter` (.visible, .ultraviolet365nm, .infraredNegative).
  - Update `EvidenceDetailView.swift` to add spectral filter selection and real-time shader effects on Loupe magnification.

- [x] Task 14: Tactile Analog Audio Engine
  - Build `AnalogAudioEngine.swift` using native `AVAudioEngine` for tape clicks, camera shutter, paper rustle, and typewriter mechanical clicks.
  - Integrate with `SoundManager.swift`.

- [x] Task 15: Project Regeneration, Test Suite & Verification
  - Update `tools/generate_xcodeproj.py` and regenerate `Caseboard.xcodeproj`.
  - Run `swift test` and `xcodebuild test` (23/23 tests passed in 0.155s).
  - Capture simulator screenshots and update `walkthrough.md`.


