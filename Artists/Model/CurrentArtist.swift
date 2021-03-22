import Foundation

struct CurrentArtist {
    
    let name: String?
    let imageURL: String?
    let url: String?
    
    init?(artist: Artist) {
        name = artist.name
        imageURL = artist.imageURL
        url = artist.url
    }
}
