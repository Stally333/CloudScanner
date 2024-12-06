import Foundation

@MainActor
class ReactionService: ObservableObject {
    static let shared = ReactionService()
    
    enum Reaction: String, CaseIterable {
        case like = "❤️"
        case love = "😍"
        case wow = "😮"
        case cloud = "☁️"
        case storm = "⛈️"
        case rainbow = "🌈"
        
        var systemImage: String {
            switch self {
            case .like: return "heart.fill"
            case .love: return "heart.circle.fill"
            case .wow: return "star.fill"
            case .cloud: return "cloud.fill"
            case .storm: return "cloud.bolt.fill"
            case .rainbow: return "rainbow"
            }
        }
    }
    
    @Published private(set) var postReactions: [String: Set<Reaction>] = [:] // [PostID: Set<Reaction>]
    
    func addReaction(_ reaction: Reaction, to postId: String) async throws {
        if var reactions = postReactions[postId] {
            reactions.insert(reaction)
            postReactions[postId] = reactions
        } else {
            postReactions[postId] = [reaction]
        }
        
        // TODO: Sync with backend
        try await Task.sleep(nanoseconds: 500_000_000)
    }
    
    func removeReaction(_ reaction: Reaction, from postId: String) async throws {
        postReactions[postId]?.remove(reaction)
        
        // TODO: Sync with backend
        try await Task.sleep(nanoseconds: 500_000_000)
    }
} 