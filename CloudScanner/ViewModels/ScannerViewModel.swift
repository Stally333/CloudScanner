import AVFoundation
import SwiftUI

@MainActor
class ScannerViewModel: ObservableObject {
    @Published var isCameraEnabled = false
    @Published var showingPermissionAlert = false
    @Published var captureMode: CaptureMode = .photo
    @Published var isFlashEnabled = false
    
    let session = AVCaptureSession()
    private var photoOutput: AVCapturePhotoOutput?
    
    @Published private(set) var detectedClouds: [DetectedCloud] = []
    @Published var isGridVisible = false
    @Published var gridType: CameraGridOverlay.GridType = .rule3x3
    
    private let cloudDetector = CloudDetectionService.shared
    private let weatherService = WeatherService.shared
    
    enum CaptureMode {
        case photo, burst, timelapse
    }
    
    func checkPermissions() async {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isCameraEnabled = true
        case .notDetermined:
            isCameraEnabled = await AVCaptureDevice.requestAccess(for: .video)
        case .denied, .restricted:
            showingPermissionAlert = true
        @unknown default:
            break
        }
    }
    
    func setupCamera() async {
        guard isCameraEnabled else { return }
        
        session.beginConfiguration()
        defer { session.commitConfiguration() }
        
        // Add video input
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                      for: .video,
                                                      position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoInput) else {
            return
        }
        session.addInput(videoInput)
        
        // Add photo output
        let photoOutput = AVCapturePhotoOutput()
        guard session.canAddOutput(photoOutput) else { return }
        session.addOutput(photoOutput)
        self.photoOutput = photoOutput
        
        // Start session
        Task.detached {
            self.session.startRunning()
        }
    }
    
    func capturePhoto() async -> UIImage? {
        guard let photoOutput = photoOutput else { return nil }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        
        return await withCheckedContinuation { continuation in
            let delegate = PhotoCaptureDelegate { image in
                continuation.resume(returning: image)
            }
            
            photoOutput.capturePhoto(with: settings, delegate: delegate)
            // Hold a reference to delegate until capture completes
            _ = delegate
        }
    }
    
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    func analyzeFrame(_ sampleBuffer: CMSampleBuffer) {
        Task {
            if let clouds = try? await cloudDetector.detectClouds(in: sampleBuffer) {
                await MainActor.run {
                    self.detectedClouds = clouds
                }
            }
        }
    }
    
    func toggleGrid() {
        isGridVisible.toggle()
    }
    
    func cycleGridType() {
        switch gridType {
        case .rule3x3: gridType = .golden
        case .golden: gridType = .square
        case .square: gridType = .rule3x3
        }
    }
    
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = isFlashEnabled ? .off : .on
            device.unlockForConfiguration()
            isFlashEnabled.toggle()
        } catch {
            print("Error toggling flash: \(error)")
        }
    }
}

// Photo capture delegate
class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    private let completion: (UIImage?) -> Void
    
    init(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                    didFinishProcessingPhoto photo: AVCapturePhoto,
                    error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            completion(nil)
            return
        }
        completion(image)
    }
} 