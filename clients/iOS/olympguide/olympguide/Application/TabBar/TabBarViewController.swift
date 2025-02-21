//
//  TabBarViewController.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - Constants
    private enum Constants {
        // Titles
        static let universitiesTitle = "Вузы"
        static let olympiadsTitle = "Олимпиады"
        static let destinationTitle = "Направления"
        static let profileTitle = "Профиль"
        
        // Icons
        static let universitiesIcon = "graduationcap"
        static let olympiadsIcon = "trophy"
        static let destinationIcon = "book.pages"
        static let profileIcon = "person.crop.circle"
        
        // CustomTabBar layout
        static let customTabBarBackgroundColor = UIColor(hex: "#E0E8FE")
        static let customTabBarCornerRadius: CGFloat = 27.5
        static let customTabBarHeight: CGFloat = 55
        static let customTabBarHorizontalPadding: CGFloat = 14
        static let customTabBarVerticalPadding: CGFloat = 22
        static let customTabBarMargins = UIEdgeInsets(top: 0, left: 50, bottom: -10, right: 50)
        
        // Shadow
        static let shadowColor = UIColor.black.cgColor
        static let shadowOpacity: Float = 0.25
        static let shadowOffset = CGSize(width: 5, height: 5)
        static let shadowRadius: CGFloat = 10
    }
    
    // MARK: - Properties
    let presenter = UniversitiesPresenter()
    let interactor = UniversitiesInteractor()
    let router = UniversitiesRouter()
    
    private let universitiesVC = UniversitiesViewController()
    private let olympiadsVC = OlympiadsViewController()
    private let fieldsVC = FieldsViewController()
    private let profileVC = ProfileAssembly.build()
    
    private lazy var universitiesBtn: TabButton = {
        TabButton(
            title: Constants.universitiesTitle,
            icon: Constants.universitiesIcon,
            tag: 0,
            action: action,
            tintColor: .black
        )
    }()
    
    private lazy var olympiadsBtn: TabButton = {
        TabButton(
            title: Constants.olympiadsTitle,
            icon: Constants.olympiadsIcon,
            tag: 1,
            action: action
        )
    }()
    
    private lazy var destinationBtn: TabButton = {
        TabButton(
            title: Constants.destinationTitle,
            icon: Constants.destinationIcon,
            tag: 2,
            action: action
        )
    }()
    
    private lazy var profileBtn: TabButton = {
        TabButton(
            title: Constants.profileTitle,
            icon: Constants.profileIcon,
            tag: 3,
            action: action
        )
    }()
    
    lazy var customTabBar: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.backgroundColor = Constants.customTabBarBackgroundColor
        $0.frame = CGRect(
            x: Constants.customTabBarHorizontalPadding,
            y: view.frame.height - Constants.customTabBarHeight - Constants.customTabBarVerticalPadding,
            width: view.frame.width - 2 * Constants.customTabBarHorizontalPadding,
            height: Constants.customTabBarHeight
        )
        $0.layer.cornerRadius = Constants.customTabBarCornerRadius
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = Constants.customTabBarMargins
        return $0
    }(UIStackView())
    
    private lazy var action = UIAction { [weak self] sender in
        guard let sender = sender.sender as? UIButton,
              let self = self
        else {
            return
        }
        
        self.selectedIndex = sender.tag
        self.setIcons(tag: sender.tag)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let universitiesNavVC = NavigationBarViewController(rootViewController: universitiesVC)
        let olympiadsNavVC = NavigationBarViewController(rootViewController: olympiadsVC)
        let fieldsNavVC = NavigationBarViewController(rootViewController: fieldsVC)
        let profileNavVC = NavigationBarViewController(rootViewController: profileVC)
        
        setViewControllers([universitiesNavVC, olympiadsNavVC, fieldsNavVC, profileNavVC], animated: true)
        configureTabBar()
        setupCustomTabBar()
        setupShadow()
        isTabBarHidden = true
    }
    
    // MARK: - Configuration
    private func configureTabBar() {
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.barTintColor = .white
//        tabBar.isTranslucent = false
    }
    
    private func setupCustomTabBar() {
        view.addSubview(customTabBar)
        customTabBar.addArrangedSubview(universitiesBtn)
        customTabBar.addArrangedSubview(olympiadsBtn)
        customTabBar.addArrangedSubview(destinationBtn)
        customTabBar.addArrangedSubview(profileBtn)
    }
    
    private func setupShadow() {
        customTabBar.layer.shadowColor = Constants.shadowColor
        customTabBar.layer.shadowOpacity = Constants.shadowOpacity
        customTabBar.layer.shadowOffset = Constants.shadowOffset
        customTabBar.layer.shadowRadius = Constants.shadowRadius
        customTabBar.layer.masksToBounds = false
    }
    
    // MARK: - Helpers
    private func setIcons(tag: Int) {
        [universitiesBtn, olympiadsBtn, destinationBtn, profileBtn].forEach { button in
            button.unfillIcon()
            if button.getTag() == tag {
                button.fillIcon()
            }
        }
    }
}
