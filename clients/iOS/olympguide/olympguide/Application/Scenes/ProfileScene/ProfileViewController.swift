//
//  ProfileViewController.swift
//  olympguide
//
//  Created by Tom Tim on 10.01.2025.
//

import UIKit

// MARK: - Constants
fileprivate enum Constants {
    enum Colors {
        static let refreshTint = UIColor.systemCyan
        static let searchButtonTint = UIColor.black
        static let tableViewBackground = UIColor.white
        static let titleLabelTextColor = UIColor.black
    }
    
    enum Fonts {
        static let titleLabelFont = UIFont(name: "MontserratAlternates-Bold", size: 28)!
    }
    
    enum Dimensions {
        static let titleLabelTopMargin: CGFloat = 25
        static let titleLabelLeftMargin: CGFloat = 20
        static let searchButtonSize: CGFloat = 33
        static let searchButtonRightMargin: CGFloat = 20
        static let tableViewTopMargin: CGFloat = 13
    }
    
    enum Strings {
        static let profileTitle = "Профиль"
        static let backButtonTitle = "Профиль"
    }
    
    enum Images {
        static let searchIcon: String =  "magnifyingglass"
    }
}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        
        let backItem = UIBarButtonItem(title: Constants.Strings.backButtonTitle, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    private func configureNavigationBar() {
        navigationItem.title = Constants.Strings.profileTitle
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        
        tableView.frame = view.bounds
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ProfileButtonTableViewCell.self, forCellReuseIdentifier: ProfileButtonTableViewCell.reuseIdentifier)
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier)
        
        let headerContainer = UIView()
        headerContainer.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 10)
        
        tableView.tableHeaderView = headerContainer
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8 // 2 кнопки + 6 пунктов меню
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileButtonTableViewCell.reuseIdentifier, for: indexPath) as! ProfileButtonTableViewCell
            cell.configure(title: "Зарегистрироваться", borderColor: UIColor(hex: "#FF2D55")!, textColor: .black)
            cell.actionButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileButtonTableViewCell.reuseIdentifier, for: indexPath) as! ProfileButtonTableViewCell
            cell.configure(title: "Войти", borderColor: UIColor(hex: "#32ADE6")!, textColor: .black)
            cell.actionButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reuseIdentifier, for: indexPath) as! ProfileTableViewCell
            switch indexPath.row {
            case 2:
                cell.configure(title: "Регион", detail: "Москва")
            case 3:
                cell.configure(title: "Избранные ВУЗы")
            case 4:
                cell.configure(title: "Избранные направления")
            case 5:
                cell.configure(title: "Избранные олимпиады")
            case 6:
                cell.configure(title: "Настройка уведомлений")
            case 7:
                cell.configure(title: "О нас")
                cell.hideSeparator(true)
            default:
                break
            }
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    @objc private func registerButtonTapped() {
        let enterEmailVC = EnterEmailViewController()
        enterEmailVC.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(enterEmailVC, animated: true)
    }
    
    @objc private func loginButtonTapped() {
        print("Войти нажато")
//        let searchVC = VerificateEmailViewController(email: "pankravvlad1@gmail.com")
        let searchVC = CodeInputViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
}
