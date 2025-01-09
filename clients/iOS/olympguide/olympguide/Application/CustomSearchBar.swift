//
//  CustomSearchBar.swift
//  olympguide
//
//  Created by Tom Tim on 07.01.2025.
//

import UIKit

protocol CustomSearchBarDelegate: AnyObject {
    func customSearchBar(_ searchBar: CustomSearchBar, textDidChange text: String)
}

final class CustomSearchBar: UIView {
    
    weak var delegate: CustomSearchBarDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "MontserratAlternates-Regular", size: 15)
        label.textColor = UIColor(hex: "#4F4F4F")
        label.textAlignment = .left
        return label
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "MontserratAlternates-Regular", size: 14)
        tf.textColor = .black
        tf.alpha = 0  // изначально "спрятан" (прозрачный)
        tf.isHidden = true
        // Отключаем автокоррекцию и предиктивный ввод
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.autocapitalizationType = .none

        return tf
    }()
    
    private var isActive = false
    
    // MARK: - Init
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func addCloseButtonOnKeyboard() {
        // Создаём тулбар нужного размера
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Создаём гибкий пробел, чтобы кнопка «Закрыть» была справа
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Создаём кнопку «Закрыть»
        let closeButton = UIBarButtonItem(title: "Закрыть", style: .done, target: self, action: #selector(closeKeyboard))
        
        // Добавляем элементы на тулбар
        toolbar.items = [flexSpace, closeButton]
        
        // Назначаем тулбар в качестве inputAccessoryView для textField
        textField.inputAccessoryView = toolbar
    }
    
    @objc
    private func closeKeyboard() {
        // Скрываем клавиатуру
        textField.resignFirstResponder()
        didTapSearchBar()
    }
    
    private func commonInit() {
        backgroundColor = UIColor(hex: "#E7E7E7")
        layer.cornerRadius = 13
        
        addSubview(titleLabel)
        addSubview(textField)
        
        // Отслеживание изменений текста
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // Добавляем тулбар с кнопкой «Закрыть» для клавиатуры
        addCloseButtonOnKeyboard()
        
        // Жест нажатия для анимации перехода
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchBar))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Общие размеры: предположим, что высота = 48,
        // а ширину вы задаёте извне (или через констрейты).
        
        // Ставим titleLabel без учёта трансформа — например, ближе к левому краю.
        // (Можете центрировать по горизонтали, если нужно.)
        
        let padding: CGFloat = 10
        let labelSize = titleLabel.intrinsicContentSize
        
        // Логическая позиция (без трансформа), пусть будет по вертикальному центру
        // (или чуть выше). Выбираем любой вариант. Ниже — ближе к центру:
        let labelX = padding
        let labelY = (bounds.height - labelSize.height) / 2
        titleLabel.frame = CGRect(
            x: labelX,
            y: labelY,
            width: labelSize.width,
            height: labelSize.height
        )
        
        // Если активно — применяем визуальную трансформацию (уменьшение * 0.5 и сдвиг вверх)
        // Например, сместим на -6 по Y (можно увеличить, если нужно выше).
        if isActive {
            let scaledWidth = titleLabel.bounds.width * (1 - 0.5)
            let scaleTransform = CGAffineTransform(translationX: -scaledWidth / 2, y: -8).scaledBy(x: 0.5, y: 0.5)
            titleLabel.transform = scaleTransform
            
            // Показываем textField (делаем alpha = 1 в анимации ниже, но фрейм зададим здесь)
            // Т.к. метка по логическому фрейму осталась на labelY, то поставим textField ниже её «физического» bottom
            // — например, на label.frame.maxY + 8
            // Учтите, transform НЕ меняет frame, поэтому maxY = labelY + labelSize.height.
            let textFieldY = titleLabel.frame.maxY + 8
            textField.frame = CGRect(
                x: padding,
                y: textFieldY - 11,
                width: bounds.width - 2*padding,
                height: 24
            )
            
        } else {
            let labelX = padding
            let labelY = (bounds.height - labelSize.height) / 2
            titleLabel.transform = .identity  // сброс преобразований
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelSize.width, height: labelSize.height)
            
            textField.frame = .zero
            
            // Прячем textField
            textField.frame = .zero
        }
    }
    
    @objc
    private func didTapSearchBar() {
        // 1. Сначала меняем флаг
        

        // 2. Запускаем анимацию
        let isThereText = !(self.textField.text?.isEmpty ?? true)
        guard !isThereText else { return }
        isActive.toggle()
        if self.isActive {
            // При окончании анимации показываем клавиатуру
            self.textField.becomeFirstResponder()
        } else {
            // Если мы «сняли» состояние isActive, убираем клавиатуру
            self.textField.resignFirstResponder()
        }

        UIView.animate(withDuration: 0.3, animations: {
            // 3. Говорим, что нам нужно пересчитать layout
            self.setNeedsLayout()
            // 4. Просим немедленно применить новые фреймы
            self.layoutIfNeeded()
            
            // Дополнительно меняем цвет / альфу и т.д.
            if self.isActive {
                self.backgroundColor = .white
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.black.cgColor
                self.textField.alpha = 1
            } else {
                self.backgroundColor = UIColor(hex: "#E7E7E7")
                self.layer.borderWidth = 0
                self.layer.borderColor = UIColor.clear.cgColor
                self.textField.alpha = 0
            }
        }, completion: {_ in
            if self.isActive {
                self.textField.isHidden = false
            } else {
                self.textField.isHidden = true
            }
        })
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        // Сообщаем делегату об изменении текста
        delegate?.customSearchBar(self, textDidChange: textField.text ?? "")
    }
}
