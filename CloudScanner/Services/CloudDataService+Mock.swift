import Foundation
import CoreLocation
import UIKit

extension CloudDataService {
    static var mockPosts: [CloudPost] {
        let mockImage = UIImage(systemName: "cloud.fill")!
        return [
            CloudPost(
                id: UUID().uuidString,
                userId: "user1",
                username: "cloudchaser",
                originalImage: mockImage,
                generatedImage: mockImage,
                imageUrl: "https://cloudscanner.app/images/cloud1.jpg",
                userAvatarUrl: "https://cloudscanner.app/images/user1.jpg",
                timestamp: Date().addingTimeInterval(-3600),
                location: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
                weather: WeatherData(
                    temperature: 22.5,
                    humidity: 65,
                    condition: "Partly Cloudy",
                    conditionIcon: "cloud.sun.fill",
                    windSpeed: 8.5,
                    windDirection: 180,
                    pressure: 1013,
                    visibility: 10000,
                    isGoldenHour: false,
                    isBlueMoment: false
                )
            )
        ]
    }
} 