import Foundation

enum SubscriptionFeature: Equatable {
    case cloudRecognition
    case advancedFilters
    case unlimitedUploads
    case weatherAlerts
    case customTags
    case prioritySupport
    case aiAssistant
    case exportFeatures
    case socialFeatures
    
    var requiredTier: SubscriptionManager.SubscriptionTier {
        switch self {
        case .cloudRecognition, .advancedFilters:
            return .free
        case .unlimitedUploads, .weatherAlerts, .customTags,
             .prioritySupport, .aiAssistant, .exportFeatures,
             .socialFeatures:
            return .premium
        }
    }
} 