//
//  HistoryVC.swift
//  Drink Tracker
//
//  Created by Sern Duck on 31/03/2023.
//

import UIKit
import RxSwift
import RxCocoa
import Charts
import SwiftDate

enum DayOfWeek: Int, CaseIterable {
    case monday
    case tuesday
    case wenseday
    case thursday
    case friday
    case saturday
    case sunday
    
    var index: Int {
        switch self {
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wenseday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        case .sunday:
            return 8
        }
    }
    
    var text: String {
        switch self {
        case .monday:
            return "Thứ 2"
        case .tuesday:
            return "Thứ 3"
        case .wenseday:
            return "Thứ 4"
        case .thursday:
            return "Thứ 5"
        case .friday:
            return "Thứ 6"
        case .saturday:
            return "Thứ 7"
        case .sunday:
            return "Chủ nhật"
        }
    }
}

class HistoryVC: UIViewController {
    
    @IBOutlet private weak var calendarCollectionView: UICollectionView!
    @IBOutlet private weak var reportTableView: UITableView!
    @IBOutlet private weak var reportPerWeekView: UIView!
    @IBOutlet private weak var barChartView: BarChartView!
    
    private let disposeBag = DisposeBag()
    
    struct Report: Codable {
        // T2 -> CN
        var weekDayFinishTarget: [Double] = []
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
        setupUI()
        genReport()
        setupChart()
        
        NotificationCenter.default.rx
            .notification(UIApplication.didBecomeActiveNotification)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.genReport()
                self.setupChart()
                self.calendarCollectionView.reloadData()
                self.reportTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func genReport() {
        DispatchQueue.global(qos: .background).sync {
            let drinkHistory = AppConfig.shared.drinkHistory
            guard !drinkHistory.isEmpty else { return }
            
            let startDayOfWeek = DateInRegion(region: VNRegion).dateAt(.startOfWeek)
            
            let allDate = drinkHistory.keys
            
            let weekDayFinishTarget = DayOfWeek.allCases.map { dayOfWeek in
                let date = startDayOfWeek + dayOfWeek.rawValue.days
                let index = allDate.firstIndex(where: { d in
                    DateInRegion(d,region: VNRegion).compare(toDate: date, granularity: .day) == .orderedSame
                })
                if let index = index,
                   let dateHistory = drinkHistory[allDate[index]] {
                    let totalDrink = dateHistory.reduce(0, { $0 + $1.amount })
                    return totalDrink
                } else {
                    return 0
                }
            }
            
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
                weekDayFinishTarget: weekDayFinishTarget,
                weaklyAmount: totalDrink / countWeek,
                monthlyAmount: totalDrink / countMonth,
                percentFinish: countDayReachTarget / countDay * 100,
                drinkFrequency: drinkTimes / Int(countDay)
            )
        }
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
        cell.bindData(
            DayOfWeek(rawValue: indexPath.row) ?? .monday,
            isDone: report.weekDayFinishTarget[indexPath.row] >= Setting.shared.drinkTarget)
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
        barChartView.isUserInteractionEnabled = false
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawAxisLineEnabled    = true
        barChartView.leftAxis.gridLineDashLengths    = [4.0, 6.0]
        barChartView.leftAxis.gridLineWidth          = 1.0
        barChartView.xAxis.gridLineDashPhase = 5
        barChartView.xAxis.labelCount = DayOfWeek.allCases.count
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: DayOfWeek.allCases.map { $0.text })
        barChartView.legend.enabled = false
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.axisMaximum = 110
        barChartView.leftAxis.axisRange = 20
        
        // Set up chart data
        let dataEntries: [BarChartDataEntry] = DayOfWeek.allCases.map {
            BarChartDataEntry(x: Double($0.rawValue), y: report.weekDayFinishTarget[$0.rawValue]/Setting.shared.drinkTarget * 100)
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
