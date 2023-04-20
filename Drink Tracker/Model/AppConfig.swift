import Foundation


struct AppConfig: HasSaveToUserDefault {
    static var shared = AppConfig()
    
    var key: UserDefaultService.Key { .appConfig }
    
    var isOnboard: Bool = false
    var currentDrinkWater: Double = 0
    
    var drinkHistory: [DrinkDayResult] = []
    
    var todayDrink: [DrinkDayResult] = []
}
