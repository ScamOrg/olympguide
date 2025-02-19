//
//  ProfileTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 10.01.2025.
//

import UIKit 

class ProfileTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ProfileTableViewCell"
    
    private let label = UILabel()
    private let detailLabel = UILabel()
    private let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    private let separatorLine = UIView()

    // MARK: - Инициализация
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Настраиваем сабвью
        label.font = UIFont(name: "MontserratAlternates-Medium", size: 15)!
        
        detailLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 15)!
        detailLabel.textColor = .gray
        
        chevronImageView.tintColor = .black
        
        separatorLine.backgroundColor = UIColor(hex: "#E7E7E7")
        
        // Добавляем сабвью один раз
        contentView.addSubview(label)
        contentView.addSubview(detailLabel)
        contentView.addSubview(chevronImageView)
        contentView.addSubview(separatorLine)
        
        // Задаём констрейны один раз
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Публичный метод для конфигурации
    func configure(title: String, detail: String? = nil) {
        label.text = title
        detailLabel.text = detail
        
        // Если detail нет, можно скрыть detailLabel или настроить констрейны
        // Но важный момент: не добавляйте subviews и не создавайте заново констрейны здесь.
    }
    
    // MARK: - Пример метода для установки констрейнов
    private func setupConstraints() {
        chevronImageView.pinCenterY(to: contentView.centerYAnchor)
        chevronImageView.pinRight(to: contentView.trailingAnchor, 20)
        chevronImageView.setWidth(13)
        chevronImageView.setHeight(22)
        
        label.pinTop(to: contentView.topAnchor, 21)
        label.pinLeft(to: contentView.leadingAnchor, 20)
        
        detailLabel.pinTop(to: label.bottomAnchor, 4)
        detailLabel.pinLeft(to: contentView.leadingAnchor, 20)
        detailLabel.pinBottom(to: contentView.bottomAnchor, 21)
        
        separatorLine.pinLeft(to: contentView.leadingAnchor, 20)
        separatorLine.pinRight(to: contentView.trailingAnchor, 20)
        separatorLine.pinBottom(to: contentView.bottomAnchor)
        separatorLine.setHeight(1)
    }
    
    func hideSeparator(_ hide: Bool) {
        separatorLine.isHidden = hide
    }
}
