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
    @IBOutlet private weak var currentWaterAspectRatio: NSLayoutConstraint!
    @IBOutlet private weak var currentDrinkWaterView: UIView!
    @IBOutlet private weak var amountWaterSuperView: UIView!
    
    var maxAmoutWater = 2500.0
    var currentWater = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountWaterSuperView.layer.borderWidth = 1
        amountWaterSuperView.layer.borderColor = UIColor(hex: "5C5C5C").cgColor
        updateWater(amount: 0)
    }
    
    func updateWater(amount: CGFloat) {
        currentWater += amount
        UIView.animate(withDuration: 0.5, delay: 0.0,options: .curveEaseInOut) {
            self.currentDrinkWaterHeight.constant = 200 * (self.currentWater / self.maxAmoutWater)
            self.waterAmountLabel.text = "\(Int(self.currentWater)) ml"
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func onDrinkWater(_ sender: Any) {
        updateWater(amount: 200.0)
    }
}
