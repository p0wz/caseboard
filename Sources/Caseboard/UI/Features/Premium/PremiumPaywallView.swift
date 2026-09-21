import SwiftUI
import StoreKit

public struct PremiumPaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var premiumManager = PremiumManager.shared
    @State private var selectedLegalDoc: LegalDocumentType? = nil

    public init() {}

    private let features = [
        ("All 12 Premier Cases", "Full access to high-stakes homicides, corporate fraud, and espionage dossiers.", "archivebox.fill"),
        ("Unlimited Daily Archive", "Play past daily cold cases anytime offline without calendar restrictions.", "calendar.badge.clock"),
        ("Expert S+ Forensic Grading", "Unlock advanced analytical rubrics and master investigator scoring.", "rosette"),
        ("Zero Ads & No Subscriptions", "One single purchase. Yours permanently offline forever.", "lock.shield.fill")
    ]

    public var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Crown Hero
                ZStack {
                    Circle()
                        .fill(ForensicTheme.forensicGold.opacity(0.18))
                        .frame(width: 80, height: 80)
                    Image(systemName: "crown.fill")
                        .font(.system(size: 40))
                        .foregroundColor(ForensicTheme.forensicGold)
                }
                .padding(.top, 16)

                VStack(spacing: 6) {
                    Text("FULL ARCHIVE UNLOCK")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(ForensicTheme.forensicGold)

                    Text("Unlock Premier Intelligence Files")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text("Expand your forensic jurisdiction with all 12 premier cases and unlimited daily archives.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                // Features list
                ForensicCard {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(features, id: \.0) { title, desc, icon in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: icon)
                                    .font(.system(size: 20))
                                    .foregroundColor(ForensicTheme.forensicBlue)
                                    .frame(width: 28)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(title)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text(desc)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)

                Spacer()

                // Purchase CTA
                VStack(spacing: 12) {
                    if let err = premiumManager.purchaseErrorMessage {
                        Text(err)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    Button {
                        Task {
                            let success = await premiumManager.purchase()
                            if success {
                                dismiss()
                            }
                        }
                    } label: {
                        HStack {
                            if premiumManager.isPurchasing {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Unlock Full Archive — \(premiumManager.product?.displayPrice ?? "$4.99")")
                                    .fontWeight(.bold)
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(ForensicTheme.forensicBlue))
                    }
                    .disabled(premiumManager.isPurchasing)

                    Button("Restore Previous Purchases") {
                        Task {
                            await premiumManager.restorePurchases()
                        }
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)

                    HStack(spacing: 12) {
                        Button("Terms of Service") {
                            selectedLegalDoc = .termsOfService
                        }
                        Text("•")
                            .foregroundColor(.secondary.opacity(0.5))
                        Button("Privacy Policy") {
                            selectedLegalDoc = .privacyPolicy
                        }
                    }
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .sheet(item: $selectedLegalDoc) { doc in
                LegalDocumentModalView(documentType: doc)
            }
        }
    }
}
