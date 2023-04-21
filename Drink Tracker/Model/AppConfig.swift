import Foundation


struct AppConfig: HasSaveToUserDefault {
    static var shared = AppConfig()
    
    var key: UserDefaultService.Key { .appConfig }
    
    var isOnboard: Bool = false
    
    var drinkHistory: [DrinkDayResult] = []
    
    var todayDrink: [DrinkDayResult] = []
    
    var currentDrinkWater: Double {
        todayDrink.reduce(0, { $0 + $1.amount })
    }
}
