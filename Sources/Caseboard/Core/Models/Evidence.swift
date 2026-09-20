import Foundation

public enum EvidenceType: String, Codable, Sendable, CaseIterable {
    case statement = "statement"
    case phoneLog = "phone_log"
    case receipt = "receipt"
    case securityRecord = "security_record"
    case locationData = "location_data"
    case audioTranscript = "audio_transcript"
    case medicalReport = "medical_report"
    case financialRecord = "financial_record"
    case photoMetadata = "photo_metadata"
    case messageThread = "message_thread"
    case timelineEvent = "timeline_event"
    case objectReport = "object_report"
    case backgroundProfile = "background_profile"

    public var sfSymbol: String {
        switch self {
        case .statement: return "quote.bubble.fill"
        case .phoneLog: return "phone.badge.waveform.fill"
        case .receipt: return "doc.text.fill"
        case .securityRecord: return "lock.shield.fill"
        case .locationData: return "location.fill"
        case .audioTranscript: return "waveform.badge.mic"
        case .medicalReport: return "cross.case.fill"
        case .financialRecord: return "banknote.fill"
        case .photoMetadata: return "camera.badge.ellipsis"
        case .messageThread: return "bubble.left.and.bubble.right.fill"
        case .timelineEvent: return "clock.arrow.circlepath"
        case .objectReport: return "magnifyingglass.circle.fill"
        case .backgroundProfile: return "person.text.rectangle.fill"
        }
    }

    public var displayName: String {
        switch self {
        case .statement: return "Witness Statement"
        case .phoneLog: return "Telephony Log"
        case .receipt: return "Transaction Receipt"
        case .securityRecord: return "Access / Security Log"
        case .locationData: return "Geographic Location"
        case .audioTranscript: return "Audio Intercept"
        case .medicalReport: return "Coroner / Medical"
        case .financialRecord: return "Financial Audit"
        case .photoMetadata: return "EXIF Metadata"
        case .messageThread: return "Encrypted Thread"
        case .timelineEvent: return "Chronology Log"
        case .objectReport: return "Physical Artifact"
        case .backgroundProfile: return "Subject Dossier"
        }
    }
}

public enum Reliability: String, Codable, Sendable, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case verified = "verified"

    public var displayName: String {
        switch self {
        case .low: return "Unverified / Contested"
        case .medium: return "Corroborated"
        case .high: return "High Fidelity"
        case .verified: return "Forensically Verified"
        }
    }

    public var colorHex: String {
        switch self {
        case .low: return "#FF453A"
        case .medium: return "#FF9F0A"
        case .high: return "#0A84FF"
        case .verified: return "#34C759"
        }
    }

    public var scoreMultiplier: Double {
        switch self {
        case .low: return 0.75
        case .medium: return 1.0
        case .high: return 1.2
        case .verified: return 1.5
        }
    }
}

public struct MetadataEntry: Codable, Sendable, Hashable {
    public let label: String
    public let value: String

    public init(label: String, value: String) {
        self.label = label
        self.value = value
    }
}

public struct EvidenceItem: Identifiable, Codable, Sendable, Hashable {
    public var id: String { evidenceId }
    public let evidenceId: String
    public let caseId: String
    public let title: String
    public let type: EvidenceType
    public let summary: String
    public let fullText: String
    public let timestamp: String?
    public let source: String
    public let reliability: Reliability
    public let tags: [String]
    public let isKeyEvidence: Bool
    public var isPinned: Bool
    public let relatedSuspectIds: [String]
    public let relatedEvidenceIds: [String]
    public let discoveredInitially: Bool
    public let unlockCondition: String?
    public let metadata: [MetadataEntry]?

    public init(
        evidenceId: String,
        caseId: String,
        title: String,
        type: EvidenceType,
        summary: String,
        fullText: String,
        timestamp: String? = nil,
        source: String,
        reliability: Reliability = .high,
        tags: [String] = [],
        isKeyEvidence: Bool = false,
        isPinned: Bool = false,
        relatedSuspectIds: [String] = [],
        relatedEvidenceIds: [String] = [],
        discoveredInitially: Bool = true,
        unlockCondition: String? = nil,
        metadata: [MetadataEntry]? = nil
    ) {
        self.evidenceId = evidenceId
        self.caseId = caseId
        self.title = title
        self.type = type
        self.summary = summary
        self.fullText = fullText
        self.timestamp = timestamp
        self.source = source
        self.reliability = reliability
        self.tags = tags
        self.isKeyEvidence = isKeyEvidence
        self.isPinned = isPinned
        self.relatedSuspectIds = relatedSuspectIds
        self.relatedEvidenceIds = relatedEvidenceIds
        self.discoveredInitially = discoveredInitially
        self.unlockCondition = unlockCondition
        self.metadata = metadata
    }
}
