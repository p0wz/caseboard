import SwiftUI

public struct CaseIdentityTheme: Sendable {
    public let caseId: String
    public let departmentName: String
    public let jurisdictionCode: String
    public let divisionBadgeSymbol: String
    public let badgeNumber: String
    public let caseClassification: String
    public let signatureEvidencePrefix: String
    public let primaryAccent: Color
    public let secondaryAccent: Color
    public let paperToneHex: String

    public init(
        caseId: String,
        departmentName: String,
        jurisdictionCode: String,
        divisionBadgeSymbol: String,
        badgeNumber: String,
        caseClassification: String,
        signatureEvidencePrefix: String,
        primaryAccent: Color,
        secondaryAccent: Color,
        paperToneHex: String
    ) {
        self.caseId = caseId
        self.departmentName = departmentName
        self.jurisdictionCode = jurisdictionCode
        self.divisionBadgeSymbol = divisionBadgeSymbol
        self.badgeNumber = badgeNumber
        self.caseClassification = caseClassification
        self.signatureEvidencePrefix = signatureEvidencePrefix
        self.primaryAccent = primaryAccent
        self.secondaryAccent = secondaryAccent
        self.paperToneHex = paperToneHex
    }

    public static func theme(for caseId: String) -> CaseIdentityTheme {
        if let theme = allThemes[caseId] {
            return theme
        }
        return defaultTheme(for: caseId)
    }

