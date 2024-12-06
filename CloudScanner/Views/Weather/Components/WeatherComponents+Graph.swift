import SwiftUI

struct CloudDistributionGraph: View {
    let data: [(String, Double)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                VStack {
                    Text(item.0)
                        .font(CloudFonts.caption)
                        .foregroundStyle(.secondary)
                    
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(CloudColors.gradientStart)
                            .frame(width: geometry.size.width * item.1)
                    }
                    .frame(height: 8)
                    
                    Text("\(Int(item.1 * 100))%")
                        .font(CloudFonts.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
} 