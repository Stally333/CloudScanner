import SwiftUI

// MARK: - Photo Timing Card
struct PhotoTimingCard: View {
    let sunrise: Date
    let sunset: Date
    let goldenHours: [Date]  // [morning, evening]
    let blueMoments: [Date]  // [morning, evening]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Best Times for Photography")
                .font(CloudFonts.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                TimeRow(
                    title: "Sunrise",
                    time: sunrise,
                    icon: "sunrise.fill",
                    color: .orange
                )
                
                TimeRow(
                    title: "Golden Hours",
                    time: goldenHours[0],
                    secondTime: goldenHours[1],
                    icon: "sun.max.fill",
                    color: .orange
                )
                
                TimeRow(
                    title: "Blue Moments",
                    time: blueMoments[0],
                    secondTime: blueMoments[1],
                    icon: "moon.stars.fill",
                    color: .blue
                )
                
                TimeRow(
                    title: "Sunset",
                    time: sunset,
                    icon: "sunset.fill",
                    color: .orange
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

// MARK: - Time Row Component
private struct TimeRow: View {
    let title: String
    let time: Date
    var secondTime: Date?
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)
            
            Text(title)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            if let second = secondTime {
                Text(time.formatted(.dateTime.hour().minute()))
                Text("&")
                    .foregroundStyle(.secondary)
                Text(second.formatted(.dateTime.hour().minute()))
            } else {
                Text(time.formatted(.dateTime.hour().minute()))
            }
        }
        .font(CloudFonts.caption)
    }
} 