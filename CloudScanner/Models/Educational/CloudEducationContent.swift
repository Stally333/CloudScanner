import Foundation

struct CloudEducationContent {
    let sections: [EducationSection]
    let quizzes: [CloudQuiz]
    let tutorials: [Tutorial]
    
    struct EducationSection: Identifiable {
        let id = UUID()
        let title: String
        let content: [ContentItem]
        let difficulty: Difficulty
        let tags: Set<Tag>
    }
    
    struct ContentItem {
        let type: ContentType
        let data: ContentData
        let interactions: [Interaction]
    }
    
    enum ContentType {
        case text, image, video, animation, ar, interactive
    }
    
    enum ContentData {
        case text(String)
        case image(String) // Asset name
        case video(URL)
        case animation(String) // Lottie animation name
        case ar(String) // AR experience identifier
        case interactive(InteractiveContent)
    }
    
    struct InteractiveContent {
        let type: InteractionType
        let data: [String: Any]
    }
    
    enum InteractionType {
        case cloudFormation
        case weatherPrediction
        case atmosphericConditions
        case cloudIdentification
    }
    
    enum Difficulty {
        case beginner, intermediate, advanced, expert
    }
    
    enum Tag: String {
        case basics, formation, weather, science, photography, advanced
    }
    
    struct Interaction {
        let type: InteractionType
        let completion: () -> Void
    }
} 