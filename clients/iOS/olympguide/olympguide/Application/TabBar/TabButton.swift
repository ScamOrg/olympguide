//
//  TabButton.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

class TabButton: UIView {
    
    // MARK: - Properties
    private var button: UIButton = UIButton()
    private var titleView: UILabel = UILabel()
    
    // MARK: - Initialization
    init(title: String, icon: String, tag: Int, action: UIAction, tintColor: UIColor = UIColor(hex: "#4F4F4F") ?? .gray) {
        super.init(frame: .zero)
        
        button = UIButton(primaryAction: action)
        button.tag = tag
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        var iconImage = UIImage(systemName: icon, withConfiguration: symbolConfig)

        if tintColor == .black {
            iconImage = UIImage(systemName: icon + ".fill", withConfiguration: symbolConfig)
        }

        // Устанавливаем accessibilityIdentifier
        iconImage?.accessibilityIdentifier = tintColor == .black ? icon + ".fill" : icon

        button.setImage(iconImage, for: .normal)
        button.tintColor = tintColor
        button.setWidth(64)
        button.setHeight(34)
        
        titleView.text = title
        titleView.font = .systemFont(ofSize: 10)
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
    
    func fillIcon() {
        guard let currentImage = button.image(for: .normal),
              let currentSymbolName = currentImage.accessibilityIdentifier else {
            return
        }
        
        let newSymbolName = currentSymbolName.replacingOccurrences(of: ".fill", with: "") + ".fill"
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let newIconImage = UIImage(systemName: newSymbolName, withConfiguration: symbolConfig)
        button.setImage(newIconImage, for: .normal)
        button.tintColor = .black
        titleView.textColor = .black
        newIconImage?.accessibilityIdentifier = newSymbolName
    }
    
    func unfillIcon() {
        guard let currentImage = button.image(for: .normal),
              let currentSymbolName = currentImage.accessibilityIdentifier else {
            return
        }
        
        let newSymbolName = currentSymbolName.replacingOccurrences(of: ".fill", with: "")
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let newIconImage = UIImage(systemName: newSymbolName, withConfiguration: symbolConfig)
        button.setImage(newIconImage, for: .normal)
        button.tintColor = UIColor(hex: "#4F4F4F") ?? .gray
        titleView.textColor = UIColor(hex: "#4F4F4F") ?? .gray
        
        newIconImage?.accessibilityIdentifier = newSymbolName
    }
    
    func getTag() -> Int {
        return button.tag
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return button.frame.contains(point) || titleView.frame.contains(point)
    }
}
