import XCTest
@testable import Caseboard

final class FinalReportEngineTests: XCTestCase {
    var engine: FinalReportEngine!
    var sampleCase: CaseModel!

    override func setUp() {
        super.setUp()
        engine = FinalReportEngine()
        sampleCase = DailyCaseGenerator().generateDailyCase(forDateString: "2026-03-14")
    }

    func testPerfectSolveProducesSPlus() {
        let sol = sampleCase.solution
        let submission = AccusationSubmission(
            caseId: sampleCase.caseId,
            culpritId: sol.culpritId,
            motiveEvidenceIds: sol.requiredMotiveEvidenceIds,
            meansEvidenceIds: sol.requiredMeansEvidenceIds,
            opportunityEvidenceIds: sol.requiredOpportunityEvidenceIds,
            keyContradictionId: sol.requiredContradictionIds.first ?? "",
            timelineEventIds: sol.requiredTimelineEventIds
        )

        let result = engine.evaluateAccusation(
            submission: submission,
            in: sampleCase,
            hintsUsedCount: 0,
            previousWrongAttempts: 0,
            elapsedSeconds: 400
        )

        XCTAssertTrue(result.isSuccess)
        XCTAssertTrue(result.isPerfectSolve)
        XCTAssertEqual(result.grade, .sPlus)
        XCTAssertTrue(result.analyticalFeedback.isEmpty)
    }

    func testWrongCulpritRejection() {
        let wrongCulprit = sampleCase.suspects.first { $0.suspectId != sampleCase.solution.culpritId }?.suspectId ?? "wrong"
        let sol = sampleCase.solution

        let submission = AccusationSubmission(
            caseId: sampleCase.caseId,
            culpritId: wrongCulprit,
            motiveEvidenceIds: sol.requiredMotiveEvidenceIds,
            meansEvidenceIds: sol.requiredMeansEvidenceIds,
            opportunityEvidenceIds: sol.requiredOpportunityEvidenceIds,
            keyContradictionId: sol.requiredContradictionIds.first ?? "",
            timelineEventIds: sol.requiredTimelineEventIds
        )

        let result = engine.evaluateAccusation(
            submission: submission,
            in: sampleCase,
            hintsUsedCount: 0,
            previousWrongAttempts: 0,
            elapsedSeconds: 500
        )

        XCTAssertFalse(result.isSuccess)
        XCTAssertNil(result.grade)
        XCTAssertTrue(result.analyticalFeedback.contains { $0.contains("intelligence does not support") })
    }
}
