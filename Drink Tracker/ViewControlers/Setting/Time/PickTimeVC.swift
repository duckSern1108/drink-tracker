//
//  PickTimeVC.swift
//  Drink Tracker
//
//  Created by Sern Duck on 24/04/2023.
//

import UIKit

class PickTimeVC: UIViewController {
    
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var hourPicker: UIPickerView!
    @IBOutlet private weak var minutePicker: UIPickerView!
    
    static func newVC(selectedHour: Int, selectedMinute: Int, title: String) -> PickTimeVC {
        let vc = PickTimeVC()
        vc.selectedHour = selectedHour
        vc.selectedMinute = selectedMinute
        vc.headerTitle = title
        return vc
    }
        
    var selectedHour: Int = -1
    var selectedMinute: Int = -1
    var headerTitle: String = ""
    var onConfirmChange: ((_ time: Int, _ minute: Int) -> Void)?
    
    private let hourOptions: [Int] = Array(stride(from: 1, to: 24, by: 1))
    private let minuteOptions: [Int] = Array(stride(from: 0, to: 60, by: 5))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = headerTitle
        
        hourPicker.dataSource = self
        hourPicker.delegate = self
        if let selectedHourIndex = hourOptions.firstIndex(where: { $0 == selectedHour }) {
            hourPicker.selectRow(selectedHourIndex, inComponent: 0, animated: false)
        }
        
        minutePicker.dataSource = self
        minutePicker.delegate = self
        if let selectedMinuteIndex = minuteOptions.firstIndex(where: { $0 == selectedMinute }) {
            minutePicker.selectRow(selectedMinuteIndex, inComponent: 0, animated: false)
        }
    }
    
    @IBAction private func onConfirm(_ sender: Any) {
        dismiss(animated: true)
        onConfirmChange?(
            hourOptions[hourPicker.selectedRow(inComponent: 0)],
            minuteOptions[minutePicker.selectedRow(inComponent: 0)]
        )
    }
}

extension PickTimeVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case hourPicker:
            return hourOptions.count
        case minutePicker:
            return minuteOptions.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        20
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case hourPicker:
            return "\(hourOptions[row] < 10 ? "0" : "")\(hourOptions[row])"
        case minutePicker:
            return "\(minuteOptions[row] < 10 ? "0" : "")\(minuteOptions[row])"
        default:
            return nil
        }
    }
}
