//
//  SettingReminderVC.swift
//  Drink Tracker
//
//  Created by Sern Duck on 31/03/2023.
//

import UIKit
import SnapKit


class SettingReminderVC: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    let sections = [
        "11:00",
        "12:00",
        "13:00"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingReminderCell.self)
    }
}

extension SettingReminderVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(SettingReminderCell.self, indexPath)
        cell.label.text = sections[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
}

class SettingReminderCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var label: UILabel = UILabel()
    var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(label)
        addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingDateCell.self)
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let day = DayOfWeek(rawValue: indexPath.row) else { return UICollectionViewCell() }
        let cell = collectionView.dequeue(SettingDateCell.self, indexPath)
        cell.bind(date: day)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DayOfWeek.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / CGFloat(DayOfWeek.allCases.count), height: collectionView.bounds.height)
    }
}

class SettingDateCell: UICollectionViewCell {
    var containerView: UIView = UIView()
    var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(containerView)
        containerView.addSubview(label)
        containerView.backgroundColor = .blue
        label.textColor = UIColor.white
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        layoutIfNeeded()
        containerView.layer.cornerRadius = containerView.bounds.width / 2
    }
    
    func bind(date: DayOfWeek) {
        label.text = date.minimumText
    }
}

private extension DayOfWeek {
    var minimumText: String {
        switch self {
        case .monday:
            return "M"
        case .tuesday:
            return "T"
        case .wenseday:
            return "W"
        case .thursday:
            return "T"
        case .friday:
            return "F"
        case .saturday:
            return "S"
        case .sunday:
            return "S"
        }
    }
}
