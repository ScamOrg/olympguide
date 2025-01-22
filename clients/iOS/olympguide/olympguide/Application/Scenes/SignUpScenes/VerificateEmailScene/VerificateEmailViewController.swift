//
//  VerificateEmailViewController.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import UIKit

final class VerificateEmailViewController: UIViewController {
    private var userEmail: String = ""
    
    init(email: String) {
        super.init(nibName: nil, bundle: nil)
        self.userEmail = email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Подтвердите почту"
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        title = "Подтвердите почту"
        
        configureDescriptioLabel()
    }
    
    private func configureDescriptioLabel() {
        let descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .left
        descriptionLabel.text = "Введите четырёхзначный код присланный на\n\(userEmail)"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: "MontserratAlternates-Medium", size: 12) ?? .systemFont(ofSize: 12)
        
        view.addSubview(descriptionLabel)
        descriptionLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 13)
        descriptionLabel.pinLeft(to: view.leadingAnchor, 20)
        descriptionLabel.pinRight(to: view.trailingAnchor, 20)
    }
}


class CodeInputViewController: UIViewController {
    let verifyCodeField = VerifyCodeField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // Создаём кастомный элемент для ввода кода (на 4 цифры)
        verifyCodeField.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем его на вью контроллера
        view.addSubview(verifyCodeField)
        
        // Задаём размер и позицию (центрируем вью на экране)
        NSLayoutConstraint.activate([
            verifyCodeField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verifyCodeField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
        //        verifyCodeField.setHeight(50)
        //        verifyCodeField.setWidth(230)
        
        // Слушаем событие "все цифры введены"
        verifyCodeField.onComplete = { code in
            print("Пользователь ввёл код: \(code)")
            // Далее, например, отправляем код на сервер
        }
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        // Теперь даём фокус, когда экран уже отобразился
    //        verifyCodeField.setFocusToFirstField()
    //    }
}


/// Кастомный UI-элемент ввода кода из цифр
//final class VerifyCodeField: UIStackView {
//
//    override var intrinsicContentSize: CGSize {
//        return CGSize(
//            width: 230,
//            height: 50
//        )
//    }
//
//    override var frame: CGRect {
//        get { return super.frame }
//        set {
//            super.frame = CGRect(
//                origin: newValue.origin,
//                size: self.intrinsicContentSize
//            )
//        }
//    }
//
//    /// Колбэк, который вызывается при вводе всех цифр (4 в примере)
//    var onComplete: ((String) -> Void)?
//
//    /// Массив текстовых полей
//    private var codeTextFields: [UITextField] = []
//
//    /// Количество цифр, по умолчанию 4
//    private let digitCount: Int
//
//    // MARK: - Инициализаторы
//
//    /// Конструктор из кода (с возможностью задать кол-во цифр)
//    init() {
//        self.digitCount = 4
//        super.init(frame: .zero)
//        setupView()
//    }
//
//    /// Конструктор для использования из сториборда / xib
//    required init(coder: NSCoder) {
//        // Можете жёстко зашить 4 или сделать динамическую константу
//        self.digitCount = 4
//        super.init(coder: coder)
//        setupView()
//    }
//
//    // MARK: - Настройка UIStackView и полей
//
//    private func setupView() {
//        // Настраиваем сам StackView
//        axis = .horizontal
//        distribution = .fillEqually
//        alignment = .fill
//        spacing = 8
//
//        // Создаём необходимое количество полей ввода
//        for _ in 0..<digitCount {
//            let textField = CustomTextField()
//            textField.delegate = self
//            textField.backgroundColor = .white
//            textField.borderStyle = .roundedRect
//            textField.layer.cornerRadius = 8
//            textField.textAlignment = .center
//            textField.font = UIFont.systemFont(ofSize: 24)
//            textField.keyboardType = .numberPad
//            textField.layer.borderWidth = 1
//            // Добавляем текстовое поле в StackView3
//            textField.newDelegate = self
//            addArrangedSubview(textField)
//            codeTextFields.append(textField)
//        }
//    }
//
//    func setFocusToFirstField() {
//        codeTextFields.first?.becomeFirstResponder()
//    }
//
//    /// Собираем введённые цифры в единую строку
//    private func getCurrentCode() -> String {
//        codeTextFields.map { $0.text ?? "" }.joined()
//    }
//}
//
//// MARK: - UITextFieldDelegate
//extension VerifyCodeField: UITextFieldDelegate {
//
//    /// Метод делегата, где обрабатываем ввод и переключение фокуса
//    func textField(_ textField: UITextField,
//                   shouldChangeCharactersIn range: NSRange,
//                   replacementString string: String) -> Bool {
//        if string.isEmpty, range.length == 1 {
//            textField.text = ""
//            UIView.animate(withDuration: 0.2) {
//                textField.layer.borderWidth = 1
//            }
//            if let index = codeTextFields.firstIndex(of: textField), index > 0 {
//                codeTextFields[index - 1].becomeFirstResponder()
//            }
//            return false
//        }
//
//        // CASE 2: Вводим сразу несколько символов (вставка) → запрещаем
//        guard string.count == 1 else {
//            return false
//        }
//
//        // CASE 3: Проверяем, что введена именно цифра
//        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
//            return false
//        }
//
//        // Записываем символ (замещаем текущее содержимое)
//        textField.text = string
//
//        // Переходим к следующему полю или завершаем ввод, если это было последнее
//        if let index = codeTextFields.firstIndex(of: textField) {
//            UIView.animate(withDuration: 0.2) {
//                textField.layer.borderWidth = 2
//            }
//            if index < codeTextFields.count - 1 {
//                codeTextFields[index + 1].becomeFirstResponder()
//            } else {
//                // Все поля заполнены
//                textField.resignFirstResponder()
//
//                // Вызываем колбэк onComplete
//                let fullCode = getCurrentCode()
//                onComplete?(fullCode)
//            }
//        }
//
//        // Возвращаем false, чтобы не оставлять «следы» от старого текста
//        return false
//    }
//}
//
//extension VerifyCodeField: CustomTextFieldDelegate {
//    func delete(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.2) {
//            textField.layer.borderWidth = 1
//        }
//        if let index = codeTextFields.firstIndex(of: textField), index > 0 {
//            codeTextFields[index - 1].text = ""
//            codeTextFields[index - 1].becomeFirstResponder()
//        }
//    }
//}
//
//protocol CustomTextFieldDelegate: AnyObject {
//    func delete(_ textField: UITextField)
//}
//class CustomTextField: UITextField {
//    weak var newDelegate: CustomTextFieldDelegate?
//
//    override func deleteBackward() {
//        super.deleteBackward()
//        newDelegate?.delete(self)
//        print("Backspace was pressed")
//    }
//}
//
