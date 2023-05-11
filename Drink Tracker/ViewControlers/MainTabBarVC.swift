//
//  MainTabBarVC.swift
//  SSTCloud
//
//  Created by Sern Duck on 20/03/2023.
//

import UIKit


class MainTabBarVC: UITabBarController {
    static let shared = MainTabBarVC()
    var notiData: UNNotification? = nil
    
    private let homeVC: UIViewController = {
        let homeVC = HomeVC()
        let homeNavigation = UINavigationController(rootViewController: homeVC)
        homeNavigation.tabBarItem = UITabBarItem(title: "Trang chủ", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        return homeNavigation
    }()
        
    
    private let historyVC: UIViewController = {
        let vc = HistoryVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: "Lịch sử", image: UIImage(systemName: "arrow.clockwise.circle"), selectedImage: UIImage(systemName: "arrow.clockwise.circle.fill"))
        return nav
    }()
    
    private let settingVC: UIViewController = {
        let vc = SettingVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: "Cài đặt", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([homeVC, historyVC, settingVC], animated: false)
        tabBar.backgroundColor = .white
        tabBar.tintColor = .appColorBold
    }
}

extension MainTabBarVC: UNUserNotificationCenterDelegate {
    
}

class AppCoordinator {
    static let shared = AppCoordinator()
    var window: UIWindow!
    var notiData: UNNotification?
    private init() {}
    
    func bind(window: UIWindow, notiData: UNNotification?) {
        self.window = window
        self.notiData = notiData
        if !AppConfig.shared.isOnboard {
            goToOnboard()
        } else {
            goToMainVC()
        }
    }
    
    func goToOnboard() {
        window.rootViewController = UpdateUserInfoVCViewController()
    }
    
    func goToMainVC() {
        MainTabBarVC.shared.notiData = notiData
        window.rootViewController = MainTabBarVC.shared        
    }
}
