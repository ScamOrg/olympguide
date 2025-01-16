//
//  FieldCollectionViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 15.01.2025.
//

import UIKit

class FieldCollectionViewCell: UICollectionViewCell {
    static let reuseId = "FieldCollectionViewCell"
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Для наглядности фон
        contentView.backgroundColor = .systemBlue
        
        // Включаем перенос строк
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        // Обязательно отключаем автоавтолейаут по умолчанию
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем в contentView
        contentView.addSubview(titleLabel)
        
        // Задаём констрейнты, чтобы контент "тянулся" по высоте
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with fieldViewModel: Fields.Load.ViewModel.GroupOfFieldsViewModel.FieldViewModel, width: CGFloat) {
        // В тексте могут быть длинные названия
        titleLabel.text = "\(fieldViewModel.code) - \(fieldViewModel.name)"
        contentView.setWidth(width)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutAttributes
    {
        setNeedsLayout()
        layoutIfNeeded()
        
        // Получаем размер контента по автолейауту
        let size = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}
