import Foundation

public enum Errors: LocalizedError {
    case artistNotFound
    case serverError
    
    public var errorDescription: String? {
        switch self {
        
        case .artistNotFound:
            return "Такого артиста не существует"
        case .serverError:
            return "Ошибка на сервере"
        }
    }
}
