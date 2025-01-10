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
        static let olympiadsTitle = "Профиль"
        static let backButtonTitle = "Профиль"
    }
    
    enum Images {
        static let searchIcon: String =  "magnifyingglass"
    }
}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let titleLabel: UILabel = UILabel()
    private var tableViewTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabel()
        setupTableView()
        
        let backItem = UIBarButtonItem(title: Constants.Strings.backButtonTitle, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configureLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.font = Constants.Fonts.titleLabelFont
        titleLabel.textColor = Constants.Colors.titleLabelTextColor
        titleLabel.text = Constants.Strings.olympiadsTitle
        titleLabel.textAlignment = .center
        
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.titleLabelTopMargin)
        titleLabel.pinLeft(to: view.leadingAnchor, Constants.Dimensions.titleLabelLeftMargin)
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13)
        
        NSLayoutConstraint.activate([
            tableViewTopConstraint,
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ProfileButtonTableViewCell.self, forCellReuseIdentifier: ProfileButtonTableViewCell.reuseIdentifier)
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier)
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
                cell.configure(title: "Личные данные")
            case 4:
                cell.configure(title: "Мои дипломы")
            case 5:
                cell.configure(title: "Ближайшие события")
            case 6:
                cell.configure(title: "Избранные ВУЗы")
            case 7:
                cell.configure(title: "О нас")
            default:
                break
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row > 1 else { return }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        let scaleFactor = min(1.2, max(0.75, 1 - offset / 200))
        
        titleLabel.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        let maxYTranslated: CGFloat = 30
        let k = -maxYTranslated / (1 - 0.75)
        let b = -k
        let YTranslated = k * scaleFactor + b
        
        let scaledWidth = titleLabel.bounds.width * (1 - scaleFactor)
        if scaleFactor <= 1 {
            titleLabel.transform = titleLabel.transform.translatedBy(x: -scaledWidth / 2, y: -YTranslated)
            
            tableViewTopConstraint.constant = Constants.Dimensions.tableViewTopMargin - YTranslated
            
            view.layoutIfNeeded()
            view.layoutIfNeeded()
        } else {
            titleLabel.transform = titleLabel.transform.translatedBy(x: -scaledWidth / 2, y: 0)
        }
    }
    
    // MARK: - Actions
    @objc private func registerButtonTapped() {
        print("Зарегистрироваться нажато")
    }
    
    @objc private func loginButtonTapped() {
        print("Войти нажато")
    }
}
