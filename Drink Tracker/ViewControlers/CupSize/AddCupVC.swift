//
//  EditWeightVC.swift
//  Drink Tracker
//
//  Created by Sern Duck on 24/04/2023.
//

import UIKit

class AddCupVC: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var label: UILabel!
    var onConfirm: ((Double) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
