//
//  CustomSearchBar.swift
//  olympguide
//
//  Created by Tom Tim on 07.01.2025.
//

import UIKit

// MARK: - Constants
fileprivate enum Constants {
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
    }
}

protocol CustomSearchBarDelegate: AnyObject {
    func customSearchBar(_ searchBar: CustomSearchBar, textDidChange text: String)
}

final class CustomSearchBar: UIView {
    
    weak var delegate: CustomSearchBarDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Constants.Fonts.titleFont
        label.textColor = Constants.Colors.titleTextColor
        label.textAlignment = .left
        return label
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.font = Constants.Fonts.textFieldFont
        tf.textColor = .black
        tf.alpha = 0
        tf.isHidden = true
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private var isActive = false
    
    // MARK: - Lifecycle
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Private funcs
    private func addCloseButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let closeButton = UIBarButtonItem(title: Constants.Strings.closeButtonTitle,
                                          style: .done,
                                          target: self,
                                          action: #selector(closeKeyboard))
        toolbar.items = [flexSpace, closeButton]
        textField.inputAccessoryView = toolbar
    }
    
    @objc
    private func closeKeyboard() {
        textField.resignFirstResponder()
        didTapSearchBar()
    }
    
    private func commonInit() {
        backgroundColor = Constants.Colors.backgroundColor
        layer.cornerRadius = Constants.Dimensions.cornerRadius
        
        addSubview(titleLabel)
        addSubview(textField)
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        addCloseButtonOnKeyboard()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchBar))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = Constants.Dimensions.padding
        let labelSize = titleLabel.intrinsicContentSize
        
        let labelX = padding
        let labelY = (bounds.height - labelSize.height) / 2
        titleLabel.frame = CGRect(
            x: labelX,
            y: labelY,
            width: labelSize.width,
            height: labelSize.height
        )
        

        if isActive {
            let scaledWidth = titleLabel.bounds.width * (1 - Constants.Dimensions.titleScale)
            let scaleTransform = CGAffineTransform(translationX: -scaledWidth / 2, y: Constants.Dimensions.titleTranslateY)
                .scaledBy(x: Constants.Dimensions.titleScale, y: Constants.Dimensions.titleScale)
            titleLabel.transform = scaleTransform
    
            let textFieldY = titleLabel.frame.maxY - Constants.Dimensions.titleTranslateY
            textField.frame = CGRect(
                x: padding,
                y: textFieldY + (Constants.Dimensions.titleTranslateY - 3),
                width: bounds.width - 2 * padding,
                height: 24
            )
            
        } else {
            let labelX = padding
            let labelY = (bounds.height - labelSize.height) / 2
            titleLabel.transform = .identity
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelSize.width, height: labelSize.height)
            
            textField.frame = .zero
        }
    }
    
    // MARK: - Objc funcs
    @objc
    private func didTapSearchBar() {
        let isThereText = !(self.textField.text?.isEmpty ?? true)
        guard !isThereText else { return }
        
        isActive.toggle()
        if self.isActive {
            self.textField.becomeFirstResponder()
        } else {
            self.textField.resignFirstResponder()
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.setNeedsLayout()
            self.layoutIfNeeded()
            if self.isActive {
                self.backgroundColor = Constants.Colors.activeBackgroundColor
                self.layer.borderWidth = 1
                self.layer.borderColor = Constants.Colors.borderColor.cgColor
                self.textField.alpha = 1
            } else {
                self.backgroundColor = Constants.Colors.backgroundColor
                self.layer.borderWidth = 0
                self.layer.borderColor = UIColor.clear.cgColor
                self.textField.alpha = 0
            }
        }, completion: { _ in
            if self.isActive {
                self.textField.isHidden = false
            } else {
                self.textField.isHidden = true
            }
        })
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        delegate?.customSearchBar(self, textDidChange: textField.text ?? "")
    }
}
