import Foundation

@MainActor
class BookmarkService: ObservableObject {
    static let shared = BookmarkService()
    
    struct Collection: Identifiable, Codable {
        let id: String
        var name: String
        var posts: [String] // Post IDs
        var isPrivate: Bool
        let createdAt: Date
        
        init(id: String = UUID().uuidString, name: String, posts: [String] = [], isPrivate: Bool = false) {
            self.id = id
            self.name = name
            self.posts = posts
            self.isPrivate = isPrivate
            self.createdAt = Date()
        }
    }
    
    @Published private(set) var collections: [Collection] = []
    @Published private(set) var savedPosts: Set<String> = []
    
    private init() {
        loadCollections()
    }
    
    func createCollection(name: String, isPrivate: Bool = false) async throws {
        let collection = Collection(name: name, isPrivate: isPrivate)
        collections.append(collection)
        saveCollections()
    }
    
    func addPost(_ postId: String, to collectionId: String) async throws {
        guard let index = collections.firstIndex(where: { $0.id == collectionId }) else {
            throw BookmarkError.collectionNotFound
        }
        
        collections[index].posts.append(postId)
        savedPosts.insert(postId)
        saveCollections()
    }
    
    func removePost(_ postId: String, from collectionId: String) async throws {
        guard let index = collections.firstIndex(where: { $0.id == collectionId }) else {
            throw BookmarkError.collectionNotFound
        }
        
        collections[index].posts.removeAll { $0 == postId }
        savedPosts.remove(postId)
        saveCollections()
    }
    
    private func loadCollections() {
        // Load from UserDefaults for now
        if let data = UserDefaults.standard.data(forKey: "collections"),
           let collections = try? JSONDecoder().decode([Collection].self, from: data) {
            self.collections = collections
            self.savedPosts = Set(collections.flatMap { $0.posts })
        }
    }
    
    private func saveCollections() {
        if let data = try? JSONEncoder().encode(collections) {
            UserDefaults.standard.set(data, forKey: "collections")
        }
    }
    
    enum BookmarkError: LocalizedError {
        case collectionNotFound
        case saveFailed
        
        var errorDescription: String? {
            switch self {
            case .collectionNotFound: return "Collection not found"
            case .saveFailed: return "Failed to save collection"
            }
        }
    }
} 