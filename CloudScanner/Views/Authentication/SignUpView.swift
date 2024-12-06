import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 15) {
                    // Username field
                    VStack(alignment: .leading) {
                        TextField("Username", text: $viewModel.username)
                            .textFieldStyle(CloudTextFieldStyle())
                            .textContentType(.username)
                            .autocapitalization(.none)
                        
                        if let error = viewModel.usernameError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Email field
                    VStack(alignment: .leading) {
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(CloudTextFieldStyle())
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                        
                        if let error = viewModel.emailError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Password field with strength indicator
                    VStack(alignment: .leading) {
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(CloudTextFieldStyle())
                            .textContentType(.newPassword)
                        
                        PasswordStrengthView(strength: viewModel.passwordStrength)
                        
                        if let error = viewModel.passwordError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Confirm password field
                    VStack(alignment: .leading) {
                        SecureField("Confirm Password", text: $viewModel.confirmPassword)
                            .textFieldStyle(CloudTextFieldStyle())
                            .textContentType(.newPassword)
                        
                        if let error = viewModel.confirmPasswordError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Sign up button
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Button("Create Account") {
                            Task {
                                await viewModel.signUp()
                            }
                        }
                        .buttonStyle(CloudButtonStyle())
                    }
                }
                .padding()
            }
            .background(CloudColors.skyGradient.ignoresSafeArea())
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An error occurred")
            }
        }
    }
}

struct PasswordStrengthView: View {
    let strength: SignUpViewModel.PasswordStrength
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Password Strength: \(strength.description)")
                .font(CloudFonts.caption)
                .foregroundColor(.secondary)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                    
                    Rectangle()
                        .fill(strength.color)
                        .frame(width: geometry.size.width * strengthMultiplier)
                }
            }
            .frame(height: 4)
            .cornerRadius(2)
        }
    }
    
    private var strengthMultiplier: Double {
        switch strength {
        case .weak: return 0.33
        case .medium: return 0.66
        case .strong: return 1.0
        }
    }
}
