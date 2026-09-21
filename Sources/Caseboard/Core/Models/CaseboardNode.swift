import Foundation
import CoreGraphics

public enum NodeType: String, Codable, Sendable {
    case evidence = "evidence"
    case suspect = "suspect"
}

public struct CaseboardNode: Identifiable, Codable, Sendable, Hashable {
    public var id: String { nodeId }
    public let nodeId: String
    public let itemType: NodeType
    public var x: Double
    public var y: Double
    public var isPinned: Bool
    public var isHighlighted: Bool

    public init(
        nodeId: String,
        itemType: NodeType,
        x: Double,
        y: Double,
        isPinned: Bool = true,
        isHighlighted: Bool = false
    ) {
        self.nodeId = nodeId
        self.itemType = itemType
        self.x = x
        self.y = y
        self.isPinned = isPinned
        self.isHighlighted = isHighlighted
    }
}

public enum ConnectionType: String, Codable, Sendable, CaseIterable {
    case supports = "supports"
    case contradicts = "contradicts"
    case placesAtScene = "places_at_scene"
    case establishesMotive = "establishes_motive"
    case establishesMeans = "establishes_means"
    case establishesOpportunity = "establishes_opportunity"
    case weakensAlibi = "weakens_alibi"
    case confirmsTimeline = "confirms_timeline"

    public var displayName: String {
        switch self {
        case .supports: return "Corroborates / Supports"
        case .contradicts: return "Directly Contradicts"
        case .placesAtScene: return "Places at Scene"
        case .establishesMotive: return "Establishes Motive"
        case .establishesMeans: return "Establishes Means"
        case .establishesOpportunity: return "Establishes Opportunity"
        case .weakensAlibi: return "Weakens / Breaks Alibi"
        case .confirmsTimeline: return "Confirms Timeline Window"
        }
    }

    public var threadColorHex: String {
        switch self {
        case .supports: return "#34C759"
        case .contradicts: return "#FF453A"
        case .placesAtScene: return "#FF9F0A"
        case .establishesMotive: return "#AF52DE"
        case .establishesMeans: return "#5856D6"
        case .establishesOpportunity: return "#0A84FF"
        case .weakensAlibi: return "#FF375F"
        case .confirmsTimeline: return "#30B0C7"
        }
    }

    public var sfSymbol: String {
        switch self {
        case .supports: return "arrow.right.circle.fill"
        case .contradicts: return "bolt.horizontal.circle.fill"
        case .placesAtScene: return "location.circle.fill"
        case .establishesMotive: return "flame.circle.fill"
        case .establishesMeans: return "wrench.and.screwdriver.fill"
        case .establishesOpportunity: return "door.left.hand.open"
        case .weakensAlibi: return "shield.slash.fill"
        case .confirmsTimeline: return "clock.fill"
        }
    }
}

public enum ConnectionEvaluation: String, Codable, Sendable {
    case untested = "untested"
    case correct = "correct"
    case incorrect = "incorrect"
    case partial = "partial"
    case critical = "critical"

    public var badgeLabel: String {
        switch self {
        case .untested: return "Hypothesis"
        case .correct: return "Forensically Valid"
        case .incorrect: return "Spurious Link"
        case .partial: return "Partial Deduction"
        case .critical: return "Critical Breakthrough"
        }
    }
}

public struct CaseboardConnection: Identifiable, Codable, Sendable, Hashable {
    public var id: String { connectionId }
    public let connectionId: String
    public let sourceId: String
    public let targetId: String
    public var connectionType: ConnectionType
    public var evaluation: ConnectionEvaluation
    public var notes: String?
    public var discoveredContradictionId: String?

    public init(
        connectionId: String = UUID().uuidString,
        sourceId: String,
        targetId: String,
        connectionType: ConnectionType,
        evaluation: ConnectionEvaluation = .untested,
        notes: String? = nil,
        discoveredContradictionId: String? = nil
    ) {
        self.connectionId = connectionId
        self.sourceId = sourceId
        self.targetId = targetId
        self.connectionType = connectionType
        self.evaluation = evaluation
        self.notes = notes
        self.discoveredContradictionId = discoveredContradictionId
    }

    /// Check if this connection spans the given two node IDs regardless of direction
    public func connects(_ idA: String, _ idB: String) -> Bool {
        return (sourceId == idA && targetId == idB) || (sourceId == idB && targetId == idA)
    }
}
