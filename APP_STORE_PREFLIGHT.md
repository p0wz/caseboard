# Caseboard: Criminal Deduction — App Store Preflight Audit & Review Documentation
**Target Version:** 2.0.0 (Build 2026.1)  
**Target OS:** iOS 17.0+ / iPadOS 17.0+ / macOS 14.0+  
**Bundle Identifier:** `com.caseboard.detective`  
**Compliance Standard:** [app-store-preflight-skills](https://github.com/truongduy2611/app-store-preflight-skills)

---

## Part 1: App Store Review Notes (6-Section Standard Template)

> *The following text is pre-formatted for direct submission into App Store Connect's **App Review Information > Notes** field.*

```text
================================================================================
APP STORE REVIEW INFORMATION — CASEBOARD: CRIMINAL DEDUCTION
================================================================================

1. DEMO ACCOUNT / AUTHENTICATION:
- Caseboard features a zero-login, 100% offline architecture.
- No user accounts, credentials, phone numbers, or passwords are required.
- The app immediately opens directly to the Investigator Dashboard upon launch with full guest access.

2. CORE TESTING FLOW & WALKTHROUGH:
- Step 1: From the Dashboard, select the featured tutorial case "The Locked Gallery".
- Step 2: Review the confidential Briefing folder, then tap "Open Caseboard".
- Step 3: On the Caseboard canvas, drag pins between evidence nodes (e.g., Weather Log and Front Door Turnstile) to discover contradictions. Tap on any evidence node to inspect high-resolution macro photography with the 2.5x Loupe tool.
- Step 4: Switch to the "Forensic Lab" tab in the bottom bar to test the procedural tools (Biometric AFIS Scanner, Ballistic Split-Screen Comparator, and Classified Declassifier).
- Step 5: Switch to the "Suspects" tab, select Mara Voss, and tap "ENTER INTERROGATION ROOM" to conduct dialogue inquiries and confront her with physical evidence.
- Step 6: When ready, tap "FILE FORMAL ACCUSATION" to review Motive, Means, and Opportunity, stamp the final warrant, and obtain the S+ forensic grade.

3. IN-APP PURCHASE (IAP) TESTING:
- Product ID: com.caseboard.detective.fullarchive (Non-Consumable, $4.99).
- StoreKit 2 is implemented with automatic StoreKit Test Environment support.
- In Settings or via any locked case, tap "Upgrade to Full Archive" to test the StoreKit purchase sheet.
- Tap "Restore Previous Purchases" at any time to verify instantaneous entitlement restoration.

4. HARDWARE & FEATURE DEPENDENCIES:
- No external hardware required (no Bluetooth, accessories, or cameras needed).
- Fully supports all iPhone and iPad screen sizes in portrait and landscape.
- Utilizes CoreHaptics and AudioToolbox for tactile feedback (gracefully degrades on devices without haptic engines).

5. SERVER STATUS & OFFLINE FUNCTIONALITY:
- Zero external servers or cloud dependencies.
- The application can be completely tested and enjoyed in Airplane Mode with Wi-Fi and Cellular disabled.

6. CONTACT INFORMATION:
- Primary Contact: Caseboard Lead Engineering
- Email: support@caseboard.app
- Issue Tracker: https://github.com/truongduy2611/app-store-preflight-skills
================================================================================
```

---

## Part 2: Apple Review Guidelines Compliance Matrix

### 1. Guideline 2.1 — App Completeness
- **Status:** PASS
- **Verification:**
  - All bundled cases (`tutorial_locked_gallery`, `room_312`, etc.) contain complete, solvable graph topologies verified by automated test suites (`CaseContentIntegrityTests`).
  - Zero "Lorem Ipsum", placeholder buttons, or dead-end screens exist in the codebase.
  - All interactive elements provide responsive visual/haptic feedback.

### 2. Guideline 2.3 — Accurate Metadata
- **Status:** PASS
- **Verification:**
  - App name, subtitle, and description accurately convey the deductive gameplay mechanics.
  - Screenshots reflect actual rendered SwiftUI views on iPhone 17 Pro and iPad Pro simulators.
  - Rating suitability: 12+ / Frequent/Intense Realistic Violence (Detective crime scene themes).

### 3. Guideline 3.1.2 — Subscriptions & In-App Purchases
- **Status:** PASS
- **Verification:**
  - Product `com.caseboard.detective.fullarchive` is clearly designated as a **Non-Consumable** one-time unlock.
  - Paywall explicitly presents:
    - Display price loaded dynamically from StoreKit.
    - Prominent, functional **"Restore Previous Purchases"** button.
    - Direct modal links to **Terms of Service (EULA)** and **Privacy Policy**.

### 4. Guideline 4.0 & 4.2 — Design & Minimum Functionality
- **Status:** PASS
- **Verification:**
  - Bespoke procedural tactile UI (authentic corkboard texture, Polaroid borders, metallic pushpins, braided contradiction threads).
  - High utility interactive features: AFIS Biometric scanner, Ballistic microscope comparison slider, classified dossier declassifier, and dynamic dialogue interrogation room with stress meter.
  - Replayability via deterministic Daily Cold Case generator with cryptographically seeded forensic puzzles.

### 5. Guideline 5.1.1 — Data Privacy & Security
- **Status:** PASS
- **Verification:**
  - **Apple Privacy Manifest (`PrivacyInfo.xcprivacy`)** is included in the application bundle:
    - `NSPrivacyTracking`: `false`
    - `NSPrivacyTrackingDomains`: `[]`
    - `NSPrivacyCollectedDataTypes`: `[]`
    - `NSPrivacyAccessedAPITypes`: `NSPrivacyAccessedAPICategoryUserDefaults` with authorized reason `CA92.1` (In-app preference storage).
  - Zero third-party tracking or advertising SDKs.
  - 100% on-device local storage.

---

## Part 3: StoreKit 2 Configuration (`Caseboard.storekit`)

```json
{
  "identifier": "com.caseboard.detective.storekit",
  "products": [
    {
      "id": "com.caseboard.detective.fullarchive",
      "type": "Non-Consumable",
      "displayPrice": "4.99",
      "displayName": "Full Case Archive Access",
      "description": "Permanent lifetime access to all 12 premier cases and unlimited daily cold case archives."
    }
  ]
}
```

---

## Part 4: Final Sign-Off Checklist
- [x] `PrivacyInfo.xcprivacy` verified and bundled into app resources.
- [x] Terms of Service (EULA) and Privacy Policy accessible from Paywall and Settings.
- [x] Restore Purchases verified via StoreKit 2.
- [x] 100% offline verification in Simulator with airplane/disconnected network.
- [x] Automated test suite passing with 0 failures.
