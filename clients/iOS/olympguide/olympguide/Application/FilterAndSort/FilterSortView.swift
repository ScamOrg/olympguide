//
//  FilterSortView.swift
//  olympguide
//
//  Created by Tom Tim on 27.12.2024.
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

protocol FilterSortViewDelegate: AnyObject {
    func filterSortViewDidTapSortButton(_ view: FilterSortView)
    func filterSortView(_ view: FilterSortView, didTapFilterWith title: String)
}

final class FilterSortView: UIView {
    
    // MARK: - Variables
    weak var delegate: FilterSortViewDelegate?
    
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
    
    // MARK: - Lifecycle
    init(sortingOptions: [String], filteringOptions: [String]) {
        super.init(frame: .zero)
        setupUI()
        configure(sortingOptions: sortingOptions, filteringOptions: filteringOptions)
    }
    
    init (filteringOptions: [String]) {
        super.init(frame: .zero)
        setupUI()
        configure(filteringOptions: filteringOptions)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
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
    
    private func configure(sortingOptions: [String], filteringOptions: [String]) {
        horizontalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let space = UIView()
        space.setWidth(Constants.Dimensions.spaceWidth)
        horizontalStackView.addArrangedSubview(space)
        
        let sortButton = createSortButton()
        horizontalStackView.addArrangedSubview(sortButton)
        
        for filter in filteringOptions {
            let filterButton = createFilterButton(with: filter)
            horizontalStackView.addArrangedSubview(filterButton)
        }
    }
    
    private func configure(filteringOptions: [String]) {
        let space = UIView()
        space.setWidth(Constants.Dimensions.spaceWidth)
        horizontalStackView.addArrangedSubview(space)
        
        for filter in filteringOptions {
            let filterButton = createFilterButton(with: filter)
            horizontalStackView.addArrangedSubview(filterButton)
        }
    }
    
    private func createSortButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.Images.sortIcon), for: .normal)
        button.tintColor = Constants.Colors.tintColor
        button.setWidth(Constants.Dimensions.sortButtonSize)
        button.setHeight(Constants.Dimensions.sortButtonSize)
//        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return button
    }
    
    private func createFilterButton(with title: String) -> UIButton {
//        let button = FilterButton(title: title)
//        //        button.isSelectedItem.toggle()
//        button.tintColor = .black
////        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
//        return button
        UIButton(type: .system)
    }
    
    // MARK: - Objc funcs
    @objc private func sortButtonTapped() {
        delegate?.filterSortViewDidTapSortButton(self)
    }
    
//    @objc private func filterButtonTapped(_ sender: UIButton) {
//        guard let filterButton = sender as? FilterButton else { return }
//        let title = filterButton.filterTitle
//        
//        delegate?.filterSortView(self, didTapFilterWith: title)
//    }
}


protocol SelectedBarDelegate: UIViewController {
    func toggleCustomTextField()
    func unselectOption(at index: Int)
}
