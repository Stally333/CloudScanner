import SwiftUI

struct WeatherDataItem: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
            Text(value)
                .font(CloudFonts.caption)
        }
        .foregroundColor(.white)
    }
} 