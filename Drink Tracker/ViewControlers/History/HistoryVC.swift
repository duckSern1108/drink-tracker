//
//  HistoryVC.swift
//  Drink Tracker
//
//  Created by Sern Duck on 31/03/2023.
//

import UIKit
import Charts
import SwiftDate

enum DayOfWeek: Int, CaseIterable {
    case monday = 2
    case tuesday = 3
    case wenseday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 8
}

class HistoryVC: UIViewController {
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet private weak var reportTableView: UITableView!
    @IBOutlet private weak var reportPerWeekView: UIView!
    @IBOutlet weak var barChartView: BarChartView!
    
    struct Report: Codable {
        var weaklyAmount: Double = 0
        var monthlyAmount: Double = 0
        var percentFinish: Double = 0
        // ngay
        var drinkFrequency: Int = 0
    }
    
    var report: Report = .init()
    
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
        genReport()
        setupUI()
        setupChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func genReport() {
        let drinkHistory = AppConfig.shared.drinkHistory
        guard !drinkHistory.isEmpty else { return }
        let sortedDate = drinkHistory.keys.sorted(by: >)
        
        var startMonthDate: Date = sortedDate.first!
        var countMonth: Double = 1
        
        var startWeekDate: Date = sortedDate.first!
        var countWeek: Double = 1
        
        let countDay = Double(drinkHistory.keys.count)
        var countDayReachTarget = 0.0
        
        var totalDrink: Double = 0
        
        var drinkTimes: Int = 0
        sortedDate.forEach { date in
            let dateTotalAmount = drinkHistory[date]!.reduce(0, { $0 + $1.amount })
            countDayReachTarget += dateTotalAmount < Setting.shared.drinkTarget ? 0 : 1
            totalDrink += dateTotalAmount
            print(drinkHistory[date]!.count)
            drinkTimes += drinkHistory[date]!.count
            
            if date.month == startMonthDate.month && date.year == startMonthDate.year {
            } else {
                startMonthDate = date
                countMonth += 1
            }
            
            if date.compare(toDate: startWeekDate, granularity: .weekdayOrdinal) == .orderedSame {
            } else {
                startWeekDate = date
                countWeek += 1
            }
        }
        
        report = Report(
            weaklyAmount: totalDrink / countWeek,
            monthlyAmount: totalDrink / countMonth,
            percentFinish: countDayReachTarget / countDay * 100,
            drinkFrequency: drinkTimes / Int(countDay)
        )
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
        let value: String = {
            switch data {
            case .weekAverage:
                return "\(Int(report.weaklyAmount)) ml / tuần"
            case .monthAverage:
                return "\(Int(report.monthlyAmount)) ml / tháng"
            case .percentFinish:
                return "\(Int(report.percentFinish))%"
            case .drinkFrequency:
                return "\(report.drinkFrequency) lần / ngày"
            }
        }()
        cell.bind(title: data.title, value: value, seperatorColor: UIColor(hex: "EBEBEB"), isShowPoint: true, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension HistoryVC {
    func setupChart(){
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
        var dataEntries: [BarChartDataEntry] = []
        let days: [String] = ["Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "Chủ nhật"]
        barChartView.isUserInteractionEnabled = false
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawAxisLineEnabled    = true
        barChartView.leftAxis.gridLineDashLengths    = [4.0, 6.0]
        barChartView.leftAxis.gridLineWidth          = 1.0
        barChartView.xAxis.gridLineDashPhase = 5
        barChartView.xAxis.labelCount = days.count
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        barChartView.legend.enabled = false
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.axisMaximum = 110
        barChartView.leftAxis.axisRange = 20
        
        // Set up chart data
        for i in 0...6 {
            var data = BarChartDataEntry(x: Double(i), y: 0)
            for v in valsFilter {
                if v.date.weekday - 2 == i {
                    data = BarChartDataEntry(x: Double(i), y: v.amount/Setting.shared.drinkTarget * 100)
                }
            }
            dataEntries.append(data)
        }

        
        // Set up bar chart data set
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "test")
        chartDataSet.colors = [.appColorBold]
        chartDataSet.valueFont = UIFont.systemFont(ofSize: 10)
        chartDataSet.valueColors = [.black]
        chartDataSet.drawValuesEnabled = true
        
        
        // Set up bar chart data
        let chartData = BarChartData(dataSet: chartDataSet)
        
        // Set bar chart data to the bar chart view
        barChartView.data = chartData
    }
}
