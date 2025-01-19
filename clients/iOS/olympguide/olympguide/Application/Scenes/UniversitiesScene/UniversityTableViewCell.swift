//
//  UniversityTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 26.12.2024.
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

class UniversityTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = Constants.Identifier.cellIdentifier
    
    private let logoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let regionLabel = UILabel()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: Constants.Images.bookmark), for: .normal)
        return button
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Colors.separatorColor
        return view
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
        contentView.addSubview(logoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(regionLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(separatorLine)
        
        // Configure logoImageView
        logoImageView.contentMode = .scaleAspectFit
        
        // Configure nameLabel
        nameLabel.font = Constants.Fonts.nameLabelFont
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        // Configure regionLabel
        regionLabel.font = Constants.Fonts.regionLabelFont
        regionLabel.textColor = Constants.Colors.regionTextColor
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        logoImageView.pinLeft(to: contentView.leadingAnchor, Constants.Dimensions.logoLeftMargin)
        logoImageView.pinTop(to: contentView.topAnchor, Constants.Dimensions.logoTopMargin)
        logoImageView.setWidth(Constants.Dimensions.logoSize)
        logoImageView.setHeight(Constants.Dimensions.logoSize)
        
        regionLabel.pinTop(to: contentView.topAnchor, Constants.Dimensions.logoTopMargin)
        regionLabel.pinLeft(to: logoImageView.trailingAnchor, Constants.Dimensions.interItemSpacing)
        regionLabel.pinRight(to: favoriteButton.leadingAnchor, Constants.Dimensions.interItemSpacing)
        
        nameLabel.pinTop(to: regionLabel.bottomAnchor, 5)
        nameLabel.pinLeft(to: logoImageView.trailingAnchor, Constants.Dimensions.interItemSpacing)
        nameLabel.pinRight(to: favoriteButton.leadingAnchor, Constants.Dimensions.interItemSpacing)
        nameLabel.pinBottom(to: contentView.bottomAnchor, Constants.Dimensions.nameLabelBottomMargin)
        
        favoriteButton.pinCenterY(to: contentView)
        favoriteButton.pinRight(to: contentView.trailingAnchor, Constants.Dimensions.interItemSpacing)
        favoriteButton.setWidth(Constants.Dimensions.favoriteButtonSize)
        favoriteButton.setHeight(Constants.Dimensions.favoriteButtonSize)
        
        separatorLine.pinLeft(to: contentView.leadingAnchor, Constants.Dimensions.separatorHorizontalInset)
        separatorLine.pinRight(to: contentView.trailingAnchor, Constants.Dimensions.separatorHorizontalInset)
        separatorLine.pinBottom(to: contentView.bottomAnchor)
        separatorLine.setHeight(Constants.Dimensions.separatorHeight)
    }
    
    // MARK: - Methods
    func configure(with viewModel: Universities.Load.ViewModel.UniversityViewModel) {
        nameLabel.text = viewModel.name
        regionLabel.text = viewModel.region
        
        if let url = URL(string: viewModel.logoURL) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                if let data = data, error == nil, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.logoImageView.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.logoImageView.image = UIImage(systemName: Constants.Images.placeholder)
                    }
                }
            }.resume()
        } else {
            logoImageView.image = UIImage(systemName: Constants.Images.placeholder)
        }
    private func hideAll() {
        separatorLine.isHidden = true
        favoriteButton.isHidden = true
        nameLabel.isHidden = true
        regionLabel.isHidden = true
        logoImageView.isHidden = true
    }
    
    private func showAll() {
        separatorLine.isHidden = false
        favoriteButton.isHidden = false
        nameLabel.isHidden = false
        regionLabel.isHidden = false
        logoImageView.isHidden = false
    }
    
    // MARK: - Objc funcs
    @objc
    private func favoriteButtonTapped() {
        let isFavorite = favoriteButton.image(for: .normal) == UIImage(systemName: Constants.Images.bookmarkFill)
        let newImageName = isFavorite ? Constants.Images.bookmark : Constants.Images.bookmarkFill
        favoriteButton.setImage(UIImage(systemName: newImageName), for: .normal)
    }
}
