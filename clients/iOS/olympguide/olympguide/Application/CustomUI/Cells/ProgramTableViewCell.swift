//
//  ProgramTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
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

final class ProgramTableViewCell: UITableViewCell {
    private let informationStack: UIStackView = UIStackView()
    private let favoriteButton: UIButton = UIButton()
    private let budgtetLabel: UIInformationLabel = UIInformationLabel()
    private let paidLabel: UIInformationLabel = UIInformationLabel()
    private let costLabel: UIInformationLabel = UIInformationLabel()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        configureInformationStack()
        configureFavoriteButton()
        configureBudgetLabel()
        configurePaidLabel()
        configureCostLabel()
    }
    
    private func configureInformationStack() {
        informationStack.axis = .horizontal
        informationStack.alignment = .top
        informationStack.spacing = 0
        
        contentView.addSubview(informationStack)
        
        informationStack.pinTop(to: contentView.topAnchor, 5)
        informationStack.pinLeft(to: contentView.leadingAnchor, 40)
        informationStack.pinRight(to: contentView.trailingAnchor, 57)
    }
    
    private func configureFavoriteButton() {
        favoriteButton.tintColor = .black
        favoriteButton.contentHorizontalAlignment = .fill
        favoriteButton.contentVerticalAlignment = .fill
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        favoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        
        contentView.addSubview(favoriteButton)
        
        favoriteButton.pinTop(to: contentView.topAnchor, 6)
        favoriteButton.pinRight(to: contentView.trailingAnchor, 20)
        favoriteButton.setWidth(CellConstants.Dimensions.favoriteButtonSize)
        favoriteButton.setHeight(CellConstants.Dimensions.favoriteButtonSize)
    }
    
    private func configureBudgetLabel() {
        budgtetLabel.setText(regular: "Бюджетных мест ")
        
        contentView.addSubview(budgtetLabel)
        
        budgtetLabel.pinTop(to: informationStack.bottomAnchor, 11)
        budgtetLabel.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    private func configurePaidLabel() {
        paidLabel.setText(regular: "Платных мест ")
        
        contentView.addSubview(paidLabel)
        
        paidLabel.pinTop(to: budgtetLabel.bottomAnchor, 7)
        paidLabel.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    private func configureCostLabel() {
        costLabel.setText(regular: "Стоимость ")
        
        contentView.addSubview(costLabel)
        
        costLabel.pinTop(to: paidLabel.bottomAnchor, 7)
        costLabel.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    
    func configure(with viewModel: Programs.Load.ViewModel.GroupOfProgramsViewModel.ProgramViewModel) {
        informationStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
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
            informationStack.addArrangedSubview(label)
        }
        
        let spaceLabel1 = UILabel()
        spaceLabel1.setWidth(4)
        let spaceLabel2 = UILabel()
        spaceLabel2.setWidth(2)
        informationStack.addArrangedSubview(spaceLabel1)
        let dashLabel = UILabel()
        dashLabel.text = "-"
        dashLabel.font = CellConstants.Fonts.nameLabelFont
        dashLabel.textColor = .black
        dashLabel.textAlignment = .center
        dashLabel.setWidth(11)
        informationStack.addArrangedSubview(dashLabel)
        informationStack.addArrangedSubview(spaceLabel2)
        
        let nameLabel = UILabel()
        nameLabel.text = viewModel.name
        nameLabel.font = CellConstants.Fonts.nameLabelFont
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        nameLabel.lineBreakMode = .byWordWrapping
        informationStack.addArrangedSubview(nameLabel)
        
        budgtetLabel.setBoldText(viewModel.budgetPlaces)
        paidLabel.setBoldText(viewModel.paidPlaces)
        costLabel.setBoldText(viewModel.cost)
    }
}


import UIKit

final class UIInformationLabel: UILabel {
    private var regularText: String = ""
    private var boldText: String = ""
    
    func setText(regular: String = "", bold: String = "") {
        self.regularText = regular
        self.boldText = bold
        updateAttributedText()
    }
    
    func setBoldText(_ bold: String) {
        self.boldText = bold
        updateAttributedText()
    }
    
    private func updateAttributedText() {
        let fullText = regularText + boldText
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let regularFont = UIFont(name: "MontserratAlternates-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let boldFont = UIFont(name: "MontserratAlternates-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
        
        attributedString.addAttribute(
            .font,
            value: regularFont,
            range: NSRange(
                location: 0,
                length: regularText.count
            )
        )
        
        let boldRange = NSRange(
            location: regularText.count,
            length: boldText.count
        )
        attributedString.addAttribute(
            .font,
            value: boldFont,
            range: boldRange
        )
        
        attributedText = attributedString
    }
}
