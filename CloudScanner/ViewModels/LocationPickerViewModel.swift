import SwiftUI
import CoreLocation

@MainActor
class LocationPickerViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [LocationResult] = []
    @Published var savedLocations: [SavedLocation] = []
    @Published var currentLocation: CLLocation?
    
    private let locationManager = LocationManager.shared
    private let geocoder = CLGeocoder()
    
    struct LocationResult: Identifiable {
        let id = UUID()
        let name: String
        let description: String
        let location: CLLocation
    }
    
    struct SavedLocation: Identifiable {
        let id = UUID()
        let name: String
        let location: CLLocation
    }
    
    init() {
        loadSavedLocations()
        
        // Watch for search text changes
        Task {
            for await text in $searchText.values where !text.isEmpty {
                await searchLocations(text)
            }
        }
    }
    
    func useCurrentLocation() {
        currentLocation = locationManager.location
    }
    
    private func loadSavedLocations() {
        // TODO: Load from UserDefaults or other storage
        savedLocations = [
            SavedLocation(
                name: "New York",
                location: CLLocation(latitude: 40.7128, longitude: -74.0060)
            ),
            SavedLocation(
                name: "London",
                location: CLLocation(latitude: 51.5074, longitude: -0.1278)
            )
        ]
    }
    
    private func searchLocations(_ query: String) async {
        do {
            let placemarks = try await geocoder.geocodeAddressString(query)
            searchResults = placemarks.compactMap { placemark in
                guard let location = placemark.location else { return nil }
                return LocationResult(
                    name: placemark.name ?? query,
                    description: placemark.formattedAddress ?? "",
                    location: location
                )
            }
        } catch {
            print("Geocoding error: \(error)")
            searchResults = []
        }
    }
}

// Helper for formatted address
private extension CLPlacemark {
    var formattedAddress: String? {
        let components = [
            locality,
            administrativeArea,
            country
        ].compactMap { $0 }
        
        return components.joined(separator: ", ")
    }
} 