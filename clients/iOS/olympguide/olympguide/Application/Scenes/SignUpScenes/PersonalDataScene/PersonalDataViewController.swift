//
//  PersonalDataScene.swift
//  olympguide
//
//  Created by Tom Tim on 22.01.2025.
//

import UIKit

final class PersonalDataViewController: UIViewController, ValidationErrorDisplayable {
    
    // MARK: - Свойства
    private var userEmail: String = ""
    private var hasSecondName: Bool = true
    
    private var toggleButtonTopConstraint: NSLayoutConstraint?
    private var birthdayTopConstraint: NSLayoutConstraint?
    
    var interactor: PersonalDataInteractor?
    var router: PersonalDataRouter?
    
    // MARK: UI Элементы
    let lastNameTextField: HighlightableField = CustomInputDataField(with: "Фамилия")
    let nameTextField: HighlightableField = CustomInputDataField(with: "Имя")
    
    var secondNameTextField: HighlightableField = CustomInputDataField(with: "Отчество")
    
    let toggleSecondNameButton: HasSecondNameButton = HasSecondNameButton(frame: .zero)
    
    let birthdayPicker: HighlightableField = CustomDatePicker(with: "День рождения")
    
    let regionTextField: (HighlightableField & RegionDelegateOwner) = RegionTextField(
        with: "Регион",
        endPoint: "/meta/regions"
    )
    
    let passwordTextField: HighlightableField = CustomPasswordField(with: "Придумайте пароль")
    
    private let nextButton: UIButton = UIButton(type: .system)
    
    // MARK: Свойства данных
    var lastName: String = ""
    var firstName: String = ""
    var secondName: String = ""
    var birthday: String = ""
    var region: Int?
    var password: String = ""
    
    // MARK: - Инициализация
    
    init(email: String) {
        super.init(nibName: nil, bundle: nil)
        self.userEmail = email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been реализован")
    }
    
    
    // MARK: - Жизненный цикл
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Личные данные"
        
        configureUI()
        
