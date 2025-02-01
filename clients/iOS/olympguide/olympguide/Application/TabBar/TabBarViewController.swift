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
    private let profileVC = ProfileViewController()
    
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
        
//        let universitiesNavVC = NavigationBarViewController(rootViewController: universitiesVC)
        let universitiesNavVC = NavigationBarViewController(rootViewController: universitiesVC)
        let olympiadsNavVC = NavigationBarViewController(rootViewController: olympiadsVC)
        let fieldsNavVC = NavigationBarViewController(rootViewController: fieldsVC)
        let profileNavVC = NavigationBarViewController(rootViewController: profileVC)
        
        setViewControllers([ViewController(), olympiadsNavVC, fieldsNavVC, profileNavVC], animated: true)
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



import UIKit

final class ViewController: UIViewController, SelectedBarDelegate {

    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Toggle Field", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// Контейнер для нашего CustomTextField.
    /// Именно его высоту мы будем анимировать.
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        // Включим, чтобы "обрезать" содержимое, когда высота = 0
        view.clipsToBounds = true
        return view
    }()

    /// Сам кастомный текстфилд
    private let customTextField = SelectedScrollView(selectedOptions: ["Москва", "Санкт-Петербург", "Новосибирск", "Екатеренбург"])

    /// Таблица для наглядности
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    /// Пример данных для таблицы
    private let data = ["Первая строка", "Вторая строка", "Третья строка"]

    /// Констрейнт, отвечающий за высоту `containerView`.
    private var containerHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Добавим сабвью
        view.addSubview(toggleButton)
        view.addSubview(containerView)
        view.addSubview(tableView)
        
        // Настраиваем кнопку (пусть будет сверху, по центру)
        NSLayoutConstraint.activate([
            toggleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            toggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Привязываем containerView к низу кнопки
        containerHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0)
        containerHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: toggleButton.bottomAnchor), // без отступов
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        

        // Привязываем таблицу к низу контейнера
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Размещаем кастомное поле внутри контейнера
        containerView.addSubview(customTextField)
        customTextField.translatesAutoresizingMaskIntoConstraints = false
        customTextField.delegate = self
//
//        NSLayoutConstraint.activate([
//            // По центру контейнера
//            customTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//            customTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
//            // Ширину фиксируем на 200, а высоту сделаем, например, 5
//        ])
        customTextField.pinLeft(to: containerView.leadingAnchor)
        customTextField.pinRight(to: containerView.trailingAnchor)
        // Изначально делаем поле прозрачным, чтобы не "выпрыгивало"
        customTextField.alpha = 0

        // Настраиваем таблицу
        tableView.dataSource = self
        tableView.delegate = self

        // Добавим экшн на кнопку
        toggleButton.addTarget(self, action: #selector(toggleCustomTextField), for: .touchUpInside)
    }

    @objc func toggleCustomTextField() {
        if containerHeightConstraint.constant == 0 {
            // Показываем
            UIView.animate(withDuration: 0.3) {
                self.containerHeightConstraint.constant = self.customTextField.bounds.height // или сколько вам нужно
                self.customTextField.alpha = 1
                self.view.layoutIfNeeded()
            }
        } else {
            // Скрываем
            UIView.animate(withDuration: 0.3) {
                self.containerHeightConstraint.constant = 0
                self.customTextField.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}
