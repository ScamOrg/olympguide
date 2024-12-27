//
//  FilterButton.swift
//  olympguide
//
//  Created by Tom Tim on 27.12.2024.
//

import UIKit

class FilterButton: UIButton {
    private var title: UILabel = UILabel()
    let arrowImageView: UIImageView = UIImageView(image: UIImage(systemName: "chevron.down"))
    // MARK: - Initialization
    init(title: String) {
        super.init(frame: .zero)
        self.title.text = title
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubview(title)
        self.addSubview(arrowImageView)
        
        self.backgroundColor = UIColor(hex: "#EBEBEC")
        self.layer.cornerRadius = 15.5 // Половина высоты кнопки
        self.clipsToBounds = true
        self.setHeight(31)
        
        arrowImageView.tintColor = .black // Делаем `chevron.down` чёрной
        arrowImageView.contentMode = .scaleAspectFit
        
        title.font = UIFont(name: "MontserratAlternates-Regular", size: 14)
        title.pinBottom(to: self.bottomAnchor, 2)
        title.pinLeft(to: self.leadingAnchor, 16)
        title.pinTop(to: self.topAnchor)
        title.pinRight(to: arrowImageView.leadingAnchor, 6)
        
        arrowImageView.pinCenterY(to: self)
        arrowImageView.pinRight(to: self.trailingAnchor, 14)
    }
    
    // MARK: - Обработка нажатий
        override var isHighlighted: Bool {
            didSet {
                // При нажатии изменяем прозрачность для эффекта "нажатия"
                self.alpha = isHighlighted ? 0.7 : 1.0
            }
        }
}
