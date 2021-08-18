import Foundation
import Moya

enum MoyaService {
    case getArtist(artist: String)
    case getEvent(artist: String, date: String)
}

extension MoyaService: TargetType {
    var baseURL: URL {
        return URL(string: GlobalConstants.baseURL)!
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
            return .requestParameters(parameters: [Constants.appiID: GlobalConstants.apiKey], encoding: URLEncoding.queryString)
        case .getEvent(_, let date):
            return .requestParameters(parameters: [Constants.appiID: GlobalConstants.apiKey, Constants.date: "\(date)"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

extension MoyaService {
    enum Constants {
        static let appiID = "app_id"
        static let date = "date"
    }
}
