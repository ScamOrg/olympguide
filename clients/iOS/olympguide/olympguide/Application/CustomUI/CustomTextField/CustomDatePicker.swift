//
//  CustomDatePicker.swift
//  olympguide
//
//  Created by Tom Tim on 29.01.2025.
//

import UIKit

// MARK: - CustomDatePicker
final class CustomDatePicker: CustomTextField {
    private let datePicker: UIDatePicker = UIDatePicker()
    
    override init(with title: String) {
        super.init(with: title)
        setTextFieldInputView(datePicker)
        configureDatePicker()
    }
    
    @MainActor required init?(coder: NSCoder) {
        super.init(coder: coder)
        setTextFieldInputView(datePicker)
        configureDatePicker()
    }
    
    private func configureDatePicker() {
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let targetYear = currentYear - 16
        let defaultDate = Calendar.current.date(from: DateComponents(year: targetYear, month: 1, day: 1))
        datePicker.date = defaultDate ?? Date()
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    override func closeKeyboard() {
        dateChanged(datePicker)
        
        super.closeKeyboard()
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        setTextFieldText(formatter.string(from: datePicker.date))
        
        textFieldSendAction(for: .editingChanged)
    }
}

