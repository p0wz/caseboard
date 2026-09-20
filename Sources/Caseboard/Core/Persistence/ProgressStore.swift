import Foundation
import Combine

@MainActor
public final class ProgressStore: ObservableObject {
    public static let shared = ProgressStore()

    @Published public private(set) var userProgress: UserProgress
    @Published public var recentlyUnlockedAchievement: AchievementID?

    private let storageURL: URL
    private let fileManager = FileManager.default

    public init(customStorageURL: URL? = nil) {
        if let custom = customStorageURL {
            self.storageURL = custom
        } else {
            let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            let dir = appSupport.appendingPathComponent("Caseboard", isDirectory: true)
            try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
            self.storageURL = dir.appendingPathComponent("user_progress.json")
        }

        // Load persisted state or create initial
        if let data = try? Data(contentsOf: storageURL),
           let loaded = try? JSONDecoder().decode(UserProgress.self, from: data) {
            self.userProgress = loaded
        } else {
            self.userProgress = UserProgress()
        }
    }

    // MARK: - Persistence Engine

    public func save() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            let data = try encoder.encode(userProgress)

            let tempURL = storageURL.deletingLastPathComponent().appendingPathComponent("temp_\(UUID().uuidString).json")
            try data.write(to: tempURL, options: .atomic)

