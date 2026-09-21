import Foundation

public enum ContradictionType: String, Codable, Sendable, CaseIterable {
    case contradiction = "contradiction"
    case alibiBreak = "alibi_break"
    case sequenceConflict = "sequence_conflict"
    case motiveReveal = "motive_reveal"
    case physicalProof = "physical_proof"

    public var displayName: String {
        switch self {
        case .contradiction: return "Direct Contradiction"
        case .alibiBreak: return "Alibi Shattered"
        case .sequenceConflict: return "Chronological Impossibility"
        case .motiveReveal: return "Hidden Motive Exposed"
        case .physicalProof: return "Physical Forensic Inconsistency"
        }
    }

    public var sfSymbol: String {
        switch self {
        case .contradiction: return "bolt.horizontal.fill"
        case .alibiBreak: return "shield.slash.fill"
        case .sequenceConflict: return "clock.badge.exclamationmark.fill"
        case .motiveReveal: return "flame.fill"
        case .physicalProof: return "hand.raised.slash.fill"
        }
    }
}

public enum ContradictionSeverity: String, Codable, Sendable, CaseIterable {
    case minor = "minor"
    case major = "major"
    case critical = "critical"

    public var displayName: String {
        switch self {
        case .minor: return "Minor Inconsistency"
        case .major: return "Significant Discrepancy"
        case .critical: return "Critical Case Breakthrough"
        }
    }

    public var points: Int {
        switch self {
        case .minor: return 100
        case .major: return 250
        case .critical: return 500
        }
    }

    public var colorHex: String {
        switch self {
        case .minor: return "#0A84FF"
        case .major: return "#FF9F0A"
        case .critical: return "#FF3B30"
        }
    }
}

public struct Contradiction: Identifiable, Codable, Sendable, Hashable {
    public var id: String { contradictionId }
    public let contradictionId: String
    public let caseId: String?
    public let title: String
    public let requiredEvidenceIds: [String]
    public let type: ContradictionType
    public let explanation: String
    public let severity: ContradictionSeverity
    public let affectedSuspectId: String?
    public let motiveDelta: Double?
    public let meansDelta: Double?
    public let opportunityDelta: Double?
    public let newAlibiStatus: AlibiStatus?
    public let unlocks: [String]?

    public init(
        contradictionId: String,
        caseId: String? = nil,
        title: String,
        requiredEvidenceIds: [String],
        type: ContradictionType = .contradiction,
        explanation: String,
        severity: ContradictionSeverity = .major,
        affectedSuspectId: String? = nil,
        motiveDelta: Double? = nil,
        meansDelta: Double? = nil,
        opportunityDelta: Double? = nil,
        newAlibiStatus: AlibiStatus? = nil,
        unlocks: [String]? = nil
    ) {
        self.contradictionId = contradictionId
        self.caseId = caseId
        self.title = title
        self.requiredEvidenceIds = requiredEvidenceIds
        self.type = type
        self.explanation = explanation
        self.severity = severity
        self.affectedSuspectId = affectedSuspectId
        self.motiveDelta = motiveDelta
        self.meansDelta = meansDelta
        self.opportunityDelta = opportunityDelta
        self.newAlibiStatus = newAlibiStatus
        self.unlocks = unlocks
    }
}
