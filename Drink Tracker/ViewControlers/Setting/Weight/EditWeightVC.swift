//
//  EditWeightVC.swift
//  Drink Tracker
//
//  Created by Sern Duck on 24/04/2023.
//

import UIKit

class EditWeightVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    var onConfirm: ((Double) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = "\(UserInfo.shared.weight)"
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
