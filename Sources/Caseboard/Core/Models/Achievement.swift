import Foundation

public enum AchievementID: String, Codable, Sendable, CaseIterable {
    case firstContradiction = "first_contradiction"
    case brokeAnAlibi = "broke_an_alibi"
    case noHintsNeeded = "no_hints_needed"
    case perfectCase = "perfect_case"
    case timelineMaster = "timeline_master"
    case motiveHunter = "motive_hunter"
    case meansEstablished = "means_established"
    case opportunityLocked = "opportunity_locked"
    case sevenDayStreak = "seven_day_streak"
    case hundredEvidenceReviewed = "hundred_evidence_reviewed"
    case sPlusAnalyst = "s_plus_analyst"
    case solvedAllFreeCases = "solved_all_free_cases"
    case solvedAllPremiumCases = "solved_all_premium_cases"

    public var title: String {
        switch self {
        case .firstContradiction: return "First Contradiction"
        case .brokeAnAlibi: return "Alibi Shattered"
        case .noHintsNeeded: return "Pure Deduction"
        case .perfectCase: return "Flawless File"
        case .timelineMaster: return "Chronology Reconstructed"
        case .motiveHunter: return "Motive Exposed"
        case .meansEstablished: return "Instrument Identified"
        case .opportunityLocked: return "Window of Action"
        case .sevenDayStreak: return "7-Day Cold Case Streak"
        case .hundredEvidenceReviewed: return "100 Evidence Reviewed"
        case .sPlusAnalyst: return "S+ Forensic Virtuoso"
        case .solvedAllFreeCases: return "Free Archive Cleared"
        case .solvedAllPremiumCases: return "Master of Cold Cases"
        }
    }

    public var description: String {
        switch self {
        case .firstContradiction: return "Discovered your first formal contradiction on the caseboard."
        case .brokeAnAlibi: return "Exposed a fabricated suspect alibi with forensic records."
        case .noHintsNeeded: return "Solved a complete case without requesting forensic nudges."
        case .perfectCase: return "Achieved a perfect solve with zero spurious connections."
        case .timelineMaster: return "Reconstructed an entire case timeline without chronological conflict."
        case .motiveHunter: return "Identified the definitive psychological or financial motive."
        case .meansEstablished: return "Proved the exact mechanism used to commit the offense."
        case .opportunityLocked: return "Isolated the physical and temporal window of the culprit."
        case .sevenDayStreak: return "Maintained a 7-day daily cold case streak."
        case .hundredEvidenceReviewed: return "Read and analyzed 100 individual evidence items."
        case .sPlusAnalyst: return "Received the prestigious S+ grade on any advanced or expert case."
        case .solvedAllFreeCases: return "Solved the tutorial and all three core free cases."
        case .solvedAllPremiumCases: return "Solved all 12 premier intelligence case files."
        }
    }

    public var sfSymbol: String {
        switch self {
        case .firstContradiction: return "bolt.fill"
        case .brokeAnAlibi: return "shield.slash.fill"
        case .noHintsNeeded: return "brain.head.profile"
        case .perfectCase: return "sparkles"
        case .timelineMaster: return "clock.arrow.circlepath"
        case .motiveHunter: return "flame.fill"
        case .meansEstablished: return "wrench.and.screwdriver.fill"
        case .opportunityLocked: return "door.left.hand.open"
        case .sevenDayStreak: return "calendar.badge.clock"
        case .hundredEvidenceReviewed: return "doc.text.magnifyingglass"
        case .sPlusAnalyst: return "crown.fill"
        case .solvedAllFreeCases: return "folder.fill.badge.checkmark"
        case .solvedAllPremiumCases: return "archivebox.fill"
        }
    }

    public var category: String {
        switch self {
        case .firstContradiction, .brokeAnAlibi, .motiveHunter, .meansEstablished, .opportunityLocked:
            return "Deduction"
        case .timelineMaster:
            return "Chronology"
        case .noHintsNeeded, .perfectCase, .sPlusAnalyst:
            return "Mastery"
        case .sevenDayStreak, .hundredEvidenceReviewed:
            return "Dedication"
        case .solvedAllFreeCases, .solvedAllPremiumCases:
            return "Archive"
        }
    }
}

public struct Achievement: Identifiable, Codable, Sendable, Hashable {
    public var id: String { achievementId.rawValue }
    public let achievementId: AchievementID
    public var isUnlocked: Bool
    public var unlockedDate: Date?

    public init(achievementId: AchievementID, isUnlocked: Bool = false, unlockedDate: Date? = nil) {
        self.achievementId = achievementId
        self.isUnlocked = isUnlocked
        self.unlockedDate = unlockedDate
    }
}
