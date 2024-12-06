import SwiftUI

struct WeatherConditionRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(verbatim: text)
        }
        .foregroundColor(color)
    }
}

#if DEBUG
struct WeatherConditionRow_Previews: PreviewProvider {
    static var previews: some View {
        WeatherConditionRow(
            icon: "sun.max",
            text: "Golden Hour",
            color: .orange
        )
        .padding()
    }
}
#endif 