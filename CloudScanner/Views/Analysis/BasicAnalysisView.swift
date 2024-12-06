import SwiftUI

struct BasicAnalysisView: View {
    @StateObject private var viewModel = CloudAnalysisViewModel()
    let image: UIImage
    
    var body: some View {
        VStack {
            if viewModel.isAnalyzing {
                ProgressView("Analyzing cloud...")
            } else if let analysis = viewModel.currentAnalysis {
                CloudAnalysisResultView(analysis: analysis)
            } else {
                ContentUnavailableView(
                    "No Analysis",
                    systemImage: "cloud.slash",
                    description: Text("Tap analyze to begin")
                )
            }
            
            Button("Analyze") {
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