import StoreKit
import SwiftUI

@MainActor
class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()
    
    enum SubscriptionTier: String, Codable, Equatable {
        case free = "free"
        case premium = "premium"
        
        var features: [Feature] {
            switch self {
            case .free:
                return [
                    .init(title: "Basic Cloud Recognition", description: "Identify common cloud types"),
                    .init(title: "Limited Scans", description: "Up to 5 scans per day"),
                    .init(title: "Basic Weather Data", description: "Current conditions")
                ]
            case .premium:
                return [
                    .init(title: "Advanced Cloud Analysis", description: "Detailed cloud formation analysis"),
                    .init(title: "Unlimited Scans", description: "No daily limits"),
                    .init(title: "Premium Weather Data", description: "Detailed forecasts and historical data"),
                    .init(title: "Priority Support", description: "24/7 premium support"),
                    .init(title: "Cloud Formation Alerts", description: "Get notified of interesting formations"),
                    .init(title: "Export & Share", description: "Advanced sharing options")
                ]
            }
        }
        
        struct Feature: Identifiable {
            let id = UUID()
            let title: String
            let description: String
        }
    }
    
    struct Subscription: Codable {
        let tier: SubscriptionTier
        let expiryDate: Date?
    }
    
    enum SubscriptionError: LocalizedError {
        case notAvailable
        case purchaseFailed
        case verificationFailed
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .notAvailable:
                return "Subscriptions are not available at this time"
            case .purchaseFailed:
                return "Unable to complete the purchase"
            case .verificationFailed:
                return "Unable to verify the purchase"
            case .unknown:
                return "An unknown error occurred"
            }
        }
    }
    
    @Published private(set) var currentTier: SubscriptionTier = .free
    @Published private(set) var currentSubscription: Subscription?
    @Published private(set) var availableProducts = [StoreKit.Product]()
    
    private let defaults = UserDefaults.standard
    private let subscriptionKey = "user_subscription"
    
    private init() {
        if let data = defaults.data(forKey: subscriptionKey),
           let subscription = try? JSONDecoder().decode(Subscription.self, from: data) {
            self.currentSubscription = subscription
            self.currentTier = subscription.tier
        }
    }
    
    func loadProducts() async throws {
        let productIdentifiers = Set([
            "com.cloudscanner.premium.monthly",
            "com.cloudscanner.premium.yearly"
        ])
        availableProducts = try await StoreKit.Product.products(for: productIdentifiers)
    }
    
    func purchase(_ product: StoreKit.Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await updateSubscriptionStatus(to: .premium)
        case .userCancelled:
            throw SubscriptionError.purchaseFailed
        case .pending:
            throw SubscriptionError.notAvailable
        @unknown default:
            throw SubscriptionError.unknown
        }
    }
    
    func restorePurchases() async throws {
        for await result in StoreKit.Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                await transaction.finish()
                await updateSubscriptionStatus(to: .premium)
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
    
    private func updateSubscriptionStatus(to tier: SubscriptionTier) async {
        self.currentTier = tier
        self.currentSubscription = Subscription(
            tier: tier,
            expiryDate: tier == .premium ? Date().addingTimeInterval(365 * 24 * 60 * 60) : nil
        )
        
        if let encoded = try? JSONEncoder().encode(currentSubscription) {
            defaults.set(encoded, forKey: subscriptionKey)
        }
    }
} 