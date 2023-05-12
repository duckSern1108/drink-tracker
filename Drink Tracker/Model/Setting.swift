import Foundation


struct Setting: HasSaveToUserDefault {
    static var shared = Setting()
    
    var key: UserDefaultService.Key { .setting }
    //ml
    var drinkTarget: Double = 2500
    var wakeUpTime: Date = Date()
    var goToSleepTime: Date = Date()
    var waterDonVi: WaterDonVi = .ml
    var weightDonVi: WeightDonVi = .kg
    var remindHour: Set<Int> = .init()
    
    var cupSize: Double = 100
}


enum WaterDonVi: Int, Codable {
    case ml = 1000
    case l = 1
}

enum WeightDonVi: Int, Codable {
    case g = 1000
    case kg = 1
}
