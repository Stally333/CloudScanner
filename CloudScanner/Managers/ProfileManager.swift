import Foundation
import SwiftUI

class ProfileManager: ObservableObject {
    @Published var currentProfile: UserProfile?
    @Published var isLoading = false
    @Published var isPremium = false
    
    struct UserProfile: Codable {
        var id: String
        var username: String
        var email: String
        var profileImage: String?
        var createdAt: Date
        var stats: UserStats
        var preferences: UserPreferences
        var subscription: SubscriptionStatus
    }
    
    struct UserStats: Codable {
        var totalScans: Int
        var totalShares: Int
        var floatUpsReceived: Int
        var floatUpsGiven: Int
    }
    
    struct UserPreferences: Codable {
        var notificationsEnabled: Bool
        var defaultStyle: String
        var saveToLibrary: Bool
        var darkMode: Bool
    }
    
    enum SubscriptionStatus: String, Codable {
        case free
        case premium
        case premiumPlus
    }
} 