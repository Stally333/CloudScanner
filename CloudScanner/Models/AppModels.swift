import Foundation

struct LearningPath: Identifiable {
    let id = UUID()
    let title: String
    let progress: Double
    let estimatedTime: Int
}

struct QuickLesson: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    let tags: [String]
}

struct Tutorial: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
} 