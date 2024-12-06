import Foundation

enum LocalizedStrings {
    static let clearSkies = NSLocalizedString("CLEAR_SKIES", comment: "Clear skies weather condition")
    static let partlyCloudy = NSLocalizedString("PARTLY_CLOUDY", comment: "Partly cloudy weather condition")
    static let overcast = NSLocalizedString("OVERCAST", comment: "Overcast weather condition")
    static let cloudy = NSLocalizedString("CLOUDY", comment: "Cloudy weather condition")
    
    enum CloudTypes {
        static let cumulus = NSLocalizedString("CUMULUS", comment: "Cumulus cloud type")
        static let stratus = NSLocalizedString("STRATUS", comment: "Stratus cloud type")
        static let cirrus = NSLocalizedString("CIRRUS", comment: "Cirrus cloud type")
        static let cumulonimbus = NSLocalizedString("CUMULONIMBUS", comment: "Cumulonimbus cloud type")
    }
    
    enum Metrics {
        static let temperature = NSLocalizedString("TEMPERATURE", comment: "Temperature metric")
        static let humidity = NSLocalizedString("HUMIDITY", comment: "Humidity metric")
        static let windSpeed = NSLocalizedString("WIND_SPEED", comment: "Wind speed metric")
        static let visibility = NSLocalizedString("VISIBILITY", comment: "Visibility metric")
    }
}

// MARK: - Generative Options
enum GenerativeOptionsStrings {
    static let navigationTitle = NSLocalizedString("Cloud Art", comment: "Navigation title for generative options view")
    static let originalLabel = NSLocalizedString("Original", comment: "Label for original image")
    static let generatedVersionsTitle = NSLocalizedString("AI Generated Versions", comment: "Title for AI generated versions section")
    static let generatingMessage = NSLocalizedString("Generating cloud art...", comment: "Message shown while generating AI art")
    static let generateButtonTitle = NSLocalizedString("Generate Cloud Art", comment: "Button title to generate cloud art")
    static let shareButtonTitle = NSLocalizedString("Share Images", comment: "Button title to share generated images")
    static let cancelButtonTitle = NSLocalizedString("Cancel", comment: "Cancel button title")
} 