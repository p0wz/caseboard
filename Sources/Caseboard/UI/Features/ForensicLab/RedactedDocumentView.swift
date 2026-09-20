import SwiftUI

public struct RedactedDocumentView: View {
    public let classificationLevel: String
    public let documentTitle: String
    public let dateStamped: String

    @State private var revealedRedactions: Set<Int> = []

    public init(classificationLevel: String = "TOP SECRET // SENSITIVE COMPARTMENTED",
                documentTitle: String = "FINANCIAL AUDIT // SHADOW WIRE TRANSFERS",
                dateStamped: String = "OCTOBER 14, 1998") {
        self.classificationLevel = classificationLevel
        self.documentTitle = documentTitle
        self.dateStamped = dateStamped
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Classified Header Banner
            HStack {
                Text(classificationLevel)
                    .font(.system(size: 8, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.red.opacity(0.85), in: RoundedRectangle(cornerRadius: 3))

                Spacer()

                Text("DATE: \(dateStamped)")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
            }

            // Title & File Number
            VStack(alignment: .leading, spacing: 2) {
                Text(documentTitle)
                    .font(.system(size: 13, weight: .black, design: .monospaced))
                    .foregroundColor(.primary)
                Text("INTELLIGENCE SUMMARY DISPATCH • DEPT REF: 88-X-04")
                    .font(.system(size: 8, weight: .semibold, design: .monospaced))
                    .foregroundColor(.secondary)
            }

            Divider()

            // Document Paragraphs with Redactions
            VStack(alignment: .leading, spacing: 10) {
                Text("Subject arrived at the terminal under the pseudonym ")
                    .font(.system(size: 11, weight: .regular, design: .serif))
                + redactedText(index: 1, hiddenText: "ELIAS VORN", placeholderLength: 10)
                + Text(". Surveillance recorded a meeting with ")
                    .font(.system(size: 11, weight: .regular, design: .serif))
                + redactedText(index: 2, hiddenText: "MARA VOSS", placeholderLength: 9)
                + Text(" at 22:45 hours inside the VIP lounge.")
                    .font(.system(size: 11, weight: .regular, design: .serif))

                Text("A wire transfer totaling ")
                    .font(.system(size: 11, weight: .regular, design: .serif))
                + redactedText(index: 3, hiddenText: "$450,000 USD", placeholderLength: 12)
                + Text(" was routed through Cayman holding accounts, explicitly matching the ledger seized from ")
                    .font(.system(size: 11, weight: .regular, design: .serif))
                + redactedText(index: 4, hiddenText: "SUITE 312 SAFE", placeholderLength: 14)
                + Text(".")
                    .font(.system(size: 11, weight: .regular, design: .serif))
            }
            .lineSpacing(4)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.primary.opacity(0.03))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .strokeBorder(Color.primary.opacity(0.1), lineWidth: 0.8)
                    )
            )

            // Declassify controls & instructions
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 9))
                    Text("TAP BLACKED-OUT BARS TO DECLASSIFY")
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                }
                .foregroundColor(.secondary)

                Spacer()

                Button(action: {
                    withAnimation(.spring(response: 0.35)) {
                        if revealedRedactions.count == 4 {
                            revealedRedactions.removeAll()
                        } else {
                            revealedRedactions = [1, 2, 3, 4]
                        }
                    }
                }) {
                    Text(revealedRedactions.count == 4 ? "RESTORE REDACTIONS" : "DECLASSIFY ALL")
                        .font(.system(size: 9, weight: .black, design: .monospaced))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }

    private func redactedText(index: Int, hiddenText: String, placeholderLength: Int) -> Text {
        let isRevealed = revealedRedactions.contains(index)

        if isRevealed {
            return Text(" \(hiddenText) ")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(.green)
        } else {
            return Text(String(repeating: "█", count: placeholderLength))
                .font(.system(size: 11, weight: .black, design: .monospaced))
                .foregroundColor(.primary)
        }
    }
}
