import SwiftUI

struct CloudImagePlaceholder: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .frame(maxWidth: .infinity)
                .frame(height: 360)
            
            VStack(spacing: 12) {
                Image(systemName: "cloud.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(CloudColors.gradientStart)
                
                Text("No Image")
                    .font(CloudFonts.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct ProfileImagePlaceholder: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: size, height: size)
            
            Image(systemName: "person.circle.fill")
                .font(.system(size: size * 0.8))
                .foregroundStyle(CloudColors.gradientStart)
        }
        .overlay(
            Circle()
                .stroke(CloudColors.gradientMiddle, lineWidth: 2)
        )
    }
} 