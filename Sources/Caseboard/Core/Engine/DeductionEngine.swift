import Foundation

public enum DeductionValidationResult: Sendable, Equatable {
    case critical(contradiction: Contradiction, unlockedEvidenceIds: [String])
    case correct(contradiction: Contradiction, unlockedEvidenceIds: [String])
    case partial(contradictionTitle: String, matchedCount: Int, requiredCount: Int, hint: String)
    case validRelationship(type: ConnectionType, explanation: String)
    case spuriousLink(reason: String)

    public var isSuccess: Bool {
        switch self {
        case .critical, .correct, .validRelationship: return true
        default: return false
        }
    }

    public var isContradictionDiscovery: Bool {
        switch self {
        case .critical, .correct: return true
        default: return false
        }
    }
}

public struct DeductionEngine: Sendable {
    public init() {}

    /// Evaluates a proposed connection between two items on the caseboard.
    public func validateConnection(
        idA: String,
        idB: String,
        connectionType: ConnectionType,
        in caseModel: CaseModel,
        existingConnections: [CaseboardConnection] = []
    ) -> DeductionValidationResult {
        // Normalize IDs
        let activePair = Set([idA, idB])

        // 1. Check if this directly or partially satisfies a known Contradiction
        for contradiction in caseModel.contradictions {
            let requiredSet = Set(contradiction.requiredEvidenceIds)

            if connectionType == .contradicts || connectionType == .weakensAlibi {
                // If the contradiction requires exactly 2 items and matches activePair
                if requiredSet.count == 2 && requiredSet == activePair {
                    let unlocked = contradiction.unlocks ?? []
                    if contradiction.severity == .critical {
                        return .critical(contradiction: contradiction, unlockedEvidenceIds: unlocked)
                    } else {
                        return .correct(contradiction: contradiction, unlockedEvidenceIds: unlocked)
                    }
                }

                // If contradiction requires 3 items
                if requiredSet.count > 2 && activePair.isSubset(of: requiredSet) {
                    // Check if the remaining required items are already connected to idA or idB on the board
                    var connectedWithActive = Set<String>(activePair)
                    for conn in existingConnections where conn.connectionType == .contradicts || conn.connectionType == .weakensAlibi {
                        if connectedWithActive.contains(conn.sourceId) {
                            connectedWithActive.insert(conn.targetId)
                        } else if connectedWithActive.contains(conn.targetId) {
                            connectedWithActive.insert(conn.sourceId)
                        }
                    }

                    if requiredSet.isSubset(of: connectedWithActive) {
                        let unlocked = contradiction.unlocks ?? []
                        if contradiction.severity == .critical {
                            return .critical(contradiction: contradiction, unlockedEvidenceIds: unlocked)
                        } else {
                            return .correct(contradiction: contradiction, unlockedEvidenceIds: unlocked)
                        }
                    } else {
                        let matched = requiredSet.intersection(connectedWithActive).count
                        return .partial(
                            contradictionTitle: contradiction.title,
                            matchedCount: matched,
                            requiredCount: requiredSet.count,
                            hint: "A third forensic element is required to substantiate this contradiction: '\(contradiction.title)'."
                        )
                    }
                }
            }
        }

        // 2. Check relationship validations against Solution & Suspects
        switch connectionType {
        case .establishesMotive:
            if caseModel.solution.requiredMotiveEvidenceIds.contains(idA) || caseModel.solution.requiredMotiveEvidenceIds.contains(idB) {
                return .validRelationship(type: .establishesMotive, explanation: "Evidence establishes a verified motive against the suspect.")
            }

        case .establishesMeans:
            if caseModel.solution.requiredMeansEvidenceIds.contains(idA) || caseModel.solution.requiredMeansEvidenceIds.contains(idB) {
                return .validRelationship(type: .establishesMeans, explanation: "Evidence establishes physical means and instrumental capability.")
            }

        case .establishesOpportunity:
            if caseModel.solution.requiredOpportunityEvidenceIds.contains(idA) || caseModel.solution.requiredOpportunityEvidenceIds.contains(idB) {
                return .validRelationship(type: .establishesOpportunity, explanation: "Evidence confirms suspect opportunity window.")
            }

        case .placesAtScene:
            let evidenceItem = caseModel.evidence.first { $0.evidenceId == idA || $0.evidenceId == idB }
            if let ev = evidenceItem, ev.type == .securityRecord || ev.type == .locationData || ev.type == .receipt {
                return .validRelationship(type: .placesAtScene, explanation: "Documented access or transaction places subject at location.")
            }

        case .supports, .confirmsTimeline:
            let evA = caseModel.evidence.first { $0.evidenceId == idA }
            let evB = caseModel.evidence.first { $0.evidenceId == idB }
            if let a = evA, let b = evB {
                if a.relatedEvidenceIds.contains(b.evidenceId) || b.relatedEvidenceIds.contains(a.evidenceId) {
                    return .validRelationship(type: connectionType, explanation: "Forensic records corroborate each other.")
                }
            }

        default:
            break
        }

        return .spuriousLink(reason: "No conclusive forensic relationship found between these records.")
    }

    /// Evaluates dynamic MMO updates for suspects when contradictions are discovered
    public func updateSuspectMetrics(
        for suspects: [Suspect],
        discoveredContradictions: [Contradiction]
    ) -> [Suspect] {
        var updated = suspects

        for contradiction in discoveredContradictions {
            guard let suspectId = contradiction.affectedSuspectId,
                  let index = updated.firstIndex(where: { $0.suspectId == suspectId }) else {
                continue
            }

            if let mDelta = contradiction.motiveDelta {
                updated[index].motiveScore = min(1.0, max(0.0, updated[index].motiveScore + mDelta))
            }
            if let meansDelta = contradiction.meansDelta {
                updated[index].meansScore = min(1.0, max(0.0, updated[index].meansScore + meansDelta))
            }
            if let oppDelta = contradiction.opportunityDelta {
                updated[index].opportunityScore = min(1.0, max(0.0, updated[index].opportunityScore + oppDelta))
            }
            if let newAlibi = contradiction.newAlibiStatus {
                updated[index].alibiStatus = newAlibi
            }

            // Adjust suspicion level
            let composite = updated[index].compositeThreatIndex
            if updated[index].alibiStatus == .broken || composite >= 0.75 {
                updated[index].suspicionLevel = .primeSuspect
            } else if composite >= 0.5 {
                updated[index].suspicionLevel = .elevated
            } else if composite >= 0.25 {
                updated[index].suspicionLevel = .moderate
            }
        }

        return updated
    }
}
