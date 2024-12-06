import Foundation

@MainActor
class HashtagExploreViewModel: ObservableObject {
    @Published var posts: [CloudPost] = []
    @Published var selectedHashtag: String = ""
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    private let cloudDataService = CloudDataService.shared
    
    func fetchPosts(for hashtag: String?) async {
        guard let tag = hashtag, !tag.isEmpty else { 
            posts = []
            return 
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            selectedHashtag = tag
            let allPosts = try await cloudDataService.fetchPosts()
            posts = allPosts.filter { post in
                post.description?.contains("#\(tag)") ?? false
            }
        } catch {
            self.error = error
            posts = []
        }
    }
} 