import SwiftUI

struct HashtagExploreView: View {
    let hashtag: String
    @StateObject private var viewModel = HashtagExploreViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Header
                VStack(spacing: 8) {
                    Text("#\(hashtag)")
                        .font(CloudFonts.title)
                    
                    Text("\(viewModel.posts.count) posts")
                        .font(CloudFonts.body)
                        .foregroundStyle(.secondary)
                }
                .padding()
                
                // Posts grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 2) {
                    ForEach(viewModel.posts) { post in
                        NavigationLink {
                            CloudPostDetailView(post: post)
                        } label: {
                            PostThumbnail(post: post)
                        }
                    }
                }
            }
        }
        .navigationTitle("#\(hashtag)")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchPosts(for: hashtag)
        }
    }
} 