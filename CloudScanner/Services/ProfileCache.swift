import Foundation

@MainActor
class ProfileCache {
    static let shared = ProfileCache()
    
    private let defaults = UserDefaults.standard
    private let cacheKey = "cached_profile"
    
    private init() {}
    
    struct CachedProfile: Codable {
        let username: String
        let bio: String?
        let location: String?
        let userAvatarUrl: String?
        let lastUpdated: Date
        
        var isStale: Bool {
            Date().timeIntervalSince(lastUpdated) > 3600 // 1 hour
        }
    }
    
    func cacheProfile(_ profile: AuthenticationManager.User) {
        let cachedProfile = CachedProfile(
            username: profile.username,
            bio: profile.bio,
            location: profile.location,
            userAvatarUrl: profile.userAvatarUrl,
            lastUpdated: Date()
        )
        
        if let encoded = try? JSONEncoder().encode(cachedProfile) {
            defaults.set(encoded, forKey: cacheKey)
        }
    }
    
    func getCachedProfile() -> CachedProfile? {
        guard let data = defaults.data(forKey: cacheKey),
              let profile = try? JSONDecoder().decode(CachedProfile.self, from: data),
              !profile.isStale else {
            return nil
        }
        return profile
    }
    
    func clearCache() {
        defaults.removeObject(forKey: cacheKey)
    }
} 