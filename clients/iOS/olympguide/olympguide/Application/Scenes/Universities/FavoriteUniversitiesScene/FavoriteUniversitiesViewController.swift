//
//  FavoriteUniversitiesViewController.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
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
        static let universitiesTitle = "Избранные ВУЗы"
        static let backButtonTitle = "Избранные"
    }
    
    enum Images {
        static let searchIcon: String =  "magnifyingglass"
    }
}

class FavoriteUniversitiesViewController: UIViewController {
    
    // MARK: - VIP
    var interactor: (UniversitiesDataStore & UniversitiesBusinessLogic)?
    var router: UniversitiesRoutingLogic?
    
    // MARK: - Variables
    private let tableView = UITableView()
    private let titleLabel: UILabel = UILabel()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    private var universities: [Universities.Load.ViewModel.UniversityViewModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureRefreshControl()
        configureTableView()
        
        interactor?.loadUniversities(
            Universities.Load.Request(params: Dictionary<String, Set<String>>())
        )
        
        let backItem = UIBarButtonItem(title: Constants.Strings.backButtonTitle, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    

    private func configureNavigationBar() {
        navigationItem.title = Constants.Strings.universitiesTitle
        
        if let navigationController = self.navigationController as? NavigationBarViewController {
            navigationController.searchButtonPressed = { [weak self] sender in
                self?.router?.routeToSearch()
            }
        }
    }
    
    func configureRefreshControl() {
        refreshControl.tintColor = Constants.Colors.refreshTint
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    
    // MARK: - Private funcs
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        
        tableView.register(UniversityTableViewCell.self,
                           forCellReuseIdentifier: "UniversityTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Constants.Colors.tableViewBackground
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
    }
    
    @objc
    private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.interactor?.loadUniversities(
                Universities.Load.Request(params: Dictionary<String, Set<String>>())
            )
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FavoriteUniversitiesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "UniversityTableViewCell",
            for: indexPath
        ) as! UniversityTableViewCell
        
        let universityViewModel = universities[indexPath.row]
        cell.configure(with: universityViewModel)
        return cell
    }
}

extension FavoriteUniversitiesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let universityModel = interactor?.universities[indexPath.row] else { return }
        router?.routeToDetails(for: universityModel)
    }
}

extension FavoriteUniversitiesViewController: UniversitiesDisplayLogic {
    func displayError(message: String) {
        
    }
    
    func displayUniversities(viewModel: Universities.Load.ViewModel) {
        universities = viewModel.universities
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if self.universities.isEmpty {
                let emptyLabel = UILabel(frame: self.tableView.bounds)
                emptyLabel.text = "Избранных ВУЗов пока нет"
                emptyLabel.textAlignment = .center
                emptyLabel.textColor = .black
                emptyLabel.font = UIFont(name: "MontserratAlternates-SemiBold", size: 18)
                self.tableView.backgroundView = emptyLabel
            } else {
                self.tableView.backgroundView = nil
            }
            
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

