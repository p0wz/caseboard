import Foundation

public struct ValidationIssue: Sendable, Hashable, Identifiable {
    public var id: String { "\(severity)_\(message)" }
    public enum Severity: String, Sendable {
        case error = "ERROR"
        case warning = "WARNING"
    }

    public let severity: Severity
    public let caseId: String
    public let message: String

    public init(severity: Severity, caseId: String, message: String) {
        self.severity = severity
        self.caseId = caseId
        self.message = message
    }
}

public struct CaseValidator: Sendable {
    public init() {}

    /// Validates a single case model for internal consistency and solvability
    public func validate(caseModel: CaseModel) -> [ValidationIssue] {
        var issues: [ValidationIssue] = []
        let caseId = caseModel.caseId

        // 1. Suspect checks
        var suspectIds = Set<String>()
        for s in caseModel.suspects {
            if suspectIds.contains(s.suspectId) {
                issues.append(ValidationIssue(severity: .error, caseId: caseId, message: "Duplicate suspect ID: \(s.suspectId)"))
            }
            suspectIds.insert(s.suspectId)
        }

        // 2. Evidence checks
        var evidenceIds = Set<String>()
        for ev in caseModel.evidence {
            if evidenceIds.contains(ev.evidenceId) {
                issues.append(ValidationIssue(severity: .error, caseId: caseId, message: "Duplicate evidence ID: \(ev.evidenceId)"))
            }
            evidenceIds.insert(ev.evidenceId)
        }

        // 3. Contradiction checks
        var contradictionIds = Set<String>()
        for c in caseModel.contradictions {
            if contradictionIds.contains(c.contradictionId) {
                issues.append(ValidationIssue(severity: .error, caseId: caseId, message: "Duplicate contradiction ID: \(c.contradictionId)"))
            }
            contradictionIds.insert(c.contradictionId)

            for reqEv in c.requiredEvidenceIds {
                if !evidenceIds.contains(reqEv) {
                    issues.append(ValidationIssue(severity: .error, caseId: caseId, message: "Contradiction '\(c.contradictionId)' requires missing evidence: \(reqEv)"))
                }
            }

            if let affected = c.affectedSuspectId, !suspectIds.contains(affected) {
                issues.append(ValidationIssue(severity: .error, caseId: caseId, message: "Contradiction '\(c.contradictionId)' affects non-existent suspect: \(affected)"))
            }

            if let unlocks = c.unlocks {
                for unlockId in unlocks {
                    if !evidenceIds.contains(unlockId) {
                        issues.append(ValidationIssue(severity: .error, caseId: caseId, message: "Contradiction '\(c.contradictionId)' unlocks non-existent evidence: \(unlockId)"))
                    }
                }
            }
        }

        // 4. Timeline checks
        var timelineIds = Set<String>()
        for t in caseModel.timeline {
            if timelineIds.contains(t.eventId) {
                issues.append(ValidationIssue(severity: .error, caseId: caseId, message: "Duplicate timeline event ID: \(t.eventId)"))
            }
            timelineIds.insert(t.eventId)

            if !evidenceIds.contains(t.sourceEvidenceId) {
                issues.append(ValidationIssue(severity: .warning, caseId: caseId, message: "Timeline event '\(t.eventId)' references unknown source evidence: \(t.sourceEvidenceId)"))
            }
        }

        // 5. Solution checks
        let sol = caseModel.solution
        if !suspectIds.contains(sol.culpritId) {
            issues.append(ValidationIssue(severity: .error, caseId: caseId, message: "Solution culpritId '\(sol.culpritId)' not in suspects."))
        }

        for evId in sol.requiredMotiveEvidenceIds where !evidenceIds.contains(evId) {
            issues.append(ValidationIssue(severity: .error, caseId: caseId, message: "Solution requiredMotiveEvidenceId '\(evId)' not found."))
        }
        for evId in sol.requiredMeansEvidenceIds where !evidenceIds.contains(evId) {
            issues.append(ValidationIssue(severity: .error, caseId: caseId, message: "Solution requiredMeansEvidenceId '\(evId)' not found."))
        }
        for evId in sol.requiredOpportunityEvidenceIds where !evidenceIds.contains(evId) {
            issues.append(ValidationIssue(severity: .error, caseId: caseId, message: "Solution requiredOpportunityEvidenceId '\(evId)' not found."))
        }
        for cId in sol.requiredContradictionIds where !contradictionIds.contains(cId) {
            issues.append(ValidationIssue(severity: .error, caseId: caseId, message: "Solution requiredContradictionId '\(cId)' not found."))
        }
        for tId in sol.requiredTimelineEventIds where !timelineIds.contains(tId) {
            issues.append(ValidationIssue(severity: .error, caseId: caseId, message: "Solution requiredTimelineEventId '\(tId)' not found."))
        }

        // 6. Solvability path check
        var reachableEvidence = Set<String>(caseModel.evidence.filter { $0.discoveredInitially }.map { $0.evidenceId })
        var unlockedAny = true
        while unlockedAny {
            unlockedAny = false
            for c in caseModel.contradictions {
                if Set(c.requiredEvidenceIds).isSubset(of: reachableEvidence) {
                    if let unlocks = c.unlocks {
                        for u in unlocks where !reachableEvidence.contains(u) {
                            reachableEvidence.insert(u)
                            unlockedAny = true
                        }
                    }
                }
            }
        }

        let allRequiredEvidence = Set(sol.requiredMotiveEvidenceIds + sol.requiredMeansEvidenceIds + sol.requiredOpportunityEvidenceIds)
        for req in allRequiredEvidence {
            if !reachableEvidence.contains(req) {
                issues.append(ValidationIssue(severity: .error, caseId: caseId, message: "Required solution evidence '\(req)' is unreachable via initial clues or contradiction chain!"))
            }
        }

        return issues
    }
}
