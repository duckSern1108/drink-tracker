//
//  ReportCell.swift
//  Drink Tracker
//
//  Created by Sern Duck on 31/03/2023.
//

import UIKit

class ReportCell: UITableViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seperator: UIView!
    
    func bind(title: String, value: String, isHiddenSeperator: Bool = false, seperatorColor: UIColor = .init(hex: "5C5C5C")) {
        titleLabel.text = title
        valueLabel.text = value
        seperator.isHidden = isHiddenSeperator
        seperator.backgroundColor = seperatorColor
    }
}
