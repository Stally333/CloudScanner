import SwiftUI

struct ScanningAnimation: View {
    @State private var opacity = 0.0
    
    var body: some View {
        Rectangle()
            .fill(.white.opacity(0.3))
            .opacity(opacity)
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5).repeatForever()) {
                    opacity = 0.1
                }
            }
    }
} 