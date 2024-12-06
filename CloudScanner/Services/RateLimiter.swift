import Foundation

@MainActor
class RateLimiter {
    static let shared = RateLimiter()
    
    private let defaults = UserDefaults.standard
    private var lastUpdateTimes: [String: Date] = [:]
    private let minimumInterval: TimeInterval = 60 // 1 minute between updates
    
    private init() {}
    
    func canPerformAction(_ action: String) -> Bool {
        if let lastUpdate = lastUpdateTimes[action] {
            let timeSinceLastUpdate = Date().timeIntervalSince(lastUpdate)
            return timeSinceLastUpdate >= minimumInterval
        }
        return true
    }
    
    func recordAction(_ action: String) {
        lastUpdateTimes[action] = Date()
    }
    
    func timeUntilNextAllowed(_ action: String) -> TimeInterval {
        guard let lastUpdate = lastUpdateTimes[action] else { return 0 }
        let timeSinceLastUpdate = Date().timeIntervalSince(lastUpdate)
        return max(0, minimumInterval - timeSinceLastUpdate)
    }
} 