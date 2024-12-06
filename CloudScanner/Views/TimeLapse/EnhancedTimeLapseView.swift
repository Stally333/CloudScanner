import SwiftUI

struct EnhancedTimeLapseView: View {
    @StateObject private var timeLapseManager = TimeLapseManager()
    @State private var isRecording = false
    
    var body: some View {
        VStack {
            Text("Time-lapse Coming Soon!")
                .padding()
            
            Button(isRecording ? "Stop Recording" : "Start Recording") {
                isRecording.toggle()
            }
            .padding()
            .background(isRecording ? Color.red : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
} 