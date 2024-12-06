import SwiftUI

struct StatsOverview: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        HStack(spacing: 20) {
            StatItem(title: "Posts", value: "\(authManager.currentUser?.posts.count ?? 0)")
            StatItem(title: "Following", value: "\(authManager.currentUser?.following.count ?? 0)")
            StatItem(title: "Followers", value: "\(authManager.currentUser?.followers.count ?? 0)")
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(CloudFonts.headlineLarge)
                .foregroundColor(CloudColors.deepBlue)
            
            Text(title)
                .font(CloudFonts.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
} 