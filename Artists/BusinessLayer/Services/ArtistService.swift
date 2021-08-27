import Foundation
import Moya

class ArtistService {
    typealias Request = ArtistAPI
    
    // MARK: Properties
    
    var request: Request?
    private let provider = MoyaProvider<ArtistAPI>()
    
    // MARK: Public Methods
    
    // Request to get Artist
    func getArtist(artist: GetArtistName, completion: @escaping (CurrentArtist) -> Void, completionError: @escaping (UIAlertController) -> ()) {
        request = Request.getArtist(artist: artist)
        guard let request = request else {return}
        
        NetworkManager.shered.request(target: request, model: CurrentArtist.self) { result in

            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        } completionError: { error in
            guard let errorDescription = error.errorDescription else {return}
            let alert = self.errorAlert(message: errorDescription)
            completionError(alert)
        }
    }
    
    // Request to get Events
    func getEvents(artist: GetArtistName, date: GetDate, completion: @escaping([Event]) -> Void) {
        request = Request.getEvent(artist: artist, date: date)
        guard let request = request else {return}
        
        NetworkManager.shered.request(target: request, model: [Event].self) { result in
            
            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        } completionError: { error in
            print(error.localizedDescription)
        }
    }
    
    // Alert with errors
    private func errorAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: Constants.alertTitle, message: "\(message)", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: Constants.okButtonTitle, style: .cancel)
        alert.addAction(okAction)
        
        return alert
    }
}

// MARK: Extention

extension ArtistService {
    enum Constants {
        static let alertTitle = "Ошибка"
        static let okButtonTitle = "Ok"
    }
}
