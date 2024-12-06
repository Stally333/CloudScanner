import SwiftUI

struct ScanningOverlay: View {
    @State private var animationPhase = 0.0
    let cloudType: String?
    
    var body: some View {
        ZStack {
            // Scanning frame
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    LinearGradient(
                        colors: [.blue.opacity(0.5), .purple.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
                .frame(width: 280, height: 280)
                .overlay {
                    // Scanning line animation
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, .blue.opacity(0.5), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 2)
                        .offset(y: -140 + 280 * animationPhase)
                }
            
            // Cloud type indicator
            if let cloudType = cloudType {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "cloud.fill")
                        Text(cloudType)
                            .font(CloudFonts.headlineMedium)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            withAnimation(
                .linear(duration: 2.0)
                .repeatForever(autoreverses: false)
            ) {
                animationPhase = 1.0
            }
        }
    }
} 