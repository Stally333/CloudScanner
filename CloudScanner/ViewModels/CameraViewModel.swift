import AVFoundation
import SwiftUI

@MainActor
class CameraViewModel: ObservableObject {
    @Published var isAuthorized = false
    @Published var isFlashOn = false
    @Published var isHDROn = false
    
    private var captureSession: AVCaptureSession?
    private var photoOutput: AVCapturePhotoOutput?
    
    var session: AVCaptureSession? {
        captureSession
    }
    
    init() {
        checkPermissions()
        setupCaptureSession()
    }
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isAuthorized = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                Task { @MainActor in
                    self?.isAuthorized = granted
                }
            }
        default:
            isAuthorized = false
        }
    }
    
    private func setupCaptureSession() {
        guard isAuthorized else { return }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        
        // Add camera input
        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera),
              session.canAddInput(input) else {
            return
        }
        session.addInput(input)
        
        // Add photo output
        let output = AVCapturePhotoOutput()
        guard session.canAddOutput(output) else { return }
        session.addOutput(output)
        
        session.commitConfiguration()
        
        self.captureSession = session
        self.photoOutput = output
        
        Task.detached {
            session.startRunning()
        }
    }
    
    func toggleFlash() {
        isFlashOn.toggle()
    }
    
    func toggleHDR() {
        isHDROn.toggle()
    }
    
    func switchCamera() {
        // Implementation for switching camera
    }
} 