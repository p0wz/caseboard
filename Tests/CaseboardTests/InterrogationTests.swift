import XCTest
@testable import Caseboard

final class InterrogationTests: XCTestCase {

    var engine: InterrogationEngine!
    var sampleCase: CaseModel!
    var suspectMara: Suspect!

    override func setUp() {
        super.setUp()
        engine = InterrogationEngine()
        sampleCase = CaseContentLoader.shared.loadCase(withId: "locked_gallery")
        XCTAssertNotNil(sampleCase, "Locked gallery case should load successfully")
        suspectMara = sampleCase.suspects.first { $0.suspectId == "suspect_mara" }
        XCTAssertNotNil(suspectMara, "Mara Voss should exist in the locked gallery case")
    }

    func testSuspectHasInterrogationTopics() {
        XCTAssertFalse(suspectMara.interrogationTopics.isEmpty, "Mara should have configured interrogation topics")
        let firstTopic = suspectMara.interrogationTopics[0]
        XCTAssertFalse(firstTopic.questionText.isEmpty)
        XCTAssertFalse(firstTopic.initialResponse.isEmpty)
    }

    func testConfrontationWithDirectEvidenceBreaksAlibi() {
        // In tutorial case, Mara's alibi is broken by weather_log_811 or dry_umbrella_locker
        let outcome = engine.evaluateConfrontation(
            suspect: suspectMara,
            evidenceId: "weather_log_811",
            caseModel: sampleCase
        )

        XCTAssertTrue(outcome.isBreakthrough, "Weather log should trigger a breakthrough confrontation for Mara")
        XCTAssertNotNil(outcome.unlockedContradictionId)
        XCTAssertEqual(outcome.unlockedContradictionId, "contradiction_alibi_time")
        XCTAssertTrue(outcome.stressIncrease > 0.2)
        XCTAssertFalse(outcome.responseText.isEmpty)
    }

    func testConfrontationWithIrrelevantEvidenceProducesGraspingResponse() {
        let outcome = engine.evaluateConfrontation(
            suspect: suspectMara,
            evidenceId: "completely_unrelated_fake_evidence",
            caseModel: sampleCase
        )

        XCTAssertFalse(outcome.isBreakthrough, "Unrelated evidence must not trigger a breakthrough")
        XCTAssertNil(outcome.unlockedContradictionId)
        XCTAssertNil(outcome.newFactUnlocked)
    }

    func testStressLevelIncreasesWithInquiries() {
        let initialStress = engine.computeStress(
            baseMotive: suspectMara.motiveScore,
            alibiStatus: suspectMara.alibiStatus,
            topicsAskedCount: 0,
            breakthroughsCount: 0
        )

        let elevatedStress = engine.computeStress(
            baseMotive: suspectMara.motiveScore,
            alibiStatus: .broken,
            topicsAskedCount: 3,
            breakthroughsCount: 1
        )
        XCTAssertGreaterThan(elevatedStress, initialStress)
        XCTAssertLessThanOrEqual(elevatedStress, 1.0)
    }

    func testRoom312ConciergeInterrogationConfrontation() {
        guard let room312 = CaseContentLoader.shared.loadCase(withId: "room_312"),
              let andre = room312.suspects.first(where: { $0.suspectId == "suspect_andre" }) else {
            XCTFail("Room 312 and Andre Dupuis should load")
            return
        }

        XCTAssertFalse(andre.interrogationTopics.isEmpty)
        let outcome = engine.evaluateConfrontation(
            suspect: andre,
            evidenceId: "elevator_maintenance_log",
            caseModel: room312
        )

        XCTAssertTrue(outcome.isBreakthrough, "Service elevator log should break Andre's lobby alibi")
        XCTAssertEqual(outcome.unlockedContradictionId, "contradiction_elevator_lobby")
        XCTAssertTrue(outcome.responseText.contains("Mon Dieu"))
    }
}
