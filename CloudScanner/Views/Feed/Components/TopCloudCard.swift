import SwiftUI

struct TopCloudCard: View {
    let cloud: CloudPost
    
    var body: some View {
        VStack(spacing: 4) {
            Rectangle()
                .fill(.ultraThinMaterial)
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            HStack(spacing: 8) {
                Text(cloud.location.placeName)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                    Text("\(cloud.likes)")
                }
                
                Text(cloud.cloudType.rawValue)
            }
            .font(CloudFonts.caption)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
} 