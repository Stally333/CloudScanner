import SwiftUI

struct AdvancedAnalysisResultView: View {
    let analysis: CloudAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Advanced Analysis")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                Section(title: "Cloud Classification") {
                    ResultRow(title: "Type", value: analysis.cloudType.rawValue)
                    ResultRow(title: "Confidence", value: "\(Int(analysis.confidence * 100))%")
                }
                
                if let weather = analysis.weatherConditions {
                    Section(title: "Weather Conditions") {
                        ResultRow(title: "Temperature", value: "\(weather.temperature)°")
                        ResultRow(title: "Humidity", value: "\(Int(weather.humidity))%")
                        ResultRow(title: "Pressure", value: "\(weather.pressure) hPa")
                        ResultRow(title: "Wind Speed", value: "\(weather.windSpeed) m/s")
                    }
                }
                
                if let location = analysis.location {
                    Section(title: "Location Data") {
                        ResultRow(title: "Latitude", value: String(format: "%.4f", location.latitude))
                        ResultRow(title: "Longitude", value: String(format: "%.4f", location.longitude))
                        if let altitude = location.altitude {
                            ResultRow(title: "Altitude", value: "\(Int(altitude))m")
                        }
                    }
                }
            }
        }
        .padding()
        .background(Material.ultraThin)
        .cornerRadius(12)
    }
}

private struct Section<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
            content
        }
    }
}

private struct ResultRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
    }
} 