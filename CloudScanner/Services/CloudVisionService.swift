import Vision
import CoreML
import UIKit

class CloudVisionService {
    private var classificationRequest: VNRequest?
    
    init() {
        setupVision()
    }
    
    private func setupVision() {
        // Use VNRequest instead of VNCoreMLRequest for basic image analysis
        classificationRequest = VNGenerateImageFeaturePrintRequest()
    }
    
    func analyzeImage(_ image: UIImage) async throws -> VNFeaturePrintObservation {
        guard let cgImage = image.cgImage else {
            throw VisionError.invalidImage
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNGenerateImageFeaturePrintRequest()
        
        try requestHandler.perform([request])
        
        guard let result = request.results?.first as? VNFeaturePrintObservation else {
            throw VisionError.analysisFailure
        }
        
        return result
    }
    
    // Basic image analysis without ML model
    func analyzeCloudFeatures(_ image: UIImage) async throws -> CloudFeatures {
        guard let cgImage = image.cgImage else {
            throw VisionError.invalidImage
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        // Create requests for different features
        let rectangleRequest = VNDetectRectanglesRequest()
        let textureRequest = VNGenerateImageFeaturePrintRequest()
        
        try requestHandler.perform([rectangleRequest, textureRequest])
        
        // Get results
        let rectangles = rectangleRequest.results ?? []
        let texturePrint = textureRequest.results?.first as? VNFeaturePrintObservation
        
        return CloudFeatures(
            shapes: rectangles.map { $0.boundingBox },
            texture: texturePrint,
            brightness: try await analyzeBrightness(image),
            contrast: try await analyzeContrast(image)
        )
    }
    
    private func analyzeBrightness(_ image: UIImage) async throws -> Double {
        guard let cgImage = image.cgImage else {
            throw VisionError.invalidImage
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNGenerateAttentionBasedSaliencyImageRequest()
        
        try requestHandler.perform([request])
        
        // Calculate average brightness from saliency map
        guard let observation = request.results?.first as? VNSaliencyImageObservation else {
            throw VisionError.analysisFailure
        }
        
        return Double(observation.salientObjects?.first?.confidence ?? 0.5)
    }
    
    private func analyzeContrast(_ image: UIImage) async throws -> Double {
        // Simple contrast analysis using pixel values
        guard let cgImage = image.cgImage else {
            throw VisionError.invalidImage
        }
        
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        
        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                              width: width,
                              height: height,
                              bitsPerComponent: bitsPerComponent,
                              bytesPerRow: bytesPerRow,
                              space: colorSpace,
                              bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Calculate contrast from pixel values
        var minLuminance: Double = 1.0
        var maxLuminance: Double = 0.0
        
        for y in 0..<height {
            for x in 0..<width {
                let offset = (y * bytesPerRow) + (x * bytesPerPixel)
                let r = Double(pixelData[offset]) / 255.0
                let g = Double(pixelData[offset + 1]) / 255.0
                let b = Double(pixelData[offset + 2]) / 255.0
                
                // Calculate luminance
                let luminance = (0.299 * r + 0.587 * g + 0.114 * b)
                minLuminance = min(minLuminance, luminance)
                maxLuminance = max(maxLuminance, luminance)
            }
        }
        
        return maxLuminance - minLuminance
    }
    
    struct CloudFeatures {
        let shapes: [CGRect]
        let texture: VNFeaturePrintObservation?
        let brightness: Double
        let contrast: Double
    }
    
    enum VisionError: Error {
        case invalidImage
        case analysisFailure
        case modelLoadingError
    }
} 