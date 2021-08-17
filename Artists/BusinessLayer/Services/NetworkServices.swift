import Foundation
import Moya

enum MoyaService {
    case getArtist(artist: String)
    case getEvent(artist: String, date: String)
}

extension MoyaService: TargetType {
    var baseURL: URL {
        return URL(string: "https://rest.bandsintown.com")!
    }
    
    var path: String {
        switch self {
        case .getArtist(let artist):
            return "/artists/\(artist)"
        case .getEvent(let artist, _):
            return "/artists/\(artist)/events"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getArtist:
            return .get
        case .getEvent:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getArtist:
            return Data()
        case .getEvent:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .getArtist:
            return .requestParameters(parameters: ["app_id": "ccd11757-c148-4587-a813-7e887084b536"], encoding: URLEncoding.queryString)
        case .getEvent(_, let date):
            return .requestParameters(parameters: ["app_id": "ccd11757-c148-4587-a813-7e887084b536", "date": "\(date)"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
