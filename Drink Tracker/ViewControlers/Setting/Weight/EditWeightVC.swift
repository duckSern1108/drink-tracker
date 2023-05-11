//
//  EditWeightVC.swift
//  Drink Tracker
//
//  Created by Sern Duck on 24/04/2023.
//

import UIKit

class EditWeightVC: UIViewController {

    var isHeight: Bool = false
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var label: UILabel!
    var onConfirm: ((Double) -> Void)?
    
    static func newVc(isHeight: Bool = true) -> EditWeightVC {
        let vc = EditWeightVC()
        vc.isHeight = isHeight
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = "\(isHeight ? UserInfo.shared.height : UserInfo.shared.weight)"
        label.text = isHeight ? "Chiều cao (cm):" : "Cân nặng (kg):"
        textField.keyboardType = .numberPad
    }
    
    @IBAction func onConfirm(_ sender: Any) {
        guard let text = textField.text,
              let val = Double(text)
        else {
            self.dismiss(animated: true)
            return
        }
        self.dismiss(animated: true)
        onConfirm?(val)
    }
}
