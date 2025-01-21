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


class CodeInputViewController: UIViewController, UITextFieldDelegate {

    // Массив, чтобы удобно управлять всеми полями
    private var codeTextFields: [UITextField] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Создаём UIStackView, чтобы расположить поля в линию
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем stackView на экран
        view.addSubview(stackView)

        // Располагаем его по центру (пример со стандартными ограничениями)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.widthAnchor.constraint(equalToConstant: 4 * 60) // Ширина под 4 поля по 60pt
        ])
        
        // Создаём 4 текстовых поля
        for _ in 0..<4 {
            let textField = UITextField()
            textField.delegate = self
            textField.backgroundColor = .white
            textField.borderStyle = .roundedRect
            textField.layer.cornerRadius = 8
            textField.textAlignment = .center
            textField.font = UIFont.systemFont(ofSize: 24)
            textField.keyboardType = .numberPad
            
            // Добавляем поле в стек и в массив
            stackView.addArrangedSubview(textField)
            codeTextFields.append(textField)
        }
        
        // Фокус ставим на первое поле
        codeTextFields.first?.becomeFirstResponder()
    }

    // MARK: - UITextFieldDelegate
    
    // Основная логика: ограничение в 1 символ + переход фокуса
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // Текущий текст в поле (до изменений)
        let currentText = textField.text ?? ""

        // Если пользователь нажал Backspace (string пустая и удаляется 1 символ)
        if string.isEmpty, range.length == 1 {
            textField.text = ""
            
            // Переходим к предыдущему полю, если оно есть
            if let index = codeTextFields.firstIndex(of: textField), index > 0 {
                codeTextFields[index - 1].becomeFirstResponder()
            }
            return false
        }
        
        // Если пользователь пытается ввести несколько символов сразу (вставка текста) — не даём
        guard string.count == 1 else {
            return false
        }
        
        // Проверяем, что введён именно символ цифры
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
            // Записываем новый символ
            textField.text = string
            
            // Переходим к следующему полю, если оно есть
            if let index = codeTextFields.firstIndex(of: textField), index < codeTextFields.count - 1 {
                codeTextFields[index + 1].becomeFirstResponder()
            } else {
                // Если это было последнее поле, снимаем фокус
                textField.resignFirstResponder()
                // Здесь можно обрабатывать ввод полного кода
            }
        }
        
        // Возвращаем false, чтобы поле не пыталось дополнительно обрабатывать ввод
        return false
    }
}
