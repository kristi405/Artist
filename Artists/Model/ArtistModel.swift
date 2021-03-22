import UIKit

struct Artist: Decodable {
    
    var thumbURL: String?
    var mbid, supportURL: String?
    var facebookPageURL: String?
    var imageURL: String?
    var name: String?
    var options: Options?
    var id: String?
    var trackerCount, upcomingEventCount: Int?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbURL = "thumb_url"
        case mbid
        case supportURL = "support_url"
        case facebookPageURL = "facebook_page_url"
        case imageURL = "image_url"
        case name, options, id
        case trackerCount = "tracker_count"
        case upcomingEventCount = "upcoming_event_count"
        case url
    }
    
    // MARK: - Options
    struct Options: Codable {
        let displayListenUnit: Bool?
        
        enum CodingKeys: String, CodingKey {
            case displayListenUnit = "display_listen_unit"
        }
    }
    
    init(id: String?, supportURL: String?, name: String?, options: Options?, url: String?, image_url: String?, thumb_url: String?, facebook_page_url: String?, mbid: String?, tracker_count: Int?, upcoming_event_count: Int?) {
        self.id = id
        self.name = name
        self.url = url
        self.imageURL = image_url
        self.thumbURL = thumb_url
        self.facebookPageURL = facebook_page_url
        self.mbid = mbid
        self.trackerCount = tracker_count
        self.upcomingEventCount = upcoming_event_count
        self.options = options
        self.supportURL = supportURL
    }
}
