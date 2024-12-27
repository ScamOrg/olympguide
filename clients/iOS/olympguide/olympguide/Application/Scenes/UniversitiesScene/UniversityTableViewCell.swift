//
//  UniversityTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 26.12.2024.
//

import UIKit

class UniversityTableViewCell: UITableViewCell {
    static let identifier = "UniversityTableViewCell"
    
    private let logoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let regionLabel = UILabel()
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bookmark"), for: .normal) // Пустой значок
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill 
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(regionLabel)
        contentView.addSubview(favoriteButton)
        
        // Настройки для logoImageView
        logoImageView.contentMode = .scaleAspectFit
        
        // Настройки для nameLabel
        nameLabel.font = UIFont(name: "MontserratAlternates-Medium", size: 15)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        // Настройки для regionLabel
        regionLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 13)
        regionLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.53)
        
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        logoImageView.pinLeft(to: contentView.leadingAnchor, 15)
        logoImageView.pinTop(to: contentView.topAnchor, 30)
        logoImageView.setWidth(80)
        logoImageView.setHeight(80)
        
        regionLabel.pinTop(to: contentView.topAnchor, 30)
        regionLabel.pinLeft(to: logoImageView.trailingAnchor, 15)
        regionLabel.pinRight(to: favoriteButton.leadingAnchor, 15)
        
        nameLabel.pinTop(to: regionLabel.bottomAnchor, 5)
        nameLabel.pinLeft(to: logoImageView.trailingAnchor, 15)
        nameLabel.pinRight(to: favoriteButton.leadingAnchor, 15)
        nameLabel.pinBottom(to: contentView.bottomAnchor, 20)
        
        favoriteButton.pinCenterY(to: contentView)
        favoriteButton.pinRight(to: contentView.trailingAnchor, 15)
        favoriteButton.setWidth(22)
        favoriteButton.setHeight(22)
    }
    
    func configure(with viewModel: Universities.Load.ViewModel.UniversityViewModel) {
        nameLabel.text = viewModel.name
        regionLabel.text = viewModel.region
        
        if let url = URL(string: viewModel.logoURL) {
            // Загружаем изображение асинхронно
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                if let data = data, error == nil, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.logoImageView.image = image
                    }
                } else {
                    // В случае ошибки можно установить изображение-заглушку
                    DispatchQueue.main.async {
                        self.logoImageView.image = UIImage(systemName: "photo")
                    }
                }
            }.resume()
        } else {
            // Устанавливаем изображение-заглушку, если URL недействителен
            logoImageView.image = UIImage(systemName: "photo")
        }
    }
    
    @objc
    private func favoriteButtonTapped() {
        let isFavorite = favoriteButton.image(for: .normal) == UIImage(systemName: "bookmark.fill")
        let newImage = isFavorite ? UIImage(systemName: "bookmark") : UIImage(systemName: "bookmark.fill")
        favoriteButton.setImage(newImage, for: .normal)
    }
}
