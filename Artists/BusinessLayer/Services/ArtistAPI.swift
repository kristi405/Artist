import Foundation
import Moya

enum ArtistAPI {
    // MARK: Requests
    
    case getArtist(artist: GetArtistName)
    case getEvent(artist: GetArtistName, date: GetDate)
}

extension ArtistAPI: TargetType {
    var baseURL: URL {
        return URL(string: GlobalConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getArtist(let artist):
            return "/artists/\(artist.name)"
        case .getEvent(let artist, _):
            return "/artists/\(artist.name)/events"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getArtist, .getEvent:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getArtist, .getEvent:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .getArtist:
            return .requestParameters(parameters: self.dictionaryArtist, encoding: self.encoding)
        case .getEvent(_, let getDate):
            return .requestParameters(parameters: self.dictionaryEvent(date: getDate.date), encoding: self.encoding)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

// MARK: Extentions

extension ArtistAPI {
    var dictionaryArtist: Dictionary<String, Any> {
        get {
            let app_id = Constants.appID
            let apiKey = GlobalConstants.apiKey
            return [app_id : apiKey]
        }
    }
    
    func dictionaryEvent(date: String) -> [String : String] {
            let app_id = Constants.appID
            let apiKey = GlobalConstants.apiKey
            let dateKey = Constants.date
            let date = date
            return [app_id: apiKey, dateKey : date]
    }

    var encoding: URLEncoding {
        return URLEncoding.queryString
    }
}

extension ArtistAPI {
    enum Constants {
        static let appID = "app_id"
        static let date = "date"
    }
}
