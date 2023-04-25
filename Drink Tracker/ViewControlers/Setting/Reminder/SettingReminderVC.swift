//
//  SettingReminderVC.swift
//  Drink Tracker
//
//  Created by Sern Duck on 31/03/2023.
//

import UIKit
import UserNotifications
import SnapKit
import SwiftDate
import RxSwift
import RxGesture


class SettingReminderVC: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var sections: [Int] = []
    private var seletedHour: Set<Int> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genSection()
        
        title = "Hẹn lịch nhắc uống nước"
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingReminderCell.self)
    }
    
    private func genSection() {
        let timeWakeUp = UserInfo.shared.timeWakeUp.convertTo(region: VNRegion).hour
        let timeGoToSleep = UserInfo.shared.timeGoToSleep.convertTo(region: VNRegion).hour
        sections = Array(stride(from: timeWakeUp, to: timeGoToSleep, by: 1))
        seletedHour = Setting.shared.remindHour
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    @IBAction func onConfirm(_ sender: Any) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            guard let self = self else { return }
            
            defer {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            if let error = error {
                return
                // Handle the error here.
            }
            if !granted {
                return
            }
            
            Setting.shared.remindHour = self.seletedHour
            Setting.shared.saveToUserDefault()
            
            self.createLocalNotification()
        }
    }
    
    private func createLocalNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        seletedHour.forEach { hour in
            createSingleNoti(hour: hour)
        }
    }
    
    private func createSingleNoti(hour: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Uống nước nào"
        content.body = "Một cốc nước \(Int(Setting.shared.drinkTarget)) ml"
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = hour
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: dateComponents, repeats: true)
        
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        UNUserNotificationCenter.current().add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }
}

extension SettingReminderVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SettingReminderCell.self, indexPath)
        let data = sections[indexPath.row]
        cell.bind(time: data, isActive: seletedHour.contains(data))
        cell.onChangeSetting = { [weak self] time, isActive in
            if isActive {
                self?.seletedHour.insert(time)
            } else {
                self?.seletedHour.remove(time)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}

class SettingReminderCell: UICollectionViewCell {
    var label: UILabel = UILabel()
    var switchBtn: UISwitch = UISwitch()
    
    private let disposeBag = DisposeBag()
    private var time: Int = 0
    
    var onChangeSetting: ((_ hour: Int, _ isActive: Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(time: Int, isActive: Bool) {
        self.time = time
        label.text = "\(time):00"
        switchBtn.isOn = isActive
    }
    
    func setup() {
        addSubview(label)
        addSubview(switchBtn)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        switchBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.leading.greaterThanOrEqualTo(label.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        switchBtn.rx.isOn
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.onChangeSetting?(self.time, $0)
            })
            .disposed(by: disposeBag)
    }
}
