import Foundation

class TextParser {
    static let shared = TextParser()
    
    struct ParsedText {
        let text: String
        let mentions: [String]
        let hashtags: [String]
        let ranges: [NSRange]
        let types: [TokenType]
    }
    
    enum TokenType {
        case mention
        case hashtag
        case url
        case plain
    }
    
    func parse(_ text: String) -> ParsedText {
        var mentions: [String] = []
        var hashtags: [String] = []
        var ranges: [NSRange] = []
        var types: [TokenType] = []
        
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        var currentIndex = 0
        
        for word in words {
            if word.starts(with: "@") {
                let mention = String(word.dropFirst())
                mentions.append(mention)
                let range = NSRange(location: currentIndex, length: word.count)
                ranges.append(range)
                types.append(.mention)
            } else if word.starts(with: "#") {
                let hashtag = String(word.dropFirst())
                hashtags.append(hashtag)
                let range = NSRange(location: currentIndex, length: word.count)
                ranges.append(range)
                types.append(.hashtag)
            }
            currentIndex += word.count + 1 // +1 for space
        }
        
        return ParsedText(
            text: text,
            mentions: mentions,
            hashtags: hashtags,
            ranges: ranges,
            types: types
        )
    }
} 