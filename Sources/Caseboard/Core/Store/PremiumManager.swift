import Foundation
import StoreKit
import Combine

@MainActor
public final class PremiumManager: ObservableObject {
    public static let shared = PremiumManager()

    public static let fullUnlockProductID = "caseboard_full_unlock"

    @Published public private(set) var isPremium: Bool = false
    @Published public private(set) var product: Product?
    @Published public private(set) var isPurchasing: Bool = false
    @Published public var purchaseErrorMessage: String?

    private var transactionListenerTask: Task<Void, Never>?

    public init() {
        // Initialize from local progress store cache
        self.isPremium = ProgressStore.shared.userProgress.isPremiumUnlocked

        // Listen for StoreKit 2 transactions
        self.transactionListenerTask = listenForTransactions()

        Task {
            await loadProducts()
            await updateEntitlements()
        }
    }

    deinit {
        transactionListenerTask?.cancel()
    }

    // MARK: - Product Loading

    public func loadProducts() async {
        do {
            let products = try await Product.products(for: [Self.fullUnlockProductID])
            self.product = products.first
        } catch {
            print("[PremiumManager] Failed to fetch product: \(error)")
        }
    }

    // MARK: - Purchase

    public func purchase() async -> Bool {
        guard let product = product else {
            // If offline or product unavailable in sandbox without StoreKit Configuration, offer debug option
            purchaseErrorMessage = "Store connection currently unavailable. Check internet or local configuration."
            return false
        }

        isPurchasing = true
        purchaseErrorMessage = nil
        defer { isPurchasing = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                self.isPremium = true
                ProgressStore.shared.setPremiumUnlocked(true)
                HapticsManager.shared.caseSolved()
                return true

            case .userCancelled:
                return false

            case .pending:
                purchaseErrorMessage = "Purchase is pending authorization."
                return false

            @unknown default:
                return false
            }
        } catch {
            purchaseErrorMessage = error.localizedDescription
            return false
        }
    }

    // MARK: - Restore Purchases

    public func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updateEntitlements()
        } catch {
            purchaseErrorMessage = "Failed to restore transactions: \(error.localizedDescription)"
        }
    }

    // MARK: - Entitlement Verification

    public func updateEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == Self.fullUnlockProductID && transaction.revocationDate == nil {
                    self.isPremium = true
                    ProgressStore.shared.setPremiumUnlocked(true)
                    return
                }
            }
        }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    await MainActor.run {
                        if transaction.productID == Self.fullUnlockProductID {
                            self.isPremium = true
                            ProgressStore.shared.setPremiumUnlocked(true)
                        }
                    }
                }
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let safe):
            return safe
        }
    }

    // MARK: - Debug Override

    public func debugSetPremium(_ active: Bool) {
        self.isPremium = active
        ProgressStore.shared.setPremiumUnlocked(active)
    }
}
