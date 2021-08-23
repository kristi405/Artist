import Foundation
import Moya

public final class NetworkManager {
    // MARK: Properties
    
    public static let shered = NetworkManager()
    
    private let decoder: JSONDecoder
    private lazy var networkProvider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>(stubClosure: MoyaProvider.neverStub)
    
    // MARK: Initialization

    init() {
        let decoder = JSONDecoder()
        self.decoder = decoder
    }
    
    // MARK: Public Method
    
    public func request<T: TargetType, U: Decodable>(target: T, model: U.Type, completion: @escaping (Result<U, Error>) -> Void, callBack: @escaping (UIAlertController) ->()) {
        let provider = networkProvider
        
        provider.request(MultiTarget(target)) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let response):
                do {
                    let response = try? response.map(model, using: self.decoder)
                    guard let artist = response else {
                        let alert = self.errorAlert()
                        callBack(alert)
                        return}
                    completion(.success(artist))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func errorAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Ошибка", message: "Такого Артиста не существует", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(okAction)
        
        return alert
    }
}
