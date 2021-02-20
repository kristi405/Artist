import Foundation

struct CurrentArtist {
    
    let name: String?
    let imageURL: String?

    init?(artist: Artist) {
        name = artist.name
        imageURL = artist.imageURL
    }
}
