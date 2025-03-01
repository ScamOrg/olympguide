//
//  FavoriteUniversitiesViewController.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
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
    private var cancellables = Set<AnyCancellable>()
    
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
        setupBindings()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        universities = universities.map { university in
//            var modifiedUniversity = university
//            modifiedUniversity.like = isFavorite(
//                univesityID: university.universityID,
//                serverValue: university.like
//            )
//            return modifiedUniversity
//        }.filter { $0.like }
//        
//        tableView.reloadData()
//        tableView.backgroundView = getEmptyLabel()
//    }
    
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        tableView.register(
            UniversityTableViewCell.self,
            forCellReuseIdentifier: "UniversityTableViewCell"
        )
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

// MARK: - UITableViewDataSource
extension FavoriteUniversitiesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UniversityTableViewCell.identifier,
            for: indexPath
        ) as? UniversityTableViewCell else {
            fatalError()
        }
        
        let universityViewModel = universities[indexPath.row]
        cell.configure(with: universityViewModel)
        
        cell.favoriteButtonTapped = { [weak self] sender, isFavorite in
            guard let self = self else { return }
            
            if !isFavorite {
                FavoritesManager.shared.removeUniversityFromFavorites(universityID: sender.tag)
                self.universities[indexPath.row].like = false
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteUniversitiesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let universityModel = interactor?.universities[indexPath.row] else { return }
        router?.routeToDetails(for: universityModel)
    }
}

// MARK: - UniversitiesDisplayLogic
extension FavoriteUniversitiesViewController: UniversitiesDisplayLogic {
    func displayError(message: String) {
        
    }
    
    func displayUniversities(viewModel: Universities.Load.ViewModel) {
        universities = viewModel.universities.map { university in
            var modifiedUniversity = university
            modifiedUniversity.like = isFavorite(
                univesityID: university.universityID,
                serverValue: university.like
            )
            return modifiedUniversity
        }.filter { $0.like }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.tableView.backgroundView = getEmptyLabel()
            
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func getEmptyLabel() -> UILabel? {
        guard universities.isEmpty else { return nil }
        
        let emptyLabel = UILabel(frame: self.tableView.bounds)
        emptyLabel.text = "Избранных ВУЗов пока нет"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .black
        emptyLabel.font = UIFont(name: "MontserratAlternates-SemiBold", size: 18)
        
        return emptyLabel
    }
}

// MARK: - Combine
extension FavoriteUniversitiesViewController {
    private func setupBindings() {
        FavoritesManager.shared.universityEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .added(let university):
                    if !self.universities.contains(where: { $0.universityID == university.universityID }) {
                        let viewModel = Universities.Load.ViewModel.UniversityViewModel(
                            universityID: university.universityID,
                            name: university.name,
                            logoURL: university.logo,
                            region: university.region,
                            like: university.like ?? false
                        )
                        
                        let insertIndex = self.universities.firstIndex {$0.universityID > university.universityID} ?? self.universities.count
                        
                        self.interactor?.likeUniversity(university, at: insertIndex)
                        self.universities.insert(viewModel, at: insertIndex)
                        
                        let newIndex = IndexPath(row: self.universities.count - 1, section: 0)
                        self.tableView.insertRows(at: [newIndex], with: .automatic)
                        self.tableView.backgroundView = nil
                    }
                case .removed(let universityID):
                    if let index = self.universities.firstIndex(where: { $0.universityID == universityID }) {
                        if !self.universities[index].like { break }
                        self.universities.remove(at: index)
                        self.interactor?.dislikeUniversity(at: index)
                        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        self.tableView.backgroundView = self.getEmptyLabel()
                    }
                case .error(let universityID):
                    interactor?.handleBatchError(universityID: universityID)
                case .access(let universityID, let isFavorite):
                    interactor?.handleBatchSuccess(universityID: universityID, isFavorite: isFavorite)
                }
            }
            .store(in: &cancellables)
    }
    
    func isFavorite(univesityID: Int, serverValue: Bool) -> Bool {
        FavoritesManager.shared.isUniversityFavorited(
            universityID: univesityID,
            serverValue: serverValue
        )
    }
}

