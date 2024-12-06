import SwiftUI

struct PostThumbnail: View {
    let post: CloudPost
    
    var body: some View {
        Image(post.imageUrl)
            .resizable()
            .aspectRatio(1, contentMode: .fill)
            .clipped()
    }
} 