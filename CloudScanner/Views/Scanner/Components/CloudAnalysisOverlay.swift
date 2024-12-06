import SwiftUI

struct CloudAnalysisOverlay: View {
    let cloudType: CloudType?
    let confidence: Double
    
    var body: some View {
        VStack(spacing: 12) {
            if let cloudType = cloudType {
                Text(cloudType.name)
                    .font(CloudFonts.headline)
                    .foregroundStyle(.white)
                
                Text("\(Int(confidence * 100))% Confidence")
                    .font(CloudFonts.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
} 