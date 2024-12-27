//
//  ChoiceCell.swift
//  olympguide
//
//  Created by Tom Tim on 27.12.2024.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MontserratAlternates-Medium", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        // Устанавливаем начальное изображение
        button.setImage(UIImage(systemName: "square"), for: .normal)
        return button
    }()
    
    // Кастомный сепаратор
    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#E7E7E7")
        return view
    }()
    
    // Callback для обработки нажатия кнопки
    var buttonAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Отключаем стандартное выделение
        selectionStyle = .none
        
        // Добавляем подвиды
        contentView.addSubview(titleLabel)
        contentView.addSubview(actionButton)
        contentView.addSubview(separatorLine)
        
        // Настраиваем ограничения
        titleLabel.pinLeft(to: contentView.leadingAnchor, 20)
        titleLabel.pinCenterY(to: contentView)
        
        actionButton.pinRight(to: contentView.trailingAnchor, 20)
        actionButton.pinCenterY(to: contentView)
        actionButton.setHeight(24)
        actionButton.setWidth(24)
        
        titleLabel.pinRight(to: actionButton.leadingAnchor, 8, .lsOE)
        
        separatorLine.pinLeft(to: contentView.leadingAnchor, 20)
        separatorLine.pinRight(to: contentView.trailingAnchor, 20)
        separatorLine.pinBottom(to: contentView.bottomAnchor)
        separatorLine.setHeight(1)
        
        // Добавляем действие на кнопку
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        buttonAction?()
    }
    
    // Метод для скрытия сепаратора
    func hideSeparator(_ hide: Bool) {
        separatorLine.isHidden = hide
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
