import Foundation
import Moya

class ArtistService {
    typealias Request = ArtistAPI
    
    // MARK: Properties
    
    public var request: Request?
    private let provider = MoyaProvider<ArtistAPI>()
    
    // MARK: Public Methods
    
    // Request to get Artist
    public func getArtist(artist: GetArtistName, completion: @escaping(CurrentArtist) -> Void) {
        request = Request.getArtist(artist: artist)
        guard let request = request else {return}
        
        NetworkManager.shered.request(target: request, model: CurrentArtist.self) { result in
            
            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Request to get Events
    public func getEvents(artist: GetArtistName, date: GetDate, completion: @escaping([Event]) -> Void) {
        request = Request.getEvent(artist: artist, date: date)
        guard let request = request else {return}
        
        NetworkManager.shered.request(target: request, model: [Event].self) { result in
            
            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
