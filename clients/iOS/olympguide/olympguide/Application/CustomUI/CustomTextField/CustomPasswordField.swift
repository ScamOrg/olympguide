//
//  CustomPasswordField.swift
//  olympguide
//
//  Created by Tom Tim on 30.01.2025.
//

import UIKit

class CustomPasswordField: CustomTextField, HighlightableField {
    var isWrong: Bool = false
    
    var savedText: String? = nil
    
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
        setTextFieldType(.default, .newPassword)
        configureVisiblePasswordField()
    }
    
    @MainActor required init?(coder: NSCoder) {
        super.init(coder: coder)
        setSecureTextEntry(true)
        setActionButtonImage(UIImage(systemName: "eye"))
        setActionButtonTarget(self, #selector(showPassword), for: .touchDown)
    }
    
//    override func textFieldDidChange(_ textField: UITextField) {
//        if (savedText != nil) {
//            setTextFieldText(savedText)
//            savedText = nil
//        }
//        super.textFieldDidChange(textField)
//    }
    let visiblePassword = UILabel()
    
    func configureVisiblePasswordField() {
        self.addSubview(visiblePassword)
        visiblePassword.font =  UIFont(name: "MontserratAlternates-Regular", size: 14)!
        visiblePassword.textColor = .black
        visiblePassword.pinTop(to: textField.topAnchor)
        visiblePassword.pinLeft(to: textField.leadingAnchor)
        visiblePassword.pinRight(to: textField.trailingAnchor)
        visiblePassword.pinBottom(to: textField.bottomAnchor)
        visiblePassword.alpha = 0
    }
    @objc private func hidePassword() {
        setActionButtonImage(UIImage(systemName: "eye"))
//        savedText = textField.text
//        setSecureTextEntry(true)
        visiblePassword.alpha = 0
        textField.alpha = 1
    }
    
    @objc private func showPassword() {
        setActionButtonImage(UIImage(systemName: "eye.slash"))
//        setSecureTextEntry(false)
        visiblePassword.text = textField.text
        visiblePassword.alpha = 1
        textField.alpha = 0
    }
}
