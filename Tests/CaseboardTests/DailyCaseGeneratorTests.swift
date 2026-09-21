import XCTest
@testable import Caseboard

final class DailyCaseGeneratorTests: XCTestCase {
    var generator: DailyCaseGenerator!
    var validator: CaseValidator!

    override func setUp() {
        super.setUp()
        generator = DailyCaseGenerator()
        validator = CaseValidator()
    }

    func testDeterministicGenerationForSameDate() {
        let caseA = generator.generateDailyCase(forDateString: "2026-03-14")
        let caseB = generator.generateDailyCase(forDateString: "2026-03-14")

        XCTAssertEqual(caseA.caseId, caseB.caseId)
        XCTAssertEqual(caseA.title, caseB.title)
        XCTAssertEqual(caseA.solution.culpritId, caseB.solution.culpritId)
        XCTAssertEqual(caseA.evidence.count, caseB.evidence.count)
        XCTAssertEqual(caseA.contradictions.count, caseB.contradictions.count)
    }

    func testDailyCaseValidationIntegrity() {
        let testDates = ["2026-01-01", "2026-03-14", "2026-07-04", "2026-11-11", "2026-12-31"]
        for dateStr in testDates {
            let daily = generator.generateDailyCase(forDateString: dateStr)
            let issues = validator.validate(caseModel: daily)
            let errors = issues.filter { $0.severity == .error }
            XCTAssertTrue(errors.isEmpty, "Daily case on \(dateStr) has errors: \(errors.map { $0.message })")
        }
    }
}
