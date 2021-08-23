import Foundation

public enum Errors: LocalizedError {
    case artistNotFound
    
    public var errorDescription: String? {
        switch self {
        
        case .artistNotFound:
            return "Такого артиста не существует"
        }
    }
}
