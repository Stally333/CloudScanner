import SwiftUI

@MainActor
class GenerativeOptionsViewModel: ObservableObject {
    @Published var generatedImages: [UIImage] = []
    @Published var selectedImage: UIImage?
    @Published var isLoading = false
    
    private let aiService = AIGenerationService.shared
    
    func generateVariations(from image: UIImage) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            generatedImages = try await aiService.generateCloudArt(from: image, count: 4)
        } catch {
            print("Failed to generate variations: \(error)")
            // TODO: Handle error properly
        }
    }
    
    func shareImages(original: UIImage, username: String, imageUrl: String) async {
        guard let selectedImage = selectedImage else { return }
        
        // TODO: Implement sharing logic
        // This is a placeholder for now
        print("Sharing images for user: \(username)")
    }
} 