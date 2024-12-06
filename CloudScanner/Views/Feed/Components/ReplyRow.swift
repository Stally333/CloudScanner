import SwiftUI

struct ReplyRow: View {
    let reply: CloudPost.Comment.Reply
    let parentComment: CloudPost.Comment
    @StateObject private var interactionService = PostInteractionService.shared
    @State private var isLiked: Bool
    @State private var likeCount: Int
    
    init(reply: CloudPost.Comment.Reply, parentComment: CloudPost.Comment) {
        self.reply = reply
        self.parentComment = parentComment
        _isLiked = State(initialValue: reply.isLiked)
        _likeCount = State(initialValue: 0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(reply.username)
                    .font(CloudFonts.caption.bold())
                
                Text(reply.timestamp.timeAgo())
                    .font(CloudFonts.caption2)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Button {
                    toggleLike()
                } label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundStyle(isLiked ? .red : .secondary)
                }
                .scaleEffect(isLiked ? 1.1 : 1.0)
            }
            
            Text(reply.text)
                .font(CloudFonts.caption)
        }
        .padding(8)
        .background(.ultraThinMaterial.opacity(0.5))
        .cornerRadius(8)
        .onReceive(NotificationCenter.default.publisher(for: .replyLikeToggled)) { notification in
            guard let notifReply = notification.userInfo?["reply"] as? CloudPost.Comment.Reply,
                  notifReply.id == reply.id else { return }
            
            withAnimation(.spring(response: 0.3)) {
                isLiked.toggle()
                HapticManager.impact(style: .light)
            }
        }
    }
    
    private func toggleLike() {
        Task {
            do {
                try await interactionService.toggleReplyLike(reply, in: parentComment)
            } catch {
                print("Error toggling reply like: \(error)")
                HapticManager.notification(type: .error)
            }
        }
    }
} 