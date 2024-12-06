import StoreKit
import Foundation

@MainActor
class SubscriptionService {
    static let shared = SubscriptionService()
    
    private let defaults = UserDefaults.standard
    private let subscriptionKey = "user_subscription"
    private let expiryKey = "subscription_expiry"
    
    private init() {}
    
    struct StoredSubscription: Codable {
        let tier: SubscriptionManager.SubscriptionTier
        let expiryDate: Date
        let productId: String
        let originalTransactionId: String?
    }
    
    @Published private(set) var products: [Product] = []
    
    func loadProducts() async throws {
        let productIdentifiers = ["com.cloudscanner.premium.monthly", 
                                "com.cloudscanner.premium.yearly"]
        products = try await Product.products(for: productIdentifiers)
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            let subscription = try await verifyReceipt(transaction)
            storeSubscription(subscription)
            await transaction.finish()
        case .userCancelled:
            throw SubscriptionError.userCancelled
        case .pending:
            throw SubscriptionError.pending
        @unknown default:
            throw SubscriptionError.unknown
        }
    }
    
    func restorePurchases() async throws {
        for await verification in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(verification) {
                let subscription = try await verifyReceipt(transaction)
                storeSubscription(subscription)
                await transaction.finish()
            }
        }
    }
    
    enum SubscriptionError: LocalizedError {
        case userCancelled
        case pending
        case unknown
        case verificationFailed
        
        var errorDescription: String? {
            switch self {
            case .userCancelled:
                return "Purchase was cancelled"
            case .pending:
                return "Purchase is pending approval"
            case .unknown:
                return "An unknown error occurred"
            case .verificationFailed:
                return "Purchase verification failed"
            }
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw SubscriptionError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
    
    func verifyReceipt(_ transaction: StoreKit.Transaction) async throws -> StoredSubscription {
        // TODO: Implement server-side receipt verification
        // For now, we'll simulate verification
        try await Task.sleep(until: .now + .seconds(1), clock: .continuous)
        
        let expiryDate = Calendar.current.date(
            byAdding: .year,
            value: 1,
            to: transaction.purchaseDate
        ) ?? Date()
        
        // Safely handle the optional transaction ID using Optional(originalID)
        let originalId: String? = Optional(transaction.originalID).map(String.init)
        
        return StoredSubscription(
            tier: .premium,
            expiryDate: expiryDate,
            productId: String(transaction.productID),  // Safe conversion of productID
            originalTransactionId: originalId
        )
    }
    
    func storeSubscription(_ subscription: StoredSubscription) {
        if let encoded = try? JSONEncoder().encode(subscription) {
            defaults.set(encoded, forKey: subscriptionKey)
            let timestamp = subscription.expiryDate.timeIntervalSince1970
            defaults.set(timestamp, forKey: expiryKey)
        }
    }
    
    func loadStoredSubscription() -> StoredSubscription? {
        guard let data = defaults.data(forKey: subscriptionKey),
              let subscription = try? JSONDecoder().decode(StoredSubscription.self, from: data) else {
            return nil
        }
        return subscription
    }
    
    func getExpiryTimestamp() -> Double? {
        return defaults.double(forKey: expiryKey)
    }
    
    func clearSubscription() {
        defaults.removeObject(forKey: subscriptionKey)
        defaults.removeObject(forKey: expiryKey)
    }
} 