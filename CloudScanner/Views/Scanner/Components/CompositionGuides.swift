import SwiftUI

struct GoldenRatioGuide: View {
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            // Vertical golden ratio lines
            ForEach([0.382, 0.618], id: \.self) { ratio in
                Rectangle()
                    .fill(.white.opacity(0.5))
                    .frame(width: 1)
                    .position(x: geometry.size.width * ratio,
                            y: geometry.size.height / 2)
            }
            
            // Horizontal golden ratio lines
            ForEach([0.382, 0.618], id: \.self) { ratio in
                Rectangle()
                    .fill(.white.opacity(0.5))
                    .frame(height: 1)
                    .position(x: geometry.size.width / 2,
                            y: geometry.size.height * ratio)
            }
        }
    }
}

struct DiagonalGuide: View {
    let geometry: GeometryProxy
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
            path.move(to: CGPoint(x: geometry.size.width, y: 0))
            path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
        }
        .stroke(.white.opacity(0.5), lineWidth: 1)
    }
}

struct SquareGuide: View {
    let geometry: GeometryProxy
    
    var body: some View {
        let size = min(geometry.size.width, geometry.size.height)
        Rectangle()
            .strokeBorder(.white.opacity(0.5), lineWidth: 1)
            .frame(width: size, height: size)
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
    }
}

struct CompositionGuides: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Rule of Thirds
                VStack {
                    Spacer()
                    Rectangle()
                        .frame(height: 1)
                        .opacity(0.3)
                    Spacer()
                    Rectangle()
                        .frame(height: 1)
                        .opacity(0.3)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Rectangle()
                        .frame(width: 1)
                        .opacity(0.3)
                    Spacer()
                    Rectangle()
                        .frame(width: 1)
                        .opacity(0.3)
                    Spacer()
                }
                
                // Center Cross
                Rectangle()
                    .frame(width: 20, height: 1)
                    .opacity(0.5)
                Rectangle()
                    .frame(width: 1, height: 20)
                    .opacity(0.5)
            }
            .foregroundStyle(.white)
        }
    }
} 