import SwiftUI

enum CloudAnimation {
    static let spring = Animation.spring(response: 0.5, dampingFraction: 0.7)
    static let bouncy = Animation.spring(response: 0.6, dampingFraction: 0.6)
    static let smooth = Animation.easeInOut(duration: 0.3)
    
    struct Transition {
        static let slide = AnyTransition.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
        
        static let scale = AnyTransition.scale(scale: 0.9)
            .combined(with: .opacity)
        
        static let fade = AnyTransition.opacity
            .combined(with: .scale(scale: 0.95))
            .animation(.easeInOut(duration: 0.2))
    }
    
    struct FeedTransition: ViewModifier {
        let delay: Double
        @State private var isShown = false
        
        func body(content: Content) -> some View {
            content
                .opacity(isShown ? 1 : 0)
                .offset(y: isShown ? 0 : 20)
                .onAppear {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay)) {
                        isShown = true
                    }
                }
        }
    }
}

extension View {
    func feedTransition(delay: Double = 0) -> some View {
        modifier(CloudAnimation.FeedTransition(delay: delay))
    }
} 