import Foundation

struct CloudQuiz {
    let id = UUID()
    let title: String
    let questions: [Question]
    let difficulty: Difficulty
    let timeLimit: TimeInterval?
    
    struct Question {
        let text: String
        let type: QuestionType
        let answers: [Answer]
        let explanation: String
        
        struct Answer {
            let text: String
            let isCorrect: Bool
            let feedback: String?
        }
    }
    
    enum QuestionType {
        case multipleChoice
        case trueFalse
        case imageIdentification
        case weatherPrediction
    }
    
    enum Difficulty {
        case beginner, intermediate, advanced
    }
} 