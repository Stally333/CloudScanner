import SwiftUI

struct TopCloudsView: View {
    let clouds: [CloudPost]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(clouds) { cloud in
                    TopCloudCard(cloud: cloud)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Top Clouds")
        .navigationBarTitleDisplayMode(.inline)
    }
} 