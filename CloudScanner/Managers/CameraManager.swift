import AVFoundation
import UIKit

class CameraManager: NSObject {
    private var captureSession: AVCaptureSession?
    private var photoOutput: AVCapturePhotoOutput?
    private var currentCapturePromise: ((Result<UIImage, Error>) -> Void)?
    
    override init() {
        super.init()
        setupCaptureSession()
    }
    
    func requestAuthorization() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)
        default:
            return false
        }
    }
    
    func startSession() -> AVCaptureSession? {
        captureSession?.startRunning()
        return captureSession
    }
    
    func stopSession() {
        captureSession?.stopRunning()
    }
    
    func cleanup() {
        stopSession()
        captureSession = nil
        photoOutput = nil
    }
    
    func capturePhoto() async throws -> UIImage {
        guard let photoOutput = photoOutput else {
            throw CameraError.notReady
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let settings = AVCapturePhotoSettings()
            currentCapturePromise = { result in
                continuation.resume(with: result)
            }
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }
    
    private func setupCaptureSession() {
        let session = AVCaptureSession()
        session.beginConfiguration()
        
        // Add video input
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoInput) else {
            return
        }
        session.addInput(videoInput)
        
        // Add photo output
        let output = AVCapturePhotoOutput()
        guard session.canAddOutput(output) else { return }
        session.addOutput(output)
        
        session.commitConfiguration()
        
        self.captureSession = session
        self.photoOutput = output
    }
    
    enum CameraError: LocalizedError {
        case notReady
        case captureFailed
        case processingFailed
        
        var errorDescription: String? {
            switch self {
            case .notReady: return "Camera is not ready"
            case .captureFailed: return "Failed to capture photo"
            case .processingFailed: return "Failed to process photo"
            }
        }
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            currentCapturePromise?(.failure(error))
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            currentCapturePromise?(.failure(CameraError.processingFailed))
            return
        }
        
        currentCapturePromise?(.success(image))
    }
} 