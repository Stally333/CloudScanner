import SwiftUI

struct CommentRow: View {
    let comment: CloudPost.Comment
    @StateObject private var interactionService = PostInteractionService.shared
    @State private var isLiked: Bool
    @State private var showingReplyInput = false
    @State private var replyText = ""
    @State private var showingReplies = false
    @FocusState private var isReplyFocused: Bool
    @State private var replies: [CloudPost.Comment.Reply]
    @State private var isSubmitting = false
    @State private var likeCount: Int
    
    init(comment: CloudPost.Comment) {
        self.comment = comment
        _isLiked = State(initialValue: comment.isLiked)
        _replies = State(initialValue: comment.replies ?? [])
        _likeCount = State(initialValue: comment.likes)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(comment.username)
                        .font(CloudFonts.caption.bold())
                    Text(comment.timestamp.timeAgo())
                        .font(CloudFonts.caption2)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button {
                    toggleLike()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundStyle(isLiked ? .red : .secondary)
                        Text("\(likeCount)")
                            .font(CloudFonts.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .scaleEffect(isLiked ? 1.1 : 1.0)
                .animation(.spring(response: 0.3), value: isLiked)
            }
            
            Text(comment.text)
                .font(CloudFonts.body)
                .textSelection(.enabled)
            
            // Actions
            HStack(spacing: 16) {
                Button {
                    toggleLike()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundStyle(isLiked ? .red : .secondary)
                        Text("\(likeCount)")
                            .font(CloudFonts.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .scaleEffect(isLiked ? 1.1 : 1.0)
                .animation(.spring(response: 0.3), value: isLiked)
                
                Button {
                    showingReplyInput = true
                    isReplyFocused = true
                } label: {
                    Text("Reply")
                        .font(CloudFonts.caption)
                        .foregroundStyle(.secondary)
                }
                
                if !comment.replies.isNilOrEmpty {
                    Button {
                        withAnimation {
                            showingReplies.toggle()
                        }
                    } label: {
                        Text("\(comment.replies?.count ?? 0) replies")
                            .font(CloudFonts.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            // Reply Input
            Group {
                if showingReplyInput {
                    HStack(spacing: 8) {
                        TextField("Reply to \(comment.username)...", text: $replyText)
                            .textFieldStyle(.roundedBorder)
                            .focused($isReplyFocused)
                            .disabled(isSubmitting)
                        
                        Button {
                            submitReply()
                        } label: {
                            if isSubmitting {
                                ProgressView()
                                    .tint(CloudColors.skyBlue)
                            } else {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(replyText.isEmpty ? .secondary : CloudColors.skyBlue)
                            }
                        }
                        .disabled(replyText.isEmpty || isSubmitting)
                    }
                    .padding(.leading, 32)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showingReplyInput)
            
            // Replies
            Group {
                if showingReplies && !replies.isEmpty {
                    ForEach(replies) { reply in
                        ReplyRow(reply: reply, parentComment: comment)
                            .padding(.leading, 32)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showingReplies)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .onReceive(NotificationCenter.default.publisher(for: .replyAdded)) { notification in
            guard let notifComment = notification.userInfo?["comment"] as? CloudPost.Comment,
                  let reply = notification.userInfo?["reply"] as? CloudPost.Comment.Reply,
                  notifComment.id == comment.id else { return }
            
            withAnimation {
                replies.append(reply)
                showingReplies = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .commentLikeToggled)) { notification in
            guard let likedComment = notification.userInfo?["comment"] as? CloudPost.Comment,
                  likedComment.id == comment.id else { return }
            
            withAnimation {
                likeCount += isLiked ? -1 : 1
                isLiked.toggle()
            }
        }
    }
    
    private func submitReply() {
        guard !replyText.isEmpty else { return }
        
        isSubmitting = true
        Task {
            do {
                let reply = try await interactionService.addReply(to: comment, text: replyText)
                await MainActor.run {
                    withAnimation {
                        replyText = ""
                        showingReplyInput = false
                        showingReplies = true
                        isSubmitting = false
                    }
                    HapticManager.notification(type: .success)
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    HapticManager.notification(type: .error)
                }
                print("Error submitting reply: \(error)")
            }
        }
    }
    
    private func toggleLike() {
        Task {
            do {
                try await interactionService.toggleCommentLike(comment)
            } catch {
                print("Error toggling like: \(error)")
                HapticManager.notification(type: .error)
            }
        }
    }
}

// Helper extension
extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
} 