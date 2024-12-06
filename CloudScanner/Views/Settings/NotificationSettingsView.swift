import SwiftUI

struct NotificationSettingsView: View {
    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var settingsManager = NotificationSettingsManager.shared
    @State private var settings = NotificationSettingsManager.shared.settings
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Comments", isOn: $settings.commentsEnabled)
                    Toggle("Replies", isOn: $settings.repliesEnabled)
                    Toggle("Likes", isOn: $settings.likesEnabled)
                    Toggle("Mentions", isOn: $settings.mentionsEnabled)
                    Toggle("New Followers", isOn: $settings.newFollowersEnabled)
                } header: {
                    Text("Notifications")
                } footer: {
                    if !notificationManager.isAuthorized {
                        Text("Please enable notifications in Settings to receive these alerts")
                            .foregroundStyle(.red)
                    }
                }
                
                if !notificationManager.isAuthorized {
                    Section {
                        Button("Enable Notifications") {
                            Task {
                                try? await notificationManager.requestAuthorization()
                            }
                        }
                    }
                }
            }
            .onChange(of: settings) { newValue in
                settingsManager.updateSettings(newValue)
            }
            .navigationTitle("Notification Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
} 