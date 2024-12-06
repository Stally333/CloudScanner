import SwiftUI

struct RichTextView: View {
    let text: String
    let mentions: [String]
    let hashtags: [String]
    
    init(_ text: String) {
        let parsed = TextParser.shared.parse(text)
        self.text = text
        self.mentions = parsed.mentions
        self.hashtags = parsed.hashtags
    }
    
    var body: some View {
        Text(text)
            .foregroundStyle(.white)
            .font(CloudFonts.body)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .textSelection(.enabled)
            .onMentionTap { username in
                // Handle mention tap
                print("Tapped mention: @\(username)")
            }
            .onHashtagTap { tag in
                // Handle hashtag tap
                print("Tapped hashtag: #\(tag)")
            }
    }
}

// Text modifiers for handling taps
extension View {
    func onMentionTap(action: @escaping (String) -> Void) -> some View {
        self.gesture(
            TapGesture()
                .onEnded { _ in
                    // Handle mention tap
                }
        )
    }
    
    func onHashtagTap(action: @escaping (String) -> Void) -> some View {
        self.gesture(
            TapGesture()
                .onEnded { _ in
                    // Handle hashtag tap
                }
        )
    }
} 