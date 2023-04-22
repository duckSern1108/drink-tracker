import Foundation

typealias DrinkHistory = [Date: [DrinkDayResult]]

struct AppConfig: HasSaveToUserDefault {
    static var shared = AppConfig()
    
    var key: UserDefaultService.Key { .appConfig }
    
    var isOnboard: Bool = false
    
    var drinkHistory: DrinkHistory = [:]
    
    var todayDrink: [DrinkDayResult] = []
    
    var currentDrinkWater: Double {
        todayDrink.reduce(0, { $0 + $1.amount })
    }
}
