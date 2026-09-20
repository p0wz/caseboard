# SPEC.md: Caseboard: Offline Detective Files

## 1. Vision & Identity
**Caseboard: Offline Detective Files** is a premium, offline-first detective deduction game for iOS 17+.
- Aesthetic: Modern Apple-native forensic intelligence database. Frosted glass, white/graphite palette, SF Symbols, smooth SwiftUI motion, CoreHaptics.
- Privacy & Offline: Zero backend, zero account, zero server cost, zero ads, zero energy mechanics, zero tracking. 100% offline-first.
- Tech Stack: Swift 6, SwiftUI, Combine/Observation, Codable persistence, StoreKit 2, CoreHaptics, AVFoundation sound cues.

## 2. Architecture & Modules
- `Core/Models`: Codable data models (`Case`, `Evidence`, `Suspect`, `Contradiction`, `TimelineEvent`, `CaseboardNode`, `CaseboardConnection`, `FinalReport`, `Progress`, `Achievement`).
- `Core/Engine`:
  - `DeductionEngine`: Validates 2 & 3 item connections, order-insensitive, detects partial matches, unlocks dependent evidence.
  - `TimelineEngine`: Validates relative and exact constraints, flags chronological impossibilities.
  - `FinalReportEngine`: Evaluates culprit, motive, means, opportunity, key contradiction, timeline proof; assigns S+, S, A, B, C grades with actionable non-spoiler analytical feedback.
  - `DailyCaseGenerator`: Deterministic local date-seeded micro-case generator.
  - `CaseValidator`: Bundled content integrity verifier.
- `Core/Persistence`: `ProgressStore` (resilient local JSON persistence, auto-save).
- `Core/Haptics`: `HapticsManager` (CoreHaptics with UIImpactFeedbackGenerator fallback).
- `Core/Audio`: `SoundManager` (tactile local sound synthesis).
- `Core/Store`: `PremiumManager` (StoreKit 2 `Product.products(for:)`, entitlements, restore).
- `Core/Content`: `CaseContentLoader` (bundled JSON loader and cache).
- `UI/Theme`: `ForensicTheme` (Apple-grade light/dark palettes, frosted glass surfaces, hairline strokes).
- `Features`:
  - `Onboarding`: Welcome, mechanics overview, offline privacy promise, direct tutorial launch.
  - `Dashboard`: Hero active case, Daily Cold Case card, archive progress, analyst rank, streak.
  - `CaseArchive`: Categorized cases (Tutorial, Free, Premium, Daily, Solved) with status badges and filters.
  - `CaseWorkspace`: Sleek segmented interface for Briefing, Evidence, Timeline, Caseboard canvas, Suspects, Final Report.
  - `CaseboardCanvas`: Interactive 2D drag board, connection threads (quadratic Bezier curves), connection classification, auto-arrange.
  - `TimelineReconstruction`: Vertical chronological board with reordering, conflict detection modal.
  - `SuspectDossier`: Motive, Means, Opportunity dynamic meters, alibi status tracker.
  - `FinalReport`: Accusation dossier submission, analytical feedback, animated case resolution with S+/S/A/B/C grades.
  - `Settings`: Sound, haptics, appearance, restore purchases, reset progress, privacy statement.
  - `PremiumPaywall`: StoreKit 2 purchase sheet with feature comparison.
  - `Achievements`: Local achievement system with haptic toast banners.
  - `DebugDashboard`: DEBUG-only inspector and cheat tools.

## 3. Bundled Cases
- 1 Tutorial: *The Locked Gallery* (playable end-to-end with Elias Vorn, Mara Voss, Theo Grant, Lin Park).
- 3 Free Cases: *Rain at Mercer Street*, *The Vanishing Courier*, *Room 312*.
- 12 Premium Cases: *The Silent Auction*, *Cold Signal*, *The Ninth Witness*, *Glass House*, *The Missing Minute*, *The Harbor Alibi*, *Dead Drop*, *The Last Reservation*, *The Blue Umbrella*, *Static on Line Seven*, *The Founder’s Exit*, *The Ash Ledger*.
- Local deterministic daily cold cases.
