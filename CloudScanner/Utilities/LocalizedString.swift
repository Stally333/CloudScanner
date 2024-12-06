import SwiftUI

struct LocalizedString {
    private let key: String
    
    init(_ key: String) {
        self.key = key
    }
    
    var localized: String {
        NSLocalizedString(key, comment: "")
    }
}

extension Text {
    init(_ localizedString: LocalizedString) {
        self.init(localizedString.localized)
    }
}

extension LocalizedString {
    static let weatherTitle = LocalizedString("Weather")
    static let goldenHour = LocalizedString("Golden Hour")
    static let blueHour = LocalizedString("Blue Hour")
} 