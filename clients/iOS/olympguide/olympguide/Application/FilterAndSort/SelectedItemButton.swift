//
//  SelectedItemButton.swift
//  olympguide
//
//  Created by Tom Tim on 01.02.2025.
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

class SelectedItemButton: UIButton, ScrolledButtonProtocol {
    var isSelectedItem: Bool = false
    
    
    // MARK: - Variables
    private var title: UILabel = UILabel()
    let crossImageView: UIImageView = UIImageView(image: UIImage(systemName: "xmark.circle.fill"))
    
    var filterTitle: String {
        return title.text ?? ""
    }
    
    // MARK: - Lifecycle
    init(title: String) {
        super.init(frame: .zero)
        self.title.text = title
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
    
    // MARK: - Private funcs
    private func configureUI() {
        addSubview(title)
        addSubview(crossImageView)
        
        backgroundColor = UIColor(hex: "#1B1F26", alpha: 0.72)
        
        layer.cornerRadius = Constants.Dimensions.cornerRadius
        clipsToBounds = true
        setHeight(Constants.Dimensions.buttonHeight)
        
        crossImageView.tintColor = UIColor(hex: "#999999")
        crossImageView.contentMode = .scaleAspectFit
        
        title.font = UIFont(name: "MontserratAlternates-SemiBold", size: 14)!
        title.textColor = .white
        title.pinBottom(to: self.bottomAnchor, Constants.Dimensions.titleBottomMargin)
        title.pinLeft(to: self.leadingAnchor, Constants.Dimensions.titleLeftMargin)
        title.pinTop(to: self.topAnchor)
        title.pinRight(to: crossImageView.leadingAnchor, Constants.Dimensions.titleRightMargin)
        
        crossImageView.pinCenterY(to: self)
        crossImageView.pinRight(to: self.trailingAnchor, Constants.Dimensions.arrowRightMargin)
    }
}
