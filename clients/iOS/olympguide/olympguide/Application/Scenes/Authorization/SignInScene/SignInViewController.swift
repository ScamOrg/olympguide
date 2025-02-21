//
//  SignInViewController.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

import UIKit

final class SignInViewController: UIViewController, SignInValidationErrorDisplayable {
    
    // MARK: - VIP
    var interactor: SignInBusinessLogic?
    var router: SignInRoutingLogic?
    
    // MARK: - UI
    let emailTextField: HighlightableField = CustomInputDataField(with: "email")
    let passwordTextField: HighlightableField = CustomPasswordField(with: "пароль")
    
    private let nextButton: UIButton = UIButton(type: .system)
    private var nextButtonBottomConstraint: NSLayoutConstraint!
    private var email: String = ""
    private var password: String = ""
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Вход"
        
        emailTextField.tag = 1
        passwordTextField.tag = 2
        
        configureUI()
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
        configurePasswordTextField()
        configureNextButton()
    }
    
    private func configureEmailTextField() {
        view.addSubview(emailTextField)
        
        emailTextField.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        emailTextField.pinLeft(to: view.leadingAnchor, 20)
        emailTextField.setTextFieldType(.emailAddress, .username)
        emailTextField.delegate = self
    }
    
    private func configurePasswordTextField() {
        view.addSubview(passwordTextField)
        
        passwordTextField.pinTop(to: emailTextField.bottomAnchor, 24)
        passwordTextField.pinLeft(to: view.leadingAnchor, 20)
        passwordTextField.setTextFieldType(.default, .password)
        passwordTextField.delegate = self
    }
    
    private func configureNextButton() {
        nextButton.titleLabel?.font = UIFont(name: "MontserratAlternates-Medium", size: 15)!
        nextButton.layer.cornerRadius = 13
        nextButton.titleLabel?.tintColor = .black
        nextButton.backgroundColor = UIColor(hex: "#E0E8FE")
        nextButton.setTitle("Войти", for: .normal)
        
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
        let request = SignInModels.SignIn.Request(email: email, password: password)
        interactor?.signIn(request)
    }
}

extension SignInViewController: CustomTextFieldDelegate {
    func action(_ searchBar: CustomTextField, textDidChange text: String) {
        switch searchBar.tag {
        case 1:
            email = text
        case 2:
            password = text
        default:
            break
        }
    }
}

// MARK: - Keyboard handling
extension SignInViewController {
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


extension SignInViewController : SignInDisplayLogic {
    func displaySignInResult(_ viewModel: SignInModels.SignIn.ViewModel) {
        if viewModel.success {
            router?.routeToRoot()
        } else {
            if let errorMesseges = viewModel.errorMessages, errorMesseges.count > 0 {
                showAlert(with: errorMesseges.joined(separator: "\n"))
                return
            }
        }
    }
}

