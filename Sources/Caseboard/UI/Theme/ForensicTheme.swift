import SwiftUI

public enum ForensicTheme {
    // MARK: - Semantic Colors

    public static let backgroundLight = Color(red: 246/255, green: 247/255, blue: 249/255)
    public static let backgroundDark = Color(red: 18/255, green: 20/255, blue: 24/255)

    public static let cardLight = Color.white.opacity(0.85)
    public static let cardDark = Color(red: 28/255, green: 32/255, blue: 38/255).opacity(0.85)

    public static let forensicBlue = Color(red: 10/255, green: 132/255, blue: 255/255)
    public static let forensicGold = Color(red: 255/255, green: 215/255, blue: 0/255)
    public static let criticalRed = Color(red: 255/255, green: 69/255, blue: 58/255)
    public static let verifiedGreen = Color(red: 52/255, green: 199/255, blue: 89/255)
    public static let graphite = Color(red: 142/255, green: 142/255, blue: 147/255)

    public static func backgroundColor(for scheme: ColorScheme) -> Color {
        scheme == .dark ? backgroundDark : backgroundLight
    }

    public static func cardBackground(for scheme: ColorScheme) -> Color {
        scheme == .dark ? cardDark : cardLight
    }

    public static func hairlineBorder(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.08)
    }
}

// MARK: - Reusable UI Components

public struct ForensicCard<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    private let content: Content
    private let cornerRadius: CGFloat

    public init(cornerRadius: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    public var body: some View {
        content
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(ForensicTheme.cardBackground(for: colorScheme))
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(ForensicTheme.hairlineBorder(for: colorScheme), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 10, x: 0, y: 4)
    }
}

public struct FrostedBadge: View {
    public let title: String
    public let sfSymbol: String?
    public let color: Color

    public init(title: String, sfSymbol: String? = nil, color: Color = ForensicTheme.forensicBlue) {
        self.title = title
        self.sfSymbol = sfSymbol
        self.color = color
    }

    public var body: some View {
        HStack(spacing: 5) {
            if let sfSymbol = sfSymbol {
                Image(systemName: sfSymbol)
                    .font(.system(size: 11, weight: .semibold))
            }
            Text(title)
                .font(.system(size: 12, weight: .semibold))
        }
        .foregroundColor(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(color.opacity(0.15))
        )
        .overlay(
            Capsule()
                .strokeBorder(color.opacity(0.3), lineWidth: 0.75)
        )
    }
}

public struct MetricPill: View {
    public let label: String
    public let value: String
    public let sfSymbol: String?

    public init(label: String, value: String, sfSymbol: String? = nil) {
        self.label = label
        self.value = value
        self.sfSymbol = sfSymbol
    }

    public var body: some View {
        HStack(spacing: 6) {
            if let sfSymbol = sfSymbol {
                Image(systemName: sfSymbol)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(ForensicTheme.forensicBlue)
            }
            VStack(alignment: .leading, spacing: 1) {
                Text(label.uppercased())
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(size: 13, weight: .semibold))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
        )
    }
}

public struct ConnectionLineShape: Shape {
    public var start: CGPoint
    public var end: CGPoint
    public var curvature: CGFloat

    public init(start: CGPoint, end: CGPoint, curvature: CGFloat = 0.2) {
        self.start = start
        self.end = end
        self.curvature = curvature
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)

        let dx = end.x - start.x
        let dy = end.y - start.y
        let midX = (start.x + end.x) / 2
        let midY = (start.y + end.y) / 2

        // Perpendicular offset for organic Bezier curve
        let controlPoint = CGPoint(
            x: midX - (dy * curvature),
            y: midY + (dx * curvature)
        )

        path.addQuadCurve(to: end, control: controlPoint)
        return path
    }
}

// MARK: - Cross-Platform Compatibility Modifiers

extension View {
    @ViewBuilder
    public func forensicInlineTitle() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }

    @ViewBuilder
    public func forensicInsetGrouped() -> some View {
        #if os(iOS)
        self.listStyle(.insetGrouped)
        #else
        self.listStyle(.inset)
        #endif
    }
}
