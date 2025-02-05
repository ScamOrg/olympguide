//
//  UIViewController+FirstResponder.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

import UIKit

// MARK: - Расширение для поиска текущего поля (firstResponder)
 extension UIView {
    func currentFirstResponder() -> UIResponder? {
        if self.isFirstResponder {
            return self
        }
        for subview in self.subviews {
            if let responder = subview.currentFirstResponder() {
                return responder
            }
        }
        return nil
    }
}
