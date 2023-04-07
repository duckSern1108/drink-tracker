import UIKit

class UpdateUserInfoVCViewController: UIViewController {

    @IBOutlet private weak var waterLabel: UILabel!
    @IBOutlet private weak var heightTextField: UITextField!
    @IBOutlet private weak var weightTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
        
    @IBAction func onUpdateBtnPress(_ sender: Any) {
        guard let heightStr = heightTextField.text,
              let height = Int(heightStr),
              let weightStr = weightTextField.text,
              let weight = Int(weightStr)
        else { return }
        AppDataManager.shared.data.userData.weight = weight
        AppDataManager.shared.data.userData.height = height
        AppDataManager.shared.data.setting.drinkTarget = 100.0
    }
    @IBAction func onHeightChange(_ sender: Any) {
        updateWaterNeedAmount()
    }
    @IBAction func onWeightChange(_ sender: Any) {
        updateWaterNeedAmount()
    }
    
    private func updateWaterNeedAmount() {
        guard let heightStr = heightTextField.text,
              let height = Int(heightStr),
              let weightStr = weightTextField.text,
              let weight = Int(weightStr)
        else { return }
        var amountWaterNeed = 0
        waterLabel.text = "\(amountWaterNeed) ml"
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
}
