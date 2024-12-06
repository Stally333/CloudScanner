import SwiftUI

struct CloudConditionsView: View {
    let conditions: WeatherService.CloudConditions
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let primaryType = conditions.primaryType {
                CloudTypeCard(
                    type: primaryType,
                    coverage: Double(conditions.coverage),
                    altitude: conditions.altitude
                )
            }
            
            WeatherDataBadge(
                icon: "eye.fill",
                value: "\(Int(conditions.visibility/1000))km Visibility"
            )
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
} 