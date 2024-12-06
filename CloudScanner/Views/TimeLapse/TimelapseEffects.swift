import SwiftUI

struct DayNightGradient: View {
    @State private var progress: CGFloat = 0
    
    var body: some View {
        LinearGradient(
            colors: [
                Color(.sRGB, red: 0.2, green: 0.2, blue: 0.6, opacity: progress),
                Color(.sRGB, red: 0.8, green: 0.6, blue: 0.3, opacity: 1 - progress)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever()) {
                progress = 1
            }
        }
    }
}

struct CloudMotionTrails: View {
    @State private var trails: [CloudTrail] = []
    
    struct CloudTrail: Identifiable {
        let id = UUID()
        var position: CGPoint
        var opacity: Double
        var scale: CGFloat
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for trail in trails {
                    context.opacity = trail.opacity
                    context.scaleBy(x: trail.scale, y: trail.scale)
                    
                    let cloudPath = Path { path in
                        path.addArc(
                            center: trail.position,
                            radius: 20,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360),
                            clockwise: true
                        )
                    }
                    
                    context.stroke(
                        cloudPath,
                        with: .color(.white),
                        lineWidth: 2
                    )
                }
            }
        }
        .onAppear {
            startTrailAnimation()
        }
    }
    
    private func startTrailAnimation() {
        // Animate cloud trails
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation {
                updateTrails()
            }
        }
    }
    
    private func updateTrails() {
        // Update trail positions and properties
    }
}

struct WeatherTransitionEffect: View {
    @State private var currentWeather: WeatherType = .sunny
    @State private var transitionProgress: CGFloat = 0
    
    enum WeatherType {
        case sunny, cloudy, rainy, stormy
        
        var particles: some View {
            switch self {
            case .sunny:
                return AnyView(SunRaysEffect())
            case .cloudy:
                return AnyView(CloudParticles())
            case .rainy:
                return AnyView(RainEffect())
            case .stormy:
                return AnyView(StormEffect())
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            currentWeather.particles
                .opacity(1 - transitionProgress)
            
            if transitionProgress > 0 {
                nextWeather.particles
                    .opacity(transitionProgress)
            }
        }
        .onChange(of: currentWeather) { _ in
            withAnimation(.easeInOut(duration: 2)) {
                transitionProgress = 1
            }
        }
    }
    
    private var nextWeather: WeatherType {
        switch currentWeather {
        case .sunny: return .cloudy
        case .cloudy: return .rainy
        case .rainy: return .stormy
        case .stormy: return .sunny
        }
    }
}

// Weather Effect Components
struct SunRaysEffect: View {
    @State private var rotation = 0.0
    
    var body: some View {
        ZStack {
            ForEach(0..<8) { i in
                Rectangle()
                    .fill(Color.yellow.opacity(0.3))
                    .frame(width: 4, height: 100)
                    .rotationEffect(.degrees(Double(i) * 45 + rotation))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

struct CloudParticles: View {
    @State private var particles: [CloudParticle] = []
    
    struct CloudParticle: Identifiable {
        let id = UUID()
        var position: CGPoint
        var size: CGFloat
        var opacity: Double
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for particle in particles {
                    context.opacity = particle.opacity
                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: particle.position.x,
                            y: particle.position.y,
                            width: particle.size,
                            height: particle.size
                        )),
                        with: .color(.white)
                    )
                }
            }
        }
    }
}

struct RainEffect: View {
    @State private var raindrops: [Raindrop] = []
    
    struct Raindrop: Identifiable {
        let id = UUID()
        var position: CGPoint
        var length: CGFloat
        var speed: Double
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for drop in raindrops {
                    let path = Path { path in
                        path.move(to: drop.position)
                        path.addLine(to: CGPoint(
                            x: drop.position.x,
                            y: drop.position.y + drop.length
                        ))
                    }
                    context.stroke(
                        path,
                        with: .color(.blue.opacity(0.5)),
                        lineWidth: 1
                    )
                }
            }
        }
    }
}

struct StormEffect: View {
    @State private var lightningFlash = false
    @State private var thunderDelay: Double = 0
    
    var body: some View {
        ZStack {
            // Dark clouds
            CloudParticles()
                .colorInvert()
            
            // Lightning
            if lightningFlash {
                Color.white
                    .opacity(0.8)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
            
            // Rain
            RainEffect()
        }
        .onAppear {
            startStorm()
        }
    }
    
    private func startStorm() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            createLightning()
        }
    }
    
    private func createLightning() {
        withAnimation(.easeIn(duration: 0.1)) {
            lightningFlash = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeOut(duration: 0.1)) {
                lightningFlash = false
            }
        }
    }
} 