import SwiftUI

struct ErrorOverlay: View {
    let error: Error
    let retryAction: () -> Void
    let dismissAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundStyle(.red)
            
            Text("Error")
                .font(CloudFonts.headlineLarge)
            
            Text(error.localizedDescription)
                .font(CloudFonts.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            VStack(spacing: 12) {
                Button("Try Again") {
                    retryAction()
                }
                .buttonStyle(CloudButtonStyle(.primary))
                
                Button("Dismiss") {
                    dismissAction()
                }
                .buttonStyle(CloudButtonStyle(.secondary))
            }
            .padding(.top)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .padding()
    }
} 