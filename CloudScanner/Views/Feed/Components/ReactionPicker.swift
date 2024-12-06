import SwiftUI
import UIKit

struct ReactionPicker: View {
    let postId: String
    @StateObject private var reactionService = ReactionService.shared
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(ReactionService.Reaction.allCases, id: \.self) { reaction in
                Button {
                    addReaction(reaction)
                } label: {
                    Text(reaction.rawValue)
                        .font(.title2)
                }
                .scaleEffect(1.0)
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .cornerRadius(24)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private func addReaction(_ reaction: ReactionService.Reaction) {
        Task {
            try? await reactionService.addReaction(reaction, to: postId)
            withAnimation {
                isPresented = false
            }
            HapticManager.impact(style: .light)
        }
    }
} 