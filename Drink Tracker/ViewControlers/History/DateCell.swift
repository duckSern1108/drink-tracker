//
//  DateCell.swift
//  Drink Tracker
//
//  Created by Sern Duck on 31/03/2023.
//

import UIKit
import SnapKit


class DateCell: UICollectionViewCell {
    var imgView: UIImageView = UIImageView()
    var customLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(imgView.snp.width)
        }
        imgView.backgroundColor = .red
        addSubview(customLabel)
        customLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.greaterThanOrEqualTo(imgView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(4)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindData(_ dayOfWeek: DayOfWeek) {
        customLabel.text = "\(dayOfWeek.rawValue)"
    }
}
