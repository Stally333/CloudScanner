import SwiftUI

// MARK: - Button Style
struct CloudButtonStyle: ButtonStyle {
    enum Style {
        case primary, secondary, destructive
        
        var backgroundColor: Color {
            switch self {
            case .primary: return CloudColors.deepBlue
            case .secondary: return .white.opacity(0.15)
            case .destructive: return .red
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary, .destructive: return .white
            case .secondary: return .white
            }
        }
    }
    
    let style: Style
    
    init(_ style: Style = .primary) {
        self.style = style
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(style.backgroundColor)
            .foregroundStyle(style.foregroundColor)
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

// MARK: - TextField Style
struct CloudTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .foregroundStyle(.white)
    }
}

// MARK: - Card Style
struct CloudCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(radius: 5)
    }
}

// MARK: - Text Styles
struct CloudTextStyle: ViewModifier {
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
    
    func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundStyle(style.color)
    }
}

// MARK: - View Extensions
extension View {
    func cloudCard() -> some View {
        modifier(CloudCardStyle())
    }
    
    func cloudText(_ style: CloudTextStyle.TextStyle) -> some View {
        modifier(CloudTextStyle(style: style))
    }
} 