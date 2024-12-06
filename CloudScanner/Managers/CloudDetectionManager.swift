import Vision
import UIKit

class CloudDetectionManager: ObservableObject {
    @Published var isProcessing = false
    @Published var cloudConfidence: Float = 0.0
    @Published var detectedCloudFrame: CGRect?
    
    // Temporary placeholder for detection
    func detectClouds(in image: UIImage) {
        isProcessing = true
        // Simulate detection
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.detectedCloudFrame = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.4)
            self.cloudConfidence = 0.8
            self.isProcessing = false
        }
    }
} 