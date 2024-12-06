import SwiftUI

extension Text {
    static func raw(_ string: String) -> Text {
        Text(verbatim: "_\(string)")
    }
} 