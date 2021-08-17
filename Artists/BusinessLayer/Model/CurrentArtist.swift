import UIKit

struct CurrentArtist: Decodable {
    
    var name: String?
    var imageURL: String?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "image_url"
        case url
    }
    
    struct Options: Codable {
        let displayListenUnit: Bool?
        
        enum CodingKeys: String, CodingKey {
            case displayListenUnit = "display_listen_unit"
        }
    }
    
    init(name: String?, imageURL: String?, url: String?) {
        self.name = name
        self.imageURL = imageURL
        self.url = url
    }
}
