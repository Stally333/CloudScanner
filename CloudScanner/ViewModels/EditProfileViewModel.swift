import SwiftUI

@MainActor
class EditProfileViewModel: ObservableObject {
    @Published var username = ""
    @Published var bio = ""
    @Published var location = ""
    @Published var isLoading = false
    @Published var error: Error?
    @Published var avatarUrl: String?
    @Published var newProfileImage: UIImage?
    @Published var showingError = false
    @Published var errorMessage: String?
    @Published var uploadProgress: Double?
    
    private let authManager: AuthenticationManager
    private let imageUploadService = ImageUploadService.shared
    private let errorRecovery = ErrorRecoveryService.shared
    
    init(authManager: AuthenticationManager? = nil) {
        self.authManager = authManager ?? AuthenticationManager.shared
        if let user = authManager?.currentUser {
            username = user.username
            bio = user.bio ?? ""
            location = user.location ?? ""
            avatarUrl = user.userAvatarUrl
        }
    }
    
    private func validateUsername(_ username: String) -> Bool {
        guard username.count >= 3 && username.count <= 30 else {
            self.errorMessage = "Username must be between 3 and 30 characters"
            self.showingError = true
            return false
        }
        
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._")
        guard username.unicodeScalars.allSatisfy({ allowedCharacterSet.contains($0) }) else {
            self.errorMessage = "Username can only contain letters, numbers, underscores, and dots"
            self.showingError = true
            return false
        }
        
        guard !username.hasPrefix(".") && !username.hasPrefix("_") &&
              !username.hasSuffix(".") && !username.hasSuffix("_") else {
            self.errorMessage = "Username cannot start or end with dots or underscores"
            self.showingError = true
            return false
        }
        
        return true
    }
    
    private func validateBio(_ bio: String) -> Bool {
        let trimmedBio = bio.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard trimmedBio.count <= 150 else {
            self.errorMessage = "Bio must be 150 characters or less"
            self.showingError = true
            return false
        }
        
        let blockedWords = ["spam", "abuse", "hate"]
        let containsBlockedWord = blockedWords.contains { word in
            trimmedBio.lowercased().contains(word)
        }
        
        guard !containsBlockedWord else {
            self.errorMessage = "Bio contains inappropriate content"
            self.showingError = true
            return false
        }
        
        return true
    }
    
    func updateProfile() async {
        let trimmedUsername = self.username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBio = self.bio.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedUsername.isEmpty else {
            self.errorMessage = "Username cannot be empty"
            self.showingError = true
            return
        }
        
        guard validateUsername(trimmedUsername) else {
            return
        }
        
        guard validateBio(trimmedBio) else {
            return
        }
        
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            try await errorRecovery.executeWithRetry(operation: "profile_update") {
                if let newImage = self.newProfileImage {
                    self.uploadProgress = 0.0
                    self.avatarUrl = try await self.imageUploadService.uploadProfileImage(newImage)
                    self.uploadProgress = nil
                }
                
                try await self.authManager.updateProfile(
                    username: trimmedUsername,
                    bio: trimmedBio,
                    location: self.location.trimmingCharacters(in: .whitespacesAndNewlines),
                    avatarUrl: self.avatarUrl
                )
            }
        } catch {
            self.errorMessage = error.localizedDescription
            self.showingError = true
        }
    }
} 