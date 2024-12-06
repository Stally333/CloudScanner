import SwiftUI

struct WeatherVisualization: View {
    @ObservedObject var weatherService: WeatherService
    @State private var selectedTimeRange: TimeRange = .day
    @State private var selectedView = WeatherViewType.current
    @State private var cloudConditions: WeatherService.CloudConditions?
    @State private var isLoadingCloudData = false
    
    enum TimeRange: String, CaseIterable {
        case day = "24h"
        case week = "7 Days"
        case month = "30 Days"
    }
    
    enum WeatherViewType: String, CaseIterable {
        case current = "Current"
        case forecast = "Forecast"
        case clouds = "Clouds"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                TimeBasedGradient()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        CloudSegmentPicker(
                            items: WeatherViewType.allCases,
                            titleForItem: { $0.rawValue },
                            selection: $selectedView
                        )
                        .padding(.horizontal)
                        
                        switch selectedView {
                        case .current:
                            CurrentWeatherView(weatherService: weatherService)
                        case .forecast:
                            ForecastView(forecast: weatherService.forecast)
                        case .clouds:
                            if isLoadingCloudData {
                                ProgressView()
                            } else if let conditions = cloudConditions {
                                CloudConditionsView(conditions: conditions)
                            } else {
                                Text("Cloud data unavailable")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Weather")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selectedView) { oldValue, newValue in
                if newValue == .clouds {
                    loadCloudConditions()
                }
            }
        }
    }
    
    private func loadCloudConditions() {
        isLoadingCloudData = true
        
        Task {
            do {
                if let location = LocationManager.shared.location {
                    cloudConditions = try await weatherService.fetchCloudConditions(for: location)
                }
            } catch {
                print("Error loading cloud conditions: \(error)")
            }
            isLoadingCloudData = false
        }
    }
}

// Time-based gradient background
struct TimeBasedGradient: View {
    @State private var currentHour = Calendar.current.component(.hour, from: Date())
    
    var gradientColors: [Color] {
        switch currentHour {
        case 5..<8: // Dawn
            return [CloudColors.skyBlue, Color.orange.opacity(0.3)]
        case 8..<17: // Day
            return [CloudColors.skyBlue, CloudColors.deepBlue]
        case 17..<20: // Dusk
            return [CloudColors.deepBlue, CloudColors.twilightPurple]
        default: // Night
            return [Color.black.opacity(0.8), CloudColors.deepBlue]
        }
    }
    
    var body: some View {
        LinearGradient(
            colors: gradientColors,
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// Current weather view with animations
struct CurrentWeatherView: View {
    @ObservedObject var weatherService: WeatherService
    @State private var isAnimating = false
    
    var body: some View {
        if let weather = weatherService.currentWeather {
            VStack(spacing: 30) {
                // Temperature and conditions
                VStack(spacing: 10) {
                    Text("\(Int(weather.temperature))°")
                        .font(.system(size: 80, weight: .thin))
                        .foregroundColor(.white)
                    
                    Text(weather.conditions.map { $0.description }.joined(separator: ", "))
                        .font(CloudFonts.headlineMedium)
                        .foregroundStyle(.white)
                }
                .scaleEffect(isAnimating ? 1 : 0.9)
                
                // Weather details grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    WeatherDetailCard(
                        icon: "humidity",
                        value: "\(Int(weather.humidity))%",
                        title: "Humidity"
                    )
                    
                    WeatherDetailCard(
                        icon: "wind",
                        value: "\(Int(weather.windSpeed)) m/s",
                        title: "Wind"
                    )
                    
                    WeatherDetailCard(
                        icon: "cloud.fill",
                        value: "\(weather.cloudCover)%",
                        title: "Cloud Cover"
                    )
                }
                .padding()
            }
            .onAppear {
                withAnimation(.spring()) {
                    isAnimating = true
                }
            }
        }
    }
}

// Weather detail card with hover effect
struct WeatherDetailCard: View {
    let icon: String
    let value: String
    let title: String
    @State private var isHovered = false
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
            
            Text(value)
                .font(CloudFonts.headlineMedium)
            
            Text(title)
                .font(CloudFonts.caption)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .scaleEffect(isHovered ? 1.05 : 1)
        .animation(.spring(response: 0.3), value: isHovered)
        .onTapGesture {
            withAnimation {
                isHovered.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation {
                    isHovered = false
                }
            }
        }
    }
}

struct WeatherRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}