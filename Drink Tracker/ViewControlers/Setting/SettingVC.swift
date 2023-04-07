//
//  SettingVC.swift
//  Drink Tracker
//
//  Created by Sern Duck on 31/03/2023.
//

import UIKit

class SettingVC: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    enum Section: Int, CaseIterable {
        case remind
        case general
        case personal
        
        var commands: [SettingCommand] {
            switch self {
            case .remind:
                return [.calendarRemind, .soundRemind]
            case .general:
                return [.donVi, .targetDrink]
            case .personal:
                return [.gender, .weight, .timeWakeUp, .timeGoToSleep]
            }
        }
        
        var text: String {
            switch self {
            case .remind:
                return "Nhắc nhở"
            case .general:
                return "Chung"
            case .personal:
                return "Dữ liệu cá nhân"
            }
        }
    }
    
    enum SettingCommand: String, CaseIterable {
        case calendarRemind = "Lịch nhắc nhở"
        case soundRemind = "Âm thanh nhắc nhở"
        case donVi = "Đơn vị"
        case targetDrink = "Mục tiêu lượng nước uống"
        case gender = "Giới tính"
        case weight = "Cân nặng"
        case timeWakeUp = "Giờ thức dậy"
        case timeGoToSleep = " Giờ đi ngủ"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorStyle = .none
        tableview.rowHeight = 30
        tableview.estimatedRowHeight = 30
        tableview.sectionHeaderHeight = 40
        tableview.register(ReportCell.self)
        tableview.register(SectionHeaderSetting.self, forHeaderFooterViewReuseIdentifier: "header")
    }
}

extension SettingVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = Section(rawValue: section) else { return 0 }
        return sec.commands.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? SectionHeaderSetting,
              let section = Section(rawValue: section)
        else { return nil }
        headerView.label.text = section.text
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        let item = section.commands[indexPath.row]
        let cell = tableView.dequeue(ReportCell.self)
        cell.bind(title: item.rawValue, value: getDisplayTextForItem(item: item))
        return cell
    }
        
    
    func getDisplayTextForItem(item : SettingCommand) -> String {
        switch item {
        case .calendarRemind,
                .soundRemind:
            return ""
        case .donVi:
            return "\(Setting.shared.waterDonVi), \(Setting.shared.waterDonVi)"
        case .targetDrink:
            return "\(Setting.shared.drinkTarget)"
        case .gender:
            return "\(Setting.shared.userInfo.gender.rawValue)"
        case .weight:
            return "\(Setting.shared.userInfo.weight) \(Setting.shared.weightDonVi)"
        case .timeWakeUp:
            return "06:10"
        case .timeGoToSleep:
            return "22:00"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let command = SettingCommand.allCases[indexPath.row]
        switch command {
        case .calendarRemind:
            navigationController?.pushViewController(SettingReminderVC(), animated: true)
        case .soundRemind:
            break
        case .gender:
            break
        case .timeGoToSleep:
            break
        case .timeWakeUp:
            break
        case .donVi:
            break
        case .targetDrink:
            break
        case .weight:
            break
        }
    }
}

class SectionHeaderSetting: UITableViewHeaderFooterView {
    var label: UILabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
