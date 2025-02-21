//
//  HasSecondNameButton.swift
//  olympguide
//
//  Created by Tom Tim on 06.02.2025.
//

import UIKit

// MARK: - Constants
fileprivate enum Constants {
    enum Colors {
        static let separatorColor = UIColor(hex: "#E7E7E7")
    }
    
    enum Fonts {
        static let titleFont = UIFont(name: "MontserratAlternates-Medium", size: 15)!
    }
    
    enum Dimensions {
        static let titleLeftMargin: CGFloat = 30
        static let iconButtonRightMargin: CGFloat = 30
        static let titleRightMargin: CGFloat = 8
        static let iconButtonSize: CGFloat = 24
        static let separatorHeight: CGFloat = 1
        static let separatorLeftMargin: CGFloat = 20
        static let separatorRightMargin: CGFloat = 20
    }
    
    enum Images {
        static let buttonImageName = "circle"
    }
    
    enum Strings {
        static let identifier = "CustomButton"
    }
}

// MARK: - Custom Button
class HasSecondNameButton: UIButton {
    // MARK: - Subviews
    private let cellTitleLabel: UILabel = UILabel()

    private let iconImageView: UIImageView = UIImageView()
    
    
    // MARK: - Public properties
    
    var text: String? {
        didSet {
            cellTitleLabel.text = text
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        configureUI()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        setTitle("", for: .normal)
    }
    
    private func configureUI() {
        configureCellTitleLabel()
        configureIconImageView()
    }
    
    private func configureCellTitleLabel() {
        cellTitleLabel.font = Constants.Fonts.titleFont
        
        addSubview(cellTitleLabel)
        cellTitleLabel.pinLeft(to: leadingAnchor, Constants.Dimensions.titleLeftMargin)
        cellTitleLabel.pinCenterY(to: centerYAnchor)
    }
    
    private func configureIconImageView() {
        iconImageView.tintColor = .black
        iconImageView.image = UIImage(systemName: Constants.Images.buttonImageName)
        iconImageView.contentMode = .scaleAspectFit
        
        addSubview(iconImageView)
        iconImageView.pinRight(to: trailingAnchor, Constants.Dimensions.iconButtonRightMargin)
        iconImageView.pinCenterY(to: centerYAnchor)
        iconImageView.setWidth(Constants.Dimensions.iconButtonSize)
        iconImageView.setHeight(Constants.Dimensions.iconButtonSize)
        
        cellTitleLabel.pinRight(to: iconImageView.leadingAnchor, Constants.Dimensions.titleRightMargin, .lsOE)
    }
    
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        guard let image = image else { return }
        
        iconImageView.image = image
    }
}

