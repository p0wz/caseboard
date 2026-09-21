# Implementation Tasks: Caseboard

## Task 1: Package Manifest, Data Models & Architecture Contracts
- [x] Create `Package.swift` with macOS/iOS targets, Swift 6 tools-version.
- [x] Create Core/Models:
  - `Case.swift`: CaseModel, Briefing, Solution, Difficulty
  - `Evidence.swift`: EvidenceItem, EvidenceType, Reliability, Exif/Metadata
  - `Suspect.swift`: Suspect, AlibiStatus, SuspicionLevel, Motive/Means/Opportunity
  - `Contradiction.swift`: Contradiction, ContradictionType, Severity
  - `TimelineEvent.swift`: TimelineEvent, RelativeConstraint
  - `CaseboardNode.swift`: CaseboardNode, CaseboardConnection, ConnectionType, ConnectionEvaluation
  - `FinalReport.swift`: AccusationSubmission, AccusationResult, AnalystGrade, ScoreBreakdown
  - `Progress.swift`: UserProgress, CaseProgress, DailyStreak, AnalystRank, SettingsModel
  - `Achievement.swift`: Achievement, AchievementID

## Task 2: Core Deduction & Game Engines
- [x] `DeductionEngine.swift`:
  - 2-item and 3-item order-insensitive contradiction validation
  - Partial match identification
  - Dependent evidence unlock trigger
  - Penalty and discovery tracking
- [x] `TimelineEngine.swift`:
  - Ordered timeline verification against strict and relative constraints
  - Impossible claim conflict detection
- [x] `FinalReportEngine.swift`:
  - Culprit evaluation
  - Motive, Means, Opportunity evidence validation
  - Key contradiction verification
  - Timeline proof verification
  - Non-spoiler analytical feedback generation
  - Analyst grade computation (S+, S, A, B, C)
- [x] `DailyCaseGenerator.swift`:
  - Deterministic calendar-date seeded PRNG
  - Micro-case template combination (Setting, Suspects, Evidence, Contradictions, Solution)
- [x] `CaseValidator.swift`:
  - Bundled case integrity validation (no dangling IDs, solvable graph, valid flags)

## Task 3: Unit Test Suite for Engines (TDD Verification)
- [x] `DeductionEngineTests.swift`
- [x] `TimelineEngineTests.swift`
- [x] `FinalReportEngineTests.swift`
- [x] `DailyCaseGeneratorTests.swift`
- [x] `CaseValidatorTests.swift`
- [x] Verify test suite passes with `swift test`

## Task 4: Complete Bundled Case Database (16 Cases + Daily Templates)
- [x] Tutorial Case: `locked_gallery.json` (Playable end-to-end: Elias Vorn, Mara Voss, Theo Grant, Lin Park, rain alibi, service door, chemicals)
- [x] Free Case 1: `rain_at_mercer_street.json`
- [x] Free Case 2: `the_vanishing_courier.json`
- [x] Free Case 3: `room_312.json`
- [x] 12 Premium Cases:
  - `the_silent_auction.json`
  - `cold_signal.json`
  - `the_ninth_witness.json`
  - `glass_house.json`
  - `the_missing_minute.json`
  - `the_harbor_alibi.json`
  - `dead_drop.json`
  - `the_last_reservation.json`
  - `the_blue_umbrella.json`
  - `static_on_line_seven.json`
  - `the_founders_exit.json`
  - `the_ash_ledger.json`
- [x] Daily Case Templates & Deterministic Engine
- [x] Automated integrity validation passing across all 16 JSONs.

## Task 5: Core Services & Infrastructure
- [x] `CaseContentLoader.swift`: Bundled JSON loader with fallback diagnostics
- [x] `ProgressStore.swift`: Codable local persistence with crash-resilient write
- [x] `HapticsManager.swift`: CoreHaptics engine + UIImpactFeedback fallback
- [x] `SoundManager.swift`: Tactile local sound cues (card movement, pin, discovery chime, case solved)
- [x] `PremiumManager.swift`: StoreKit 2 `Product.products(for:)`, transaction listener, restore purchases, DEBUG override

## Task 6: Forensic Theme & Reusable UI Design Tokens
- [x] `ForensicTheme.swift`: Color palette (graphite, forensic blue, critical evidence red, insight gold, frosted glass materials)
- [x] Forensic UI Components:
  - `ForensicCard`, `FrostedBadge`, `MetricPill`, `ForensicDivider`, `StatusPill`, `ConnectionLineShape`
  - Smooth SwiftUI micro-animations and typography hierarchy

## Task 7: Case Workspace Features
- [x] `CaseWorkspaceView.swift`: Sleek tabbed workspace (Briefing, Evidence, Timeline, Caseboard, Suspects, Final Report)
- [x] `BriefingView.swift`: Official case incident file, victim, objective, initial suspects
- [x] `EvidenceListView.swift` & `EvidenceDetailView.swift`: Evidence cards, metadata/EXIF drawer, reliability, pin action, player notes
- [x] `CaseboardCanvasView.swift`: Interactive 2D drag canvas, Bezier thread connections, connection type selector, auto-arrange, reset layout
- [x] `TimelineReconstructionView.swift`: Vertical drag-and-drop timeline, conflict detection modal, snap feedback
- [x] `SuspectsListView.swift` & `SuspectDetailView.swift`: Suspect dossiers, dynamic Motive/Means/Opportunity circular & bar meters, alibi status tracker
- [x] `FinalReportView.swift`: Accusation submission dossier (culprit, motive, means, opportunity, contradiction, timeline proof)
- [x] `CaseResolutionView.swift`: S+/S/A/B/C animated resolution sheet, grade badge, metrics breakdown, case unlock

## Task 8: Navigation, Shell & Auxiliary Views
- [x] `OnboardingView.swift`: Welcome, mechanics, offline promise, jump into tutorial
- [x] `DashboardView.swift`: Featured case hero, Continue card, Daily Cold Case card, Archive progress, Analyst Rank, Streak
- [x] `CaseArchiveView.swift`: Categorized list (Tutorial, Free, Premium, Daily, Solved), filters, search/sort
- [x] `SettingsView.swift`: Haptics toggle, sound toggle, appearance mode, restore purchases, reset progress, privacy declaration
- [x] `PremiumPaywallView.swift`: Sleek StoreKit 2 purchase sheet with feature comparisons
- [x] `AchievementsView.swift` & `AchievementToastView.swift`: Achievement library and haptic discovery toast
- [x] `DebugDashboardView.swift`: DEBUG tools (unlock premium, reset, mark solved, validate content, view solution)
- [x] `CaseboardApp.swift` & `AppState.swift`: Root view wiring, environment injection, lifecycle handling

## Task 9: Build, Test, and App Store Readiness
- [x] Run full test suite (`swift test`) and verify all tests green
- [x] Compile library & executable (`swift build`)
- [x] App Store metadata file (`APP_STORE_METADATA.md`) with ASO keywords, description, entitlements, privacy policy copy
- [x] StoreKit 2 configuration (`CaseboardStoreKit.storekit`)
