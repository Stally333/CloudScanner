import SwiftUI

extension WeatherScoreCard {
    struct ConditionRow: View {
        let icon: String
        let title: String
        let value: String
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                Text(title)
                    .font(CloudFonts.body)
                Spacer()
                Text(value)
                    .font(CloudFonts.body)
                    .foregroundColor(.secondary)
            }
        }
    }
} 