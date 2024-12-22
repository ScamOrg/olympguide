//
//  TabBarViewController.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    private let universitiesVC: UniversitiesViewController = UniversitiesViewController()
    private let olympiadsVC: UIViewController = UIViewController()
    private let destinationVC: UIViewController = UIViewController()
    private let profileVC: UIViewController = UIViewController()
    
    private lazy var universitiesBtn: TabButton = {
        TabButton(title: "Вузы", icon: "graduationcap", tag: 0, action: action, tintColor: .black)
    }()
    
    private lazy var olympiadsBtn: TabButton = {
        TabButton(title: "Олимпиады", icon: "trophy", tag: 1, action: action)
    }()
    
    private lazy var destinatioBtn: TabButton = {
        TabButton(title: "Направления", icon: "book.pages", tag: 2, action: action)
    }()
    
    private lazy var profileBtn: TabButton = {
        TabButton(title: "Профиль", icon: "person.crop.circle", tag: 3, action: action)
    }()
    
    private lazy var customTabBar: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.backgroundColor = UIColor(hex: "#E0E8FE")
        $0.frame = CGRect(
            x: 14,
            y: view.frame.height - 77,
            width: view.frame.width - 2 * 14,
            height: 55
        )
        $0.layer.cornerRadius = 55 / 2
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 50, bottom: -10, right: 50)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        tabBar.isHidden = true
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        // (Дополнительно) Устанавливаем цвет фона таббара, если нужно
        tabBar.barTintColor = .white // Задайте нужный цвет фона
        tabBar.isTranslucent = false
        view.addSubview(customTabBar)
//        customTabBar.addArrangedSubview(UIView())
        customTabBar.addArrangedSubview(universitiesBtn)
        customTabBar.addArrangedSubview(olympiadsBtn)
        customTabBar.addArrangedSubview(destinatioBtn)
        customTabBar.addArrangedSubview(profileBtn)
//        customTabBar.addArrangedSubview(UIView())
        setupShadow()
    }
    
    private func setIcons(tag: Int) {
        [universitiesBtn, olympiadsBtn, destinatioBtn, profileBtn].forEach {button in
            button.unfillIcon()
            if button.getTag() == tag {
                button.fillIcon()
            }
        }
    }
    
    private func setupShadow() {
        customTabBar.layer.shadowColor = UIColor.black.cgColor // Цвет тени
        customTabBar.layer.shadowOpacity = 0.25                // Прозрачность тени (от 0 до 1)
        customTabBar.layer.shadowOffset = CGSize(width: 5, height: 5) // Смещение тени
        customTabBar.layer.shadowRadius = 10                 // Радиус размытия тени
        customTabBar.layer.masksToBounds = false             // Важно, чтобы тень выходила за границы
    }
}
