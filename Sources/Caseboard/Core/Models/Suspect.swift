import Foundation

public enum AlibiStatus: String, Codable, Sendable, CaseIterable {
    case unknown = "unknown"
    case claimed = "claimed"
    case weak = "weak"
    case broken = "broken"
    case confirmed = "confirmed"

    public var displayName: String {
        switch self {
        case .unknown: return "Unknown"
        case .claimed: return "Uncorroborated Alibi"
        case .weak: return "Compromised Alibi"
        case .broken: return "Definitively Broken"
        case .confirmed: return "Verified / Cleared"
        }
    }

    public var sfSymbol: String {
        switch self {
        case .unknown: return "questionmark.circle"
        case .claimed: return "shield"
        case .weak: return "shield.lefthalf.filled"
        case .broken: return "shield.slash.fill"
        case .confirmed: return "checkmark.shield.fill"
        }
    }

    public var colorHex: String {
        switch self {
        case .unknown: return "#8E8E93"
        case .claimed: return "#FF9F0A"
        case .weak: return "#FF6961"
        case .broken: return "#FF3B30"
        case .confirmed: return "#34C759"
        }
    }
}

public enum SuspicionLevel: String, Codable, Sendable, CaseIterable {
    case cleared = "cleared"
    case low = "low"
    case moderate = "moderate"
    case elevated = "elevated"
    case primeSuspect = "prime_suspect"

    public var displayName: String {
        switch self {
        case .cleared: return "Cleared / Exonerated"
        case .low: return "Person of Interest"
        case .moderate: return "Active Suspect"
        case .elevated: return "High Suspicion"
        case .primeSuspect: return "Prime Accused"
        }
    }

    public var colorHex: String {
        switch self {
        case .cleared: return "#34C759"
        case .low: return "#0A84FF"
        case .moderate: return "#FF9F0A"
        case .elevated: return "#FF6961"
        case .primeSuspect: return "#FF3B30"
        }
    }
}

public struct SuspectFact: Codable, Sendable, Hashable {
    public let id: String
    public let text: String
    public let requiredEvidenceId: String?

    public init(id: String, text: String, requiredEvidenceId: String? = nil) {
        self.id = id
        self.text = text
        self.requiredEvidenceId = requiredEvidenceId
    }
}

public struct Suspect: Identifiable, Codable, Sendable, Hashable {
    public var id: String { suspectId }
    public let suspectId: String
    public let caseId: String
    public let name: String
    public let role: String
    public let age: Int?
    public let relationshipToVictim: String
    public let profile: String
    public var motiveScore: Double // 0.0 ... 1.0
    public var meansScore: Double  // 0.0 ... 1.0
    public var opportunityScore: Double // 0.0 ... 1.0
    public var alibiStatus: AlibiStatus
    public var suspicionLevel: SuspicionLevel
    public let initialAlibi: String?
    public let knownFacts: [String]
    public var unlockedFacts: [String]
    public var playerNotes: String?

    public init(
        suspectId: String,
        caseId: String,
        name: String,
        role: String,
        age: Int? = nil,
        relationshipToVictim: String,
        profile: String,
        motiveScore: Double = 0.0,
        meansScore: Double = 0.0,
        opportunityScore: Double = 0.0,
        alibiStatus: AlibiStatus = .unknown,
        suspicionLevel: SuspicionLevel = .low,
        initialAlibi: String? = nil,
        knownFacts: [String] = [],
        unlockedFacts: [String] = [],
        playerNotes: String? = nil
    ) {
        self.suspectId = suspectId
        self.caseId = caseId
        self.name = name
        self.role = role
        self.age = age
        self.relationshipToVictim = relationshipToVictim
        self.profile = profile
        self.motiveScore = motiveScore
        self.meansScore = meansScore
        self.opportunityScore = opportunityScore
        self.alibiStatus = alibiStatus
        self.suspicionLevel = suspicionLevel
        self.initialAlibi = initialAlibi
        self.knownFacts = knownFacts
        self.unlockedFacts = unlockedFacts
        self.playerNotes = playerNotes
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.suspectId = try container.decode(String.self, forKey: .suspectId)
        self.caseId = try container.decode(String.self, forKey: .caseId)
        self.name = try container.decode(String.self, forKey: .name)
        self.role = try container.decode(String.self, forKey: .role)
        self.age = try container.decodeIfPresent(Int.self, forKey: .age)
        self.relationshipToVictim = try container.decode(String.self, forKey: .relationshipToVictim)
        self.profile = try container.decode(String.self, forKey: .profile)
        self.motiveScore = try container.decodeIfPresent(Double.self, forKey: .motiveScore) ?? 0.0
        self.meansScore = try container.decodeIfPresent(Double.self, forKey: .meansScore) ?? 0.0
        self.opportunityScore = try container.decodeIfPresent(Double.self, forKey: .opportunityScore) ?? 0.0
        self.alibiStatus = try container.decodeIfPresent(AlibiStatus.self, forKey: .alibiStatus) ?? .unknown
        self.suspicionLevel = try container.decodeIfPresent(SuspicionLevel.self, forKey: .suspicionLevel) ?? .low
        self.initialAlibi = try container.decodeIfPresent(String.self, forKey: .initialAlibi)
        self.knownFacts = try container.decodeIfPresent([String].self, forKey: .knownFacts) ?? []
        self.unlockedFacts = try container.decodeIfPresent([String].self, forKey: .unlockedFacts) ?? []
        self.playerNotes = try container.decodeIfPresent(String.self, forKey: .playerNotes)
    }

    private enum CodingKeys: String, CodingKey {
        case suspectId, caseId, name, role, age, relationshipToVictim, profile, motiveScore, meansScore, opportunityScore, alibiStatus, suspicionLevel, initialAlibi, knownFacts, unlockedFacts, playerNotes
    }

    public var compositeThreatIndex: Double {
        return (motiveScore * 0.35) + (meansScore * 0.35) + (opportunityScore * 0.30)
    }
}
