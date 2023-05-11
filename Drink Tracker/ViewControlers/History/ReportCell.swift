//
//  ReportCell.swift
//  Drink Tracker
//
//  Created by Sern Duck on 31/03/2023.
//

import UIKit

class ReportCell: UITableViewCell {
    
    @IBOutlet weak var leadingTitle: NSLayoutConstraint!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seperator: UIView!
    @IBOutlet weak var pointView: UIView!
    
    let listColor: [UIColor] = [.green, .blue, .orange, .red]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func bind(title: String, value: String, isHiddenSeperator: Bool = false, seperatorColor: UIColor = .init(hex: "5C5C5C"), isShowPoint: Bool = false, index: Int = 0) {
        if isShowPoint {
            pointView.backgroundColor = listColor[index]
            pointView.isHidden = false
            leadingTitle.constant = 20
        } else {
            leadingTitle.constant = 10
            pointView.isHidden = true
        }
        valueLabel.textColor = .appColorBold
        titleLabel.text = title
        valueLabel.text = value
        seperator.isHidden = isHiddenSeperator
        seperator.backgroundColor = seperatorColor
    }
}
