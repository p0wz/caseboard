import XCTest
@testable import Caseboard

final class CaseboardGameplayFlowTests: XCTestCase {
    private let loader = CaseContentLoader()
    private let deductionEngine = DeductionEngine()
    private let timelineEngine = TimelineEngine()
    private let reportEngine = FinalReportEngine()

    func testTutorialCaseEndToEndPlaythrough() {
        guard let tutorialCase = loader.loadCase(withId: "locked_gallery") else {
            XCTFail("Failed to load tutorial case")
            return
        }

        // 1. Initial State: Mara Voss alibi is claimed
        let maraInitial = tutorialCase.suspects.first { $0.suspectId == "suspect_mara" }
        XCTAssertEqual(maraInitial?.alibiStatus, .claimed)

        // 2. Discover critical contradiction: Rainfall vs Departure Sensor
        var activeConnections: [CaseboardConnection] = []

        let partial1 = deductionEngine.validateConnection(
            idA: "door_sensor_824",
            idB: "weather_log_811",
            connectionType: .contradicts,
            in: tutorialCase,
            existingConnections: activeConnections
        )
        if case .partial(let title, let matched, let required, _) = partial1 {
            XCTAssertEqual(matched, 2)
            XCTAssertEqual(required, 3)
            XCTAssertTrue(title.contains("Rainfall vs Departure"))
        } else {
            XCTFail("Expected partial match for 2 of 3 elements")
        }

        activeConnections.append(CaseboardConnection(
            sourceId: "door_sensor_824",
            targetId: "weather_log_811",
            connectionType: .contradicts,
            evaluation: .partial
        ))

        let fullContradiction = deductionEngine.validateConnection(
            idA: "door_sensor_824",
            idB: "mara_statement_alibi",
            connectionType: .contradicts,
            in: tutorialCase,
            existingConnections: activeConnections
        )

        XCTAssertTrue(fullContradiction.isContradictionDiscovery)
        if case .critical(let contradiction, let unlocked) = fullContradiction {
            XCTAssertEqual(contradiction.contradictionId, "contradiction_alibi_time")
            XCTAssertTrue(unlocked.contains("stolen_badge_confession"))
        } else {
            XCTFail("Expected critical contradiction discovery")
        }

        // 3. Verify Suspect Threat index & alibi updates dynamically
        let updatedSuspects = deductionEngine.updateSuspectMetrics(
            for: tutorialCase.suspects,
            discoveredContradictions: [tutorialCase.contradictions.first(where: { $0.contradictionId == "contradiction_alibi_time" })!]
        )
        let maraUpdated = updatedSuspects.first { $0.suspectId == "suspect_mara" }
        XCTAssertEqual(maraUpdated?.alibiStatus, .broken)
        XCTAssertEqual(maraUpdated?.suspicionLevel, .primeSuspect)

        // 4. Validate Timeline Reconstruction
        let validTimelineIds = ["t_vorn_memo", "t_theo_arrives_bar", "t_rain_begins", "t_mara_front_exit", "t_service_door_exit"]
        let timelineValidation = timelineEngine.validateTimeline(orderedEventIds: validTimelineIds, against: tutorialCase.timeline)
        XCTAssertTrue(timelineValidation.isValid)
        XCTAssertEqual(timelineValidation.accuracyPercentage, 100)

        // 5. Submit Final Accusation Dossier
        let submission = AccusationSubmission(
            caseId: tutorialCase.caseId,
            culpritId: "suspect_mara",
            motiveEvidenceIds: ["provenance_audit_memorandum"],
            meansEvidenceIds: ["restoration_solvent_inventory"],
            opportunityEvidenceIds: ["door_sensor_824", "service_door_override_log"],
            keyContradictionId: "contradiction_alibi_time",
            timelineEventIds: ["t_mara_front_exit", "t_service_door_exit"],
            playerHypothesis: "Mara Voss poisoned curator Elias Vorn with restoration solvent after he exposed her forgeries, badged out front to fabricate an alibi, and escaped via service door."
        )

        let accusationResult = reportEngine.evaluateAccusation(
            submission: submission,
            in: tutorialCase,
            hintsUsedCount: 0,
            previousWrongAttempts: 0,
            elapsedSeconds: 320
        )

        XCTAssertTrue(accusationResult.isSuccess)
        XCTAssertTrue(accusationResult.isPerfectSolve)
        XCTAssertEqual(accusationResult.grade, .sPlus)

        // 6. Test progress store integration
        MainActor.assumeIsolated {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("flow_test_\(UUID().uuidString).json")
            let store = ProgressStore(customStorageURL: tempURL)
            store.recordCaseSolved(caseId: tutorialCase.caseId, result: accusationResult, elapsedSeconds: 320)
            let cp = store.progress(for: tutorialCase.caseId)
            XCTAssertEqual(cp.status, .perfect)
            XCTAssertEqual(cp.bestGrade, .sPlus)
            XCTAssertGreaterThan(store.userProgress.totalScore, 1000)
        }
    }

    func testWrongCulpritDiagnosticFeedback() {
        guard let tutorialCase = loader.loadCase(withId: "locked_gallery") else {
            XCTFail("Failed to load case")
            return
        }

        let submission = AccusationSubmission(
            caseId: tutorialCase.caseId,
            culpritId: "suspect_theo",
            motiveEvidenceIds: ["provenance_audit_memorandum"],
            meansEvidenceIds: ["restoration_solvent_inventory"],
            opportunityEvidenceIds: ["door_sensor_824"],
            keyContradictionId: "contradiction_alibi_time"
        )

        let result = reportEngine.evaluateAccusation(submission: submission, in: tutorialCase)
        XCTAssertFalse(result.isSuccess)
        XCTAssertNil(result.grade)
        XCTAssertTrue(result.analyticalFeedback.contains { $0.contains("intelligence does not support the accused") })
    }

    func testFreeCaseRoom312EndToEnd() {
        guard let roomCase = loader.loadCase(withId: "room_312") else {
            XCTFail("Failed to load room_312")
            return
        }

        let submission = AccusationSubmission(
            caseId: roomCase.caseId,
            culpritId: "suspect_andre",
            motiveEvidenceIds: ["andre_sports_debt"],
            meansEvidenceIds: ["coroner_chen"],
            opportunityEvidenceIds: ["elevator_maintenance_log", "connecting_balcony_lock"],
            keyContradictionId: "contradiction_elevator_lobby",
            timelineEventIds: ["t_elevator_override"]
        )

        let result = reportEngine.evaluateAccusation(submission: submission, in: roomCase)
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.grade, .sPlus)
    }

    func testProgressPersistenceAcrossRelaunch() {
        MainActor.assumeIsolated {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("persistence_test_\(UUID().uuidString).json")
            let store1 = ProgressStore(customStorageURL: tempURL)

            store1.completeOnboarding()
            store1.setPremiumUnlocked(true)
            store1.saveNotes(caseId: "locked_gallery", notes: "Forensic analysis: check weather radar.")
            store1.unlockAchievement(.firstContradiction)

            let store2 = ProgressStore(customStorageURL: tempURL)
            XCTAssertTrue(store2.userProgress.onboardingCompleted)
            XCTAssertTrue(store2.userProgress.isPremiumUnlocked)
            XCTAssertEqual(store2.userProgress.playerNotes["locked_gallery"], "Forensic analysis: check weather radar.")
            XCTAssertTrue(store2.userProgress.unlockedAchievementIds.contains(AchievementID.firstContradiction.rawValue))
        }
    }
}
