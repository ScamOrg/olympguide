//
//  UniversityViewController.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import UIKit
import SafariServices
import MessageUI
import Combine

fileprivate enum Constants {
    enum Dimensions {
        static let logoTopMargin: CGFloat = 30
        static let logoLeftMargin: CGFloat = 15
        static let logoSize: CGFloat = 80
        static let interItemSpacing: CGFloat = 20
        static let nameLabelBottomMargin: CGFloat = 20
        static let favoriteButtonSize: CGFloat = 22
        static let separatorHeight: CGFloat = 1
        static let separatorHorizontalInset: CGFloat = 20
    }
    
    enum Colors {
        static let separatorColor = UIColor(hex: "#E7E7E7")
        static let regionTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.53)
    }
    
    enum Fonts {
        static let nameLabelFont = UIFont(name: "MontserratAlternates-Medium", size: 15)!
        static let regionLabelFont = UIFont(name: "MontserratAlternates-Regular", size: 13)!
    }
}

protocol WithBookMarkButton { }

// MARK: - UniversityViewController
final class UniversityViewController: UIViewController, WithBookMarkButton {
    var interactor: (UniversityBusinessLogic & ProgramsBusinessLogic & ProgramsDataStore)?
    var router: ProgramsRoutingLogic?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let informationContainer: UIView = UIView()
    private let logoImageView: UIImageViewWithShimmer = UIImageViewWithShimmer(frame: .zero)
    private let universityID: Int
    private var startIsFavorite: Bool
    private var isFavorite: Bool
    private let nameLabel: UILabel = UILabel()
    private let regionLabel: UILabel = UILabel()
    private let logo: String
    private let webSiteButton: UIInformationButton = UIInformationButton(type: .web)
    private let emailButton: UIInformationButton = UIInformationButton(type: .email)
    private let university: UniversityModel
    private let programsLabel: UILabel = UILabel()
    private let segmentedControl: UISegmentedControl = UISegmentedControl()
    private let filterSortView: FilterSortView = FilterSortView()
    
    private var groupOfProgramsViewModel : [Programs.Load.ViewModel.GroupOfProgramsViewModel] = []
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    init(for university: UniversityModel) {
        self.logoImageView.contentMode = .scaleAspectFit
        self.logo = university.logo
        self.universityID = university.universityID
        self.isFavorite = FavoritesManager.shared.isUniversityFavorited(
            universityID: universityID,
            serverValue: university.like ?? false
        )
        self.startIsFavorite = isFavorite
        self.university = university
        
        super.init(nibName: nil, bundle: nil)
        
        self.nameLabel.text = university.name
        self.regionLabel.text = university.region
        self.title = university.shortName
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        logoImageView.startShimmer()
        webSiteButton.startShimmer()
        ImageLoader.shared.loadImage(from: logo) { [weak self] (image: UIImage?) in
            guard let self = self, let image = image else { return }
            self.logoImageView.stopShimmer()
            self.logoImageView.image = image
        }
        
        interactor?.loadUniversity(with: University.Load.Request(universityID: universityID))
        let request = Programs.Load.Request(
            params: [],
            university: university
        )
        
        setupUniversityBindings()
        setupProgramsBindings()
        interactor?.loadPrograms(with: request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController as? NavigationBarViewController else { return }
        let newImageName = isFavorite ? "bookmark.fill" :  "bookmark"
        navigationController.bookMarkButton.setImage(UIImage(systemName: newImageName), for: .normal)
        navigationController.bookMarkButtonPressed = {[weak self] sender in
            guard let self = self else { return }
            self.isFavorite.toggle()
            let newImageName = self.isFavorite ? "bookmark.fill" :  "bookmark"
            sender.setImage(UIImage(systemName: newImageName), for: .normal)
            
            if self.isFavorite {
                FavoritesManager.shared.addUniversityToFavorites(model: university)
            } else {
                FavoritesManager.shared.removeUniversityFromFavorites(universityID: self.universityID)
            }
        }
    }
}

// MARK: - UI Configuration
extension UniversityViewController {
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        configureLogoImageView()
        configureRegionLabel()
        configureNameLabel()
        configureWebSiteButton()
        configureEmailButton()
        configureProgramsLabel()
        configureSearchButton()
        configureSegmentedControl()
        
        configureRefreshControl()
        configureTableView()
        
