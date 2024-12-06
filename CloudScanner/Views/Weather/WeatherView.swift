import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var showingLocationPicker = false
    @State private var selectedTimeRange: TimeRange = .day
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                // MARK: - Location Header
                LocationHeader(
                    location: viewModel.currentLocation,
                    showingPicker: $showingLocationPicker
                )
                .padding(.horizontal)
                
                // MARK: - Current Weather
                if let weather = viewModel.currentWeather {
                    CurrentWeatherCard(weather: weather)
                        .padding(.horizontal)
                }
                
                // MARK: - Photography Conditions
                PhotoConditionsCard(
                    score: viewModel.currentWeather?.photographyScore ?? 0,
                    isGoldenHour: viewModel.currentWeather?.isGoldenHour ?? false,
                    isBlueMoment: viewModel.currentWeather?.isBlueMoment ?? false,
                    visibility: viewModel.currentWeather?.visibility ?? 0
                )
                .padding(.horizontal)
                
                // MARK: - Cloud Analysis
                if let conditions = viewModel.cloudConditions {
                    CloudAnalysisSection(
                        conditions: conditions,
                        cloudImages: viewModel.cloudImages
                    )
                }
                
                // MARK: - Forecast
                ForecastSection(
                    selectedRange: $selectedTimeRange,
                    forecast: viewModel.forecast
                )
                
                // MARK: - Photography Timing
                PhotoTimingCard(
                    sunrise: Date().addingTimeInterval(3600),
                    sunset: Date().addingTimeInterval(43200),
                    goldenHours: [
                        Date().addingTimeInterval(7200),
                        Date().addingTimeInterval(39600)
                    ],
                    blueMoments: [
                        Date().addingTimeInterval(5400),
                        Date().addingTimeInterval(41400)
                    ]
                )
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(CloudColors.skyGradient.ignoresSafeArea())
        .sheet(isPresented: $showingLocationPicker) {
            LocationPickerView(selection: $viewModel.selectedLocation)
        }
        .task {
            await viewModel.fetchWeather()
        }
    }
}

// MARK: - Location Header
private struct LocationHeader: View {
    let location: String?
    @Binding var showingPicker: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(location ?? "Current Location")
                    .font(CloudFonts.title3)
                Text(Date().formatted(.dateTime.weekday().hour()))
                    .font(CloudFonts.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                showingPicker = true
            } label: {
                Label("Change Location", systemImage: "location.circle.fill")
                    .foregroundStyle(.white)
                    .font(CloudFonts.body)
            }
        }
    }
}

// MARK: - Cloud Analysis Section
private struct CloudAnalysisSection: View {
    let conditions: WeatherService.CloudConditions
    let cloudImages: [UIImage]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Cloud Analysis")
                    .font(CloudFonts.headline)
                Spacer()
                CloudQualityBadge(quality: conditions.quality)
            }
            .padding(.horizontal)
            
            if let primaryType = conditions.primaryType {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Primary Cloud Type")
                        .font(CloudFonts.caption)
                    
                    CloudTypeCard(
                        type: primaryType,
                        coverage: Double(conditions.coverage),
                        altitude: conditions.altitude
                    )
                }
                .padding(.horizontal)
            }
            
            CloudImageStream(images: cloudImages)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Cloud Distribution")
                    .font(CloudFonts.caption)
                CloudDistributionGraph(data: conditions.distribution)
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Forecast Section
private struct ForecastSection: View {
    @Binding var selectedRange: TimeRange
    let forecast: [WeatherService.ForecastData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Forecast")
                    .font(CloudFonts.headline)
                Spacer()
                Picker("Time Range", selection: $selectedRange) {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(forecast) { forecast in
                        ForecastCard(data: forecast)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Cloud Image Stream
private struct CloudImageStream: View {
    let images: [UIImage]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(images.indices, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Image(uiImage: images[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160, height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        Text("Similar Cloud")
                            .font(CloudFonts.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
} 