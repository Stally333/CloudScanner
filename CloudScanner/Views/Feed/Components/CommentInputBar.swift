import SwiftUI

struct CommentInputBar: View {
    @Binding var text: String
    @Binding var isInputFocused: Bool
    let onSend: () -> Void
    
    @FocusState private var internalFocus: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            TextField("Add a comment...", text: $text)
                .textFieldStyle(.roundedBorder)
                .focused($internalFocus)
                .onChange(of: isInputFocused) { newValue in
                    internalFocus = newValue
                }
                .onChange(of: internalFocus) { newValue in
                    isInputFocused = newValue
                }
            
            Button {
                onSend()
                text = ""
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(text.isEmpty ? .secondary : CloudColors.skyBlue)
            }
            .disabled(text.isEmpty)
        }
        .padding()
        .background(.ultraThinMaterial)
    }
} 