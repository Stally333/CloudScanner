import SwiftUI

struct CloudFeedView: View {
    @StateObject private var viewModel = CloudFeedViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Top Clouds Section
                    TopCloudsSection(topClouds: viewModel.topClouds)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    
                    // Regular Feed Posts
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.posts) { post in
                            CloudPostCard(post: post)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(
                LinearGradient(
                    colors: [CloudColors.gradientStart, CloudColors.gradientMiddle, CloudColors.gradientEnd],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Cloud Feed")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    // Menu action
                }) {
                    Image(systemName: "line.3.horizontal")
                        .foregroundStyle(.white)
                }
            )
        }
    }
} 