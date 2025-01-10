//
//  ProfileButtonTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 10.01.2025.
//

import UIKit

class ProfileButtonTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ProfileButtonTableViewCell"
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "MontserratAlternates-Medium", size: 15)!
        button.layer.cornerRadius = 13
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    func configure(title: String, borderColor: UIColor, textColor: UIColor) {
        actionButton.setTitle(title, for: .normal)
        actionButton.layer.borderColor = borderColor.cgColor
        actionButton.setTitleColor(textColor, for: .normal)
        
        actionButton.addTarget(nil, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        actionButton.addTarget(nil, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
    }
    
    @objc
    private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction]) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc
    private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.curveEaseOut, .allowUserInteraction]) {
            sender.transform = .identity
        }
    }
}
