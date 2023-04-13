import Foundation


class UserDefaultService {
    static let shared = UserDefaultService()
    
    private init() {}
    
    enum Key: String {
        case setting
        case userInfo
        case appConfig
    }
    
    let jsonEncoder = JSONEncoder()
    let jsonDecoder = JSONDecoder()
    
    func setData<T: Codable>(_ data: T, key: Key) throws {
        let data = try jsonEncoder.encode(data)
        UserDefaults.standard.set(data, forKey: key.rawValue)
    }
    func getData<T: Codable>(key: Key) -> T? {
        let data = UserDefaults.standard.data(forKey: key.rawValue)
        guard let data = data else { return nil }
        
        return try? jsonDecoder.decode(T.self, from: data)
    }
}

protocol HasSaveToUserDefault: Codable {
    var key: UserDefaultService.Key { get }
    
    func saveToUserDefault()
}

extension HasSaveToUserDefault {
    func saveToUserDefault() {
        do {
            try UserDefaultService.shared.setData(self, key: key)
        } catch let err {
            print(err.localizedDescription)
        }
        
    }
}

