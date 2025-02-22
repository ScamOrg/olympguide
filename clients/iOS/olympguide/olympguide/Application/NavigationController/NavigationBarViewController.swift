//
//  NavigationBarViewController.swift
//  olympguide
//
//  Created by Tom Tim on 12.01.2025.
//

import UIKit

protocol NonTabBarVC { }

fileprivate enum Constants {
    enum Colors {
        static let searchButtonTintColor: UIColor = .black
    }
    
    enum Dimensions {
        static let searchButtonSize: CGFloat = 33
        static let bookMarkkButtonSize: CGFloat = 28
        static let searchButtonBottomMargin: CGFloat = 8
        static let searchButtonRightMargin: CGFloat = 20
        static let animateDuration: TimeInterval = 0.1
    }
    
    enum Images {
        static let searchIcon: String =  "magnifyingglass"
        static let bookmarkIcon: String = "bookmark"
    }
}

class NavigationBarViewController: UINavigationController {
    var searchButtonPressed: ((_: UIButton) -> Void)?
    var bookMarkButtonPressed: ((_: UIButton) -> Void)?
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.Images.searchIcon), for: .normal)
        button.tintColor = Constants.Colors.searchButtonTintColor
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let bookMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.Images.bookmarkIcon), for: .normal)
        button.tintColor = Constants.Colors.searchButtonTintColor
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        configureNavigationBar()
        
        configureUI()
    }
    
    private func configureUI() {
        configureSearchButton()
        configureBookMarkButton()
    }
    
    private func configureNavigationBar() {
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchButton() {
        navigationBar.addSubview(searchButton)
        
        searchButton.alpha = 1.0
        
        searchButton.setWidth(Constants.Dimensions.searchButtonSize)
        searchButton.setHeight(Constants.Dimensions.searchButtonSize)
        
        searchButton.pinBottom(to: navigationBar.bottomAnchor, Constants.Dimensions.searchButtonBottomMargin)
        searchButton.pinRight(to: navigationBar.trailingAnchor, Constants.Dimensions.searchButtonRightMargin)
        
        searchButton.addTarget(self, action: #selector(searchButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func configureBookMarkButton() {
        navigationBar.addSubview(bookMarkButton)

        bookMarkButton.alpha = 0.0
        bookMarkButton.isHidden = true
        
        bookMarkButton.setWidth(Constants.Dimensions.bookMarkkButtonSize)
        bookMarkButton.setHeight(Constants.Dimensions.bookMarkkButtonSize)
        
        bookMarkButton.pinBottom(to: navigationBar.bottomAnchor, Constants.Dimensions.searchButtonBottomMargin)
        bookMarkButton.pinRight(to: navigationBar.trailingAnchor, Constants.Dimensions.searchButtonRightMargin)
        
        bookMarkButton.addTarget(self, action: #selector(bookMarkButtonPressed(_:)), for: .touchUpInside)
    }
    
    @objc private func searchButtonPressed(_ sender: UIButton) {
        searchButtonPressed?(sender)
    }
    
    @objc private func bookMarkButtonPressed(_ sender: UIButton) {
        bookMarkButtonPressed?(sender)
    }
}

extension NavigationBarViewController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        guard let coordinator = navigationController.transitionCoordinator else {
            self.searchButton.alpha = (viewController is MainVC) ? 1.0 : 0.0
            self.searchButton.isHidden = (viewController is MainVC) ? false : true
            self.bookMarkButton.alpha = (viewController is WithBookMarkButton) ? 1.0 : 0.0
            self.bookMarkButton.isHidden = (viewController is WithBookMarkButton) ? false : true
            return
        }
        guard let tabBarVC = tabBarController as? TabBarViewController else { return }
        
        coordinator.animateAlongsideTransition(in: navigationBar, animation: { _ in
            self.searchButton.isHidden = false
            self.bookMarkButton.isHidden = false
            self.searchButton.alpha = (viewController is MainVC) ? 1.0 : 0.0
            self.bookMarkButton.alpha = (viewController is WithBookMarkButton) ? 1.0 : 0.0
            tabBarVC.customTabBar.alpha = (viewController is NonTabBarVC) ? 0.0 : 1.0
        }, completion: { context in
            self.searchButton.isHidden = (viewController is MainVC) ? false : true
            self.bookMarkButton.isHidden = (viewController is WithBookMarkButton) ? false : true
            if context.isCancelled,
               let fromVC = context.viewController(forKey: .from) {
                self.searchButton.alpha = (fromVC is MainVC) ? 1.0 : 0.0
                self.bookMarkButton.alpha = (viewController is WithBookMarkButton) ? 1.0 : 0.0
                tabBarVC.customTabBar.alpha = (viewController is NonTabBarVC) ? 0.0 : 1.0
            }
        })
    }
}
