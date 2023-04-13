import UIKit

class UpdateUserInfoVCViewController: UIViewController {

    @IBOutlet private weak var waterLabel: UILabel!
    @IBOutlet private weak var heightTextField: UITextField!
    @IBOutlet private weak var weightTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
        
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
