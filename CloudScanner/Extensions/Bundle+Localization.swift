import Foundation

extension Bundle {
    func localizedDictionary(forPath path: String) -> [String: Any] {
        guard let url = self.url(forResource: path, withExtension: "stringsdict"),
              let dict = NSDictionary(contentsOf: url) as? [String: Any] else {
            return [:]
        }
        return dict
    }
} 