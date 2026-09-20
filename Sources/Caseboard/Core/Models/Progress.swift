import Foundation

public enum CaseStatus: String, Codable, Sendable, CaseIterable {
    case newCase = "new"
    case inProgress = "in_progress"
    case solved = "solved"
    case perfect = "perfect"
    case locked = "locked"

    public var displayName: String {
        switch self {
        case .newCase: return "Unopened File"
        case .inProgress: return "Active Investigation"
        case .solved: return "Case Solved"
        case .perfect: return "Flawless Deduction"
        case .locked: return "Restricted Archive"
        }
    }

    public var sfSymbol: String {
        switch self {
        case .newCase: return "folder.badge.plus"
        case .inProgress: return "magnifyingglass.circle.fill"
        case .solved: return "checkmark.seal.fill"
        case .perfect: return "star.fill"
        case .locked: return "lock.fill"
        }
    }

    public var colorHex: String {
        switch self {
        case .newCase: return "#0A84FF"
        case .inProgress: return "#FF9F0A"
        case .solved: return "#34C759"
        case .perfect: return "#FFD700"
        case .locked: return "#8E8E93"
        }
    }
}

public enum AnalystRank: String, Codable, Sendable, CaseIterable, Comparable {
    case traineeAnalyst = "trainee_analyst"
    case evidenceClerk = "evidence_clerk"
    case fieldInvestigator = "field_investigator"
    case caseAnalyst = "case_analyst"
    case seniorAnalyst = "senior_analyst"
    case coldCaseSpecialist = "cold_case_specialist"
    case forensicStrategist = "forensic_strategist"
    case masterDeductionist = "master_deductionist"

    public var displayName: String {
        switch self {
        case .traineeAnalyst: return "Trainee Analyst"
        case .evidenceClerk: return "Evidence Clerk"
        case .fieldInvestigator: return "Field Investigator"
        case .caseAnalyst: return "Case Analyst"
        case .seniorAnalyst: return "Senior Analyst"
        case .coldCaseSpecialist: return "Cold Case Specialist"
        case .forensicStrategist: return "Forensic Strategist"
        case .masterDeductionist: return "Master Deductionist"
        }
    }

    public var requiredScore: Int {
        switch self {
        case .traineeAnalyst: return 0
        case .evidenceClerk: return 500
        case .fieldInvestigator: return 1200
        case .caseAnalyst: return 2500
        case .seniorAnalyst: return 4500
        case .coldCaseSpecialist: return 7000
        case .forensicStrategist: return 10500
        case .masterDeductionist: return 15000
        }
    }

    public var clearanceCode: String {
        switch self {
        case .traineeAnalyst: return "CLR-LVL-1"
        case .evidenceClerk: return "CLR-LVL-2"
        case .fieldInvestigator: return "CLR-LVL-3"
        case .caseAnalyst: return "CLR-LVL-4"
        case .seniorAnalyst: return "CLR-LVL-5"
        case .coldCaseSpecialist: return "CLR-SPECIAL"
        case .forensicStrategist: return "CLR-OMEGA"
        case .masterDeductionist: return "CLR-SUPREME"
        }
    }

    private var rankOrder: Int {
        switch self {
        case .traineeAnalyst: return 1
        case .evidenceClerk: return 2
        case .fieldInvestigator: return 3
        case .caseAnalyst: return 4
        case .seniorAnalyst: return 5
        case .coldCaseSpecialist: return 6
        case .forensicStrategist: return 7
        case .masterDeductionist: return 8
        }
    }

    public static func < (lhs: AnalystRank, rhs: AnalystRank) -> Bool {
        return lhs.rankOrder < rhs.rankOrder
    }
}

public struct CaseProgress: Codable, Sendable {
    public let caseId: String
    public var status: CaseStatus
    public var readEvidenceIds: Set<String>
    public var pinnedNodes: [CaseboardNode]
    public var connections: [CaseboardConnection]
    public var discoveredContradictions: [String]
    public var timelineOrder: [String]
    public var wrongAttemptsCount: Int
    public var hintsUsed: [String]
    public var elapsedSeconds: Int
    public var bestGrade: AnalystGrade?
    public var solvedDate: Date?

    public init(
        caseId: String,
        status: CaseStatus = .newCase,
        readEvidenceIds: Set<String> = [],
        pinnedNodes: [CaseboardNode] = [],
        connections: [CaseboardConnection] = [],
        discoveredContradictions: [String] = [],
        timelineOrder: [String] = [],
        wrongAttemptsCount: Int = 0,
        hintsUsed: [String] = [],
        elapsedSeconds: Int = 0,
        bestGrade: AnalystGrade? = nil,
        solvedDate: Date? = nil
    ) {
        self.caseId = caseId
        self.status = status
        self.readEvidenceIds = readEvidenceIds
        self.pinnedNodes = pinnedNodes
        self.connections = connections
        self.discoveredContradictions = discoveredContradictions
        self.timelineOrder = timelineOrder
        self.wrongAttemptsCount = wrongAttemptsCount
        self.hintsUsed = hintsUsed
        self.elapsedSeconds = elapsedSeconds
        self.bestGrade = bestGrade
        self.solvedDate = solvedDate
    }
}

public enum AppearanceMode: String, Codable, Sendable, CaseIterable {
    case system = "system"
    case light = "light"
    case dark = "dark"
}

public struct SettingsModel: Codable, Sendable {
    public var hapticsEnabled: Bool
    public var soundEnabled: Bool
    public var reducedMotion: Bool
    public var appearanceMode: AppearanceMode

    public init(
        hapticsEnabled: Bool = true,
        soundEnabled: Bool = true,
        reducedMotion: Bool = false,
        appearanceMode: AppearanceMode = .system
    ) {
        self.hapticsEnabled = hapticsEnabled
        self.soundEnabled = soundEnabled
        self.reducedMotion = reducedMotion
        self.appearanceMode = appearanceMode
    }
}

public struct UserProgress: Codable, Sendable {
    public var onboardingCompleted: Bool
    public var isPremiumUnlocked: Bool
    public var caseProgress: [String: CaseProgress]
    public var analystRank: AnalystRank
    public var totalScore: Int
    public var dailyStreak: Int
    public var lastDailyCompletedDate: String?
    public var discoveredContradictionIds: Set<String>
    public var unlockedAchievementIds: Set<String>
    public var playerNotes: [String: String]
    public var settings: SettingsModel

    public init(
        onboardingCompleted: Bool = false,
        isPremiumUnlocked: Bool = false,
        caseProgress: [String: CaseProgress] = [:],
        analystRank: AnalystRank = .traineeAnalyst,
        totalScore: Int = 0,
        dailyStreak: Int = 0,
        lastDailyCompletedDate: String? = nil,
        discoveredContradictionIds: Set<String> = [],
        unlockedAchievementIds: Set<String> = [],
        playerNotes: [String: String] = [:],
        settings: SettingsModel = SettingsModel()
    ) {
        self.onboardingCompleted = onboardingCompleted
        self.isPremiumUnlocked = isPremiumUnlocked
        self.caseProgress = caseProgress
        self.analystRank = analystRank
        self.totalScore = totalScore
        self.dailyStreak = dailyStreak
        self.lastDailyCompletedDate = lastDailyCompletedDate
        self.discoveredContradictionIds = discoveredContradictionIds
        self.unlockedAchievementIds = unlockedAchievementIds
        self.playerNotes = playerNotes
        self.settings = settings
    }
}
