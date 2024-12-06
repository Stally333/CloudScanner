import SwiftUI

struct ProcessingOverlay: View {
    @State private var rotation = 0.0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 44))
                    .rotationEffect(.degrees(rotation))
                    .onAppear {
                        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                            rotation = 360
                        }
                    }
                
                Text("Analyzing Cloud...")
                    .font(CloudFonts.headlineMedium)
            }
            .foregroundColor(.white)
        }
    }
} 