import SwiftUI

struct AdvancedAnalysisView: View {
    @StateObject private var viewModel = CloudAnalysisViewModel()
    let image: UIImage
    
    var body: some View {
        VStack {
            if viewModel.isAnalyzing {
                ProgressView("Performing advanced analysis...")
            } else if let analysis = viewModel.currentAnalysis {
                AdvancedAnalysisResultView(analysis: analysis)
            } else {
                ContentUnavailableView(
                    "No Analysis",
                    systemImage: "cloud.slash",
                    description: Text("Tap analyze to begin")
                )
            }
            
            Button("Advanced Analysis") {
                Task {
                    await viewModel.analyzeCloud(image)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isAnalyzing)
        }
        .padding()
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.error = nil
            }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Unknown error")
        }
    }
} 