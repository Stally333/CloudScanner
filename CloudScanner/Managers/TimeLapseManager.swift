import Foundation
import AVFoundation
import UIKit

class TimeLapseManager: ObservableObject {
    @Published var isRecording = false
    @Published var progress: Float = 0
    @Published var remainingTime: TimeInterval = 0
    
    func startRecording(settings: TimeLapseSettings) {
        isRecording = true
        // Placeholder for actual implementation
    }
    
    func stopRecording() {
        isRecording = false
    }
} 