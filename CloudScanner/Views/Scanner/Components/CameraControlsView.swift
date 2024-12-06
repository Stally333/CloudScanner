import SwiftUI

struct CameraControlsView: View {
    let isFlashOn: Bool
    let onFlashToggle: () -> Void
    let onCapture: () -> Void
    @State private var showingTutorial = false
    
    var body: some View {
        VStack {
            // Top toolbar
            HStack {
                Button {
                    showingTutorial = true
                } label: {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.title2)
                }
                
                Spacer()
                
                Button {
                    onFlashToggle()
                } label: {
                    Image(systemName: isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                        .font(.title2)
                }
            }
            .padding()
            .foregroundColor(.white)
            
            Spacer()
            
            // Capture button
            Button {
                onCapture()
            } label: {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 65, height: 65)
                    Circle()
                        .stroke(.white, lineWidth: 4)
                        .frame(width: 75, height: 75)
                }
            }
            .padding(.bottom, 30)
        }
        .sheet(isPresented: $showingTutorial) {
            CameraTutorialView()
        }
    }
} 