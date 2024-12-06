import SwiftUI

struct UserPostsGrid: View {
    @EnvironmentObject var authManager: AuthenticationManager
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(authManager.currentUser?.posts ?? []) { post in
                NavigationLink {
                    CloudPostDetailView(post: post)
                } label: {
                    PostThumbnail(post: post)
                }
            }
        }
        .padding(.horizontal, 2)
    }
} 