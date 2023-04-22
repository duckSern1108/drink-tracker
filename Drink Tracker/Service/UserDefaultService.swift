import Foundation
import SwiftDate


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
    
    func getAppData() {
        UserInfo.shared = UserDefaultService.shared.getData(key: .userInfo) ?? UserInfo()
        Setting.shared = UserDefaultService.shared.getData(key: .setting) ?? Setting()
        AppConfig.shared = UserDefaultService.shared.getData(key: .appConfig) ?? AppConfig()
        if let lastTimeTodayDrinkResult = AppConfig.shared.todayDrink.last?.date,
           !lastTimeTodayDrinkResult.compare(.isToday)
        {
            AppConfig.shared.drinkHistory[lastTimeTodayDrinkResult] = AppConfig.shared.todayDrink
            AppConfig.shared.todayDrink = []
            AppConfig.shared.saveToUserDefault()
        }
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


let VNRegion = Region(calendar: Calendars.gregorian, zone: Zones.asiaVientiane, locale: Locales.vietnameseVietnam)

