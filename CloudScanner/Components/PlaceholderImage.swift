import SwiftUI
import CoreGraphics

struct PlaceholderImage: View {
    let size: CGFloat
    let systemName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
            
            Image(systemName: systemName)
                .font(.system(size: size))
                .foregroundStyle(CloudColors.gradientStart)
        }
    }
}

struct ProfilePlaceholder: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: size, height: size)
            
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: size * 0.8))
                .foregroundStyle(CloudColors.gradientStart)
        }
    }
}