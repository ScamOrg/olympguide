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
    private let titleLabel: UILabel = UILabel()
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
        configureLabel()
        configureSearchButton()
        configureFilterSortView()
        configureTableView()
        interactor?.loadOlympiads(
            Olympiads.Load.Request(sortOption: nil, searchQuery: nil, levels: nil, profiles: nil)
        )
        
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
    
    private func configureLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.font = Constants.Fonts.titleLabelFont
        titleLabel.textColor = Constants.Colors.titleLabelTextColor
        titleLabel.text = Constants.Strings.olympiadsTitle
        titleLabel.textAlignment = .center
        
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.titleLabelTopMargin)
        titleLabel.pinLeft(to: view.leadingAnchor, Constants.Dimensions.titleLabelLeftMargin)
    }
    
    private func configureFilterSortView() {
        view.addSubview(filterSortView)
        filterSortView.pinLeft(to: view.leadingAnchor)
        filterSortView.pinRight(to: view.trailingAnchor)
    }
    
    private func configureSearchButton() {
        view.addSubview(searchButton)
        
        searchButton.setHeight(Constants.Dimensions.searchButtonSize)
        searchButton.setWidth(Constants.Dimensions.searchButtonSize)
        searchButton.pinCenterY(to: titleLabel.centerYAnchor)
        searchButton.pinRight(to: view.trailingAnchor, Constants.Dimensions.searchButtonRightMargin)
        
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
    }
    
    // MARK: - Private funcs
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13)
        
        NSLayoutConstraint.activate([
            tableViewTopConstraint,
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
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
    private func didTapSearchButton() {
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
            searchButton.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            let searchScaledWidth = searchButton.bounds.width * (1 - scaleFactor)
            
            titleLabel.transform = titleLabel.transform.translatedBy(x: -scaledWidth / 2, y: -YTranslated)
            searchButton.transform = searchButton.transform.translatedBy(x: searchScaledWidth, y: -YTranslated)
            
            tableViewTopConstraint.constant = Constants.Dimensions.tableViewTopMargin - YTranslated
            
            view.layoutIfNeeded()
            view.layoutIfNeeded()
        } else {
            searchButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            titleLabel.transform = titleLabel.transform.translatedBy(x: -scaledWidth / 2, y: 0)
        }
    }
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
