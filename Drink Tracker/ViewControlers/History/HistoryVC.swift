//
//  HistoryVC.swift
//  Drink Tracker
//
//  Created by Sern Duck on 31/03/2023.
//

import UIKit

enum DayOfWeek: Int, CaseIterable {
    case monday
    case tuesday
    case wenseday
    case thursday
    case friday
    case saturday
    case sunday
}

class HistoryVC: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet private weak var reportTableView: UITableView!
    @IBOutlet private weak var reportPerWeekView: UIView!
    
    var reports: [String] = []
    
    enum ReportSection: Int, CaseIterable {
        case weekAverage
        case monthAverage
        case percentFinish
        case drinkFrequency
        
        var title: String {
            switch self {
            case .weekAverage:
                return "Trung bình hàng tuần"
            case .monthAverage:
                return "Trung bình hàng tháng"
            case .percentFinish:
                return "Hoàn thành trung bình"
            case .drinkFrequency:
                return "Tần suất uống"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self        
        calendarCollectionView.isScrollEnabled = false

        calendarCollectionView.register(DateCell.self)
        
        reportTableView.dataSource = self
        reportTableView.estimatedRowHeight = UITableView.automaticDimension
        reportTableView.rowHeight = UITableView.automaticDimension
        reportTableView.delegate = self
        reportTableView.separatorStyle = .none
        reportTableView.rowHeight = 60
        reportTableView.estimatedRowHeight = 60
        reportTableView.register(ReportCell.self)
        
        reportPerWeekView.backgroundColor = UIColor(hex: "EBEBEB")
    }
}

extension HistoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(DateCell.self, indexPath)
        cell.bindData(DayOfWeek(rawValue: indexPath.row) ?? .monday)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DayOfWeek.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let windowWidth = UIScreen.main.bounds.width
        return CGSize(width: (windowWidth - 16) / 7 , height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

extension HistoryVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ReportSection.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ReportCell.self)
        let data = ReportSection(rawValue: indexPath.row) ?? .weekAverage
        cell.bind(title: data.title, value: "400ml")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
