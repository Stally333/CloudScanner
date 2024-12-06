import SwiftUI

struct CloudBackgroundView: View {
    @State private var phase = 0.0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let clouds = [
                    Cloud(x: size.width * 0.2, y: size.height * 0.3, scale: 1.2),
                    Cloud(x: size.width * 0.7, y: size.height * 0.2, scale: 0.8),
                    Cloud(x: size.width * 0.5, y: size.height * 0.6, scale: 1.0),
                    Cloud(x: size.width * 0.8, y: size.height * 0.7, scale: 0.9)
                ]
                
                for cloud in clouds {
                    let x = cloud.x + sin(phase + cloud.x) * 20
                    let y = cloud.y + cos(phase + cloud.y) * 10
                    
                    context.opacity = 0.6
                    context.blendMode = .plusLighter
                    
                    let cloudPath = Path { path in
                        path.addEllipse(in: CGRect(x: x, y: y, width: 60 * cloud.scale, height: 40 * cloud.scale))
                        path.addEllipse(in: CGRect(x: x + 20 * cloud.scale, y: y - 10 * cloud.scale, width: 50 * cloud.scale, height: 35 * cloud.scale))
                        path.addEllipse(in: CGRect(x: x + 40 * cloud.scale, y: y, width: 45 * cloud.scale, height: 30 * cloud.scale))
                    }
                    
                    context.fill(cloudPath, with: .color(Color.white.opacity(0.3)))
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
    
    struct Cloud {
        let x: Double
        let y: Double
        let scale: Double
    }
} 