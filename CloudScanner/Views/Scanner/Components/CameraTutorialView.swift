import SwiftUI

struct CameraTutorialView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 30) {
                    // Tutorial sections
                    TutorialSection(
                        icon: "camera.viewfinder",
                        title: "Frame the Cloud",
                        description: "Position your camera so the cloud is clearly visible in the frame."
                    )
                    
                    TutorialSection(
                        icon: "hand.raised",
                        title: "Hold Steady",
                        description: "Keep your device stable for the best analysis results."
                    )
                    
                    TutorialSection(
                        icon: "sun.max",
                        title: "Lighting Matters",
                        description: "Try to capture clouds in good lighting conditions for accurate detection."
                    )
                    
                    TutorialSection(
                        icon: "arrow.up.doc",
                        title: "Share & Learn",
                        description: "Share your cloud observations with the community and learn from others."
                    )
                }
                .padding()
            }
            .background(CloudColors.skyGradient.ignoresSafeArea())
            .navigationTitle("How to Use")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TutorialSection: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(CloudColors.deepBlue)
            
            Text(title)
                .font(CloudFonts.headlineMedium)
            
            Text(description)
                .font(CloudFonts.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
} 