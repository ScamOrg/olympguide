//
//  FieldsViewController.swift
//  olympguide
//
//  Created by Tom Tim on 11.01.2025.
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
        static let fieldsTitle = "Направления"
        static let backButtonTitle = "Направления"
    }
    
    enum Images {
        static let searchIcon: String = "magnifyingglass"
    }
}

class FieldsViewController: UIViewController, FieldsDisplayLogic, MainVC {
    
    // MARK: - VIP
    var interactor: (FieldsDataStore & FieldsBusinessLogic)?
    var router: FieldsRoutingLogic?
    
    // MARK: - Variables
    private let tableView = UITableView()
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Constants.Colors.refreshTint
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var filterSortView: FilterSortView = {
        let view = FilterSortView(
            filteringOptions: ["Формат обучения"]
        )
        view.delegate = self
        return view
    }()
    
    private var fields: [Fields.Load.ViewModel.GroupOfFieldsViewModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        configureNavigationBar()
        configureTableView()
        
        interactor?.loadFields(
            Fields.Load.Request(searchQuery: nil, degree: nil)
        )
        
        let backItem = UIBarButtonItem(
            title: Constants.Strings.backButtonTitle,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem = backItem
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    // MARK: - Methods (FieldsDisplayLogic)
    func displayFields(viewModel: Fields.Load.ViewModel) {
        fields = viewModel.groupsOfFields
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func displayError(message: String) {
        print("Error: \(message)")
    }
    
    // MARK: - Private setup
    private func setup() {
        let viewController = self
        let interactor = FieldsInteractor()
        let presenter = FieldsPresenter()
        let router = FieldsRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    private func configureNavigationBar() {
        navigationItem.title = Constants.Strings.fieldsTitle
        
        if let navigationController = self.navigationController as? NavigationBarViewController {
            navigationController.setSearchButtonAction(target: self, action: #selector (didTapSearchButton))
        }
    }
    
    private func configureFilterSortView() {
        view.addSubview(filterSortView)
        filterSortView.pinLeft(to: view.leadingAnchor)
        filterSortView.pinRight(to: view.trailingAnchor)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        
        tableView.register(
            FieldTableViewCell.self,
            forCellReuseIdentifier: FieldTableViewCell.identifier
        )
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "ReusableHeader")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Constants.Colors.tableViewBackground
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = true
        
        let headerContainer = UIView()
        headerContainer.backgroundColor = .clear
        
        headerContainer.addSubview(filterSortView)
        
        filterSortView.pinTop(to: headerContainer.topAnchor, Constants.Dimensions.tableViewTopMargin)
        filterSortView.pinLeft(to: headerContainer.leadingAnchor)
        filterSortView.pinRight(to: headerContainer.trailingAnchor)
        filterSortView.pinBottom(to: headerContainer.bottomAnchor, 21)
        
        
        headerContainer.layoutIfNeeded()
        
        let targetSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let height = headerContainer.systemLayoutSizeFitting(targetSize).height
        
        headerContainer.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: height)
        
        tableView.tableHeaderView = headerContainer
    }
    
    // MARK: - Actions
    @objc
    private func didTapSearchButton() {
        router?.routeToSearch()
    }
    
    @objc
    private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.interactor?.loadFields(
                Fields.Load.Request(searchQuery: nil, degree: nil)
            )
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FieldsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields[section].isExpanded ? fields[section].fields.count : 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FieldTableViewCell.identifier,
            for: indexPath
        ) as! FieldTableViewCell
        
        let fieldViewModel = fields[indexPath.section].fields[indexPath.row]
        cell.configure(with: fieldViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let fieldModel = interactor?.groupsOfFields[indexPath.section].fields[indexPath.row] else {
            return
        }
        router?.routeToDetails(for: fieldModel)
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerButton = FieldsTableButton(name: fields[section].name, code: fields[section].code)
        headerButton.tag = section
        headerButton.addTarget(self, action: #selector(toggleSection), for: .touchUpInside)
        
        if fields[section].isExpanded {
            headerButton.backgroundView.backgroundColor = UIColor(hex: "#E0E8FE")
        }
        return headerButton
    }
    
    @objc func toggleSection(_ sender: UIButton) {
        let section = sender.tag
        
        var currentOffset = tableView.contentOffset
        let headerRectBefore = tableView.rectForHeader(inSection: section)
        
        fields[section].isExpanded.toggle()
        
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet(integer: section), with: .none)
            tableView.layoutIfNeeded()
        }
        let headerRectAfter = tableView.rectForHeader(inSection: section)
        
        let deltaY = headerRectAfter.origin.y - headerRectBefore.origin.y
        currentOffset.y += deltaY
        tableView.setContentOffset(currentOffset, animated: false)
    }
}

// MARK: - FilterSortViewDelegate
extension FieldsViewController: FilterSortViewDelegate {
    
    func filterSortViewDidTapSortButton(_ view: FilterSortView) {
    }
    
    func filterSortView(_ view: FilterSortView,
                        didTapFilterWithTitle title: String) {
        switch title {
        case "Формат обучения":
            let items = ["Бакалавриат", "Специалитет"]
            let sheetVC = OptionsViewController(items: items,
                                                title: title,
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


class ReusableHeader: UITableViewHeaderFooterView {
    override func prepareForReuse() {
        super.prepareForReuse()
        print("Header is about to be reused!")
    }
}
