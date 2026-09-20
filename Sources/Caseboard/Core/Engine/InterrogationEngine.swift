import Foundation

public struct ConfrontationOutcome: Sendable {
    public let isBreakthrough: Bool
    public let responseText: String
    public let unlockedContradictionId: String?
    public let newFactUnlocked: String?
    public let stressIncrease: Double

    public init(
        isBreakthrough: Bool,
        responseText: String,
        unlockedContradictionId: String? = nil,
        newFactUnlocked: String? = nil,
        stressIncrease: Double = 0.0
    ) {
        self.isBreakthrough = isBreakthrough
        self.responseText = responseText
        self.unlockedContradictionId = unlockedContradictionId
        self.newFactUnlocked = newFactUnlocked
        self.stressIncrease = stressIncrease
    }
}

public final class InterrogationEngine: Sendable {
    public static let shared = InterrogationEngine()

    public init() {}

    /// Evaluates presenting evidence to a suspect
    public func evaluateConfrontation(
        suspect: Suspect,
        evidenceId: String,
        caseModel: CaseModel
    ) -> ConfrontationOutcome {
        // 1. Check suspect's explicit confrontation pairs
        if let pair = suspect.confrontations.first(where: { $0.evidenceId == evidenceId }) {
            return ConfrontationOutcome(
                isBreakthrough: true,
                responseText: pair.brokenReaction,
                unlockedContradictionId: pair.contradictionId,
                newFactUnlocked: pair.newFactUnlocked,
                stressIncrease: 0.35
            )
        }

        // 2. Check if this evidence is part of a contradiction involving this suspect
        let relevantContradiction = caseModel.contradictions.first { contra in
            contra.affectedSuspectId == suspect.suspectId && contra.requiredEvidenceIds.contains(evidenceId)
        }

        if relevantContradiction != nil {
            let defenseText = "I see what you're implying with \(evidenceId.replacingOccurrences(of: "_", with: " ")), but without corroborating logs, your theory is baseless."
            return ConfrontationOutcome(
                isBreakthrough: false,
                responseText: defenseText,
                unlockedContradictionId: nil,
                newFactUnlocked: nil,
                stressIncrease: 0.15
            )
        }

        // 3. Completely irrelevant evidence
        let genericDefenses = [
            "What does this item have to do with me? You're grasping at straws, Detective.",
            "I have never seen that in my life. Inspect it all you want.",
            "That proves nothing about my whereabouts or motives."
        ]
        let hash = abs((suspect.suspectId + evidenceId).hashValue)
        let response = genericDefenses[hash % genericDefenses.count]

        return ConfrontationOutcome(
            isBreakthrough: false,
            responseText: response,
            unlockedContradictionId: nil,
            newFactUnlocked: nil,
            stressIncrease: -0.05
        )
    }

    /// Calculate dynamic stress level (0.0 ... 1.0)
    public func computeStress(
        baseMotive: Double,
        alibiStatus: AlibiStatus,
        topicsAskedCount: Int,
        breakthroughsCount: Int
    ) -> Double {
        var stress = baseMotive * 0.4
        stress += Double(topicsAskedCount) * 0.05
        stress += Double(breakthroughsCount) * 0.35

        switch alibiStatus {
        case .broken: stress += 0.4
        case .weak: stress += 0.2
        case .confirmed: stress = max(0.05, stress - 0.3)
        case .claimed, .unknown: break
        }

        return min(1.0, max(0.05, stress))
    }
}
