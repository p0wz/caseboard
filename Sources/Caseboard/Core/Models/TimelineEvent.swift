import Foundation

public struct TimelineEvent: Identifiable, Codable, Sendable, Hashable {
    public var id: String { eventId }
    public let eventId: String
    public let caseId: String?
    public let title: String
    public let eventDescription: String
    public let timeWindow: String
    public let exactTime: String?
    public let canonicalOrder: Int
    public let sourceEvidenceId: String
    public let isFalseClaim: Bool
    public let dependsOnEvidenceIds: [String]?
    public let conflictsWithEventIds: [String]?

    public init(
        eventId: String,
        caseId: String? = nil,
        title: String,
        eventDescription: String,
        timeWindow: String,
        exactTime: String? = nil,
        canonicalOrder: Int,
        sourceEvidenceId: String,
        isFalseClaim: Bool = false,
        dependsOnEvidenceIds: [String]? = nil,
        conflictsWithEventIds: [String]? = nil
    ) {
        self.eventId = eventId
        self.caseId = caseId
        self.title = title
        self.eventDescription = eventDescription
        self.timeWindow = timeWindow
        self.exactTime = exactTime
        self.canonicalOrder = canonicalOrder
        self.sourceEvidenceId = sourceEvidenceId
        self.isFalseClaim = isFalseClaim
        self.dependsOnEvidenceIds = dependsOnEvidenceIds
        self.conflictsWithEventIds = conflictsWithEventIds
    }
}
