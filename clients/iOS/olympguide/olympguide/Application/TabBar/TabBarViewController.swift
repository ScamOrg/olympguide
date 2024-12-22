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
    
    private lazy var customTabBar: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.backgroundColor = .cyan
        $0.frame = CGRect(
            x: 14,
            y: view.frame.height - 77,
            width: view.frame.width - 2 * 14,
            height: 55
        )
        $0.layer.cornerRadius = 55 / 2
        return $0
    }(UIStackView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(customTabBar)
        configureUI()
    }
    
    private func configureUI() {
        
    }
}
