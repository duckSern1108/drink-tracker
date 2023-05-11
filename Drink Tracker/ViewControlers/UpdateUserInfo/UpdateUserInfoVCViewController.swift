import UIKit
import SwiftDate
import RxSwift
import RxGesture

class UpdateUserInfoVCViewController: UIViewController {
    
    @IBOutlet private weak var waterLabel: UILabel!
    @IBOutlet private weak var heightTextField: UITextField!
    @IBOutlet private weak var weightTextField: UITextField!
    @IBOutlet weak var progresView: UIProgressView!
    @IBOutlet weak var loadingText: UILabel!
    @IBOutlet weak var calculateView: UIView!
    @IBOutlet weak var resultView: UIStackView!
    @IBOutlet weak var viewFemale: UIView!
    @IBOutlet weak var viewMale: UIView!
    @IBOutlet weak var imageFemale: UIView!
    @IBOutlet weak var imageMale: UIView!
    @IBOutlet weak var labelFemale: UILabel!
    @IBOutlet weak var labelMale: UILabel!
    @IBOutlet weak var resultlb2: UILabel!
    @IBOutlet weak var resultlb1: UILabel!
    @IBOutlet weak var sleepTimeLabel: UITextField!
    @IBOutlet weak var wakeUpTimeLabel: UITextField!
    @IBOutlet weak var bottleImage: UIImageView!
    
    @IBOutlet weak var updateButton: UIButton!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        selectSex()
        bindRx()
        setupView()
    }
    
    func setupView() {
        resultView.isHidden = true
        progresView.progress = 0
        calculateView.isHidden = true
        heightTextField.delegate = self
        weightTextField.delegate = self
        wakeUpTimeLabel.delegate = self
        sleepTimeLabel.delegate = self
        wakeUpTimeLabel.text = "07:00"
        sleepTimeLabel.text = "22:00"
        updateButton.backgroundColor = isActiveButton() ? .appColor : .lightGray
        updateButton.isUserInteractionEnabled = isActiveButton()
        if let dateWake = DateInRegion(components: {
            $0.hour = 7
            $0.minute = 0
        }, region: VNRegion)?.date,
           let dateSleep = DateInRegion(components: {
               $0.hour = 22
               $0.minute = 0
           }, region: VNRegion)?.date {
            UserInfo.shared.timeWakeUp = dateWake
            UserInfo.shared.timeWakeUp = dateSleep
        }
    }
    
    func bindRx(){
        viewMale.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            self.selectSex(isMale: true)
        }
        .disposed(by: disposeBag)
        
        viewFemale.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            self.selectSex(isMale: false)
        }
        .disposed(by: disposeBag)
        heightTextField.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            let editWeightVC = EditWeightVC.newVc(isHeight: true)
            editWeightVC.onConfirm = { [weak self] weight in
                guard let self = self else { return }
                self.heightTextField.text = String(weight)
                UserInfo.shared.height = weight
                UserInfo.shared.saveToUserDefault()
                Setting.shared.saveToUserDefault()
                updateButton.backgroundColor = isActiveButton() ? .appColor : .lightGray
                updateButton.isUserInteractionEnabled = isActiveButton()
            }
            let vc = BottomSheetVC.newVC(contentVC: editWeightVC, contentHeight: 130)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        .disposed(by: disposeBag)
        
        weightTextField.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            let editWeightVC = EditWeightVC()
            editWeightVC.onConfirm = { [weak self] weight in
                guard let self = self else { return }
                self.weightTextField.text = String(weight)
                UserInfo.shared.weight = weight
                UserInfo.shared.saveToUserDefault()
                
                Setting.shared.drinkTarget = weight * 30
                Setting.shared.saveToUserDefault()
                updateButton.backgroundColor = isActiveButton() ? .appColor : .lightGray
                updateButton.isUserInteractionEnabled = isActiveButton()
            }
            let vc = BottomSheetVC.newVC(contentVC: editWeightVC, contentHeight: 130)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        .disposed(by: disposeBag)
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
    
    @IBAction func skipAction(_ sender: UIButton) {
        if weightTextField.text!.isEmpty {
            UserInfo.shared.weight = 60
        }
        if heightTextField.text!.isEmpty {
            UserInfo.shared.height = 160
        }
        UserInfo.shared.saveToUserDefault()
        Setting.shared.drinkTarget = UserInfo.shared.weight * 30
        Setting.shared.saveToUserDefault()
     
        AppConfig.shared.isOnboard = true
        AppConfig.shared.saveToUserDefault()
        AppCoordinator.shared.goToMainVC()
    }
    @IBAction func onUpdateBtnPress(_ sender: Any) {
        guard let heightStr = heightTextField.text,
              let height = Double(heightStr),
              let weightStr = weightTextField.text,
              let weight = Double(weightStr)
        else { return }
        updateWaterNeedAmount()
        UserInfo.shared.weight = weight
        UserInfo.shared.height = height
        UserInfo.shared.saveToUserDefault()
        
    }
    
    func selectSex(isMale: Bool = true) {
        self.labelMale.textColor = isMale ? .black : .lightGray
        self.imageMale.backgroundColor = isMale ? .appColor : .lightGray
        self.labelFemale.textColor = isMale ? .lightGray : .black
        self.imageFemale.backgroundColor = isMale ? .lightGray : UIColor.appColor
        self.viewMale.alpha = isMale ? 1 : 0.6
        self.viewFemale.alpha = isMale ? 0.6 : 1
    }
    
    func isActiveButton() -> Bool {
        return !heightTextField.text!.isEmpty && !weightTextField.text!.isEmpty
    }
    
    private func updateWaterNeedAmount() {
        guard let weightStr = weightTextField.text,
              let weightDouble = Double(weightStr)
        else { return }
        let weight = Int(weightDouble)
        bottleImage.isHidden = true
        progresView.progressTintColor = .systemBlue
        loadingText.textColor = .darkGray
        resultlb1.textColor = .white
        resultlb2.textColor = .white
        UIView.animate(withDuration: 0.5) {
            self.calculateView.isHidden = false
            self.resultView.isHidden = true
        }
        UIView.animate(withDuration: 1) {
            self.progresView.setProgress(Float(0.2), animated: true)
        }
        UIView.animate(withDuration: 1.5) {
            self.progresView.setProgress(Float(0.6), animated: true)
        }
        UIView.animate(withDuration: 2.5) {
            self.progresView.setProgress(Float(1), animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            self.progresView.progressTintColor = .white
            self.loadingText.textColor = .white
            self.resultlb1.textColor = .black
            self.resultlb2.textColor = .black
            self.bottleImage.isHidden = false
            UIView.animate(withDuration: 1) {
                self.calculateView.isHidden = true
                self.resultView.isHidden = false
            }
        })
        let amountWaterNeed = weight * 30
        waterLabel.text = "\(amountWaterNeed) ml"
    }
}
extension UpdateUserInfoVCViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

extension UIColor {
    static var appColor = UIColor.init(hex: "#A8D4F3")
}
