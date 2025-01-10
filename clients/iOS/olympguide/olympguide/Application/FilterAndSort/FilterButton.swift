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
    }
    
    enum Colors {
        static let backgroundColor = UIColor(hex: "#EBEBEC")
        static let arrowTintColor = UIColor.black
    }
    
    enum Fonts {
        static let titleFont = UIFont(name: "MontserratAlternates-Regular", size: 14)!
    }
    
    enum Dimensions {
        static let cornerRadius: CGFloat = 15.5
        static let buttonHeight: CGFloat = 31
        static let titleBottomMargin: CGFloat = 2
        static let titleLeftMargin: CGFloat = 16
        static let titleRightMargin: CGFloat = 6
        static let arrowRightMargin: CGFloat = 14
    }
}

class FilterButton: UIButton {
    
    // MARK: - Variables
    private var title: UILabel = UILabel()
    let arrowImageView: UIImageView = UIImageView(image: UIImage(systemName: Constants.Images.arrowImageName))
    
    var filterTitle: String {
        return title.text ?? ""
    }
    
    // MARK: - Lifecycle
    init(title: String) {
        super.init(frame: .zero)
        self.title.text = title
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
    
    // MARK: - Private funcs
    private func configureUI() {
        addSubview(title)
        addSubview(arrowImageView)
        
        backgroundColor = Constants.Colors.backgroundColor
        layer.cornerRadius = Constants.Dimensions.cornerRadius
        clipsToBounds = true
        setHeight(Constants.Dimensions.buttonHeight)
        
        arrowImageView.tintColor = Constants.Colors.arrowTintColor
        arrowImageView.contentMode = .scaleAspectFit
        
        title.font = Constants.Fonts.titleFont
        title.pinBottom(to: self.bottomAnchor, Constants.Dimensions.titleBottomMargin)
        title.pinLeft(to: self.leadingAnchor, Constants.Dimensions.titleLeftMargin)
        title.pinTop(to: self.topAnchor)
        title.pinRight(to: arrowImageView.leadingAnchor, Constants.Dimensions.titleRightMargin)
        
        arrowImageView.pinCenterY(to: self)
        arrowImageView.pinRight(to: self.trailingAnchor, Constants.Dimensions.arrowRightMargin)
    }
}
