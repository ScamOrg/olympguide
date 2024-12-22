//
//  TabButton.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

class TabButton: UIView {
    
    // MARK: - Properties
    private var button: UIButton = UIButton()
    private var titleView: UILabel = UILabel()
    
    // MARK: - Initialization
    init(title: String, icon: String, tag: Int, action: UIAction) {
        button = UIButton(primaryAction: action)
        super.init(frame: .zero)
        button.tag = tag
        button.setImage(UIImage(systemName: icon), for: .normal)
        titleView.text = title
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(button)
        addSubview(titleView)
        
        button.pinTop(to: self)
        button.pinHorizontal(to: self)
        titleView.pinHorizontal(to: self)
        titleView.pinTop(to: button, 10)
        titleView.pinBottom(to: self)
    }
}
