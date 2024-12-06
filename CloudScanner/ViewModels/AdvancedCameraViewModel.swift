import AVFoundation
import CoreML
import SwiftUI

@MainActor
class AdvancedCameraViewModel: ObservableObject {
    @Published private(set) var session: AVCaptureSession?
    
    func setupSession() async {
        let session = AVCaptureSession()
        self.session = session
        
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        Task.detached {
            session.startRunning()
        }
    }
} 