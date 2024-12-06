import SwiftUI

@main
struct AppMain: App {
    @StateObject private var authManager = AuthenticationManager.shared
    @StateObject private var weatherService = WeatherService.shared
    @StateObject private var locationManager = LocationManager.shared
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(weatherService)
                .environmentObject(locationManager)
                .preferredColorScheme(.dark)
                .task {
                    await preloadData()
                }
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    case .active:
                        Task { await onAppBecameActive() }
                    case .background:
                        Task { await onAppEnteredBackground() }
                    default:
                        break
                    }
                }
        }
    }
    
    private func preloadData() async {
        if let location = locationManager.location {
            Task {
                _ = try? await weatherService.fetchWeather(for: location)
            }
        }
        
        Task {
            _ = try? await CloudDataService.shared.fetchPosts(filter: .all)
        }
    }
    
    private func onAppBecameActive() async {}
    
    private func onAppEnteredBackground() async {}
} 