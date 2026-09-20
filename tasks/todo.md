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
