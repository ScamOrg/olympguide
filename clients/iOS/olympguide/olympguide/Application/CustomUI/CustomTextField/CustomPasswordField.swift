//
//  CustomPasswordField.swift
//  olympguide
//
//  Created by Tom Tim on 30.01.2025.
//

import UIKit

class CustomPasswordField: CustomTextField {
    override init(with title: String) {
        super.init(with: title)
        setSecureTextEntry(true)
    }
    
    @MainActor required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
