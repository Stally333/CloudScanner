import SwiftUI
import Combine

@MainActor
class CloudFeedViewModel: ObservableObject {
    @Published private(set) var posts: [CloudPost] = []
    @Published private(set) var topClouds: [CloudPost] = []
    @Published private(set) var isLoading = true
    @Published private(set) var error: Error?
    
    init() {
        Task {
            await fetchInitialData()
        }
    }
    
    private func fetchInitialData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await Task.sleep(until: .now + .seconds(1), clock: .continuous)
            
            posts = CloudPost.mockPosts
            topClouds = CloudPost.mockPosts
                .sorted { $0.likes > $1.likes }
                .prefix(5)
                .map { $0 }
        } catch {
            self.error = error
        }
    }
    
    func fetchPosts() async {
        // TODO: Implement backend fetch
    }
    
    func fetchTopClouds() async {
        // TODO: Implement backend fetch
    }
} 