//
//  TabButton.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

class TabButton: UIView {
    
    // MARK: - Constants
    private enum Constants {
        // Sizes
        static let buttonWidth: CGFloat = 64
        static let buttonHeight: CGFloat = 34
        static let iconPointSize: CGFloat = 20
        static let titleFontSize: CGFloat = 10
        
        // Colors
        static let defaultTintColor = UIColor(hex: "#4F4F4F") ?? .gray
        static let filledTintColor = UIColor.black
        
        static let fillSuffix = ".fill"
    }
    
    // MARK: - Properties
    private var button: UIButton = UIButton()
    private var titleView: UILabel = UILabel()
    
    // MARK: - Initialization
    init(title: String, icon: String, tag: Int, action: UIAction, tintColor: UIColor = Constants.defaultTintColor) {
        super.init(frame: .zero)
        
        button = UIButton(primaryAction: action)
        button.tag = tag
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: Constants.iconPointSize, weight: .regular)
        var iconImage = UIImage(systemName: icon, withConfiguration: symbolConfig)
        
        if tintColor == Constants.filledTintColor {
            iconImage = UIImage(systemName: icon + Constants.fillSuffix, withConfiguration: symbolConfig)
        }
        
        iconImage?.accessibilityIdentifier = tintColor == Constants.filledTintColor ? icon + Constants.fillSuffix : icon
        
        button.setImage(iconImage, for: .normal)
        button.tintColor = tintColor
        button.setWidth(Constants.buttonWidth)
        button.setHeight(Constants.buttonHeight)
        
        titleView.text = title
        titleView.font = .systemFont(ofSize: Constants.titleFontSize)
        titleView.textColor = tintColor
        
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        addSubview(button)
        addSubview(titleView)
        button.pinCenterX(to: self)
        button.pinTop(to: self.topAnchor)
        titleView.pinCenterX(to: self)
        titleView.pinTop(to: button.bottomAnchor)
        titleView.pinBottom(to: self.bottomAnchor)
    }
    
    // MARK: - Icon Management
    func fillIcon() {
        guard let currentImage = button.image(for: .normal),
              let currentSymbolName = currentImage.accessibilityIdentifier else {
            return
        }
        
        let newSymbolName = currentSymbolName.replacingOccurrences(of: Constants.fillSuffix, with: "") + Constants.fillSuffix
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: Constants.iconPointSize, weight: .regular)
        let newIconImage = UIImage(systemName: newSymbolName, withConfiguration: symbolConfig)
        button.setImage(newIconImage, for: .normal)
        button.tintColor = Constants.filledTintColor
        titleView.textColor = Constants.filledTintColor
        newIconImage?.accessibilityIdentifier = newSymbolName
    }
    
    func unfillIcon() {
        guard let currentImage = button.image(for: .normal),
              let currentSymbolName = currentImage.accessibilityIdentifier else {
            return
        }
        
        let newSymbolName = currentSymbolName.replacingOccurrences(of: Constants.fillSuffix, with: "")
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: Constants.iconPointSize, weight: .regular)
        let newIconImage = UIImage(systemName: newSymbolName, withConfiguration: symbolConfig)
        button.setImage(newIconImage, for: .normal)
        button.tintColor = Constants.defaultTintColor
        titleView.textColor = Constants.defaultTintColor
        newIconImage?.accessibilityIdentifier = newSymbolName
    }
    
    // MARK: - Utility
    func getTag() -> Int {
        return button.tag
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return button.frame.contains(point) || titleView.frame.contains(point)
    }
}
