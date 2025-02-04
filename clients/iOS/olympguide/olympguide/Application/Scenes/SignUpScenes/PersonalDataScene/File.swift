//
//  File.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

//import UIKit
//
//final class PersonalDataViewController: UIViewController {
//    
//    // MARK: - Свойства
//    private var userEmail: String = ""
//    /// Флаг, показывающий, отображается ли поле «Отчество»
//    private var hasSecondName: Bool = true
//    
//    /// ScrollView для управления смещением при появлении клавиатуры
//    private let scrollView: UIScrollView = {
//        let sv = UIScrollView()
//        sv.translatesAutoresizingMaskIntoConstraints = false
//        sv.keyboardDismissMode = .interactive
//        return sv
//    }()
//    
//    /// Храним ссылку на привязку поля «Регион», чтобы её обновлять при смене состояния поля «Отчество»
//    private var regionTopConstraint: NSLayoutConstraint?
//    
//    // MARK: UI Элементы
//    
//    let lastNameTextField: CustomInputDataField = CustomInputDataField(with: "Фамилия")
//    let nameTextField: CustomInputDataField = CustomInputDataField(with: "Имя")
//    /// Сделали var, чтобы можно было удалять/добавлять поле при переключении
//    var secondNameTextField: CustomInputDataField = CustomInputDataField(with: "Отчество")
//    let birthdayPicker: CustomDatePicker = CustomDatePicker(with: "День рождения")
//    
//    /// Кнопка для переключения отображения поля «Отчество»
//    let toggleSecondNameButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Нет отчества", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
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
//    
//    let passwordTextField: CustomPasswordField = CustomPasswordField(with: "Придумайте пароль")
//    
//    // MARK: Свойства данных
//    var lastName = ""
//    var name = ""
//    var secondName = ""
//    var birthday = ""
//    var region = ""
//    var password = ""
//    var confirmPassword = ""
//    
//    
//    // MARK: - Инициализация
//    
//    init(email: String) {
//        super.init(nibName: nil, bundle: nil)
//        self.userEmail = email
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been реализован")
//    }
//    
//    
//    // MARK: - Жизненный цикл
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .white
//        title = "Личные данные"
//        
//        // Добавляем scrollView на основной view
//        setupScrollView()
//        // Компонуем элементы по порядку
//        configureUI()
//        // Настраиваем наблюдателей за клавиатурой
//        addKeyboardObservers()
//        
//        // Обработчик нажатия для переключения состояния поля «Отчество»
//        toggleSecondNameButton.addTarget(self, action: #selector(toggleSecondNameTapped), for: .touchUpInside)
//        
//        // Если ваши кастомные элементы основаны на UITextField, установите делегата,
//        // чтобы метод textFieldDidBeginEditing вызывался и происходила прокрутка.
//        lastNameTextField.delegate = self
//        nameTextField.delegate = self
//        secondNameTextField.delegate = self
//        passwordTextField.delegate = self
//        
//        // Присваиваем теги (при необходимости для делегата CustomTextFieldDelegate)
//        nameTextField.tag = 1
//        secondNameTextField.tag = 2
//        lastNameTextField.tag = 3
//        birthdayPicker.tag = 4
//        regionTextField.tag = 5
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        NotificationCenter.default.removeObserver(self)
//        
//        if self.isMovingFromParent {
//            navigationController?.popToRootViewController(animated: true)
//        }
//    }
//    
//    
//    // MARK: - Настройка UI
//    
//    private func setupScrollView() {
//        view.addSubview(scrollView)
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    private func configureUI() {
//        // 1. Фамилия
//        configureLastNameTextField()
//        // 2. Имя
//        configureNameTextField()
//        // 3. День рождения
//        configureBirthdayPicker()
//        // 4. Кнопка для переключения поля «Отчество»
//        configureToggleSecondNameButton()
//        // 5. Поле «Отчество» (если включено)
//        if hasSecondName {
//            configureSecondNameTextField()
//        }
//        // 6. Регион
//        configureRegionTextField()
//        // 7. Пароль
//        configurePasswordTextField()
//    }
//    
//    private func configureLastNameTextField() {
//        scrollView.addSubview(lastNameTextField)
//        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            lastNameTextField.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 16),
//            lastNameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
//        ])
//    }
//    
//    private func configureNameTextField() {
//        scrollView.addSubview(nameTextField)
//        nameTextField.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            nameTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 24),
//            nameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
//        ])
//    }
//    
//    private func configureBirthdayPicker() {
//        scrollView.addSubview(birthdayPicker)
//        birthdayPicker.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            birthdayPicker.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
//            birthdayPicker.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
//        ])
//    }
//    
//    private func configureToggleSecondNameButton() {
//        scrollView.addSubview(toggleSecondNameButton)
//        NSLayoutConstraint.activate([
//            toggleSecondNameButton.topAnchor.constraint(equalTo: birthdayPicker.bottomAnchor, constant: 24),
//            toggleSecondNameButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
//        ])
//    }
//    
//    private func configureSecondNameTextField() {
//        scrollView.addSubview(secondNameTextField)
//        secondNameTextField.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            secondNameTextField.topAnchor.constraint(equalTo: toggleSecondNameButton.bottomAnchor, constant: 24),
//            secondNameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
//        ])
//    }
//    
//    private func configureRegionTextField() {
//        scrollView.addSubview(regionTextField)
//        regionTextField.translatesAutoresizingMaskIntoConstraints = false
//        // Привязываем верхнюю границу regionTextField к нижней границе поля «Отчество» (если оно есть)
//        // или к кнопке toggleSecondNameButton, если поля «Отчество» нет.
//        if hasSecondName {
//            regionTopConstraint = regionTextField.topAnchor.constraint(equalTo: secondNameTextField.bottomAnchor, constant: 24)
//        } else {
//            regionTopConstraint = regionTextField.topAnchor.constraint(equalTo: toggleSecondNameButton.bottomAnchor, constant: 24)
//        }
//        regionTopConstraint?.isActive = true
//        
//        NSLayoutConstraint.activate([
//            regionTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
//        ])
//        
//        regionTextField.regionDelegate = self
//    }
//    
//    private func configurePasswordTextField() {
//        scrollView.addSubview(passwordTextField)
//        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            passwordTextField.topAnchor.constraint(equalTo: regionTextField.bottomAnchor, constant: 24),
//            passwordTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
//            passwordTextField.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20) // чтобы задать contentSize
//        ])
//    }
//    
//    
//    // MARK: - Переключение поля «Отчество»
//    
//    @objc private func toggleSecondNameTapped() {
//        if hasSecondName {
//            // Скрываем поле «Отчество»
//            hasSecondName = false
//            secondNameTextField.removeFromSuperview()
//            // Обновляем привязку regionTextField – теперь привязываем к кнопке
//            regionTopConstraint?.isActive = false
//            regionTopConstraint = regionTextField.topAnchor.constraint(equalTo: toggleSecondNameButton.bottomAnchor, constant: 24)
//            regionTopConstraint?.isActive = true
//            // Можно изменить заголовок кнопки, чтобы дать понять, что поле можно вернуть
//            toggleSecondNameButton.setTitle("Есть отчество", for: .normal)
//        } else {
//            // Возвращаем поле «Отчество»
//            hasSecondName = true
//            scrollView.addSubview(secondNameTextField)
//            secondNameTextField.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                secondNameTextField.topAnchor.constraint(equalTo: toggleSecondNameButton.bottomAnchor, constant: 24),
//                secondNameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20)
//            ])
//            // Обновляем привязку regionTextField – теперь привязываем к нижней границе поля «Отчество»
//            regionTopConstraint?.isActive = false
//            regionTopConstraint = regionTextField.topAnchor.constraint(equalTo: secondNameTextField.bottomAnchor, constant: 24)
//            regionTopConstraint?.isActive = true
//            // Возвращаем исходный заголовок кнопки
//            toggleSecondNameButton.setTitle("Нет отчества", for: .normal)
//        }
//        
//        UIView.animate(withDuration: 0.3) {
//            self.scrollView.layoutIfNeeded()
//        }
//    }
//    
//    
//    // MARK: - Работа с клавиатурой
//    
//    private func addKeyboardObservers() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(keyboardWillShow(notification:)),
//                                               name: UIResponder.keyboardWillShowNotification,
//                                               object: nil)
//        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(keyboardWillHide(notification:)),
//                                               name: UIResponder.keyboardWillHideNotification,
//                                               object: nil)
//    }
//    
//    @objc private func keyboardWillShow(notification: Notification) {
//        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//        let keyboardHeight = keyboardFrame.height
//        scrollView.contentInset.bottom = keyboardHeight
//        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
//    }
//    
//    @objc private func keyboardWillHide(notification: Notification) {
//        scrollView.contentInset.bottom = 0
//        scrollView.verticalScrollIndicatorInsets.bottom = 0
//    }
//}
//
//
//// MARK: - Делегаты для кастомных текстовых полей
//
//extension PersonalDataViewController: CustomTextFieldDelegate {
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
//extension PersonalDataViewController: RegionTextFieldDelegate {
//    func regionTextFieldDidSelect(region: String) {
//        // Обработка выбора региона
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
//
//
//// MARK: - Прокрутка активного текстового поля (UITextFieldDelegate)
//
//extension PersonalDataViewController: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        // Вычисляем область текстового поля относительно scrollView и прокручиваем, если оно перекрыто клавиатурой
//        let rect = textField.convert(textField.bounds, to: scrollView)
//        scrollView.scrollRectToVisible(rect, animated: true)
//    }
//}
