import SwiftUI

struct CameraPermissionDeniedView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.slash.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Camera Access Required")
                .font(CloudFonts.headlineLarge)
            
            Text("CloudScanner needs camera access to analyze clouds. Please enable it in Settings.")
                .font(CloudFonts.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Open Settings")
                    .padding()
                    .background(CloudColors.deepBlue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(CloudColors.skyGradient)
    }
} 