//
//  CustomSearchBar.swift
//  olympguide
//
//  Created by Tom Tim on 07.01.2025.
//

import UIKit

// MARK: - CustomSearchBar
final class CustomSearchBar : CustomTextField {
    private var isWrong = false
    
    func makeRed() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor(hex: "#FFCDCD")
        }
        isWrong = true
    }
    
    override func textFieldDidChange(_ textField: UITextField) {
        super.textFieldDidChange(textField)
        
        if isWrong {
            isWrong = false
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = .white
            }
        }
    }
}
