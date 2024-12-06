import SwiftUI

struct CommentSheet: View {
    let post: CloudPost
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CommentViewModel()
    @State private var isInputFocused = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Comments List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(post.comments) { comment in
                            CommentRow(comment: comment)
                        }
                    }
                    .padding()
                }
                
                // Comment Input
                CommentInputBar(
                    text: $viewModel.commentText,
                    isInputFocused: $isInputFocused,
                    onSend: {
                        Task {
                            await viewModel.addComment(to: post)
                            isInputFocused = false
                        }
                    }
                )
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Preview provider
#Preview {
    CommentSheet(post: CloudPost.mockPosts[0])
} 