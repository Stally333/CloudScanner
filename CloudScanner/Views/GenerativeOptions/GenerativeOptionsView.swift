/// A view that provides AI-powered generative options for cloud images
struct GenerativeOptionsView: View {
    @StateObject private var viewModel = GenerativeOptionsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Properties
    let originalImage: UIImage
    let username: String
    let imageUrl: String
    
    // MARK: - Constants
    private enum ViewStrings {
        static let navigationTitle = "Cloud Art"
        static let originalLabel = "Original"
        static let generatedVersionsTitle = "AI Generated Versions"
        static let generatingMessage = "Generating cloud art..."
        static let generateButtonTitle = "Generate Cloud Art"
        static let shareButtonTitle = "Share Images"
        static let cancelButtonTitle = "Cancel"
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    originalImageSection
                    generatedVersionsSection
                    shareButton
                }
                .padding()
            }
            .background(CloudColors.skyGradient.ignoresSafeArea())
            .navigationTitle(ViewStrings.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(ViewStrings.cancelButtonTitle) {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await viewModel.generateVariations(from: originalImage)
        }
    }
    
    // MARK: - View Components
    
    /// Original image preview section
    private var originalImageSection: some View {
        CloudCard {
            Image(uiImage: originalImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 200)
                .cornerRadius(12)
                .overlay(
                    Text(ViewStrings.originalLabel)
                        .font(CloudFonts.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                        .padding(8),
                    alignment: .topLeading
                )
        }
    }
    
    /// Generated versions section
    private var generatedVersionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            CloudText(text: ViewStrings.generatedVersionsTitle, style: .headline)
            
            if viewModel.isLoading {
                generatingView
            } else if !viewModel.generatedImages.isEmpty {
                generatedOptionsGrid
            } else {
                generateButton
            }
        }
    }
    
    /// Loading view while generating images
    private var generatingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text(ViewStrings.generatingMessage)
                .foregroundStyle(.secondary)
        }
        .frame(height: 200)
    }
    
    /// Grid of generated images
    private var generatedOptionsGrid: some View {
        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 16) {
            ForEach(viewModel.generatedImages.indices, id: \.self) { index in
                generatedImageView(viewModel.generatedImages[index])
            }
        }
    }
    
    /// Individual generated image view
    private func generatedImageView(_ image: UIImage) -> some View {
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
    
    /// Generate button
    private var generateButton: some View {
        Button {
            Task {
                await viewModel.generateVariations(from: originalImage)
            }
        } label: {
            Text(ViewStrings.generateButtonTitle)
                .font(CloudFonts.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(CloudColors.gradientStart)
                .cornerRadius(12)
        }
    }
    
    /// Share button for selected images
    private var shareButton: some View {
        Group {
            if viewModel.selectedImage != nil {
                Button {
                    Task {
                        await viewModel.shareImages(
                            original: originalImage,
                            username: username,
                            imageUrl: imageUrl
                        )
                        dismiss()
                    }
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text(ViewStrings.shareButtonTitle)
                    }
                    .font(CloudFonts.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(CloudColors.gradientStart)
                    .cornerRadius(12)
                }
                .disabled(viewModel.isLoading)
                .opacity(viewModel.isLoading ? 0.6 : 1)
            }
        }
    }
} 