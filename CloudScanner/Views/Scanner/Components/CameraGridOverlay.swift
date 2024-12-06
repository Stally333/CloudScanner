import SwiftUI

struct CameraGridOverlay: View {
    let gridType: GridType
    let color: Color
    
    enum GridType {
        case rule3x3
        case golden
        case square
    }
    
    var body: some View {
        GeometryReader { geometry in
            switch gridType {
            case .rule3x3:
                rule3x3Grid(size: geometry.size)
            case .golden:
                goldenRatioGrid(size: geometry.size)
            case .square:
                squareGrid(size: geometry.size)
            }
        }
        .allowsHitTesting(false)
    }
    
    private func rule3x3Grid(size: CGSize) -> some View {
        ZStack {
            // Vertical lines
            HStack {
                ForEach(1...2, id: \.self) { index in
                    Spacer()
                    Rectangle()
                        .fill(color.opacity(0.5))
                        .frame(width: 1)
                    if index == 1 { Spacer() }
                }
            }
            
            // Horizontal lines
            VStack {
                ForEach(1...2, id: \.self) { index in
                    Spacer()
                    Rectangle()
                        .fill(color.opacity(0.5))
                        .frame(height: 1)
                    if index == 1 { Spacer() }
                }
            }
        }
    }
    
    private func goldenRatioGrid(size: CGSize) -> some View {
        let goldenRatio: CGFloat = 1.618
        
        return ZStack {
            // Vertical lines
            HStack {
                Spacer()
                    .frame(width: size.width / goldenRatio)
                Rectangle()
                    .fill(color.opacity(0.5))
                    .frame(width: 1)
                Spacer()
            }
            
            // Horizontal lines
            VStack {
                Spacer()
                    .frame(height: size.height / goldenRatio)
                Rectangle()
                    .fill(color.opacity(0.5))
                    .frame(height: 1)
                Spacer()
            }
        }
    }
    
    private func squareGrid(size: CGSize) -> some View {
        let smallerDimension = min(size.width, size.height)
        let offset = (size.width - smallerDimension) / 2
        
        return ZStack {
            Rectangle()
                .stroke(color.opacity(0.5), lineWidth: 1)
                .frame(width: smallerDimension, height: smallerDimension)
                .offset(x: offset)
            
            // Diagonal lines
            Path { path in
                path.move(to: CGPoint(x: offset, y: 0))
                path.addLine(to: CGPoint(x: offset + smallerDimension, y: smallerDimension))
                
                path.move(to: CGPoint(x: offset + smallerDimension, y: 0))
                path.addLine(to: CGPoint(x: offset, y: smallerDimension))
            }
            .stroke(color.opacity(0.5), lineWidth: 1)
        }
    }
}

#Preview {
    ZStack {
        Color.black
        CameraGridOverlay(gridType: .golden, color: .white)
    }
} 