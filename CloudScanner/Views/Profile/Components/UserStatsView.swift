import SwiftUI

struct UserStatsView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Activity chart
            ActivityChart()
            
            // Stats cards
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                StatCard(title: "Most Active Time", value: "2-4 PM", icon: "clock.fill")
                StatCard(title: "Favorite Cloud Type", value: "Cumulus", icon: "cloud.fill")
                StatCard(title: "Average Float Ups", value: "234", icon: "arrow.up.heart.fill")
                StatCard(title: "Posting Streak", value: "12 days", icon: "flame.fill")
            }
            .padding(.horizontal)
        }
    }
}

struct ActivityChart: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Activity")
                .font(CloudFonts.headlineMedium)
            
            // Placeholder chart
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<7) { _ in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(CloudColors.deepBlue)
                        .frame(width: 30, height: CGFloat.random(in: 50...150))
                }
            }
            .frame(height: 150)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(CloudColors.deepBlue)
            
            Text(value)
                .font(CloudFonts.headlineMedium)
            
            Text(title)
                .font(CloudFonts.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
    }
} 