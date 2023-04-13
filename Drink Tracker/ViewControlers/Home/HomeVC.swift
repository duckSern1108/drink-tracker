//
//  HomeVC.swift
//  Drink Tracker
//
//  Created by Sern Duck on 31/03/2023.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var waterAmountLabel: UILabel!
    @IBOutlet weak var currentDrinkWaterHeight: NSLayoutConstraint!
    @IBOutlet private weak var currentDrinkWaterView: UIView!
    @IBOutlet private weak var amountWaterSuperView: UIView!
    
    let MAX_HEIGHT = 200.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        amountWaterSuperView.layer.borderWidth = 1
        amountWaterSuperView.layer.borderColor = UIColor(hex: "5C5C5C").cgColor
        updateWater()
    }
    
    func updateWater() {
        UIView.animate(withDuration: 0.5, delay: 0.0,options: .curveEaseInOut) {
            self.currentDrinkWaterHeight.constant = self.MAX_HEIGHT * min(1,(AppConfig.shared.currentDrinkWater / Setting.shared.drinkTarget))
            self.waterAmountLabel.text = "\(Int(AppConfig.shared.currentDrinkWater)) ml"
            self.amountWaterSuperView.layoutIfNeeded()
        }
        
        AppConfig.shared.saveToUserDefault()
    }
    
    @IBAction func onDrinkWater(_ sender: Any) {
        AppConfig.shared.currentDrinkWater += Setting.shared.cupSize
        updateWater()
    }
    
    @IBAction func onChangeCup(_ sender: Any) {
        present(CupSizeVC(), animated: true)
    }
}
