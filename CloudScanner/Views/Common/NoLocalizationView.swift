import SwiftUI

struct NoLocalizationView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .environment(\.locale, .init(identifier: "en"))
    }
} 