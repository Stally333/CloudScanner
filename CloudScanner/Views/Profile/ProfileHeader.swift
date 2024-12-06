import SwiftUI
import PhotosUI

struct ProfileHeader: View {
    let user: AuthenticationManager.User?
    @State private var showingImagePicker = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 16) {
            // Profile Photo with edit button
            Button {
                showingImagePicker = true
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    if let avatarUrl = user?.userAvatarUrl,
                       let url = URL(string: avatarUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            defaultAvatar
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    } else {
                        defaultAvatar
                            .frame(width: 100, height: 100)
                    }
                    
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, CloudColors.gradientStart)
                        .font(.title2)
                        .background(Circle().fill(.white))
                }
            }
            
            // User Info
            VStack(spacing: 4) {
                Text(user?.username ?? "Username")
                    .font(.title2.bold())
                
                if let bio = user?.bio {
                    Text(bio)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                if let location = user?.location {
                    Label(location, systemImage: "location.fill")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Choose Photo")
            }
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        selectedImage = uiImage
                    }
                }
            }
        }
    }
    
    private var defaultAvatar: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .foregroundStyle(CloudColors.deepBlue)
    }
}

#Preview {
    ProfileHeader(user: nil)
} 