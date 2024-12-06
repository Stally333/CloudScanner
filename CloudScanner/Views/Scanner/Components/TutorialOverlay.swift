import SwiftUI

struct TutorialOverlay: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Camera Tutorial")
                    .font(CloudFonts.headlineLarge)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 20) {
                    TutorialStep(
                        number: 1,
                        title: "Find a Good Spot",
                        description: "Look for an open area with a clear view of the sky"
                    )
                    
                    TutorialStep(
                        number: 2,
                        title: "Check Weather",
                        description: "Ideal conditions are shown in the weather overlay"
                    )
                    
                    TutorialStep(
                        number: 3,
                        title: "Frame Your Shot",
                        description: "Use composition guides to align your photo"
                    )
                    
                    TutorialStep(
                        number: 4,
                        title: "Capture",
                        description: "Hold steady and tap the capture button"
                    )
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                
                Button("Got it!") {
                    withAnimation {
                        isPresented = false
                    }
                }
                .buttonStyle(CloudButtonStyle())
            }
            .padding()
        }
    }
}

private struct TutorialStep: View {
    let number: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Text("\(number)")
                .font(.title2.bold())
                .frame(width: 36, height: 36)
                .background(CloudColors.deepBlue)
                .foregroundColor(.white)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(CloudFonts.headlineMedium)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(CloudFonts.body)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
} 