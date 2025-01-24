//
//  NavigationBarViewController.swift
//  olympguide
//
//  Created by Tom Tim on 12.01.2025.
//

import UIKit

fileprivate enum Constants {
    enum Colors {
        static let searchButtonTintColor: UIColor = .black
    }
    
    enum Dimensions {
        static let searchButtonSize: CGFloat = 33
        static let searchButtonBottomMargin: CGFloat = 8
        static let searchButtonRightMargin: CGFloat = 20
        static let animateDuration: TimeInterval = 0.1
    }
    
    enum Images {
        static let searchIcon: String =  "magnifyingglass"
    }
}

class NavigationBarViewController: UINavigationController {
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.Images.searchIcon), for: .normal)
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
        navigationBar.addSubview(searchButton)
        searchButton.alpha = 1.0
        
        searchButton.setWidth(Constants.Dimensions.searchButtonSize)
        searchButton.setHeight(Constants.Dimensions.searchButtonSize)
        
        searchButton.pinBottom(to: navigationBar.bottomAnchor, Constants.Dimensions.searchButtonBottomMargin)
        searchButton.pinRight(to: navigationBar.trailingAnchor, Constants.Dimensions.searchButtonRightMargin)
    }
    
    private func configureNavigationBar() {
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.prefersLargeTitles = true
        //        navigationBar.isTranslucent = false
    }
    
    func setSearchButtonAction(target: AnyObject, action: Selector) {
        searchButton.addTarget(target, action: action, for: .touchUpInside)
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
            return
        }
        guard let tabBarVC = tabBarController as? TabBarViewController else { return }
        
        coordinator.animateAlongsideTransition(in: navigationBar, animation: { _ in
            self.searchButton.alpha = (viewController is MainVC) ? 1.0 : 0.0
            tabBarVC.customTabBar.alpha = (viewController is ProfileViewController) || (viewController is MainVC) ? 1.0 : 0.0
        }, completion: { context in
            if context.isCancelled,
               let fromVC = context.viewController(forKey: .from) {
                self.searchButton.alpha = (fromVC is MainVC) ? 1.0 : 0.0
                tabBarVC.customTabBar.alpha = (viewController is ProfileViewController) || (viewController is MainVC) ? 1.0 : 0.0
            }
        })
    }
}
