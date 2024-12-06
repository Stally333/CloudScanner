import SwiftUI

struct SlideInModifier: ViewModifier {
    let delay: Double
    @State private var isShown = false
    
    func body(content: Content) -> some View {
        content
            .offset(y: isShown ? 0 : 50)
            .opacity(isShown ? 1 : 0)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay)) {
                    isShown = true
                }
            }
    }
}

struct ScaleInModifier: ViewModifier {
    let delay: Double
    @State private var isShown = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isShown ? 1 : 0.5)
            .opacity(isShown ? 1 : 0)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay)) {
                    isShown = true
                }
            }
    }
}

extension View {
    func slideIn(delay: Double = 0) -> some View {
        modifier(SlideInModifier(delay: delay))
    }
    
    func scaleIn(delay: Double = 0) -> some View {
        modifier(ScaleInModifier(delay: delay))
    }
} 