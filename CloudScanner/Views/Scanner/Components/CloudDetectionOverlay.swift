import SwiftUI
import Vision

struct CloudDetectionOverlay: View {
    let detectedClouds: [DetectedCloud]
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(detectedClouds, id: \.bounds) { cloud in
                CloudBoundingBox(
                    cloud: cloud,
                    size: geometry.size
                )
            }
        }
        .allowsHitTesting(false)
    }
}

struct CloudBoundingBox: View {
    let cloud: DetectedCloud
    let size: CGSize
    
    var body: some View {
        let rect = cloud.bounds
        
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 4)
                .stroke(CloudColors.gradientStart, lineWidth: 2)
                .frame(
                    width: rect.width * size.width,
                    height: rect.height * size.height
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(cloud.type.rawValue)
                    .font(.caption.bold())
                Text("\(Int(cloud.confidence * 100))%")
                    .font(.caption2)
            }
            .padding(4)
            .background(.ultraThinMaterial)
            .cornerRadius(4)
        }
        .position(
            x: rect.midX * size.width,
            y: rect.midY * size.height
        )
    }
} 