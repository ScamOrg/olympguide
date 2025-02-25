//
//  FieldsTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 11.01.2025.
//

import UIKit

// MARK: - CellConstants
fileprivate enum CellConstants {
    enum Identifier {
        static let cellIdentifier = "FieldTableViewCell"
    }
    
    enum Images {
        static let bookmark = "bookmark"
        static let bookmarkFill = "bookmark.fill"
        static let placeholder = "photo"
    }
    
    enum Colors {
        static let separatorColor = UIColor(hex: "#E7E7E7")
        static let regionTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.53)
    }
    
    enum Fonts {
        static let nameLabelFont = UIFont(name: "MontserratAlternates-Medium", size: 15)!
        static let regionLabelFont = UIFont(name: "MontserratAlternates-Regular", size: 13)!
    }
    
    enum Dimensions {
        static let interItemSpacing: CGFloat = 15
        static let favoriteButtonSize: CGFloat = 22
    }
}

class FieldTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = CellConstants.Identifier.cellIdentifier
    
    private let information: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private funcs
    private func setupUI() {
        contentView.addSubview(information)
        
        information.pinTop(to: contentView.topAnchor, 5)
        information.pinLeft(to: contentView.leadingAnchor, 40)
        information.pinBottom(to: contentView.bottomAnchor, 5)
        information.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    // MARK: - Methods
    func configure(with viewModel: Fields.Load.ViewModel.GroupOfFieldsViewModel.FieldViewModel) {
        information.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let code = viewModel.code
        for char in code {
            let label = UILabel()
            label.text = String(char)
            label.font = CellConstants.Fonts.nameLabelFont
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
        dashLabel.font = CellConstants.Fonts.nameLabelFont
        dashLabel.textColor = .black
        dashLabel.textAlignment = .center
        dashLabel.setWidth(11)
        information.addArrangedSubview(dashLabel)
        information.addArrangedSubview(spaceLabel2)

        let nameLabel = UILabel()
        nameLabel.text = viewModel.name
        nameLabel.font = CellConstants.Fonts.nameLabelFont
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        nameLabel.lineBreakMode = .byWordWrapping
        information.addArrangedSubview(nameLabel)
    }
}
