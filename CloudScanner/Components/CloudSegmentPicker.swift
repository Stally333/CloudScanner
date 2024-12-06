import SwiftUI

struct CloudSegmentPicker<T: Hashable>: View {
    let items: [T]
    let titleForItem: (T) -> String
    @Binding var selection: T
    
    var body: some View {
        HStack {
            Spacer()
            segmentButtons
            Spacer()
        }
    }
    
    private var segmentButtons: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                segmentButton(for: item)
            }
        }
    }
    
    private func segmentButton(for item: T) -> some View {
        Button {
            selection = item
        } label: {
            Text(titleForItem(item))
                .font(CloudFonts.body)
                .foregroundStyle(selection == item ? .primary : .secondary)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background {
                    if selection == item {
                        Capsule()
                            .fill(.ultraThinMaterial)
                    }
                }
        }
    }
} 