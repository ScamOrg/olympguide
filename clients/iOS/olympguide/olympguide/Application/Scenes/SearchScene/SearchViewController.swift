//
//  SearchViewController.swift
//  olympguide
//
//  Created by Tom Tim on 01.01.2025.
//

import UIKit

final class SearchViewController: UIViewController, SearchDisplayLogic {
    
    // MARK: - VIP
    var interactor: SearchBusinessLogic?
    var router: (SearchRoutingLogic & SearchDataPassing)?
    
    // MARK: - UI
    private let customSearchBar: CustomSearchBar
    private let tableView = UITableView()
    
    private var itemsToShow: [String] = []
    
    // MARK: - LifeCycle
    init(searchType: SearchType) {
        customSearchBar = CustomSearchBar(title: searchType.title())
        super.init(nibName: nil, bundle: nil)
        setup()
        
        router?.dataStore?.searchType = searchType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadScene()
    }
    
    // MARK: - Setup VIP
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
    
    // MARK: - UI
    private func setupUI() {
        view.backgroundColor = .white
        
        // Скрываем стандартную кнопку "Назад", чтобы остался только свайп
//        navigationItem.hidesBackButton = true
        
        // Создаём контейнер для кастомного поискового бара
        
//        // Назначаем контейнер в качестве titleView
//        navigationItem.titleView = containerView
        
        // Добавляем CustomSearchBar в контейнер
        customSearchBar.delegate = self
        customSearchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customSearchBar)

        customSearchBar.setHeight(48)
        customSearchBar.setWidth( UIScreen.main.bounds.width - 2 * 20)
        customSearchBar.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        customSearchBar.pinLeft(to: view.leadingAnchor, 20)
        
        // Настраиваем tableView
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.pinTop(to: customSearchBar.bottomAnchor, 10)
        tableView.pinLeft(to: view.leadingAnchor)
        tableView.pinRight(to: view.trailingAnchor)
        tableView.pinBottom(to: view.bottomAnchor)
    }
    
    private func loadScene() {
        // Если searchType уже был записан извне:
        if let searchType = router?.dataStore?.searchType {
            let request = Search.Load.Request(searchType: searchType)
            interactor?.loadScene(request: request)
        } else {
            // Дефолтное поведение
            let request = Search.Load.Request(searchType: .other)
            interactor?.loadScene(request: request)
        }
    }
    
    // MARK: - SearchDisplayLogic
    func displayLoadScene(viewModel: Search.Load.ViewModel) {
        title = "Поиск"
//        title = viewModel.navBarTitle
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
extension SearchViewController: CustomSearchBarDelegate {
    func customSearchBar(_ searchBar: CustomSearchBar, textDidChange text: String) {
        let request = Search.TextDidChange.Request(query: text)
        interactor?.textDidChange(request: request)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    // Кол-во строк = кол-во элементов в массиве
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToShow.count
    }
    
    // Конфигурация ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = itemsToShow[indexPath.row]
        return cell
    }
    
    // Обработка нажатия на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = Search.SelectItem.Request(index: indexPath.row)
        interactor?.selectItem(request: request)
    }
}
