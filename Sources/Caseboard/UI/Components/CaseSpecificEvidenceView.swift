import SwiftUI

public struct CaseSpecificEvidenceView: View {
    public let evidence: EvidenceItem
    public let caseTheme: CaseIdentityTheme
    public let spectralFilter: MultispectralFilter
    public let height: CGFloat

    public init(
        evidence: EvidenceItem,
        caseTheme: CaseIdentityTheme? = nil,
        spectralFilter: MultispectralFilter = .visible,
        height: CGFloat = 220
    ) {
        self.evidence = evidence
        self.caseTheme = caseTheme ?? CaseIdentityTheme.theme(for: evidence.caseId)
        self.spectralFilter = spectralFilter
        self.height = height
    }

    private var matchingImageName: String? {
        if ForensicAssetLoader.image(named: evidence.evidenceId) != nil {
            return evidence.evidenceId
        }
        if evidence.evidenceId == "solvent_bottle_analysis" || evidence.evidenceId.contains("solvent") {
            return "evidence_solvent_bottle"
        }
        if evidence.evidenceId == "door_sensor_824" || evidence.evidenceId == "service_door_override_log" {
            return "evidence_vault_crime_scene"
        }
        if evidence.evidenceId == "coroner_chen" || evidence.evidenceId == "connecting_balcony_lock" {
            return "coroner_chen"
        }
        if evidence.evidenceId == "elevator_maintenance_log" {
            return "elevator_maintenance_log"
        }
        return nil
    }

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let imgName = matchingImageName {
                ForensicImageView(name: imgName, contentMode: .fill)
                    .multispectralFilter(spectralFilter)
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
                    .clipped()
            } else {
                proceduralEvidenceSpecimen
                    .multispectralFilter(spectralFilter)
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
            }

