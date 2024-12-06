import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                TabView {
                    CloudFeedView()  // No need for extra NavigationView since CloudFeedView has its own
                        .tabItem {
                            Image(systemName: "cloud.fill")
                            Text("Feed")
                        }
                    
                    WeatherView()
                        .tabItem {
                            Image(systemName: "sun.max.fill")
                            Text("Weather")
                        }
                    
                    ScannerView()
                        .tabItem {
                            Image(systemName: "camera.fill")
                            Text("Scan")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }
            } else {
                AuthenticationView()
            }
        }
    }
} 