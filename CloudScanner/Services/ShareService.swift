import Foundation
import UIKit

@MainActor
class ShareService: ObservableObject {
    static let shared = ShareService()
    
    private init() {}
    
    func sharePost(_ post: CloudPost) {
        let text = "Check out this amazing cloud photo by @\(post.username)"
        let image = post.generatedImage
        
        let activityItems: [Any] = [text, image]
        let activityVC = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        // Present the activity view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
} 