import XCTest
@testable import Caseboard

final class CaseboardModelTests: XCTestCase {
    func testAnalystRankProgression() {
        XCTAssertTrue(AnalystRank.traineeAnalyst < AnalystRank.evidenceClerk)
        XCTAssertTrue(AnalystRank.seniorAnalyst < AnalystRank.masterDeductionist)
    }

    func testEvidenceReliabilityMultipliers() {
        XCTAssertGreaterThan(Reliability.verified.scoreMultiplier, Reliability.low.scoreMultiplier)
    }
}
