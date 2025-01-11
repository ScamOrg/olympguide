//
//  FieldsTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 11.01.2025.
//

import UIKit

// MARK: - Constants
fileprivate enum Constants {
    enum Identifier {
        static let cellIdentifier = "UniversityTableViewCell"
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
        static let logoTopMargin: CGFloat = 30
        static let logoLeftMargin: CGFloat = 15
        static let logoSize: CGFloat = 80
        static let interItemSpacing: CGFloat = 15
        static let nameLabelBottomMargin: CGFloat = 20
        static let favoriteButtonSize: CGFloat = 22
        static let separatorHeight: CGFloat = 1
        static let separatorHorizontalInset: CGFloat = 20
    }
}

class FieldTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = Constants.Identifier.cellIdentifier
    
    private let information: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        return stackView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: Constants.Images.bookmark), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private funcs
    private func setupUI() {
        contentView.addSubview(favoriteButton)
        contentView.addSubview(information)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        information.pinTop(to: contentView.topAnchor, 5)
        information.pinLeft(to: contentView.leadingAnchor, 20)
        information.pinBottom(to: contentView.bottomAnchor, 5)
        information.pinRight(to: favoriteButton.leadingAnchor, 15)
        favoriteButton.pinTop(to: contentView.topAnchor)
        favoriteButton.pinRight(to: contentView.trailingAnchor, Constants.Dimensions.interItemSpacing)
        favoriteButton.setWidth(Constants.Dimensions.favoriteButtonSize)
        favoriteButton.setHeight(Constants.Dimensions.favoriteButtonSize)
    }
    
    // MARK: - Methods
    func configure(with viewModel: Fields.Load.ViewModel.GroupOfFieldsViewModel.FieldViewModel) {
        let code = viewModel.code
        let title = viewModel.name
        
        for char in code {
            let label = UILabel()
            label.text = String(char)
            label.font = Constants.Fonts.nameLabelFont
            label.textColor = .black
            label.textAlignment = .center
            if char == "." {
                label.setWidth(3)
                label.textAlignment = .left
            } else {
                label.setWidth(11)
            }
            information.addArrangedSubview(label)
        }
        let spaceLabel = UILabel()
        spaceLabel.text = " - "
        spaceLabel.font = Constants.Fonts.nameLabelFont
        information.addArrangedSubview(spaceLabel)
        
        let nameLabel = UILabel()
        nameLabel.text = title
        nameLabel.font = Constants.Fonts.nameLabelFont
        nameLabel.textColor = .black
        
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        information.addArrangedSubview(nameLabel)
    }
    
    // MARK: - Objc funcs
    @objc
    private func favoriteButtonTapped() {
        let isFavorite = favoriteButton.image(for: .normal) == UIImage(systemName: Constants.Images.bookmarkFill)
        let newImageName = isFavorite ? Constants.Images.bookmark : Constants.Images.bookmarkFill
        favoriteButton.setImage(UIImage(systemName: newImageName), for: .normal)
    }
}

