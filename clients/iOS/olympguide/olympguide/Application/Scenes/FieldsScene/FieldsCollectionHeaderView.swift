//
//  FieldsCollectionHeaderView.swift
//  olympguide
//
//  Created by Tom Tim on 15.01.2025.
//

import UIKit

protocol FieldsCollectionHeaderViewDelegate: AnyObject {
    func didTapSectionHeader(section: Int)
}

class FieldsCollectionHeaderView: UICollectionReusableView {
    static let reuseId = "FieldsCollectionHeaderView"
    
    private let titleLabel = UILabel()
    private let backgroundBox = UIView()
    
    private var sectionIndex: Int = 0
    weak var delegate: FieldsCollectionHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Настраиваем фоновый вью
        backgroundBox.backgroundColor = .white
        backgroundBox.layer.cornerRadius = 8
        backgroundBox.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundBox)
        
        // Лейбл
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundBox.addSubview(titleLabel)
        
        // Располагаем
        NSLayoutConstraint.activate([
            backgroundBox.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            backgroundBox.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            backgroundBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            backgroundBox.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            titleLabel.leadingAnchor.constraint(equalTo: backgroundBox.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundBox.trailingAnchor, constant: -12),
            titleLabel.centerYAnchor.constraint(equalTo: backgroundBox.centerYAnchor)
        ])
        
        // Добавим жест для тапа
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, code: String, isExpanded: Bool, section: Int, delegate: FieldsCollectionHeaderViewDelegate) {
        self.delegate = delegate
        sectionIndex = section
        
        // Можно стилизовать фон при isExpanded
        backgroundBox.backgroundColor = isExpanded ? UIColor(hex: "#E0E8FE") : .white
        
        // Пишем текст
        titleLabel.text = "\(code) — \(title)"
    }
    
    @objc
    private func didTapHeader() {
        delegate?.didTapSectionHeader(section: sectionIndex)
    }
}

