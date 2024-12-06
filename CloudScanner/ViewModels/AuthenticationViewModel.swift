import Foundation

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var showingError = false
    @Published var errorMessage: String?
    
    var authManager: AuthenticationManager!
    
    func signIn() async {
        guard validateInput() else { return }
        
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            try await self.authManager.signIn(email: self.email, password: self.password)
        } catch {
            self.errorMessage = error.localizedDescription
            self.showingError = true
        }
    }
    
    private func validateInput() -> Bool {
        if self.email.isEmpty {
            self.errorMessage = "Email is required"
            self.showingError = true
            return false
        }
        
        if self.password.isEmpty {
            self.errorMessage = "Password is required"
            self.showingError = true
            return false
        }
        
        return true
    }
} 