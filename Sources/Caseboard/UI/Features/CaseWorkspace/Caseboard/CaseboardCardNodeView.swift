import SwiftUI

public struct CaseboardCardNodeView: View {
    public let node: CaseboardNode
    public let title: String
    public let subtitle: String
    public let iconSymbol: String
    public let badgeText: String?
    public let badgeColor: Color
    public let isSelected: Bool
    public let isConnectionTarget: Bool
    public let onSelect: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    private var cardTiltAngle: Double {
        let hash = abs(node.nodeId.hashValue)
        let angles = [-1.5, 0.8, -0.6, 1.2, -1.0, 1.8, -0.4, 0.5]
        return angles[hash % angles.count]
    }

    private var cardBackgroundColor: Color {
        if colorScheme == .dark {
            return Color(red: 28/255, green: 32/255, blue: 40/255)
        } else {
            return Color(red: 252/255, green: 252/255, blue: 253/255)
        }
    }

    private var borderColor: Color {
        if isSelected {
            return ForensicTheme.forensicBlue
        } else if isConnectionTarget {
            return ForensicTheme.forensicGold
        } else if colorScheme == .dark {
            return Color.white.opacity(0.12)
        } else {
            return Color.black.opacity(0.08)
        }
    }

    public var body: some View {
        Button(action: onSelect) {
            ZStack(alignment: .top) {
                cardBody
                    .padding(10)
                    .frame(width: 152, height: 108)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(cardBackgroundColor)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(borderColor, lineWidth: (isSelected || isConnectionTarget) ? 2.5 : 1.0)
                    )
                    .shadow(
                        color: isSelected ? ForensicTheme.forensicBlue.opacity(0.4) : Color.black.opacity(colorScheme == .dark ? 0.4 : 0.12),
                        radius: isSelected ? 8 : 5,
                        x: 0,
                        y: isSelected ? 4 : 2
                    )

                // Pushpin Attachment at top center
                PushPinView(isSelected ? .cobalt : (isConnectionTarget ? .amber : .crimson))
                    .offset(y: -7)
            }
            .rotationEffect(.degrees(cardTiltAngle))
        }
        .buttonStyle(.plain)
    }

    private var cardBody: some View {
        VStack(alignment: .leading, spacing: 5) {
            headerRow

            Text(title)
                .font(.system(size: 11, weight: .bold, design: .default))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(subtitle)
                .font(.system(size: 9, weight: .medium, design: .monospaced))
                .foregroundColor(.secondary)
                .lineLimit(1)

            Spacer(minLength: 0)

            barcodeFooter
        }
    }

    private var headerRow: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(badgeColor.opacity(0.15))
                    .frame(width: 22, height: 22)
                Image(systemName: iconSymbol)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(badgeColor)
            }

            Spacer()

            if let badge = badgeText {
                Text(badge)
                    .font(.system(size: 8, weight: .black, design: .monospaced))
                    .foregroundColor(badgeColor)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 1.5)
                    .background(Capsule().fill(badgeColor.opacity(0.12)))
            }
        }
    }

    private var barcodeFooter: some View {
        HStack(spacing: 3) {
            ForEach(0..<8, id: \.self) { idx in
                Rectangle()
                    .fill(Color.primary.opacity(0.35))
                    .frame(width: idx % 3 == 0 ? 2.0 : 1.0, height: 8)
            }
            Spacer()
            Text(String(node.nodeId.prefix(8)).uppercased())
                .font(.system(size: 7, weight: .bold, design: .monospaced))
                .foregroundColor(.secondary)
        }
    }
}
