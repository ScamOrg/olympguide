//
//  VerifyCodeField.swift
//  olympguide
//
//  Created by Tom Tim on 22.01.2025.
//

import UIKit

/// Полностью кастомный "инпут" для ввода кода.
final class VerifyCodeField: UIView, UIKeyInput {
    private let hiddenTextField = CustomTextFeield()
    
    /// Колбэк, который вызывается, когда пользователь ввёл все цифры
    var onComplete: ((String) -> Void)?
    
    /// Общее количество цифр в коде (можно сделать настраиваемым)
    private let digitCount: Int = 4
    
    /// Текущий массив введённых символов (цифр)
    private var digits: [Character] = []
    
    /// Массив для отображения цифр (4 UILabel)
    private var digitLabels: [UILabel] = []
    
    // MARK: - Инициализаторы
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: 230,
            height: 50
        )
    }
    
    override var frame: CGRect {
        get { return super.frame }
        set {
            super.frame = CGRect(
                origin: newValue.origin,
                size: self.intrinsicContentSize
            )
        }
    }
    // MARK: - Настройка внешнего вида
    
    private func setupView() {
        hiddenTextField.keyboardType = .numberPad
        hiddenTextField.isHidden = true
        hiddenTextField.newDelegate = self
        hiddenTextField.delegate = self
        addSubview(hiddenTextField)
        
        // Добавление жеста для обработки нажатия
        
        // Создаём UIStackView для удобного расположения "ячеек" (UILabel)
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        
        addSubview(stackView)
        // Отключаем autoresizing маски и проставляем констрейнты
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        // Создаём нужное количество "полей" (UILabel)
        for _ in 0..<digitCount {
            let label = UILabel()
            label.backgroundColor = .white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 24)
            label.layer.cornerRadius = 8
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.black.cgColor
            label.clipsToBounds = true
            
            stackView.addArrangedSubview(label)
            digitLabels.append(label)
        }
        
        // Чтобы нажатие на эту область вызывало клавиатуру,
        // сделаем view "тапабельным"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        // По тапу становится firstResponder
//                becomeFirstResponder()
        hiddenTextField.becomeFirstResponder()
    }
    
    func setFocusToFirstField() {
        handleTap()
    }
    
    // MARK: - Обновление UI (отображение цифр)
    private func updateLabels() {
        for i in 0..<digitCount {
            if i < digits.count {
                // Если символ уже введён - показываем
                digitLabels[i].text = String(digits[i])
                UIView.animate(withDuration: 0.2) {[weak self] in
                    self?.digitLabels[i].layer.borderWidth = 2
                }
            } else {
                // Если символа ещё нет - пустая строка
                digitLabels[i].text = ""
                UIView.animate(withDuration: 0.2) {[weak self] in
                    self?.digitLabels[i].layer.borderWidth = 1
                }
            }
        }
    }
    
    // MARK: - UIKeyInput
    /// Говорит, есть ли у нас текст (используется для backspace и т.д.)
    var hasText: Bool {
        !digits.isEmpty
    }
    
    // Вставка нового текста (символа)
    func insertText(_ text: String) {
        // Проверяем, что это ровно 1 символ и он - цифра
        guard text.count == 1,
              let char = text.first,
              char.isNumber
        else {
            return
        }
        
        // Если уже достигнут лимит — не добавляем
        guard digits.count < digitCount else {
            return
        }
        
        // Добавляем символ в массив
        digits.append(char)
        
        // Обновляем отображение
        updateLabels()
        
        // Если достигли нужного количества символов, вызываем колбэк
        if digits.count == digitCount {
            onComplete?(String(digits))
            // Здесь можно убрать фокус
//            resignFirstResponder()
            hiddenTextField.resignFirstResponder()
        }
    }
    
    // Удаление последнего символа (Backspace)
    func deleteBackward() {
        guard !digits.isEmpty else { return }
        
        // Удаляем из массива последнюю цифру
        digits.removeLast()
        // Обновляем
        updateLabels()
    }
    
    // MARK: - First Responder
    /// Разрешаем объекту становиться firstResponder,
    /// чтобы он мог открывать клавиатуру.
//    override var canBecomeFirstResponder: Bool {
//        true
//    }
    
    //    // MARK: - Переопределяем тип клавиатуры (числовая)
    private var keyboardType: UIKeyboardType {
        .numberPad
    }
}

extension VerifyCodeField : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        insertText(string)
        return false
    }
}


class CustomTextFeield: UITextField {
    var newDelegate: UIKeyInput?
    
    override var hasText: Bool {
        newDelegate?.hasText ?? false
    }
    
    override func deleteBackward() {
        newDelegate?.deleteBackward()
    }
}
