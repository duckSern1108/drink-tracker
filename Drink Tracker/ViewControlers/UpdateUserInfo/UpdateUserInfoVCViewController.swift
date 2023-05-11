import UIKit
import SwiftDate
import RxSwift
import RxGesture

class UpdateUserInfoVCViewController: UIViewController {
    
    @IBOutlet private weak var waterLabel: UILabel!
    @IBOutlet private weak var heightTextField: UITextField!
    @IBOutlet private weak var wakeUpTimeLabel: UILabel!
    @IBOutlet private weak var sleepTimeLabel: UILabel!
    @IBOutlet private weak var weightTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        wakeUpTimeLabel.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let vnTime = UserInfo.shared.timeWakeUp.convertTo(region: VNRegion)
                let pickTimeVC = PickTimeVC.newVC(selectedHour: vnTime.hour, selectedMinute: vnTime.minute, title: "Chọn thời gian thức dậy")
                pickTimeVC.onConfirmChange = { [weak self] hour, minute in
                    guard let date = DateInRegion(components: {
                        $0.hour = hour
                        $0.minute = minute
                    }, region: VNRegion)?.date,
                          let self = self
                    else { return }
                    UserInfo.shared.timeWakeUp = date
                    UserInfo.shared.saveToUserDefault()
                    self.wakeUpTimeLabel.textColor = UIColor.black
                    self.wakeUpTimeLabel.text = UserInfo.shared.timeWakeUp.convertTo(region: VNRegion).toFormat("HH:mm")
                }
                let vc = BottomSheetVC.newVC(contentVC: pickTimeVC, contentHeight: 320)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
                
        sleepTimeLabel.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let vnTime = UserInfo.shared.timeGoToSleep.convertTo(region: VNRegion)
                let pickTimeVC = PickTimeVC.newVC(selectedHour: vnTime.hour, selectedMinute: vnTime.minute, title: "Chọn thời gian đi ngủ")
                pickTimeVC.onConfirmChange = { [weak self] hour, minute in
                    guard let date = DateInRegion(components: {
                        $0.hour = hour
                        $0.minute = minute
                    }, region: VNRegion)?.date,
                          let self = self
                    else { return }
                    UserInfo.shared.timeGoToSleep = date
                    UserInfo.shared.saveToUserDefault()
                    self.sleepTimeLabel.textColor = UIColor.black
                    self.sleepTimeLabel.text = UserInfo.shared.timeGoToSleep.convertTo(region: VNRegion).toFormat("HH:mm")
                }
                let vc = BottomSheetVC.newVC(contentVC: pickTimeVC, contentHeight: 320)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func onUpdateBtnPress(_ sender: Any) {
        guard let heightStr = heightTextField.text,
              let height = Double(heightStr),
              let weightStr = weightTextField.text,
              let weight = Double(weightStr)
        else { return }
        UserInfo.shared.weight = weight
        UserInfo.shared.height = height
        UserInfo.shared.saveToUserDefault()
        
        Setting.shared.drinkTarget = weight * 30
        Setting.shared.saveToUserDefault()
        
        AppConfig.shared.isOnboard = true
        AppConfig.shared.saveToUserDefault()
        
        AppCoordinator.shared.goToMainVC()
    }
    
    @IBAction func onHeightChange(_ sender: Any) {
        updateWaterNeedAmount()
    }
    
    @IBAction func onWeightChange(_ sender: Any) {
        updateWaterNeedAmount()
    }
    
    private func updateWaterNeedAmount() {
        guard let weightStr = weightTextField.text,
              let weight = Int(weightStr)
        else { return }
        let amountWaterNeed = weight * 30
        waterLabel.text = "\(amountWaterNeed) ml"
        
    }
}
