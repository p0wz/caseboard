import Foundation

public struct TimelineConflict: Sendable, Hashable, Identifiable {
    public var id: String { "\(eventId)_\(conflictReason)" }
    public let eventId: String
    public let eventTitle: String
    public let conflictReason: String

    public init(eventId: String, eventTitle: String, conflictReason: String) {
        self.eventId = eventId
        self.eventTitle = eventTitle
        self.conflictReason = conflictReason
    }
}

public struct TimelineValidationResult: Sendable, Equatable {
    public let isValid: Bool
    public let accuracyPercentage: Int
    public let conflicts: [TimelineConflict]
    public let discoveredFalseClaims: [String]

    public init(
        isValid: Bool,
        accuracyPercentage: Int,
        conflicts: [TimelineConflict] = [],
        discoveredFalseClaims: [String] = []
    ) {
        self.isValid = isValid
        self.accuracyPercentage = accuracyPercentage
        self.conflicts = conflicts
        self.discoveredFalseClaims = discoveredFalseClaims
    }
}

public struct TimelineEngine: Sendable {
    public init() {}

    /// Validates the sequence of timeline event IDs submitted by the user.
    public func validateTimeline(
        orderedEventIds: [String],
        against canonicalEvents: [TimelineEvent]
    ) -> TimelineValidationResult {
        guard !orderedEventIds.isEmpty else {
            return TimelineValidationResult(isValid: false, accuracyPercentage: 0, conflicts: [], discoveredFalseClaims: [])
        }

        let eventMap = Dictionary(uniqueKeysWithValues: canonicalEvents.map { ($0.eventId, $0) })
        var conflicts: [TimelineConflict] = []
        var falseClaims: [String] = []
        var correctOrderCount = 0

        // 1. Detect false claims included as truth
        for id in orderedEventIds {
            if let event = eventMap[id], event.isFalseClaim {
                falseClaims.append(event.title)
                conflicts.append(TimelineConflict(
                    eventId: id,
                    eventTitle: event.title,
                    conflictReason: "This claim contradicts physical telemetry and cannot occupy a verified slot."
                ))
            }
        }

        // 2. Validate pairwise chronological order
        for i in 0..<orderedEventIds.count {
            guard let eventA = eventMap[orderedEventIds[i]] else { continue }

            for j in (i + 1)..<orderedEventIds.count {
                guard let eventB = eventMap[orderedEventIds[j]] else { continue }

                // Check if eventA has a higher canonicalOrder than eventB (i.e. out of chronological sequence)
                if eventA.canonicalOrder > eventB.canonicalOrder && !eventA.isFalseClaim && !eventB.isFalseClaim {
                    conflicts.append(TimelineConflict(
                        eventId: eventA.eventId,
                        eventTitle: eventA.title,
                        conflictReason: "Occurred after '\(eventB.title)' according to forensic records."
                    ))
                }

                // Check explicit conflict rules
                if let conflictsWith = eventA.conflictsWithEventIds, conflictsWith.contains(eventB.eventId) {
                    conflicts.append(TimelineConflict(
                        eventId: eventA.eventId,
                        eventTitle: eventA.title,
                        conflictReason: "Mutually exclusive with '\(eventB.title)'."
                    ))
                }
            }
        }

        // 3. Compute accuracy percentage based on valid non-false items in canonical sequence
        let validCanonical = canonicalEvents.filter { !$0.isFalseClaim }.sorted { $0.canonicalOrder < $1.canonicalOrder }
        let validOrderedIds = orderedEventIds.filter { id in
            guard let ev = eventMap[id] else { return false }
            return !ev.isFalseClaim
        }

        for (idx, id) in validOrderedIds.enumerated() {
            if idx < validCanonical.count && validCanonical[idx].eventId == id {
                correctOrderCount += 1
            }
        }

        let totalExpected = max(1, validCanonical.count)
        let accuracy = min(100, Int((Double(correctOrderCount) / Double(totalExpected)) * 100.0))
        let isValid = conflicts.isEmpty && accuracy >= 90

        return TimelineValidationResult(
            isValid: isValid,
            accuracyPercentage: accuracy,
            conflicts: conflicts,
            discoveredFalseClaims: falseClaims
        )
    }
}
