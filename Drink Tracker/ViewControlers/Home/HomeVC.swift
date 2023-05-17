//
//  HomeVC.swift
//  Drink Tracker
//
//  Created by Sern Duck on 31/03/2023.
//

import UIKit
import SwiftDate
import RxSwift
import RxGesture

class HomeVC: UIViewController {
    
    @IBOutlet weak var currentGlassImage: UIImageView!
    @IBOutlet weak var currentGlassLb: UILabel!
    @IBOutlet weak var currentRecord: UILabel!
    @IBOutlet weak var waterAmountLabel: UILabel!
    @IBOutlet weak var currentDrinkWaterHeight: NSLayoutConstraint!
    @IBOutlet private weak var currentDrinkWaterView: UIView!
    @IBOutlet private weak var amountWaterSuperView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var drinkWaterBtn: UIButton!
    @IBOutlet weak var parentTbl: UIView!
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipView: UIView!
    let MAX_HEIGHT = 200.0
    let disposeBag = DisposeBag()
    let tips = [
        "Nước lọc là lựa chọn tốt nhất cho sức khỏe của bạn",
        "Bạn nên uống nước vào thời điểm phù hợp, chẳng hạn như trước khi ăn, giữa các bữa ăn hoặc sau khi vận động.",
        "Bạn nên uống nước định kỳ trong suốt cả ngày thay vì uống một lượng lớn nước vào một lúc.",
        "Uống quá nhiều nước có gas và các đồ uống có chứa caffeine có thể gây ra mất nước trong cơ thể và gây ra tình trạng khô miệng.",
        "Uống nước ấm giúp giảm cảm giác khát và giúp cơ thể hấp thụ nước tốt hơn."
    ]
    var currentTip: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountWaterSuperView.layer.borderWidth = 1
        amountWaterSuperView.layer.borderColor = UIColor(hex: "5C5C5C").cgColor
        self.currentRecord.text = "\(Int(AppConfig.shared.currentDrinkWater))/\(Int(Setting.shared.drinkTarget)) ml"
        self.currentGlassLb.text = "+\(Int(Setting.shared.cupSize)) ml"
        currentGlassImage.image = imageForCup(size: Setting.shared.cupSize)
        waterAmountLabel.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 40
        tableView.estimatedRowHeight = 40
        tableView.separatorStyle = .none
        tableView.register(HomeDrinkRecordCell.self)
        if let notiData = MainTabBarVC.shared.notiData {
            UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                self.drinkWaterBtn.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }) { isFinished in
                guard isFinished else { return }
                UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                    self.drinkWaterBtn.transform = CGAffineTransform.identity
                })
            }
        }
        parentTbl.layer.makeShadow()
        updateWater()
        tipView.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
            guard let self = self else { return }
            let randomInt = Int(arc4random_uniform(5))
            if self.currentTip == randomInt {
                self.currentTip = self.currentTip == 4 ? 3 : (self.currentTip + 1)
            } else {
                self.currentTip = randomInt
            }
            self.tipLabel.text = "Tips: " + self.tips[self.currentTip]
        }
        .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func updateWater() {
        UIView.animate(withDuration: 0.5, delay: 0.0,options: .curveEaseInOut) {
            self.currentDrinkWaterHeight.constant = self.MAX_HEIGHT * min(1,(AppConfig.shared.currentDrinkWater / Setting.shared.drinkTarget))
            if self.currentDrinkWaterHeight.constant > 0.7 {
                self.currentRecord.textColor = .white
            } else {
                self.currentRecord.textColor = .black
            }
            self.waterAmountLabel.text = "\(Int(AppConfig.shared.currentDrinkWater)) ml"
            self.currentRecord.text = "\(Int(AppConfig.shared.currentDrinkWater))/\(Int(Setting.shared.drinkTarget)) ml"
            self.amountWaterSuperView.layoutIfNeeded()
        }
        
        AppConfig.shared.saveToUserDefault()
    }
    
    @IBAction func onDrinkWater(_ sender: Any) {
        let newDrinkRes = DrinkDayResult(amount: Setting.shared.cupSize, date: Date())
        AppConfig.shared.todayDrink.append(newDrinkRes)
        updateWater()
        tableView.reloadData()
    }
    
    @IBAction func onChangeCup(_ sender: Any) {
        let vc = CupSizeVC()
        vc.onChangeCup = { [weak self] amount in
            guard let self = self else { return }
            self.currentGlassImage.image = self.imageForCup(size: amount)
            self.currentGlassLb.text = "+\(Int(amount)) ml"
        }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func imageForCup(size: Double) -> UIImage? {
        switch size {
        case 1..<300:
            return UIImage(named: "bottle_small")
        case 300..<400:
            return UIImage(named: "bottle_medium")
        case 400...500:
            return UIImage(named: "bottle_big")
        default:
            return UIImage(named: "bottle")
        }
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
        amountLabel.text = "\(Int(data.amount)) ml"
        timeLabel.text = data.date.convertTo(region: VNRegion).toFormat("HH:mm")
    }
}

public extension CALayer {
    @discardableResult
    func makeShadow(offSet: CGSize = CGSize(width: 0, height: 2),
                    opacity: Float = 0.2,
                    radius: CGFloat = 4,
                    color: UIColor = UIColor.black) -> CALayer {
        shadowOffset = offSet
        shadowOpacity = opacity
        shadowRadius = radius
        shadowColor = color.cgColor
        masksToBounds = false
        
        return self
    }
}
