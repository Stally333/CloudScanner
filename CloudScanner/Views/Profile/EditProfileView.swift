import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = EditProfileViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Username", text: $viewModel.username)
                    TextField("Bio", text: $viewModel.bio)
                    TextField("Location", text: $viewModel.location)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            await viewModel.updateProfile()
                            dismiss()
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "Please try again later")
            }
        }
    }
}

#Preview {
    EditProfileView()
        .environmentObject(AuthenticationManager.shared)
} 