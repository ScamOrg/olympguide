//
//  UIViewController+Alert.swift
//  olympguide
//
//  Created by Tom Tim on 26.01.2025.
//

import UIKit

// MARK: - UIViewController Extension
extension UIViewController {

    // MARK: - Show Alert Method
    func showAlert(title: String = "Ошибка", with message: String?, cancelTitle: String = "Отмена") {
        let alert = UIAlertController(title: title, message: (message ?? "Ошибка"), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
