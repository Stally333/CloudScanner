import Foundation

@MainActor
class FeatureAccessManager: ObservableObject {
    static let shared = FeatureAccessManager()
    
    private let subscriptionManager = SubscriptionManager.shared
    
    func canAccess(_ feature: SubscriptionFeature) -> Bool {
        let requiredTier = feature.requiredTier
        return subscriptionManager.currentTier == requiredTier || 
               (requiredTier == .free && subscriptionManager.currentTier == .premium)
    }
    
    func checkAccess(_ feature: SubscriptionFeature) throws {
        guard canAccess(feature) else {
            throw FeatureAccessError.subscriptionRequired(feature)
        }
    }
    
    enum FeatureAccessError: LocalizedError {
        case subscriptionRequired(SubscriptionFeature)
        
        var errorDescription: String? {
            switch self {
            case .subscriptionRequired(let feature):
                return "This feature requires a premium subscription"
            }
        }
    }
} 