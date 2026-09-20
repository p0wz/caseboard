import Foundation

public enum AnalystGrade: String, Codable, Sendable, Comparable {
    case sPlus = "S+"
    case s = "S"
    case a = "A"
    case b = "B"
    case c = "C"

    public var title: String {
        switch self {
        case .sPlus: return "Forensic Virtuoso (Flawless)"
        case .s: return "Master Deductionist"
        case .a: return "Senior Case Analyst"
        case .b: return "Field Investigator"
        case .c: return "Provisional Clearance"
        }
    }

    public var colorHex: String {
        switch self {
        case .sPlus: return "#FFD700" // Gold
        case .s: return "#AF52DE"     // Purple
        case .a: return "#0A84FF"     // Electric Blue
        case .b: return "#34C759"     // Emerald Green
        case .c: return "#FF9F0A"     // Amber
        }
    }

    private var rankOrder: Int {
        switch self {
        case .sPlus: return 5
        case .s: return 4
        case .a: return 3
        case .b: return 2
        case .c: return 1
        }
    }

    public static func < (lhs: AnalystGrade, rhs: AnalystGrade) -> Bool {
        return lhs.rankOrder < rhs.rankOrder
    }
}

public struct AccusationSubmission: Codable, Sendable, Hashable {
    public let caseId: String
    public let culpritId: String
    public let motiveEvidenceIds: [String]
    public let meansEvidenceIds: [String]
    public let opportunityEvidenceIds: [String]
    public let keyContradictionId: String
    public let timelineEventIds: [String]
    public let playerHypothesis: String?

    public init(
        caseId: String,
        culpritId: String,
        motiveEvidenceIds: [String],
        meansEvidenceIds: [String],
        opportunityEvidenceIds: [String],
        keyContradictionId: String,
        timelineEventIds: [String] = [],
        playerHypothesis: String? = nil
    ) {
        self.caseId = caseId
        self.culpritId = culpritId
        self.motiveEvidenceIds = motiveEvidenceIds
        self.meansEvidenceIds = meansEvidenceIds
        self.opportunityEvidenceIds = opportunityEvidenceIds
        self.keyContradictionId = keyContradictionId
        self.timelineEventIds = timelineEventIds
        self.playerHypothesis = playerHypothesis
    }
}

public struct AccusationResult: Codable, Sendable, Hashable {
    public let isSuccess: Bool
    public let isPerfectSolve: Bool
    public let grade: AnalystGrade?
    public let culpritCorrect: Bool
    public let motiveVerified: Bool
    public let meansVerified: Bool
    public let opportunityVerified: Bool
    public let contradictionVerified: Bool
    public let timelineVerified: Bool
    public let analyticalFeedback: [String]
    public let resolutionSummary: String
    public let finalScore: Int
    public let hintsUsedCount: Int
    public let wrongAttemptsCount: Int

    public init(
        isSuccess: Bool,
        isPerfectSolve: Bool,
        grade: AnalystGrade?,
        culpritCorrect: Bool,
        motiveVerified: Bool,
        meansVerified: Bool,
        opportunityVerified: Bool,
        contradictionVerified: Bool,
        timelineVerified: Bool,
        analyticalFeedback: [String],
        resolutionSummary: String,
        finalScore: Int,
        hintsUsedCount: Int,
        wrongAttemptsCount: Int
    ) {
        self.isSuccess = isSuccess
        self.isPerfectSolve = isPerfectSolve
        self.grade = grade
        self.culpritCorrect = culpritCorrect
        self.motiveVerified = motiveVerified
        self.meansVerified = meansVerified
        self.opportunityVerified = opportunityVerified
        self.contradictionVerified = contradictionVerified
        self.timelineVerified = timelineVerified
        self.analyticalFeedback = analyticalFeedback
        self.resolutionSummary = resolutionSummary
        self.finalScore = finalScore
        self.hintsUsedCount = hintsUsedCount
        self.wrongAttemptsCount = wrongAttemptsCount
    }
}
