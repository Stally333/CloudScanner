import SwiftUI

struct GenerativeOptionsView: View {
    let originalImage: UIImage
    @StateObject private var viewModel = GenerativeOptionsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Original Image
                    Image(uiImage: originalImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 200)
                        .cornerRadius(12)
                    
                    // AI Generated Options
                    Text("AI Generated Versions")
                        .font(.headline)
                    
                    if viewModel.isGenerating {
                        generatingView
                    } else if !viewModel.generatedImages.isEmpty {
                        generatedOptionsGrid
                    } else {
                        generateButton
                    }
                    
                    // Share Button
                    if viewModel.selectedImage != nil {
                        Button {
                            Task {
                                await viewModel.shareImages(original: originalImage)
                            }
                        } label: {
                            Text("Share Images")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(CloudColors.gradientStart)
                                .cornerRadius(12)
                        }
                        .padding(.top)
                    }
                }
                .padding()
            }
            .navigationTitle("Cloud Art")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var generatingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Generating cloud art...")
                .foregroundStyle(.secondary)
        }
        .frame(height: 200)
    }
    
    private var generatedOptionsGrid: some View {
        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 16) {
            ForEach(viewModel.generatedImages.indices, id: \.self) { index in
                let image = viewModel.generatedImages[index]
                Button {
                    viewModel.selectedImage = image
                } label: {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            if viewModel.selectedImage == image {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(CloudColors.gradientStart, lineWidth: 3)
                            }
                        }
                }
            }
        }
    }
    
    private var generateButton: some View {
        Button {
            Task {
                await viewModel.generateVariations(from: originalImage)
            }
        } label: {
            Text("Generate Cloud Art")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(CloudColors.gradientStart)
                .cornerRadius(12)
        }
    }
} 