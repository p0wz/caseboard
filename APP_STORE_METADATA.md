# App Store Readiness Metadata: Caseboard

## Application Identity
- **App Name**: Caseboard: Detective Game
- **Subtitle**: Offline mystery logic cases
- **Primary Category**: Games / Puzzle
- **Secondary Category**: Games / Word & Trivia
- **Target Platform**: iOS 17.0+, iPadOS 17.0+
- **Monetization Model**: Free to Play with One-Time Premium Unlock (No subscriptions, No ads, No consumables)

## ASO Search & Discovery
### Keywords
```
detective game offline,murder mystery,logic deduction,case files,crime investigation,mystery puzzle,no ads,forensic analyst,cold case
```

### Promotional Text
```
Experience authentic forensic deduction. Pin evidence, break alibis, spot contradictions, and submit final accusations. 100% offline-ready.
```

### Short Description
```
Solve premium offline detective cases by connecting evidence, breaking alibis, and exposing contradictions. No ads. No internet. No energy timers.
```

### Full Description
```
Step into the role of a forensic analyst deciphering cold cases from an elegant intelligence database. 

Caseboard: Offline Detective Files brings authentic investigative deduction to iOS with Apple-native craftsmanship, tactile CoreHaptics, and zero server dependencies.

FEATURES:
• TACTILE CASEBOARD: Pin clues, suspect dossiers, and forensic transcripts to an interactive 2D canvas. Draw thread connections to establish motive, physical means, opportunity, and broken alibis.
• LOCAL DEDUCTION ENGINE: Uncover multi-layered contradictions between witness claims and electronic sensor telemetry. Discovering discrepancies unlocks hidden evidence files and alters suspect suspicion profiles in real time.
• CHRONOLOGICAL RECONSTRUCTION: Reconstruct crime timelines, detect mutually exclusive events, and expose fabricated departures.
• FINAL ACCUSATION DOSSIERS: Submit your formal thesis to the District Analyst. Prove culpability across motive, means, opportunity, and definitive contradictions to earn prestigious S+ and S forensic grades.
• 16 COMPLETE BUNDLED CASES: From "The Locked Gallery" gallery curator mystery to "The Ash Ledger" corporate incinerator case, experience deep, handcrafted deduction puzzles.
• DETERMINISTIC DAILY COLD CASES: A new offline micro-case generated every single calendar day based on local device date. Build your analyst streak.
• ETHICAL HINTS: Request forensic nudges if you get stuck. Hints adjust your final score but never require in-app payments.
• PRIVACY GUARANTEE: Zero third-party SDKs, zero analytics trackers, zero accounts, and zero remote servers. Everything runs entirely on your device.
```

## In-App Purchase Configuration (StoreKit 2)
- **Product ID**: `caseboard_full_unlock`
- **Product Name**: Full Archive Unlock
- **Type**: Non-Consumable (One-Time Purchase)
- **Tier**: Tier 5 ($4.99 USD)
- **Family Sharing**: Enabled
- **Offline Entitlement**: Persisted locally via `ProgressStore` and verified through `Transaction.currentEntitlements`.
- **Local Testing**: Includes bundled `CaseboardStoreKit.storekit` for immediate Xcode simulation without internet.

## Privacy Nutrition Labels (App Store Connect)
- **Data Used to Track You**: None
- **Data Linked to You**: None
- **Data Not Linked to You**: None (Zero telemetry collected)
- **Data Collection Policy**: Fully offline local persistence (`ProgressStore`).