            // Chain of Custody Forensic Barcode Tag
            BarcodeEvidenceTagView(
                serialId: "\(caseTheme.signatureEvidencePrefix)-\(evidence.evidenceId.prefix(8).uppercased())",
                category: evidence.type.displayName
            )
            .padding(10)
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(caseTheme.primaryAccent.opacity(0.35), lineWidth: 1)
        )
        .forensicLoupeInspection()
    }

    // MARK: - Procedural Evidence Specimen Canvas

    private var proceduralEvidenceSpecimen: some View {
        ZStack {
            // Textured Archival Background
            Color(hex: caseTheme.paperToneHex)

            // Technical Grid
            ForensicGridPattern()
                .stroke(caseTheme.primaryAccent.opacity(0.08), lineWidth: 0.8)

            // Specimen Content
            VStack(alignment: .leading, spacing: 6) {
                // Header Bar with Department Badge & Seal
                HStack(spacing: 6) {
                    Image(systemName: caseTheme.divisionBadgeSymbol)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(caseTheme.primaryAccent)

                    Text(caseTheme.departmentName)
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                        .foregroundColor(caseTheme.primaryAccent)
                        .lineLimit(1)

                    Spacer()

                    Text("EXHIBIT #\(evidence.evidenceId.prefix(6).uppercased())")
                        .font(.system(size: 8, weight: .black, design: .monospaced))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)

                // Category-specific Forensic Graphic
                specimenGraphicView
                    .padding(.horizontal, 14)
                    .padding(.bottom, 24)
            }

            // Multispectral Hidden Clues (Revealed under UV/IR)
            multispectralHiddenLayer
        }
    }

    // MARK: - Category Graphics

    @ViewBuilder
    private var specimenGraphicView: some View {
        let typeStr = evidence.type.rawValue.lowercased()
        let tags = evidence.tags.map { $0.lowercased() }

        if typeStr.contains("medical") || typeStr.contains("autopsy") {
            medicalAutopsyGraphic
        } else if typeStr.contains("financial") || tags.contains("motive") {
            financialDossierGraphic
        } else if typeStr.contains("security") || typeStr.contains("telemetry") || tags.contains("telemetry") {
            telemetrySensorGraphic
        } else {
            ballisticObjectGraphic
        }
    }

    private var medicalAutopsyGraphic: some View {
        HStack(spacing: 16) {
            // Anatomical silhouette outline
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.black.opacity(0.3))
                    .frame(width: 80, height: 120)

                Image(systemName: "figure.stand")
                    .font(.system(size: 80))
                    .foregroundColor(Color.white.opacity(0.15))

                // Trauma / injection target reticle
                Circle()
                    .strokeBorder(Color.red, lineWidth: 1.5)
                    .frame(width: 20, height: 20)
                    .offset(x: 8, y: -20)
                Image(systemName: "plus")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.red)
                    .offset(x: 8, y: -20)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("LAB PATHOLOGY FINDINGS")
                    .font(.system(size: 10, weight: .black, design: .monospaced))
                    .foregroundColor(.red.opacity(0.9))

                Text(evidence.summary)
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(4)

                Spacer()

                HStack(spacing: 6) {
                    Text("TOXICITY:")
                        .font(.system(size: 7, weight: .bold, design: .monospaced))
                        .foregroundColor(.secondary)
                    Text("LETHAL DETECTED")
                        .font(.system(size: 7, weight: .black, design: .monospaced))
                        .foregroundColor(.red)
                }
            }
            .frame(maxHeight: 120)
        }
    }

    private var financialDossierGraphic: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("CONFIDENTIAL BOARD REGISTRATION")
                    .font(.system(size: 9, weight: .black, design: .monospaced))
                    .foregroundColor(caseTheme.primaryAccent)
                Spacer()
                Text("RESTRICTED")
                    .font(.system(size: 7, weight: .black, design: .monospaced))
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color.yellow.opacity(0.2), in: RoundedRectangle(cornerRadius: 2))
            }

            Divider().background(Color.white.opacity(0.2))

            // Simulated document lines with redaction bars
            ForEach(0..<4) { i in
                HStack(spacing: 6) {
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: CGFloat(40 + (i * 30 % 80)), height: 4)
                    if i % 2 == 1 {
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 50, height: 6)
                            .overlay(
                                Text("REDACTED")
                                    .font(.system(size: 4, weight: .black, design: .monospaced))
                                    .foregroundColor(.white.opacity(0.4))
                            )
                    }
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 4)
                }
            }

            Spacer()

            Text(evidence.summary)
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(2)
        }
        .frame(maxHeight: 120)
    }

    private var telemetrySensorGraphic: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("CIRCUIT TELEMETRY LOG")
                    .font(.system(size: 9, weight: .black, design: .monospaced))
                    .foregroundColor(caseTheme.primaryAccent)
                Spacer()
                Text(evidence.timestamp ?? "LIVE FEED")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .foregroundColor(.green)
            }

            // Oscilloscope Waveform Path
            Path { p in
                p.move(to: CGPoint(x: 0, y: 30))
                for x in stride(from: 0, through: 260, by: 10) {
                    let y = 30.0 + sin(Double(x) * 0.15) * 18.0 + (x == 120 ? -24.0 : 0.0)
                    p.addLine(to: CGPoint(x: Double(x), y: y))
                }
            }
            .stroke(Color.green, style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
            .frame(height: 60)
            .background(Color.black.opacity(0.4), in: RoundedRectangle(cornerRadius: 4))

            Text(evidence.summary)
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(2)
        }
        .frame(maxHeight: 120)
    }

    private var ballisticObjectGraphic: some View {
        HStack(spacing: 12) {
            // Technical Blueprint Box
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.black.opacity(0.4))
                    .frame(width: 90, height: 110)

                Image(systemName: "wrench.and.screwdriver")
                    .font(.system(size: 40))
                    .foregroundColor(caseTheme.primaryAccent.opacity(0.4))

                // Dimension Callout lines
                Path { p in
                    p.move(to: CGPoint(x: 10, y: 15))
                    p.addLine(to: CGPoint(x: 80, y: 15))
                    p.move(to: CGPoint(x: 10, y: 10))
                    p.addLine(to: CGPoint(x: 10, y: 20))
                    p.move(to: CGPoint(x: 80, y: 10))
                    p.addLine(to: CGPoint(x: 80, y: 20))
                }
                .stroke(Color.white.opacity(0.4), lineWidth: 1)

                Text("CALIBER / METRIC")
                    .font(.system(size: 5, weight: .bold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.6))
                    .offset(y: -44)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("PHYSICAL SPECIMEN ANALYSIS")
                    .font(.system(size: 9, weight: .black, design: .monospaced))
                    .foregroundColor(caseTheme.primaryAccent)

                Text(evidence.summary)
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(4)

                Spacer()

                HStack {
                    Text("STATUS:")
                        .font(.system(size: 7, weight: .bold, design: .monospaced))
                        .foregroundColor(.secondary)
                    Text(evidence.reliability.displayName.uppercased())
                        .font(.system(size: 7, weight: .black, design: .monospaced))
                        .foregroundColor(.green)
                }
            }
            .frame(maxHeight: 110)
        }
    }

    // MARK: - Multispectral Filter Layer

    @ViewBuilder
    private var multispectralHiddenLayer: some View {
        if spectralFilter == .ultraviolet {
            // UV Fluorescent Latent Fingerprint
            ZStack {
                Image(systemName: "touchid")
                    .font(.system(size: 48))
                    .foregroundColor(Color(red: 0.6, green: 0.9, blue: 1.0).opacity(0.85))
                    .blur(radius: 0.3)
                    .offset(x: -30, y: -10)

                Text("LATENT FLUORESCENCE // RIDGE MATCH: 98.4%")
                    .font(.system(size: 7, weight: .black, design: .monospaced))
                    .foregroundColor(Color.cyan)
                    .offset(x: -20, y: 24)
            }
        } else if spectralFilter == .infraredNegative {
            // IR Hidden Redacted Text Reveal
            VStack {
                Text("INFRARED INK RECONSTRUCTION")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .foregroundColor(.red)
                Text("ORIGINAL RECOVERED TEXT: AUTHORIZATION KEY CONFIRMED")
                    .font(.system(size: 7, weight: .black, design: .monospaced))
                    .foregroundColor(.yellow)
            }
            .padding(6)
            .background(Color.black.opacity(0.8), in: RoundedRectangle(cornerRadius: 4))
            .offset(y: -30)
        }
    }
}

// MARK: - Forensic Grid Pattern

public struct ForensicGridPattern: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let step: CGFloat = 20
        for x in stride(from: 0, through: rect.width, by: step) {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }
        for y in stride(from: 0, through: rect.height, by: step) {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        return path
    }
}
