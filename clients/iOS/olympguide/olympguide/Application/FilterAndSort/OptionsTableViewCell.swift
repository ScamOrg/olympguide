//
//  ChoiceCell.swift
//  olympguide
//
//  Created by Tom Tim on 27.12.2024.
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
        static let titleLeftMargin: CGFloat = 20
        static let actionButtonRightMargin: CGFloat = 20
        static let titleRightMargin: CGFloat = 8
        static let actionButtonSize: CGFloat = 24
        static let separatorHeight: CGFloat = 1
        static let separatorLeftMargin: CGFloat = 20
        static let separatorRightMargin: CGFloat = 20
    }
    
    enum Images {
        static let buttonImageName = "square"
    }
    
    enum Strings {
        static let identifier = "CustomTableViewCell"
    }
}

class OptionsTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = Constants.Strings.identifier
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.titleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.setImage(UIImage(systemName: Constants.Images.buttonImageName), for: .normal)
        return button
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Colors.separatorColor
        return view
    }()
    
    var buttonAction: (() -> Void)?
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(actionButton)
        contentView.addSubview(separatorLine)
        setupConstraints()
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func hideSeparator(_ hide: Bool) {
        separatorLine.isHidden = hide
    }
    
    // MARK: - Private funcs
    private func setupConstraints() {
        titleLabel.pinLeft(to: contentView.leadingAnchor, Constants.Dimensions.titleLeftMargin)
        titleLabel.pinCenterY(to: contentView)
        
        actionButton.pinRight(to: contentView.trailingAnchor, Constants.Dimensions.actionButtonRightMargin)
        actionButton.pinCenterY(to: contentView)
        actionButton.setHeight(Constants.Dimensions.actionButtonSize)
        actionButton.setWidth(Constants.Dimensions.actionButtonSize)
        
        titleLabel.pinRight(to: actionButton.leadingAnchor, Constants.Dimensions.titleRightMargin, .lsOE)
        
        separatorLine.pinLeft(to: contentView.leadingAnchor, Constants.Dimensions.separatorLeftMargin)
        separatorLine.pinRight(to: contentView.trailingAnchor, Constants.Dimensions.separatorRightMargin)
        separatorLine.pinBottom(to: contentView.bottomAnchor)
        separatorLine.setHeight(Constants.Dimensions.separatorHeight)
    }
    
    // MARK: - Objc funcs
    @objc
    private func buttonTapped() {
        buttonAction?()
    }
}
