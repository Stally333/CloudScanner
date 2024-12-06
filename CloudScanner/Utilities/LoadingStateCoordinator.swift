import SwiftUI
import Combine

@MainActor
class LoadingStateCoordinator: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var loadingTasks: Set<UUID> = []
    
    func trackTask(_ id: UUID) {
        loadingTasks.insert(id)
        updateLoadingState()
    }
    
    func completeTask(_ id: UUID) {
        loadingTasks.remove(id)
        updateLoadingState()
    }
    
    private func updateLoadingState() {
        withAnimation {
            isLoading = !loadingTasks.isEmpty
        }
    }
}

struct LoadingTask: ViewModifier {
    @StateObject private var coordinator: LoadingStateCoordinator
    private let id = UUID()
    
    init(coordinator: LoadingStateCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                coordinator.trackTask(id)
            }
            .onDisappear {
                coordinator.completeTask(id)
            }
    }
}

extension View {
    func trackLoading(using coordinator: LoadingStateCoordinator) -> some View {
        modifier(LoadingTask(coordinator: coordinator))
    }
} 