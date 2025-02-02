//
//  FilterButton.swift
//  olympguide
//
//  Created by Tom Tim on 27.12.2024.
//

import UIKit

// MARK: - Constants
fileprivate enum Constants {
    enum Images {
        static let arrowImageName = "chevron.down"
        static let crossImageName = "xmark.circle.fill"
    }
    
    enum Colors {
        static let defaultBackgroundColor = UIColor(hex: "#EBEBEC")
        static let selectedBackgroundColor = UIColor(hex: "#1B1F26", alpha: 0.72)
        static let arrowTintColor = UIColor.black
        static let crossTintColor = UIColor(hex: "#999999")
        static let defaultTitleTextColor = UIColor.black
        static let selectedTitleTextColor = UIColor.white
    }
    
    enum Fonts {
        static let defaultTitleFont = UIFont(name: "MontserratAlternates-Regular", size: 14)!
        static let selectedTitleFont = UIFont(name: "MontserratAlternates-SemiBold", size: 14)!
    }
    
    enum Dimensions {
        static let cornerRadius: CGFloat = 15.5
        static let buttonHeight: CGFloat = 31
        static let titleBottomMargin: CGFloat = 2
        static let titleLeftMargin: CGFloat = 16
        static let titleRightMargin: CGFloat = 6
        static let arrowRightMargin: CGFloat = 10
        // Размер иконки стрелки, как мы задаём её вручную
        static let arrowSize: CGFloat = 22
    }
}

protocol ScrolledButtonProtocol {
    var filterTitle:  String { get }
    var isSelectedItem: Bool { get set }
}

class FilterButton: UIButton, ScrolledButtonProtocol {
    
    // MARK: - Variables
    private var titleLabelCustom: UILabel = UILabel()
    let arrowImageView: UIImageView = UIImageView()
    
    var filterTitle: String {
        return titleLabelCustom.text ?? ""
    }
    
    private var _isSelectedItem = false
    var isSelectedItem: Bool {
        get { _isSelectedItem }
        set {
            _isSelectedItem = newValue
            if newValue {
                configureSelected()
            } else {
                configureDefault()
            }
            // При смене состояния обновляем размеры кнопки, если они зависят от intrinsicContentSize
            self.invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - Lifecycle
    init(title: String) {
        super.init(frame: .zero)
        self.titleLabelCustom.text = title
        isUserInteractionEnabled = true
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override var isHighlighted: Bool {
        didSet {
            self.alpha = isHighlighted ? 0.7 : 1.0
        }
    }
    
    // Переопределяем intrinsicContentSize, чтобы ширина учитывала максимальный размер текста
    override var intrinsicContentSize: CGSize {
        let text = titleLabelCustom.text ?? ""
        
        // Вычисляем ширину текста для обоих шрифтов
        let attributesDefault = [NSAttributedString.Key.font: Constants.Fonts.defaultTitleFont]
        let attributesSelected = [NSAttributedString.Key.font: Constants.Fonts.selectedTitleFont]
        let sizeDefault = (text as NSString).size(withAttributes: attributesDefault)
        let sizeSelected = (text as NSString).size(withAttributes: attributesSelected)
        
        let textWidth = max(sizeDefault.width, sizeSelected.width)
        
        // Общая ширина = отступ слева + ширина текста + отступ справа (между текстом и иконкой) + ширина иконки + отступ справа от иконки
        let totalWidth = Constants.Dimensions.titleLeftMargin +
                         textWidth +
                         Constants.Dimensions.titleRightMargin +
                         Constants.Dimensions.arrowSize +
                         Constants.Dimensions.arrowRightMargin
        
        return CGSize(width: totalWidth, height: Constants.Dimensions.buttonHeight)
    }
    
    // MARK: - Private funcs
    private func configureUI() {
        addSubview(titleLabelCustom)
        addSubview(arrowImageView)
        
        layer.cornerRadius = Constants.Dimensions.cornerRadius
        clipsToBounds = true
        
        // Фиксированная высота кнопки
        self.setHeight(Constants.Dimensions.buttonHeight)
        
        // Настройка arrowImageView
        arrowImageView.setWidth(Constants.Dimensions.arrowSize)
        arrowImageView.setHeight(Constants.Dimensions.arrowSize)
        
        // Расстановка констрейнтов (пример с использованием методов pin*)
        titleLabelCustom.pinTop(to: self.topAnchor)
        titleLabelCustom.pinLeft(to: self.leadingAnchor, Constants.Dimensions.titleLeftMargin)
        titleLabelCustom.pinBottom(to: self.bottomAnchor, Constants.Dimensions.titleBottomMargin)
        titleLabelCustom.pinRight(to: arrowImageView.leadingAnchor, Constants.Dimensions.titleRightMargin)
        
        arrowImageView.pinCenterY(to: self)
        arrowImageView.pinRight(to: self.trailingAnchor, Constants.Dimensions.arrowRightMargin)
        
        // Начальная конфигурация (по умолчанию)
        configureDefault()
    }
    
    private func configureDefault() {
        arrowImageView.contentMode = .scaleAspectFit
        backgroundColor = Constants.Colors.defaultBackgroundColor
        arrowImageView.tintColor = Constants.Colors.arrowTintColor
        let config = UIImage.SymbolConfiguration(weight: .light)
        arrowImageView.image = UIImage(systemName: Constants.Images.arrowImageName, withConfiguration: config)
        // Используем Regular шрифт в состоянии по умолчанию
        titleLabelCustom.font = Constants.Fonts.defaultTitleFont
        titleLabelCustom.textColor = Constants.Colors.defaultTitleTextColor
    }
    
    private func configureSelected() {
        arrowImageView.contentMode = .scaleAspectFill
        backgroundColor = Constants.Colors.selectedBackgroundColor
        arrowImageView.tintColor = Constants.Colors.crossTintColor
        arrowImageView.image = UIImage(systemName: Constants.Images.crossImageName)
        titleLabelCustom.font = Constants.Fonts.selectedTitleFont
        titleLabelCustom.textColor = Constants.Colors.selectedTitleTextColor
    }
}
