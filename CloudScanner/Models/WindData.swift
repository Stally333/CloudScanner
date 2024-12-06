import Foundation

struct WindData {
    let speed: Double
    let direction: Double
    let gusts: Double
    let altitude: Double
    let turbulence: Double
    
    var isIdealForPhotography: Bool {
        speed < 15 && turbulence < 0.5
    }
    
    var photographyScore: Int {
        var score = 0
        
        // Wind speed
        if speed < 10 { score += 30 }
        else if speed < 15 { score += 15 }
        
        // Turbulence
        if turbulence < 0.3 { score += 30 }
        else if turbulence < 0.5 { score += 15 }
        
        // Gusts
        if gusts < speed * 1.2 { score += 20 }
        else if gusts < speed * 1.5 { score += 10 }
        
        return score
    }
} 