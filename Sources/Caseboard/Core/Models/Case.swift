import Foundation

public enum CaseDifficulty: String, Codable, Sendable, CaseIterable {
    case intro = "intro"
    case standard = "standard"
    case advanced = "advanced"
    case expert = "expert"

    public var displayName: String {
        switch self {
        case .intro: return "Introductory"
        case .standard: return "Standard"
        case .advanced: return "Advanced"
        case .expert: return "Expert Forensic"
        }
    }

    public var badgeColorHex: String {
        switch self {
        case .intro: return "#34C759"
        case .standard: return "#0A84FF"
        case .advanced: return "#FF9F0A"
        case .expert: return "#FF453A"
        }
    }
}

public struct Briefing: Codable, Sendable, Hashable {
    public let location: String
    public let date: String
    public let victimOrSubject: String?
    public let summary: String
    public let objective: String
    public let requiredSolveConditions: [String]?

    public init(
        location: String,
        date: String,
        victimOrSubject: String? = nil,
        summary: String,
        objective: String,
        requiredSolveConditions: [String]? = nil
    ) {
        self.location = location
        self.date = date
        self.victimOrSubject = victimOrSubject
        self.summary = summary
        self.objective = objective
        self.requiredSolveConditions = requiredSolveConditions
    }
}

public struct CaseSolution: Codable, Sendable, Hashable {
    public let culpritId: String
    public let requiredMotiveEvidenceIds: [String]
    public let requiredMeansEvidenceIds: [String]
    public let requiredOpportunityEvidenceIds: [String]
    public let requiredContradictionIds: [String]
    public let requiredTimelineEventIds: [String]
    public let resolutionNarrative: String?

    public init(
        culpritId: String,
        requiredMotiveEvidenceIds: [String],
        requiredMeansEvidenceIds: [String],
        requiredOpportunityEvidenceIds: [String],
        requiredContradictionIds: [String],
        requiredTimelineEventIds: [String],
        resolutionNarrative: String? = nil
    ) {
        self.culpritId = culpritId
        self.requiredMotiveEvidenceIds = requiredMotiveEvidenceIds
        self.requiredMeansEvidenceIds = requiredMeansEvidenceIds
        self.requiredOpportunityEvidenceIds = requiredOpportunityEvidenceIds
        self.requiredContradictionIds = requiredContradictionIds
        self.requiredTimelineEventIds = requiredTimelineEventIds
        self.resolutionNarrative = resolutionNarrative
    }
}

public struct CaseModel: Identifiable, Codable, Sendable, Hashable {
    public var id: String { caseId }
    public let caseId: String
    public let title: String
    public let subtitle: String
    public let difficulty: CaseDifficulty
    public let estimatedMinutes: Int
    public let isPremium: Bool
    public let briefing: Briefing
    public let suspects: [Suspect]
    public let evidence: [EvidenceItem]
    public let timeline: [TimelineEvent]
    public let contradictions: [Contradiction]
    public let solution: CaseSolution
    public let hints: [CaseHint]?

    public init(
        caseId: String,
        title: String,
        subtitle: String,
        difficulty: CaseDifficulty,
        estimatedMinutes: Int,
        isPremium: Bool,
        briefing: Briefing,
        suspects: [Suspect],
        evidence: [EvidenceItem],
        timeline: [TimelineEvent],
        contradictions: [Contradiction],
        solution: CaseSolution,
        hints: [CaseHint]? = nil
    ) {
        self.caseId = caseId
        self.title = title
        self.subtitle = subtitle
        self.difficulty = difficulty
        self.estimatedMinutes = estimatedMinutes
        self.isPremium = isPremium
        self.briefing = briefing
        self.suspects = suspects
        self.evidence = evidence
        self.timeline = timeline
        self.contradictions = contradictions
        self.solution = solution
        self.hints = hints
    }
}

public struct CaseHint: Codable, Sendable, Hashable, Identifiable {
    public var id: String { tier.rawValue }
    public let tier: HintTier
    public let text: String
    public let targetSuspectId: String?
    public let relatedEvidenceIds: [String]?

    public enum HintTier: String, Codable, Sendable, CaseIterable {
        case nudge = "nudge"
        case direction = "direction"
        case nearSolution = "near_solution"

        public var title: String {
            switch self {
            case .nudge: return "Forensic Nudge"
            case .direction: return "Investigative Direction"
            case .nearSolution: return "Critical Deduction"
            }
        }

        public var scorePenaltyPercent: Int {
            switch self {
            case .nudge: return 5
            case .direction: return 12
            case .nearSolution: return 25
            }
        }
    }

    public init(tier: HintTier, text: String, targetSuspectId: String? = nil, relatedEvidenceIds: [String]? = nil) {
        self.tier = tier
        self.text = text
        self.targetSuspectId = targetSuspectId
        self.relatedEvidenceIds = relatedEvidenceIds
    }
}
