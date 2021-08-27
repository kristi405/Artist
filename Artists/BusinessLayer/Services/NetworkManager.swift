import Foundation
import Moya

final class NetworkManager {
    // MARK: Properties
    
    static let shered = NetworkManager()
    
    private let decoder: JSONDecoder
    private lazy var networkProvider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>(stubClosure: MoyaProvider.neverStub)
    
    // MARK: Initialization

    private init() {
        let decoder = JSONDecoder()
        self.decoder = decoder
    }
    
    // MARK: Public Method
    
    func request<T: TargetType, U: Decodable>(target: T, model: U.Type, completion: @escaping (Result<U, Error>) -> Void, completionError: @escaping (LocalizedError) -> ()) {
        let provider = networkProvider
        
        provider.request(MultiTarget(target)) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let response):
                do {
                    let response = try? response.map(model, using: self.decoder)
                    guard let artist = response else { completionError(Errors.artistNotFound)
                        return
                    }
                    completion(.success(artist))
                }
            case .failure(let error):
                completionError(Errors.serverError)
                print(error.localizedDescription)
            }
        }
    }
}
