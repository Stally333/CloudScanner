import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showingSubscription = false
    @State private var showingNotificationSettings = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    if let user = authManager.currentUser {
                        Text(user.email)
                        Text(user.username)
                    }
                    
                    Button("Sign Out", role: .destructive) {
                        authManager.signOut()
                    }
                }
                
                Section("Preferences") {
                    NavigationLink("Notifications") {
                        NotificationSettingsView()
                    }
                    NavigationLink("Tutorial") {
                        TutorialView()
                    }
                    Button("Contact Support") {
                        // Open support
                    }
                }
                
                Section("About") {
                    NavigationLink("About CloudScanner") {
                        AboutView()
                    }
                    NavigationLink("Privacy Policy") {
                        PrivacyPolicyView()
                    }
                    NavigationLink("Terms of Service") {
                        TermsView()
                    }
                }
                
                Section("Premium") {
                    Button {
                        showingSubscription = true
                    } label: {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(CloudColors.gradientStart)
                            Text("Subscription Options")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingSubscription) {
                SubscriptionView()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthenticationManager.shared)
} 
