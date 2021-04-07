import UIKit

class GlobalConstants {
    // MARK: Global Constants
    
    static let baseURL = "https://rest.bandsintown.com"
    static let apiKey = "ccd11757-c148-4587-a813-7e887084b536"
    
    static func returnArtistURL(artist: String) -> String {
        return baseURL + "/artists/\(artist)?app_id=\(apiKey)"
    }
    
    static func returnEventURL(artist: String, date: String) -> String {
        return baseURL +  "/artists/\(artist)/events?app_id=\(apiKey)&date=\(date)"
    }
}
