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
    private var collectionView: UICollectionView!
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Constants.Colors.refreshTint
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
        configureCollectionView()
        configureRefreshControl()
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
    }
    
    // MARK: - Methods (FieldsDisplayLogic)
    func displayFields(viewModel: Fields.Load.ViewModel) {
        fields = viewModel.groupsOfFields
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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
    
    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        // Важно: именно estimatedItemSize "включает" динамическое вычисление размера,
        // а также позволяет ячейке "раскрыться" по контенту.
        // Можно поставить 50, 100 — любая примерная высота.
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        
        // Минимальные отступы между ячейками
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        // Для заголовка
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // Регистрируем ячейку
        collectionView.register(
            FieldCollectionViewCell.self,
            forCellWithReuseIdentifier: FieldCollectionViewCell.reuseId
        )
        
        // Регистрируем header (не забудьте, иначе будет ошибка)
        collectionView.register(
            FieldsCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FieldsCollectionHeaderView.reuseId
        )
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        
        // Если нужно, чтобы работал sizeForItemAt (не всегда требуется),
        // укажите делегата:
        // collectionView.delegate = self

        view.addSubview(collectionView)

        // Привязываем коллекцию ко всем краям
        collectionView.pinTop(to: view.topAnchor)
        collectionView.pinLeft(to: view.leadingAnchor)
        collectionView.pinRight(to: view.trailingAnchor)
        collectionView.pinBottom(to: view.bottomAnchor)
    }
    
    // MARK: - Actions
    @objc
    private func didTapSearchButton() {
        print(collectionView.contentOffset.y)
        //        router?.routeToSearch()
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
    var openedSections: [Int] = []

}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FieldsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fields.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        // Если секция раскрыта, возвращаем реальное число элементов
        // Если свернута, возвращаем 0
        return fields[section].isExpanded ? fields[section].fields.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FieldCollectionViewCell.reuseId,
            for: indexPath
        ) as! FieldCollectionViewCell
//        cell.setWidth(100)
        let fieldVM = fields[indexPath.section].fields[indexPath.row]
        cell.configure(with: fieldVM, width: view.bounds.width)
        return cell
    }
    
    // Заголовок секции (Header)
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: FieldsCollectionHeaderView.reuseId,
            for: indexPath
        ) as! FieldsCollectionHeaderView
        
        let group = fields[indexPath.section]
        header.configure(title: group.name,
                         code: group.code,
                         isExpanded: group.isExpanded,
                         section: indexPath.section,
                         delegate: self)
        return header
    }
}

extension FieldsViewController: FieldsCollectionHeaderViewDelegate {
    func didTapSectionHeader(section: Int) {
        // Сворачиваем/раскрываем
        fields[section].isExpanded.toggle()

        // Без анимации
        UIView.performWithoutAnimation {
            collectionView.reloadSections(IndexSet(integer: section))
            collectionView.collectionViewLayout.invalidateLayout()
        }
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
