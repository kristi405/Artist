import UIKit

struct Event: Decodable {
    
    var id: String?
    var url: String
    var datetime, title, welcomeDescription: String?
    var artist: Artist?
    var venue: Venue?
    var lineup: [String]?
    var offers: [Offer]?
    var artistID, onSaleDatetime: String?
    
    enum CodingKeys: String, CodingKey {
        case id, url, datetime, title
        case welcomeDescription = "description"
        case artist, venue, lineup, offers
        case artistID = "artist_id"
        case onSaleDatetime = "on_sale_datetime"
    }
    
    // MARK: - Options
    struct Options: Decodable {
        let displayListenUnit: Bool
        
        enum CodingKeys: String, CodingKey {
            case displayListenUnit = "display_listen_unit"
        }
    }
    
    // MARK: - Offer
    struct Offer: Decodable {
        let type: String?
        let url: String?
        let status: String?
    }
    
    // MARK: - Venue
    struct Venue: Decodable {
        let country, city, name: String?
        let latitude, longitude, region: String?
    }
    
    init(id: String?, url: String, title: String?, datetime: String?, welcomeDescription: String?, artist: Artist?, venue: Venue?, offers: [Offer]?, lineup: [String]?, artistID: String?, onSaleDatetime: String?) {
        self.id = id
        self.artistID = artistID
        self.title = title
        self.url = url
        self.artist = artist
        self.onSaleDatetime = onSaleDatetime
        self.datetime = datetime
        self.welcomeDescription = welcomeDescription
        self.venue = venue
        self.offers = offers
        self.lineup = lineup
    }
}
