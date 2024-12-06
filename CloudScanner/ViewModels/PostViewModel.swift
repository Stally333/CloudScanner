import Foundation

@MainActor
class PostViewModel: ObservableObject {
    @Published var post: CloudPost
    private let postInteractionService = PostInteractionService.shared
    
    init(post: CloudPost) {
        self.post = post
    }
    
    func likePost() async {
        do {
            try await postInteractionService.likePost(post)
            // Update local state if needed
        } catch {
            print("Error liking post: \(error)")
        }
    }
    
    func addComment(_ text: String) async {
        do {
            let comment = try await postInteractionService.addComment(to: post, text: text)
            post.comments.append(comment)
        } catch {
            print("Error adding comment: \(error)")
        }
    }
    
    func addReply(_ text: String, to comment: CloudPost.Comment) async {
        do {
            let reply = try await postInteractionService.addReply(to: comment, text: text)
            if let index = post.comments.firstIndex(where: { $0.id == comment.id }) {
                post.comments[index].replies?.append(reply)
            }
        } catch {
            print("Error adding reply: \(error)")
        }
    }
} 