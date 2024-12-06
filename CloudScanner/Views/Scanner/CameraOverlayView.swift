import SwiftUI

struct CameraOverlayView: View {
    let isEnabled: Bool
    @Binding var captureMode: ScannerViewModel.CaptureMode
    @ObservedObject var viewModel: ScannerViewModel
    @ObservedObject var weatherService: WeatherService
    let onCapture: () -> Void
    
    var body: some View {
        ZStack {
            // Grid overlay if enabled
            if viewModel.isGridVisible {
                CameraGridOverlay(
                    gridType: viewModel.gridType,
                    color: .white
                )
            }
            
            // Cloud detection overlay
            CloudDetectionOverlay(detectedClouds: viewModel.detectedClouds)
            
            VStack {
                if let weather = weatherService.currentWeather {
                    WeatherInfoOverlay(weather: weather)
                }
                
                // Top toolbar
                HStack {
                    Button {
                        viewModel.toggleFlash()
                    } label: {
                        Image(systemName: "bolt.circle")
                            .font(.system(size: 30))
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.toggleGrid()
                    } label: {
                        Image(systemName: "grid")
                            .font(.system(size: 30))
                    }
                }
                .padding()
                .foregroundStyle(.white)
                
                Spacer()
                
                // Bottom controls
                VStack(spacing: 20) {
                    // Capture modes
                    HStack(spacing: 30) {
                        ForEach([ScannerViewModel.CaptureMode.photo,
                                .burst,
                                .timelapse], id: \.self) { mode in
                            Button {
                                captureMode = mode
                            } label: {
                                Text(mode.title)
                                    .font(.subheadline)
                                    .foregroundStyle(captureMode == mode ? .white : .gray)
                            }
                        }
                    }
                    
                    // Capture button
                    Button {
                        onCapture()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 70, height: 70)
                            
                            Circle()
                                .stroke(.white, lineWidth: 3)
                                .frame(width: 80, height: 80)
                        }
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .disabled(!isEnabled)
    }
}

extension ScannerViewModel.CaptureMode {
    var title: String {
        switch self {
        case .photo: return "Photo"
        case .burst: return "Burst"
        case .timelapse: return "Time-lapse"
        }
    }
} 