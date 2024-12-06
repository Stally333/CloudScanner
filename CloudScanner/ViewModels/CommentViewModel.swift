import SwiftUI
import Combine

@MainActor
class CommentViewModel: ObservableObject {
    @Published var commentText = ""
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published private(set) var comments: [CloudPost.Comment] = []
    
    private let postInteractionService = PostInteractionService.shared
    
    func addComment(to post: CloudPost) async {
        guard !commentText.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let comment = try await postInteractionService.addComment(
                to: post,
                text: commentText
            )
            comments.append(comment)
            commentText = ""
        } catch {
            self.error = error
        }
    }
}

extension Notification.Name {
    static let commentAdded = Notification.Name("commentAdded")
} 