import Foundation
import SwiftUI

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var showingError = false
    @Published var errorMessage: String?
    
    // Validation states
    @Published var usernameError: String?
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?
    
    var passwordStrength: PasswordStrength {
        let length = password.count
        let hasUppercase = password.contains(where: { $0.isUppercase })
        let hasNumber = password.contains(where: { $0.isNumber })
        let hasSpecial = password.contains(where: { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) })
        
        if length >= 12 && hasUppercase && hasNumber && hasSpecial {
            return .strong
        } else if length >= 8 && (hasUppercase || hasNumber) {
            return .medium
        } else {
            return .weak
        }
    }
    
    enum PasswordStrength {
        case weak, medium, strong
        
        var color: Color {
            switch self {
            case .weak: return .red
            case .medium: return .yellow
            case .strong: return .green
            }
        }
        
        var description: String {
            switch self {
            case .weak: return "Weak"
            case .medium: return "Medium"
            case .strong: return "Strong"
            }
        }
    }
    
    func validate() -> Bool {
        var isValid = true
        
        // Username validation
        if username.isEmpty {
            self.usernameError = "Username is required"
            isValid = false
        } else if username.count < 3 {
            self.usernameError = "Username must be at least 3 characters"
            isValid = false
        } else {
            self.usernameError = nil
        }
        
        // Email validation
        if email.isEmpty {
            self.emailError = "Email is required"
            isValid = false
        } else if !email.contains("@") || !email.contains(".") {
            self.emailError = "Please enter a valid email"
            isValid = false
        } else {
            self.emailError = nil
        }
        
        // Password validation
        if password.isEmpty {
            self.passwordError = "Password is required"
            isValid = false
        } else if password.count < 8 {
            self.passwordError = "Password must be at least 8 characters"
            isValid = false
        } else {
            self.passwordError = nil
        }
        
        // Confirm password validation
        if confirmPassword != password {
            self.confirmPasswordError = "Passwords don't match"
            isValid = false
        } else {
            self.confirmPasswordError = nil
        }
        
        return isValid
    }
    
    func signUp() async {
        guard validate() else { return }
        
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            // Simulate network delay
            try await Task.sleep(until: .now + .seconds(1), clock: .continuous)
            
            // TODO: Implement actual sign up
        } catch {
            self.errorMessage = error.localizedDescription
            self.showingError = true
        }
    }
} 