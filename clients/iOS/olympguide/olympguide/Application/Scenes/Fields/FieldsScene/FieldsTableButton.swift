//
//  FieldsTableButton.swift
//  olympguide
//
//  Created by Tom Tim on 11.01.2025.
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

class FieldsTableButton: UIButton {
    
    // MARK: - Variables
    private var name: String
    private var code: String
    var isExpanded: Bool
    let backgroundView: UIView = UIView()
    let arrowImageView: UIImageView = UIImageView()
    
    private let information: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: - Lifecycle
    init(name: String, code: String, isExpanded: Bool = false) {
        self.isExpanded = isExpanded
        self.name = name
        self.code = code
        
        super.init(frame: .zero)
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
        addSubview(backgroundView)
        addSubview(arrowImageView)
        addSubview(information)
        
        arrowImageView.image = isExpanded
        ? UIImage(systemName: "chevron.up")
        : UIImage(systemName: "chevron.down")
        
        self.backgroundColor = .clear
        
        information.arrangedSubviews.forEach { $0.removeFromSuperview() }
        information.isUserInteractionEnabled = false
 
        arrowImageView.isUserInteractionEnabled = false
        backgroundView.isUserInteractionEnabled = false
        
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 13
        backgroundView.pinTop(to: self.topAnchor)
        backgroundView.pinBottom(to: self.bottomAnchor)
        backgroundView.pinLeft(to: self.leadingAnchor, 15)
        backgroundView.pinRight(to: self.trailingAnchor, 15)
        
        information.pinTop(to: self.topAnchor, 5)
        information.pinLeft(to: self.leadingAnchor, 40)
        information.pinBottom(to: self.bottomAnchor, 5)
        information.pinRight(to: self.trailingAnchor, 20)
        
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = .black
        arrowImageView.setWidth(17)
        
        arrowImageView.pinTop(to: self.topAnchor, 3)
        arrowImageView.pinLeft(to: self.leadingAnchor, 20)
        if code.count > 0 {
            for char in code {
                let label = UILabel()
                label.text = String(char)
                label.font = UIFont(name: "MontserratAlternates-Medium", size: 15)!
                label.textColor = .black
                label.textAlignment = .center
                if char == "." {
                    label.setWidth(3)
                } else {
                    label.setWidth(11)
                }
                information.addArrangedSubview(label)
            }
            
            let spaceLabel1 = UILabel()
            spaceLabel1.setWidth(4)
            let spaceLabel2 = UILabel()
            spaceLabel2.setWidth(2)
            information.addArrangedSubview(spaceLabel1)
            let dashLabel = UILabel()
            dashLabel.text = "-"
            dashLabel.font = UIFont(name: "MontserratAlternates-Medium", size: 15)!
            dashLabel.textColor = .black
            dashLabel.textAlignment = .center
            dashLabel.setWidth(11)
            information.addArrangedSubview(dashLabel)
            information.addArrangedSubview(spaceLabel2)
        }

        let nameLabel = UILabel()
        nameLabel.text = capitalizeFirstLetter(input: name)
        nameLabel.font = UIFont(name: "MontserratAlternates-Medium", size: 15)!
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        nameLabel.lineBreakMode = .byWordWrapping
        information.addArrangedSubview(nameLabel)
        
        
        self.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    private func capitalizeFirstLetter(input: String) -> String {
        guard let firstChar = input.first else { return "" }
        return firstChar.uppercased() + input.dropFirst().lowercased()
    }
    
    @objc
    func didTap() {
        isExpanded.toggle()
        alpha = 0.0
        UIView.animate(withDuration: 0.1, animations: {[weak self] in
            self?.alpha = 1.0
            self?.backgroundView.backgroundColor = ((self?.isExpanded) != nil) ? UIColor(hex: "#E0E8FE") : .white
        })
    }
}
