import Foundation
import UserNotifications

struct NotificationContent {
    static func makeCommentContent(username: String, text: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "New Comment"
        content.body = "\(username) commented: \(text)"
        content.sound = .default
        return content
    }
    
    static func makeLikeContent(username: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "New Like"
        content.body = "\(username) liked your cloud photo"
        content.sound = .default
        return content
    }
} 