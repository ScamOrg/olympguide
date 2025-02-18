//
//  ShowWrong.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

import UIKit

protocol HighlightableField: CustomTextField {
    func highlightError()
    var isWrong: Bool { get set }
}

extension HighlightableField where Self: UIView {
    func highlightError() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor(hex: "#FFCDCD")
        }
        isWrong = true
    }
}
