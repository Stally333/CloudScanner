import SwiftUI

struct CameraModeButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
            
            Text(title)
                .font(CloudFonts.caption)
        }
        .foregroundColor(.white)
        .opacity(isSelected ? 1 : 0.6)
    }
} 