        logoImageView.startShimmer()
        webSiteButton.startShimmer()
        emailButton.startShimmer()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let backItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    private func reloadFavoriteButton() {
        guard let navigationController = navigationController as? NavigationBarViewController else { return }
        let newImageName = isFavorite ? "bookmark.fill" :  "bookmark"
        navigationController.bookMarkButton.setImage(UIImage(systemName: newImageName), for: .normal)
    }
    
    private func configureLogoImageView() {
        informationContainer.addSubview(logoImageView)
        
        logoImageView.contentMode = .scaleAspectFit
        
        regionLabel.font = Constants.Fonts.regionLabelFont
        regionLabel.textColor = Constants.Colors.regionTextColor
        
        logoImageView.pinLeft(to: informationContainer.leadingAnchor, Constants.Dimensions.logoLeftMargin)
        logoImageView.pinTop(to: informationContainer.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.logoTopMargin)
        logoImageView.setWidth(Constants.Dimensions.logoSize)
        logoImageView.setHeight(Constants.Dimensions.logoSize)
    }
    
    private func configureRegionLabel() {
        informationContainer.addSubview(regionLabel)
        
        regionLabel.pinTop(to: informationContainer.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.logoTopMargin)
        regionLabel.pinLeft(to: logoImageView.trailingAnchor, Constants.Dimensions.interItemSpacing)
    }
    
    private func configureNameLabel() {
        informationContainer.addSubview(nameLabel)
        
        nameLabel.font = Constants.Fonts.nameLabelFont
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        nameLabel.pinTop(to: regionLabel.bottomAnchor, 5)
        nameLabel.pinLeft(to: logoImageView.trailingAnchor, Constants.Dimensions.interItemSpacing)
        nameLabel.pinRight(to: informationContainer.trailingAnchor, Constants.Dimensions.interItemSpacing)
    }
    
