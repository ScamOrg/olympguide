//
//  EnterEmailViewController.swift
//  olympguide
//
//  Created by Tom Tim on 19.01.2025.
//

import UIKit

final class EnterEmailViewController: UIViewController, NonTabBarVC {
    
    // MARK: - VIP
    var interactor: EnterEmailBusinessLogic?
    var router: (EnterEmailRoutingLogic & EnterEmailDataPassing)?
    
    // MARK: - UI
    private let emailTextField: CustomInputDataField = CustomInputDataField(with: "email")
    private let nextButton: UIButton = UIButton(type: .system)
    private var nextButtonBottomConstraint: NSLayoutConstraint!
    private var currentEmail: String = ""
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Регистрация"
        configureUI()
        let backItem = UIBarButtonItem(title: "Регистрация", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Private UI Setup
    private func configureUI() {
        view.backgroundColor = .white
        configureEmailTextField()
        configureNextButton()
    }
    
    private func configureEmailTextField() {
        view.addSubview(emailTextField)
        
        emailTextField.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        emailTextField.pinLeft(to: view.leadingAnchor, 20)
        emailTextField.setTextFieldType(.emailAddress, .emailAddress)
        emailTextField.delegate = self
    }
    
    private func configureNextButton() {
        nextButton.titleLabel?.font = UIFont(name: "MontserratAlternates-Medium", size: 15)!
        nextButton.layer.cornerRadius = 13
        nextButton.titleLabel?.tintColor = .black
        nextButton.backgroundColor = UIColor(hex: "#E0E8FE")
        nextButton.setTitle("Продолжить", for: .normal)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 48),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        nextButtonBottomConstraint = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -43)
        nextButtonBottomConstraint.isActive = true
        
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc
    private func didTapNextButton() {
        let request = EnterEmailModels.SendCode.Request(email: currentEmail)
        interactor?.sendCode(request: request)
    }
}

extension EnterEmailViewController: CustomTextFieldDelegate {
    func action(_ searchBar: CustomTextField, textDidChange text: String) {
        currentEmail = text
    }
}

// MARK: - Keyboard handling
extension EnterEmailViewController {
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            let keyboardHeight = keyboardFrame.height
            nextButtonBottomConstraint.constant = -keyboardHeight - 10
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        if let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            nextButtonBottomConstraint.constant = -43
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - EnterEmailDisplayLogic
extension EnterEmailViewController: EnterEmailDisplayLogic {
    func displaySendCodeResult(viewModel: EnterEmailModels.SendCode.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            let alert = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            emailTextField.highlightError()
            present(alert, animated: true)
        } else {
            router?.routeToVerifyCode()
        }
    }
}
