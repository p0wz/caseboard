import SwiftUI

public enum LegalDocumentType: String, Identifiable {
    case privacyPolicy = "Privacy Policy"
    case termsOfService = "Terms of Service (EULA)"

    public var id: String { rawValue }
}

public struct LegalDocumentModalView: View {
    @Environment(\.dismiss) private var dismiss
    public let documentType: LegalDocumentType

    public init(documentType: LegalDocumentType) {
        self.documentType = documentType
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    switch documentType {
                    case .privacyPolicy:
                        privacyPolicyContent
                    case .termsOfService:
                        termsOfServiceContent
                    }
                }
                .padding(20)
            }
            .navigationTitle(documentType.rawValue)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    // MARK: - Privacy Policy Content

    private var privacyPolicyContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                Text("Effective Date: April 2026")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("1. Complete Offline Architecture")
                    .font(.headline)
                Text("Caseboard is architected with a strict privacy-first foundation. The application operates entirely offline. It does not communicate with external analytics servers, user tracking services, remote databases, or cloud backends.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("2. Zero Data Collection & Tracking")
                    .font(.headline)
                Text("We do not collect, transmit, store, or sell any personal data whatsoever. Caseboard does not collect names, email addresses, IP addresses, advertising identifiers (IDFA), or location information. As declared in our Apple Privacy Manifest (PrivacyInfo.xcprivacy), NSPrivacyTracking is set to false and NSPrivacyCollectedDataTypes is completely empty.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("3. Local On-Device Storage")
                    .font(.headline)
                Text("All detective work—including solved case states, player notes, evidence connections, and unlocked achievements—is stored exclusively on your local device using Apple's standard on-device storage APIs (UserDefaults for preference toggles and local JSON disk storage for game state).")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Group {
                Text("4. In-App Purchases & Apple StoreKit")
                    .font(.headline)
                Text("Any in-app purchase transactions are processed directly by Apple via StoreKit 2. Caseboard never receives or handles your credit card or financial account numbers. All billing and transaction security are handled exclusively by Apple Inc.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("5. Contact & Inquiries")
                    .font(.headline)
                Text("If you have any questions regarding Caseboard's privacy architecture, please submit an issue on our GitHub repository or contact the lead developer at support@caseboard.app.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }

    // MARK: - Terms of Service / EULA Content

    private var termsOfServiceContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                Text("Standard End User License Agreement (EULA)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("1. Agreement to Terms")
                    .font(.headline)
                Text("By downloading, installing, or playing Caseboard: Criminal Deduction, you agree to be bound by these Terms of Service and Apple's Standard Licensed Application End User License Agreement (EULA).")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("2. Intellectual Property & Game License")
                    .font(.headline)
                Text("All detective scenarios, case files, character dossiers, algorithmic deduction trees, and artwork are proprietary intellectual property. You are granted a personal, non-exclusive, non-transferable revocable license for entertainment purposes.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("3. In-App Purchases & Lifetime Unlocks")
                    .font(.headline)
                Text("The 'Full Archive Access' in-app purchase is a non-consumable, one-time lifetime unlock. It provides permanent access to all premier case files and daily cold case archives without recurring subscription fees. You may restore this purchase at any time across all iOS devices associated with your Apple ID using the 'Restore Purchases' feature.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Group {
                Text("4. Disclaimer of Warranty")
                    .font(.headline)
                Text("Caseboard is provided on an 'AS IS' and 'AS AVAILABLE' basis without warranties of any kind. All criminal cases, persons, and organizations depicted are entirely fictional. Any resemblance to real persons or events is purely coincidental.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("5. Governing Law")
                    .font(.headline)
                Text("These terms shall be governed by and construed in accordance with the laws of the applicable jurisdiction, consistent with Apple's standard App Store terms.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
