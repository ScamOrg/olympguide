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
    private let olympiadsVC = ViewController()
    private let destinationVC = MainViewController()
    private let profileVC = UIViewController()
    
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
    
    private lazy var customTabBar: UIStackView = {
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
        universitiesVC.interactor = interactor
        universitiesVC.router = router
        interactor.presenter = presenter
        presenter.viewController = universitiesVC
        router.viewController = universitiesVC
        //        router.dataStore = interactor
        
        let universitiesNavVC = UINavigationController(rootViewController: universitiesVC)
        let olympiadsNavVC = UINavigationController(rootViewController: olympiadsVC)
        setViewControllers([universitiesNavVC, olympiadsNavVC, destinationVC, profileVC], animated: true)
        configureTabBar()
        setupCustomTabBar()
        setupShadow()
    }
    
    // MARK: - Configuration
    private func configureTabBar() {
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
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


class ViewController: UIViewController {
    
    
    private let showSheetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Поиск", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    let fsView = FilterSortView(sortingOptions: ["Популярность", "Первый уровень"], filteringOptions: ["Уровень", "Профиль", "Уровень", "Профиль"])
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(fsView)
        view.backgroundColor = .white
        setupButton()
        fsView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        fsView.pinLeft(to: view.leadingAnchor)
        fsView.pinRight(to: view.trailingAnchor)

        let backItem = UIBarButtonItem(title: "ВУЗы", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    private func setupButton() {
        view.addSubview(showSheetButton)
        showSheetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            showSheetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showSheetButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Добавляем таргет
        showSheetButton.addTarget(self, action: #selector(showSearchForUniversities), for: .touchUpInside)
    }
    
    @objc
    func showSearchForUniversities() {
        let searchVC = SearchViewController(searchType: .universities)
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc
    private func showBottomSheetButtonTapped() {
        let items = ["I уровень", "II уровень", "III уровень"]
        let sheetVC = OptionsViewController(items: items, title: "Уровень олимпиады", isMultipleChoice: true)
        sheetVC.modalPresentationStyle = .overFullScreen
        present(sheetVC, animated: false) {
            sheetVC.animateShow()
        }
    }
}
//final class ViewController: UIViewController {
//    
//    private let customSearchBar = CustomSearchBar(title: "Найти")
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        // Допустим, хотим разместить на экране
//        customSearchBar.frame = CGRect(
//            x: 20,
//            y: 100,
//            width: UIScreen.main.bounds.width - 40,
//            height: 48
//        )
//        view.addSubview(customSearchBar)
//    }
//}

class MainViewController: UIViewController {
    
    //
        private let customSearchBar = CustomSearchBar(title: "Найти")
    
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
    
            // Допустим, хотим разместить на экране
            customSearchBar.frame = CGRect(
                x: 20,
                y: 100,
                width: UIScreen.main.bounds.width - 40,
                height: 50
            )
            view.addSubview(customSearchBar)
        }
}
