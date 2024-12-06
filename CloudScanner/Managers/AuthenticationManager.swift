import SwiftUI
import Foundation

@MainActor
class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    private init() {
        // Private initializer to enforce singleton pattern
    }
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    private let profileCache = ProfileCache.shared
    private let rateLimiter = RateLimiter.shared
    
    struct User {
        let id: String
        let email: String
        let username: String
        let userAvatarUrl: String?
        let bio: String?
        let location: String?
        private(set) var posts: [CloudPost] = []
        var following: [String] = []
        var followers: [String] = []
        var subscriptionTier: SubscriptionManager.SubscriptionTier = .free
        var subscriptionExpiryDate: Date?
        
        mutating func updatePosts(_ newPosts: [CloudPost]) {
            posts = newPosts
        }
    }
    
    func signIn(email: String, password: String) async throws {
        // TODO: Implement actual authentication
        self.isAuthenticated = true
        self.currentUser = User(
            id: "1",
            email: email,
            username: "cloudchaser",
            userAvatarUrl: nil,
            bio: "Cloud enthusiast and weather photographer",
            location: "Seattle, WA",
            following: [],
            followers: [],
            subscriptionTier: .free,
            subscriptionExpiryDate: nil
        )
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
    }
    
    func updateProfile(username: String, bio: String?, location: String?, avatarUrl: String?) async throws {
        guard let currentUser = self.currentUser else {
            throw AuthError.notAuthenticated
        }
        
        // Check rate limit
        let action = "profile_update_\(currentUser.id)"
        guard self.rateLimiter.canPerformAction(action) else {
            throw AuthError.rateLimited(self.rateLimiter.timeUntilNextAllowed(action))
        }
        
        let updatedUser = User(
            id: currentUser.id,
            email: currentUser.email,
            username: username,
            userAvatarUrl: avatarUrl,
            bio: bio,
            location: location,
            following: currentUser.following,
            followers: currentUser.followers,
            subscriptionTier: currentUser.subscriptionTier,
            subscriptionExpiryDate: currentUser.subscriptionExpiryDate
        )
        
        // TODO: Sync with backend
        try await Task.sleep(until: .now + .seconds(1), clock: .continuous)
        
        // Record the action after successful update
        self.rateLimiter.recordAction(action)
        
        // Update current user and cache
        self.currentUser = updatedUser
        self.profileCache.cacheProfile(updatedUser)
    }
    
    private func loadCachedProfile() {
        if let cached = profileCache.getCachedProfile() {
            // Only update if we have a current user
            guard var updatedUser = currentUser else { return }
            
            // Update only cached fields
            updatedUser = User(
                id: updatedUser.id,
                email: updatedUser.email,
                username: cached.username,
                userAvatarUrl: cached.userAvatarUrl,
                bio: cached.bio,
                location: cached.location,
                posts: updatedUser.posts,
                following: updatedUser.following,
                followers: updatedUser.followers,
                subscriptionTier: updatedUser.subscriptionTier,
                subscriptionExpiryDate: updatedUser.subscriptionExpiryDate
            )
            
            self.currentUser = updatedUser
        }
    }
    
    enum AuthError: LocalizedError {
        case notAuthenticated
        case rateLimited(TimeInterval)
        
        var errorDescription: String? {
            switch self {
            case .notAuthenticated:
                return "You must be signed in to perform this action"
            case .rateLimited(let seconds):
                let waitTime = Int(ceil(seconds))
                return "Please wait \(waitTime) seconds before updating your profile again"
            }
        }
    }
    
    func checkSubscriptionStatus() async {
        guard let currentUser = currentUser else { return }
        
        do {
            let subscription = try await SubscriptionService.shared.loadStoredSubscription()
            if let subscription = subscription {
                // Update user's subscription status
                self.currentUser?.subscriptionTier = subscription.tier
                self.currentUser?.subscriptionExpiryDate = subscription.expiryDate
            }
        } catch {
            print("Error checking subscription status: \(error)")
        }
    }
} 