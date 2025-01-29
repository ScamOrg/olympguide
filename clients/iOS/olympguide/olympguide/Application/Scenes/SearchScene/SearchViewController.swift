//
//  SearchViewController.swift
//  olympguide
//
//  Created by Tom Tim on 01.01.2025.
//

import UIKit

// MARK: - Constants
fileprivate enum Constants {
    enum Dimensions {
        static let searchBarHeight: CGFloat = 48
        static let searchBarHorizontalMargin: CGFloat = 20
        static let tableViewTopMargin: CGFloat = 10
    }
}

final class SearchViewController: UIViewController, SearchDisplayLogic {
    
    // MARK: - VIP
    var interactor: SearchBusinessLogic?
    var router: (SearchRoutingLogic & SearchDataPassing)?
    
    // MARK: - Variables
    private let customSearchBar: CustomSearchBar
    private let tableView = UITableView()
    private var itemsToShow: [String] = []
    
    // MARK: - Lifecycle
    init(searchType: SearchType) {
        customSearchBar = CustomSearchBar(with: searchType.title())
        super.init(nibName: nil, bundle: nil)
        setup()
        router?.dataStore?.searchType = searchType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        setupUI()
        loadScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customSearchBar.didTapSearchBar()
    }
    
    // MARK: - Methods
    private func setup() {
        let viewController = self
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        customSearchBar.delegate = self
        view.addSubview(customSearchBar)
        
//        customSearchBar.setHeight(Constants.Dimensions.searchBarHeight)
//        customSearchBar.setWidth(UIScreen.main.bounds.width - 2 * Constants.Dimensions.searchBarHorizontalMargin)
        customSearchBar.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        customSearchBar.pinLeft(to: view.leadingAnchor, Constants.Dimensions.searchBarHorizontalMargin)
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.pinTop(to: customSearchBar.bottomAnchor, Constants.Dimensions.tableViewTopMargin)
        tableView.pinLeft(to: view.leadingAnchor)
        tableView.pinRight(to: view.trailingAnchor)
        tableView.pinBottom(to: view.bottomAnchor)
    }
    
    private func loadScene() {
        if let searchType = router?.dataStore?.searchType {
            let request = Search.Load.Request(searchType: searchType)
            interactor?.loadScene(request: request)
        } else {
            let request = Search.Load.Request(searchType: .fields)
            interactor?.loadScene(request: request)
        }
    }
    
    // MARK: - SearchDisplayLogic
    func displayLoadScene(viewModel: Search.Load.ViewModel) {
        title = "Поиск"
    }
    
    func displayTextDidChange(viewModel: Search.TextDidChange.ViewModel) {
        itemsToShow = viewModel.items
        tableView.reloadData()
    }
    
    func displaySelectItem(viewModel: Search.SelectItem.ViewModel) {
        router?.routeToSomeNextScene(selected: viewModel.selectedItemTitle)
    }
}

// MARK: - CustomSearchBarDelegate
extension SearchViewController: CustomTextFieldDelegate {
    func customSearchBar(_ searchBar: CustomTextField, textDidChange text: String) {
        let request = Search.TextDidChange.Request(query: text)
        interactor?.textDidChange(request: request)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = itemsToShow[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = Search.SelectItem.Request(index: indexPath.row)
        interactor?.selectItem(request: request)
    }
}
