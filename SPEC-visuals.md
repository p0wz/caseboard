# Spec: Caseboard Forensic Visual & Asset Enhancement (SPEC-visuals)

## Objective
Transform Caseboard from a clean typographic interface into an immersive, tactile, visually rich forensic workstation. Integrate photorealistic visual assets, procedural forensic analysis tools, tactile paper/evidence textures, and high-impact SF Symbols micro-animations without compromising the 100% offline, zero-backend architecture.

---

## Asset Strategy & Sources

1. **AI-Generated Bespoke Assets (`generate_image`)**:
   - High-fidelity noir/forensic character portraits (Mugshots with height charts and booking placards).
   - Macro crime scene evidence imagery (broken watches, torn documents, ballistics, fiber samples).
   - Archival crime scene photos in Polaroid/35mm film format.

2. **Free & Public Domain Asset Catalogs (Zero Licensing Risk)**:
   - **Kenney.nl (CC0 - Public Domain)**: Audio chimes, tactile UI clicks, forensic scan sounds, paper rustles.
   - **SF Symbols 6 (Apple Native)**: Multi-layer variable color forensic icons (magnifyingglass, waveform.path, doc.text.magnifyingglass, lock.shield, view.2d).
   - **Unsplash/Wikimedia Commons (Public Domain / CC0)**: Historical textures, fingerprint templates, architectural blueprints.

3. **Procedural SwiftUI Vector Generators**:
   - Biometric fingerprint scanner with animating laser sweep and minutiae markers.
   - Ballistic striation split-screen comparator slider.
   - Audio spectrogram frequency visualizer.
   - Forensic rubber stamp generator ("TOP SECRET", "REDACTED", "MATCH CONFIRMED", "CONTRADICTION").

---

## Core Visual Systems & Capabilities

### System A: Visual Suspect Dossiers
- Every suspect features a dedicated booking photo / mugshot with lighting tuned to their personality (cold corporate lighting, harsh interrogation flash, moody ambient shadow).
- Interactive interrogation state: As contradictions are solved, suspect portrait badge degrades (e.g., "ALIBI COMPROMISED" stamp overlays, nervous posture variant, or status badge).

### System B: Tactile Evidence Presentation
- **Physical Evidence**: Rendered as items pinned to corkboard/forensic slate with realistic drop shadows, evidence label tags with barcodes and serial numbers.
- **Documents & Logs**: Folders with tab dividers, stamped classification watermarks, coffee stains, highlighter annotations, and redacted black-bar text that reveals upon tapping.
- **Biometric & Audio Data**: Waveform audio scrubbers, fingerprint matching overlays, DNA sequence strip visualizers.

### System C: Caseboard Interactive Elements
- Connection threads styled like physical braided thread or digital fiber optic lines with pulse animations upon contradiction discovery.
- Magnifying loupe tool: Floating lens gesture to inspect high-resolution evidence details.
- Resolution dossier stamp: Interactive mechanical rubber stamp animation slamming down on the final report (S+ "CASE CLOSED / ARCHIVED").

---

## Technical Specifications & Tech Stack

- **Language & Frameworks**: Swift 6, SwiftUI, CoreGraphics / Canvas, CoreHaptics, AVFoundation.
- **Asset Storage**: Stored locally in `Sources/Caseboard/Resources/Assets/` or asset catalog `Assets.xcassets`.
- **Target OS**: iOS 17.0+, iPadOS 17.0+ (Dynamic Type, Dark Mode & Light Mode forensic contrast).
- **Bundle Footprint**: Optimized WebP / HEIC / high-efficiency compressed PNGs to keep app download size compact (<50MB total).

---

## Commands
```bash
# Build
xcodebuild -project Caseboard.xcodeproj -scheme Caseboard -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build CODE_SIGNING_ALLOWED=NO

# Test
xcodebuild test -project Caseboard.xcodeproj -scheme Caseboard -destination 'platform=iOS Simulator,name=iPhone 17 Pro' CODE_SIGNING_ALLOWED=NO

# SPM fallback test
swift test
```

---

## Boundaries
- **Always do**:
  - Keep 100% offline capability (all assets bundled locally, zero remote CDN calls).
  - Support both Light and Dark Mode with curated forensic color grading.
  - Optimize memory usage (load full-res images only when zooming, use thumbnails in list/caseboard nodes).
- **Ask first**:
  - Generating and bundling high-res AI images for all 16 cases vs starting with the 4 Free/Tutorial cases first.
  - Introducing heavy 3D scene rendering vs retaining 2D/2.5D SwiftUI Canvas performance.
- **Never do**:
  - Never add external network dependencies, analytics trackers, or paid proprietary asset libraries requiring subscriptions.
  - Never use uncompressed raw 4K textures that would balloon the app size past 100MB.

---

## Success Criteria
1. Every suspect in the playable cases has a distinct, atmospheric visual portrait.
2. Caseboard canvas cards display visual thumbnails and tactile evidence badges instead of pure text.
3. Contradiction discovery triggers a satisfying visual sequence (stamp/thread pulse/haptic feedback).
4. Full headless test suite continues to pass with 0 warnings.
