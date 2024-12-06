import UIKit

@MainActor
class ImageUploadService {
    static let shared = ImageUploadService()
    
    private init() {}
    
    func uploadProfileImage(_ image: UIImage) async throws -> String {
        // Simulate network upload
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        // TODO: Implement actual image upload to backend
        // For now, return a mock URL
        return "https://cloudscanner.app/profiles/mock-image-\(UUID().uuidString).jpg"
    }
} 