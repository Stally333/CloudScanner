import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel: FeedViewModel
    
    init() {
        // Initialize on the main thread
        let viewModel = FeedViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                TopCloudsSection(topClouds: viewModel.topClouds)
                
                ForEach(viewModel.posts) { post in
                    CloudPostCard(post: post)
                }
            }
        }
        .refreshable {
            await viewModel.fetchPosts()
            await viewModel.loadTopClouds()
        }
        .task {
            await viewModel.fetchPosts()
            await viewModel.loadTopClouds()
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.error != nil },
            set: { if !$0 { viewModel.error = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            if let error = viewModel.error {
                Text(error.localizedDescription)
            }
        }
    }
}

#Preview {
    FeedView()
        .preferredColorScheme(.dark)
} 