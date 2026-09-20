import XCTest
@testable import Caseboard

final class DeductionEngineTests: XCTestCase {
    var engine: DeductionEngine!
    var sampleCase: CaseModel!

    override func setUp() {
        super.setUp()
        engine = DeductionEngine()
        sampleCase = DailyCaseGenerator().generateDailyCase(forDateString: "2026-03-14")
    }

    func testTwoItemContradictionOrderInsensitive() {
        // Required items for contradiction_alibi_break: ["ev_culprit_statement", "ev_sensor_telemetry"]
        let resultForward = engine.validateConnection(
            idA: "ev_culprit_statement",
            idB: "ev_sensor_telemetry",
            connectionType: .contradicts,
            in: sampleCase
        )

        let resultReverse = engine.validateConnection(
            idA: "ev_sensor_telemetry",
            idB: "ev_culprit_statement",
            connectionType: .contradicts,
            in: sampleCase
        )

        XCTAssertTrue(resultForward.isContradictionDiscovery)
        XCTAssertTrue(resultReverse.isContradictionDiscovery)

        if case .critical(let c, let unlocked) = resultForward {
            XCTAssertEqual(c.contradictionId, "contradiction_alibi_break")
            XCTAssertTrue(unlocked.contains("ev_discarded_item"))
        } else {
            XCTFail("Expected critical contradiction discovery")
        }
    }

    func testSpuriousConnection() {
        let result = engine.validateConnection(
            idA: "ev_incident_report",
            idB: "ev_culprit_statement",
            connectionType: .establishesMeans,
            in: sampleCase
        )

        XCTAssertFalse(result.isSuccess)
        if case .spuriousLink(let reason) = result {
            XCTAssertFalse(reason.isEmpty)
        } else {
            XCTFail("Expected spurious link")
        }
    }

    func testSuspectMMOUpdateOnContradiction() {
        guard let contradiction = sampleCase.contradictions.first(where: { $0.contradictionId == "contradiction_alibi_break" }) else {
            XCTFail("Missing contradiction")
            return
        }

        let updated = engine.updateSuspectMetrics(for: sampleCase.suspects, discoveredContradictions: [contradiction])
        let culprit = updated.first { $0.suspectId == sampleCase.solution.culpritId }

        XCTAssertNotNil(culprit)
        XCTAssertEqual(culprit?.alibiStatus, .broken)
        XCTAssertEqual(culprit?.suspicionLevel, .primeSuspect)
        XCTAssertGreaterThan(culprit?.opportunityScore ?? 0, 0.5)
    }
}
