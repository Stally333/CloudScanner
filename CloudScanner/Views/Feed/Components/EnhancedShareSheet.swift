import SwiftUI
import UIKit

struct EnhancedShareSheet: View {
    let post: CloudPost
    @Binding var isPresented: Bool
    @StateObject private var shareService = ShareService.shared
    @State private var showingError = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            List {
                Section("Share to") {
                    ShareDestinationRow(
                        title: "Instagram Story",
                        icon: "camera.circle.fill",
                        iconColor: .purple
                    ) {
                        shareToInstagram()
                    }
                    
                    ShareDestinationRow(
                        title: "Twitter",
                        icon: "bubble.left.fill",
                        iconColor: .blue
                    ) {
                        shareToTwitter()
                    }
                    
                    ShareDestinationRow(
                        title: "Messages",
                        icon: "message.fill",
                        iconColor: .green
                    ) {
                        shareToMessages()
                    }
                }
                
                Section("Other") {
                    ShareDestinationRow(
                        title: "Copy Link",
                        icon: "link",
                        iconColor: .gray
                    ) {
                        copyLink()
                    }
                    
                    ShareDestinationRow(
                        title: "Save Image",
                        icon: "square.and.arrow.down",
                        iconColor: .blue
                    ) {
                        saveImage()
                    }
                }
            }
            .navigationTitle("Share")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "An error occurred")
        }
    }
    
    // Implement sharing actions...
    
    private func shareToInstagram() {
        Task {
            do {
                try await shareService.share(post, to: .instagram)
                isPresented = false
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
    
    private func shareToTwitter() {
        Task {
            do {
                try await shareService.share(post, to: .twitter)
                isPresented = false
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
    
    private func shareToMessages() {
        Task {
            do {
                try await shareService.share(post, to: .messages)
                isPresented = false
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
    
    private func copyLink() {
        Task {
            do {
                try await shareService.share(post, to: .copyLink)
                HapticManager.notification(type: .success)
                isPresented = false
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
    
    private func saveImage() {
        Task {
            do {
                try await shareService.share(post, to: .saveImage)
                HapticManager.notification(type: .success)
                isPresented = false
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
}

struct ShareDestinationRow: View {
    let title: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(iconColor)
                Text(title)
            }
        }
    }
}
 