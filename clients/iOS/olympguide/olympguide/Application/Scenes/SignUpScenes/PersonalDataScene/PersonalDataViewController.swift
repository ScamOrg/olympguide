//
//  PersonalDataScene.swift
//  olympguide
//
//  Created by Tom Tim on 22.01.2025.
//

import UIKit

final class PersonalDataViewController: UIViewController {
    
    // MARK: - Свойства
    private var userEmail: String = ""
    /// Флаг, показывающий, отображается ли поле «Отчество»
    private var hasSecondName: Bool = true
    
    /// ScrollView для управления смещением при появлении клавиатуры
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.keyboardDismissMode = .interactive
        return sv
    }()
    
    // Эти две констрейнты будем переустанавливать при скрытии/показе отчества
    private var toggleButtonTopConstraint: NSLayoutConstraint?
    private var birthdayTopConstraint: NSLayoutConstraint?
    
    // MARK: UI Элементы
    
    let lastNameTextField: CustomInputDataField = CustomInputDataField(with: "Фамилия")
    let nameTextField: CustomInputDataField = CustomInputDataField(with: "Имя")
    
    /// Сделали var, чтобы можно было удалять/добавлять поле при переключении
    var secondNameTextField: CustomInputDataField = CustomInputDataField(with: "Отчество")
    
    let toggleSecondNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нет отчества", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let birthdayPicker: CustomDatePicker = CustomDatePicker(with: "День рождения")
    
    let regionTextField: RegionTextField = RegionTextField(
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
    
    let passwordTextField: CustomPasswordField = CustomPasswordField(with: "Придумайте пароль")
    
    // MARK: Свойства данных
    var lastName = ""
    var name = ""
    var secondName = ""
    var birthday = ""
    var region = ""
    var password = ""
    var confirmPassword = ""
    
    
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
        
        // Добавляем scrollView на основной view
        setupScrollView()
        // Компонуем элементы по порядку
        configureUI()
        
        // Обработчик нажатия для переключения состояния поля «Отчество»
        toggleSecondNameButton.addTarget(self, action: #selector(toggleSecondNameTapped), for: .touchUpInside)
        
        // Установим делегаты для отслеживания ввода
        lastNameTextField.delegate = self
        nameTextField.delegate = self
        secondNameTextField.delegate = self
        passwordTextField.delegate = self
        
        // Присваиваем теги (опционально, если нужно где-то в логике)
        nameTextField.tag = 1
        secondNameTextField.tag = 2
        lastNameTextField.tag = 3
        birthdayPicker.tag = 4
        regionTextField.tag = 5
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
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
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
    }
    
    private func configureLastNameTextField() {
        scrollView.addSubview(lastNameTextField)
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lastNameTextField.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 16),
            lastNameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
        ])
    }
    
    private func configureNameTextField() {
        scrollView.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
        ])
    }
    
    private func configureSecondNameTextField() {
        scrollView.addSubview(secondNameTextField)
        secondNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Отчество идёт сразу под «Имя»
        NSLayoutConstraint.activate([
            secondNameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            secondNameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
        ])
    }
    
    private func configureToggleSecondNameButton() {
        scrollView.addSubview(toggleSecondNameButton)
        // При добавлении кнопки смотрим, есть ли поле «Отчество»
        if hasSecondName {
            // Если отчество есть, то кнопка под ним
            toggleButtonTopConstraint = toggleSecondNameButton.topAnchor.constraint(
                equalTo: secondNameTextField.bottomAnchor,
                constant: 24
            )
        } else {
            // Если отчества нет, кнопка располагается под «Имя»
            toggleButtonTopConstraint = toggleSecondNameButton.topAnchor.constraint(
                equalTo: nameTextField.bottomAnchor,
                constant: 24
            )
        }
        toggleButtonTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            toggleSecondNameButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
        ])
    }
    
    private func configureBirthdayPicker() {
        scrollView.addSubview(birthdayPicker)
        birthdayPicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Пикер даты располагаем под кнопкой
        birthdayTopConstraint = birthdayPicker.topAnchor.constraint(equalTo: toggleSecondNameButton.bottomAnchor, constant: 24)
        birthdayTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            birthdayPicker.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
        ])
    }
    
    private func configureRegionTextField() {
        scrollView.addSubview(regionTextField)
        regionTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Топ у regionTextField привязываем к нижней границе пикера дня рождения
        NSLayoutConstraint.activate([
            regionTextField.topAnchor.constraint(equalTo: birthdayPicker.bottomAnchor, constant: 24),
            regionTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
        ])
        
        regionTextField.regionDelegate = self
    }
    
    private func configurePasswordTextField() {
        scrollView.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: regionTextField.bottomAnchor, constant: 24),
            passwordTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            passwordTextField.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }
    
    
    // MARK: - Переключение поля «Отчество»
    
    @objc private func toggleSecondNameTapped() {
        if hasSecondName {
            // Скрываем поле «Отчество»
            hasSecondName = false
            secondNameTextField.removeFromSuperview()
            
            // Обновляем привязку кнопки (теперь к нижней границе поля «Имя»)
            toggleButtonTopConstraint?.isActive = false
            toggleButtonTopConstraint = toggleSecondNameButton.topAnchor.constraint(
                equalTo: nameTextField.bottomAnchor,
                constant: 24
            )
            toggleButtonTopConstraint?.isActive = true
            
            toggleSecondNameButton.setTitle("Есть отчество", for: .normal)
        } else {
            // Показываем поле «Отчество»
            hasSecondName = true
            // Добавляем на скролл снова
            scrollView.addSubview(secondNameTextField)
            secondNameTextField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                secondNameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
                secondNameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
            ])
            
            // Обновляем привязку кнопки (теперь к нижней границе поля «Отчество»)
            toggleButtonTopConstraint?.isActive = false
            toggleButtonTopConstraint = toggleSecondNameButton.topAnchor.constraint(
                equalTo: secondNameTextField.bottomAnchor,
                constant: 24
            )
            toggleButtonTopConstraint?.isActive = true
            
            toggleSecondNameButton.setTitle("Нет отчества", for: .normal)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.scrollView.layoutIfNeeded()
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
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        // Возвращаем в исходное положение
        self.view.frame.origin.y = 0
    }
}


// MARK: - Делегаты для кастомных текстовых полей

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

extension PersonalDataViewController: RegionTextFieldDelegate {
    func regionTextFieldDidSelect(region: String) {
        // Обработка выбора региона
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
