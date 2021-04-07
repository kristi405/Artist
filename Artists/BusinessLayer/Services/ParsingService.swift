import UIKit

final class ParsingService {
    
    // MARK: Parsing of artist`s data
    static func parseJSON(forData data: Data) -> CurrentArtist? {
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
    
    // MARK: Parsing of event`s data
    static func parseJSONEvent(forData data: Data) -> [Event]? {
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
