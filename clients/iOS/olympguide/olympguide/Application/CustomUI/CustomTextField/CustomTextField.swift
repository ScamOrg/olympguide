//
//  CustomTextField.swift
//  olympguide
//
//  Created by Tom Tim on 30.01.2025.
//

import UIKit

// MARK: - Constants

private enum Constants {
    
    enum Fonts {
        static let titleFont = UIFont(name: "MontserratAlternates-Regular", size: 15)!
        static let textFieldFont = UIFont(name: "MontserratAlternates-Regular", size: 14)!
    }
    
    enum Colors {
        static let titleTextColor = UIColor(hex: "#4F4F4F")
        static let backgroundColor = UIColor(hex: "#E7E7E7")
        static let activeBackgroundColor = UIColor.white
        static let borderColor = UIColor.black
    }
    
    enum Dimensions {
        static let cornerRadius: CGFloat = 13
        static let padding: CGFloat = 10
        static let searchBarHeight: CGFloat = 48
        static let textFieldHeight: CGFloat = 24
        static let titleScale: CGFloat = 0.5
        static let titleTranslateY: CGFloat = -8
    }
    
    enum Strings {
        static let closeButtonTitle = "Закрыть"
        static let deleteButtonImage = "xmark.circle.fill"
    }
}

// MARK: - Protocol
protocol CustomTextFieldDelegate: AnyObject {
    func action(_ searchBar: CustomTextField, textDidChange text: String)
}

// MARK: - CustomTextField
class CustomTextField: UIView {
    
    // MARK: - Properties
    weak var delegate: (any CustomTextFieldDelegate)?
    
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let actionButton = UIButton()
    var isActive = false
    
    // MARK: - Initializers
    init(with title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        setupView()
        configureTitleLabel()
        configureTextField()
        configureDeleteButton()
        addCloseButtonOnKeyboard()
        addTapGesture()
    }
    
    private func setupView() {
        backgroundColor = Constants.Colors.backgroundColor
        layer.cornerRadius = Constants.Dimensions.cornerRadius
    }
    
    private func configureTitleLabel() {
        titleLabel.font = Constants.Fonts.titleFont
        titleLabel.textColor = Constants.Colors.titleTextColor
        titleLabel.textAlignment = .left
        addSubview(titleLabel)
    }
    
    private func configureTextField() {
        textField.font = Constants.Fonts.textFieldFont
        textField.textColor = .black
        textField.alpha = 0
        textField.isHidden = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addSubview(textField)
    }
    
    private func configureDeleteButton() {
        actionButton.tintColor = .black
        actionButton.contentHorizontalAlignment = .fill
        actionButton.contentVerticalAlignment = .fill
        actionButton.imageView?.contentMode = .scaleAspectFit
        actionButton.setImage(UIImage(systemName: Constants.Strings.deleteButtonImage), for: .normal)
        actionButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        actionButton.isHidden = true
        addSubview(actionButton)
    }
    
    private func addCloseButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let closeButton = UIBarButtonItem(title: Constants.Strings.closeButtonTitle,
                                          style: .done,
                                          target: self,
                                          action: #selector(closeInputView))
        toolbar.items = [flexSpace, closeButton]
        textField.inputAccessoryView = toolbar
    }
    
    private func addTapGesture() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchBar))
