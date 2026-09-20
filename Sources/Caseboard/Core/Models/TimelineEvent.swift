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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.eventId = try container.decode(String.self, forKey: .eventId)
        self.caseId = try container.decodeIfPresent(String.self, forKey: .caseId)
        self.title = try container.decode(String.self, forKey: .title)
        self.eventDescription = try container.decode(String.self, forKey: .eventDescription)
        self.timeWindow = try container.decode(String.self, forKey: .timeWindow)
        self.exactTime = try container.decodeIfPresent(String.self, forKey: .exactTime)
        self.canonicalOrder = try container.decode(Int.self, forKey: .canonicalOrder)
        self.sourceEvidenceId = try container.decode(String.self, forKey: .sourceEvidenceId)
        self.isFalseClaim = try container.decodeIfPresent(Bool.self, forKey: .isFalseClaim) ?? false
        self.dependsOnEvidenceIds = try container.decodeIfPresent([String].self, forKey: .dependsOnEvidenceIds)
        self.conflictsWithEventIds = try container.decodeIfPresent([String].self, forKey: .conflictsWithEventIds)
    }

    private enum CodingKeys: String, CodingKey {
        case eventId, caseId, title, eventDescription, timeWindow, exactTime, canonicalOrder, sourceEvidenceId, isFalseClaim, dependsOnEvidenceIds, conflictsWithEventIds
    }
}
