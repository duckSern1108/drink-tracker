import UIKit
import SwiftDate

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
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
        headerView.label.text = section.text.uppercased()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        let item = section.commands[indexPath.row]
        let cell = tableView.dequeue(ReportCell.self)
        cell.bind(title: item.rawValue, value: getDisplayTextForItem(item: item), isHiddenSeperator: true)
        return cell
    }
    
    
    func getDisplayTextForItem(item : SettingCommand) -> String {
        switch item {
        case .calendarRemind,
                .soundRemind:
            return ""
        case .donVi:
            return "\(Setting.shared.weightDonVi), \(Setting.shared.waterDonVi)"
        case .targetDrink:
            return "\(Setting.shared.drinkTarget)"
        case .gender:
            return "\(UserInfo.shared.gender.rawValue)"
        case .weight:
            return "\(UserInfo.shared.weight) \(Setting.shared.weightDonVi)"
        case .timeWakeUp:
            return UserInfo.shared.timeWakeUp.convertTo(region: VNRegion).toFormat("HH:mm")
        case .timeGoToSleep:
            return UserInfo.shared.timeGoToSleep.convertTo(region: VNRegion).toFormat("HH:mm")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        let command = section.commands[indexPath.row]
        switch command {
        case .calendarRemind:
            navigationController?.pushViewController(SettingReminderVC(), animated: true)
        case .soundRemind:
            break
            
        case .donVi:
            let vc = BottomSheetVC.newVC(contentVC: PickDonViVC(), contentHeight: 400)
            vc.modalPresentationStyle = .overFullScreen
            MainTabBarVC.shared.present(vc, animated: true)
        case .targetDrink:
            break
            
        case .gender:
            break
        case .weight:
            let editWeightVC = EditWeightVC()
            editWeightVC.onConfirm = { [weak self] weight in
                UserInfo.shared.weight = weight
                UserInfo.shared.saveToUserDefault()
                
                Setting.shared.drinkTarget = weight * 30
                Setting.shared.saveToUserDefault()
                self?.tableview.reloadData()
            }
            let vc = BottomSheetVC.newVC(contentVC: editWeightVC, contentHeight: 130)
            vc.modalPresentationStyle = .overFullScreen
            MainTabBarVC.shared.present(vc, animated: true)
        case .timeWakeUp:
            let vnTime = UserInfo.shared.timeWakeUp.convertTo(region: VNRegion)
            let pickTimeVC = PickTimeVC.newVC(selectedHour: vnTime.hour, selectedMinute: vnTime.minute)
            pickTimeVC.onConfirmChange = { [weak self] hour, minute in
                guard let date = DateInRegion(components: {
                    $0.hour = hour
                    $0.minute = minute
                }, region: VNRegion)?.date
                else { return }
                UserInfo.shared.timeWakeUp = date
                UserInfo.shared.saveToUserDefault()
                self?.tableview.reloadData()
            }
            let vc = BottomSheetVC.newVC(contentVC: pickTimeVC, contentHeight: 300)
            vc.modalPresentationStyle = .overFullScreen
            MainTabBarVC.shared.present(vc, animated: true)
            break
        case .timeGoToSleep:
            let vnTime = UserInfo.shared.timeGoToSleep.convertTo(region: VNRegion)
            let pickTimeVC = PickTimeVC.newVC(selectedHour: vnTime.hour, selectedMinute: vnTime.minute)
            pickTimeVC.onConfirmChange = { [weak self] hour, minute in
                guard let date = DateInRegion(components: {
                    $0.hour = hour
                    $0.minute = minute
                }, region: VNRegion)?.date
                else { return }
                UserInfo.shared.timeGoToSleep = date
                UserInfo.shared.saveToUserDefault()
                self?.tableview.reloadData()
            }
            let vc = BottomSheetVC.newVC(contentVC: pickTimeVC, contentHeight: 300)
            vc.modalPresentationStyle = .overFullScreen
            MainTabBarVC.shared.present(vc, animated: true)
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
