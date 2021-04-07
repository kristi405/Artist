import Foundation

final class NetworkServices {
    
    // MARK: Getting data on the artist
    func fetchArtist(artist: String, complition: @escaping (CurrentArtist)->()) {
        let urlString = GlobalConstants.returnArtistURL(artist: artist)
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            if let currentArtist = ParsingService.parseJSON(forData: data) {
                complition(currentArtist)
            }
        }
        task.resume()
    }
    
    // MARK: We get data on events
    func fetchEvent(artist: String, date: String, complition: @escaping ([Event])->()) {
        let urlString = GlobalConstants.returnEventURL(artist: artist, date: date)
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            if let currentEvent = ParsingService.parseJSONEvent(forData: data) {
                complition(currentEvent)
            }
        }
        task.resume()
    }
}
