import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var viewModel: AuthenticationViewModel
    @State private var showingSignUp = false
    @Environment(\.colorScheme) var colorScheme
    
    init() {
        // Initialize viewModel without creating a new AuthenticationManager
        _viewModel = StateObject(wrappedValue: AuthenticationViewModel())
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Logo and welcome text
                VStack(spacing: 20) {
                    Image(systemName: "cloud.sun.fill")
                        .font(.system(size: 80))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.white, CloudColors.gradientStart)
                    
                    Text("CLOUD SCANNER")
                        .font(CloudFonts.title)
                        .foregroundColor(.white)
                    
                    Text("Scan the Skies, Capture Your Dreams!")
                        .font(CloudFonts.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 50)
                
                // Sign in form
                VStack(spacing: 20) {
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(CloudTextFieldStyle())
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(CloudTextFieldStyle())
                        .textContentType(.password)
                    
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Button("Sign In") {
                            Task {
                                await viewModel.signIn()
                            }
                        }
                        .buttonStyle(CloudButtonStyle())
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Social sign in
                HStack(spacing: 16) {
                    SocialSignInButton(
                        icon: "apple.logo",
                        title: "Apple",
                        iconImage: Image("apple_logo")
                    ) {
                        /* handle sign in */
                    }
                    
                    SocialSignInButton(
                        icon: "google.logo",
                        title: "Google",
                        iconImage: Image("google_logo")
                    ) {
                        /* handle sign in */
                    }
                }
                .padding(.horizontal)
                
                // Sign up button with black text
                Button {
                    showingSignUp = true
                } label: {
                    Text("Don't have an account? Sign Up")
                        .font(CloudFonts.body)
                        .foregroundColor(.black)
                        .padding(.vertical, 8)
                }
                
                Spacer()
            }
            .padding()
            .background(CloudColors.skyGradient.ignoresSafeArea())
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An error occurred")
            }
            .sheet(isPresented: $showingSignUp) {
                SignUpView()
            }
        }
        .onAppear {
            // Connect the viewModel to the shared authManager
            viewModel.authManager = authManager
        }
    }
}
