import SwiftUI
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        guard let type = userInfo["type"] as? String else { return }
        
        switch type {
        case "comment", "like":
            if let postId = userInfo["postId"] as? String {
                // Navigate to post
                NotificationCenter.default.post(
                    name: .navigateToPost,
                    object: nil,
                    userInfo: ["postId": postId]
                )
            }
        case "reply":
            if let commentId = userInfo["commentId"] as? String {
                // Navigate to comment
                NotificationCenter.default.post(
                    name: .navigateToComment,
                    object: nil,
                    userInfo: ["commentId": commentId]
                )
            }
        default:
            break
        }
    }
}

extension Notification.Name {
    static let navigateToPost = Notification.Name("navigateToPost")
    static let navigateToComment = Notification.Name("navigateToComment")
} 