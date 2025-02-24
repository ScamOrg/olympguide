//
//  UIInformationLabel.swift
//  olympguide
//
//  Created by Tom Tim on 25.02.2025.
//

import UIKit

final class UIInformationLabel: UILabel {
    private var regularText: String = ""
    private var boldText: String = ""
    
    func setText(regular: String = "", bold: String = "") {
        self.regularText = regular
        self.boldText = bold
        updateAttributedText()
    }
    
    func setBoldText(_ bold: String) {
        self.boldText = bold
        updateAttributedText()
    }
    
    private func updateAttributedText() {
        let fullText = regularText + boldText
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let regularFont = UIFont(name: "MontserratAlternates-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let boldFont = UIFont(name: "MontserratAlternates-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
        
        let textColor = UIColor.black.withAlphaComponent(0.53)
        attributedString.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: fullText.count))
        
        attributedString.addAttribute(
            .font,
            value: regularFont,
            range: NSRange(
                location: 0,
                length: regularText.count
            )
        )
        
        let boldRange = NSRange(
            location: regularText.count,
            length: boldText.count
        )
        attributedString.addAttribute(
            .font,
            value: boldFont,
            range: boldRange
        )
        
        attributedText = attributedString
    }
}
