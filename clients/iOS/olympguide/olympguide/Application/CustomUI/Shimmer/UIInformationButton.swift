//
//  UIInformationButton.swift
//  olympguide
//
//  Created by Tom Tim on 21.02.2025.
//

import UIKit

enum UIInformationButtonType {
    case web
    case email
    case phone
    
    var imageName : String {
        switch self {
        case .web:
            return "globe"
        case .email:
            return "at"
        case .phone:
            return "phone"
        }
    }
}

class UIInformationButton: UIButton, Shimmerable {
    var shimmerView = UIShimmerView()
    
    init(type: UIInformationButtonType) {
        super.init(frame: .zero)
        setupButton(with: type)
        configureShimmer()
        startShimmer()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(with type: UIInformationButtonType) {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .black
        config.imagePlacement = .leading
        config.imagePadding = 10
        config.contentInsets = .zero
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        config.image = UIImage(systemName: type.imageName, withConfiguration: symbolConfig)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.black)
        
        self.configuration = config
        self.contentHorizontalAlignment = .left
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        var config = self.configuration ?? UIButton.Configuration.plain()
        guard let customFont = UIFont(name: "MontserratAlternates-Medium", size: 15) else {
            fatalError("Font not found")
        }
        config.attributedTitle = AttributedString(title ?? "", attributes: AttributeContainer([.font: customFont]))
        self.configuration = config
        
        super.setTitle(title, for: state)
        
        stopShimmer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shimmerView.frame = bounds
        bringSubviewToFront(shimmerView)
    }
}
