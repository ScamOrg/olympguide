//
//  UniversitiesViewController.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

class UniversitiesViewController: UIViewController, UniversitiesDisplayLogic {
    var interactor: (UniversitiesDataStore & UniversitiesBusinessLogic)?
    var router: UniversitiesRoutingLogic?
    
    private let tableView = UITableView()
    private let titleLabel: UILabel = UILabel()
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemCyan
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal) // Пустой значок
        button.tintColor = .black
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
        // Важно: не забудьте установить делегат
        view.delegate = self
        return view
    }()
    
    private var universities: [Universities.Load.ViewModel.UniversityViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureLabel()
        configureFilterSortView()
        configureTableView()
        interactor?.loadUniversities(
            Universities.Load.Request(regionID: nil, sortOption: nil, searchQuery: nil)
        )
    }
    
    
    
    func displayUniversities(viewModel: Universities.Load.ViewModel) {
        universities = viewModel.universities
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func displayError(message: String) {
        // Покажите сообщение об ошибке
        print("Error: \(message)")
    }
    
    private func setup() {
        let viewController = self
        let interactor = UniversitiesInteractor()
        let presenter = UniversitiesPresenter()
        let router = UniversitiesRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    private func configureLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.font =  UIFont(name: "MontserratAlternates-Bold", size: 28)
        
        titleLabel.text = "ВУЗы"
        titleLabel.textAlignment = .center
        
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 25)
        titleLabel.pinLeft(to: view.leadingAnchor, 20)
    }
    
    private func configureFilterSortView() {
        view.addSubview(filterSortView)
//        filterSortView.pinTop(to: titleLabel.bottomAnchor, 20)
        filterSortView.pinLeft(to: view.leadingAnchor, 20)
        filterSortView.pinRight(to: view.trailingAnchor)
    }
}


// MARK: - UITableViewDataSource & UITableViewDelegate
extension UniversitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    struct Constants {
        static let universityCellIdentifier = "UniversityTableViewCell"
        static let tableViewBackgroundColor: UIColor = .white
        static let shareActionTitle = "Share"
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
//        tableView.pinTop(to: titleLabel.bottomAnchor, 13)
//        tableView.pinLeft(to: view.leadingAnchor)
//        tableView.pinRight(to: view.trailingAnchor)
//        tableView.pinBottom(to: view.bottomAnchor)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13)
        
        NSLayoutConstraint.activate([
            tableViewTopConstraint,
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(UniversityTableViewCell.self,
                           forCellReuseIdentifier: Constants.universityCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Constants.tableViewBackgroundColor
        tableView.separatorStyle = .singleLine
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        
        // 1. Создаём контейнер под шапку
        let headerContainer = UIView()
        headerContainer.backgroundColor = .clear
        
        // 2. Добавляем filterSortView внутрь контейнера
        headerContainer.addSubview(filterSortView)
        // Задаём нужные констрейнты внутри контейнера
        filterSortView.pinTop(to: headerContainer.topAnchor)
        filterSortView.pinLeft(to: headerContainer.leadingAnchor, 20)
        filterSortView.pinRight(to: headerContainer.trailingAnchor, 20)
        filterSortView.pinBottom(to: headerContainer.bottomAnchor)
        
        // 3. Говорим лейауту посчитать размеры
        headerContainer.layoutIfNeeded()
        
        // 4. Считаем минимально необходимый размер
        let targetSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let height = headerContainer.systemLayoutSizeFitting(targetSize).height
        
        // 5. Задаём фрейм контейнера
        headerContainer.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: height)
        
        // 6. Присваиваем контейнер таблице как header
        tableView.tableHeaderView = headerContainer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.universityCellIdentifier,
            for: indexPath
        ) as! UniversityTableViewCell
        let universityViewModel = universities[indexPath.row]
        cell.configure(with: universityViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let universityModel = interactor?.universities[indexPath.row] else { return }
        router?.routeToDetails(for: universityModel)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
            
        let scaleFactor = min(1.2, max(0.75, 1 - offset / 200))
            
        // Применяем масштабирование к titleLabel
        titleLabel.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            
        let maxYTranslated: CGFloat = 30
        let k = -maxYTranslated / (1 - 0.75)
        let b = -k
        let YTranslated = k * scaleFactor + b
            
        let scaledWidth = titleLabel.bounds.width * (1 - scaleFactor)
        if scaleFactor <= 1 {
            // Смещаем titleLabel
            titleLabel.transform = titleLabel.transform.translatedBy(x: -scaledWidth / 2, y: -YTranslated)
                
            // Обновляем константу уже существующего ограничения
            tableViewTopConstraint.constant = 13 - YTranslated
                
            // Обновляем layout
            view.layoutIfNeeded()
        } else {
            titleLabel.transform = titleLabel.transform.translatedBy(x: -scaledWidth / 2, y: 0)
        }
    }
    
    @objc
    private func handleRefresh() {
        // Имитация загрузки данных
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.interactor?.loadUniversities(
                Universities.Load.Request(regionID: nil, sortOption: nil, searchQuery: nil)
            )
            self.refreshControl.endRefreshing() // Останавливаем анимацию
        }
    }
}

// MARK: - FilterSortViewDelegate
extension UniversitiesViewController: FilterSortViewDelegate {
    
    func filterSortViewDidTapSortButton(_ view: FilterSortView) {
        // Показываем OptionsViewController с вариантами сортировки
        let items = ["По возрастанию", "По убыванию"]
        let sheetVC = OptionsViewController(items: items,
                                            title: "Сортировка",
                                            isMultipleChoice: false) // или true
        
        sheetVC.modalPresentationStyle = .overFullScreen
        present(sheetVC, animated: false) {
            sheetVC.animateShow()
        }
    }
    
    func filterSortView(_ view: FilterSortView, didTapFilterWithTitle title: String) {
        switch title {
        case "Регион":
            // Показываем выбор уровня (как в вашем примере)
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


