import SwiftUI

struct ErrorView: View {
    let error: AppError
    let retryAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.red)
            
            Text(error.localizedDescription)
                .font(CloudFonts.body)
                .multilineTextAlignment(.center)
            
            if let suggestion = error.recoverySuggestion {
                Text(suggestion)
                    .font(CloudFonts.caption)
                    .foregroundStyle(.secondary)
            }
            
            if let retry = retryAction {
                Button("Try Again", action: retry)
                    .buttonStyle(CloudButtonStyle())
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .padding()
    }
} 