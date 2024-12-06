import SwiftUI

struct NewCollectionView: View {
    @Binding var name: String
    @Binding var isPrivate: Bool
    @Binding var isPresented: Bool
    let onCreate: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Collection Name", text: $name)
                    Toggle("Private Collection", isOn: $isPrivate)
                } footer: {
                    Text("Private collections are only visible to you")
                }
            }
            .navigationTitle("New Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        onCreate()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
} 