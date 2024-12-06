import SwiftUI
import UIKit

struct CollectionSheet: View {
    let post: CloudPost
    @Binding var isPresented: Bool
    @StateObject private var bookmarkService = BookmarkService.shared
    @State private var showingNewCollection = false
    @State private var newCollectionName = ""
    @State private var isPrivate = false
    @State private var errorMessage: String?
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button {
                        showingNewCollection = true
                    } label: {
                        Label("Create New Collection", systemImage: "plus.circle.fill")
                    }
                }
                
                Section("Your Collections") {
                    ForEach(bookmarkService.collections) { collection in
                        CollectionRow(
                            collection: collection,
                            post: post,
                            isPresented: $isPresented
                        )
                    }
                }
            }
            .navigationTitle("Save to Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewCollection) {
            NewCollectionView(
                name: $newCollectionName,
                isPrivate: $isPrivate,
                isPresented: $showingNewCollection,
                onCreate: createCollection
            )
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "An error occurred")
        }
    }
    
    private func createCollection() {
        Task {
            do {
                try await bookmarkService.createCollection(name: newCollectionName, isPrivate: isPrivate)
                newCollectionName = ""
                isPrivate = false
                showingNewCollection = false
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
}

struct CollectionRow: View {
    let collection: BookmarkService.Collection
    let post: CloudPost
    @Binding var isPresented: Bool
    @StateObject private var bookmarkService = BookmarkService.shared
    
    var body: some View {
        Button {
            saveToCollection()
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(collection.name)
                        .font(CloudFonts.body)
                    Text("\(collection.posts.count) posts")
                        .font(CloudFonts.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if collection.posts.contains(post.id) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
            }
        }
    }
    
    private func saveToCollection() {
        Task {
            do {
                try await bookmarkService.addPost(post.id, to: collection.id)
                HapticManager.notification(type: .success)
                isPresented = false
            } catch {
                print("Error saving to collection: \(error)")
                HapticManager.notification(type: .error)
            }
        }
    }
} 