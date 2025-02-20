//
//  ProfileViewController.swift
//  olympguide
//
//  Created by Tom Tim on 10.01.2025.
//

import UIKit
import Combine

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

class ProfileViewController: UIViewController {
    var router: ProfileRoutingLogic?
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var authCancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        
        let backItem = UIBarButtonItem(title: Constants.Strings.backButtonTitle, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        authCancellable = AuthManager.shared.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
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
    
    // MARK: - Actions
    @objc private func registerButtonTapped() {
        router?.routeToSignUp()
    }
    
    @objc private func loginButtonTapped() {
        router?.routeToSignIn()
    }
    
    @objc private func logoutButtonTapped() {
        AuthManager.shared.logout()
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AuthManager.shared.isAuthenticated {
            return 9
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !AuthManager.shared.isAuthenticated {
            if indexPath.row == 0 {
                let cell = ProfileButtonTableViewCell()
                cell.configure(title: "Зарегистрироваться", borderColor: UIColor(hex: "#FF2D55")!, textColor: .black)
                cell.actionButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
                return cell
            } else if indexPath.row == 1 {
                let cell = ProfileButtonTableViewCell()
                cell.configure(title: "Войти", borderColor: UIColor(hex: "#32ADE6")!, textColor: .black)
                cell.actionButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
                return cell
            } else {
                let cell = ProfileTableViewCell()
                switch indexPath.row {
                case 2:
                    cell.configure(title: "Регион", detail: "Москва")
                case 3:
                    cell.configure(title: "Тема приложения")
                case 4:
                    cell.configure(title: "О нас")
                    cell.hideSeparator(true)
                default:
                    break
                }
                return cell
            }
        } else {
            if indexPath.row <= 7 {
                let cell = ProfileTableViewCell()
                switch indexPath.row {
                case 0:
                    cell.configure(title: "Регион", detail: "Москва")
                case 1:
                    cell.configure(title: "Личные данные")
                case 2:
                    cell.configure(title: "Мои дипломы")
                case 3:
                    cell.configure(title: "Избранные ВУЗы")
                case 4:
                    cell.configure(title: "Избранные олимпиады")
                case 5:
                    cell.configure(title: "Настройка уведомлений")
                case 6:
                    cell.configure(title: "Тема приложения")
                case 7:
                    cell.configure(title: "О нас")
                    cell.hideSeparator(true)
                default:
                    break
                }
                return cell
            }
            else {
                let cell = ProfileButtonTableViewCell()
                cell.configure(title: "Выйти", borderColor: UIColor(hex: "#FF2D55")!, textColor: .black)
                cell.actionButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
                return cell
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