    private static let allThemes: [String: CaseIdentityTheme] = [
        "locked_gallery": CaseIdentityTheme(
            caseId: "locked_gallery",
            departmentName: "METROPOLITAN POLICE • ART & ANTIQUITIES RECOVERY",
            jurisdictionCode: "NYPD-AATF-08",
            divisionBadgeSymbol: "building.columns.fill",
            badgeNumber: "BADGE #8804",
            caseClassification: "CLASS-A HIGH VALUE ART THEFT & CHEMICAL BREACH",
            signatureEvidencePrefix: "ART-LKG",
            primaryAccent: Color(red: 217/255, green: 175/255, blue: 85/255), // Fine Gold
            secondaryAccent: Color(red: 30/255, green: 41/255, blue: 59/255),
            paperToneHex: "#1E222A"
        ),
        "room_312": CaseIdentityTheme(
            caseId: "room_312",
            departmentName: "METRO HOMICIDE • DOWNTOWN PRECINCT ARCHIVES",
            jurisdictionCode: "MPD-HOM-312",
            divisionBadgeSymbol: "shield.lefthalf.filled",
            badgeNumber: "BADGE #3120",
            caseClassification: "HOTEL SUITE HOMICIDE & ELEVATOR TAMPERING",
            signatureEvidencePrefix: "HOM-R312",
            primaryAccent: Color(red: 220/255, green: 38/255, blue: 38/255), // Crimson
            secondaryAccent: Color(red: 180/255, green: 83/255, blue: 9/255),
            paperToneHex: "#241D1D"
        ),
        "rain_at_mercer_street": CaseIdentityTheme(
            caseId: "rain_at_mercer_street",
            departmentName: "BALLISTICS & COLD CASE SPECIAL INVESTIGATION",
            jurisdictionCode: "CCB-MERCER-07",
            divisionBadgeSymbol: "scope",
            badgeNumber: "BADGE #7719",
            caseClassification: "BALLISTIC AMBUSH & ALLEYWAY RETRIEVAL",
            signatureEvidencePrefix: "BAL-MRC",
            primaryAccent: Color(red: 59/255, green: 130/255, blue: 246/255), // Cobalt
            secondaryAccent: Color(red: 100/255, green: 116/255, blue: 139/255),
            paperToneHex: "#18202A"
        ),
        "the_founders_exit": CaseIdentityTheme(
            caseId: "the_founders_exit",
            departmentName: "SECURITIES & FINANCIAL CRIMES ENFORCEMENT DIVISION",
            jurisdictionCode: "SEC-FIN-50",
            divisionBadgeSymbol: "chart.line.downtrend.xyaxis",
            badgeNumber: "BADGE #5011",
            caseClassification: "EXECUTIVE BOARDROOM POISONING & HOSTILE BUYOUT",
            signatureEvidencePrefix: "SEC-FND",
            primaryAccent: Color(red: 16/255, green: 185/255, blue: 129/255), // Emerald
            secondaryAccent: Color(red: 52/255, green: 211/255, blue: 153/255),
            paperToneHex: "#12231E"
        ),
        "the_silent_auction": CaseIdentityTheme(
            caseId: "the_silent_auction",
            departmentName: "INTERNATIONAL ANTIQUITIES & ILLICIT AUCTION SQUAD",
            jurisdictionCode: "INT-AUC-99",
            divisionBadgeSymbol: "crown.fill",
            badgeNumber: "BADGE #9903",
            caseClassification: "CIPHER TOKEN SUBSTITUTE & PRIVATE VAULT FRAUD",
            signatureEvidencePrefix: "AUC-SLN",
            primaryAccent: Color(red: 245/255, green: 158/255, blue: 11/255), // Amber Gold
            secondaryAccent: Color(red: 147/255, green: 51/255, blue: 234/255),
            paperToneHex: "#221E2A"
        ),
        "the_harbor_alibi": CaseIdentityTheme(
            caseId: "the_harbor_alibi",
            departmentName: "PORT AUTHORITY WATERFRONT POLICE & CUSTOMS BRIGADE",
            jurisdictionCode: "PORT-44-TAC",
            divisionBadgeSymbol: "ferry.fill",
            badgeNumber: "BADGE #4480",
            caseClassification: "PIER 44 SMUGGLING CONSPIRACY & CUSTOMS BRIBERY",
            signatureEvidencePrefix: "PRT-HRB",
            primaryAccent: Color(red: 14/255, green: 165/255, blue: 233/255), // Ocean Sky
            secondaryAccent: Color(red: 234/255, green: 179/255, blue: 8/255),
            paperToneHex: "#11222D"
        ),
        "dead_drop": CaseIdentityTheme(
            caseId: "dead_drop",
            departmentName: "INTELLIGENCE COUNTER-ESPIONAGE SERVICE",
            jurisdictionCode: "ICES-DD-01",
            divisionBadgeSymbol: "key.fill",
            badgeNumber: "BADGE #0188",
            caseClassification: "SUBWAY DEAD DROP & ENCRYPTED CIPHER DRIVE",
            signatureEvidencePrefix: "ESP-DDR",
            primaryAccent: Color(red: 239/255, green: 68/255, blue: 68/255), // Red Hot
            secondaryAccent: Color(red: 156/255, green: 163/255, blue: 175/255),
            paperToneHex: "#1C1C1E"
        ),
        "cold_signal": CaseIdentityTheme(
            caseId: "cold_signal",
            departmentName: "TELECOM SPECTRUM ENFORCEMENT & HIGH-ALTITUDE RADAR",
            jurisdictionCode: "FCC-RAD-14",
            divisionBadgeSymbol: "antenna.radiowaves.left.and.right",
            badgeNumber: "BADGE #1490",
            caseClassification: "RADIO TOWER SABOTAGE & FREQUENCY HIJACK",
            signatureEvidencePrefix: "RAD-CLD",
            primaryAccent: Color(red: 56/255, green: 189/255, blue: 248/255), // Frost Cyan
            secondaryAccent: Color(red: 224/255, green: 242/255, blue: 254/255),
            paperToneHex: "#13232E"
        ),
        "glass_house": CaseIdentityTheme(
            caseId: "glass_house",
            departmentName: "SMART RESIDENCE & ARCHITECTURAL FORENSIC DIVISION",
            jurisdictionCode: "ARCH-GLS-04",
            divisionBadgeSymbol: "house.and.flag.fill",
            badgeNumber: "BADGE #0422",
            caseClassification: "SMART VILLA OVERRIDE & POOL PLATFORM TAMPERING",
            signatureEvidencePrefix: "GLS-HSE",
            primaryAccent: Color(red: 45/255, green: 212/255, blue: 191/255), // Turquoise
            secondaryAccent: Color(red: 148/255, green: 163/255, blue: 184/255),
            paperToneHex: "#122524"
        ),
        "the_missing_minute": CaseIdentityTheme(
            caseId: "the_missing_minute",
            departmentName: "ALGORITHMIC TRADING FRAUD & FIBER CYBERWATCH",
            jurisdictionCode: "SEC-HFT-60",
            divisionBadgeSymbol: "waveform.path.ecg.rectangle",
            badgeNumber: "BADGE #6001",
            caseClassification: "NANOSECOND FIBER SPLICE & HIGH-FREQUENCY CRASH",
            signatureEvidencePrefix: "CYB-MNT",
            primaryAccent: Color(red: 34/255, green: 197/255, blue: 94/255), // Matrix Green
            secondaryAccent: Color(red: 74/255, green: 222/255, blue: 128/255),
            paperToneHex: "#0D2214"
        ),
        "the_vanishing_courier": CaseIdentityTheme(
            caseId: "the_vanishing_courier",
            departmentName: "DIPLOMATIC CORPS SPECIAL INVESTIGATION SERVICE",
            jurisdictionCode: "DIP-COU-77",
            divisionBadgeSymbol: "envelope.badge.shield.half.filled",
            badgeNumber: "BADGE #7740",
            caseClassification: "DIPLOMATIC POUCH SEIZURE & EMBASSY INFILTRATION",
            signatureEvidencePrefix: "DIP-VAN",
            primaryAccent: Color(red: 168/255, green: 85/255, blue: 247/255), // Diplomatic Purple
            secondaryAccent: Color(red: 251/255, green: 191/255, blue: 36/255),
            paperToneHex: "#221828"
        ),
        "the_blue_umbrella": CaseIdentityTheme(
            caseId: "the_blue_umbrella",
            departmentName: "SPECIAL TOXICOLOGY & BIOHAZARD EPIDEMIOLOGY BUREAU",
            jurisdictionCode: "TOX-BLU-19",
            divisionBadgeSymbol: "cross.vial.fill",
            badgeNumber: "BADGE #1905",
            caseClassification: "RICIN MICRO-PELLET INJECTION & CAFE ASSASSINATION",
            signatureEvidencePrefix: "TOX-UMB",
            primaryAccent: Color(red: 6/255, green: 182/255, blue: 212/255), // Toxic Cyan
            secondaryAccent: Color(red: 167/255, green: 139/255, blue: 250/255),
            paperToneHex: "#112529"
        ),
        "the_ash_ledger": CaseIdentityTheme(
            caseId: "the_ash_ledger",
            departmentName: "FORENSIC ACCOUNTING & OFFSHORE TAX ENFORCEMENT",
            jurisdictionCode: "IRS-ASH-23",
            divisionBadgeSymbol: "flame.fill",
            badgeNumber: "BADGE #2387",
            caseClassification: "INCINERATOR RECONSTRUCTION & MULTI-SHELL FRAUD",
            signatureEvidencePrefix: "ACC-ASH",
            primaryAccent: Color(red: 249/255, green: 115/255, blue: 22/255), // Ember Orange
            secondaryAccent: Color(red: 253/255, green: 186/255, blue: 116/255),
            paperToneHex: "#261D15"
        ),
        "static_on_line_seven": CaseIdentityTheme(
            caseId: "static_on_line_seven",
            departmentName: "METROPOLITAN TRANSIT AUTHORITY RAIL POLICE",
            jurisdictionCode: "MTA-LN7-POL",
            divisionBadgeSymbol: "train.side.front.car",
            badgeNumber: "BADGE #7044",
            caseClassification: "SUBWAY SIGNAL RELAY INTERFERENCE & DERAIL PLOT",
            signatureEvidencePrefix: "MTA-LN7",
            primaryAccent: Color(red: 250/255, green: 204/255, blue: 21/255), // Transit Yellow
            secondaryAccent: Color(red: 248/255, green: 113/255, blue: 113/255),
            paperToneHex: "#262314"
        ),
        "the_ninth_witness": CaseIdentityTheme(
            caseId: "the_ninth_witness",
            departmentName: "FEDERAL WITNESS SECURITY & JUDICIAL PROTECTION",
            jurisdictionCode: "USMS-WIT-09",
            divisionBadgeSymbol: "shield.fill",
            badgeNumber: "BADGE #0912",
            caseClassification: "SAFEHOUSE BREACH & CORRUPT MARSHAL TRANSMISSION",
            signatureEvidencePrefix: "FED-WIT",
            primaryAccent: Color(red: 99/255, green: 102/255, blue: 241/255), // Indigo Marshal
            secondaryAccent: Color(red: 199/255, green: 210/255, blue: 254/255),
            paperToneHex: "#181B2D"
        ),
        "the_last_reservation": CaseIdentityTheme(
            caseId: "the_last_reservation",
            departmentName: "HAUTE GASTRONOMY INSPECTION & POISONS ANALYSIS",
            jurisdictionCode: "CHEF-TOX-03",
            divisionBadgeSymbol: "fork.knife",
            badgeNumber: "BADGE #0333",
            caseClassification: "MICHELIN THREE-STAR FUGU TETRODOTOXIN POISONING",
            signatureEvidencePrefix: "CUL-LST",
            primaryAccent: Color(red: 225/255, green: 29/255, blue: 72/255), // Rose Wine
            secondaryAccent: Color(red: 253/255, green: 224/255, blue: 71/255),
            paperToneHex: "#29161B"
        )
    ]

    private static func defaultTheme(for caseId: String) -> CaseIdentityTheme {
        CaseIdentityTheme(
            caseId: caseId,
            departmentName: "METROPOLITAN FORENSIC INVESTIGATION DIVISION",
            jurisdictionCode: "METRO-DIV-\(abs(caseId.hashValue % 900 + 100))",
            divisionBadgeSymbol: "shield.lefthalf.filled",
            badgeNumber: "BADGE #\(abs(caseId.hashValue % 8999 + 1000))",
            caseClassification: "CLASSIFIED INCIDENT DOSSIER // LEVEL 4",
            signatureEvidencePrefix: "EVD-\(caseId.prefix(3).uppercased())",
            primaryAccent: Color(red: 37/255, green: 99/255, blue: 235/255),
            secondaryAccent: Color(red: 217/255, green: 145/255, blue: 9/255),
            paperToneHex: "#1A1E24"
        )
    }
}
