import SwiftUI

struct TopCloudsSection: View {
    let topClouds: [CloudPost]
    
    @MainActor
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Top Clouds")
                    .font(CloudFonts.headline)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("See All")
                    .font(CloudFonts.body)
                    .foregroundStyle(CloudColors.skyBlue)
            }
            .padding(.horizontal)
            
            HStack(spacing: 12) {
                Group {
                    if !topClouds.isEmpty {
                        TopCloudCard(cloud: topClouds[0])
                            .frame(maxWidth: .infinity)
                    } else {
                        PlaceholderCard()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// Placeholder card view
struct PlaceholderCard: View {
    var body: some View {
        VStack(spacing: 4) {
            // Banner placeholder
            Rectangle()
                .fill(.ultraThinMaterial.opacity(0.5))
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Info row placeholder
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.ultraThinMaterial.opacity(0.5))
                    .frame(width: 60, height: 12)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(.ultraThinMaterial.opacity(0.5))
                    .frame(width: 30, height: 12)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(.ultraThinMaterial.opacity(0.5))
                    .frame(width: 40, height: 12)
            }
            .font(CloudFonts.caption)
        }
        .shimmering()
    }
}

// Shimmer effect modifier
struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .white.opacity(0.5),
                            .clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: -geometry.size.width + (phase * geometry.size.width * 2))
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmering() -> some View {
        modifier(Shimmer())
    }
}

// Preview provider
#Preview {
    TopCloudsSection(topClouds: CloudPost.mockPosts)
        .background(.black)
} 