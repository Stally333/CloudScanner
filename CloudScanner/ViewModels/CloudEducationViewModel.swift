import Foundation

class CloudEducationViewModel: ObservableObject {
    @Published var learningPaths: [LearningPath] = [
        LearningPath(title: "Cloud Basics", progress: 0.3, estimatedTime: 15),
        LearningPath(title: "Weather Patterns", progress: 0.0, estimatedTime: 20),
        LearningPath(title: "Advanced Cloud Photography", progress: 0.0, estimatedTime: 30)
    ]
    
    @Published var quickLessons: [QuickLesson] = [
        QuickLesson(
            title: "Identifying Cumulus Clouds",
            description: "Learn to spot these fluffy clouds",
            imageName: "cumulus_preview",
            tags: ["basics", "identification"]
        )
    ]
    
    @Published var tutorials: [Tutorial] = [
        Tutorial(
            title: "Camera Setup",
            description: "Get the perfect cloud shot",
            icon: "camera.fill"
        )
    ]
    
    var currentQuiz: CloudQuiz {
        CloudQuiz(
            title: "Cloud Basics",
            questions: [],
            difficulty: .beginner,
            timeLimit: nil
        )
    }
} 