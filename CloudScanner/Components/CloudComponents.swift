import SwiftUI

// Base Text Styles
struct CloudText: View {
    let text: String
    let style: TextStyle
    
    enum TextStyle {
        case title, headline, body, caption
        
        var font: Font {
            switch self {
            case .title: return CloudFonts.title
            case .headline: return CloudFonts.headlineMedium
            case .body: return CloudFonts.body
            case .caption: return CloudFonts.caption
            }
        }
        
        var color: Color {
            switch self {
            case .title, .headline: return .primary
            case .body: return .primary.opacity(0.8)
            case .caption: return .secondary
            }
        }
    }
    
    var body: some View {
        Text(text)
            .font(style.font)
            .foregroundStyle(style.color)
    }
}

// Custom Button
struct CloudButton: View {
    let title: String
    let action: () -> Void
    let style: ButtonStyle
    
    enum ButtonStyle {
        case primary, secondary, destructive
        
        var backgroundColor: Color {
            switch self {
            case .primary: return CloudColors.deepBlue
            case .secondary: return .white
            case .destructive: return .red
            }
        }
        
        var textColor: Color {
            switch self {
            case .primary: return .white
            case .secondary: return CloudColors.deepBlue
            case .destructive: return .white
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(CloudFonts.headlineMedium)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .padding()
                .background(style.backgroundColor)
                .foregroundColor(style.textColor)
                .cornerRadius(10)
        }
    }
}

// Custom Card
struct CloudCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(radius: 5)
    }
}

// Avatar View
struct CloudAvatar: View {
    let url: String?
    let size: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: url ?? "")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Image(systemName: "person.circle.fill")
                .resizable()
                .foregroundColor(CloudColors.deepBlue)
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().stroke(CloudColors.deepBlue, lineWidth: 2))
    }
} 