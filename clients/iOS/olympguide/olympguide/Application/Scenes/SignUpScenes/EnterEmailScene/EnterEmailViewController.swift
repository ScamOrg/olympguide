//
//  EnterEmailViewController.swift
//  olympguide
//
//  Created by Tom Tim on 19.01.2025.
//

import UIKit

final class EnterEmailViewController: UIViewController {
    private let emailTextField = CustomSearchBar(title: "email")
    private let nextButton: UIButton = UIButton(type: .system)
    private var nextButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Регистрация"
        configureUI()
//        hidesBottomBarWhenPushed = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureEmailTextField()
        configureNextButton()
    }
    
    private func configureEmailTextField() {
        view.addSubview(emailTextField)
        
        emailTextField.setHeight(48)
        emailTextField.setWidth(UIScreen.main.bounds.width - 2 * 20)
        emailTextField.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        emailTextField.pinLeft(to: view.leadingAnchor, 20)
        emailTextField.setTextFieldType(.emailAddress, .emailAddress)
    }
    private func configureNextButton() {
        nextButton.titleLabel?.font = UIFont(name: "MontserratAlternates-Medium", size: 15)!
        nextButton.layer.cornerRadius = 13
        nextButton.titleLabel?.tintColor = .black
        nextButton.backgroundColor = UIColor(hex: "#E0E8FE")
        nextButton.setTitle("Продолжить", for: .normal)

        
//        view.addSubview(nextButton)
//        nextButton.setHeight(48)
//        nextButton.pinCenterX(to: view)
//        nextButton.pinLeft(to: view.leadingAnchor, 20)
//        nextButton.pinRight(to: view.trailingAnchor, 20)
//        nextButton.pinBottom(to: view.bottomAnchor, 100)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(nextButton)
            
            NSLayoutConstraint.activate([
                nextButton.heightAnchor.constraint(equalToConstant: 48),
                nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
            
            // Создаем и активируем нижнее ограничение, сохраняя его ссылку
            nextButtonBottomConstraint = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -43)
            nextButtonBottomConstraint.isActive = true
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            
            // Получаем высоту клавиатуры
            let keyboardHeight = keyboardFrame.height
            
            // Обновляем константу нижнего ограничения кнопки, чтобы она поднялась над клавиатурой
            // Здесь можно добавить отступ, если нужно
            nextButtonBottomConstraint.constant = -keyboardHeight - 10
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        if let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            nextButtonBottomConstraint.constant = -43
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
