//
//  SelectedScrollView.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import UIKit

// MARK: - Constants
fileprivate enum Constants {
    enum Images {
        static let sortIcon = "arrow.up.arrow.down"
    }
    
    enum Colors {
        static let tintColor = UIColor.black
    }
    
    enum Dimensions {
        static let stackViewSpacing: CGFloat = 5
        static let scrollViewInset: CGFloat = 8
        static let spaceWidth: CGFloat = 7
        static let sortButtonSize: CGFloat = 28
    }
}

final class SelectedScrollView: UIView {
    
    // MARK: - Variables
    weak var delegate: SelectedBarDelegate?
    
    private lazy var horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.Dimensions.stackViewSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    init (selectedOptions: [String]) {
        super.init(frame: .zero)
        setupUI()
        configure(with: selectedOptions)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        backgroundColor = .clear
        addSubview(horizontalScrollView)
        horizontalScrollView.addSubview(horizontalStackView)
        
        horizontalScrollView.pinLeft(to: leadingAnchor)
        horizontalScrollView.pinRight(to: trailingAnchor)
        horizontalScrollView.pinTop(to: topAnchor)
        horizontalScrollView.pinBottom(to: bottomAnchor)
        
        horizontalStackView.pinLeft(to: horizontalScrollView.leadingAnchor, Constants.Dimensions.scrollViewInset)
        horizontalStackView.pinRight(to: horizontalScrollView.trailingAnchor, Constants.Dimensions.scrollViewInset)
        horizontalStackView.pinTop(to: horizontalScrollView.topAnchor)
        horizontalStackView.pinBottom(to: horizontalScrollView.bottomAnchor)
        horizontalStackView.pinHeight(to: horizontalScrollView)
    }
    
    private func configure(with selectedOptions: [String]) {
        let space = UIView()
        space.setWidth(Constants.Dimensions.spaceWidth)
        horizontalStackView.addArrangedSubview(space)
        
        for item in selectedOptions {
            let filterButton = createSelectedButton(with: item)
            horizontalStackView.addArrangedSubview(filterButton)
        }
    }
    
    private func createSelectedButton(with title: String, tag: Int = 0) -> UIButton {
        let button = FilterButton(title: title)
        button.tag = tag
        button.isSelectedItem.toggle()
        button.tintColor = .black
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }
    
    // MARK: - Objc funcs
    @objc private func filterButtonTapped(_ sender: UIButton) {
        sender.isHidden = true
        self.horizontalStackView.removeArrangedSubview(sender)
        sender.removeFromSuperview()
        if self.horizontalStackView.arrangedSubviews.count == 1 {
            delegate?.toggleCustomTextField()
        }
        delegate?.unselectOption(at: sender.tag)
    }
    
    func addButtonToStackView(with title: String, tag: Int) {
        let selectedButton = createSelectedButton(with: title, tag: tag)
        horizontalStackView.addArrangedSubview(selectedButton)
        if self.horizontalStackView.arrangedSubviews.count == 2 {
            layoutIfNeeded()
            delegate?.toggleCustomTextField()
        }
    }
    
    func removeButtons(with tag: Int) {
        for button in self.horizontalStackView.arrangedSubviews {
            if let button = button as? FilterButton, button.tag == tag {
                button.isHidden = true
                self.horizontalStackView.removeArrangedSubview(button)
                button.removeFromSuperview()
                if self.horizontalStackView.arrangedSubviews.count == 1 {
                    delegate?.toggleCustomTextField()
                }
            }
        }
    }
}

