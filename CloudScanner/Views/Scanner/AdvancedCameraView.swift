import SwiftUI

struct AdvancedCameraView: View {
    @StateObject private var viewModel = AdvancedCameraViewModel()
    
    var body: some View {
        ZStack {
            if let session = viewModel.session {
                CameraPreview(session: session)
                    .ignoresSafeArea()
            }
            // ... rest of view
        }
        .task {
            await viewModel.setupSession()
        }
    }
} 