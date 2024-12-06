import SwiftUI

struct LikedPostsGrid: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(0..<10) { _ in
                LikedCloudCard()
            }
        }
        .padding(.horizontal)
    }
}

struct LikedCloudCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Cloud image
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(4/3, contentMode: .fit)
                .cornerRadius(10)
                .overlay(
                    Image(systemName: "cloud.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                )
            
            // User info
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 20, height: 20)
                Text("@username")
                    .font(CloudFonts.caption)
                Spacer()
                Text("2h")
                    .font(CloudFonts.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
} 