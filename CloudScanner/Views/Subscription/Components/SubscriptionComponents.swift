import SwiftUI

struct PremiumBadge: View {
    var body: some View {
        Text("PREMIUM")
            .font(CloudFonts.caption)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                LinearGradient(
                    colors: [CloudColors.gradientStart, CloudColors.gradientMiddle],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
    }
}

struct FeatureAccessBadge: View {
    let isAccessible: Bool
    
    var body: some View {
        Image(systemName: isAccessible ? "checkmark.circle.fill" : "lock.fill")
            .foregroundStyle(isAccessible ? CloudColors.gradientStart : .gray)
            .font(.system(size: 20))
    }
}

struct PremiumCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [CloudColors.gradientStart, CloudColors.gradientMiddle],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
    }
} 