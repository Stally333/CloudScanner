import SwiftUI
import MapKit

struct WeatherMapView: View {
    @Binding var region: MKCoordinateRegion
    
    var body: some View {
        if #available(iOS 17.0, *) {
            Map(initialPosition: MapCameraPosition.region(region)) {
                // Map content
            }
        } else {
            Map(coordinateRegion: $region)
        }
    }
} 