import Foundation

struct TimeLapseSettings {
    var duration: TimeInterval = 3600 // 1 hour
    var interval: TimeInterval = 5 // 5 seconds
    var frameRate: Double = 30 // frames per second
    var quality: VideoQuality = .high
    
    enum VideoQuality {
        case low, medium, high
    }
} 