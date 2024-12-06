import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var selectedTab = ProfileTab.posts
    @State private var showingEditProfile = false
    @State private var showingSubscription = false
    
    enum ProfileTab: String, CaseIterable {
        case posts = "Posts"
        case liked = "Liked"
        case stats = "Stats"
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Profile Header
                    ProfileHeader(user: authManager.currentUser)
                        .padding(.horizontal)
                    
                    // Stats Overview
                    StatsOverview()
                        .padding(.horizontal)
                    
                    // Content Tabs
                    CloudSegmentPicker(
                        items: ProfileTab.allCases,
                        titleForItem: { $0.rawValue },
                        selection: $selectedTab
                    )
                    .padding(.horizontal)
                    
                    // Tab Content
                    switch selectedTab {
                    case .posts:
                        UserPostsGrid()
                    case .liked:
                        LikedPostsGrid()
                    case .stats:
                        UserStatsView()
                    }
                    
                    // Centered upgrade button
                    if authManager.currentUser?.subscriptionTier == .free {
                        Button {
                            showingSubscription = true
                        } label: {
                            Text("Upgrade to Premium")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(CloudColors.gradientStart)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .background(CloudColors.skyGradient.ignoresSafeArea())
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showingEditProfile = true
                        } label: {
                            Label("Edit Profile", systemImage: "person.crop.circle")
                        }
                        
                        Button(role: .destructive) {
                            authManager.signOut()
                        } label: {
                            Label("Sign Out", systemImage: "arrow.right.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .foregroundStyle(.white)
                    }
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
            }
            .sheet(isPresented: $showingSubscription) {
                SubscriptionView()
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationManager.shared)
}