import SwiftUI
import UIKit

struct CommentSection: View {
    let post: CloudPost
    @ObservedObject var interactionService: PostInteractionService
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Comments")
                .font(CloudFonts.headlineMedium)
            
            // Comment list
            ForEach(post.comments) { comment in
                CommentRow(comment: comment)
            }
            
            // Comment input
            HStack {
                TextField("Add a comment...", text: $interactionService.commentText)
                    .textFieldStyle(CloudTextFieldStyle())
                    .focused($isInputFocused)
                    .onChange(of: interactionService.commentText) { newValue in
                        updateMentionSuggestions(for: newValue)
                    }
                
                Button(action: submitComment) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundStyle(interactionService.commentText.isEmpty ? .gray : CloudColors.deepBlue)
                }
                .disabled(interactionService.commentText.isEmpty)
            }
            .overlay(alignment: .top) {
                if interactionService.showingMentions {
                    MentionSuggestionView(
                        query: interactionService.mentionQuery,
                        selectedUsername: $interactionService.selectedUsername
                    )
                    .offset(y: -200)
                }
            }
        }
        .padding()
    }
    
    private func updateMentionSuggestions(for text: String) {
        if let lastWord = text.split(separator: " ").last,
           lastWord.hasPrefix("@") {
            interactionService.mentionQuery = String(lastWord.dropFirst())
            interactionService.showingMentions = true
        } else {
            interactionService.showingMentions = false
        }
    }
    
    private func submitComment() {
        guard !interactionService.commentText.isEmpty else { return }
        
        Task {
            do {
                let comment = try await interactionService.addComment(
                    to: post,
                    text: interactionService.commentText
                )
                interactionService.commentText = ""
                isInputFocused = false
                HapticManager.notification(type: .success)
            } catch {
                print("Error adding comment: \(error)")
                HapticManager.notification(type: .error)
            }
        }
    }
} 