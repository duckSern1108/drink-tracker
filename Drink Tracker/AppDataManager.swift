//
//  UserDefaultManager.swift
//  SSTCloud
//
//  Created by Sern Duck on 20/03/2023.
//

import Foundation


class AppDataManager {
    static let shared = AppDataManager()
    
    private init() {}
    
    struct InternalData: Codable {
        var hasOnboard: Bool = true
        var userData: UserInfo = .init()
        var setting: Setting = .init()
    }
    
    var data = InternalData() {
        didSet {
            saveToUserDefault()
        }
    }
    
    private let USER_DEFAULT_KEY = "drinnk_tracker_app_data"
    
    private func saveToUserDefault() {
        do {
            let data = try JSONEncoder().encode(self.data)
            UserDefaults.standard.set(data, forKey: USER_DEFAULT_KEY)
        } catch {
        }
    }
    
    func getDataFromUserDefault() {
        let data = UserDefaults.standard.data(forKey: USER_DEFAULT_KEY)
        guard let data = data else { return }

        if let decodeData = try? JSONDecoder().decode(InternalData.self, from: data) {
            self.data = decodeData
        }
    }
    
    func clearData() {
        data = InternalData()
    }
}


