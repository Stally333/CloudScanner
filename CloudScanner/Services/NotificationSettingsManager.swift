import Foundation
import SwiftUI

@MainActor
class NotificationSettingsManager: ObservableObject {
    static let shared = NotificationSettingsManager()
    
    @Published private(set) var settings: NotificationSettings {
        didSet {
            save()
        }
    }
    
    private let defaults = UserDefaults.standard
    private let settingsKey = "notification_settings"
    
    private init() {
        if let data = defaults.data(forKey: settingsKey),
           let settings = try? JSONDecoder().decode(NotificationSettings.self, from: data) {
            self.settings = settings
        } else {
            self.settings = .default
        }
    }
    
    func updateSettings(_ settings: NotificationSettings) {
        self.settings = settings
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(settings) {
            defaults.set(data, forKey: settingsKey)
        }
    }
} 