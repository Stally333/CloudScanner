import SwiftUI
import UIKit

struct CloudPostCard: View {
    let post: CloudPost
    @State private var showingOptions = false
    @State private var showingDetails = false
    @StateObject private var interactionService = PostInteractionService.shared
    @State private var showingLikeAnimation = false
    @State private var showingComments = false
    @State private var showingReactionPicker = false
    @State private var showingShareSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(post.userAvatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.username)
                        .font(CloudFonts.body)
                    Text(post.location.placeName)
                        .font(CloudFonts.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Menu {
                    Button("View Details") {
                        showingDetails = true
                    }
                    Button("Share", action: sharePost)
                    Button("Report", role: .destructive, action: reportPost)
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal)
            
            // Cloud Image
            Image(post.imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 16)
            
            // Actions
            HStack(spacing: 20) {
                Button {
                    handleLike()
                } label: {
                    Image(systemName: post.likedByCurrentUser ? "heart.fill" : "heart")
                        .foregroundStyle(post.likedByCurrentUser ? .red : .white)
                }
                .disabled(interactionService.isProcessing)
                .onLongPressGesture {
                    withAnimation {
                        showingReactionPicker = true
                    }
                }
                
                Button(action: commentOnPost) {
                    Image(systemName: "bubble.right")
                        .foregroundStyle(.white)
                }
                
                Button(action: floatUpPost) {
                    Image(systemName: "arrow.up.circle")
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                Button(action: savePost) {
                    Image(systemName: "bookmark")
                        .foregroundStyle(.white)
                }
            }
            .font(.system(size: 20))
            .padding(.horizontal)
            
            // Post Info
            VStack(alignment: .leading, spacing: 6) {
                Text("\(post.likes) likes")
                    .font(CloudFonts.body)
                
                Text(post.description)
                    .font(CloudFonts.body)
                    .lineLimit(2)
                
                if !post.comments.isEmpty {
                    Text("View all \(post.comments.count) comments")
                        .font(CloudFonts.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text(post.timestamp.timeAgo())
                    .font(CloudFonts.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding(.horizontal)
        .sheet(isPresented: $showingDetails) {
            CloudPostDetailView(post: post)
        }
        .feedTransition()
        .contextMenu {
            Button {
                sharePost()
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            Button {
                savePost()
            } label: {
                Label("Save", systemImage: "bookmark")
            }
            
            Button(role: .destructive) {
                reportPost()
            } label: {
                Label("Report", systemImage: "exclamationmark.triangle")
            }
        }
        .overlay(alignment: .bottom) {
            if showingReactionPicker {
                ReactionPicker(postId: post.id, isPresented: $showingReactionPicker)
                    .padding(.bottom, 60)
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            EnhancedShareSheet(post: post, isPresented: $showingShareSheet)
        }
        .onTapGesture(count: 2) {
            handleLike()
        }
        .overlay {
            if showingLikeAnimation {
                LikeAnimation(isAnimating: $showingLikeAnimation)
            }
        }
        .sheet(isPresented: $showingComments) {
            CommentSheet(post: post)
        }
    }
    
    private func handleLike() {
        showingLikeAnimation = true
        Task {
            try? await interactionService.toggleLike(for: post)
        }
    }
    
    private func commentOnPost() {
        showingComments = true
    }
    
    private func floatUpPost() {
        // TODO: Implement float up functionality
    }
    
    private func savePost() {
        // TODO: Implement save functionality
    }
    
    private func sharePost() {
        // TODO: Implement share functionality
    }
    
    private func reportPost() {
        // TODO: Implement report functionality
    }
} 