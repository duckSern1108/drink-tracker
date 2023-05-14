//
//  DateCell.swift
//  Drink Tracker
//
//  Created by Sern Duck on 31/03/2023.
//

import UIKit
import SnapKit


class DateCell: UICollectionViewCell {
    var imgView: UIImageView = UIImageView(image: UIImage(named: "cup"))
    var customLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(imgView.snp.width)
        }
        
        addSubview(customLabel)
        customLabel.font = UIFont.systemFont(ofSize: 14)
        customLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imgView.snp.bottom).offset(8)
            make.bottom.greaterThanOrEqualToSuperview().inset(4)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindSelected(_ selected: Bool) {
        backgroundColor = selected ? UIColor(hex: "EBEBEB") : UIColor.clear
    }

    func bindData(_ dayOfWeek: DayOfWeek) {
        let drinkHistory = AppConfig.shared.drinkHistory
        var vals: [DrinkDayResult] = []
        drinkHistory.forEach { (key: Date, value: [DrinkDayResult]) in
            if key.compare(.isThisWeek) {
                vals.append(contentsOf: value)
            }
        }
        var valsFilter: [DrinkDayResult] = []
        for item in vals {
            let key = item.date.weekday
            let valu = item.amount
            if let exist = valsFilter.firstIndex(where: { $0.date.weekday == key}) {
                valsFilter[exist].amount += valu
            } else {
                let new = DrinkDayResult(amount: valu, date: item.date)
                valsFilter.append(new)
            }
        }
        valsFilter.sort { $0.date.weekday < $1.date.weekday }
        customLabel.text = "\(dayOfWeek.minimumText)"
        backgroundColor = UIColor(hex: "EBEBEB")
        imgView.image = valsFilter.contains(where: { v in
            v.date.weekday == dayOfWeek.rawValue
        }) ? UIImage(named: "blue_drop") : UIImage(named: "gray_drop")
        
    }
}

private extension DayOfWeek {
    var minimumText: String {
        switch self {
        case .monday:
            return "T2"
        case .tuesday:
            return "T3"
        case .wenseday:
            return "T4"
        case .thursday:
            return "T5"
        case .friday:
            return "T6"
        case .saturday:
            return "T7"
        case .sunday:
            return "CN"
        }
    }
}
