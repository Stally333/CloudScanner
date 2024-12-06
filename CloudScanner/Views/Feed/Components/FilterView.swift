import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var filter: CloudDataService.PostFilter
    
    private let filters: [CloudDataService.PostFilter] = [.all, .following, .trending, .nearby]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filters, id: \.self) { filterOption in
                    Button {
                        filter = filterOption
                        dismiss()
                    } label: {
                        HStack {
                            Text(filterOption.title)
                                .foregroundStyle(.white)
                            Spacer()
                            if filter == filterOption {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filter Posts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

extension CloudDataService.PostFilter: Hashable {
    var title: String {
        switch self {
        case .all: return "All Posts"
        case .following: return "Following"
        case .trending: return "Trending"
        case .nearby: return "Nearby"
        }
    }
} 