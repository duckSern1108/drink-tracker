//
//  Setting.swift
//  Drink Tracker
//
//  Created by Sern Duck on 31/03/2023.
//

import Foundation


struct Setting: Codable {
    static let shared = Setting()
    //ml
    var drinkTarget: Int = 2500
    var wakeUpTime: Date = Date()
    var goToSleepTime: Date = Date()
    var waterDonVi: WaterDonVi = .ml
    var weightDonVi: WeightDonVi = .kg
    
    var userInfo: UserInfo = .init()
}

enum Gender: String, Codable {
    case male = "Nam"
    case female = "Nữ"
    case other = "Khác"
}

enum WaterDonVi: Int, Codable {
    case ml = 1000
    case l = 1
}

enum WeightDonVi: Int {
    case g = 1000
    case kg = 1
}

struct UserInfo: Codable {
    //kg
    var weight: Double = 0.0
    var gender: Gender = .male
    //cm
    var height: Double = 150
}
