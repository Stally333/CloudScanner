import SwiftUI

struct CaptureButton: View {
    let isRecording: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .stroke(Color.white, lineWidth: 3)
                .frame(width: 70, height: 70)
                .overlay(
                    Circle()
                        .fill(isRecording ? .red : .white)
                        .frame(width: 54, height: 54)
                )
        }
    }
} 