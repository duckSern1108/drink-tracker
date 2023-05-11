import UIKit
import RxGesture
import RxSwift

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
    
    @IBOutlet weak var bottleImage: UIImageView!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        resultView.isHidden = true
        progresView.progress = 0
        calculateView.isHidden = true
        heightTextField.delegate = self
        weightTextField.delegate = self
        self.selectSex()
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
            let editWeightVC = PickTimeVC()
//            editWeightVC.onConfirm = { [weak self] weight in
//                guard let self = self else { return }
//                self.heightTextField.text = String(weight)
//                UserInfo.shared.height = weight
//                UserInfo.shared.saveToUserDefault()
//
//                Setting.shared.drinkTarget = weight * 30
//                Setting.shared.saveToUserDefault()
//            }
            let vc = BottomSheetVC.newVC(contentVC: editWeightVC, contentHeight: 400)
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
            }
            let vc = BottomSheetVC.newVC(contentVC: editWeightVC, contentHeight: 130)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        .disposed(by: disposeBag)
    
    }
    
    func selectSex(isMale: Bool = true) {
        self.labelMale.textColor = isMale ? .black : .lightGray
        self.imageMale.backgroundColor = isMale ? .appColor : .lightGray
        self.labelFemale.textColor = isMale ? .lightGray : .black
        self.imageFemale.backgroundColor = isMale ? .lightGray : UIColor.appColor
        self.viewMale.alpha = isMale ? 1 : 0.6
        self.viewFemale.alpha = isMale ? 0.6 : 1
    }
    
    @IBAction func onUpdateBtnPress(_ sender: Any) {
//        guard let heightStr = heightTextField.text,
//              let height = Double(heightStr),
//              let weightStr = weightTextField.text,
//              let weight = Double(weightStr)
//        else { return }
//        UserInfo.shared.weight = weight
//        UserInfo.shared.height = height
//        UserInfo.shared.saveToUserDefault()
//
//        Setting.shared.drinkTarget = weight * 30
//        Setting.shared.saveToUserDefault()
//
//        AppConfig.shared.isOnboard = true
//        AppConfig.shared.saveToUserDefault()
//
//        AppCoordinator.shared.goToMainVC()
        updateWaterNeedAmount()
    }
    
    @IBAction func onHeightChange(_ sender: Any) {
        updateWaterNeedAmount()
    }
    
    @IBAction func onWeightChange(_ sender: Any) {
        updateWaterNeedAmount()
    }
    
    private func updateWaterNeedAmount() {
//        guard let weightStr = weightTextField.text,
//              let weight = Int(weightStr)
//        else { return }
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
        
    
//        let amountWaterNeed = weight * 30
//        waterLabel.text = "\(amountWaterNeed) ml"
        
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
