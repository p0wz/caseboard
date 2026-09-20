import XCTest
@testable import Caseboard

final class TimelineEngineTests: XCTestCase {
    var engine: TimelineEngine!
    var sampleCase: CaseModel!

    override func setUp() {
        super.setUp()
        engine = TimelineEngine()
        sampleCase = DailyCaseGenerator().generateDailyCase(forDateString: "2026-03-14")
    }

    func testCanonicalTimelineValidation() {
        // Canonical non-false events: t_tool_checkout (1), t_sensor_trigger (3), t_cell_ping (4)
        let validSequence = ["t_tool_checkout", "t_sensor_trigger", "t_cell_ping"]
        let result = engine.validateTimeline(orderedEventIds: validSequence, against: sampleCase.timeline)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.accuracyPercentage, 100)
        XCTAssertTrue(result.conflicts.isEmpty)
    }

    func testFalseClaimDetection() {
        // t_claimed_departure is a false claim!
        let falseSequence = ["t_tool_checkout", "t_claimed_departure", "t_sensor_trigger"]
        let result = engine.validateTimeline(orderedEventIds: falseSequence, against: sampleCase.timeline)

        XCTAssertFalse(result.isValid)
        XCTAssertFalse(result.discoveredFalseClaims.isEmpty)
        XCTAssertFalse(result.conflicts.isEmpty)
    }

    func testInvertedSequenceConflict() {
        // Inverted: placing t_cell_ping before t_tool_checkout
        let inverted = ["t_cell_ping", "t_tool_checkout"]
        let result = engine.validateTimeline(orderedEventIds: inverted, against: sampleCase.timeline)

        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.conflicts.contains { $0.conflictReason.contains("Occurred after") })
    }
}
