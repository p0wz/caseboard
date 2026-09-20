import XCTest
@testable import Caseboard

final class CaseValidatorTests: XCTestCase {
    var validator: CaseValidator!

    override func setUp() {
        super.setUp()
        validator = CaseValidator()
    }

    func testDetectsMissingEvidenceReference() {
        let badContradiction = Contradiction(
            contradictionId: "bad_c",
            title: "Bad Contradiction",
            requiredEvidenceIds: ["non_existent_evidence_1", "non_existent_evidence_2"],
            explanation: "Invalid"
        )

        let badCase = CaseModel(
            caseId: "bad_case",
            title: "Bad Case",
            subtitle: "Test",
            difficulty: .intro,
            estimatedMinutes: 5,
            isPremium: false,
            briefing: Briefing(location: "X", date: "Y", summary: "Z", objective: "W"),
            suspects: [Suspect(suspectId: "s1", caseId: "bad_case", name: "Bob", role: "R", relationshipToVictim: "V", profile: "P")],
            evidence: [],
            timeline: [],
            contradictions: [badContradiction],
            solution: CaseSolution(culpritId: "s1", requiredMotiveEvidenceIds: [], requiredMeansEvidenceIds: [], requiredOpportunityEvidenceIds: [], requiredContradictionIds: [], requiredTimelineEventIds: [])
        )

        let issues = validator.validate(caseModel: badCase)
        let errors = issues.filter { $0.severity == .error }
        XCTAssertFalse(errors.isEmpty)
        XCTAssertTrue(errors.contains { $0.message.contains("requires missing evidence") })
    }
}
