import Foundation

public struct FinalReportEngine: Sendable {
    public init() {}

    /// Evaluates a submitted final accusation dossier against the case solution.
    public func evaluateAccusation(
        submission: AccusationSubmission,
        in caseModel: CaseModel,
        hintsUsedCount: Int = 0,
        previousWrongAttempts: Int = 0,
        elapsedSeconds: Int = 0
    ) -> AccusationResult {
        let solution = caseModel.solution
        var feedback: [String] = []

        // 1. Check Culprit
        let culpritCorrect = (submission.culpritId == solution.culpritId)
        if !culpritCorrect {
            feedback.append("Forensic intelligence does not support the accused as the primary perpetrator.")
        }

        // 2. Check Motive
        let submittedMotive = Set(submission.motiveEvidenceIds)
        let requiredMotive = Set(solution.requiredMotiveEvidenceIds)
        let motiveVerified = requiredMotive.isEmpty || !submittedMotive.intersection(requiredMotive).isEmpty
        if !motiveVerified {
            feedback.append("Your dossier lacks definitive proof of motive. Cross-reference background records or financial audits.")
        }

        // 3. Check Means
        let submittedMeans = Set(submission.meansEvidenceIds)
        let requiredMeans = Set(solution.requiredMeansEvidenceIds)
        let meansVerified = requiredMeans.isEmpty || !submittedMeans.intersection(requiredMeans).isEmpty
        if !meansVerified {
            feedback.append("The physical means or instrument used to commit the offense remains unaccounted for.")
        }

        // 4. Check Opportunity
        let submittedOpportunity = Set(submission.opportunityEvidenceIds)
        let requiredOpportunity = Set(solution.requiredOpportunityEvidenceIds)
        let opportunityVerified = requiredOpportunity.isEmpty || !submittedOpportunity.intersection(requiredOpportunity).isEmpty
        if !opportunityVerified {
            feedback.append("Opportunity window is flawed: the suspect's timeline or location does not place them at the scene.")
        }

        // 5. Check Contradiction
        let contradictionVerified = solution.requiredContradictionIds.isEmpty || solution.requiredContradictionIds.contains(submission.keyContradictionId)
        if !contradictionVerified {
            feedback.append("The submitted key contradiction does not shatter the accused party's primary alibi.")
        }

        // 6. Check Timeline
        let submittedTimeline = Set(submission.timelineEventIds)
        let requiredTimeline = Set(solution.requiredTimelineEventIds)
        let timelineVerified = requiredTimeline.isEmpty || !submittedTimeline.intersection(requiredTimeline).isEmpty

        // Overall success evaluation
        // Case is solved if culprit is correct AND at least 3 of 4 pillars (Motive, Means, Opportunity, Contradiction) are verified
        let pillarsVerifiedCount = [motiveVerified, meansVerified, opportunityVerified, contradictionVerified, timelineVerified].filter { $0 }.count
        let isSuccess = culpritCorrect && pillarsVerifiedCount >= 4

        // Perfect solve check: 100% correct across all pillars, 0 hints, 0 wrong attempts
        let isPerfectSolve = isSuccess &&
            motiveVerified &&
            meansVerified &&
            opportunityVerified &&
            contradictionVerified &&
            timelineVerified &&
            hintsUsedCount == 0 &&
            previousWrongAttempts == 0

        // Determine grade
        let grade: AnalystGrade?
        if isSuccess {
            if isPerfectSolve {
                grade = .sPlus
            } else if hintsUsedCount <= 1 && previousWrongAttempts <= 1 && pillarsVerifiedCount == 5 {
                grade = .s
            } else if hintsUsedCount <= 2 && previousWrongAttempts <= 2 {
                grade = .a
            } else if previousWrongAttempts <= 3 {
                grade = .b
            } else {
                grade = .c
            }
        } else {
            grade = nil
        }

        // Calculate score
        var baseScore = isSuccess ? 1000 : 200
        if isPerfectSolve { baseScore += 500 }
        baseScore += (pillarsVerifiedCount * 100)
        let hintPenalty = hintsUsedCount * 100
        let attemptPenalty = previousWrongAttempts * 75
        let finalScore = max(50, baseScore - hintPenalty - attemptPenalty)

        let summary: String
        if isSuccess {
            summary = solution.resolutionNarrative ?? "Case successfully cleared. The forensic chain of custody and deduction hold beyond reasonable doubt."
        } else {
            summary = "Case submission rejected by the District Analyst. Review the diagnostic feedback and re-examine the caseboard."
        }

        return AccusationResult(
            isSuccess: isSuccess,
            isPerfectSolve: isPerfectSolve,
            grade: grade,
            culpritCorrect: culpritCorrect,
            motiveVerified: motiveVerified,
            meansVerified: meansVerified,
            opportunityVerified: opportunityVerified,
            contradictionVerified: contradictionVerified,
            timelineVerified: timelineVerified,
            analyticalFeedback: feedback,
            resolutionSummary: summary,
            finalScore: finalScore,
            hintsUsedCount: hintsUsedCount,
            wrongAttemptsCount: previousWrongAttempts
        )
    }
}
