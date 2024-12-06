import SwiftUI

struct CameraUnavailableView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.slash.fill")
                .font(.system(size: 60))
                .foregroundColor(.white)
            
            Text("Camera Unavailable")
                .font(CloudFonts.headlineLarge)
                .foregroundColor(.white)
            
            Text("Please check your camera permissions in Settings.")
                .font(CloudFonts.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Open Settings")
                    .font(CloudFonts.headlineMedium)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(CloudColors.skyGradient)
    }
} 