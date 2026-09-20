import XCTest
@testable import Caseboard

final class CaseContentIntegrityTests: XCTestCase {
    var validator: CaseValidator!

    override func setUp() {
        super.setUp()
        validator = CaseValidator()
    }

    func testAllBundledCasesAreValidAndSolvable() throws {
        // Find Cases directory in bundle or source tree
        let bundle = Bundle.module
        var caseURLs: [URL] = []

        if let resourceURLs = bundle.urls(forResourcesWithExtension: "json", subdirectory: "Cases") {
            caseURLs.append(contentsOf: resourceURLs)
        }
        if let rootURLs = bundle.urls(forResourcesWithExtension: "json", subdirectory: nil) {
            caseURLs.append(contentsOf: rootURLs.filter { $0.lastPathComponent.contains(".json") })
        }

        // Also check direct directory path for test runner
        let fileManager = FileManager.default
        let currentDir = fileManager.currentDirectoryPath
        let sourceCasesDir = URL(fileURLWithPath: currentDir).appendingPathComponent("Sources/Caseboard/Resources/Cases")
        if let sourceFiles = try? fileManager.contentsOfDirectory(at: sourceCasesDir, includingPropertiesForKeys: nil) {
            for f in sourceFiles where f.pathExtension == "json" {
                if !caseURLs.contains(where: { $0.lastPathComponent == f.lastPathComponent }) {
                    caseURLs.append(f)
                }
            }
        }

        XCTAssertFalse(caseURLs.isEmpty, "No case JSON files found in bundle or Sources/Caseboard/Resources/Cases")

        let decoder = JSONDecoder()
        var validatedCaseIds = Set<String>()

        for url in caseURLs {
            do {
                let data = try Data(contentsOf: url)
                let caseModel = try decoder.decode(CaseModel.self, from: data)
                validatedCaseIds.insert(caseModel.caseId)

                let issues = validator.validate(caseModel: caseModel)
                let errors = issues.filter { $0.severity == .error }
                XCTAssertTrue(errors.isEmpty, "Case '\(caseModel.caseId)' at \(url.lastPathComponent) failed validation: \(errors.map { $0.message }.joined(separator: ", "))")
            } catch {
                XCTFail("Failed to decode case JSON at \(url.lastPathComponent): \(error)")
            }
        }

        // Verify required cases are present
        let requiredFreeCases = ["locked_gallery", "rain_at_mercer_street", "the_vanishing_courier", "room_312"]
        for cId in requiredFreeCases {
            XCTAssertTrue(validatedCaseIds.contains(cId), "Missing required free case: \(cId)")
        }

        let requiredPremiumCases = [
            "the_silent_auction", "cold_signal", "the_ninth_witness", "glass_house",
            "the_missing_minute", "the_harbor_alibi", "dead_drop", "the_last_reservation",
            "the_blue_umbrella", "static_on_line_seven", "the_founders_exit", "the_ash_ledger"
        ]
        for cId in requiredPremiumCases {
            XCTAssertTrue(validatedCaseIds.contains(cId), "Missing required premium case: \(cId)")
        }
    }
}