    private func configureWebSiteButton() {
        informationContainer.addSubview(webSiteButton)
        
        webSiteButton.pinTop(to: logoImageView.bottomAnchor, 30)
        //        webSiteButton.pinTop(to: logoImageView.bottomAnchor, 30, .grOE)
        //        webSiteButton.pinTop(to: nameLabel.bottomAnchor, 30, .grOE)
        //        webSiteButton.pinTop(to: nameLabel.bottomAnchor, 30)
        
        webSiteButton.pinLeft(to: informationContainer.leadingAnchor, 20)
        webSiteButton.pinRight(to: informationContainer.centerXAnchor)
        webSiteButton.addTarget(self, action: #selector(openWebPage), for: .touchUpInside)
    }
    
    private func configureEmailButton() {
        informationContainer.addSubview(emailButton)
        
        emailButton.pinTop(to: webSiteButton.bottomAnchor, 20)
        emailButton.pinLeft(to: informationContainer.leadingAnchor, 20)
        emailButton.pinRight(to: informationContainer.centerXAnchor)
        emailButton.addTarget(self, action: #selector(openMailCompose), for: .touchUpInside)
    }
    
    private func configureProgramsLabel() {
        let text = "Программы"
        let font = UIFont(name: "MontserratAlternates-SemiBold", size: 20)!
        programsLabel.text = text
        programsLabel.font = font
        
        informationContainer.addSubview(programsLabel)
        programsLabel.pinTop(to: emailButton.bottomAnchor, 20)
        programsLabel.pinLeft(to: informationContainer.leadingAnchor, 20)
        
        //        let textSize = text.size(withAttributes: [.font: font])
        //
        //        programsLabel.setHeight(textSize.height)
    }
    
    private func configureSegmentedControl() {
        segmentedControl.insertSegment(withTitle: "По направлениям", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "По факультетам", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        
        let customFont = UIFont(name: "MontserratAlternates-Medium", size: 15)!
        let customAttributes: [NSAttributedString.Key: Any] = [.font: customFont]
        
        segmentedControl.setTitleTextAttributes(customAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(customAttributes, for: .selected)
        
        
        informationContainer.addSubview(segmentedControl)
        
        segmentedControl.pinTop(to: programsLabel.bottomAnchor, 13)
        segmentedControl.pinLeft(to: informationContainer.leadingAnchor, 20)
        segmentedControl.pinRight(to: informationContainer.trailingAnchor, 20)
        segmentedControl.pinBottom(to: informationContainer.bottomAnchor, 17)
        segmentedControl.setHeight(35)
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private func configureSearchButton() {
        let searchButton = UIClosureButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .black
        searchButton.contentHorizontalAlignment = .fill
        searchButton.contentVerticalAlignment = .fill
        searchButton.imageView?.contentMode = .scaleAspectFit
        
        searchButton.action = { [weak self] in
            self?.router?.routeToSearch()
        }
        
        informationContainer.addSubview(searchButton)
        
        searchButton.pinRight(to: informationContainer.trailingAnchor, 20)
        searchButton.pinCenterY(to: programsLabel.centerYAnchor)
        
        searchButton.setWidth(28)
        searchButton.setHeight(28)
    }
    
    private func configureFilterSortView() {
        filterSortView.configure(filteringOptions: ["Формат обучения"])
    }
    
    func configureRefreshControl() {
        refreshControl.tintColor = .systemCyan
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        tableView.register(
            ProgramTableViewCell.self,
            forCellReuseIdentifier: ProgramTableViewCell.identifier
        )
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "ReusableHeader")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        informationContainer.setNeedsLayout()
        informationContainer.layoutIfNeeded()
        
        let targetSize = CGSize(
            width: tableView.bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        let fittingSize = informationContainer.systemLayoutSizeFitting(targetSize)
        informationContainer.frame.size.height = fittingSize.height
        tableView.tableHeaderView = informationContainer
        
        tableView.tableHeaderView = informationContainer
    }
    
    @objc func openWebPage(sender: UIButton) {
        guard let url = URL(string: "https://\(sender.currentTitle ?? "")") else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true, completion: nil)
    }
    
    @objc func segmentChanged() {
        var request = Programs.Load.Request(
            params: [],
            university: university
        )
        if segmentedControl.selectedSegmentIndex == 1 {
            request.groups = .faculties
        }
        
        interactor?.loadPrograms(with: request)
    }
}

// MARK: - UniversityDisplayLogic
extension UniversityViewController : UniversityDisplayLogic {
    func displayToggleFavoriteResult(with viewModel: University.Favorite.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: "Не удалось добавить ВУЗ в изранные" , with: viewModel.errorMessage)
        }
    }
    
    func displayLoadResult(with viewModel: University.Load.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.webSiteButton.setTitle(viewModel.site, for: .normal)
            self?.emailButton.setTitle(viewModel.email, for: .normal)
        }
    }
}

// MARK: - ProgramsDisplayLogic
extension UniversityViewController : ProgramsDisplayLogic {
    func displayLoadProgramsResult(with viewModel: Programs.Load.ViewModel) {
        groupOfProgramsViewModel = viewModel.groupsOfPrograms
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension UniversityViewController : MFMailComposeViewControllerDelegate{
    @objc func openMailCompose(sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            showAlert(
                with: "На телефоне нет настроенного клиента для отправки электронной почты",
                cancelTitle: "Ок"
            )
            return
        }
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([sender.currentTitle ?? ""])
        mailVC.setSubject("Вопрос по поступлению")
        mailVC.setMessageBody("Здравствуйте!", isHTML: false)
        
        present(mailVC, animated: true, completion: nil)
    }
    
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension UniversityViewController : UITableViewDataSource {
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProgramTableViewCell.identifier,
            for: indexPath
        ) as? ProgramTableViewCell else {
            fatalError("Could not dequeue cell")
        }
        
        let fieldViewModel = groupOfProgramsViewModel[indexPath.section].programs[indexPath.row]
        cell.configure(with: fieldViewModel)
        
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        let isLastCell = indexPath.row == totalRows - 1
        
        if isLastCell {
            cell.hideSeparator()
        }
        
        cell.favoriteButtonTapped = {[weak self] sender, isFavorite in
            guard let self = self else { return }
            self.groupOfProgramsViewModel[indexPath.section].programs[indexPath.row].like = isFavorite
            let viewModel = self.groupOfProgramsViewModel[indexPath.section].programs[indexPath.row]
            if isFavorite {
                let model = ProgramModel(
                    programID: viewModel.programID,
                    name: viewModel.name,
                    field: viewModel.code,
                    budgetPlaces: viewModel.budgetPlaces,
                    paidPlaces: viewModel.paidPlaces,
                    cost: viewModel.cost,
                    requiredSubjects: viewModel.requiredSubjects,
                    optionalSubjects: viewModel.optionalSubjects ?? [],
                    like: viewModel.like,
                    university: self.university,
                    link: nil
                )
                FavoritesManager.shared.addProgramToFavorites(viewModel: model)
            } else {
                self.groupOfProgramsViewModel[indexPath.section].programs[indexPath.row].like = false
                FavoritesManager.shared.removeProgramFromFavorites(programID: viewModel.programID)
            }
        }
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let headerButton = FieldsTableButton(name: groupOfProgramsViewModel[section].name, code: groupOfProgramsViewModel[section].code)
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
    
    @objc private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            var request = Programs.Load.Request(
                params: [],
                university: self?.university
            )
            if self?.segmentedControl.selectedSegmentIndex == 1 {
                request.groups = .faculties
            }
            
            self?.interactor?.loadPrograms(with: request)
            self?.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDelegate
extension UniversityViewController : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        router?.routeToProgram(with: indexPath)
    }
}

// MARK: - Combine
extension UniversityViewController {
    private func setupUniversityBindings() {
        FavoritesManager.shared.universityEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .added(let updatedUniversity):
                    if self.university.universityID == updatedUniversity.universityID {
                        self.isFavorite = true
                    }
                case .removed(let universityID):
                    if self.university.universityID == universityID {
                        self.isFavorite = false
                    }
                case .error(let universityID):
                    if self.university.universityID == universityID {
                        self.isFavorite = self.startIsFavorite
                    }
                case .access(let universityID, let isFavorite):
                    if self.university.universityID == universityID {
                        self.startIsFavorite = isFavorite
                    }
                }
                self.reloadFavoriteButton()
            }
            .store(in: &cancellables)
    }
    