//        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitleLabel()
        layoutTextFieldAndDeleteButton()
    }
    
    private func layoutTitleLabel() {
        titleLabel.transform = .identity
        let padding = Constants.Dimensions.padding
        let labelSize = titleLabel.intrinsicContentSize
        let labelX = padding
        let labelY = (bounds.height - labelSize.height) / 2
        titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelSize.width, height: labelSize.height)
        
        if isActive {
            let scaledWidth = titleLabel.bounds.width * (1 - Constants.Dimensions.titleScale)
            let scaleTransform = CGAffineTransform(translationX: -scaledWidth / 2, y: Constants.Dimensions.titleTranslateY)
                .scaledBy(x: Constants.Dimensions.titleScale, y: Constants.Dimensions.titleScale)
            titleLabel.transform = scaleTransform
        }
    }
    
    private func layoutTextFieldAndDeleteButton() {
        let padding = Constants.Dimensions.padding
        
        if isActive {
            let textFieldY = titleLabel.frame.maxY - Constants.Dimensions.titleTranslateY
            textField.frame = CGRect(
                x: padding,
                y: textFieldY + (Constants.Dimensions.titleTranslateY - 3),
                width: bounds.width - 2 * padding - 25,
                height: Constants.Dimensions.textFieldHeight
            )
            
            actionButton.frame = CGRect(
                x: textField.frame.maxX + 1,
                y: textField.frame.minY,
                width: Constants.Dimensions.textFieldHeight,
                height: Constants.Dimensions.textFieldHeight
            )
        } else {
            textField.frame = .zero
            actionButton.frame = .zero
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: Constants.Dimensions.searchBarHeight)
    }
    
    override var frame: CGRect {
        get { return super.frame }
        set {
            super.frame = CGRect(origin: newValue.origin, size: intrinsicContentSize)
        }
    }
    
    // MARK: - Actions
    @objc func didTapSearchBar() {
        let hasText = isEmty()
        guard !hasText else { return }
        
        isActive.toggle()
        if isActive {
            textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        updateAppereance()
    }
    
    func isEmty() -> Bool {
        !(textField.text?.isEmpty ?? true)
    }
    
    func updateAppereance() {
        UIView.animate(withDuration: 0.3, animations: {
            self.setNeedsLayout()
            self.layoutIfNeeded()
            self.backgroundColor = self.isActive ? Constants.Colors.activeBackgroundColor : Constants.Colors.backgroundColor
            self.layer.borderWidth = self.isActive ? 1 : 0
            self.layer.borderColor = self.isActive ? Constants.Colors.borderColor.cgColor : UIColor.clear.cgColor
            self.textField.alpha = self.isActive ? 1 : 0
        }, completion: { _ in
            self.textField.isHidden = !self.isActive
        })
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let hasText = !(textField.text?.isEmpty ?? true)
        actionButton.isHidden = !hasText
        delegate?.action(self, textDidChange: textField.text ?? "")
        
        if !hasText && !textField.isFirstResponder {
            didTapSearchBar()
        }
    }
    
    @objc private func didTapDeleteButton() {
        textField.text = ""
        textFieldDidChange(textField)
    }
    
    @objc func closeInputView() {
        textField.resignFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let touch = touches.first else { return }
        guard !textField.isFirstResponder else { return }
        
        let point = touch.location(in: self)
        
        let buttonFrame = actionButton.convert(actionButton.bounds, to: self)
        
        if !buttonFrame.contains(point) {
            didTapSearchBar()
        }
    }
}

// MARK: - UITextFieldDelegate

extension CustomTextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        didTapSearchBar()
    }
    
    func setTextFieldType(_ keyboardType: UIKeyboardType = .default, _ textContentType: UITextContentType) {
        textField.keyboardType = keyboardType
        textField.textContentType = textContentType
    }
    
    func setTextFieldTarget(
        _ target: Any?,
        _ action: Selector =  #selector(textFieldDidChange),
        for event: UIControl.Event = .editingChanged
    ) {
        textField.removeTarget(nil, action: nil, for: .allEvents)
        textField.addTarget(target, action: action, for: event)
    }
    
    func setTextFieldInputView(_ inputView: UIView?) {
        textField.inputView = inputView
    }
    
    func setTextFieldText(_ text: String?) {
        textField.text = text
    }
    
    func setSecureTextEntry(_ isSecureTextEntry: Bool) {
        textField.isSecureTextEntry = isSecureTextEntry
    }
    
    func textFieldSendAction(for event: UIControl.Event) {
        textField.sendActions(for: event)
    }
    
    func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) {
        textField.isUserInteractionEnabled = isUserInteractionEnabled
    }
}

extension CustomTextField {
    func setActionButtonImage(_ image: UIImage?) {
        actionButton.setImage(image, for: .normal)
    }
    
    func setActionButtonTarget(
        _ target: Any?,
        _ action: Selector =  #selector(didTapDeleteButton),
        for event: UIControl.Event = .editingChanged
    ) {
        actionButton.removeTarget(nil, action: nil, for: .allEvents)
        actionButton.addTarget(target, action: action, for: event)
    }
    
    func addActionButtonTarget(
        _ target: Any?,
        _ action: Selector =  #selector(didTapDeleteButton),
        for event: UIControl.Event = .editingChanged
    ) {
        actionButton.addTarget(target, action: action, for: event)
    }
}
