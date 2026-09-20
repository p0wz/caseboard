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

    public var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: iconSymbol)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(ForensicTheme.forensicBlue)

                    Spacer()

                    if let badge = badgeText {
                        Text(badge)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(badgeColor)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(badgeColor.opacity(0.15)))
                    }
                }

                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(subtitle)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(10)
            .frame(width: 145, height: 95)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.secondary.opacity(0.12))
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(
                        isSelected ? ForensicTheme.forensicBlue : (isConnectionTarget ? ForensicTheme.forensicGold : Color.white.opacity(0.18)),
                        lineWidth: isSelected || isConnectionTarget ? 2.5 : 1
                    )
            )
            .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}