    private func setupProgramsBindings() {
        FavoritesManager.shared.programEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .added(let program):
                    if let groupIndex = groupOfProgramsViewModel.firstIndex(where: { group in
                        group.programs.contains(where: { $0.programID == program.programID })
                    }) {
                        if let programIndex = groupOfProgramsViewModel[groupIndex].programs.firstIndex(
                            where: {
                                $0.programID == program.programID
                            }) {
                            if groupOfProgramsViewModel[groupIndex].programs[programIndex].like != true {
                                groupOfProgramsViewModel[groupIndex].programs[programIndex].like = true
                                self.tableView.reloadRows(
                                    at: [IndexPath(row: programIndex, section: groupIndex)],
                                    with: .automatic
                                )
                            }
                        }
                    }
                case .removed(let programID):
                    if let groupIndex = groupOfProgramsViewModel.firstIndex(where: { group in
                        group.programs.contains(where: { $0.programID == programID })
                    }) {
                        if let programIndex = groupOfProgramsViewModel[groupIndex].programs.firstIndex(
                            where: {
                                $0.programID == programID
                            }) {
                            if groupOfProgramsViewModel[groupIndex].programs[programIndex].like != false {
                                groupOfProgramsViewModel[groupIndex].programs[programIndex].like = false
                                self.tableView.reloadRows(
                                    at: [IndexPath(row: programIndex, section: groupIndex)],
                                    with: .automatic
                                )
                            }
                        }
                    }
                case .error(let programID):
                    if let groupIndex = groupOfProgramsViewModel.firstIndex(where: { group in
                        group.programs.contains(where: { $0.programID == programID })
                    }) {
                        if let programIndex = groupOfProgramsViewModel[groupIndex].programs.firstIndex(
                            where: {
                                $0.programID == programID
                            }) {
                            groupOfProgramsViewModel[groupIndex].programs[programIndex].like = interactor?.restoreFavorite(at: IndexPath(row: programIndex, section: groupIndex)) ?? false
                            self.tableView.reloadRows(
                                at: [IndexPath(row: programIndex, section: groupIndex)],
                                with: .automatic
                            )
                        }
                    }
                case .access(let programID, let isFavorite):
                    if let groupIndex = groupOfProgramsViewModel.firstIndex(where: { group in
                        group.programs.contains(where: { $0.programID == programID })
                    }) {
                        if let programIndex = groupOfProgramsViewModel[groupIndex].programs.firstIndex(
                            where: {
                                $0.programID == programID
                            }) {
                            
                            let indexPath = IndexPath(row: programIndex, section: groupIndex)
                            
                            interactor?.setFavorite(at: indexPath, isFavorite: isFavorite)
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}


