import Foundation
import SwiftUI

@MainActor
class PostInteractionService: ObservableObject {
    static let shared = PostInteractionService()
    
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private init() {}
    
    func likePost(_ post: CloudPost) async throws {
        isLoading = true
        defer { isLoading = false }
        
        try await Task.sleep(for: .seconds(1))
    }
    
    func addComment(to post: CloudPost, text: String) async throws -> CloudPost.Comment {
        isLoading = true
        defer { isLoading = false }
        
        try await Task.sleep(for: .seconds(1))
        
        let comment = CloudPost.Comment(
            id: UUID().uuidString,
            userId: await AuthenticationManager.shared.currentUser?.id ?? "",
            username: await AuthenticationManager.shared.currentUser?.username ?? "",
            text: text,
            timestamp: Date()
        )
        
        return comment
    }
    
    func addReply(to comment: CloudPost.Comment, text: String) async throws -> CloudPost.Comment.Reply {
        isLoading = true
        defer { isLoading = false }
        
        try await Task.sleep(for: .seconds(1))
        
        let reply = CloudPost.Comment.Reply(
            id: UUID().uuidString,
            userId: await AuthenticationManager.shared.currentUser?.id ?? "",
            username: await AuthenticationManager.shared.currentUser?.username ?? "",
            text: text,
            timestamp: Date()
        )
        
        return reply
    }
} 