        toggleSecondNameButton.addTarget(self, action: #selector(toggleSecondNameTapped), for: .touchUpInside)
        
        lastNameTextField.delegate = self
        nameTextField.delegate = self
        secondNameTextField.delegate = self
        birthdayPicker.delegate = self
        passwordTextField.delegate = self
        
        nameTextField.tag = 1
        secondNameTextField.tag = 2
        lastNameTextField.tag = 3
        birthdayPicker.tag = 4
        regionTextField.tag = 5
        passwordTextField.tag = 6
        
        if let navigationController = self.navigationController {
            let viewControllers = navigationController.viewControllers
            if let rootViewController = viewControllers.first {
                navigationController.setViewControllers([rootViewController, self], animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.backgroundColor = .clear
        if self.isMovingFromParent {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    // MARK: - Настройка UI
    
    private func configureUI() {
        // 1. Фамилия
        configureLastNameTextField()
        // 2. Имя
        configureNameTextField()
        // 3. Отчество (если включено)
        if hasSecondName {
            configureSecondNameTextField()
        }
        // 4. Кнопка для переключения поля «Отчество»
        configureToggleSecondNameButton()
        // 5. День рождения
        configureBirthdayPicker()
        // 6. Регион
        configureRegionTextField()
        // 7. Пароль
        configurePasswordTextField()
        
        configureNextButton()
        
        let hiddenUsernameField = UITextField(frame: .zero)
        hiddenUsernameField.text = userEmail
        hiddenUsernameField.textContentType = .username
        hiddenUsernameField.isHidden = true
        view.addSubview(hiddenUsernameField)
    }
    
    private func configureLastNameTextField() {
        view.addSubview(lastNameTextField)
        
        lastNameTextField.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        lastNameTextField.pinLeft(to: view.leadingAnchor, 20)
    }
    
    private func configureNameTextField() {
        view.addSubview(nameTextField)
        
        nameTextField.pinTop(to: lastNameTextField.bottomAnchor, 24)
        nameTextField.pinLeft(to: view.leadingAnchor, 20)
    }
    
    private func configureSecondNameTextField() {
        view.addSubview(secondNameTextField)
        
        secondNameTextField.pinTop(to: nameTextField.bottomAnchor, 24)
        secondNameTextField.pinLeft(to: view.leadingAnchor, 20)
    }
    
    private func configureToggleSecondNameButton() {
        view.addSubview(toggleSecondNameButton)
        toggleSecondNameButton.text = "Нет отчества"
        
        toggleSecondNameButton.translatesAutoresizingMaskIntoConstraints = false
        
        if hasSecondName {
            toggleButtonTopConstraint = toggleSecondNameButton.topAnchor.constraint(
                equalTo: secondNameTextField.bottomAnchor,
                constant: 24
            )
        } else {
            toggleButtonTopConstraint = toggleSecondNameButton.topAnchor.constraint(
                equalTo: nameTextField.bottomAnchor,
                constant: 24
            )
        }
        toggleButtonTopConstraint?.isActive = true
        
        toggleSecondNameButton.pinLeft(to: view.leadingAnchor)
        toggleSecondNameButton.pinRight(to: view.trailingAnchor)
    }
    
    private func configureBirthdayPicker() {
        view.addSubview(birthdayPicker)
        birthdayPicker.translatesAutoresizingMaskIntoConstraints = false
        birthdayTopConstraint = birthdayPicker.topAnchor.constraint(equalTo: toggleSecondNameButton.bottomAnchor, constant: 24)
        birthdayTopConstraint?.isActive = true
        
        birthdayPicker.pinLeft(to: view.leadingAnchor, 20)
        
        
    }
    
    private func configureRegionTextField() {
        view.addSubview(regionTextField)
        
        regionTextField.pinTop(to: birthdayPicker.bottomAnchor, 24)
        regionTextField.pinLeft(to: view.leadingAnchor, 20)
        
        regionTextField.regionDelegate = self
    }
    
    private func configurePasswordTextField() {
        view.addSubview(passwordTextField)
        
        passwordTextField.pinTop(to: regionTextField.bottomAnchor, 24)
        passwordTextField.pinLeft(to: view.leadingAnchor, 20)
        
        passwordTextField.setTextFieldType(.default, .newPassword)
    }
    
    private func configureNextButton() {
        nextButton.titleLabel?.font = UIFont(name: "MontserratAlternates-Medium", size: 15)!
        nextButton.layer.cornerRadius = 13
        nextButton.titleLabel?.tintColor = .black
        nextButton.backgroundColor = UIColor(hex: "#E0E8FE")
        nextButton.setTitle("Продолжить", for: .normal)
        
        view.addSubview(nextButton)
        
        nextButton.setHeight(48)
        nextButton.pinLeft(to: view.leadingAnchor, 20)
        nextButton.pinRight(to: view.trailingAnchor, 20)
        nextButton.pinBottom(to: view.bottomAnchor, 43)
        
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    
    // MARK: - Переключение поля «Отчество»
    
    @objc private func toggleSecondNameTapped() {
        if hasSecondName {
            hasSecondName = false
            secondNameTextField.removeFromSuperview()
            
            toggleButtonTopConstraint?.isActive = false
            toggleButtonTopConstraint = toggleSecondNameButton.topAnchor.constraint(
                equalTo: nameTextField.bottomAnchor,
                constant: 24
            )
            toggleButtonTopConstraint?.isActive = true
            toggleSecondNameButton.setImage(UIImage(systemName: "inset.filled.circle"), for: .normal)
        } else {
            hasSecondName = true
            view.addSubview(secondNameTextField)
            secondNameTextField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                secondNameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
                secondNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            ])
            
            toggleButtonTopConstraint?.isActive = false
            toggleButtonTopConstraint = toggleSecondNameButton.topAnchor.constraint(
                equalTo: secondNameTextField.bottomAnchor,
                constant: 24
            )
            toggleButtonTopConstraint?.isActive = true
            toggleSecondNameButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.view.layoutIfNeeded()
            self?.secondNameTextField.alpha = self?.hasSecondName ?? false ? 1 : 0
        }
    }
    
    // MARK: - Keyboard Handling
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        // Высота клавиатуры
        let keyboardHeight = keyboardFrame.height
        
        // Ищем текущий firstResponder (какое поле сейчас редактируется)
        if let activeField = view.currentFirstResponder() as? UIView {
            // координата Y нижнего края поля ввода внутри self.view
            let bottomOfTextField = activeField.convert(activeField.bounds, to: self.view).maxY
            
            // Верх клавиатуры относительно self.view
            let topOfKeyboard = self.view.frame.height - keyboardHeight
            
            // Если поле уходит ниже клавиатуры, поднимаем экран
            if bottomOfTextField > topOfKeyboard {
                let offset = bottomOfTextField - topOfKeyboard + 10
                self.view.frame.origin.y = -offset
            } else {
                self.view.frame.origin.y = 0
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    // MARK: - Actions
    @objc
    private func didTapNextButton() {
        let request = PersonalData.SignUp.Request(
            email: userEmail,
            password: password,
            firstName: firstName,
            lastName: lastName,
            secondName: hasSecondName ? secondName : nil,
            birthday: birthday,
            regionId: region
        )
        interactor?.signUp(request: request)
    }
}


// MARK: - Делегаты для кастомных текстовых полей
extension PersonalDataViewController: CustomTextFieldDelegate {
    func action(_ searchBar: CustomTextField, textDidChange text: String) {
        switch searchBar.tag {
        case 1:
            firstName = text
        case 2:
            secondName = text
        case 3:
            lastName = text
        case 4:
            birthday = text
        case 6:
            password = text
        default:
            break
        }
    }
}

extension PersonalDataViewController: RegionTextFieldDelegate {
    func regionTextFieldDidSelect(region: Int) {
        self.region = region
    }
    
    func regionTextFieldWillSelect(with optionsVC: OptionsViewController) {
        optionsVC.modalPresentationStyle = .overFullScreen
        present(optionsVC, animated: false) {
            optionsVC.animateShow()
        }
    }
    
    func dissmissKeyboard() {
        view.endEditing(true)
    }
}

extension PersonalDataViewController : PersonalDataDisplayLogic {
    func displaySignUp(viewModel: PersonalData.SignUp.ViewModel) {
        if let errorMesseges = viewModel.errorMessage {
            showAlert(with: errorMesseges.joined(separator: "\n"))
            return
        }
        router?.routeToRoot(email: userEmail, password: password)
    }
}
