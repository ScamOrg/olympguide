//
//  PersonalDataScene.swift
//  olympguide
//
//  Created by Tom Tim on 22.01.2025.
//

//import UIKit
//
//final class PersonalDataViewController: UIViewController {
//    private var userEmail: String = ""
//    
//    let lastNameTextField: CustomInputDataField = CustomInputDataField(with: "Фамилия")
//    let nameTextField: CustomInputDataField = CustomInputDataField(with: "Имя")
//    let secondNameTextField: CustomInputDataField = CustomInputDataField(with: "Отчество")
//    let birthdayPicker: CustomDatePicker = CustomDatePicker(with: "День рождения")
//    let regionTextField: RegionTextField = RegionTextField(
//        with: "Регион",
//        regions: [
//            "Москва",
//            "Санкт-Петербург",
//            "Йошкар-Ола",
//            "Екатеринбург",
//            "Петрозаводск",
//            "Казань",
//            "Новосибирск",
//            "Нижний Новгород",
//            "Омск",
//            "Ростов-на-Дону",
//            "Самара",
//            "Саратов",
//            "Ульяновск"
//        ]
//    )
//    let passwordTextField: CustomPasswordField = CustomPasswordField(with: "Придумайте пароль")
//    
//    var lastName = ""
//    var name = ""
//    var secondName = ""
//    var birthday = ""
//    var region = ""
//    var password = ""
//    var confirmPassword = ""
//    
//    init(email: String) {
//        super.init(nibName: nil, bundle: nil)
//        self.userEmail = email
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        nameTextField.tag = 1
//        secondNameTextField.tag = 2
//        lastNameTextField.tag = 3
//        birthdayPicker.tag = 4
//        regionTextField.tag = 5
//        
//        view.backgroundColor = .white
//        title = "Личные данные"
//        configureUI()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        if self.isMovingFromParent {
//            navigationController?.popToRootViewController(animated: true)
//        }
//    }
//    
//    private func configureUI() {
//        configureLastNameTextField()
//        configureNameTextField()
//        configureSecondNameTextField()
//        configureBirthdayPicker()
//        configureRegionTextField()
//        configurePasswordTextField()
//    }
//    
//    private func configureLastNameTextField() {
//        view.addSubview(lastNameTextField)
//        lastNameTextField.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
//        lastNameTextField.pinLeft(to: view.leadingAnchor, 20)
//    }
//    
//    private func configureNameTextField() {
//        view.addSubview(nameTextField)
//        nameTextField.pinTop(to: lastNameTextField.bottomAnchor, 24)
//        nameTextField.pinLeft(to: view.leadingAnchor, 20)
//    }
//    
//    private func configureSecondNameTextField() {
//        view.addSubview(secondNameTextField)
//        secondNameTextField.pinTop(to: nameTextField.bottomAnchor, 24)
//        secondNameTextField.pinLeft(to: view.leadingAnchor, 20)
//    }
//    
//    private func configureBirthdayPicker() {
//        view.addSubview(birthdayPicker)
//        birthdayPicker.pinTop(to: secondNameTextField.bottomAnchor, 24)
//        birthdayPicker.pinLeft(to: view.leadingAnchor, 20)
//    }
//    
//    private func configureRegionTextField() {
//        view.addSubview(regionTextField)
//        regionTextField.pinTop(to: birthdayPicker.bottomAnchor, 24)
//        regionTextField.pinLeft(to: view.leadingAnchor, 20)
//        
//        regionTextField.regionDelegate = self
//    }
//    
//    private func configurePasswordTextField() {
//        view.addSubview(passwordTextField)
//        passwordTextField.pinTop(to: regionTextField.bottomAnchor, 24)
//        passwordTextField.pinLeft(to: view.leadingAnchor, 20)
//    }
//}
//
//extension PersonalDataViewController : CustomTextFieldDelegate {
//    func action(_ searchBar: CustomTextField, textDidChange text: String) {
//        switch searchBar.tag {
//        case 1:
//            name = text
//        case 2:
//            secondName = text
//        case 3:
//            lastName = text
//        case 4:
//            birthday = text
//        case 5:
//            region = text
//        default:
//            break
//        }
//    }
//}
//
//extension PersonalDataViewController : RegionTextFieldDelegate {
//    func regionTextFieldDidSelect(region: String) {
//        
//    }
//    
//    func regionTextFieldWillSelect(with optionsVC: OptionsViewController) {
//        optionsVC.modalPresentationStyle = .overFullScreen
//        present(optionsVC, animated: false) {
//            optionsVC.animateShow()
//        }
//    }
//    
//    func dissmissKeyboard() {
//        view.endEditing(true)
//    }
//}