            if fileManager.fileExists(atPath: storageURL.path) {
                _ = try fileManager.replaceItemAt(storageURL, withItemAt: tempURL)
            } else {
                try fileManager.moveItem(at: tempURL, to: storageURL)
            }
        } catch {
            print("[ProgressStore] Error saving progress: \(error)")
        }
    }

    // MARK: - Onboarding & Premium

    public func completeOnboarding() {
        userProgress.onboardingCompleted = true
        save()
    }

    public func setPremiumUnlocked(_ unlocked: Bool) {
        userProgress.isPremiumUnlocked = unlocked
        save()
    }

    // MARK: - Case Progress

    public func progress(for caseId: String) -> CaseProgress {
        if let existing = userProgress.caseProgress[caseId] {
            return existing
        }
        let fresh = CaseProgress(caseId: caseId)
        userProgress.caseProgress[caseId] = fresh
        return fresh
    }

    public func markEvidenceRead(caseId: String, evidenceId: String) {
        var cp = progress(for: caseId)
        if !cp.readEvidenceIds.contains(evidenceId) {
            cp.readEvidenceIds.insert(evidenceId)
            if cp.status == .newCase {
                cp.status = .inProgress
            }
            userProgress.caseProgress[caseId] = cp
            save()

            // Check 100 evidence achievement
            let totalRead = userProgress.caseProgress.values.reduce(0) { $0 + $1.readEvidenceIds.count }
            if totalRead >= 100 {
                unlockAchievement(.hundredEvidenceReviewed)
            }
        }
    }

    public func togglePinNode(caseId: String, nodeId: String, itemType: NodeType, position: CGPoint? = nil) {
        var cp = progress(for: caseId)
        if let idx = cp.pinnedNodes.firstIndex(where: { $0.nodeId == nodeId }) {
            cp.pinnedNodes.remove(at: idx)
        } else {
            let x = position != nil ? Double(position!.x) : Double.random(in: 80...320)
            let y = position != nil ? Double(position!.y) : Double.random(in: 120...500)
            cp.pinnedNodes.append(CaseboardNode(nodeId: nodeId, itemType: itemType, x: x, y: y))
        }
        userProgress.caseProgress[caseId] = cp
        save()
    }

    public func updateNodePosition(caseId: String, nodeId: String, x: Double, y: Double) {
        var cp = progress(for: caseId)
        if let idx = cp.pinnedNodes.firstIndex(where: { $0.nodeId == nodeId }) {
            cp.pinnedNodes[idx].x = x
            cp.pinnedNodes[idx].y = y
            userProgress.caseProgress[caseId] = cp
            save()
        }
    }

    public func addConnection(caseId: String, connection: CaseboardConnection) {
        var cp = progress(for: caseId)
        if let existingIdx = cp.connections.firstIndex(where: { $0.connects(connection.sourceId, connection.targetId) }) {
            cp.connections[existingIdx] = connection
        } else {
            cp.connections.append(connection)
        }
        userProgress.caseProgress[caseId] = cp
        save()
    }

    public func recordDiscoveredContradiction(caseId: String, contradictionId: String) {
        var cp = progress(for: caseId)
        if !cp.discoveredContradictions.contains(contradictionId) {
            cp.discoveredContradictions.append(contradictionId)
            userProgress.discoveredContradictionIds.insert(contradictionId)
            userProgress.caseProgress[caseId] = cp
            userProgress.totalScore += 250
            recalculateRank()
            save()

            unlockAchievement(.firstContradiction)
            if contradictionId.contains("alibi") {
                unlockAchievement(.brokeAnAlibi)
            }
        }
    }

    public func recordWrongAttempt(caseId: String) {
        var cp = progress(for: caseId)
        cp.wrongAttemptsCount += 1
        userProgress.caseProgress[caseId] = cp
        save()
    }

    public func recordHintUsed(caseId: String, hintTier: String) {
        var cp = progress(for: caseId)
        if !cp.hintsUsed.contains(hintTier) {
            cp.hintsUsed.append(hintTier)
            userProgress.caseProgress[caseId] = cp
            save()
        }
    }

    public func recordCaseSolved(
        caseId: String,
        result: AccusationResult,
        elapsedSeconds: Int
    ) {
        var cp = progress(for: caseId)
        cp.status = result.isPerfectSolve ? .perfect : .solved
        cp.bestGrade = result.grade
        cp.elapsedSeconds = elapsedSeconds
        cp.solvedDate = Date()
        userProgress.caseProgress[caseId] = cp

        userProgress.totalScore += result.finalScore
        recalculateRank()

        // Daily streak tracking
        if caseId.hasPrefix("daily_") {
            let todayStr = DailyCaseGenerator.dateString(from: Date())
            if userProgress.lastDailyCompletedDate != todayStr {
                userProgress.dailyStreak += 1
                userProgress.lastDailyCompletedDate = todayStr
                if userProgress.dailyStreak >= 7 {
                    unlockAchievement(.sevenDayStreak)
                }
            }
        }

        // Achievements check
        if result.hintsUsedCount == 0 {
            unlockAchievement(.noHintsNeeded)
        }
        if result.isPerfectSolve {
            unlockAchievement(.perfectCase)
        }
        if result.grade == .sPlus {
            unlockAchievement(.sPlusAnalyst)
        }

        checkArchiveCompletionAchievements()
        save()
    }

    private func checkArchiveCompletionAchievements() {
        let freeIds = ["locked_gallery", "rain_at_mercer_street", "the_vanishing_courier", "room_312"]
        let allFreeSolved = freeIds.allSatisfy { id in
            let st = userProgress.caseProgress[id]?.status
            return st == .solved || st == .perfect
        }
        if allFreeSolved {
            unlockAchievement(.solvedAllFreeCases)
        }

        let premiumIds = [
            "the_silent_auction", "cold_signal", "the_ninth_witness", "glass_house",
            "the_missing_minute", "the_harbor_alibi", "dead_drop", "the_last_reservation",
            "the_blue_umbrella", "static_on_line_seven", "the_founders_exit", "the_ash_ledger"
        ]
        let allPremSolved = premiumIds.allSatisfy { id in
            let st = userProgress.caseProgress[id]?.status
            return st == .solved || st == .perfect
        }
        if allPremSolved {
            unlockAchievement(.solvedAllPremiumCases)
        }
    }

    public func unlockAchievement(_ id: AchievementID) {
        if !userProgress.unlockedAchievementIds.contains(id.rawValue) {
            userProgress.unlockedAchievementIds.insert(id.rawValue)
            recentlyUnlockedAchievement = id
            userProgress.totalScore += 150
            recalculateRank()
            save()
        }
    }

    private func recalculateRank() {
        let score = userProgress.totalScore
        for rank in AnalystRank.allCases.reversed() {
            if score >= rank.requiredScore {
                userProgress.analystRank = rank
                break
            }
        }
    }

    // MARK: - Settings

    public func updateSettings(_ settings: SettingsModel) {
        userProgress.settings = settings
        save()
    }

    // MARK: - Debug Tools

    public func debugResetAll() {
        userProgress = UserProgress()
        save()
    }

    public func debugUnlockAllPremium() {
        userProgress.isPremiumUnlocked = true
        save()
    }
}
