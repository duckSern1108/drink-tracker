//
//  HomeVC.swift
//  Drink Tracker
//
//  Created by Sern Duck on 31/03/2023.
//

import UIKit
import SwiftDate

class HomeVC: UIViewController {
    
    @IBOutlet weak var waterAmountLabel: UILabel!
    @IBOutlet weak var currentDrinkWaterHeight: NSLayoutConstraint!
    @IBOutlet private weak var currentDrinkWaterView: UIView!
    @IBOutlet private weak var amountWaterSuperView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    let MAX_HEIGHT = 200.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountWaterSuperView.layer.borderWidth = 1
        amountWaterSuperView.layer.borderColor = UIColor(hex: "5C5C5C").cgColor
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 40
        tableView.estimatedRowHeight = 40
        tableView.separatorStyle = .none
        tableView.register(HomeDrinkRecordCell.self)
        updateWater()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
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
        let newDrinkRes = DrinkDayResult(amount: Setting.shared.cupSize, date: Date())
        AppConfig.shared.todayDrink.append(newDrinkRes)
        updateWater()
        tableView.reloadData()
    }
    
    @IBAction func onChangeCup(_ sender: Any) {
        let vc = CupSizeVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AppConfig.shared.todayDrink.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(HomeDrinkRecordCell.self)
        let data = AppConfig.shared.todayDrink[indexPath.row]
        cell.bindData(data)
        return cell
    }
}

private class HomeDrinkRecordCell: UITableViewCell {
    let amountLabel: UILabel = UILabel()
    let timeLabel: UILabel = UILabel()
    let clockView: UIView = {
        let v = UIStackView()
        v.distribution = .fill
        v.spacing = 1
        v.alignment = .center
        v.axis = .vertical
        let lineV1 = UIView()
        lineV1.backgroundColor = .lightGray
        let clockImgView: UIImageView = UIImageView(image: UIImage(systemName:  "clock"))
        let lineV2 = UIView()
        lineV2.backgroundColor = .lightGray
        v.addArrangedSubview(lineV1)
        v.addArrangedSubview(clockImgView)
        v.addArrangedSubview(lineV2)
        clockImgView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
        lineV1.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(lineV2.snp.height)
        }
        lineV2.snp.makeConstraints { make in
            make.width.equalTo(1)
        }
        return v
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        selectionStyle = .none
        
        addSubview(clockView)
        addSubview(amountLabel)
        addSubview(timeLabel)
        
        clockView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(1)
        }
        
        timeLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(clockView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        amountLabel.setContentHuggingPriority(.init(252), for: .horizontal)
        amountLabel.textColor = UIColor(hex: "5C5C5C")
        amountLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(timeLabel.snp.trailing).offset(16)
        }
    }
    
    func bindData(_ data: DrinkDayResult) {
        amountLabel.text = "\(data.amount) ml"
        timeLabel.text = data.date.convertTo(region: VNRegion).toFormat("HH:mm")
    }
}
