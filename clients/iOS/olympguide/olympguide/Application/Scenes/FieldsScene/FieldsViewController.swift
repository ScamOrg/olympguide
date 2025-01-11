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
        static let fieldsTitle = "ВУЗы"
        static let backButtonTitle = "ВУЗы"
    }
    
    enum Images {
        static let searchIcon: String = "magnifyingglass"
    }
}

class FieldsViewController: UIViewController, FieldsDisplayLogic {
    
    // MARK: - VIP
    var interactor: (FieldsDataStore & FieldsBusinessLogic)?
    var router: FieldsRoutingLogic?
    
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
            sortingOptions: ["Сортировка A", "Сортировка B"],
            filteringOptions: ["Регион"]
        )
        view.delegate = self
        return view
    }()
    
    private var fields: [Fields.Load.ViewModel.GroupOfFieldsViewModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureLabel()
        configureSearchButton()
        configureFilterSortView()
        configureTableView()
        
        // Загрузка данных
        interactor?.loadFields(
            Fields.Load.Request(searchQuery: nil, degree: nil)
        )
        
        // Настройка кнопки "Назад" в NavigationController
        let backItem = UIBarButtonItem(
            title: Constants.Strings.backButtonTitle,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem = backItem
        
        // Убираем отступ между секциями в iOS 15+
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    private func configureLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.font = Constants.Fonts.titleLabelFont
        titleLabel.textColor = Constants.Colors.titleLabelTextColor
        titleLabel.text = Constants.Strings.fieldsTitle
        titleLabel.textAlignment = .center
        
        // Пример использования методов pin (см. ниже расширение)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.titleLabelTopMargin)
        titleLabel.pinLeft(to: view.leadingAnchor, Constants.Dimensions.titleLabelLeftMargin)
    }
    
    private func configureSearchButton() {
        view.addSubview(searchButton)
        
        searchButton.setHeight(Constants.Dimensions.searchButtonSize)
        searchButton.setWidth(Constants.Dimensions.searchButtonSize)
        searchButton.pinCenterY(to: titleLabel.centerYAnchor)
        searchButton.pinRight(to: view.trailingAnchor, Constants.Dimensions.searchButtonRightMargin)
        
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
    }
    
    private func configureFilterSortView() {
        view.addSubview(filterSortView)
        filterSortView.pinLeft(to: view.leadingAnchor)
        filterSortView.pinRight(to: view.trailingAnchor)
        // По умолчанию высота определяется контентом (через tableHeaderView).
        // Если нужно зафиксировать, можно добавить pinTop/pinBottom.
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableViewTopConstraint = tableView.topAnchor.constraint(
            equalTo: titleLabel.bottomAnchor,
            constant: Constants.Dimensions.tableViewTopMargin
        )
        
        NSLayoutConstraint.activate([
            tableViewTopConstraint,
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Регистрация ячейки
        tableView.register(
            FieldTableViewCell.self,
            forCellReuseIdentifier: FieldTableViewCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Constants.Colors.tableViewBackground
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        
        // Создаём header с FilterSortView
        let headerContainer = UIView()
        headerContainer.backgroundColor = .clear
        
        headerContainer.addSubview(filterSortView)
        filterSortView.pinTop(to: headerContainer.topAnchor)
        filterSortView.pinLeft(to: headerContainer.leadingAnchor)
        filterSortView.pinRight(to: headerContainer.trailingAnchor)
        filterSortView.pinBottom(to: headerContainer.bottomAnchor)
        
        // Считаем высоту header-а
        headerContainer.layoutIfNeeded()
        
        let targetSize = CGSize(
            width: tableView.bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        let height = headerContainer.systemLayoutSizeFitting(targetSize).height
        headerContainer.frame = CGRect(
            x: 0,
            y: 0,
            width: tableView.bounds.width,
            height: height
        )
        
        tableView.tableHeaderView = headerContainer
        tableView.rowHeight = UITableView.automaticDimension
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
    
    // Высота header-а для секции
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    // Высота footer-а (чтобы не было лишних отступов)
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    // Создание заголовка секции с кнопкой
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerButton = UIButton(type: .system)
        headerButton.setTitle(fields[section].name, for: .normal)
        headerButton.tag = section
        headerButton.addTarget(self, action: #selector(toggleSection), for: .touchUpInside)
        headerButton.backgroundColor = .lightGray // Для наглядности
        headerButton.setTitleColor(.black, for: .normal)
        return headerButton
    }

    @objc
    func toggleSection(sender: UIButton) {
        let section = sender.tag
        fields[section].isExpanded.toggle()
        tableView.reloadSections([section], with: .automatic)
    }
    
    // Эффект скролла с трансформацией
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        let scaleFactor = min(1.2, max(0.75, 1 - offset / 200))
        
        titleLabel.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        let maxYTranslated: CGFloat = 30
        let k = -maxYTranslated / (1 - 0.75)  // коэффициент для линейной зависимости
        let b = -k
        let YTranslated = k * scaleFactor + b
        
        let scaledWidth = titleLabel.bounds.width * (1 - scaleFactor)
        if scaleFactor <= 1 {
            // Скалируем кнопку
            searchButton.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            let searchScaledWidth = searchButton.bounds.width * (1 - scaleFactor)
            
            // Двигаем лейбл и кнопку
            titleLabel.transform = titleLabel.transform.translatedBy(x: -scaledWidth / 2, y: -YTranslated)
            searchButton.transform = searchButton.transform.translatedBy(x: searchScaledWidth, y: -YTranslated)
            
            // Двигаем таблицу
            tableViewTopConstraint.constant = Constants.Dimensions.tableViewTopMargin - YTranslated
            
            view.layoutIfNeeded()
        } else {
            // Возврат к изначальным трансформациям, если scaleFactor > 1
            searchButton.transform = .identity
            titleLabel.transform = .identity
        }
    }
}

// MARK: - FilterSortViewDelegate
extension FieldsViewController: FilterSortViewDelegate {
    
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
    
    func filterSortView(_ view: FilterSortView,
                        didTapFilterWithTitle title: String) {
        switch title {
        case "Регион":
            let items = ["Москва", "Санкт-Петербург", "Долгопрудный"]
            let sheetVC = OptionsViewController(items: items,
                                                title: "Регион",
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
