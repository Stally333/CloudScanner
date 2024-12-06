import SwiftUI

struct SocialSignInButton: View {
    let icon: String
    let title: String
    let iconImage: Image
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                iconImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(CloudFonts.body)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
        .frame(height: 52)
    }
} 