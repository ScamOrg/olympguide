//
//  OlympiadsViewController.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
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
        static let olympiadsTitle = "Олимпиады"
        static let backButtonTitle = "Олимпиады"
    }
    
    enum Images {
        static let searchIcon: String =  "magnifyingglass"
    }
}

final class OlympiadsViewController: UIViewController, OlympiadsDisplayLogic {
    
    // MARK: - VIP
    var interactor: (OlympiadsDataStore & OlympiadsBusinessLogic)?
    var router: OlympiadsRoutingLogic?
    
    // MARK: - Variables
    private let tableView = UITableView()
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Constants.Colors.refreshTint
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: Constants.Images.searchIcon), for: .normal)
        button.tintColor = Constants.Colors.searchButtonTint
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private var tableViewTopConstraint: NSLayoutConstraint!
    
    private lazy var filterSortView: FilterSortView = {
        let view = FilterSortView(
            sortingOptions: ["Сортировка A"],
            filteringOptions: ["Профиль", "Уровень"]
        )
        view.delegate = self
        return view
    }()
    
    private var olympiads: [Olympiads.Load.ViewModel.OlympiadViewModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureNavigationBar()
        
        //        configureSearchButton()
        configureFilterSortView()
        configureTableView()
        interactor?.loadOlympiads(
            Olympiads.Load.Request(sortOption: nil, searchQuery: nil, levels: nil, profiles: nil)
        )
        
        let backItem = UIBarButtonItem(title: Constants.Strings.backButtonTitle, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let navigationBar = navigationController?.navigationBar else { return }

//        let customView = UIButton(type: .system)
//        customView.setImage(UIImage(systemName: Constants.Images.searchIcon), for: .normal)
//        customView.tintColor = Constants.Colors.searchButtonTint
//        customView.translatesAutoresizingMaskIntoConstraints = false
//        customView.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        
        navigationBar.addSubview(searchButton)
        searchButton.alpha = 1.0
        searchButton.setWidth(Constants.Dimensions.searchButtonSize)
        searchButton.setHeight(Constants.Dimensions.searchButtonSize)
        searchButton.addTarget(self, action:#selector (didTapSearchButton), for: .touchUpInside)
        // Располагаем кнопку в правой части навигационной панели, можно настроить по желанию
        NSLayoutConstraint.activate([
            searchButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -Constants.Dimensions.searchButtonRightMargin),
            searchButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -8), // регулируйте отступ по необходимости
            searchButton.widthAnchor.constraint(equalToConstant: Constants.Dimensions.searchButtonSize),
            searchButton.heightAnchor.constraint(equalToConstant: Constants.Dimensions.searchButtonSize)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchButton.alpha = 0.0
    }
    
    // MARK: - Methods
    func displayOlympiads(viewModel: Olympiads.Load.ViewModel) {
        olympiads = viewModel.olympiads
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func displayError(message: String) {
        print("Error: \(message)")
    }
    
    private func setup() {
        let viewController = self
        let interactor = OlympiadsInteractor()
        let presenter = OlympiadsPresenter()
        let router = OlympiadsRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Constants.Strings.olympiadsTitle
        
        
        if let navigationController = self.navigationController as? NavigationBarViewController {
            navigationController.setMiniSearchButtonAction(target: self, action: #selector (didTapSearchButton))
        }
        
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
        
        tableView.register(OlympiadTableViewCell.self,
                           forCellReuseIdentifier: "OlympiadTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Constants.Colors.tableViewBackground
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        
        let headerContainer = UIView()
        headerContainer.backgroundColor = .clear
        
        headerContainer.addSubview(filterSortView)
        
        filterSortView.pinTop(to: headerContainer.topAnchor, 13)
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
    private func didTapSearchButton(sender: UIButton) {
        guard sender.alpha == 1 else { return }
        router?.routeToSearch()
    }
    
    @objc
    private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.interactor?.loadOlympiads(
                Olympiads.Load.Request(sortOption: nil, searchQuery: nil, levels: nil, profiles: nil)
            )
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension OlympiadsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return olympiads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "OlympiadTableViewCell",
            for: indexPath
        ) as! OlympiadTableViewCell
        let olympiadViewModel = olympiads[indexPath.row]
        cell.configure(with: olympiadViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let olympiadModel = interactor?.olympiads[indexPath.row] else { return }
        router?.routeToDetails(for: olympiadModel)
    }
    
//        func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            let offset = scrollView.contentOffset.y
////            if offset >= -113  {
////                navigationItem.title = ""
////            }
////            else {
////                navigationItem.title = "Олимпиады"
////            }
//        }
}

// MARK: - FilterSortViewDelegate
extension OlympiadsViewController: FilterSortViewDelegate {
    
    func filterSortViewDidTapSortButton(_ view: FilterSortView) {
        let items = ["По возрастанию", "По убыванию"]
        let sheetVC = OptionsViewController(items: items,
                                            title: "Сортировка",
                                            isMultipleChoice: false)
        sheetVC.modalPresentationStyle = .overFullScreen
        present(sheetVC, animated: false) {
            sheetVC.animateShow()
        }
    }
    
    func filterSortView(_ view: FilterSortView, didTapFilterWithTitle title: String) {
        switch title {
        case "Профиль":
            let items = ["Математика", "Информатика"]
            let sheetVC = OptionsViewController(items: items,
                                                title: "Профиль",
                                                isMultipleChoice: true)
            sheetVC.modalPresentationStyle = .overFullScreen
            present(sheetVC, animated: false) {
                sheetVC.animateShow()
            }
        case "Уровень":
            let items = ["I уровень", "II уровень", "III уровень"]
            let sheetVC = OptionsViewController(items: items,
                                                title: "Уровень",
                                                isMultipleChoice: true)
            sheetVC.modalPresentationStyle = .overFullScreen
            present(sheetVC, animated: false) {
                sheetVC.animateShow()
            }
        default:
            break
        }
    }
}
