import SwiftUI

struct CameraPermissionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.fill")
                .font(.system(size: 60))
                .foregroundColor(.white)
            
            Text("Camera Access Required")
                .font(CloudFonts.headlineLarge)
                .foregroundColor(.white)
            
            Text("Please allow camera access in Settings to scan clouds")
                .font(CloudFonts.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Open Settings")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
} 