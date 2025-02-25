//
//  ProgramsByFacultiesViewController.swift
//  olympguide
//
//  Created by Tom Tim on 25.02.2025.
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
        static let fieldsTitle = "Факультеты"
        static let backButtonTitle = "Факультеты"
    }
    
    enum Images {
        static let searchIcon: String = "magnifyingglass"
    }
}

class ProgramsByFacultiesViewController: UIViewController, MainVC {
    
    // MARK: - VIP
    var interactor: (ProgramsByFacultiesDataStore & ProgramsByFacultiesBusinessLogic)?
    var router: ProgramsByFacultiesRoutingLogic?
    
    // MARK: - Variables
    private let tableView = UITableView()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private let university: UniversityModel
    
    private lazy var filterSortView: FilterSortView = {
        let view = FilterSortView(
            filteringOptions: ["Формат обучения"]
        )
        view.delegate = self
        return view
    }()
    
    private var groupOfProgramsViewModel: [ProgramsByFaculties.Load.ViewModel.GroupOfProgramsViewModel] = []
    
    init(for university: UniversityModel) {
        self.university = university
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureRefreshControl()
        configureTableView()
        
        let request = Programs.Load.Request(
            params: [],
            universityID: university.universityID
        )
        interactor?.loadPrograms(with: request)
        
        let backItem = UIBarButtonItem(
            title: Constants.Strings.backButtonTitle,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backBarButtonItem = backItem
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.title = Constants.Strings.fieldsTitle
        
        if let navigationController = self.navigationController as? NavigationBarViewController {
            navigationController.searchButtonPressed = { [weak self] _ in
                self?.router?.routeToSearch()
            }
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
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        
        tableView.register(
            ProgramTableViewCell.self,
            forCellReuseIdentifier: ProgramTableViewCell.identifier
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
    private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let request = Programs.Load.Request(params: [], universityID: 1)
            self.interactor?.loadPrograms(with: request)
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ProgramsByFacultiesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupOfProgramsViewModel.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return groupOfProgramsViewModel[section].isExpanded ? groupOfProgramsViewModel[section].programs.count : 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ProgramTableViewCell.identifier,
            for: indexPath
        ) as! ProgramTableViewCell
        
        let fieldViewModel = groupOfProgramsViewModel[indexPath.section].programs[indexPath.row]
        cell.configure(with: fieldViewModel)
        
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        let isLastCell = indexPath.row == totalRows - 1
        
        if isLastCell {
            cell.hideSeparator()
        }
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let headerButton = FieldsTableButton(name: groupOfProgramsViewModel[section].name, code: "")
        headerButton.tag = section
        headerButton.addTarget(self, action: #selector(toggleSection), for: .touchUpInside)
        
        if groupOfProgramsViewModel[section].isExpanded {
            headerButton.backgroundView.backgroundColor = UIColor(hex: "#E0E8FE")
        }
        return headerButton
    }
    
    @objc
    func toggleSection(_ sender: UIButton) {
        let section = sender.tag
        
        var currentOffset = tableView.contentOffset
        let headerRectBefore = tableView.rectForHeader(inSection: section)
        
        groupOfProgramsViewModel[section].isExpanded.toggle()
        
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
extension ProgramsByFacultiesViewController: FilterSortViewDelegate {
    func filterSortViewDidTapSortButton(_ view: FilterSortView) {
    }
    
    func filterSortView(_ view: FilterSortView,
                        didTapFilterWith title: String) {
       
    }
}

extension ProgramsByFacultiesViewController: ProgramsByFacultiesDisplayLogic {
    func displayLoadProgramsResult(with viewModel: ProgramsByFaculties.Load.ViewModel) {
        groupOfProgramsViewModel = viewModel.groupsOfPrograms
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

