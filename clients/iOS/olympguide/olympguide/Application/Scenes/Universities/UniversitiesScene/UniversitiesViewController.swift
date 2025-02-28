//
//  UniversitiesViewController.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
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
        static let universitiesTitle = "ВУЗы"
        static let backButtonTitle = "ВУЗы"
    }
    
    enum Images {
        static let searchIcon: String =  "magnifyingglass"
    }
}

class UniversitiesViewController: UIViewController, WithSearchButton {
    
    // MARK: - VIP
    var interactor: (UniversitiesDataStore & UniversitiesBusinessLogic)?
    var router: UniversitiesRoutingLogic?
    
    // MARK: - Variables
    private let tableView = UITableView()
    private let titleLabel: UILabel = UILabel()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    private lazy var filterSortView: FilterSortView = {
        let view = FilterSortView(
            sortingOptions: ["Сортировка A", "Сортировка B"],
            filteringOptions: ["Регион"]
        )
        view.delegate = self
        return view
    }()
    
    private var universities: [Universities.Load.ViewModel.UniversityViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureRefreshControl()
        configureFilterSortView()
        configureTableView()
        setupBindings()
        interactor?.loadUniversities(
            Universities.Load.Request(params: Dictionary<String, Set<String>>())
        )
    }
    
    // MARK: - Methods
    func displayError(message: String) {
        print("Error: \(message)")
    }
    
    private func configureNavigationBar() {
        let backItem = UIBarButtonItem(
            title: Constants.Strings.backButtonTitle,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem = backItem
        
        navigationItem.title = Constants.Strings.universitiesTitle
        
        guard let navigationController = self.navigationController as? NavigationBarViewController else {return}
        navigationController.searchButtonPressed = { [weak self] sender in
            self?.router?.routeToSearch()
        }
    }
    
    func configureRefreshControl() {
        refreshControl.tintColor = Constants.Colors.refreshTint
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func configureFilterSortView() {
        view.addSubview(filterSortView)
        filterSortView.pinLeft(to: view.leadingAnchor)
        filterSortView.pinRight(to: view.trailingAnchor)
    }
    
    // MARK: - Private funcs
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        
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
        
        let headerContainer = UIView()
        headerContainer.backgroundColor = .clear
        
        headerContainer.addSubview(filterSortView)
        
        filterSortView.pinTop(to: headerContainer.topAnchor)
        filterSortView.pinLeft(to: headerContainer.leadingAnchor)
        filterSortView.pinRight(to: headerContainer.trailingAnchor)
        filterSortView.pinBottom(to: headerContainer.bottomAnchor)
        
        headerContainer.layoutIfNeeded()
        
        let targetSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let height = headerContainer.systemLayoutSizeFitting(targetSize).height
        
        headerContainer.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: height)
        
        tableView.tableHeaderView = headerContainer
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
extension UniversitiesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (universities.count != 0) ? universities.count : 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "UniversityTableViewCell",
            for: indexPath
        ) as? UniversityTableViewCell
        else {
            fatalError("Could not dequeue cell")
        }
        
        if universities.count != 0 {
            let universityViewModel = universities[indexPath.row]
            cell.configure(with: universityViewModel)
            cell.favoriteButtonTapped = { [weak self] sender, isFavorite in
                guard let self = self else { return }
                if isFavorite {
                    self.universities[indexPath.row].like = true
                    let viewModel = self.universities[indexPath.row]
                    FavoritesManager.shared.addUniversityToFavorites(viewModel: viewModel)
                    
                } else {
                    FavoritesManager.shared.removeUniversityFromFavorites(universityID: sender.tag)
                    self.universities[indexPath.row].like = false
                }
                
                FavoritesBatcher.shared.addUniversityChange(
                    universityID: sender.tag,
                    isFavorite: isFavorite
                )
            }
        } else {
            cell.configureShimmer()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let universityModel = interactor?.universities[indexPath.row] else { return }
        router?.routeToDetails(for: universityModel)
    }
}

// MARK: - FilterSortViewDelegate
extension UniversitiesViewController: FilterSortViewDelegate {
    
    func filterSortViewDidTapSortButton(_ view: FilterSortView) {
    }
    
    func filterSortView(_ view: FilterSortView, didTapFilterWith title: String) {
    }
}

extension UniversitiesViewController: UniversitiesDisplayLogic {
    func displayUniversities(viewModel: Universities.Load.ViewModel) {
        universities = viewModel.universities
        for i in 0..<universities.count {
            let universityID = universities[i].universityID
            let like = universities[i].like
            universities[i].like = isFavorite(univesityID: universityID, serverValue: like)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}


// MARK: - Combine
extension UniversitiesViewController {
    private func setupBindings() {
        FavoritesManager.shared.universityEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .added(let updatedUniversity):
                    if let index = self.universities.firstIndex(where: {
                        $0.universityID == updatedUniversity.universityID
                    }) {
                        self.universities[index].like = true
                        self.tableView.reloadRows(
                            at: [IndexPath(row: index, section: 0)],
                            with: .automatic
                        )
                    }
                case .removed(let universityID):
                    if let index = self.universities.firstIndex(where: { $0.universityID == universityID }) {
                        self.universities[index].like = false
                        self.tableView.reloadRows(
                            at: [IndexPath(row: index, section: 0)],
                            with: .automatic
                        )
                    }
                case .error(let universityID):
                    if let index = self.universities.firstIndex(where: { $0.universityID == universityID }) {
                        self.tableView.reloadRows(
                            at: [IndexPath(row: index, section: 0)],
                            with: .automatic
                        )
                        self.universities[index].like = self.interactor?.universities[index].like ?? false
                    }
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
