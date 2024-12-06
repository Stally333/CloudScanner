import SwiftUI

struct CloudAnalysisResultView: View {
    let analysis: CloudAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Analysis Results")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                ResultRow(title: "Cloud Type", value: analysis.cloudType.rawValue)
                ResultRow(title: "Confidence", value: "\(Int(analysis.confidence * 100))%")
                ResultRow(title: "Time", value: analysis.timestamp.formatted())
                
                if let weather = analysis.weatherConditions {
                    ResultRow(title: "Temperature", value: "\(weather.temperature)°")
                    ResultRow(title: "Humidity", value: "\(Int(weather.humidity))%")
                }
                
                if let location = analysis.location {
                    ResultRow(title: "Altitude", value: location.altitude.map { "\($0)m" } ?? "Unknown")
                }
            }
        }
        .padding()
        .background(Material.ultraThin)
        .cornerRadius(12)
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