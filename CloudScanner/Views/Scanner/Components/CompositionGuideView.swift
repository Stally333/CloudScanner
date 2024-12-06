import SwiftUI

struct CompositionGuideView: View {
    enum Mode {
        case thirds, golden, diagonal, square
    }
    
    let mode: Mode
    let geometry: GeometryProxy
    
    var body: some View {
        switch mode {
        case .thirds:
            ThirdsGuide(geometry: geometry)
        case .golden:
            GoldenRatioGuide(geometry: geometry)
        case .diagonal:
            DiagonalGuide(geometry: geometry)
        case .square:
            SquareGuide(geometry: geometry)
        }
    }
}

private struct ThirdsGuide: View {
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            // Vertical lines
            ForEach(1...2, id: \.self) { i in
                Rectangle()
                    .fill(.white.opacity(0.5))
                    .frame(width: 1)
                    .position(x: geometry.size.width / 3 * CGFloat(i),
                            y: geometry.size.height / 2)
            }
            
            // Horizontal lines
            ForEach(1...2, id: \.self) { i in
                Rectangle()
                    .fill(.white.opacity(0.5))
                    .frame(height: 1)
                    .position(x: geometry.size.width / 2,
                            y: geometry.size.height / 3 * CGFloat(i))
            }
        }
    }
} 