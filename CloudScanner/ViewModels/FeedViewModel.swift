import SwiftUI
import Combine

@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts: [CloudPost] = []
    @Published var isLoading = false
    @Published var currentFilter: CloudDataService.PostFilter = .all
    @Published var error: Error?
    
    private let cloudService = CloudDataService.shared
    private var cancellables = Set<AnyCancellable>()
    private let imageCache = NSCache<NSString, UIImage>()
    
    init() {
        setupImageCache()
    }
    
    private func setupImageCache() {
        imageCache.countLimit = 100 // Maximum number of images to cache
        imageCache.totalCostLimit = 1024 * 1024 * 100 // 100 MB limit
    }
    
    func fetchPosts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            posts = try await cloudService.fetchPosts(filter: currentFilter)
            prefetchImages()
        } catch {
            self.error = error
        }
    }
    
    private func prefetchImages() {
        for post in posts {
            Task.detached(priority: .background) {
                if let url = URL(string: post.imageUrl),
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: post.imageUrl as NSString)
                }
            }
        }
    }
    
    @Published private(set) var topClouds: [CloudPost] = []
    
    func loadTopClouds() async {
        // Ensure we're on the main thread
        await MainActor.run {
            // Load your top clouds data here
            topClouds = CloudPost.mockPosts
        }
    }
} 