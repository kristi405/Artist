import Foundation

final class NetworkServices {
    
    // Getting data on the artist
    func fetchArtist(artist: String, complition: @escaping (CurrentArtist)->()) {
        let urlString = "https://rest.bandsintown.com/artists/\(artist)?app_id=ccd11757-c148-4587-a813-7e887084b536"
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            if let currentArtist = self.parseJSON(forData: data) {
                complition(currentArtist)
            }
        }
        task.resume()
    }
    
    func parseJSON(forData data: Data) -> CurrentArtist? {
        let decoder = JSONDecoder()
        do {
            let artist = try decoder.decode(Artist.self, from: data)
            guard let currentArtist = CurrentArtist(artist: artist) else {
                return nil
            }
            return currentArtist
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // We get data on events
    func fetchEvent(artist: String, date: String, complition: @escaping ([Event])->()) {
        let urlString = "https://rest.bandsintown.com/artists/\(artist)/events?app_id=ccd11757-c148-4587-a813-7e887084b536&date=\(date)"
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            if let currentEvent = self.parseJSONEvent(forData: data) {
                complition(currentEvent)
            }
        }
        task.resume()
    }
    
    func parseJSONEvent(forData data: Data) -> [Event]? {
        let decoder = JSONDecoder()
        
        do {
            let currentEvent = try decoder.decode([Event].self, from: data)
            return currentEvent
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}
