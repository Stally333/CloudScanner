import SwiftUI

struct WeatherDataBadge: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(value)
        }
        .font(CloudFonts.caption)
    }
} 