import SwiftUI
import CoreLocation

struct LocationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selection: CLLocation?
    @StateObject private var viewModel = LocationPickerViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button {
                        viewModel.useCurrentLocation()
                        selection = viewModel.currentLocation
                        dismiss()
                    } label: {
                        Label("Current Location", systemImage: "location.fill")
                    }
                }
                
                Section("Saved Locations") {
                    ForEach(viewModel.savedLocations) { location in
                        Button {
                            selection = location.location
                            dismiss()
                        } label: {
                            Label(location.name, systemImage: "mappin.circle.fill")
                        }
                    }
                }
                
                Section("Search") {
                    TextField("Search location...", text: $viewModel.searchText)
                        .textFieldStyle(.roundedBorder)
                    
                    ForEach(viewModel.searchResults) { result in
                        Button {
                            selection = result.location
                            dismiss()
                        } label: {
                            VStack(alignment: .leading) {
                                Text(result.name)
                                Text(result.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Choose Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 