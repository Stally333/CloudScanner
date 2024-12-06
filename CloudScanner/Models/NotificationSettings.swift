import Foundation

struct NotificationSettings: Codable, Equatable {
    var commentsEnabled: Bool
    var repliesEnabled: Bool
    var likesEnabled: Bool
    var mentionsEnabled: Bool
    var newFollowersEnabled: Bool
    
    static let `default` = NotificationSettings(
        commentsEnabled: true,
        repliesEnabled: true,
        likesEnabled: true,
        mentionsEnabled: true,
        newFollowersEnabled: true
    )
} 