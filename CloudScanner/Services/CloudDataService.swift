import Foundation
import CoreLocation

@MainActor
class CloudDataService: ObservableObject {
    static let shared = CloudDataService()
    
    typealias CloudPost = CloudScanner.CloudPost
    
    @Published var posts: [CloudPost] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: AppError?
    
    private init() {}
    
    func fetchPosts(filter: PostFilter = .all) async throws -> [CloudPost] {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            let filteredPosts = try CloudPost.mockPosts.filter { post in
                switch filter {
                case .all:
                    return true
                case .following:
                    if let currentUser = AuthenticationManager.shared.currentUser {
                        return currentUser.following.contains(post.userId)
                    }
                    throw AppError.unauthorized
                case .trending:
                    return post.likes > 100
                case .nearby:
                    if let userLocation = LocationManager.shared.location {
                        let postLocation = CLLocation(
                            latitude: post.location?.latitude ?? 0,
                            longitude: post.location?.longitude ?? 0
                        )
                        let distance = userLocation.distance(from: postLocation)
                        return distance <= 10000 // Within 10km
                    }
                    throw AppError.locationNotAvailable
                }
            }
            
            posts = filteredPosts
            return filteredPosts
        } catch {
            if let appError = error as? AppError {
                self.error = appError
                throw appError
            }
            let appError = AppError.cloudServiceError("Failed to fetch posts")
            self.error = appError
            throw appError
        }
    }
    
    func createPost(_ post: CloudPost) async throws {
        // TODO: Implement actual backend integration
        // For now, just simulate network delay
        try await Task.sleep(for: .seconds(1))
        
        // Add to local posts array or handle storage
        // This is where you'd normally send to your backend
    }
    
    enum PostFilter {
        case all, following, trending, nearby
    }
} 