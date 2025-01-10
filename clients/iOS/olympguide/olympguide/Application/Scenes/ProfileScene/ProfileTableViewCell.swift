//
//  ProfileTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 10.01.2025.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ProfileTableViewCell"
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#E7E7E7")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        textLabel?.font = UIFont(name: "MontserratAlternates-Medium", size: 15)!
        detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        detailTextLabel?.textColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, detail: String? = nil) {
        contentView.addSubview(separatorLine)
        textLabel?.text = title
        detailTextLabel?.text = detail
        
        separatorLine.pinLeft(to: contentView.leadingAnchor, 20)
        separatorLine.pinRight(to: contentView.trailingAnchor, 20)
        separatorLine.pinBottom(to: contentView.bottomAnchor)
        separatorLine.setHeight(1)
    }
}