import UIKit

final class PersonalDataViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var userEmail: String
    
    private let lastNameTextField: CustomInputDataField = CustomInputDataField(with: "Фамилия")
    private let nameTextField: CustomInputDataField = CustomInputDataField(with: "Имя")
    
    // Кнопка «Нет отчества»
    private lazy var noSecondNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нет отчества", for: .normal)
        button.addTarget(self, action: #selector(didTapNoSecondNameButton), for: .touchUpInside)
        return button
    }()
    
    // Отчество
    private let secondNameTextField: CustomInputDataField = CustomInputDataField(with: "Отчество")
    
    // День рождения
    private let birthdayPicker: CustomDatePicker = CustomDatePicker(with: "День рождения")
    
    // Регион (пример со своим делегатом)
    private let regionTextField: RegionTextField = {
        let textField = RegionTextField(
            with: "Регион",
            regions: [
                "Москва",
                "Санкт-Петербург",
                "Йошкар-Ола",
                "Екатеринбург",
                "Петрозаводск",
                "Казань",
                "Новосибирск",
                "Нижний Новгород",
                "Омск",
                "Ростов-на-Дону",
                "Самара",
                "Саратов",
                "Ульяновск"
            ]
        )
        return textField
    }()
    
    // Пароль
    private let passwordTextField: CustomPasswordField = CustomPasswordField(with: "Придумайте пароль")
    
    // MARK: - Stored values
    
    private var lastName = ""
    private var name = ""
    private var secondName = ""
    private var birthday = ""
    private var region = ""
    private var password = ""
    
    // Флаг, указывающий, выбрал ли пользователь «Нет отчества»
    private var isNoSecondNameSelected = false
    
    // MARK: - Init
    
    init(email: String) {
        self.userEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Личные данные"
        
        setupScrollView()
        configureUI()
        
        // Присвоение тэгов для определения, какое поле редактируется
        nameTextField.tag = 1
        secondNameTextField.tag = 2
        lastNameTextField.tag = 3
        birthdayPicker.tag = 4
        regionTextField.tag = 5
        
        regionTextField.regionDelegate = self
        
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(firstResponderChanged), name: UIResponder.keyboardDidShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(firstResponderChanged), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func firstResponderChanged(notification: Notification) {
            print("First responder changed!")
            view.endEditing(true)
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Отписываемся от уведомлений при уходе с экрана
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self)
        
        if self.isMovingFromParent {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: - Keyboard handling
    
//    @objc private func keyboardWillShow(_ notification: Notification) {
//        guard
//            let userInfo = notification.userInfo,
//            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
//        else {
//            return
//        }
//        
//        let bottomInset = keyboardFrame.height - view.safeAreaInsets.bottom
//        view.frame.origin.y = -bottomInset
//    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        // Фрейм клавиатуры в координатах всего экрана
        let keyboardFrame = keyboardFrameValue.cgRectValue
        
        // Допустим, у нас есть конкретный textField, который сейчас в фокусе
        // (или вы можете проверить все textField-ы, если нужно).
        guard let activeTextField = findActiveTextField(in: view) else { return }
        guard let window = activeTextField.window else {
            return
        }
        let frameInWindow = activeTextField.convert(view.bounds, to: window)
        let textField_y = frameInWindow.origin.y
        // Переводим фрейм textField-а в координаты окна (или основного view).
        let textFieldFrameInWindow = activeTextField.superview?.convert(activeTextField.frame, to: nil) ?? .zero
        
        // Проверяем пересечение
        if textFieldFrameInWindow.intersects(keyboardFrame) {
            print("Клавиатура перекрывает UITextField")
            // Здесь можно, например, сдвинуть контент или выполнить доп. действия
            let bottomInset = keyboardFrame.height
            view.frame.origin.y = -bottomInset + (view.frame.height - textField_y) - (activeTextField.inputAccessoryView?.frame.height ?? 0)
            print(activeTextField.inputAccessoryView?.frame.height ?? 0)
        } else {
            print("Клавиатура НЕ перекрывает UITextField")
        }
    }
    func findActiveTextField(in view: UIView) -> UITextField? {
        for subview in view.subviews {
            // Проверяем, является ли subview текстовым полем и активным
            if let textField = subview as? UITextField, textField.isFirstResponder {
                return textField
            }
            // Если не нашли, то рекурсивно продолжаем поиск во вложенных вью
            if let foundTextField = findActiveTextField(in: subview) {
                return foundTextField
            }
        }
        return nil
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        // Сбрасываем отступы
        view.frame.origin.y = 0
    }
    
    // MARK: - Configure UI
    
    private func setupScrollView() {
        // Добавляем UIScrollView и contentView, в котором будут лежать все поля
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            // Ширина contentView совпадает с шириной scrollView
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    private func configureUI() {
        // Добавляем поля по порядку в contentView
        
        // 1. Фамилия
        contentView.addSubview(lastNameTextField)
        lastNameTextField.pinTop(to: contentView.topAnchor, 16)
        lastNameTextField.pinLeft(to: contentView.leadingAnchor, 20)
        
        // 2. Имя
        contentView.addSubview(nameTextField)
        nameTextField.pinTop(to: lastNameTextField.bottomAnchor, 24)
        nameTextField.pinLeft(to: contentView.leadingAnchor, 20)
        
        // 3. День рождения
        contentView.addSubview(birthdayPicker)
        birthdayPicker.pinTop(to: nameTextField.bottomAnchor, 24)
        birthdayPicker.pinLeft(to: contentView.leadingAnchor, 20)
        
        // 4. Кнопка «Нет отчества»
        contentView.addSubview(noSecondNameButton)
        noSecondNameButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noSecondNameButton.topAnchor.constraint(equalTo: birthdayPicker.bottomAnchor, constant: 24),
            noSecondNameButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        // 5. Отчество (по умолчанию показывается)
        contentView.addSubview(secondNameTextField)
        secondNameTextField.pinTop(to: noSecondNameButton.bottomAnchor, 24)
        secondNameTextField.pinLeft(to: contentView.leadingAnchor, 20)
        
        // 6. Регион
        contentView.addSubview(regionTextField)
        regionTextField.pinTop(to: secondNameTextField.bottomAnchor, 24)
        regionTextField.pinLeft(to: contentView.leadingAnchor, 20)
        
        // 7. Придумайте пароль
        contentView.addSubview(passwordTextField)
        passwordTextField.pinTop(to: regionTextField.bottomAnchor, 24)
        passwordTextField.pinLeft(to: contentView.leadingAnchor, 20)
        // Нижний отступ, чтобы контент не прилипал к низу
        passwordTextField.pinBottom(to: contentView.bottomAnchor, 40)
    }
    
    // MARK: - Actions
    
    @objc private func didTapNoSecondNameButton() {
        isNoSecondNameSelected.toggle()
        // Скрываем или показываем поле
        secondNameTextField.isHidden = isNoSecondNameSelected
        
        // Можно менять и текст кнопки, если хочется
        // noSecondNameButton.setTitle(
        //    isNoSecondNameSelected ? "Вернуть отчество" : "Нет отчества",
        //    for: .normal
        // )
    }
}

// MARK: - CustomTextFieldDelegate

extension PersonalDataViewController: CustomTextFieldDelegate {
    func action(_ searchBar: CustomTextField, textDidChange text: String) {
        switch searchBar.tag {
        case 1:
            name = text
        case 2:
            secondName = text
        case 3:
            lastName = text
        case 4:
            birthday = text
        case 5:
            region = text
        default:
            break
        }
    }
}

// MARK: - RegionTextFieldDelegate

extension PersonalDataViewController: RegionTextFieldDelegate {
    func regionTextFieldDidSelect(region: String) {
        // Обработка выбора региона
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


