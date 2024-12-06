import Foundation
import CoreLocation
import UIKit

struct CloudPost: Identifiable, Codable {
    let id: String
    let userId: String
    let username: String
    let originalImage: UIImage
    let generatedImage: UIImage
    let imageUrl: String
    let userAvatarUrl: String?
    let timestamp: Date
    let location: CLLocationCoordinate2D?
    let weather: WeatherData?
    var likes: Int = 0
    var comments: [Comment] = []
    let description: String?
    let cloudType: CloudType
    
    enum CloudType: String, Codable {
        case cumulus = "Cumulus"
        case stratus = "Stratus"
        case cirrus = "Cirrus"
        case cumulonimbus = "Cumulonimbus"
        case altostratus = "Altostratus"
        case nimbostratus = "Nimbostratus"
        case unknown = "Unknown"
    }
    
    struct Comment: Identifiable, Codable {
        let id: String
        let userId: String
        let username: String
        let text: String
        let timestamp: Date
        var replies: [Reply]?
        
        struct Reply: Identifiable, Codable {
            let id: String
            let userId: String
            let username: String
            let text: String
            let timestamp: Date
        }
    }
    
    mutating func toggleLike() {
        likes += 1
    }
    
    enum CodingKeys: String, CodingKey {
        case id, userId, timestamp, location, weather, likes
        case originalImage, generatedImage, imageUrl, userAvatarUrl, username, cloudType, description, comments
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(location, forKey: .location)
        try container.encode(weather, forKey: .weather)
        try container.encode(likes, forKey: .likes)
        
        // Encode images as base64 strings
        if let originalData = originalImage.jpegData(compressionQuality: 0.8) {
            try container.encode(originalData.base64EncodedString(), forKey: .originalImage)
        }
        if let generatedData = generatedImage.jpegData(compressionQuality: 0.8) {
            try container.encode(generatedData.base64EncodedString(), forKey: .generatedImage)
        }
        
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(userAvatarUrl, forKey: .userAvatarUrl)
        try container.encode(username, forKey: .username)
        try container.encode(cloudType, forKey: .cloudType)
        try container.encode(description, forKey: .description)
        try container.encode(comments, forKey: .comments)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        location = try container.decodeIfPresent(CLLocationCoordinate2D.self, forKey: .location)
        weather = try container.decodeIfPresent(WeatherData.self, forKey: .weather)
        likes = try container.decode(Int.self, forKey: .likes)
        
        // Decode images from base64 strings
        let originalBase64 = try container.decode(String.self, forKey: .originalImage)
        let generatedBase64 = try container.decode(String.self, forKey: .generatedImage)
        
        guard let originalData = Data(base64Encoded: originalBase64),
              let generatedData = Data(base64Encoded: generatedBase64),
              let originalImage = UIImage(data: originalData),
              let generatedImage = UIImage(data: generatedData) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unable to decode images"
                )
            )
        }
        
        self.originalImage = originalImage
        self.generatedImage = generatedImage
        
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        userAvatarUrl = try container.decodeIfPresent(String.self, forKey: .userAvatarUrl)
        username = try container.decode(String.self, forKey: .username)
        cloudType = try container.decode(CloudType.self, forKey: .cloudType)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        comments = try container.decode([Comment].self, forKey: .comments)
    }
    
    // Custom initializer for creating posts
    init(id: String, userId: String, username: String, originalImage: UIImage, generatedImage: UIImage,
         imageUrl: String, userAvatarUrl: String?, timestamp: Date, location: CLLocationCoordinate2D?, weather: WeatherData?,
         cloudType: CloudType = .unknown, description: String? = nil) {
        self.id = id
        self.userId = userId
        self.username = username
        self.originalImage = originalImage
        self.generatedImage = generatedImage
        self.imageUrl = imageUrl
        self.userAvatarUrl = userAvatarUrl
        self.timestamp = timestamp
        self.location = location
        self.weather = weather
        self.cloudType = cloudType
        self.description = description
    }
    
    // Add static mock data
    static var mockPosts: [CloudPost] {
        let mockImage = UIImage(systemName: "cloud.fill")!
        return [
            CloudPost(
                id: "1",
                userId: "user1",
                username: "cloudchaser",
                originalImage: mockImage,
                generatedImage: mockImage,
                imageUrl: "https://cloudscanner.app/images/cloud1.jpg",
                userAvatarUrl: "https://cloudscanner.app/images/user1.jpg",
                timestamp: Date(),
                location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
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
                ),
                cloudType: .cumulus,
                description: "Beautiful cumulus clouds over San Francisco #clouds #sf"
            )
        ]
    }
}

// Add Codable support for CLLocationCoordinate2D
extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
} 