import Foundation


struct UserInfo: HasSaveToUserDefault {
    static var shared = UserInfo()
    
    var key: UserDefaultService.Key { .userInfo }
    
    //kg
    var weight: Double = 0.0
    var gender: Gender = .male
    //cm
    var height: Double = 150
    
    var timeWakeUp: Date = Date()
    var timeGoToSleep: Date = Date()
}

enum Gender: String, Codable {
    case male = "Nam"
    case female = "Nữ"
    case other = "Khác"
}
