import SwiftUI

struct MentionSuggestionView: View {
    let query: String
    @Binding var selectedUsername: String?
    
    // Mock data for now
    let suggestions = [
        "cloudchaser",
        "skygazer",
        "stormwatch",
        "nimbus",
        "cumulus"
    ]
    
    var filteredSuggestions: [String] {
        suggestions.filter { $0.contains(query.lowercased()) }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                ForEach(filteredSuggestions, id: \.self) { username in
                    Button {
                        selectedUsername = username
                    } label: {
                        HStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 32, height: 32)
                                .overlay {
                                    Text(String(username.prefix(1)).uppercased())
                                        .font(CloudFonts.caption)
                                        .foregroundStyle(.white)
                                }
                            
                            Text("@\(username)")
                                .font(CloudFonts.body)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .frame(maxHeight: 200)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
} 