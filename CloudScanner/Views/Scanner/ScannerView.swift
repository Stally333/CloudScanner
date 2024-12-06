import SwiftUI
import AVFoundation

struct ScannerView: View {
    @StateObject private var viewModel = ScannerViewModel()
    @StateObject private var weatherService = WeatherService.shared
    @State private var showingGenerativeOptions = false
    @State private var capturedImage: UIImage?
    
    var body: some View {
        ZStack {
            CameraPreviewView(session: viewModel.session)
                .ignoresSafeArea()
            
            CameraOverlayView(
                isEnabled: viewModel.isCameraEnabled,
                captureMode: $viewModel.captureMode,
                viewModel: viewModel,
                weatherService: weatherService,
                onCapture: {
                    Task {
                        if let image = await viewModel.capturePhoto() {
                            capturedImage = image
                            showingGenerativeOptions = true
                        }
                    }
                }
            )
        }
        .sheet(isPresented: $showingGenerativeOptions) {
            if let image = capturedImage {
                GenerativeOptionsView(originalImage: image)
            }
        }
        .task {
            await viewModel.checkPermissions()
            await viewModel.setupCamera()
        }
        .alert("Camera Access Required", isPresented: $viewModel.showingPermissionAlert) {
            Button("Go to Settings", role: .none) {
                viewModel.openSettings()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please allow camera access to use the cloud scanner")
        }
    }
} 