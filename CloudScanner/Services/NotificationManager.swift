import Foundation
import UserNotifications
import SwiftUI

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published private(set) var isAuthorized = false
    private let settingsManager = NotificationSettingsManager.shared
    
    private init() {
        Task {
            await checkAuthorization()
        }
    }
    
    func requestAuthorization() async throws {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        isAuthorized = try await UNUserNotificationCenter.current().requestAuthorization(options: options)
    }
    
    private func checkAuthorization() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        isAuthorized = settings.authorizationStatus == .authorized
    }
    
    func scheduleCommentNotification(for post: CloudPost, from user: String) async {
        guard isAuthorized, settingsManager.settings.commentsEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "New Comment"
        content.body = "\(user) commented on your cloud post"
        content.sound = .default
        content.userInfo = ["type": "comment", "postId": post.id]
        
        scheduleNotification(with: content)
    }
    
    func scheduleReplyNotification(for comment: CloudPost.Comment, from user: String) async {
        guard isAuthorized, settingsManager.settings.repliesEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "New Reply"
        content.body = "\(user) replied to your comment"
        content.sound = .default
        content.userInfo = ["type": "reply", "commentId": comment.id]
        
        scheduleNotification(with: content)
    }
    
    func scheduleLikeNotification(for post: CloudPost, from user: String) async {
        guard isAuthorized, settingsManager.settings.likesEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "New Like"
        content.body = "\(user) liked your cloud post"
        content.sound = .default
        content.userInfo = ["type": "like", "postId": post.id]
        
        scheduleNotification(with: content)
    }
    
    private func scheduleNotification(with content: UNNotificationContent) {
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        
        Task {
            try? await UNUserNotificationCenter.current().add(request)
        }
    }
} 