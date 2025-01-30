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
        setActionButtonImage(UIImage(systemName: "eye"))
        setActionButtonTarget(
            self,
            #selector(showPassword),
            for: .touchDown
        )
        addActionButtonTarget(
            self,
            #selector(hidePassword),
            for: [
                .touchUpInside,
                .touchUpOutside,
                .touchCancel
            ]
        )
    }
    
    @MainActor required init?(coder: NSCoder) {
        super.init(coder: coder)
        setSecureTextEntry(true)
        setActionButtonImage(UIImage(systemName: "eye"))
        setActionButtonTarget(self, #selector(showPassword), for: .touchDown)
    }
    
    @objc private func hidePassword() {
        setActionButtonImage(UIImage(systemName: "eye"))
        setSecureTextEntry(true)
    }
    
    @objc private func showPassword() {
        setActionButtonImage(UIImage(systemName: "eye.slash"))
        setSecureTextEntry(false)
    }
}
