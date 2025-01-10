//
//  ProfileTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 10.01.2025.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ProfileTableViewCell"
    
    private let label = UILabel()
    private let detailLabel = UILabel()
    private let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#E7E7E7")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        label.font = UIFont(name: "MontserratAlternates-Medium", size: 15)!
        detailLabel.font = UIFont(name: "MontserratAlternates-Regular", size: 15)!
        detailLabel.textColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(title: String, detail: String? = nil) {
        contentView.addSubview(separatorLine)
        contentView.addSubview(label)
        contentView.addSubview(detailLabel)
        contentView.addSubview(chevronImageView)
        
        chevronImageView.setHeight(22)
        chevronImageView.setWidth(13)
        chevronImageView.pinCenterY(to: contentView)
        chevronImageView.pinRight(to: contentView.trailingAnchor, 20)
        chevronImageView.tintColor = .black
        
        label.text = title
        detailLabel.text = detail
        
        
        label.pinTop(to: contentView.topAnchor, 21)
        label.pinLeft(to: contentView.leadingAnchor, 20)

        if detail != nil {
            detailLabel.pinTop(to: label.bottomAnchor, 4)
            detailLabel.pinLeft(to: contentView.leadingAnchor, 20)
            detailLabel.pinBottom(to: contentView.bottomAnchor, 21)
        } else {
            label.pinBottom(to: contentView.bottomAnchor, 21)
        }
        
        separatorLine.pinLeft(to: contentView.leadingAnchor, 20)
        separatorLine.pinRight(to: contentView.trailingAnchor, 20)
        separatorLine.pinBottom(to: contentView.bottomAnchor)
        separatorLine.setHeight(1)
    }
    
    // MARK: - Methods
    func hideSeparator(_ hide: Bool) {
        separatorLine.isHidden = hide
    }
}
