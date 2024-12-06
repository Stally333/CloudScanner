import SwiftUI

struct PhotoConditionsCard: View {
    let score: Int
    let isGoldenHour: Bool
    let isBlueMoment: Bool
    let visibility: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Photography Conditions")
                    .font(CloudFonts.headline)
                Spacer()
                Text("\(score)%")
                    .font(CloudFonts.title2)
                    .foregroundStyle(scoreColor)
            }
            
            HStack(spacing: 20) {
                if isGoldenHour {
                    Label("Golden Hour", systemImage: "sun.max.fill")
                        .foregroundStyle(.orange)
                }
                if isBlueMoment {
                    Label("Blue Hour", systemImage: "moon.stars.fill")
                        .foregroundStyle(.blue)
                }
                Label("\(Int(visibility/1000))km Visibility", systemImage: "eye.fill")
                    .foregroundStyle(visibility > 8000 ? .green : .orange)
            }
            .font(CloudFonts.caption)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
    
    private var scoreColor: Color {
        switch score {
        case 80...: return .green
        case 60...: return .yellow
        default: return .orange
        }
    }
}

struct CloudTypeCard: View {
    let type: CloudType
    let coverage: Double
    let altitude: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "cloud.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(CloudColors.gradientStart)
                
                VStack(alignment: .leading) {
                    Text(type.name)
                        .font(CloudFonts.headline)
                    Text("\(Int(coverage))% Coverage")
                        .font(CloudFonts.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Divider()
            
            HStack {
                Label("\(Int(altitude))m", systemImage: "arrow.up")
                Spacer()
                Label("Good for Photos", systemImage: "camera.fill")
                    .foregroundStyle(.green)
            }
            .font(CloudFonts.caption)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
} 