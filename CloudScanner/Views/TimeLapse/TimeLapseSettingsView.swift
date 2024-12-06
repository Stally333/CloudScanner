import SwiftUI

struct TimeLapseSettingsView: View {
    @Binding var settings: TimeLapseSettings
    
    var body: some View {
        Form {
            Section {
                // Duration
                Stepper(value: $settings.duration, in: 300...7200, step: 300) {
                    Text("Duration: \(Int(settings.duration/60)) min")
                }
                
                // Interval
                Stepper(value: $settings.interval, in: 1...30, step: 1) {
                    Text("Interval: \(Int(settings.interval)) sec")
                }
                
                // Frame Rate
                Stepper(value: $settings.frameRate, in: 24...60, step: 6) {
                    Text("Frame Rate: \(Int(settings.frameRate)) fps")
                }
                
                // Quality
                Picker("Quality", selection: $settings.quality) {
                    Text("Low").tag(TimeLapseSettings.VideoQuality.low)
                    Text("Medium").tag(TimeLapseSettings.VideoQuality.medium)
                    Text("High").tag(TimeLapseSettings.VideoQuality.high)
                }
            } header: {
                Text("Settings")
            }
        }
    }
} 