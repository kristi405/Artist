import Foundation

enum SearchVCString: String, CodingKey {
    case enterTheName = "Enter_the_name"
    case addToFavorites = "Add_to_favorites"
    case removeFromFavorites = "Remove_from_favorites"
    case name
    case showWebView
}

enum FaviritsVCString: String, CodingKey {
    case attributedTitle
    case showEvent
    case all
    case past
    case upcoming
    case cancel
    case chooseTheTime = "Choose_the_time"
    case showTheEvents = "show_the_events"
    case delete
    case chooseTheAction = "Choose_the_action"
}

enum EventsVCString: String, CodingKey {
    case showMap
    case showWeb
}

enum  WebVCString: String, CodingKey {
    case estimatedProgress
}

enum MapVCString: String, CodingKey {
    case error = "Error"
    case ok
    case unableToBuildARoute = "Unable_to_build_a_route"
    case annotationIdentifier
}

extension RawRepresentable where RawValue == String {
    var localizedString: String { rawValue }
}

extension String {
    var stringKey: String {
        let description = "\(self)"
        let components = description.components(separatedBy: "_")
        let key = String("\(components[0])" + " " + "\(components[1])" + " " + "\(components[2])")
        return key
    }
    
    func stringValue(locale: Locale = .current) -> String {
        .localizedString(for: stringKey, locale: locale)
    }
    
    var stringValue: String { stringValue() }
}

extension String {
    static func localizedString(
        for key: String, locale: Locale = .current) -> String {
        let localizedString = NSLocalizedString(key, comment: "")
        
        return localizedString
    }
}
